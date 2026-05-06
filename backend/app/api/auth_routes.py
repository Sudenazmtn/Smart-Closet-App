from flask import Blueprint, request, jsonify
from app import db
from app.models.user import User

auth_bp = Blueprint('auth', __name__)


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