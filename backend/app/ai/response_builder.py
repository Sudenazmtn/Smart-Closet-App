import random

OPENING_TEMPLATES = {
    "casual": [
        "Günlük ve şık bir bakış için bu kombini öneririm!",
        "Rahat ve şık — bugün için harika bir seçim.",
        "Gündelik bir gün için mükemmel!",
    ],
    "formal": [
        "Resmi bir etkinlik için zarif bir kombin hazırladım.",
        "Etkileyici görünmek için bu şık kombini dene.",
        "Resmi ortamlar için cilalı ve profesyonel bir bakış.",
    ],
    "date": [
        "Harika! {occasion_detail} için hem şık hem rahat bu kombini öneririm.",
        "Romantizm doğru kıyafeti hak ediyor — {occasion_detail} için bu seçim!",
        "Muhteşem görüneceksin! {occasion_detail} için stilistik bir kombin.",
    ],
    "business": [
        "{occasion_detail} için profesyonel ve özgüvenli bir bakış.",
        "İşte tam bir ofis kombini — şık ve etkileyici.",
        "Keskin ve bakımlı — iş ortamı için ideal.",
    ],
    "sport": [
        "Konfor ve stil bir arada — antrenman için hazırsın!",
        "Hareket etmeye hazır — harika bir spor kombini.",
        "Performans ve stil birlikte — işte bugünün görünümü.",
    ],
    "party": [
        "Göz alıcı ol! {occasion_detail} için eğlenceli ve canlı bir kombin.",
        "Partiye hazır ve harika görünüyorsun — işte önerim.",
        "Görkemli bir giriş yap! Bu kombini giyerdim.",
    ],
}

# Destinasyon şehri olan yanıt şablonları
DESTINATION_OPENING_TEMPLATES = {
    "casual": [
        "{city} gezisi için rahat ve şık bir kombin!",
        "{city}'de günlük dolaşım için mükemmel bir seçim.",
        "{city} için hafif ve şık — işte önerim!",
    ],
    "formal": [
        "{city}'deki resmi etkinlik için zarif bir kombin.",
        "{city} yolculuğu için cilalı ve profesyonel bir bakış.",
        "{city}'de etkileyici görünmek için bu kombini seç.",
    ],
    "date": [
        "{city}'de {occasion_detail} için hem şık hem rahat bu kombin!",
        "{city}'deki randevu için muhteşem görüneceksin.",
        "{city} yolculuğu + {occasion_detail} — bu kombin biçilmiş kaftan!",
    ],
    "business": [
        "{city}'deki {occasion_detail} için profesyonel ve özgüvenli bir bakış.",
        "{city} iş seyahati için keskin ve bakımlı bir kombin.",
        "{city}'e iş için gidiyorsun — bu kombin seni hazırlıyor!",
    ],
    "sport": [
        "{city}'deki aktivite için konforlu ve şık bir spor kombini!",
        "{city} için hareket etmeye hazır bir görünüm.",
        "{city} macerası için pratik ve şık seçimler.",
    ],
    "party": [
        "{city}'deki {occasion_detail} için göz alıcı bir kombin!",
        "{city} eğlencesi için canlı ve cesur bir bakış.",
        "{city}'de sahne al — bu kombini giyerdim!",
    ],
}

WEATHER_NOTES = {
    "hot":          "Bugün oldukça sıcak, bu yüzden hafif ve nefes alan parçalar seçtim.",
    "warm":         "Hava sıcak ve güzel — bu kombin için mükemmel bir gün.",
    "cool":         "Biraz serin, bu yüzden seni rahat tutacak katmanlar ekledim.",
    "cold":         "Soğuk havaya rağmen stil sahibi — harika bir kış kombini.",
    "rainy":        "Yağmurlu bir gün — yağışa uygun parçalar seçtim.",
    "rain":         "Yağmurlu bir gün — yağışa uygun parçalar seçtim.",
    "drizzle":      "Hafif yağmur var — bunu göz önünde bulundurarak seçtim.",
    "snow":         "Karlı bir gün — sıcak ve şık bir arada.",
    "sunny":        "Güneşli bir gün — parlak bir şey giymek için harika fırsat!",
    "cloudy":       "Bulutlu bir gün ama kombin güzel olacak!",
    "mild":         "Ilıman hava pek çok kombinlere kapı açıyor.",
    "clear":        "Açık bir gün — harika bir kombin için mükemmel hava.",
    "overcast":     "Gri bir gök, ama kombin her şeyi aydınlatacak.",
    "thunderstorm": "Fırtınalı hava — pratik ama şık bir kombin hazırladım.",
    "az bulutlu":   "Az bulutlu ve güzel bir hava seni bekliyor.",
    "parçalı bulutlu": "Parçalı bulutlu — katmanlı bir kombin iyi gider.",
    "kapalı":       "Gökyüzü kapalı ama kombin parlak olacak!",
    "hafif yağmur": "Hafif yağmur ihtimali var — buna göre seçtim.",
    "yağmurlu":     "Yağmurlu hava için pratik ve şık parçalar seçtim.",
    "karlı":        "Kar var — sıcak tutan ama şık bir kombin!",
    "sisli":        "Sisli bir hava — serin olabilir, katmanlı giyinmek iyi olur.",
    "sıcak":        "Sıcak hava — hafif ve nefes alan parçalar seçtim.",
    "soğuk":        "Soğuk hava — seni sıcak tutacak bir kombin hazırladım.",
}

STYLE_TIPS = {
    "casual": [
        "Kollarını sıva, daha rahat ve chic bir his verir.",
        "Bir şapka veya spor ayakkabı günlük stili tamamlar.",
        "Aksesuarları minimal tut — zahmetsiz bir şıklık için.",
    ],
    "formal": [
        "Klasik bir kol saati bu kombini üst seviyeye taşır.",
        "Keskin bir görünüm için her şeyin iyi ütülenmiş olduğundan emin ol.",
        "Resmi kombinlerde sade aksesuarlar en iyi tercih.",
    ],
    "date": [
        "Hafif bir parfüm ve minimal aksesuar kombini tamamlar.",
        "Özgüven en iyi aksesuarındır!",
        "Sade tut — kombin kendi başına konuşsun.",
    ],
    "business": [
        "Yapılandırılmış bir çanta profesyonel havayı pekiştirir.",
        "Aksesuarları klasik ve gösterişsiz tut.",
        "Ayakkabılarının boyalı olduğundan emin ol!",
    ],
    "sport": [
        "Bol su içmeyi unutma!",
        "Nem emici kumaşlar en iyi dostun.",
        "Spor için konfor her zaman önce gelir.",
    ],
    "party": [
        "Cesur aksesuarlar bu kombini gerçekten öne çıkarır.",
        "İddia sahibi bir parça eklemekten çekinme.",
        "Eğlen — parti bu!",
    ],
}

FALLBACK_RESPONSES = [
    "Gardırobun bu etkinlik için biraz kısıtlı. Daha iyi öneriler için daha fazla parça eklemeyi dene!",
    "Gardırobunda mükemmel bir eşleşme bulamadım. Çeşitliliği artırmayı düşün!",
    "Bu etkinlik için gardırobunda birkaç parça daha gerekiyor. Alışveriş zamanı mı?",
]


def build_response(
    recommendation: dict,
    user_message: str,
    destination_city: str | None = None,
) -> dict:
    if "error" in recommendation:
        return {
            "message":          random.choice(FALLBACK_RESPONSES),
            "outfit":           [],
            "score":            0,
            "style_tip":        None,
            "destination_city": destination_city,
        }

    occasion     = recommendation.get("event_type", "casual")
    weather_desc = recommendation.get("weather", "clear").lower()
    outfit_items = recommendation.get("outfit", [])
    score        = recommendation.get("score", 0)
    temperature  = recommendation.get("temperature", 18)

    occasion_detail = _extract_occasion_detail(user_message, occasion)

    # Destinasyon şehri varsa şehir bazlı şablon kullan
    if destination_city:
        templates = DESTINATION_OPENING_TEMPLATES.get(
            occasion, DESTINATION_OPENING_TEMPLATES["casual"]
        )
        opening = random.choice(templates).format(
            city=destination_city,
            occasion_detail=occasion_detail,
        )
        # Şehir + sıcaklık bilgisi ekle
        temp_note = _temp_note(temperature)
        weather_note = _get_weather_note(weather_desc)
        message = opening
        if temp_note:
            message += f" {temp_note}"
        if weather_note:
            message += f" {weather_note}"
    else:
        templates = OPENING_TEMPLATES.get(occasion, OPENING_TEMPLATES["casual"])
        opening   = random.choice(templates).format(occasion_detail=occasion_detail)
        weather_note = _get_weather_note(weather_desc)
        message = opening
        if weather_note:
            message += f" {weather_note}"

    tips      = STYLE_TIPS.get(occasion, STYLE_TIPS["casual"])
    style_tip = random.choice(tips)

    return {
        "message":          message,
        "outfit":           outfit_items,
        "score":            score,
        "style_tip":        style_tip,
        "destination_city": destination_city,
    }


def build_greeting() -> dict:
    return {
        "message":          "Merhaba! Bugün nereye gidiyorsun ya da ne tür bir etkinlik için giyiniyorsun? ✨",
        "outfit":           [],
        "score":            None,
        "style_tip":        None,
        "destination_city": None,
    }


def build_clarification() -> dict:
    return {
        "message":          "Gardırobuna henüz kıyafet eklemedin. "
                            "Önce birkaç parça ekle, sonra sana kombin önereyim! 👗",
        "outfit":           [],
        "score":            None,
        "style_tip":        None,
        "destination_city": None,
    }


# ── Helpers ───────────────────────────────────────────────────────────────────

def _extract_occasion_detail(message: str, occasion: str) -> str:
    msg = message.lower()

    detail_map = {
        "kahve":        "kahve buluşması",
        "coffee":       "kahve buluşması",
        "akşam yemeği": "akşam yemeği",
        "dinner":       "akşam yemeği",
        "öğle":         "öğle yemeği",
        "lunch":        "öğle yemeği",
        "brunch":       "brunch",
        "mülakat":      "iş mülakatı",
        "interview":    "iş mülakatı",
        "düğün":        "düğün",
        "wedding":      "düğün",
        "mezuniyet":    "mezuniyet töreni",
        "graduation":   "mezuniyet töreni",
        "doğum günü":   "doğum günü partisi",
        "birthday":     "doğum günü partisi",
        "konser":       "konser",
        "concert":      "konser",
        "spor":         "spor aktivitesi",
        "gym":          "spor salonu",
        "koşu":         "koşu",
        "running":      "koşu",
        "yoga":         "yoga",
        "date":         "randevu",
        "toplantı":     "iş toplantısı",
        "meeting":      "iş toplantısı",
        "sunum":        "sunum",
        "presentation": "sunum",
        "iş gezisi":    "iş seyahati",
    }

    for keyword, detail in detail_map.items():
        if keyword in msg:
            return detail

    defaults = {
        "casual":   "günlük aktivite",
        "formal":   "resmi etkinlik",
        "date":     "randevu",
        "business": "iş toplantısı",
        "sport":    "spor aktivitesi",
        "party":    "parti",
    }
    return defaults.get(occasion, occasion)


def _get_weather_note(weather_desc: str) -> str | None:
    for key, note in WEATHER_NOTES.items():
        if key in weather_desc:
            return note
    return None


def _temp_note(temperature: int) -> str | None:
    if temperature >= 28:
        return f"Orada hava {temperature}°C — oldukça sıcak, hafif giyinmeyi öneririm."
    if temperature >= 20:
        return f"Orada hava {temperature}°C — ılıman ve güzel."
    if temperature >= 12:
        return f"Orada hava {temperature}°C — serin, bir kat fazla almak iyi olabilir."
    if temperature >= 0:
        return f"Orada hava {temperature}°C — soğuk, kalın giyinmeyi unutma!"
    return f"Orada hava {temperature}°C — çok soğuk, iyi havalandırın!"
