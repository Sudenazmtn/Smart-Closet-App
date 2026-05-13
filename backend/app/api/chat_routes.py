from flask import Blueprint, request, jsonify, current_app

from app import db
from app.models.user import User
from app.models.clothing_item import ClothingItem
from app.ai.occasion_parser import parse_occasion, parse_destination_city
from app.ai.recommender import get_recommendation
from app.ai.response_builder import build_response, build_greeting, build_clarification
from app.api.weather_routes import fetch_weather

chat_bp = Blueprint('chat', __name__)


def _get_user():
    uid = request.headers.get('X-Firebase-UID')
    if not uid:
        return None, jsonify({'error': 'Unauthorized: Missing UID'}), 401
    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return None, jsonify({'error': 'User not found'}), 404
    return user, None, None


def _fetch_city_weather(city: str, api_key: str) -> dict | None:
    """OpenWeather API'den şehir adına göre hava durumu çeker."""
    try:
        import requests
        url = "https://api.openweathermap.org/data/2.5/weather"
        resp = requests.get(url, params={
            "q":     city,
            "appid": api_key,
            "units": "metric",
            "lang":  "tr",
        }, timeout=5)
        if resp.status_code != 200:
            return None
        data = resp.json()
        return {
            "temperature": round(data["main"]["temp"]),
            "description": data["weather"][0]["description"],
            "city":        data["name"],
        }
    except Exception:
        return None


@chat_bp.route('/greet', methods=['GET'])
def greet():
    return jsonify(build_greeting()), 200


@chat_bp.route('/message', methods=['POST'])
def message():
    user, err, code = _get_user()
    if err:
        return err, code

    data         = request.get_json() or {}
    user_message = data.get('message', '').strip()
    latitude     = data.get('latitude')
    longitude    = data.get('longitude')

    temperature_override = data.get('temperature')
    weather_override     = data.get('weather_desc')

    if not user_message:
        return jsonify({'error': 'Message cannot be empty'}), 400

    occasion    = parse_occasion(user_message)
    weather     = 'mild weather'
    temperature = 18
    destination_city = None

    api_key = current_app.config.get('WEATHER_API_KEY')

    city = parse_destination_city(user_message)
    if city and api_key:
        city_weather = _fetch_city_weather(city, api_key)
        if city_weather:
            temperature      = city_weather['temperature']
            weather          = city_weather['description']
            destination_city = city_weather['city']

    elif latitude and longitude:
        try:
            weather_data = fetch_weather(float(latitude), float(longitude), api_key)
            temperature  = weather_data['temperature']
            weather      = weather_data['description']
        except Exception:
            if temperature_override is not None:
                temperature = int(temperature_override)
                weather     = weather_override or 'mild weather'

    elif temperature_override is not None:
        temperature = int(temperature_override)
        weather     = weather_override or 'mild weather'

    items = ClothingItem.query.filter_by(user_id=user.id).all()
    if not items:
        return jsonify(build_clarification()), 200

    recommendation = get_recommendation(
        wardrobe   = items,
        event_type = occasion,
        weather    = weather,
        temperature= temperature,
    )

    response = build_response(
        recommendation   = recommendation,
        user_message     = user_message,
        destination_city = destination_city,
    )

    return jsonify(response), 200
