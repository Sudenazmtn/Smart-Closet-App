# 👗 Smart Closet App

AI destekli kişisel gardırop asistanı. Hava durumuna, etkinliğe ve renk uyumuna göre kombin önerileri sunar.

---

## 🚀 Teknoloji Stack

| Katman | Teknoloji |
|--------|-----------|
| Mobil | Flutter (Dart) |
| Backend | Python / Flask |
| Veritabanı | SQLite (SQLAlchemy) |
| AI Model | Random Forest (scikit-learn) |
| AI Chat | Claude API (Anthropic) |
| Auth | Firebase Authentication |
| Hava Durumu | OpenWeatherMap API |

---

## 📁 Proje Yapısı

```
smart-closet-app/
├── lib/                        # Flutter uygulaması
│   ├── feature/
│   │   ├── auth/               # Giriş, kayıt, Google Sign-In
│   │   ├── home/               # Ana sayfa, hava durumu widget
│   │   ├── wardrobe/           # Gardırop, kıyafet kartları
│   │   ├── outfit/             # AI kombin chat
│   │   ├── add_clothing/       # Kıyafet ekleme formu
│   │   ├── stats/              # İstatistikler
│   │   └── profile/            # Profil, konum, düzenleme
│   └── product/
│       ├── data/               # Modeller, repository'ler, servisler
│       └── utils/              # Renkler, stiller, sabitler
├── backend/                    # Flask API
│   ├── app/
│   │   ├── ai/                 # ML model, skor motoru, öneri sistemi
│   │   │   ├── dataset/        # Eğitim verisi üretimi
│   │   │   ├── model/          # Eğitilmiş model (.pkl)
│   │   │   ├── outfit_scorer.py
│   │   │   ├── ml_scorer.py
│   │   │   ├── recommender.py
│   │   │   ├── claude_client.py
│   │   │   └── train.py
│   │   ├── api/                # REST endpoint'leri
│   │   └── models/             # SQLAlchemy modelleri
│   ├── uploads/                # Yüklenen kıyafet görselleri
│   └── instance/
│       └── smartcloset.db      # SQLite veritabanı
└── assets/
    └── locales/                # TR / EN çeviriler
```

---

## ⚙️ Kurulum

### Gereksinimler

- Flutter SDK 3.x+
- Python 3.10+
- Firebase projesi

### 1. Backend

```bash
cd backend
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS/Linux

pip install -r requirements.txt
```


Modeli eğit:

```bash
python -m app.ai.train
```

Sunucuyu başlat:

```bash
python run.py
```

### 2. Flutter

```bash
flutter pub get
flutter run
```

---

## 🤖 AI Sistemi

### Hibrit Skorlama

Her kombin iki katmanlı skorlama sistemiyle değerlendirilir:

```
final_score = rule_score × 0.60 + ml_score × 0.40
```

**Kural tabanlı** (her zaman çalışır):
- Sıcaklık uyumu (25%)
- Etkinlik uyumu (35%)
- Hava tipi uyumu (25%)
- Mevsim uyumu (15%)
- Renk uyumu — 14×14 simetrik uyum matrisi

**ML modeli** (Random Forest, 400 ağaç):
- 6.000 satır sentetik eğitim verisi
- Özellikler: top, bottom, shoes, renkler, occasion, weather_type, temperature, feels_like, season_match
- R²: ~0.59 | MAE: ~0.044

### Desteklenen Kategoriler

| Üstler | Altlar | Ayakkabılar |
|--------|--------|-------------|
| t-shirt, shirt, blouse, sweater, hoodie, blazer, dress, cardigan, tank-top, polo | jeans, trousers, shorts, skirt, leggings, sweatpants | sneakers, heels, boots, loafers, sandals, oxfords |

---

## 🌐 API Endpoint'leri

### Chat
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | `/chat/greet` | Karşılama mesajı |
| POST | `/chat/message` | Kombin önerisi al |

### Kıyafetler
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | `/clothes/` | Gardırobu listele |
| POST | `/clothes/` | Kıyafet ekle |
| PUT | `/clothes/<id>` | Kıyafet güncelle |
| DELETE | `/clothes/<id>` | Kıyafet sil |
| POST | `/clothes/<id>/wear` | Giyildi olarak işaretle |
| PATCH | `/clothes/<id>/favorite` | Favori toggle |

### Kombin
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | `/outfit/` | Kayıtlı kombinler |
| POST | `/outfit/save` | Kombin kaydet |
| PATCH | `/outfit/<id>/favorite` | Favori toggle |
| GET | `/outfit/stats` | İstatistikler |

### Hava Durumu
| Method | Endpoint | Açıklama |
|--------|----------|----------|
| GET | `/weather/?lat=&lon=` | Koordinata göre hava durumu |



## 📱 Özellikler

- 🔐 E-posta ve Google ile giriş
- 👚 Fotoğraflı gardırop yönetimi
- ❤️ Favori kıyafet işaretleme
- 🌤️ Gerçek zamanlı hava durumu entegrasyonu
- 🤖 AI destekli kombin önerisi (chat arayüzü)
- 📍 GPS tabanlı konum ve şehir adı
