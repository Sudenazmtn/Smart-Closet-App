
from __future__ import annotations

def get_weather_type(description: str) -> str:
    d = description.lower()
    if "thunderstorm" in d or "storm" in d:  return "storm"
    if "snow" in d or "blizzard" in d:       return "snow"
    if "rain" in d or "drizzle" in d:        return "rain"
    if "clear" in d or "sunny" in d:         return "sunny"
    if "wind" in d or "squall" in d:         return "windy"
    return "cloudy"

_COLOR_COMPAT: dict[tuple[str, str], float] = {
    ("black", "white"):     1.0,  ("black", "gray"):      1.0,
    ("black", "red"):       0.90, ("black", "burgundy"):  0.90,
    ("black", "beige"):     0.80, ("black", "blue"):      0.80,
    ("black", "pink"):      0.75, ("black", "green"):     0.75,
    ("black", "purple"):    0.80, ("black", "yellow"):    0.70,
    ("black", "orange"):    0.70, ("black", "navy"):      0.60,
    ("black", "brown"):     0.60,
    ("white", "navy"):      1.0,  ("white", "blue"):      1.0,
    ("white", "gray"):      0.95, ("white", "beige"):     0.85,
    ("white", "red"):       0.85, ("white", "burgundy"):  0.85,
    ("white", "pink"):      0.85, ("white", "green"):     0.80,
    ("white", "brown"):     0.75, ("white", "purple"):    0.80,
    ("white", "yellow"):    0.75, ("white", "orange"):    0.75,
    ("gray",  "navy"):      0.90, ("gray",  "burgundy"):  0.85,
    ("gray",  "blue"):      0.85, ("gray",  "beige"):     0.85,
    ("gray",  "brown"):     0.80, ("gray",  "pink"):      0.80,
    ("gray",  "red"):       0.80, ("gray",  "purple"):    0.80,
    ("gray",  "green"):     0.75, ("gray",  "yellow"):    0.70,
    ("gray",  "orange"):    0.70,
    ("navy",  "beige"):     1.0,  ("navy",  "burgundy"):  0.90,
    ("navy",  "red"):       0.80, ("navy",  "orange"):    0.75,
    ("navy",  "brown"):     0.75, ("navy",  "pink"):      0.75,
    ("navy",  "yellow"):    0.70, ("navy",  "green"):     0.70,
    ("navy",  "purple"):    0.65, ("navy",  "blue"):      0.55,
    ("beige", "brown"):     1.0,  ("beige", "burgundy"):  0.90,
    ("beige", "green"):     0.80, ("beige", "blue"):      0.80,
    ("beige", "red"):       0.70, ("beige", "pink"):      0.75,
    ("beige", "purple"):    0.70, ("beige", "yellow"):    0.65,
    ("beige", "orange"):    0.65,
    ("blue",  "orange"):    0.80, ("blue",  "brown"):     0.70,
    ("blue",  "burgundy"):  0.70, ("blue",  "red"):       0.65,
    ("blue",  "green"):     0.60, ("blue",  "pink"):      0.65,
    ("blue",  "purple"):    0.60, ("blue",  "yellow"):    0.70,
    ("red",   "burgundy"):  0.40, ("red",   "brown"):     0.60,
    ("red",   "green"):     0.65, ("red",   "pink"):      0.35,
    ("red",   "purple"):    0.50, ("red",   "yellow"):    0.60,
    ("red",   "orange"):    0.35,
    ("green", "brown"):     0.85, ("green", "burgundy"):  0.70,
    ("green", "orange"):    0.65, ("green", "yellow"):    0.55,
    ("green", "pink"):      0.55, ("green", "purple"):    0.55,
    ("brown", "burgundy"):  0.85, ("brown", "orange"):    0.75,
    ("brown", "yellow"):    0.70, ("brown", "red"):       0.60,
    ("brown", "blue"):      0.70, ("brown", "pink"):      0.55,
    ("brown", "purple"):    0.55,
    ("pink",  "burgundy"):  0.55, ("pink",  "purple"):    0.60,
    ("pink",  "yellow"):    0.65, ("pink",  "orange"):    0.40,
    ("purple","burgundy"):  0.60, ("purple","brown"):     0.55,
    ("purple","orange"):    0.55, ("purple","yellow"):    0.60,
    ("yellow","orange"):    0.45, ("yellow","green"):     0.55,
    ("orange","burgundy"):  0.55,
}

def color_score(c1: str, c2: str) -> float:
    if not c1 or not c2: return 0.5
    c1, c2 = c1.lower().strip(), c2.lower().strip()
    if c1 == c2: return 0.65
    return _COLOR_COMPAT.get((c1, c2)) or _COLOR_COMPAT.get((c2, c1)) or 0.5

def outfit_color_score(items: list) -> float:
    if len(items) < 2: return 0.7
    scores = [color_score(items[i].color, items[j].color)
              for i in range(len(items))
              for j in range(i + 1, len(items))]
    n = len(scores)
    return round(n / sum(1.0 / max(s, 0.01) for s in scores), 3)

_EVENT_CATEGORY: dict[str, dict[str, float]] = {
    "casual": {
        "t-shirt":1.0,"jeans":1.0,"sneakers":1.0,"hoodie":0.90,
        "shorts":0.90,"skirt":0.75,"dress":0.70,"cardigan":0.80,
        "polo":0.80,"leggings":0.80,"sandals":0.80,"tank-top":0.85,
        "sweatpants":0.70,"boots":0.70,"blouse":0.70,"sweater":0.80,
        "loafers":0.80,"blazer":0.40,"trousers":0.60,"heels":0.30,
        "oxfords":0.50,"tops":0.90,"bottoms":0.90,"outerwear":0.60,
        "shoes":0.80,"bags":0.50,
    },
    "formal": {
        "shirt":1.0,"blazer":1.0,"trousers":1.0,"heels":1.0,
        "dress":0.90,"blouse":0.90,"oxfords":1.0,"loafers":0.80,
        "cardigan":0.60,"skirt":0.80,"polo":0.60,"boots":0.60,
        "sweater":0.50,"t-shirt":0.20,"jeans":0.30,"sneakers":0.10,
        "hoodie":0.0,"shorts":0.0,"sweatpants":0.0,"sandals":0.20,
        "tank-top":0.10,"tops":0.70,"bottoms":0.80,"outerwear":0.85,
        "shoes":0.70,"bags":0.70,
    },
    "sport": {
        "t-shirt":1.0,"shorts":1.0,"sneakers":1.0,"leggings":1.0,
        "sweatpants":0.90,"tank-top":1.0,"hoodie":0.70,"polo":0.60,
        "jeans":0.20,"dress":0.10,"blazer":0.0,"sweater":0.15,
        "trousers":0.10,"heels":0.0,"boots":0.15,"shirt":0.20,
        "loafers":0.10,"oxfords":0.0,"sandals":0.20,"skirt":0.10,
        "blouse":0.10,"cardigan":0.20,"tops":0.85,"bottoms":0.85,
        "outerwear":0.40,"shoes":0.85,"bags":0.40,
    },
    "business": {
        "shirt":1.0,"blazer":1.0,"trousers":1.0,"dress":0.90,
        "heels":0.80,"blouse":0.90,"oxfords":0.90,"loafers":0.80,
        "polo":0.70,"cardigan":0.70,"sweater":0.60,"skirt":0.75,
        "boots":0.70,"t-shirt":0.40,"jeans":0.50,"sneakers":0.30,
        "hoodie":0.10,"shorts":0.0,"sweatpants":0.0,"sandals":0.30,
        "tank-top":0.20,"tops":0.75,"bottoms":0.85,"outerwear":0.90,
        "shoes":0.75,"bags":0.80,
    },
    "date": {
        "dress":1.0,"heels":0.90,"blouse":0.85,"shirt":0.80,
        "blazer":0.80,"jeans":0.70,"boots":0.75,"skirt":0.85,
        "sweater":0.70,"cardigan":0.65,"sneakers":0.55,"loafers":0.65,
        "trousers":0.75,"polo":0.55,"sandals":0.70,"oxfords":0.75,
        "t-shirt":0.40,"hoodie":0.30,"shorts":0.40,"sweatpants":0.10,
        "tank-top":0.50,"tops":0.70,"bottoms":0.70,"outerwear":0.75,
        "shoes":0.70,"bags":0.65,
    },
    "party": {
        "dress":1.0,"heels":1.0,"skirt":0.90,"blouse":0.80,
        "blazer":0.80,"boots":0.75,"shirt":0.70,"jeans":0.60,
        "trousers":0.55,"cardigan":0.40,"t-shirt":0.25,"sneakers":0.20,
        "leggings":0.30,"sweater":0.20,"hoodie":0.10,"shorts":0.20,
        "sandals":0.65,"oxfords":0.60,"loafers":0.55,"polo":0.40,
        "sweatpants":0.0,"tops":0.65,"bottoms":0.60,"outerwear":0.65,
        "shoes":0.70,"bags":0.70,
    },
}

_APP_CAT_MAP = {
    "tops":"t-shirt","bottoms":"jeans","outerwear":"blazer",
    "shoes":"sneakers","dress":"dress","bags":None,
}

def event_score(category: str, event_type: str) -> float:
    table = _EVENT_CATEGORY.get(event_type.lower(), _EVENT_CATEGORY["casual"])
    cat = category.lower().strip()
    if cat in table: return table[cat]
    mapped = _APP_CAT_MAP.get(cat)
    if mapped is None: return 0.5
    if mapped and mapped in table: return table[mapped]
    for key, val in table.items():
        if key in cat or cat in key: return val
    return 0.5

_HEAVY   = {"coat","overcoat","puffer","wool","heavy","outerwear","outer"}
_MEDIUM  = {"hoodie","sweater","jacket","blazer","cardigan",
            "jeans","trousers","bottoms","sweatpants","leggings"}
_LIGHT   = {"t-shirt","shorts","dress","skirt","tank","linen","sandals"}

_WEIGHT_TABLE = {
    "hot":    {"heavy":0.0,  "medium":0.35,"light":1.0, "neutral":0.75},
    "warm":   {"heavy":0.30, "medium":0.85,"light":0.85,"neutral":0.90},
    "mild":   {"heavy":0.60, "medium":1.0, "light":0.45,"neutral":0.80},
    "cold":   {"heavy":1.0,  "medium":0.80,"light":0.15,"neutral":0.60},
    "freeze": {"heavy":1.0,  "medium":0.50,"light":0.0, "neutral":0.40},
}

def _item_weight(category: str) -> str:
    cat = category.lower()
    if any(h in cat for h in _HEAVY):  return "heavy"
    if any(m in cat for m in _MEDIUM): return "medium"
    if any(l in cat for l in _LIGHT):  return "light"
    return "neutral"

def temperature_score(category: str, feels_like: int) -> float:
    if feels_like >= 26:   zone = "hot"
    elif feels_like >= 18: zone = "warm"
    elif feels_like >= 10: zone = "mild"
    elif feels_like >= 2:  zone = "cold"
    else:                  zone = "freeze"
    return _WEIGHT_TABLE[zone][_item_weight(category)]

_RAIN_AVOID_COLORS = {"white","beige","yellow"}
_RAIN_AVOID_SHOES  = {"sandals","heels","loafers"}
_RAIN_GOOD_SHOES   = {"boots","sneakers"}

def weather_type_score(category: str, color: str, weather_type: str) -> float:
    cat, col, wt = category.lower().strip(), color.lower().strip(), weather_type.lower()

    if wt in ("rain","storm"):
        s = 1.0
        if col in _RAIN_AVOID_COLORS:                    s -= 0.20
        if any(x in cat for x in _RAIN_AVOID_SHOES):    s -= 0.30
        if any(x in cat for x in _RAIN_GOOD_SHOES):     s += 0.10
        if cat in ("shorts","skirt"):                    s -= 0.20
        return max(0.0, min(1.0, s))

    if wt == "snow":
        s = 1.0
        if _item_weight(cat) == "light":                 s -= 0.50
        if cat in ("sandals","heels","shorts","skirt"):  s -= 0.40
        if "boots" in cat:                               s += 0.10
        return max(0.0, min(1.0, s))

    if wt == "windy":
        s = 1.0
        if cat in ("shorts","skirt","dress"):            s -= 0.20
        return max(0.0, min(1.0, s))

    return 1.0

_SEASON_RANGES = {
    "summer":(20,50),"spring":(8,22),"fall":(5,20),
    "winter":(-20,10),"all":(-20,50),
}

def season_match_score(item_season: str | None, feels_like: int, weather_type: str = "cloudy") -> float:
    season = (item_season or "all").lower().strip()
    lo, hi = _SEASON_RANGES.get(season, (-20, 50))
    if lo <= feels_like <= hi:
        return 1.0 if season != "all" else 0.85
    dist = max(lo - feels_like, feels_like - hi)
    return round(max(0.0, 1.0 - min(dist / 15.0, 1.0)), 3)

def score_item(item, event_type: str, temperature: int,
               feels_like: int | None = None, weather_type: str = "cloudy") -> float:
    fl = feels_like if feels_like is not None else temperature
    return round(
        temperature_score(item.category, fl)              * 0.25 +
        event_score(item.category, event_type)            * 0.35 +
        weather_type_score(item.category, item.color, weather_type) * 0.25 +
        season_match_score(item.season, fl, weather_type) * 0.15,
        3
    )

def score_outfit(items: list, event_type: str, temperature: int,
                 feels_like: int | None = None, weather_type: str = "cloudy") -> float:
    if not items: return 0.0
    fl = feels_like if feels_like is not None else temperature

    individual = sum(score_item(i, event_type, temperature, fl, weather_type) for i in items) / len(items)
    color_avg  = outfit_color_score(items)
    season_avg = sum(season_match_score(i.season, fl, weather_type) for i in items) / len(items)
    rule_score = individual * 0.50 + color_avg * 0.30 + season_avg * 0.20

    try:
        from app.ai.ml_scorer import score_outfit_ml
        ml = score_outfit_ml(items, event_type, temperature, fl, weather_type)
        if ml is not None:
            return round(rule_score * 0.60 + ml * 0.40, 3)
    except Exception:
        pass

    return round(rule_score, 3)
