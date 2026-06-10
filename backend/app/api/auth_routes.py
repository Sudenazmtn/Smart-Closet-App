import os
import time

from flask import Blueprint, request, jsonify, current_app
from werkzeug.utils import secure_filename

from app import db
from app.models.user import User

auth_bp = Blueprint('auth', __name__)

ALLOWED_PHOTO_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp'}

def _get_uid():
    return request.headers.get('X-Firebase-UID')

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data provided'}), 400

    firebase_uid = data.get('firebase_uid')
    name         = data.get('name')
    email        = data.get('email')

    if not all([firebase_uid, name, email]):
        return jsonify({'error': 'firebase_uid, name and email are required'}), 400

    existing = User.query.filter_by(firebase_uid=firebase_uid).first()
    if existing:
        return jsonify({'message': 'User already exists', 'user': existing.to_dict()}), 200

    if User.query.filter_by(email=email).first():
        return jsonify({'error': 'Email already in use'}), 409

    user = User(firebase_uid=firebase_uid, name=name, email=email)
    db.session.add(user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully', 'user': user.to_dict()}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data or not data.get('firebase_uid'):
        return jsonify({'error': 'firebase_uid is required'}), 400

    user = User.query.filter_by(firebase_uid=data['firebase_uid']).first()

    if not user:
        if not data.get('email') or not data.get('name'):
            return jsonify({'error': 'email and name are required for new users'}), 400
        user = User(
            firebase_uid=data['firebase_uid'],
            name=data['name'],
            email=data['email'],
        )
        db.session.add(user)
        db.session.commit()

    return jsonify({'message': 'Login successful', 'user': user.to_dict()}), 200

@auth_bp.route('/me', methods=['GET'])
def me():
    uid = _get_uid()
    if not uid:
        return jsonify({'error': 'X-Firebase-UID header is required'}), 401

    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return jsonify({'error': 'User not found'}), 404

    return jsonify({'user': user.to_dict()}), 200

@auth_bp.route('/profile-photo', methods=['POST'])
def upload_profile_photo():
    uid = _get_uid()
    if not uid:
        return jsonify({'error': 'X-Firebase-UID header is required'}), 401

    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return jsonify({'error': 'User not found'}), 404

    if 'image' not in request.files:
        return jsonify({'error': 'image file is required'}), 400

    file = request.files['image']
    if not file or not file.filename or '.' not in file.filename:
        return jsonify({'error': 'Invalid file'}), 400

    ext = file.filename.rsplit('.', 1)[1].lower()
    if ext not in ALLOWED_PHOTO_EXTENSIONS:
        return jsonify({'error': 'File type not allowed'}), 400

    upload_folder = current_app.config['UPLOAD_FOLDER']

    # Remove previous profile photo regardless of its extension
    for old_ext in ALLOWED_PHOTO_EXTENSIONS:
        old_path = os.path.join(upload_folder, f'profile_{user.id}.{old_ext}')
        if os.path.exists(old_path):
            os.remove(old_path)

    filename = secure_filename(f'profile_{user.id}.{ext}')
    file.save(os.path.join(upload_folder, filename))

    # Cache-buster query param so clients refresh the image after re-upload
    image_url = f'/uploads/{filename}?v={int(time.time())}'
    return jsonify({'message': 'Profile photo updated', 'image_url': image_url}), 200

@auth_bp.route('/delete', methods=['DELETE'])
def delete_account():
    uid = _get_uid()
    if not uid:
        return jsonify({'error': 'X-Firebase-UID header is required'}), 401

    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return jsonify({'error': 'User not found'}), 404

    db.session.delete(user)
    db.session.commit()

    return jsonify({'message': 'Account deleted successfully'}), 200