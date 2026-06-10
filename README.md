# 👗 Smart Closet App

AI-powered personal wardrobe assistant. Suggests outfits based on weather, occasion, and color harmony.

---

## 🚀 Tech Stack

| Layer | Technology |
|--------|-----------|
| Mobile | Flutter (Dart) |
| Backend | Python / Flask |
| Database | SQLite (SQLAlchemy) |
| AI Model | Random Forest (scikit-learn) |
| Auth | Firebase Authentication |
| Weather | OpenWeatherMap API |

---

## 📁 Project Structure

```
smart-closet-app/
├── lib/                        # Flutter application
│   ├── feature/
│   │   ├── auth/               # Sign-in, sign-up, Google Sign-In
│   │   ├── home/               # Home screen, weather widget
│   │   ├── wardrobe/           # Wardrobe, clothing cards
│   │   ├── outfit/             # AI outfit chat
│   │   ├── add_clothing/       # Add clothing form
│   │   ├── stats/              # Statistics
│   │   └── profile/            # Profile, location, editing
│   └── product/
│       ├── data/               # Models, repositories, services
│       └── utils/              # Colors, styles, constants
├── backend/                    # Flask API
│   ├── app/
│   │   ├── ai/                 # ML model, scoring engine, recommender
│   │   │   ├── dataset/        # Training data generation
│   │   │   ├── model/          # Trained model (.pkl)
│   │   │   ├── outfit_scorer.py
│   │   │   ├── ml_scorer.py
│   │   │   ├── recommender.py
│   │   │   ├── claude_client.py
│   │   │   └── train.py
│   │   ├── api/                # REST endpoints
│   │   └── models/             # SQLAlchemy models
│   ├── uploads/                # Uploaded clothing images
│   └── instance/
│       └── smartcloset.db      # SQLite database
└── assets/
    └── locales/                # TR / EN translations
```

---

## ⚙️ Setup

### Requirements

- Flutter SDK 3.x+
- Python 3.10+
- A Firebase project

### 1. Backend

```bash
cd backend
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS/Linux

pip install -r requirements.txt
```

Train the model:

```bash
python -m app.ai.train
```

Start the server:

```bash
python run.py
```

### 2. Flutter

```bash
flutter pub get
flutter run
```

---

## 🤖 AI System

### Hybrid Scoring

Every outfit is evaluated with a two-layer scoring system:

```
final_score = rule_score × 0.60 + ml_score × 0.40
```

**Rule-based** (always runs):
- Temperature match (25%)
- Occasion match (35%)
- Weather type match (25%)
- Season match (15%)
- Color harmony — 14×14 symmetric compatibility matrix

**ML model** (Random Forest, 400 trees):
- 6,000 rows of synthetic training data
- Features: top, bottom, shoes, colors, occasion, weather_type, temperature, feels_like, season_match
- R²: ~0.59 | MAE: ~0.044

### Supported Categories

| Tops | Bottoms | Shoes |
|--------|--------|-------------|
| t-shirt, shirt, blouse, sweater, hoodie, blazer, dress, cardigan, tank-top, polo | jeans, trousers, shorts, skirt, leggings, sweatpants | sneakers, heels, boots, loafers, sandals, oxfords |

---

## 🌐 API Endpoints

### Chat
| Method | Endpoint | Description |
|--------|----------|----------|
| GET | `/chat/greet` | Greeting message |
| POST | `/chat/message` | Get an outfit suggestion |

### Clothes
| Method | Endpoint | Description |
|--------|----------|----------|
| GET | `/clothes/` | List wardrobe |
| POST | `/clothes/` | Add a clothing item |
| PUT | `/clothes/<id>` | Update a clothing item |
| DELETE | `/clothes/<id>` | Delete a clothing item |
| POST | `/clothes/<id>/wear` | Mark as worn |
| PATCH | `/clothes/<id>/favorite` | Toggle favorite |

### Outfit
| Method | Endpoint | Description |
|--------|----------|----------|
| GET | `/outfit/` | Saved outfits |
| POST | `/outfit/save` | Save an outfit |
| PATCH | `/outfit/<id>/favorite` | Toggle favorite |
| GET | `/outfit/stats` | Statistics |

### Weather
| Method | Endpoint | Description |
|--------|----------|----------|
| GET | `/weather/?lat=&lon=` | Weather by coordinates |

## 📱 Features

- 🔐 Sign in with email and Google
- 👚 Photo-based wardrobe management
- ❤️ Mark favorite clothing items
- 🌤️ Real-time weather integration
- 🤖 AI-powered outfit suggestions (chat interface)
- 📍 GPS-based location and city name

<br></br>


<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/5c6efc74-dfde-4950-a9b9-aeeb9a36e747" />
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/1f15ef28-d29c-416e-bb4f-4787f3b1066f" />
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/d8e7163e-a3b7-4a6a-b969-ed2d82080541" />
<br></br>
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/5d808e6a-b2fd-497a-bcd4-e6505408b74d" />
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/d838e7a4-9741-4413-aee6-f0c2d9a45344" />
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/4a960baf-16f0-4fcb-8b59-54347ba2883f" />
<br></br>
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/0d317177-dd53-4f7c-8a9c-49b7214bc404" />
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/8793adad-f0dc-4a7a-b998-b420ff525bbe" />
<img width="315" height="650" alt="image" src="https://github.com/user-attachments/assets/9107785d-0d09-4235-994a-91c622f07eec" />







