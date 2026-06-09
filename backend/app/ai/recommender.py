
from __future__ import annotations
from itertools import product as iterproduct

from .outfit_scorer import (
    score_outfit, score_item, get_weather_type,
    season_match_score, weather_type_score,
)

TOP_CATEGORIES    = {"t-shirt","shirt","blouse","sweater","hoodie","blazer",
                     "jacket","coat","dress","top","tops","cardigan","outerwear","outer","polo","tank-top"}
BOTTOM_CATEGORIES = {"jeans","trousers","shorts","skirt","leggings",
                     "pants","bottom","bottoms","sweatpants"}
SHOE_CATEGORIES   = {"sneakers","heels","boots","loafers","sandals","shoes","oxfords"}

_MAX_CANDIDATES = 400

def _categorize(items: list) -> dict:
    groups: dict[str, list] = {"top":[],"bottom":[],"shoes":[],"other":[]}
    for item in items:
        cat = getattr(item, 'sub_category', None) or item.category
        cat = cat.lower()
        if any(c in cat for c in TOP_CATEGORIES):         groups["top"].append(item)
        elif any(c in cat for c in BOTTOM_CATEGORIES):    groups["bottom"].append(item)
        elif any(c in cat for c in SHOE_CATEGORIES):      groups["shoes"].append(item)
        else:                                             groups["other"].append(item)
    return groups

def _season_filter(items: list, feels_like: int) -> list:
    def _keep(item) -> bool:
        s = (item.season or "all").lower()
        if s == "all": return True
        if feels_like >= 23 and s == "winter": return False
        if feels_like <= 3  and s == "summer": return False
        return True
    filtered = [i for i in items if _keep(i)]
    return filtered if filtered else items

def _weather_filter(items: list, weather_type: str) -> list:
    if weather_type in ("rain","storm"):
        filtered = [i for i in items
                    if not ((getattr(i, 'sub_category', None) or i.category).lower() == "sandals"
                            and i.color.lower() in ("white","beige"))]
        return filtered if filtered else items
    if weather_type == "snow":
        filtered = [i for i in items
                    if (getattr(i, 'sub_category', None) or i.category).lower() not in ("sandals","shorts")]
        return filtered if filtered else items
    return items

def _pre_sort(items: list, event_type: str, temperature: int,
              feels_like: int, weather_type: str) -> list:
    return sorted(items,
                  key=lambda i: score_item(i, event_type, temperature, feels_like, weather_type),
                  reverse=True)

def get_recommendation(
    wardrobe:         list,
    event_type:       str,
    weather:          str,
    temperature:      int,
    feels_like:       int | None       = None,
    weather_type:     str | None       = None,
    exclude_item_ids: list[int] | None = None,
) -> dict:
    if not wardrobe:
        return {"error": "Wardrobe is empty"}

    fl  = feels_like   if feels_like   is not None else temperature
    wt  = weather_type if weather_type is not None else get_weather_type(weather)
    excl = set(exclude_item_ids or [])

    filtered = _season_filter(wardrobe, fl)
    filtered = _weather_filter(filtered, wt)

    groups  = _categorize(filtered)
    tops    = _pre_sort(groups["top"]    or filtered, event_type, temperature, fl, wt)[:12]
    bottoms = _pre_sort(groups["bottom"] or [],        event_type, temperature, fl, wt)[:10]
    shoes   = _pre_sort(groups["shoes"]  or [],        event_type, temperature, fl, wt)[:8]

    candidates: list[list] = []
    dresses        = [i for i in tops if "dress" in (getattr(i, 'sub_category', None) or i.category).lower()]
    non_dress_tops = [i for i in tops if "dress" not in (getattr(i, 'sub_category', None) or i.category).lower()]

    for dress in dresses:
        if len(candidates) >= _MAX_CANDIDATES: break
        if shoes:
            for shoe in shoes:
                candidates.append([dress, shoe])
                if len(candidates) >= _MAX_CANDIDATES: break
        else:
            candidates.append([dress])

    if non_dress_tops and bottoms:
        for top, bottom in iterproduct(non_dress_tops, bottoms):
            if shoes:
                for shoe in shoes:
                    candidates.append([top, bottom, shoe])
                    if len(candidates) >= _MAX_CANDIDATES: break
            else:
                candidates.append([top, bottom])
            if len(candidates) >= _MAX_CANDIDATES: break
    elif non_dress_tops:
        candidates += [[t] for t in non_dress_tops]

    scored_candidates = []
    for combo in candidates:
        s = score_outfit(combo, event_type, temperature, fl, wt)
        scored_candidates.append((s, combo))
    scored_candidates.sort(key=lambda x: -x[0])

    best_score  = -1.0
    best_outfit: list = []

    for s, combo in scored_candidates:
        combo_ids = {item.id for item in combo}
        if excl and combo_ids.issubset(excl):
            continue
        best_score  = s
        best_outfit = combo
        break

    if not best_outfit and scored_candidates:
        best_score, best_outfit = scored_candidates[0]

    if not best_outfit:
        scored      = _pre_sort(filtered, event_type, temperature, fl, wt)
        best_outfit = scored[:3]
        best_score  = score_outfit(best_outfit, event_type, temperature, fl, wt)

    return {
        "outfit":       [item.to_dict() for item in best_outfit],
        "score":        round(best_score, 3),
        "event_type":   event_type,
        "temperature":  temperature,
        "feels_like":   fl,
        "weather":      weather,
        "weather_type": wt,
        "note":         _generate_note(best_outfit, event_type, fl, wt),
    }


def get_top_recommendations(
    wardrobe:         list,
    event_type:       str,
    weather:          str,
    temperature:      int,
    feels_like:       int | None       = None,
    weather_type:     str | None       = None,
    exclude_item_ids: list[int] | None = None,
    n:                int               = 3,
    preferences:      dict | None       = None,
) -> list[dict]:
    """Return n non-overlapping outfit recommendations ordered by score."""
    if not wardrobe:
        return []

    results:     list[dict] = []
    seen_ids:    set[int]   = set(exclude_item_ids or [])

    for _ in range(n):
        rec = get_recommendation(
            wardrobe         = wardrobe,
            event_type       = event_type,
            weather          = weather,
            temperature      = temperature,
            feels_like       = feels_like,
            weather_type     = weather_type,
            exclude_item_ids = list(seen_ids),
        )
        if "error" in rec or not rec.get("outfit"):
            break

        results.append(rec)
        # Exclude items used in this outfit so the next one is different
        for item in rec["outfit"]:
            seen_ids.add(item["id"])

    return results

_TEMP_TIPS = {
    "freeze": "Dondurucu soguk — kalin katmanlar zorunlu.",
    "cold":   "Soguk hava — kalin bir mont tercih edildi.",
    "mild":   "Iliman hava icin dengeli bir kombin.",
    "warm":   "Sicak hava — hafif parcalar one cikti.",
    "hot":    "Cok sicak — en ince secenekler secildi.",
}
_WEATHER_TIPS = {
    "rain":"Yagmurlu hava — koyu renkler ve bot one cikti.",
    "storm":"Firtinali hava — pratik ve dayanikli parcalar.",
    "snow":"Karli hava — sicak tutan parcalar onceliklendi.",
    "windy":"Ruzgarli hava — etek ve elbiseden kacinildi.",
    "sunny":"Gunes var — aydinlik ve hafif bir kombin.",
    "cloudy":"",
}
_EVENT_TIPS = {
    "formal":"Resmi etkinlik icin zarif ve sik.",
    "sport":"Spor icin konforlu ve esnek.",
    "date":"Randevu icin hem sik hem rahat.",
    "business":"Is ortami icin profesyonel ve bakimli.",
    "casual":"Gunluk kullanim icin rahat ve zahmetsiz.",
    "party":"Parti icin eglenceli ve cesur.",
}

def _generate_note(items: list, event_type: str, feels_like: int, weather_type: str) -> str:
    names = ", ".join(i.name for i in items)
    if feels_like >= 26:   tk = "hot"
    elif feels_like >= 18: tk = "warm"
    elif feels_like >= 10: tk = "mild"
    elif feels_like >= 2:  tk = "cold"
    else:                  tk = "freeze"
    parts = [_TEMP_TIPS.get(tk,""), _WEATHER_TIPS.get(weather_type,""),
             _EVENT_TIPS.get(event_type.lower(),"")]
    return f"{names}. {' '.join(p for p in parts if p)}".strip()
