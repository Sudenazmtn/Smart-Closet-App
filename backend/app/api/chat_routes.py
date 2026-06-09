import logging

from flask import Blueprint, request, jsonify, current_app

from app.models.user import User
from app.models.clothing_item import ClothingItem
from app.ai.occasion_parser import parse_occasion, parse_destination_city
from app.ai.outfit_scorer import get_weather_type
from app.ai.recommender import get_top_recommendations
from app.ai.response_builder import build_response, build_greeting, build_clarification

chat_bp = Blueprint('chat', __name__)
logger  = logging.getLogger(__name__)


def _get_user():
    uid = request.headers.get('X-Firebase-UID')
    if not uid:
        return None, jsonify({'error': 'Unauthorized: Missing UID'}), 401
    user = User.query.filter_by(firebase_uid=uid).first()
    if not user:
        return None, jsonify({'error': 'User not found'}), 404
    return user, None, None


def _fetch_city_weather(city: str, api_key: str) -> dict | None:
    try:
        import requests
        resp = requests.get(
            "https://api.openweathermap.org/data/2.5/weather",
            params={"q": city, "appid": api_key, "units": "metric", "lang": "tr"},
            timeout=5,
        )
        if resp.status_code != 200:
            return None
        d = resp.json()
        return {
            "temperature": round(d["main"]["temp"]),
            "feels_like":  round(d["main"]["feels_like"]),
            "description": d["weather"][0]["description"],
            "city":        d["name"],
        }
    except Exception:
        return None


def _claude_response(outfit_items, event_type, weather, temperature,
                     feels_like, weather_type, user_message,
                     destination_city, score) -> dict | None:
    if not current_app.config.get('CLAUDE_API_KEY'):
        return None
    try:
        from app.ai.claude_client import generate_outfit_response
        return generate_outfit_response(
            outfit_items     = outfit_items,
            event_type       = event_type,
            weather          = weather,
            temperature      = temperature,
            feels_like       = feels_like,
            weather_type     = weather_type,
            user_message     = user_message,
            destination_city = destination_city,
            score            = score,
        )
    except Exception as exc:
        logger.warning("Claude API hatasi, fallback: %s", exc)
        return None


@chat_bp.route('/greet', methods=['GET'])
def greet():
    return jsonify(build_greeting()), 200


@chat_bp.route('/message', methods=['POST'])
def message():
    user, err, code = _get_user()
    if err:
        return err, code

    data             = request.get_json() or {}
    user_message     = data.get('message', '').strip()
    latitude         = data.get('latitude')
    longitude        = data.get('longitude')
    t_override       = data.get('temperature')
    w_override       = data.get('weather_desc')
    fl_override      = data.get('feels_like')
    exclude_item_ids = data.get('exclude_item_ids') or []

    if not user_message:
        return jsonify({'error': 'Message cannot be empty'}), 400

    occasion         = parse_occasion(user_message)
    weather          = 'mild weather'
    temperature      = 18
    feels_like       = 18
    destination_city = None

    api_key = current_app.config.get('WEATHER_API_KEY')

    # 1️⃣  Destination city mentioned in message
    city = parse_destination_city(user_message)
    if city and api_key:
        cw = _fetch_city_weather(city, api_key)
        if cw:
            temperature      = cw['temperature']
            feels_like       = cw['feels_like']
            weather          = cw['description']
            destination_city = cw['city']
    # 2️⃣  Location coordinates from device
    elif latitude and longitude:
        try:
            from app.api.weather_routes import fetch_weather
            wd          = fetch_weather(float(latitude), float(longitude), api_key)
            temperature = wd['temperature']
            feels_like  = wd.get('feels_like', wd['temperature'])
            weather     = wd['description']
        except Exception:
            pass

    # 3️⃣  Manual overrides from client (already-cached weather)
    if t_override  is not None: temperature = int(t_override)
    if fl_override is not None: feels_like  = int(fl_override)
    elif t_override is not None: feels_like = temperature
    if w_override:              weather     = w_override

    weather_type = get_weather_type(weather)

    items = ClothingItem.query.filter_by(user_id=user.id).all()
    if not items:
        return jsonify(build_clarification()), 200

    # 4️⃣  User preferences from favorited outfits (Feature 4)
    try:
        from app.api.outfit_routes import _get_user_preferences
        preferences = _get_user_preferences(user.id)
    except Exception:
        preferences = {}

    # 5️⃣  Get 3 alternative recommendations (Feature 3)
    recommendations = get_top_recommendations(
        wardrobe         = items,
        event_type       = occasion,
        weather          = weather,
        temperature      = temperature,
        feels_like       = feels_like,
        weather_type     = weather_type,
        exclude_item_ids = exclude_item_ids,
        n                = 3,
        preferences      = preferences,
    )

    if not recommendations:
        return jsonify(build_response({"error": "no_outfit"}, user_message, destination_city)), 200

    primary      = recommendations[0]
    outfit_items = primary.get("outfit", [])
    score        = primary.get("score", 0.0)

    # Generate AI text for the primary outfit only
    ai_text = _claude_response(
        outfit_items, occasion, weather, temperature,
        feels_like, weather_type, user_message, destination_city, score,
    )

    # Build outfits list for all alternatives
    all_outfits = [rec.get("outfit", []) for rec in recommendations]

    if ai_text:
        response = {
            "message":          ai_text.get("message", ""),
            "outfit":           outfit_items,
            "outfits":          all_outfits,
            "score":            score,
            "event_type":       occasion,
            "style_tip":        ai_text.get("style_tip"),
            "destination_city": destination_city,
            "weather_type":     weather_type,
            "feels_like":       feels_like,
        }
    else:
        response = build_response(primary, user_message, destination_city)
        response["outfits"]    = all_outfits
        response["event_type"] = occasion

    return jsonify(response), 200
