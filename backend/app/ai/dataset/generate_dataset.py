"""
generate_dataset.py
-------------------
Kombin veri seti üretici.

Fashion domain bilgisini kullanarak ~700 etiketli örnek üretir ve
outfit_data.csv dosyasına kaydeder.

Her satır bir 3-parçalı kombini (üst + alt + ayakkabı) temsil eder.
Hedef (score): 0.0 – 1.0 arasında bir float.

Çalıştır:
    cd backend
    python -m app.ai.dataset.generate_dataset
"""

import random
import numpy as np
import pandas as pd
import os

random.seed(42)
np.random.seed(42)

TOPS = [
    "t-shirt", "shirt", "blouse", "sweater", "hoodie",
    "blazer", "dress", "cardigan", "tank-top", "polo",
]
BOTTOMS = [
    "jeans", "trousers", "shorts", "skirt", "leggings", "sweatpants",
]
SHOES = [
    "sneakers", "heels", "boots", "loafers", "sandals", "oxfords",
]
COLORS = [
    "white", "black", "navy", "gray", "beige",
    "blue", "red", "green", "brown", "pink",
    "yellow", "burgundy", "olive",
]
OCCASIONS    = ["casual", "formal", "date", "business", "sport", "party"]
TEMPERATURES = [5, 10, 15, 20, 25, 30]


EVENT_CAT_SCORE: dict[str, dict[str, float]] = {
    "casual": {
        "t-shirt": 1.0,  "jeans": 1.0,    "sneakers": 1.0,
        "hoodie":  0.90, "shorts": 0.90,  "skirt": 0.75,
        "dress":   0.70, "cardigan": 0.80,"polo": 0.80,
        "leggings":0.80, "sandals": 0.80, "tank-top": 0.85,
        "sweatpants":0.70,"boots": 0.70,  "blouse": 0.70,
        "sweater": 0.80, "loafers": 0.80, "blazer": 0.40,
        "trousers":0.60, "heels": 0.30,  "oxfords": 0.50,
    },
    "formal": {
        "shirt":   1.0,  "blazer": 1.0,   "trousers": 1.0,
        "heels":   1.0,  "dress": 0.90,   "blouse": 0.90,
        "oxfords": 1.0,  "loafers": 0.80, "cardigan": 0.60,
        "skirt":   0.80, "polo": 0.60,    "boots": 0.60,
        "sweater": 0.50, "t-shirt": 0.20, "jeans": 0.30,
        "sneakers":0.10, "hoodie": 0.0,   "shorts": 0.0,
        "tank-top":0.10, "sweatpants":0.0,"leggings": 0.20,
        "sandals": 0.30,
    },
    "date": {
        "dress":   1.0,  "heels": 0.90,   "blouse": 0.90,
        "skirt":   0.85, "shirt": 0.80,   "blazer": 0.80,
        "trousers":0.70, "oxfords": 0.70, "jeans": 0.70,
        "boots":   0.70, "cardigan": 0.70,"polo": 0.60,
        "sneakers":0.50, "shorts": 0.40,  "sandals": 0.60,
        "sweater": 0.60, "hoodie": 0.30,  "leggings": 0.40,
        "t-shirt": 0.50, "tank-top": 0.50,"sweatpants": 0.10,
    },
    "business": {
        "shirt":   1.0,  "blazer": 1.0,   "trousers": 1.0,
        "heels":   0.80, "blouse": 0.90,  "dress": 0.90,
        "oxfords": 0.90, "loafers": 0.80, "polo": 0.70,
        "cardigan":0.60, "skirt": 0.70,   "boots": 0.60,
        "sweater": 0.50, "jeans": 0.50,   "t-shirt": 0.40,
        "sneakers":0.30, "shorts": 0.10,  "hoodie": 0.10,
        "tank-top":0.20, "sweatpants":0.0,"leggings": 0.30,
    },
    "sport": {
        "t-shirt": 1.0,  "shorts": 1.0,   "sneakers": 1.0,
        "leggings":1.0,  "tank-top": 1.0, "sweatpants": 0.90,
        "hoodie":  0.80, "sandals": 0.30, "jeans": 0.30,
        "dress":   0.20, "blazer": 0.0,   "trousers": 0.20,
        "heels":   0.0,  "skirt": 0.30,   "shirt": 0.40,
        "oxfords": 0.0,  "boots": 0.20,   "cardigan": 0.30,
        "polo":    0.50, "blouse": 0.30,  "sweater": 0.40,
    },
    "party": {
        "dress":   1.0,  "heels": 1.0,    "blouse": 0.80,
        "blazer":  0.80, "shirt": 0.70,   "skirt": 0.90,
        "jeans":   0.60, "boots": 0.70,   "oxfords": 0.60,
        "tank-top":0.60, "cardigan": 0.50,"sneakers": 0.40,
        "hoodie":  0.10, "shorts": 0.30,  "sweatpants": 0.0,
        "trousers":0.60, "sandals": 0.50, "polo": 0.50,
        "t-shirt": 0.40, "sweater": 0.50, "leggings": 0.30,
    },
}


COLOR_COMPAT: dict[tuple, float] = {
    ("white",    "black"):     1.00,
    ("white",    "navy"):      1.00,
    ("white",    "blue"):      0.90,
    ("white",    "gray"):      0.90,
    ("white",    "beige"):     0.85,
    ("white",    "red"):       0.80,
    ("white",    "green"):     0.70,
    ("white",    "brown"):     0.70,
    ("white",    "olive"):     0.70,
    ("white",    "burgundy"):  0.80,
    ("black",    "gray"):      1.00,
    ("black",    "white"):     1.00,
    ("black",    "red"):       0.85,
    ("black",    "navy"):      0.70,
    ("black",    "beige"):     0.80,
    ("black",    "burgundy"):  0.90,
    ("black",    "olive"):     0.75,
    ("black",    "pink"):      0.70,
    ("black",    "yellow"):    0.65,
    ("black",    "brown"):     0.70,
    ("navy",     "white"):     1.00,
    ("navy",     "beige"):     0.90,
    ("navy",     "gray"):      0.85,
    ("navy",     "burgundy"):  0.85,
    ("navy",     "olive"):     0.75,
    ("navy",     "red"):       0.70,
    ("navy",     "brown"):     0.70,
    ("gray",     "white"):     1.00,
    ("gray",     "black"):     1.00,
    ("gray",     "navy"):      0.90,
    ("gray",     "blue"):      0.80,
    ("gray",     "burgundy"):  0.80,
    ("gray",     "pink"):      0.75,
    ("gray",     "beige"):     0.80,
    ("beige",    "white"):     0.90,
    ("beige",    "navy"):      0.90,
    ("beige",    "brown"):     0.85,
    ("beige",    "olive"):     0.85,
    ("beige",    "burgundy"):  0.80,
    ("beige",    "gray"):      0.80,
    ("blue",     "white"):     0.90,
    ("blue",     "gray"):      0.80,
    ("blue",     "beige"):     0.80,
    ("blue",     "navy"):      0.50,
    ("brown",    "beige"):     1.00,
    ("brown",    "white"):     0.80,
    ("brown",    "navy"):      0.75,
    ("brown",    "olive"):     0.85,
    ("brown",    "gray"):      0.75,
    ("olive",    "beige"):     0.85,
    ("olive",    "white"):     0.80,
    ("olive",    "navy"):      0.80,
    ("olive",    "brown"):     0.85,
    ("olive",    "gray"):      0.75,
    ("burgundy", "navy"):      0.85,
    ("burgundy", "gray"):      0.80,
    ("burgundy", "beige"):     0.80,
    ("burgundy", "black"):     0.90,
    ("burgundy", "white"):     0.85,
    ("red",      "white"):     0.85,
    ("red",      "black"):     0.85,
    ("red",      "navy"):      0.70,
    ("red",      "gray"):      0.70,
    ("pink",     "white"):     0.85,
    ("pink",     "gray"):      0.75,
    ("pink",     "navy"):      0.70,
    ("pink",     "black"):     0.75,
    ("green",    "white"):     0.75,
    ("green",    "beige"):     0.75,
    ("green",    "navy"):      0.70,
    ("green",    "brown"):     0.70,
    ("yellow",   "white"):     0.75,
    ("yellow",   "navy"):      0.70,
    ("yellow",   "black"):     0.70,
    ("yellow",   "gray"):      0.60,
}


TEMP_CAT_SCORE: dict[str, dict[str, float]] = {
    "hot": {   # >= 25 °C
        "t-shirt":    1.0, "tank-top":   1.0, "shorts": 1.0,
        "sandals":    1.0, "dress":      0.90,"skirt":  0.90,
        "blouse":     0.80,"polo":       0.80,"jeans":  0.50,
        "sneakers":   0.70,"sweater":    0.10,"hoodie": 0.0,
        "cardigan":   0.20,"blazer":     0.30,"trousers":0.50,
        "boots":      0.10,"leggings":   0.20,"sweatpants":0.0,
        "shirt":      0.60,"oxfords":    0.50,"loafers":0.65,
        "heels":      0.60,
    },
    "warm": {  # 15 – 24 °C
        "t-shirt":    1.0, "jeans":      1.0, "sneakers":1.0,
        "dress":      0.90,"blouse":     0.90,"shorts":  0.80,
        "sandals":    0.75,"polo":       0.90,"shirt":   0.90,
        "cardigan":   0.70,"skirt":      0.85,"blazer":  0.80,
        "trousers":   0.90,"boots":      0.70,"loafers": 0.90,
        "heels":      0.90,"sweater":    0.50,"hoodie":  0.40,
        "leggings":   0.70,"oxfords":    0.85,"sweatpants":0.30,
        "tank-top":   0.85,
    },
    "cool": {  # 8 – 14 °C
        "sweater":    1.0, "hoodie":     0.90,"jeans":   1.0,
        "blazer":     0.90,"cardigan":   0.95,"boots":   1.0,
        "trousers":   0.90,"shirt":      0.80,"loafers": 0.80,
        "oxfords":    0.80,"sneakers":   0.85,"heels":   0.65,
        "dress":      0.50,"blouse":     0.60,"skirt":   0.50,
        "t-shirt":    0.50,"shorts":     0.10,"sandals": 0.0,
        "tank-top":   0.10,"sweatpants": 0.70,"polo":    0.70,
        "leggings":   0.90,
    },
    "cold": {  # < 8 °C
        "sweater":    1.0, "hoodie":     0.90,"boots":   1.0,
        "trousers":   1.0, "jeans":      0.90,"cardigan":0.85,
        "blazer":     0.70,"leggings":   0.90,"oxfords": 0.70,
        "sneakers":   0.70,"shirt":      0.60,"sweatpants":0.80,
        "t-shirt":    0.20,"shorts":     0.0, "sandals": 0.0,
        "dress":      0.20,"skirt":      0.20,"tank-top":0.0,
        "heels":      0.40,"blouse":     0.30,"polo":    0.50,
        "loafers":    0.50,
    },
}


def _temp_band(temp: int) -> str:
    if temp >= 25: return "hot"
    if temp >= 15: return "warm"
    if temp >= 8:  return "cool"
    return "cold"


def _color_compat(c1: str, c2: str) -> float:
    if c1 == c2:
        return 0.40
    score = COLOR_COMPAT.get((c1, c2)) or COLOR_COMPAT.get((c2, c1))
    return score if score is not None else 0.50


def _event_score(cat: str, occasion: str) -> float:
    table = EVENT_CAT_SCORE.get(occasion, EVENT_CAT_SCORE["casual"])
    if cat in table:
        return table[cat]
    for key, val in table.items():
        if key in cat or cat in key:
            return val
    return 0.50


def _temp_score(cat: str, temp: int) -> float:
    band  = _temp_band(temp)
    table = TEMP_CAT_SCORE.get(band, {})
    if cat in table:
        return table[cat]
    for key, val in table.items():
        if key in cat or cat in key:
            return val
    return 0.50


def compute_score(
    top: str, top_color: str,
    bottom: str, bottom_color: str,
    shoes: str, shoes_color: str,
    occasion: str, temperature: int,
) -> float:
    """Bir kombin için 0–1 arası skor hesapla."""
    items = [
        (top,    top_color),
        (bottom, bottom_color),
        (shoes,  shoes_color),
    ]

    event_scores = [_event_score(cat, occasion) for cat, _ in items]
    temp_scores  = [_temp_score(cat, temperature) for cat, _ in items]
    color_pairs  = [
        _color_compat(items[i][1], items[j][1])
        for i in range(len(items))
        for j in range(i + 1, len(items))
    ]

    event_avg = sum(event_scores) / len(event_scores)
    temp_avg  = sum(temp_scores)  / len(temp_scores)
    color_avg = sum(color_pairs)  / len(color_pairs) if color_pairs else 0.50
    score = (event_avg * 0.45) + (temp_avg * 0.35) + (color_avg * 0.20)

    noise = np.random.uniform(-0.03, 0.03)
    return float(min(1.0, max(0.0, round(score + noise, 4))))

def generate(n_per_occasion: int = 200) -> pd.DataFrame:
    rows = []

    for occasion in OCCASIONS:
        for _ in range(n_per_occasion):
            top          = random.choice(TOPS)
            top_color    = random.choice(COLORS)
            bottom       = random.choice(BOTTOMS)
            bottom_color = random.choice(COLORS)
            shoes        = random.choice(SHOES)
            shoes_color  = random.choice(COLORS)
            temperature  = random.choice(TEMPERATURES)

            score = compute_score(
                top, top_color, bottom, bottom_color,
                shoes, shoes_color, occasion, temperature,
            )
            rows.append({
                "top":          top,
                "top_color":    top_color,
                "bottom":       bottom,
                "bottom_color": bottom_color,
                "shoes":        shoes,
                "shoes_color":  shoes_color,
                "occasion":     occasion,
                "temperature":  temperature,
                "score":        score,
            })

    rows += _edge_cases()
    rows += _destination_scenarios()

    df = pd.DataFrame(rows).sample(frac=1, random_state=42).reset_index(drop=True)
    print(f"[Dataset] {len(df)} satır üretildi.")
    return df


def _edge_cases() -> list[dict]:
    """
    Modelin kenar durumları öğrenmesi için el ile etiketlenmiş örnekler.
    Yüksek skor (iyi kombin) ve düşük skor (kötü kombin) içerir.
    """
    good = [
        # Klasik formel
        ("shirt", "white", "trousers", "black", "heels",   "black",  "formal",   20, 0.96),
        ("blazer","navy",  "trousers", "gray",  "oxfords", "black",  "business", 18, 0.95),
        ("dress", "black", "jeans",    "none",  "heels",   "black",  "date",     20, 0.94),
        # Rahat kombin
        ("t-shirt","white","jeans",    "blue",  "sneakers","white",  "casual",   22, 0.93),
        ("hoodie","gray",  "jeans",    "black", "sneakers","white",  "casual",   15, 0.91),
        # Spor
        ("t-shirt","black","leggings", "black", "sneakers","white",  "sport",    20, 0.95),
        ("tank-top","gray","shorts",   "black", "sneakers","gray",   "sport",    28, 0.96),
        # Parti
        ("dress", "red",   "jeans",    "none",  "heels",   "black",  "party",    20, 0.94),
        ("blazer","black", "jeans",    "black", "heels",   "black",  "party",    18, 0.90),
    ]
    bad = [
        # Yanlış etkinlik
        ("hoodie","black", "sweatpants","gray", "sneakers","white",  "formal",   18, 0.08),
        ("t-shirt","white","shorts",    "blue", "sandals", "brown",  "formal",   25, 0.05),
        # Renk uyumsuzluğu
        ("t-shirt","yellow","jeans",   "red",  "sneakers","green",  "casual",   20, 0.30),
        ("shirt",  "pink", "trousers", "orange","heels",  "purple", "business", 18, 0.12),
        # Sıcaklık uyumsuzluğu
        ("sweater","black","trousers", "black","boots",   "black",  "sport",    30, 0.15),
        ("shorts", "white","jeans",    "none", "sandals", "white",  "formal",    5, 0.06),
        # Karma kötü
        ("hoodie","brown", "shorts",   "red",  "heels",   "yellow", "date",     10, 0.10),
        ("tank-top","pink","leggings", "green","heels",   "blue",   "business", 22, 0.08),
    ]

    rows = []
    for g in good:
        top, tc, bot, bc, sh, sc, occ, temp, score = g
        rows.append(dict(
            top=top, top_color=tc, bottom=bot, bottom_color=bc,
            shoes=sh, shoes_color=sc, occasion=occ, temperature=temp, score=score,
        ))
    for b in bad:
        top, tc, bot, bc, sh, sc, occ, temp, score = b
        rows.append(dict(
            top=top, top_color=tc, bottom=bot, bottom_color=bc,
            shoes=sh, shoes_color=sc, occasion=occ, temperature=temp, score=score,
        ))
    return rows


def _destination_scenarios() -> list[dict]:
    """
    Seyahat/destinasyon bazlı gerçekçi senaryolar.
    Farklı şehir hava sıcaklıklarına göre iyi ve kötü kombinler.
    """
    # (top, top_color, bottom, bottom_color, shoes, shoes_color, occasion, temp, score)
    scenarios = [
        # Soğuk şehir (Erzurum, 0–5°C) → iş toplantısı
        ("sweater", "navy",  "trousers", "black",  "boots",   "black",  "business",  3, 0.93),
        ("blazer",  "gray",  "trousers", "black",  "boots",   "brown",  "business",  3, 0.91),
        ("hoodie",  "black", "jeans",    "black",  "sneakers","white",  "business",  3, 0.22),

        # Sıcak şehir (Antalya, 30°C) → günlük
        ("t-shirt", "white", "shorts",   "beige",  "sandals", "white",  "casual",   30, 0.95),
        ("blouse",  "blue",  "skirt",    "white",  "sandals", "beige",  "casual",   30, 0.93),
        ("sweater", "black", "jeans",    "black",  "boots",   "black",  "casual",   30, 0.08),

        # Ilıman şehir (İstanbul, 18°C) → randevu
        ("blouse",  "white", "trousers", "navy",   "heels",   "black",  "date",     18, 0.94),
        ("dress",   "burgundy","jeans",  "none",   "heels",   "black",  "date",     18, 0.95),
        ("hoodie",  "gray",  "sweatpants","black", "sneakers","white",  "date",     18, 0.12),

        # Yağmurlu İstanbul (12°C) → günlük
        ("cardigan","navy",  "jeans",    "black",  "boots",   "black",  "casual",   12, 0.92),
        ("hoodie",  "olive", "jeans",    "black",  "sneakers","white",  "casual",   12, 0.88),
        ("tank-top","white", "shorts",   "blue",   "sandals", "white",  "casual",   12, 0.15),

        # Ankara kış (5°C) → iş toplantısı
        ("blazer",  "black", "trousers", "gray",   "oxfords", "black",  "business",  5, 0.94),
        ("sweater", "beige", "trousers", "black",  "boots",   "brown",  "business",  5, 0.89),
        ("t-shirt", "white", "shorts",   "blue",   "sneakers","white",  "business",  5, 0.04),

        # İzmir yaz (28°C) → parti
        ("dress",   "red",   "jeans",    "none",   "heels",   "gold",   "party",    28, 0.91),
        ("blouse",  "black", "skirt",    "black",  "heels",   "black",  "party",    28, 0.90),
        ("sweater", "gray",  "jeans",    "black",  "boots",   "black",  "party",    28, 0.14),

        # Seyahat spor (25°C, dağ yürüyüşü)
        ("t-shirt", "olive", "shorts",   "khaki",  "sneakers","gray",   "sport",    25, 0.94),
        ("tank-top","gray",  "leggings", "black",  "sneakers","white",  "sport",    25, 0.95),
        ("blazer",  "navy",  "trousers", "black",  "heels",   "black",  "sport",    25, 0.05),

        # Dubai sıcak (38°C) → iş
        ("shirt",   "white", "trousers", "beige",  "loafers", "beige",  "business", 35, 0.85),
        ("blouse",  "white", "trousers", "white",  "sandals", "white",  "business", 35, 0.80),
        ("sweater", "black", "jeans",    "black",  "boots",   "black",  "business", 35, 0.03),

        # Paris ilkbahar (16°C) → randevu
        ("cardigan","beige", "jeans",    "blue",   "loafers", "brown",  "date",     16, 0.91),
        ("blouse",  "white", "trousers", "navy",   "heels",   "nude",   "date",     16, 0.93),
        ("hoodie",  "gray",  "sweatpants","gray",  "sneakers","white",  "date",     16, 0.10),
    ]

    rows = []
    for top, tc, bot, bc, sh, sc, occ, temp, score in scenarios:
        rows.append(dict(
            top=top, top_color=tc, bottom=bot, bottom_color=bc,
            shoes=sh, shoes_color=sc, occasion=occ, temperature=temp, score=score,
        ))
    return rows


if __name__ == "__main__":
    df = generate(n_per_occasion=120)
    out_path = os.path.join(os.path.dirname(__file__), "outfit_data.csv")
    df.to_csv(out_path, index=False)
    print(f"[Dataset] Kaydedildi → {out_path}")
    print(df.describe())
    print(df["occasion"].value_counts())
