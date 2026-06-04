
import os
import joblib
import pandas as pd
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import cross_val_score, train_test_split
from sklearn.preprocessing import OrdinalEncoder
from sklearn.metrics import mean_absolute_error, r2_score
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer

BASE_DIR    = os.path.dirname(__file__)
DATASET_DIR = os.path.join(BASE_DIR, "dataset")
MODEL_DIR   = os.path.join(BASE_DIR, "model")
CSV_PATH    = os.path.join(DATASET_DIR, "outfit_data.csv")
MODEL_PATH  = os.path.join(MODEL_DIR, "outfit_scorer.pkl")

os.makedirs(MODEL_DIR, exist_ok=True)

CAT_FEATURES  = ["top","top_color","bottom","bottom_color",
                 "shoes","shoes_color","occasion","weather_type"]
NUM_FEATURES  = ["temperature","feels_like","season_match"]
ALL_FEATURES  = CAT_FEATURES + NUM_FEATURES
TARGET        = "score"

TOPS          = ["t-shirt","shirt","blouse","sweater","hoodie","blazer","dress",
                 "cardigan","tank-top","polo","none"]
BOTTOMS       = ["jeans","trousers","shorts","skirt","leggings","sweatpants","none"]
SHOES_LIST    = ["sneakers","heels","boots","loafers","sandals","oxfords","none"]
COLORS        = ["white","black","navy","gray","beige","blue","red","green",
                 "brown","pink","yellow","burgundy","purple","orange","none"]
OCCASIONS     = ["casual","formal","date","business","sport","party"]
WEATHER_TYPES = ["sunny","cloudy","rain","snow","storm","windy"]

CAT_CATEGORIES = [TOPS,COLORS,BOTTOMS,COLORS,SHOES_LIST,COLORS,OCCASIONS,WEATHER_TYPES]

def load_data(path: str = CSV_PATH) -> pd.DataFrame:
    df = pd.read_csv(path)

    if "weather_type" not in df.columns: df["weather_type"] = "cloudy"
    if "feels_like"   not in df.columns: df["feels_like"]   = df.get("temperature", 18)
    if "season_match" not in df.columns: df["season_match"] = 0.75

    for col in CAT_FEATURES:
        if col in df.columns:
            df[col] = df[col].astype(str).str.lower().str.strip().fillna("none")

    cat_sets = {c: set(cats) for c, cats in zip(CAT_FEATURES, CAT_CATEGORIES)}
    for col, valid in cat_sets.items():
        df[col] = df[col].where(df[col].isin(valid), other="none")

    for col in NUM_FEATURES:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
            df[col] = df[col].fillna(df[col].median())

    print(f"[Train] {len(df)} satir yuklendi. Skor ortalamasi: {df[TARGET].mean():.3f}")
    return df

def build_pipeline() -> Pipeline:
    encoder = OrdinalEncoder(
        categories=CAT_CATEGORIES,
        handle_unknown="use_encoded_value", unknown_value=-1,
    )
    transformer = ColumnTransformer([
        ("cat", encoder,       CAT_FEATURES),
        ("num", "passthrough", NUM_FEATURES),
    ])
    model = RandomForestRegressor(
        n_estimators=400, max_depth=14, min_samples_leaf=3,
        max_features="sqrt", random_state=42, n_jobs=-1,
    )
    return Pipeline([("preprocessor", transformer), ("regressor", model)])

def train(df: pd.DataFrame) -> Pipeline:
    X = df[ALL_FEATURES]
    y = df[TARGET]
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.15, random_state=42)

    pipe = build_pipeline()
    pipe.fit(X_train, y_train)

    y_pred    = pipe.predict(X_test)
    cv_scores = cross_val_score(pipe, X, y, cv=5, scoring="r2", n_jobs=-1)

    print(f"\n[Train] MAE : {mean_absolute_error(y_test, y_pred):.4f}")
    print(f"[Train] R2  : {r2_score(y_test, y_pred):.4f}")
    print(f"[Train] CV R2: {cv_scores.mean():.4f} +/- {cv_scores.std():.4f}")

    rf    = pipe.named_steps["regressor"]
    pairs = sorted(zip(ALL_FEATURES, rf.feature_importances_), key=lambda x: -x[1])
    print("\n[Train] Ozellik Onemi:")
    for name, imp in pairs:
        print(f"  {name:<15} {imp:.4f}  {'#' * int(imp * 40)}")

    return pipe

def main() -> None:
    print("=" * 50)
    print("  Smart Closet -- Model Egitimi v2")
    print("=" * 50)

    if not os.path.exists(CSV_PATH):
        print("[Train] Dataset uretiliyor (6000 satir)...")
        from app.ai.dataset.generate_dataset import generate
        df = generate(n=6000)
        df.to_csv(CSV_PATH, index=False)
    else:
        df = load_data(CSV_PATH)

    pipe = train(df)
    joblib.dump(pipe, MODEL_PATH)
    print(f"\n[Train] Model kaydedildi: {MODEL_PATH}")
    print("[Train] Tamamlandi!")

if __name__ == "__main__":
    main()
