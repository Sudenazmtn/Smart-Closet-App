from flask import Blueprint, request, jsonify
import json

from app import db
from app.models.user import User
from app.models.outfit import Outfit
from app.models.clothing_item import ClothingItem

outfit_bp = Blueprint('outfit', __name__)

def _get_user():
    uid = request.headers.get('X-Firebase-UID')
    if not uid:
        return None, jsonify({'error': 'X-Firebase-UID header is required'}), 401
    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return None, jsonify({'error': 'User not found'}), 404
    return user, None, None

@outfit_bp.route('/', methods=['GET'])
def get_outfits():
    user, err, code = _get_user()
    if err:
        return err, code

    query = Outfit.query.filter_by(user_id=user.id)
    if request.args.get('is_favorite') == 'true':
        query = query.filter_by(is_favorite=True)

    outfits = query.order_by(Outfit.created_at.desc()).all()
    return jsonify({'outfits': [o.to_dict() for o in outfits], 'count': len(outfits)}), 200

@outfit_bp.route('/suggest', methods=['POST'])
def suggest_outfit():
    user, err, code = _get_user()
    if err:
        return err, code

    data        = request.get_json() or {}
    event_type  = data.get('event_type', 'casual')
    weather     = data.get('weather_description', 'mild weather')
    temperature = data.get('temperature', 18)

    items = ClothingItem.query.filter_by(user_id=user.id).all()
    if not items:
        return jsonify({'error': 'No clothing items found in wardrobe'}), 400

    wardrobe_text = '\n'.join([
        f'- ID:{i.id} | {i.name} | {i.category} | {i.color} | {i.season}'
        for i in items
    ])

    try:
        from app.ai.claude_client import get_outfit_suggestion
        suggestion = get_outfit_suggestion(
            wardrobe=wardrobe_text,
            event_type=event_type,
            weather=weather,
            temperature=temperature,
        )
        return jsonify({'suggestion': suggestion}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@outfit_bp.route('/save', methods=['POST'])
def save_outfit():
    user, err, code = _get_user()
    if err:
        return err, code

    data       = request.get_json() or {}
    item_ids   = data.get('item_ids', [])
    event_type = data.get('event_type')
    ai_note    = data.get('ai_note')
    name       = data.get('name')

    if not item_ids:
        return jsonify({'error': 'item_ids is required'}), 400

    items = ClothingItem.query.filter(
        ClothingItem.id.in_(item_ids),
        ClothingItem.user_id == user.id
    ).all()

    if len(items) != len(item_ids):
        return jsonify({'error': 'One or more items not found'}), 404

    outfit = Outfit(
        user_id=user.id,
        name=name,
        event_type=event_type,
        ai_note=ai_note,
        items_json=json.dumps(item_ids),
    )
    db.session.add(outfit)
    db.session.commit()

    return jsonify({'message': 'Outfit saved successfully', 'outfit': outfit.to_dict()}), 201

@outfit_bp.route('/<int:outfit_id>/favorite', methods=['PATCH'])
def toggle_favorite(outfit_id):
    user, err, code = _get_user()
    if err:
        return err, code

    outfit = Outfit.query.filter_by(id=outfit_id, user_id=user.id).first()
    if not outfit:
        return jsonify({'error': 'Outfit not found'}), 404

    outfit.is_favorite = not outfit.is_favorite
    db.session.commit()

    return jsonify({'is_favorite': outfit.is_favorite, 'outfit': outfit.to_dict()}), 200

@outfit_bp.route('/<int:outfit_id>', methods=['DELETE'])
def delete_outfit(outfit_id):
    user, err, code = _get_user()
    if err:
        return err, code

    outfit = Outfit.query.filter_by(id=outfit_id, user_id=user.id).first()
    if not outfit:
        return jsonify({'error': 'Outfit not found'}), 404

    db.session.delete(outfit)
    db.session.commit()
    return jsonify({'message': 'Outfit deleted successfully'}), 200

@outfit_bp.route('/stats', methods=['GET'])
def get_stats():
    user, err, code = _get_user()
    if err:
        return err, code

    most_worn = ClothingItem.query\
        .filter_by(user_id=user.id)\
        .filter(ClothingItem.wear_count > 0)\
        .order_by(ClothingItem.wear_count.desc())\
        .limit(5).all()

    never_worn    = ClothingItem.query.filter_by(user_id=user.id, wear_count=0).all()
    total_outfits = Outfit.query.filter_by(user_id=user.id).count()
    total_items   = ClothingItem.query.filter_by(user_id=user.id).count()

    return jsonify({
        'total_items':      total_items,
        'total_outfits':    total_outfits,
        'most_worn':        [i.to_dict() for i in most_worn],
        'never_worn':       [i.to_dict() for i in never_worn],
        'never_worn_count': len(never_worn),
    }), 200