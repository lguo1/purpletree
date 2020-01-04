from setup import db, Event
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
homeImageName = "EldridgeH(1).png",
detailImageName = "EldridgeD.png",
start = "2019/11/19 16:30",
end = "2019/11/19 18:00",
category = "Philosophy",
location = "Mccabe Atrium",
current = True,
red = 0.4,
green = 0,
blue = 0,
organizer = "PPE Club",
description = "What is Courage? Is it, as was in Harry Potter, a fearless determination to fight evil? If so, how is courage different from goodness, recklessness, or wisdom? By contrasting different theories, Professor Richard Eldridge will examine the meaning of courage. He will connect courage with Werner Herzog's films and show how it might be relevant in our modern consumerist society."
)
session.add(Eldridge)
session.commit()

Pettit = Event(
id = "2",
speakerHome = "Philip\nPettit",
speaker = "Philip Pettit",
speakerTitle = "Philosophy Professor",
time = "4:30 - 6 PM",
season = "Fall",
year = "20",
homeImageName= "PettitH.png",
detailImageName = "PettitD.png",
category = "Philosophy",
location = "Mccabe Atrium",
current = False,
red = 0.2,
green = 0.2,
blue = 0.4,
organizer = "PPE Club",
description = "Philip Pettit is the Laurence S. Rockefeller University Professor of Politics and Human Values at Princeton University, where he has taught political theory and philosophy since 2002. He works in moral and political theory and on background issues in the philosophy of mind and metaphysics.")
session.add(Pettit)
session.commit()

Rumelin = Event(
id = "3",
speakerHome = "Julian\nNida\nRumelin",
speaker = "Julian Nida Rumelin",
speakerTitle = "Philosophy Professor",
time = "4:30 - 6 PM",
season = "Fall",
year = "20",
homeImageName = "RumelinH.png",
detailImageName = "RumelinD.png",
category = "Philosophy",
location = "Mccabe Atrium",
current = False,
red = 1,
green = 0.6,
blue = 0.2,
organizer = "PPE Club",
description = "Julian Nida-Rümelin (born November 28, 1954) is a German philosopher and public intellectual. He served as State Minister for Culture of the Federal Republic of Germany under Chancellor Schröder. Nida-Rümelin propounds an approach to practical philosophy based on his theory of “Structural Rationality.” As an alternative to consequentialism, it avoids the dichotomy between moral and extra-moral rationality that is typical in Kantian approaches, and is thus able to integrate a vast complexity of practical reasons that result in coherent practice.")
session.add(Rumelin)
session.commit()

Simon = Event(
id = "4",
speakerHome = "David\nSimon",
speaker = "David Simon",
speakerTitle = "Film Director & Journalist",
time = "4:30 - 6 PM",
season = "Spring",
year = "20",
homeImageName = "SimonH(2).png",
detailImageName = "SimonD(1).png",
category = "Arts",
location = "Mccabe Atrium",
current = False,
red = 0,
green = 0.2,
blue = 0.2,
organizer = "PPE Club",
description = "David Simon is best known for his work on The Wire, which is a HBO series focusing on the illegal drug trade of Baltimore city. Simon notes that '[The Wire] is a deliberate argument that unencumbered capitalism is not a substitute for social policy; that on its own, without a social compact, raw capitalism is destined to serve the few at the expense of the many.' Before becoming a producer, Simon worked for the Baltimore Sun City Desk for twelve years (1982–95), wrote Homicide: A Year on the Killing Streets (1991), and co-wrote The Corner: A Year in the Life of an Inner-City Neighborhood (1997).")
session.add(Simon)
session.commit()
