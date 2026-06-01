import os
import json
import anthropic

_client = anthropic.Anthropic(api_key=os.getenv('CLAUDE_API_KEY'))

def get_outfit_suggestion(
    wardrobe: str,
    event_type: str,
    weather: str,
    temperature: int,
) -> dict:
    prompt = f"""You are a professional fashion stylist for the SmartCloset app.

User's wardrobe (ID | Name | Category | Color | Season):
{wardrobe}

Today:
- Event: {event_type}
- Weather: {weather}
- Temperature: {temperature}°C

Suggest the best outfit from the wardrobe above.
Respond ONLY in this JSON format, no extra text, no markdown:
{{
  "item_ids": [1, 3, 7],
  "style_name": "Chic casual",
  "note": "Short 1-2 sentence explanation."
}}

Rules:
- Only use IDs that exist above.
- Choose 2-4 items.
- Consider weather and event type."""

    message = _client.messages.create(
        model='claude-haiku-4-5-20251001',
        max_tokens=512,
        messages=[{'role': 'user', 'content': prompt}],
    )

    text = message.content[0].text.strip()
    return json.loads(text)