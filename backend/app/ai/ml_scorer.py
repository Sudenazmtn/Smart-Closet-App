
from __future__ import annotations
import os

_MODEL_PATH      = os.path.join(os.path.dirname(__file__), "model", "outfit_scorer.pkl")
_pipeline        = None
_model_available: bool | None = None

def _load_model() -> bool:
    global _pipeline, _model_available
    if _model_available is not None:
        return _model_available
    try:
        import joblib
        if not os.path.exists(_MODEL_PATH):
            _model_available = False
            return False
        _pipeline        = joblib.load(_MODEL_PATH)
        _model_available = True
        return True
    except Exception:
        _model_available = False
        return False

_COLOR_NORM: dict[str, str] = {
    "siyah":"black","beyaz":"white","gri":"gray","lacivert":"navy",
    "bej":"beige","kirmizi":"red","mavi":"blue","yesil":"green",
    "kahverengi":"brown","pembe":"pink","sari":"yellow","bordo":"burgundy",
    "mor":"purple","turuncu":"orange",
}
_CAT_NORM: dict[str, str] = {
    "tisort":"t-shirt","tshirt":"t-shirt","t shirt":"t-shirt",
    "gomlek":"shirt","bluz":"blouse","kazak":"sweater",
    "sweatshirt":"hoodie","ceket":"blazer","elbise":"dress",
    "hirka":"cardigan","atlet":"tank-top",
    "kot":"jeans","pantolon":"trousers","sort":"shorts",
    "etek":"skirt","tayt":"leggings","esofman":"sweatpants",
    "spor ayakkabi":"sneakers","topuklu":"heels","bot":"boots",
    "loafer":"loafers","sandalet":"sandals","oxford":"oxfords",
    "tops":"t-shirt","bottoms":"jeans","outerwear":"blazer",
    "shoes":"sneakers","bags":"none","dress":"dress",
}
_WEATHER_NORM: dict[str, str] = {
    "rain":"rain","drizzle":"rain","yagmur":"rain",
    "snow":"snow","kar":"snow",
    "storm":"storm","thunderstorm":"storm","firtina":"storm",
    "sunny":"sunny","clear":"sunny","gunes":"sunny",
    "windy":"windy","ruzgar":"windy",
    "cloudy":"cloudy","bulut":"cloudy",
}

def _nc(v: str, m: dict) -> str:
    return m.get(v.lower().strip(), v.lower().strip())

def _find_item(items: list, categories: set):
    for item in items:
        if _nc(item.category, _CAT_NORM) in categories:
            return item
    return None

def score_outfit_ml(
    items:        list,
    event_type:   str,
    temperature:  int,
    feels_like:   int | None = None,
    weather_type: str        = "cloudy",
) -> float | None:
    if not _load_model():
        return None

    fl = feels_like if feels_like is not None else temperature
    wt = _nc(weather_type, _WEATHER_NORM)

    top    = _find_item(items, {"t-shirt","shirt","blouse","sweater","hoodie",
                                "blazer","dress","cardigan","tank-top","polo","tops","outerwear"})
    bottom = _find_item(items, {"jeans","trousers","shorts","skirt",
                                "leggings","sweatpants","bottoms"})
    shoes  = _find_item(items, {"sneakers","heels","boots","loafers",
                                "sandals","oxfords","shoes"})

    if top is None:
        return None

    top_cat   = _nc(top.category, _CAT_NORM)
    top_color = _nc(top.color,    _COLOR_NORM)

    if top_cat == "dress":
        bot_cat, bot_color = "none", "none"
    elif bottom:
        bot_cat   = _nc(bottom.category, _CAT_NORM)
        bot_color = _nc(bottom.color,    _COLOR_NORM)
    else:
        bot_cat, bot_color = "none", "none"

    if shoes:
        shoe_cat   = _nc(shoes.category, _CAT_NORM)
        shoe_color = _nc(shoes.color,    _COLOR_NORM)
    else:
        shoe_cat, shoe_color = "none", "none"

    from app.ai.outfit_scorer import season_match_score
    season_avg = sum(season_match_score(i.season, fl, wt) for i in items) / max(len(items), 1)

    try:
        import pandas as pd
        X = pd.DataFrame([{
            "top":          top_cat,
            "top_color":    top_color,
            "bottom":       bot_cat,
            "bottom_color": bot_color,
            "shoes":        shoe_cat,
            "shoes_color":  shoe_color,
            "occasion":     event_type.lower(),
            "weather_type": wt,
            "temperature":  temperature,
            "feels_like":   fl,
            "season_match": round(season_avg, 3),
        }])
        val = float(_pipeline.predict(X)[0])
        return round(min(1.0, max(0.0, val)), 4)
    except Exception:
        return None

def is_model_available() -> bool:
    return _load_model()
