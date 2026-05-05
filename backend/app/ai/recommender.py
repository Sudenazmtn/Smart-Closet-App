from itertools import product
from .outfit_scorer import score_outfit, score_item

TOP_CATEGORIES    = {"t-shirt", "shirt", "blouse", "sweater", "hoodie",
                     "blazer", "jacket", "coat", "dress", "top", "cardigan"}
BOTTOM_CATEGORIES = {"jeans", "trousers", "shorts", "skirt", "leggings", "pants"}
SHOE_CATEGORIES   = {"sneakers", "heels", "boots", "loafers", "sandals", "shoes"}


def _categorize(items: list) -> dict:
    groups = {"top": [], "bottom": [], "shoes": [], "other": []}
    for item in items:
        cat = item.category.lower()
        if any(c in cat for c in TOP_CATEGORIES):
            groups["top"].append(item)
        elif any(c in cat for c in BOTTOM_CATEGORIES):
            groups["bottom"].append(item)
        elif any(c in cat for c in SHOE_CATEGORIES):
            groups["shoes"].append(item)
        else:
            groups["other"].append(item)
    return groups


def _season_filter(items: list, temperature: int) -> list:
    if temperature >= 22:
        return [i for i in items if i.season.lower() != "winter"]
    elif temperature <= 8:
        return [i for i in items if i.season.lower() != "summer"]
    return items


def _weather_filter(items: list, weather: str) -> list:
    if "rain" in weather.lower() or "drizzle" in weather.lower():
        return [i for i in items if i.color.lower() not in {"white", "beige"}]
    return items


def get_recommendation(wardrobe: list, event_type: str,
                        weather: str, temperature: int) -> dict:
  
    if not wardrobe:
        return {"error": "Wardrobe is empty"}

    
    filtered = _season_filter(wardrobe, temperature)
    filtered = _weather_filter(filtered, weather)

    if not filtered:
        filtered = wardrobe

    
    groups  = _categorize(filtered)
    tops    = groups["top"]    or filtered
    bottoms = groups["bottom"] or []
    shoes   = groups["shoes"]  or []

    
    candidates     = []
    dresses        = [i for i in tops if "dress" in i.category.lower()]
    non_dress_tops = [i for i in tops if "dress" not in i.category.lower()]

    
    for dress in dresses:
        if shoes:
            for shoe in shoes:
                candidates.append([dress, shoe])
        else:
            candidates.append([dress])

    
    if non_dress_tops and bottoms:
        for top, bottom in product(non_dress_tops, bottoms):
            if shoes:
                for shoe in shoes:
                    candidates.append([top, bottom, shoe])
            else:
                candidates.append([top, bottom])
    elif non_dress_tops:
        for top in non_dress_tops:
            candidates.append([top])

    
    best_score  = -1.0
    best_outfit = []

    for combo in candidates:
        s = score_outfit(combo, event_type, temperature)
        if s > best_score:
            best_score  = s
            best_outfit = combo

    
    if not best_outfit:
        scored      = sorted(filtered,
                             key=lambda i: score_item(i, event_type, temperature),
                             reverse=True)
        best_outfit = scored[:3]
        best_score  = score_outfit(best_outfit, event_type, temperature)

    return {
        "outfit":      [item.to_dict() for item in best_outfit],
        "score":       best_score,
        "event_type":  event_type,
        "temperature": temperature,
        "weather":     weather,
        "note":        _generate_note(best_outfit, event_type, temperature, weather),
    }


def _generate_note(items: list, event_type: str,
                   temperature: int, weather: str) -> str:
    names = ", ".join(i.name for i in items)
    tips  = []

    if temperature >= 25:
        tips.append("Light and breathable choices for the heat.")
    elif temperature <= 8:
        tips.append("Cold weather — consider layering up.")

    if "rain" in weather.lower():
        tips.append("Watch out for the rain.")

    event_tips = {
        "formal":   "Clean and elegant for the formal occasion.",
        "sport":    "Comfortable and flexible for your workout.",
        "date":     "Stylish yet comfortable for your date.",
        "business": "Professional and polished for the workplace.",
        "casual":   "Relaxed and easy for a casual day.",
        "party":    "Fun and vibrant for the party.",
    }
    tips.append(event_tips.get(event_type.lower(), ""))

    return f"{names}. " + " ".join(t for t in tips if t)