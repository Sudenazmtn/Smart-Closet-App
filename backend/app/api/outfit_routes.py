from flask import Blueprint, request, jsonify
import json

from app import db
from app.models.user import User
from app.models.outfit import Outfit
from app.models.clothing_item import ClothingItem

outfit_bp = Blueprint('outfit', __name__)

# ─── Wardrobe category sets ────────────────────────────────────────────────────
_TOP_CATS    = {'tops', 't-shirt', 'shirt', 'blouse', 'sweater', 'hoodie',
                'blazer', 'jacket', 'coat', 'dress', 'cardigan', 'tank-top',
                'polo', 'outerwear', 'vest', 'trench_coat'}
_BOTTOM_CATS = {'bottoms', 'jeans', 'trousers', 'shorts', 'skirt',
                'leggings', 'sweatpants'}
_SHOE_CATS   = {'shoes', 'sneakers', 'heels', 'boots', 'loafers',
                'sandals', 'oxfords'}
_OUTER_CATS  = {'outerwear', 'jacket', 'coat', 'blazer', 'vest', 'trench_coat'}
_SPORT_SHOES = {'sneakers'}
_FORMAL_TOPS = {'shirt', 'blouse', 'blazer'}
_CASUAL_TOPS = {'t-shirt', 'hoodie', 'tank-top', 'polo', 'sweater', 'cardigan'}


def _all_cats(user_id: int) -> set:
    items = ClothingItem.query.filter_by(user_id=user_id).all()
    cats: set = set()
    for item in items:
        cats.add(item.category.lower().strip())
        if item.sub_category:
            cats.add(item.sub_category.lower().strip())
    return cats, len(items)


def _wardrobe_suggestions(user_id: int) -> list:
    """Analyze the wardrobe and return a list of improvement suggestions."""
    all_cats, item_count = _all_cats(user_id)

    if item_count == 0:
        return [{'key': 'empty_wardrobe', 'emoji': '👗'}]

    suggestions = []

    has_tops    = bool(all_cats & _TOP_CATS)
    has_bottoms = bool(all_cats & _BOTTOM_CATS)
    has_shoes   = bool(all_cats & _SHOE_CATS)
    has_outer   = bool(all_cats & _OUTER_CATS)

    # Missing main categories
    if not has_tops:
        suggestions.append({'key': 'missing_tops', 'emoji': '👚'})
    if not has_bottoms:
        suggestions.append({'key': 'missing_bottoms', 'emoji': '👖'})
    if not has_shoes:
        suggestions.append({'key': 'missing_shoes', 'emoji': '👠'})
    if not has_outer:
        suggestions.append({'key': 'missing_outerwear', 'emoji': '🧥'})

    # Sub-category gaps
    if has_shoes and not (all_cats & _SPORT_SHOES):
        suggestions.append({'key': 'missing_sneakers', 'emoji': '👟'})
    if has_tops and not (all_cats & _FORMAL_TOPS):
        suggestions.append({'key': 'missing_formal_top', 'emoji': '👔'})
    if has_tops and not (all_cats & _CASUAL_TOPS):
        suggestions.append({'key': 'missing_casual_top', 'emoji': '👕'})

    # Low variety
    if item_count < 8 and not suggestions:
        suggestions.append({'key': 'low_variety', 'emoji': '📦'})

    return suggestions[:4]   # max 4 suggestions at a time


# ─── Helpers ───────────────────────────────────────────────────────────────────

def _get_user():
    uid = request.headers.get('X-Firebase-UID')
    if not uid:
        return None, jsonify({'error': 'X-Firebase-UID header is required'}), 401
    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return None, jsonify({'error': 'User not found'}), 404
    return user, None, None


def _get_user_preferences(user_id: int) -> dict:
    """Analyze favorited outfits to learn user style preferences."""
    favorites = Outfit.query.filter_by(user_id=user_id, is_favorite=True).all()
    if not favorites:
        return {}

    event_counts:   dict = {}
    color_counts:   dict = {}
    sub_cat_counts: dict = {}

    for outfit in favorites:
        if outfit.event_type:
            event_counts[outfit.event_type] = event_counts.get(outfit.event_type, 0) + 1

        item_ids = json.loads(outfit.items_json) if outfit.items_json else []
        items    = ClothingItem.query.filter(ClothingItem.id.in_(item_ids)).all()
        for item in items:
            if item.color:
                c = item.color.lower()
                color_counts[c] = color_counts.get(c, 0) + 1
            sub = (item.sub_category or item.category).lower()
            sub_cat_counts[sub] = sub_cat_counts.get(sub, 0) + 1

    return {
        'preferred_event':    max(event_counts,   key=event_counts.get)                  if event_counts   else None,
        'preferred_colors':   sorted(color_counts,   key=color_counts.get,   reverse=True)[:3],
        'preferred_sub_cats': sorted(sub_cat_counts, key=sub_cat_counts.get, reverse=True)[:5],
        'total_favorites':    len(favorites),
    }


# ─── Routes ────────────────────────────────────────────────────────────────────

@outfit_bp.route('/', methods=['GET'])
def get_outfits():
    user, err, code = _get_user()
    if err:
        return err, code

    query = Outfit.query.filter_by(user_id=user.id)
    if request.args.get('is_favorite') == 'true':
        query = query.filter_by(is_favorite=True)

    include_items = request.args.get('include_items') == 'true'
    outfits = query.order_by(Outfit.created_at.desc()).all()

    def _outfit_dict(o):
        d = o.to_dict()
        if include_items:
            item_ids  = json.loads(o.items_json) if o.items_json else []
            db_items  = ClothingItem.query.filter(
                ClothingItem.id.in_(item_ids),
                ClothingItem.user_id == user.id,
            ).all()
            # preserve original order
            item_map  = {i.id: i for i in db_items}
            d['items_data'] = [item_map[iid].to_dict()
                               for iid in item_ids if iid in item_map]
        return d

    return jsonify({'outfits': [_outfit_dict(o) for o in outfits],
                    'count':   len(outfits)}), 200


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
        user_id    = user.id,
        name       = name,
        event_type = event_type,
        ai_note    = ai_note,
        items_json = json.dumps(item_ids),
    )
    db.session.add(outfit)
    db.session.commit()

    return jsonify({'message': 'Outfit saved successfully',
                    'outfit':  outfit.to_dict()}), 201


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

    return jsonify({'is_favorite': outfit.is_favorite,
                    'outfit':      outfit.to_dict()}), 200


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

    # Recent saved outfits with full item details (last 5)
    recent_outfits = Outfit.query\
        .filter_by(user_id=user.id)\
        .order_by(Outfit.created_at.desc())\
        .limit(5).all()

    def _with_items(o):
        d = o.to_dict()
        item_ids = json.loads(o.items_json) if o.items_json else []
        db_items = ClothingItem.query.filter(
            ClothingItem.id.in_(item_ids),
            ClothingItem.user_id == user.id,
        ).all()
        item_map     = {i.id: i for i in db_items}
        d['items_data'] = [item_map[iid].to_dict()
                           for iid in item_ids if iid in item_map]
        return d

    return jsonify({
        'total_items':         total_items,
        'total_outfits':       total_outfits,
        'most_worn':           [i.to_dict() for i in most_worn],
        'never_worn':          [i.to_dict() for i in never_worn],
        'never_worn_count':    len(never_worn),
        'recent_outfits':      [_with_items(o) for o in recent_outfits],
        'wardrobe_suggestions': _wardrobe_suggestions(user.id),
    }), 200
