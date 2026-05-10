"""
train.py
--------
Kombin skorlama modelini eğitir ve kaydeder.

Pipeline:
  1. outfit_data.csv'yi yükle
  2. Kategorik özellikleri OrdinalEncoder ile encode et
  3. RandomForestRegressor eğit (5-katlı çapraz doğrulama)
  4. Model + encoder'ı joblib ile kaydet

Çalıştır:
    cd backend
    python -m app.ai.train
"""

import os
import joblib
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.preprocessing import OrdinalEncoder
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer

# ── Yollar ────────────────────────────────────────────────────────────────────

BASE_DIR    = os.path.dirname(__file__)
DATASET_DIR = os.path.join(BASE_DIR, "dataset")
MODEL_DIR   = os.path.join(BASE_DIR, "model")
CSV_PATH    = os.path.join(DATASET_DIR, "outfit_data.csv")
MODEL_PATH  = os.path.join(MODEL_DIR, "outfit_scorer.pkl")

os.makedirs(MODEL_DIR, exist_ok=True)

# ── Özellik tanımları ──────────────────────────────────────────────────────────

CAT_FEATURES = [
    "top", "top_color",
    "bottom", "bottom_color",
    "shoes", "shoes_color",
    "occasion",
]
NUM_FEATURES = ["temperature"]
ALL_FEATURES = CAT_FEATURES + NUM_FEATURES
TARGET       = "score"

# Tüm olası değerler (encoder için)
TOPS       = ["t-shirt","shirt","blouse","sweater","hoodie","blazer","dress","cardigan","tank-top","polo"]
BOTTOMS    = ["jeans","trousers","shorts","skirt","leggings","sweatpants","none"]
SHOES_LIST = ["sneakers","heels","boots","loafers","sandals","oxfords","none"]
COLORS     = ["white","black","navy","gray","beige","blue","red","green","brown","pink","yellow","burgundy","olive","unknown"]
OCCASIONS  = ["casual","formal","date","business","sport","party"]

CAT_CATEGORIES = [TOPS, COLORS, BOTTOMS, COLORS, SHOES_LIST, COLORS, OCCASIONS]


def load_data(path: str = CSV_PATH) -> pd.DataFrame:
    df = pd.read_csv(path)
    # Küçük harfe normalize et
    for col in CAT_FEATURES:
        if col in df.columns:
            df[col] = df[col].str.lower().str.strip()
    # Bilinmeyen kategorileri 'unknown' yap
    for col, cats in zip(CAT_FEATURES, CAT_CATEGORIES):
        df[col] = df[col].where(df[col].isin(cats), other="unknown")
    print(f"[Train] {len(df)} satir yuklendi. Skor ortalamasi: {df[TARGET].mean():.3f}")
    return df


def build_pipeline() -> Pipeline:
    """
    Sklearn pipeline:
      OrdinalEncoder (kategorik) + RandomForest regressor
    """
    encoder = OrdinalEncoder(
        categories=CAT_CATEGORIES,
        handle_unknown="use_encoded_value",
        unknown_value=-1,
    )
    transformer = ColumnTransformer(
        transformers=[
            ("cat", encoder, CAT_FEATURES),
            ("num", "passthrough", NUM_FEATURES),
        ]
    )
    model = RandomForestRegressor(
        n_estimators=300,
        max_depth=12,
        min_samples_leaf=3,
        max_features="sqrt",
        random_state=42,
        n_jobs=-1,
    )
    return Pipeline([
        ("preprocessor", transformer),
        ("regressor",    model),
    ])


def train(df: pd.DataFrame) -> Pipeline:
    X = df[ALL_FEATURES]
    y = df[TARGET]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.15, random_state=42
    )

    pipe = build_pipeline()
    pipe.fit(X_train, y_train)

    # ── Değerlendirme ──────────────────────────────────────────────────────────
    y_pred = pipe.predict(X_test)
    mae    = mean_absolute_error(y_test, y_pred)
    r2     = r2_score(y_test, y_pred)

    cv_scores = cross_val_score(pipe, X, y, cv=5, scoring="r2", n_jobs=-1)

    print(f"\n[Train] --- Test Seti ---")
    print(f"  MAE : {mae:.4f}")
    print(f"  R2  : {r2:.4f}")
    print(f"\n[Train] --- 5-Katli Capraz Dogrulama ---")
    print(f"  R2  : {cv_scores.mean():.4f} +/- {cv_scores.std():.4f}")
    print(f"  Katlar: {[round(s, 3) for s in cv_scores]}")

    # Feature importance
    rf_model     = pipe.named_steps["regressor"]
    feature_names= CAT_FEATURES + NUM_FEATURES
    importances  = rf_model.feature_importances_
    pairs        = sorted(zip(feature_names, importances), key=lambda x: -x[1])
    print(f"\n[Train] --- Ozellik Onemi ---")
    for name, imp in pairs:
        bar = "#" * int(imp * 40)
        print(f"  {name:<14} {imp:.4f}  {bar}")

    return pipe


def save_pipeline(pipe: Pipeline, path: str = MODEL_PATH) -> None:
    joblib.dump(pipe, path)
    print(f"\n[Train] Model kaydedildi: {path}")


def main() -> None:
    print("=" * 50)
    print("  Smart Closet - Kombin Skorlayici Egitimi")
    print("=" * 50)

    # Veri seti yoksa otomatik üret
    if not os.path.exists(CSV_PATH):
        print("[Train] Veri seti bulunamadi. Uretiliyor...")
        from app.ai.dataset.generate_dataset import generate
        df = generate(n_per_occasion=120)
        df.to_csv(CSV_PATH, index=False)
    else:
        df = load_data(CSV_PATH)

    pipe = train(df)
    save_pipeline(pipe)
    print("\n[Train] Tamamlandi! OK")


if __name__ == "__main__":
    main()
