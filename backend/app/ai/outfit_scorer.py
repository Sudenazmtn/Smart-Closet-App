COLOR_COMPATIBILITY = {
    ("white",  "black"):      1.0,
    ("white",  "navy"):       1.0,
    ("white",  "blue"):       1.0,
    ("white",  "gray"):       1.0,
    ("white",  "beige"):      0.9,
    ("white",  "red"):        0.8,
    ("white",  "green"):      0.7,
    ("black",  "gray"):       1.0,
    ("black",  "white"):      1.0,
    ("black",  "red"):        0.9,
    ("black",  "navy"):       0.7,
    ("black",  "beige"):      0.8,
    ("navy",   "white"):      1.0,
    ("navy",   "beige"):      0.9,
    ("navy",   "gray"):       0.8,
    ("navy",   "light blue"): 0.5,
    ("gray",   "white"):      1.0,
    ("gray",   "black"):      1.0,
    ("gray",   "navy"):       0.9,
    ("gray",   "blue"):       0.8,
    ("beige",  "white"):      0.9,
    ("beige",  "navy"):       0.9,
    ("beige",  "brown"):      0.8,
    ("blue",   "white"):      1.0,
    ("blue",   "gray"):       0.8,
    ("brown",  "beige"):      1.0,
    ("brown",  "white"):      0.8,
    ("brown",  "navy"):       0.7,
}

EVENT_CATEGORY_SCORE = {
     "casual": {
        "t-shirt": 1.0, "jeans": 1.0, "sneakers": 1.0,
        "hoodie": 0.9, "shorts": 0.9, "dress": 0.7,
        "blazer": 0.4, "suit": 0.0, "heels": 0.3,
    },
    "formal": {
        "shirt": 1.0, "blazer": 1.0, "suit": 1.0,
        "trousers": 1.0, "heels": 1.0, "dress": 0.8,
        "t-shirt": 0.2, "jeans": 0.3, "sneakers": 0.1,
        "hoodie": 0.0, "shorts": 0.0,
    },
    "sport": {
        "t-shirt": 1.0, "shorts": 1.0, "sneakers": 1.0,
        "leggings": 1.0, "tracksuit": 1.0, "tank top": 1.0,
        "hoodie": 0.7, "sweatpants": 0.9, "polo": 0.6,
        "jeans": 0.2, "dress": 0.1, "blazer": 0.0,
        "sweater": 0.15, "trousers": 0.1, "heels": 0.0,
        "boots": 0.15, "coat": 0.0, "shirt": 0.2,
        "loafers": 0.1, "oxfords": 0.0, "sandals": 0.2,
        "skirt": 0.1, "blouse": 0.1, "cardigan": 0.2,
    },
    "business": {
        "shirt": 1.0, "blazer": 1.0, "trousers": 1.0,
        "dress": 0.9, "heels": 0.8,
        "t-shirt": 0.4, "jeans": 0.5, "sneakers": 0.3,
    },
    "date": {
        "dress": 1.0, "heels": 0.9, "shirt": 0.8,
        "jeans": 0.7, "blazer": 0.8,
        "hoodie": 0.3, "sneakers": 0.5, "shorts": 0.4,
    },
    "party": {
        "dress": 1.0, "heels": 1.0, "skirt": 0.9,
        "blazer": 0.8, "blouse": 0.8, "boots": 0.7,
        "shirt": 0.7, "jeans": 0.6, "trousers": 0.5,
        "cardigan": 0.4, "t-shirt": 0.25, "sneakers": 0.2,
        "leggings": 0.3, "sweater": 0.2, "hoodie": 0.1,
        "shorts": 0.2, "coat": 0.1,
    },
}

def temperature_score(category: str, temperature: int) -> float:
    heavy  = {"coat", "overcoat", "puffer", "wool sweater", "heavy jacket"}
    medium = {"hoodie", "sweater", "jacket", "blazer", "cardigan", "jeans", "trousers"}
    light  = {"t-shirt", "shorts", "dress", "skirt", "tank top", "linen shirt"}
 
    category = category.lower()
 
    if temperature >= 25:
        if any(h in category for h in heavy):  return 0.0
        if any(m in category for m in medium): return 0.4
        if any(l in category for l in light):  return 1.0
    elif temperature >= 15:
        if any(h in category for h in heavy):  return 0.5
        if any(m in category for m in medium): return 1.0
        if any(l in category for l in light):  return 0.7
    elif temperature >= 5:
        if any(h in category for h in heavy):  return 1.0
        if any(m in category for m in medium): return 0.8
        if any(l in category for l in light):  return 0.2
    else:
        if any(h in category for h in heavy):  return 1.0
        if any(m in category for m in medium): return 0.5
        if any(l in category for l in light):  return 0.0
 
    return 0.5

def color_score(color1: str, color2: str) -> float:
    c1, c2 = color1.lower(), color2.lower()
    if c1 == c2:
        return 0.75
 
    score = COLOR_COMPATIBILITY.get((c1, c2)) or COLOR_COMPATIBILITY.get((c2, c1))
    return score if score is not None else 0.5

def event_score(category: str, event_type: str) -> float:
    table = EVENT_CATEGORY_SCORE.get(event_type.lower(), EVENT_CATEGORY_SCORE["casual"])
    cat   = category.lower()
 
    if cat in table:
        return table[cat]
 
    for key, val in table.items():
        if key in cat or cat in key:
            return val
 
    return 0.5  
 
 
def score_item(item, event_type: str, temperature: int) -> float:
    """Scores a single clothing item based on temperature and event suitability."""
    t_score = temperature_score(item.category, temperature)
    e_score = event_score(item.category, event_type)
    return round((t_score * 0.3) + (e_score * 0.7), 3)
 
 
def score_outfit(items: list, event_type: str, temperature: int) -> float:
    """
    Kombin skorunu hesapla.

    Önce ML modelini dener (app/ai/model/outfit_scorer.pkl).
    Model yoksa veya hata oluşursa kural tabanlı skorlamaya fallback yapar.
    """
    if not items:
        return 0.0

    individual = sum(score_item(i, event_type, temperature) for i in items) / len(items)

    color_scores = []
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            color_scores.append(color_score(items[i].color, items[j].color))

    color_avg = sum(color_scores) / len(color_scores) if color_scores else 0.5
    rule_score = (individual * 0.6) + (color_avg * 0.4)

    try:
        from app.ai.ml_scorer import score_outfit_ml
        ml_score = score_outfit_ml(items, event_type, temperature)
        if ml_score is not None:
            blended = (rule_score * 0.7) + (ml_score * 0.3)
            return round(blended, 3)
    except Exception:
        pass

    return round(rule_score, 3)


    




    



