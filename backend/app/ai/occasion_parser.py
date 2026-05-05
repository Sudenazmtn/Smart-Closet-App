OCCASION_KEYWORD = {
    "casual" : ["everyday" , "chill" , "relaxed" , "normal", 
                "daily", "park", "grocery", "shopping", "walk", 
                "hangout", "friends", "weekend", "errand", "brunch",
                ],

    "formal" : ["formal", "gala", "ceremony", "wedding", "graduation",
                "cocktail", "black tie", "groom", "bride", "banquet" ,
                ],

    "date": [
        "date", "coffee date", "dinner date", "romantic",
        "anniversary", "valentine", "first date", "night out",
        "restaurant", "picnic date",
    ],
    "business": [
        "business", "work", "meeting", "office", "presentation",
        "conference", "client", "interview", "professional", "seminar",
    ],
    "sport": [
        "sport", "gym", "fitness", "running", "yoga",
        "workout", "training", "match", "hiking", "cycling",
    ],
    "party": [
        "party", "club", "birthday", "celebration", "festival",
        "night out", "rave", "gathering", "event", "concert",
    ],
}


def parse_occasion(message: str) -> str:
    msg = message.lower()
    for occasion, keywords in OCCASION_KEYWORD.items():
        if any (keyword in msg for keyword in keywords):
            return occasion
    return "casual"



    


    


    




