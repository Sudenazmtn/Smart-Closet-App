import os
import json
import anthropic

_client: anthropic.Anthropic | None = None

def _get_client() -> anthropic.Anthropic:
    global _client
    if _client is None:
        api_key = os.getenv('CLAUDE_API_KEY')
        if not api_key:
            raise ValueError("CLAUDE_API_KEY environment variable is not set")
        _client = anthropic.Anthropic(api_key=api_key)
    return _client

def generate_outfit_response(
    outfit_items:     list[dict],
    event_type:       str,
    weather:          str,
    temperature:      int,
    user_message:     str,
    destination_city: str | None = None,
    score:            float      = 0.0,
    feels_like:       int | None = None,
    weather_type:     str        = "cloudy",
) -> dict:
    client = _get_client()

    if not outfit_items:
        return {
            "message":   "Gardırobunda bu etkinlik için uygun bir kombin oluşturamadım. Daha fazla kıyafet eklemeyi dene!",
            "style_tip": None,
        }

    items_lines = []
    for item in outfit_items:
        name     = item.get("name", "")
        category = item.get("category", "")
        color    = item.get("color", "")
        season   = item.get("season", "")
        worn     = item.get("wear_count", 0)
        items_lines.append(
            f"  - {name} ({category}, {color}, {season} mevsimlik)"
            + (f" — {worn} kez giyildi" if worn > 0 else " — hiç giyilmedi")
        )
    items_text = "\n".join(items_lines)

    event_labels = {
        "casual":   "günlük/rahat",
        "formal":   "resmi/zarif",
        "date":     "randevu/özel buluşma",
        "business": "iş/profesyonel",
        "sport":    "spor/aktif",
        "party":    "parti/eğlence",
    }
    event_label = event_labels.get(event_type.lower(), event_type)
    score_pct   = int(score * 100)
    fl          = feels_like if feels_like is not None else temperature
    city_line   = f"- Şehir/destinasyon: {destination_city}" if destination_city else ""

    weather_type_labels = {
        "rain":   "yağmurlu",
        "snow":   "karlı",
        "storm":  "fırtınalı",
        "sunny":  "güneşli",
        "windy":  "rüzgarlı",
        "cloudy": "bulutlu",
    }
    wt_label = weather_type_labels.get(weather_type, weather_type)

    prompt = f"""Sen SmartCloset uygulamasının deneyimli ve samimi bir moda stilistisin.
Kullanıcının gardırobundan bu kombini seçtin:

{items_text}

Bağlam:
- Kullanıcı mesajı: "{user_message}"
- Etkinlik türü: {event_label}
- Gerçek sıcaklık: {temperature}°C  |  Hissedilen: {fl}°C
- Hava durumu: {weather} ({wt_label})
{city_line}
- Kombin uyum skoru: %{score_pct}

Görevin:
1. Bu kombini neden bu etkinlik ve hava koşulları için uygun olduğunu açıkla.
2. Her kıyafet parçasının adını kullan.
3. Varsa şehir/destinasyon bilgisini dahil et.
4. Sona kısa ve uygulanabilir bir stil ipucu ekle.

Kurallar:
- Türkçe yaz, samimi ve güven veren bir ton kullan.
- 3-5 cümle arası tut.
- Markdown, emoji, bullet point kullanma, sadece düz metin.
- Teknik terimler kullanma, sanki sen seçmişsin gibi yaz.

YALNIZCA şu JSON formatında yanıt ver:
{{
  "message": "Kombin açıklaması burada.",
  "style_tip": "Kısa stil ipucu burada."
}}"""

    response = client.messages.create(
        model="claude-haiku-4-5-20251001",
        max_tokens=600,
        messages=[{"role": "user", "content": prompt}],
    )

    raw = response.content[0].text.strip()

    if raw.startswith("```"):
        raw = raw.split("```")[1]
        if raw.startswith("json"):
            raw = raw[4:]
        raw = raw.strip()

    return json.loads(raw)
