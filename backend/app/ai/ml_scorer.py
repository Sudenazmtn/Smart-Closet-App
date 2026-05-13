"""
ml_scorer.py
------------
Eğitilmiş RandomForest modeli ile kombin skoru tahmin eder.

Eğer model dosyası yoksa otomatik olarak rule-based outfit_scorer'a fallback yapar.
Bu sayede model hiç eğitilmemişse bile sistem çalışmaya devam eder.

Kullanım:
    from app.ai.ml_scorer import score_outfit_ml

    score = score_outfit_ml(items, event_type="date", temperature=20)
"""

import os
import logging
from typing import Optional

try:
    import pandas as pd
    _PANDAS_AVAILABLE = True
except ImportError:
    _PANDAS_AVAILABLE = False

logger = logging.getLogger(__name__)

BASE_DIR   = os.path.dirname(__file__)
MODEL_PATH = os.path.join(BASE_DIR, "model", "outfit_scorer.pkl")

_pipeline = None
_model_available = None


def _load_model():
    global _pipeline, _model_available
    if _model_available is not None:
        return _model_available

    if not os.path.exists(MODEL_PATH):
        logger.warning("[ml_scorer] Model dosyası bulunamadı: %s", MODEL_PATH)
        logger.warning("[ml_scorer] Rule-based scorer'a fallback yapılıyor.")
        _model_available = False
        return False

    try:
        import joblib
        _pipeline = joblib.load(MODEL_PATH)
        _model_available = True
        logger.info("[ml_scorer] Model yüklendi: %s", MODEL_PATH)
        return True
    except Exception as exc:
        logger.error("[ml_scorer] Model yüklenirken hata: %s", exc)
        _model_available = False
        return False


_COLOR_NORMALIZE = {
    "siyah": "black", "beyaz": "white", "gri": "gray",
    "lacivert": "navy", "bej": "beige", "kırmızı": "red",
    "mavi": "blue", "yeşil": "green", "kahverengi": "brown",
    "pembe": "pink", "sarı": "yellow", "bordo": "burgundy",
    "haki": "olive", "zeytin": "olive",
}

_CAT_NORMALIZE = {
    "tişört": "t-shirt", "tshirt": "t-shirt", "t shirt": "t-shirt",
    "gömlek": "shirt", "bluz": "blouse", "kazak": "sweater",
    "sweatshirt": "hoodie", "ceket": "blazer", "elbise": "dress",
    "hırka": "cardigan", "atlet": "tank-top", "polo yaka": "polo",
    "kot": "jeans", "pantolon": "trousers", "şort": "shorts",
    "etek": "skirt", "tayt": "leggings", "eşofman": "sweatpants",
    "spor ayakkabı": "sneakers", "topuklu": "heels", "bot": "boots",
    "loafer": "loafers", "sandalet": "sandals", "oxford": "oxfords",
}

_OCCASION_NORMALIZE = {
    "günlük": "casual", "rahat": "casual", "casual": "casual",
    "resmi": "formal", "formal": "formal", "gala": "formal",
    "randevu": "date", "date": "date", "romantik": "date",
    "iş": "business", "toplantı": "business", "ofis": "business",
    "spor": "sport", "sport": "sport", "gym": "sport",
    "parti": "party", "party": "party", "kutlama": "party",
}


def _norm(value: str, mapping: dict) -> str:
    v = value.lower().strip()
    return mapping.get(v, v)


def score_outfit_ml(
    items: list,
    event_type: str,
    temperature: int,
) -> Optional[float]:
    """
    ML modeli ile kombin skoru tahmin et.

    Parameters
    ----------
    items       : ClothingItem ORM nesnelerinin listesi (category, color alanları beklenir)
    event_type  : "casual" | "formal" | "date" | "business" | "sport" | "party"
    temperature : Sıcaklık (°C)

    Returns
    -------
    float (0.0 – 1.0) veya model yüklenemediyse None
    """
    if not _load_model():
        return None
    top    = _find_item(items, {"t-shirt","shirt","blouse","sweater","hoodie",
                                 "blazer","dress","cardigan","tank-top","polo"})
    bottom = _find_item(items, {"jeans","trousers","shorts","skirt","leggings","sweatpants"})
    shoes  = _find_item(items, {"sneakers","heels","boots","loafers","sandals","oxfords"})

    if top is None:
        return None

    top_cat    = _norm(top.category,    _CAT_NORMALIZE)
    top_color  = _norm(top.color,       _COLOR_NORMALIZE)
    bot_cat    = _norm(bottom.category, _CAT_NORMALIZE) if bottom else "none"
    bot_color  = _norm(bottom.color,    _COLOR_NORMALIZE) if bottom else "black"
    shoe_cat   = _norm(shoes.category,  _CAT_NORMALIZE) if shoes else "none"
    shoe_color = _norm(shoes.color,     _COLOR_NORMALIZE) if shoes else "black"
    occasion   = _norm(event_type,      _OCCASION_NORMALIZE)

    if not _PANDAS_AVAILABLE:
        return None
    X = pd.DataFrame([{
        "top":         top_cat,
        "top_color":   top_color,
        "bottom":      bot_cat,
        "bottom_color":bot_color,
        "shoes":       shoe_cat,
        "shoes_color": shoe_color,
        "occasion":    occasion,
        "temperature": int(temperature),
    }])

    try:
        score = float(_pipeline.predict(X)[0])
        return round(min(1.0, max(0.0, score)), 4)
    except Exception as exc:
        logger.error("[ml_scorer] Tahmin hatası: %s", exc)
        return None


def _find_item(items: list, category_set: set):
    for item in items:
        cat = item.category.lower().strip()
        for key in category_set:
            if key in cat or cat in key:
                return item
    return None


def is_model_available() -> bool:
    return _load_model()


def model_info() -> dict:
    available = is_model_available()
    info = {
        "available": available,
        "path": MODEL_PATH,
        "exists": os.path.exists(MODEL_PATH),
    }
    if available and _pipeline is not None:
        rf = _pipeline.named_steps.get("regressor")
        if rf:
            info["n_estimators"]  = rf.n_estimators
            info["n_features_in"] = getattr(rf, "n_features_in_", "?")
    return info
