from setup import db, Event, Update
session = db.session

Eldridge = Event(
id = "1",
speakerHome = "Richard\nEldridge",
speaker = "Richard Eldridge",
speakerTitle = "Philosophy Professor",
time = "4:30 - 6 PM",
weekday = "Tuesday",
date = "Nov 19",
season = "Fall",
year = "2019",
imageHomeName = "EldridgeH(1).png",
imageDetailName = "EldridgeD.png",
category = "Philosophy",
location = "Mccabe Atrium",
current = True,
red = 0.4,
green = 0,
blue = 0,
description = "What is Courage? Is it, as was in Harry Potter, a fearless determination to fight evil? If so, how is courage different from goodness, recklessness, or wisdom? By contrasting different theories, Professor Richard Eldridge will examine the meaning of courage. He will connect courage with Werner Herzog’s films and show how it might be relevant in our modern consumerist society."
)
session.add(Eldridge)
session.commit()

Pettit = Event(
id = "2",
speakerHome = "Philip\nPettit",
speaker = "Philip Pettit",
speakerTitle = "Philosophy Professor",
time = "4:30 - 6 PM",
weekday = "TBD",
date = "TBD",
season = "Fall",
year = "20",
imageHomeName = "PettitH.png",
imageDetailName = "PettitD.png",
category = "Philosophy",
location = "Mccabe Atrium",
current = False,
red = 0.2,
green = 0.2,
blue = 0.4)
session.add(Pettit)
session.commit()

Rumelin = Event(
id = "3",
speakerHome = "Julian\nNida\nRumelin",
speaker = "Julian Nida Rumelin",
speakerTitle = "Philosophy Professor",
time = "4:30 - 6 PM",
weekday = "TBD",
date = "TBD",
season = "Fall",
year = "20",
imageHomeName = "RumelinH.png",
imageDetailName = "RumelinD.png",
category = "Philosophy",
location = "Mccabe Atrium",
current = False,
red = 1,
green = 0.6,
blue = 0.2)
session.add(Rumelin)
session.commit()
