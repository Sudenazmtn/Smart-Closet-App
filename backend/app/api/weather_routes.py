from flask import Blueprint, request, jsonify, current_app
import requests

weather_bp = Blueprint('weather', __name__)


# ── GET /weather/ ─────────────────────────────────────────────────────────────
@weather_bp.route('/', methods=['GET'])
def get_weather():
    uid = request.headers.get('X-Firebase-UID')
    if not uid:
        return jsonify({'error': 'X-Firebase-UID header is required'}), 401

    lat = request.args.get('lat')
    lon = request.args.get('lon')
    if not lat or not lon:
        return jsonify({'error': 'lat and lon are required'}), 400

    api_key = current_app.config.get('WEATHER_API_KEY')
    if not api_key:
        return jsonify({'error': 'Weather API key not configured'}), 500

    try:
        response = requests.get(
            'https://api.openweathermap.org/data/2.5/weather',
            params={'lat': lat, 'lon': lon, 'appid': api_key, 'units': 'metric', 'lang': 'en'},
            timeout=5,
        )
        response.raise_for_status()
        d = response.json()

        temperature = round(d['main']['temp'])
        description = d['weather'][0]['description'].capitalize()

        return jsonify({
            'city':        d.get('name', ''),
            'temperature': temperature,
            'feels_like':  round(d['main']['feels_like']),
            'humidity':    d['main']['humidity'],
            'description': description,
            'icon_code':   d['weather'][0]['icon'],
            'icon_url':    f"https://openweathermap.org/img/wn/{d['weather'][0]['icon']}@2x.png",
            'wind_speed':  round(d['wind']['speed']),
            'outfit_tip':  _outfit_tip(temperature, description),
        }), 200

    except requests.exceptions.Timeout:
        return jsonify({'error': 'Weather service timed out'}), 504
    except requests.exceptions.RequestException as e:
        return jsonify({'error': str(e)}), 502


def _outfit_tip(temperature: int, description: str) -> str:
    desc = description.lower()
    if 'rain' in desc or 'drizzle' in desc:
        return 'Rainy day — bring an umbrella and wear a waterproof jacket.'
    if 'snow' in desc:
        return 'Snowy day — layer up with a heavy coat, scarf and boots.'
    if 'thunderstorm' in desc:
        return 'Stormy weather — stay indoors if possible.'
    if temperature >= 28: return 'Very hot — light, breathable fabrics recommended.'
    if temperature >= 22: return 'Warm day — a t-shirt and light pants will do.'
    if temperature >= 15: return 'Mild weather — a light jacket is a good idea.'
    if temperature >= 8:  return 'Cool day — wear a medium coat or sweater.'
    if temperature >= 0:  return 'Cold day — layer up with a warm coat and scarf.'
    return 'Very cold — heavy coat, gloves and a hat are essential.'

def fetch_weather(lat: float, lon: float, api_key: str) -> dict:
    response = requests.get(
        'https://api.openweathermap.org/data/2.5/weather',
        params={'lat': lat, 'lon': lon, 'appid': api_key, 'units': 'metric', 'lang': 'en'},
        timeout=5,
    )
    response.raise_for_status()
    d = response.json()

    return {
        'temperature': round(d['main']['temp']),
        'description': d['weather'][0]['description'].capitalize(),
    }