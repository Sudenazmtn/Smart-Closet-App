
from __future__ import annotations
import os, random
import numpy as np
import pandas as pd

random.seed(42)
np.random.seed(42)

TOPS    = ["t-shirt","shirt","blouse","sweater","hoodie","blazer","dress","cardigan","tank-top","polo"]
BOTTOMS = ["jeans","trousers","shorts","skirt","leggings","sweatpants"]
SHOES   = ["sneakers","heels","boots","loafers","sandals","oxfords"]
COLORS  = ["white","black","navy","gray","beige","blue","red","green","brown","pink","yellow","burgundy","purple","orange"]
OCCASIONS     = ["casual","formal","date","business","sport","party"]
WEATHER_TYPES = ["sunny","cloudy","rain","snow","storm","windy"]

_TOP_W = {
    "summer": {"t-shirt":5,"tank-top":4,"blouse":3,"polo":2,"shirt":2,"dress":3,"hoodie":0,"sweater":0,"blazer":1,"cardigan":1},
    "winter": {"sweater":5,"hoodie":4,"blazer":3,"cardigan":3,"shirt":2,"blouse":2,"dress":1,"t-shirt":1,"tank-top":0,"polo":1},
    "spring": {"shirt":4,"blouse":4,"t-shirt":3,"polo":3,"cardigan":3,"dress":3,"blazer":2,"hoodie":2,"sweater":2,"tank-top":1},
    "fall":   {"sweater":4,"blazer":4,"shirt":3,"hoodie":3,"cardigan":3,"blouse":2,"t-shirt":2,"dress":1,"tank-top":0,"polo":2},
}
_BOT_W = {
    "summer": {"shorts":5,"skirt":4,"jeans":3,"leggings":2,"trousers":2,"sweatpants":0},
    "winter": {"jeans":4,"trousers":4,"leggings":4,"sweatpants":3,"skirt":1,"shorts":0},
    "spring": {"jeans":4,"trousers":3,"skirt":3,"shorts":2,"leggings":2,"sweatpants":1},
    "fall":   {"jeans":5,"trousers":4,"leggings":3,"skirt":2,"shorts":1,"sweatpants":2},
}
_SHOE_W = {
    "summer": {"sandals":5,"sneakers":4,"loafers":3,"heels":2,"boots":0,"oxfords":1},
    "winter": {"boots":5,"sneakers":3,"loafers":2,"oxfords":2,"heels":1,"sandals":0},
    "spring": {"sneakers":4,"loafers":4,"sandals":2,"boots":2,"heels":2,"oxfords":2},
    "fall":   {"boots":4,"sneakers":4,"loafers":3,"oxfords":3,"heels":2,"sandals":0},
}
_OCC_TOP_BIAS = {
    "casual":{"t-shirt":4,"hoodie":3,"polo":2},
    "formal":{"shirt":4,"blazer":4,"dress":3,"blouse":3},
    "date":  {"dress":4,"blouse":3,"shirt":2},
    "business":{"shirt":4,"blazer":4,"blouse":3},
    "sport": {"t-shirt":5,"tank-top":4,"hoodie":2},
    "party": {"dress":5,"blouse":3,"blazer":2},
}
_OCC_COLOR_BIAS = {
    "casual":  {"white":3,"navy":3,"gray":3,"black":2,"blue":2},
    "formal":  {"black":4,"navy":3,"white":3,"gray":2,"burgundy":2},
    "date":    {"burgundy":3,"black":3,"navy":2,"red":2,"pink":2},
    "business":{"navy":4,"gray":3,"black":3,"white":3,"beige":2},
    "sport":   {"black":3,"gray":3,"navy":2,"blue":2,"white":2},
    "party":   {"black":3,"red":3,"burgundy":2,"pink":2,"purple":2},
}

def _wc(w: dict) -> str:
    keys  = list(w.keys())
    probs = np.array([w[k] for k in keys], dtype=float)
    probs = probs / probs.sum()
    return np.random.choice(keys, p=probs)

def _season(t: int) -> str:
    if t >= 23: return "summer"
    if t >= 13: return "spring"
    if t >= 4:  return "fall"
    return "winter"

def _feels_like(t: int, wt: str) -> int:
    if wt == "snow":   return t + random.randint(-8, -3)
    if wt in ("rain","storm"): return t + random.randint(-5, -1)
    if wt == "sunny" and t >= 22: return t + random.randint(1, 5)
    return t + random.randint(-2, 2)

def _season_match(top: str, bot: str, shoe: str, t: int) -> float:
    s = _season(t)
    sc = []
    if s == "summer":
        sc.append(1.0 if top in ("t-shirt","tank-top","blouse","polo","dress") else
                  0.85 if top in ("shirt",) else 0.5 if top in ("cardigan",) else
                  0.2 if top in ("sweater","hoodie") else 0.6)
    elif s == "winter":
        sc.append(1.0 if top in ("sweater","hoodie","blazer","cardigan") else
                  0.7 if top in ("shirt","blouse","polo") else
                  0.2 if top in ("t-shirt","tank-top") else 0.6)
    else:
        sc.append(1.0 if top in ("shirt","blouse","polo","cardigan","blazer") else
                  0.85 if top in ("t-shirt","hoodie","sweater","dress") else 0.7)
    if s == "summer":
        sc.append(1.0 if bot in ("shorts","skirt") else 0.7 if bot in ("jeans","leggings") else 0.4)
    elif s == "winter":
        sc.append(1.0 if bot in ("jeans","trousers","leggings","sweatpants") else 0.1 if bot == "shorts" else 0.7)
    else:
        sc.append(0.8)
    if s == "summer":
        sc.append(1.0 if shoe in ("sandals","sneakers") else 0.75 if shoe in ("loafers","heels") else 0.2 if shoe == "boots" else 0.6)
    elif s == "winter":
        sc.append(1.0 if shoe == "boots" else 0.8 if shoe in ("sneakers","loafers","oxfords") else 0.05 if shoe == "sandals" else 0.6)
    else:
        sc.append(0.8)
    return round(sum(sc) / len(sc), 3)

_CCOMPAT: dict[frozenset, float] = {
    frozenset({"black","white"}):1.0, frozenset({"black","gray"}):1.0,
    frozenset({"black","red"}):0.9,   frozenset({"black","burgundy"}):0.9,
    frozenset({"black","beige"}):0.8, frozenset({"black","blue"}):0.8,
    frozenset({"white","navy"}):1.0,  frozenset({"white","blue"}):1.0,
    frozenset({"white","gray"}):0.95, frozenset({"white","red"}):0.85,
    frozenset({"white","beige"}):0.85,frozenset({"white","burgundy"}):0.85,
    frozenset({"gray","navy"}):0.90,  frozenset({"gray","burgundy"}):0.85,
    frozenset({"gray","blue"}):0.85,  frozenset({"gray","beige"}):0.85,
    frozenset({"navy","beige"}):1.0,  frozenset({"navy","burgundy"}):0.90,
    frozenset({"navy","red"}):0.80,   frozenset({"beige","brown"}):1.0,
    frozenset({"beige","burgundy"}):0.90, frozenset({"brown","burgundy"}):0.85,
    frozenset({"blue","orange"}):0.80,frozenset({"green","brown"}):0.85,
    frozenset({"red","burgundy"}):0.40,frozenset({"red","pink"}):0.35,
    frozenset({"red","orange"}):0.35, frozenset({"pink","orange"}):0.40,
    frozenset({"yellow","orange"}):0.45,
}

def _cpair(c1: str, c2: str) -> float:
    if c1 == c2: return 0.65
    return _CCOMPAT.get(frozenset({c1, c2}), 0.55)

def _score(top, tc, bot, bc, shoe, sc, occ, t, fl, wt, sm) -> float:
    E_TOP = {
        "casual":  {"t-shirt":1.0,"hoodie":0.9,"polo":0.85,"dress":0.7,"blouse":0.75,"shirt":0.8,"cardigan":0.8,"blazer":0.4,"sweater":0.8,"tank-top":0.85},
        "formal":  {"shirt":1.0,"blazer":1.0,"blouse":0.9,"dress":0.9,"sweater":0.5,"cardigan":0.6,"t-shirt":0.2,"hoodie":0.0,"polo":0.6,"tank-top":0.1},
        "date":    {"dress":1.0,"blouse":0.9,"shirt":0.8,"blazer":0.75,"sweater":0.7,"cardigan":0.65,"t-shirt":0.4,"hoodie":0.3,"polo":0.55,"tank-top":0.5},
        "business":{"shirt":1.0,"blazer":1.0,"blouse":0.9,"dress":0.9,"polo":0.7,"cardigan":0.7,"sweater":0.6,"t-shirt":0.4,"hoodie":0.1,"tank-top":0.2},
        "sport":   {"t-shirt":1.0,"tank-top":1.0,"hoodie":0.7,"polo":0.6,"shirt":0.3,"blouse":0.1,"dress":0.1,"blazer":0.0,"sweater":0.15,"cardigan":0.2},
        "party":   {"dress":1.0,"blouse":0.8,"blazer":0.8,"shirt":0.7,"t-shirt":0.3,"hoodie":0.1,"sweater":0.2,"cardigan":0.4,"polo":0.4,"tank-top":0.5},
    }
    E_BOT = {
        "casual":  {"jeans":1.0,"shorts":0.9,"leggings":0.8,"skirt":0.75,"trousers":0.65,"sweatpants":0.7},
        "formal":  {"trousers":1.0,"skirt":0.85,"jeans":0.3,"shorts":0.0,"leggings":0.4,"sweatpants":0.0},
        "date":    {"jeans":0.75,"skirt":0.9,"trousers":0.8,"shorts":0.5,"leggings":0.5,"sweatpants":0.1},
        "business":{"trousers":1.0,"skirt":0.75,"jeans":0.5,"leggings":0.5,"shorts":0.0,"sweatpants":0.0},
        "sport":   {"shorts":1.0,"leggings":1.0,"sweatpants":0.9,"jeans":0.2,"trousers":0.1,"skirt":0.1},
        "party":   {"skirt":1.0,"jeans":0.65,"trousers":0.6,"shorts":0.3,"leggings":0.35,"sweatpants":0.0},
    }
    E_SHOE = {
        "casual":  {"sneakers":1.0,"sandals":0.85,"loafers":0.8,"boots":0.7,"heels":0.35,"oxfords":0.55},
        "formal":  {"heels":1.0,"oxfords":1.0,"loafers":0.8,"boots":0.65,"sneakers":0.15,"sandals":0.25},
        "date":    {"heels":0.9,"boots":0.8,"loafers":0.7,"sandals":0.75,"sneakers":0.55,"oxfords":0.75},
        "business":{"oxfords":0.95,"heels":0.85,"loafers":0.85,"boots":0.75,"sneakers":0.35,"sandals":0.30},
        "sport":   {"sneakers":1.0,"sandals":0.25,"boots":0.2,"loafers":0.1,"heels":0.0,"oxfords":0.0},
        "party":   {"heels":1.0,"boots":0.75,"sandals":0.7,"loafers":0.55,"sneakers":0.25,"oxfords":0.6},
    }

    def _tf(cat, feels):
        heavy  = {"sweater","hoodie","blazer","cardigan","boots"}
        light  = {"t-shirt","tank-top","shorts","skirt","sandals","dress"}
        if cat in heavy:
            return 0.1 if feels>=26 else 0.5 if feels>=18 else 0.8 if feels>=10 else 1.0
        elif cat in light:
            return 1.0 if feels>=26 else 0.85 if feels>=18 else 0.55 if feels>=10 else 0.2 if feels>=2 else 0.0
        else:
            return 0.75 if feels>=26 else 1.0 if feels>=18 else 0.95 if feels>=10 else 0.70 if feels>=2 else 0.5

    ev  = (E_TOP.get(occ,E_TOP["casual"]).get(top,0.5) +
           E_BOT.get(occ,E_BOT["casual"]).get(bot,0.5) +
           E_SHOE.get(occ,E_SHOE["casual"]).get(shoe,0.5)) / 3
    tmp = (_tf(top,fl) + _tf(bot,fl) + _tf(shoe,fl)) / 3
    col = (_cpair(tc,bc) + _cpair(tc,sc) + _cpair(bc,sc)) / 3

    wp = 0.0
    if wt in ("rain","storm"):
        if tc in ("white","beige") or bc in ("white","beige"): wp += 0.10
        if shoe == "sandals": wp += 0.25
        if bot in ("shorts","skirt"): wp += 0.15
    elif wt == "snow":
        if shoe == "sandals": wp += 0.40
        if bot == "shorts":   wp += 0.35
        if top in ("t-shirt","tank-top") and fl <= 5: wp += 0.30
    elif wt == "windy":
        if bot in ("skirt","shorts"): wp += 0.20
        if top in ("tank-top",):      wp += 0.10

    raw = ev*0.35 + tmp*0.25 + col*0.25 + max(0,1-wp)*0.10 + sm*0.05
    return float(np.clip(raw + np.random.normal(0, 0.025), 0.0, 1.0))

def generate(n: int = 6000) -> pd.DataFrame:
    rows = []
    occ_cycle = OCCASIONS * (n // len(OCCASIONS) + 1)
    random.shuffle(occ_cycle)

    for i in range(n):
        occ  = occ_cycle[i]
        temp = int(np.random.choice(
            [2,5,8,10,12,15,18,20,22,25,28,32],
            p=[0.04,0.06,0.07,0.08,0.08,0.10,0.10,0.10,0.10,0.10,0.09,0.08]
        ))
        season = _season(temp)
        wt     = random.choice(["sunny","sunny","cloudy","cloudy","rain","windy"] if temp>5 else ["snow","snow","cloudy","rain","storm","cloudy"])
        fl     = _feels_like(temp, wt)

        tw = dict(_TOP_W[season])
        for k, v in _OCC_TOP_BIAS.get(occ, {}).items():
            tw[k] = tw.get(k, 1) + v
        top = _wc(tw)

        bot  = "none" if top == "dress" else _wc(_BOT_W[season])
        shoe = _wc(_SHOE_W[season])

        cw = dict(_OCC_COLOR_BIAS.get(occ, {}))
        for c in COLORS:
            if c not in cw: cw[c] = 1
        tc = _wc(cw)
        bc = _wc(cw) if bot != "none" else "none"
        sc = _wc(cw)

        sm    = _season_match(top, bot if bot != "none" else top, shoe, temp)
        score = _score(top, tc, bot if bot != "none" else top,
                       bc if bc != "none" else tc, shoe, sc, occ, temp, fl, wt, sm)

        rows.append({"top":top,"top_color":tc,
                     "bottom":bot if bot!="none" else "none",
                     "bottom_color":bc if bc!="none" else "none",
                     "shoes":shoe,"shoes_color":sc,
                     "occasion":occ,"temperature":temp,
                     "feels_like":fl,"weather_type":wt,
                     "season_match":round(sm,3),"score":round(score,3)})

    df = pd.DataFrame(rows)
    print(f"[Dataset] {len(df)} satir uretildi. Skor ort: {df['score'].mean():.3f}")
    return df

if __name__ == "__main__":
    out = os.path.join(os.path.dirname(__file__), "outfit_data.csv")
    generate(6000).to_csv(out, index=False)
    print(f"Kaydedildi: {out}")
