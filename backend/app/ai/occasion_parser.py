OCCASION_KEYWORD = {
    "casual": [
        "everyday", "chill", "relaxed", "normal",
        "daily", "park", "grocery", "shopping", "walk",
        "hangout", "friends", "weekend", "errand", "brunch",
        "günlük", "rahat", "arkadaş", "alışveriş", "yürüyüş",
        "piknik", "kahvaltı", "market", "gezinti", "mahalle",
    ],
    "formal": [
        "formal", "gala", "ceremony", "wedding", "graduation",
        "cocktail", "black tie", "groom", "bride", "banquet",
        "düğün", "mezuniyet", "tören", "resmi", "nikah",
        "balo", "davet", "kokteyl",
    ],
    "date": [
        "date", "coffee date", "dinner date", "romantic",
        "anniversary", "valentine", "first date", "night out",
        "restaurant", "picnic date",
        "randevu", "sevgili", "romantik", "akşam yemeği",
        "kahve buluşması", "yıl dönümü", "özel gece",
    ],
    "business": [
        "business", "work", "meeting", "office", "presentation",
        "conference", "client", "interview", "professional", "seminar",
        "iş", "toplantı", "ofis", "sunum", "konferans",
        "müşteri", "mülakat", "profesyonel", "seminer", "görüşme",
        "iş gezisi", "iş seyahati",
    ],
    "sport": [
        "sport", "gym", "fitness", "running", "yoga",
        "workout", "training", "match", "hiking", "cycling",
        "spor", "koşu", "antrenman", "yürüyüş", "bisiklet",
        "maç", "tenis", "yüzme", "dağ", "kamp", "trekking",
    ],
    "party": [
        "party", "club", "birthday", "celebration", "festival",
        "night out", "rave", "gathering", "event", "concert",
        "parti", "doğum günü", "kutlama", "konser", "festival",
        "gece kulübü", "eğlence", "organizasyon", "dans", "dance",
    ],
}

CITY_MAP = {
    "istanbul": "Istanbul",
    "istanbula": "Istanbul",
    "istanbulda": "Istanbul",
    "istanbuldan": "Istanbul",
    "ankara": "Ankara",
    "ankaraya": "Ankara",
    "ankarada": "Ankara",
    "izmir": "Izmir",
    "izmire": "Izmir",
    "izmirde": "Izmir",
    "antalya": "Antalya",
    "antalyaya": "Antalya",
    "antalyada": "Antalya",
    "bursa": "Bursa",
    "bursaya": "Bursa",
    "bursada": "Bursa",
    "adana": "Adana",
    "konya": "Konya",
    "gaziantep": "Gaziantep",
    "mersin": "Mersin",
    "kayseri": "Kayseri",
    "eskisehir": "Eskisehir",
    "eskişehir": "Eskisehir",
    "trabzon": "Trabzon",
    "samsun": "Samsun",
    "diyarbakir": "Diyarbakir",
    "diyarbakır": "Diyarbakir",
    "van": "Van",
    "erzurum": "Erzurum",
    "malatya": "Malatya",
    "bodrum": "Bodrum",
    "fethiye": "Fethiye",
    "alanya": "Alanya",
    "marmaris": "Marmaris",
    "cappadocia": "Goreme",
    "kapadokya": "Goreme",
    "pamukkale": "Pamukkale",
    "efes": "Selcuk",
    "paris": "Paris",
    "london": "London",
    "londra": "London",
    "berlin": "Berlin",
    "amsterdam": "Amsterdam",
    "rome": "Rome",
    "roma": "Rome",
    "barcelona": "Barcelona",
    "madrid": "Madrid",
    "dubai": "Dubai",
    "new york": "New York",
    "newyork": "New York",
    "tokyo": "Tokyo",
}

def parse_occasion(message: str) -> str:
    msg = message.lower()
    for occasion, keywords in OCCASION_KEYWORD.items():
        if any(keyword in msg for keyword in keywords):
            return occasion
    return "casual"

def parse_destination_city(message: str) -> str | None:
    """
    Kullanıcı mesajından şehir/destinasyon adını çıkarır.
    Örnek: "Ankara'ya iş toplantısına gidiyorum" → "Ankara"
    """
    msg = message.lower()
    words = msg.replace("'", " ").replace(",", " ").replace(".", " ").split()

    for word in words:
        if word in CITY_MAP:
            return CITY_MAP[word]

    for key, city in CITY_MAP.items():
        if " " in key and key in msg:
            return city

    return None
