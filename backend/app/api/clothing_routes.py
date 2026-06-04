from flask import Blueprint, request, jsonify, current_app
from werkzeug.utils import secure_filename
from datetime import datetime
import os
import uuid

from app import db
from app.models.user import User
from app.models.clothing_item import ClothingItem

clothing_bp = Blueprint('clothing', __name__)

ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp'}

def _allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def _get_user():
    uid = request.headers.get('X-Firebase-UID')
    if not uid:
        return None, jsonify({'error': 'X-Firebase-UID header is required'}), 401
    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return None, jsonify({'error': 'User not found'}), 404
    return user, None, None

@clothing_bp.route('/', methods=['GET'])
def get_clothes():
    user, err, code = _get_user()
    if err:
        return err, code

    query    = ClothingItem.query.filter_by(user_id=user.id)
    category = request.args.get('category')
    season   = request.args.get('season')
    color    = request.args.get('color')

    if category: query = query.filter_by(category=category)
    if season:   query = query.filter_by(season=season)
    if color:    query = query.filter_by(color=color)

    items = query.order_by(ClothingItem.created_at.desc()).all()
    return jsonify({'items': [i.to_dict() for i in items], 'count': len(items)}), 200

@clothing_bp.route('/<int:item_id>', methods=['GET'])
def get_clothing_item(item_id):
    user, err, code = _get_user()
    if err:
        return err, code

    item = ClothingItem.query.filter_by(id=item_id, user_id=user.id).first()
    if not item:
        return jsonify({'error': 'Item not found'}), 404

    return jsonify({'item': item.to_dict()}), 200

@clothing_bp.route('/', methods=['POST'])
def add_clothing():
    user, err, code = _get_user()
    if err:
        return err, code

    name     = request.form.get('name')
    category = request.form.get('category')
    color    = request.form.get('color')
    season   = request.form.get('season')

    if not all([name, category, color, season]):
        return jsonify({'error': 'name, category, color and season are required'}), 400

    image_url = None
    if 'image' in request.files:
        file = request.files['image']
        if file and file.filename and _allowed_file(file.filename):
            ext      = file.filename.rsplit('.', 1)[1].lower()
            filename = secure_filename(f'{uuid.uuid4().hex}.{ext}')
            filepath = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            image_url = f'/uploads/{filename}'

    item = ClothingItem(
        user_id=user.id,
        name=name,
        category=category,
        color=color,
        season=season,
        image_url=image_url,
    )
    db.session.add(item)
    db.session.commit()

    return jsonify({'message': 'Clothing item added successfully', 'item': item.to_dict()}), 201

@clothing_bp.route('/<int:item_id>', methods=['PUT'])
def update_clothing(item_id):
    user, err, code = _get_user()
    if err:
        return err, code

    item = ClothingItem.query.filter_by(id=item_id, user_id=user.id).first()
    if not item:
        return jsonify({'error': 'Item not found'}), 404

    data = request.get_json() or {}
    if data.get('name'):     item.name     = data['name']
    if data.get('category'): item.category = data['category']
    if data.get('color'):    item.color    = data['color']
    if data.get('season'):   item.season   = data['season']

    db.session.commit()
    return jsonify({'message': 'Updated successfully', 'item': item.to_dict()}), 200

@clothing_bp.route('/<int:item_id>', methods=['DELETE'])
def delete_clothing(item_id):
    user, err, code = _get_user()
    if err:
        return err, code

    item = ClothingItem.query.filter_by(id=item_id, user_id=user.id).first()
    if not item:
        return jsonify({'error': 'Item not found'}), 404

    if item.image_url:
        filename = item.image_url.replace('/uploads/', '')
        filepath = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
        if os.path.exists(filepath):
            os.remove(filepath)

    db.session.delete(item)
    db.session.commit()
    return jsonify({'message': 'Deleted successfully'}), 200

@clothing_bp.route('/<int:item_id>/favorite', methods=['PATCH'])
def toggle_favorite(item_id):
    user, err, code = _get_user()
    if err:
        return err, code

    item = ClothingItem.query.filter_by(id=item_id, user_id=user.id).first()
    if not item:
        return jsonify({'error': 'Item not found'}), 404

    item.is_favorite = not item.is_favorite
    db.session.commit()
    return jsonify({'item': item.to_dict()}), 200

@clothing_bp.route('/<int:item_id>/wear', methods=['POST'])
def mark_as_worn(item_id):
    user, err, code = _get_user()
    if err:
        return err, code

    item = ClothingItem.query.filter_by(id=item_id, user_id=user.id).first()
    if not item:
        return jsonify({'error': 'Item not found'}), 404

    item.wear_count += 1
    item.last_worn   = datetime.utcnow()
    db.session.commit()

    return jsonify({'message': 'Wear count updated', 'item': item.to_dict()}), 200