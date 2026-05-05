# app/ai/response_builder.py

import random

OPENING_TEMPLATES = {
    "casual": [
        "Here's a relaxed and stylish look for your day!",
        "Keeping it casual and comfortable — here's what I'd suggest.",
        "Perfect for a laid-back day out!",
    ],
    "formal": [
        "For a formal occasion, here's an elegant ensemble.",
        "Looking sharp! Here's a sophisticated outfit for your event.",
        "A polished look that's sure to impress.",
    ],
    "date": [
        "Perfect! For a chic {occasion_detail}, I recommend this sophisticated yet comfortable ensemble.",
        "Romance calls for the right outfit — here's my pick for your {occasion_detail}.",
        "You'll look amazing! Here's a stylish combination for your {occasion_detail}.",
    ],
    "business": [
        "A professional and confident look for your {occasion_detail}.",
        "Dressed to impress at work — here's what I'd recommend.",
        "Sharp and polished — perfect for a business setting.",
    ],
    "sport": [
        "Comfort meets style for your workout!",
        "Ready to move — here's a great athletic combination.",
        "Performance and style together — here's your look.",
    ],
    "party": [
        "Time to stand out! Here's a fun and vibrant outfit for the {occasion_detail}.",
        "Party-ready and looking great — here's my suggestion.",
        "Let's make an entrance! Here's what I'd wear.",
    ],
}

# ── Weather notes ─────────────────────────────────────────────────────────────
WEATHER_NOTES = {
    "hot":          "It's quite hot today, so I kept it light and breathable.",
    "warm":         "The weather is warm and pleasant — perfect for this look.",
    "cool":         "It's a bit cool out, so I added some layers to keep you comfortable.",
    "cold":         "Bundled up but still stylish — great for the cold weather.",
    "rainy":        "Rainy day ahead — I picked pieces that work well in wet weather.",
    "rain":         "Rainy day ahead — I picked pieces that work well in wet weather.",
    "drizzle":      "A little drizzle out there — I kept that in mind for this pick.",
    "snow":         "Snowy day — staying warm and stylish at the same time.",
    "sunny":        "Sunny day — a great excuse to wear something bright!",
    "cloudy":       "Cloudy skies today — still a great day to look good!",
    "mild":         "The mild weather gives you plenty of outfit options.",
    "clear":        "Clear skies today — perfect weather to show off a great outfit.",
    "overcast":     "A grey sky outside, but your outfit will brighten things up.",
    "thunderstorm": "Stormy weather — I picked something practical yet stylish.",
}

# ── Style tips by occasion ────────────────────────────────────────────────────
STYLE_TIPS = {
    "casual": [
        "Roll up your sleeves for a more relaxed vibe.",
        "Add a cap or sneakers to complete the casual look.",
        "Keep accessories minimal for an effortless style.",
    ],
    "formal": [
        "A classic watch will elevate this look.",
        "Make sure everything is well-ironed for a sharp finish.",
        "Subtle accessories work best with formal outfits.",
    ],
    "date": [
        "A light fragrance and minimal accessories will complete the look.",
        "Confidence is your best accessory!",
        "Keep it simple — let the outfit speak for itself.",
    ],
    "business": [
        "A structured bag will add to the professional feel.",
        "Keep accessories classic and understated.",
        "Make sure your shoes are polished!",
    ],
    "sport": [
        "Don't forget to stay hydrated!",
        "Moisture-wicking fabrics are your best friend.",
        "Comfort should always come first for workouts.",
    ],
    "party": [
        "Bold accessories can really make this outfit pop.",
        "Don't be afraid to add a statement piece.",
        "Have fun with it — it's a party!",
    ],
}

# ── Fallback responses ────────────────────────────────────────────────────────
FALLBACK_RESPONSES = [
    "Your wardrobe is a bit limited for this occasion. Try adding more items to get better suggestions!",
    "I couldn't find a perfect match in your wardrobe. Consider adding more variety!",
    "Hmm, your wardrobe needs a few more pieces for this occasion. Time to go shopping?",
]


def build_response(recommendation: dict, user_message: str) -> dict:
    """
    Converts the recommender output into a chat-style response.

    Returns:
    {
        "message":   "Perfect! For a chic coffee date...",
        "outfit":    [...],
        "score":     0.87,
        "style_tip": "Confidence is your best accessory!"
    }
    """
    if "error" in recommendation:
        return {
            "message":   random.choice(FALLBACK_RESPONSES),
            "outfit":    [],
            "score":     0,
            "style_tip": None,
        }

    occasion     = recommendation.get("event_type", "casual")
    weather_desc = recommendation.get("weather", "clear").lower()
    outfit_items = recommendation.get("outfit", [])
    score        = recommendation.get("score", 0)

    occasion_detail = _extract_occasion_detail(user_message, occasion)

    # Opening sentence
    templates = OPENING_TEMPLATES.get(occasion, OPENING_TEMPLATES["casual"])
    opening   = random.choice(templates).format(occasion_detail=occasion_detail)

    # Weather note
    weather_note = _get_weather_note(weather_desc)
    message = opening
    if weather_note:
        message += f" {weather_note}"

    # Style tip
    tips      = STYLE_TIPS.get(occasion, STYLE_TIPS["casual"])
    style_tip = random.choice(tips)

    return {
        "message":   message,
        "outfit":    outfit_items,
        "score":     score,
        "style_tip": style_tip,
    }


def build_greeting() -> dict:
    """Returns the opening message when the chat starts."""
    return {
        "message":   "Hello! What kind of occasion are you dressing for today? ✨",
        "outfit":    [],
        "score":     None,
        "style_tip": None,
    }


def build_clarification() -> dict:
    """Returns a follow-up message when the occasion is unclear or wardrobe is empty."""
    return {
        "message":   "Could you tell me a bit more about where you're heading? "
                     "For example: a coffee date, a work meeting, or a casual day out?",
        "outfit":    [],
        "score":     None,
        "style_tip": None,
    }


# ── Helpers ───────────────────────────────────────────────────────────────────

def _extract_occasion_detail(message: str, occasion: str) -> str:
    """Extracts a specific occasion label from the user's message."""
    msg = message.lower()

    detail_map = {
        "coffee date":   "coffee date",
        "dinner date":   "dinner date",
        "dinner":        "dinner",
        "lunch":         "lunch",
        "brunch":        "brunch",
        "job interview": "job interview",
        "interview":     "interview",
        "wedding":       "wedding",
        "graduation":    "graduation",
        "birthday":      "birthday party",
        "concert":       "concert",
        "gym":           "gym session",
        "hiking":        "hiking trip",
        "running":       "run",
        "yoga":          "yoga session",
    }

    for keyword, detail in detail_map.items():
        if keyword in msg:
            return detail

    defaults = {
        "casual":   "casual day",
        "formal":   "formal event",
        "date":     "date night",
        "business": "business meeting",
        "sport":    "workout",
        "party":    "party",
    }
    return defaults.get(occasion, occasion)


def _get_weather_note(weather_desc: str) -> str | None:
    """Returns a weather-related note based on the description."""
    for key, note in WEATHER_NOTES.items():
        if key in weather_desc:
            return note
    return None