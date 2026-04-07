/datum/patron/godless
	abstract_type = /datum/patron/godless
	associated_faith = /datum/faith/godless

/datum/patron/godless/can_pray(mob/living/follower)
	// Redefined this entire proc just to tell you:
	// Yes, the godless can pray. This is intentional.
	// Maybe they pray to themselves?
	return TRUE

/datum/patron/godless/hear_prayer(mob/living/follower, message)
	return FALSE

/datum/patron/godless/godless //lol lmao
	name = "Godless"
	domain = "Abandonment of the Gods"
	desc = "Worship of the gods is foolish! Gods exist, but you refuse to worship them due to your own hubris."
	flaws = "Stubborn, Unrelenting, Misguided"
	worshippers = "Egomaniacs, Heretics, the Ignorant"
	sins = "Idolatry, Worship, Blind Faith"
	boons = "None, you godless heathen."

	confess_lines = list(
		"NO GODS, NO MASTERS! THERE IS ONLY ME!",
		"A MAN CHOOSES, A SLAVE OBEYS - I WILL BE FREE FROM THE GODS!",
		"THE OLD WAYS WILL CRUMBLE, THE GODS ARE UNJUST!"
	)

/datum/patron/godless/autotheist
	name = "Autotheist"
	domain = "Self-Deification"
	desc = "Forget the Divine Pantheon, YOU are a god! The mortals don't know it, but you walk alongside them in your shell. You are the true ruler of this world!"
	flaws = "Stubborn, Pride, Superiority"
	worshippers = "Egomaniacs, The Self-Obsessed, Megalomaniacs"
	sins = "Humility, Self-Doubt"
	boons = "None."

	confess_lines = list(
		"I AM THE ONLY TRUE GOD!",
		"MY WILL IS THE ONLY LAW!",
		"WHAT IS A GOD BUT MYSELF!"
	)

/datum/patron/godless/defiant
	name = "Defiant"
	domain = "Rejection of Gods"
	desc = "You have a grave distaste for authority, so much so to the point where you decided that you refuse to worship the gods! They are merely another form of authority, and you will never bow down to them."
	flaws = "Defiant, Rebellious, Unrelenting"
	worshippers = "Anarchists, Rebels" //fuck the system, og
	sins = "Obedience, Submission"
	boons = "None."

	confess_lines = list(
		"I WILL NEVER BOW TO ANYONE- NOT EVEN THE DIVINE!",
		"A MAN CHOOSES, A SLAVE OBEYS! I WILL BE FREE FROM THE GODS!",
		"NOBODY HOLDS AUTHORITY OVER ME, NOT EVEN THE GODS!"
	)

/datum/patron/godless/dystheist
	name = "Dystheist"
	domain = "Rejection of Gods"
	desc = "You see the gods for what they truly are: powerful, yet flawed and unworthy of worship."
	flaws = "Cynical, Judgmental"
	worshippers = "Skeptics, The Disillusioned"
	sins = "Blind Faith"
	boons = "None."

	confess_lines = list(
		"THE GODS MEAN NOTHING TO ME!",
		"THE TEN ARE FLAWED!",
		"I WILL NEVER BOW DOWN TO ANY OF THOSE TYRANTS, DIVINE NOR INHUMEN!"
	)

/datum/patron/godless/naivety
	name = "Naivety"
	domain = "Indifference"
	desc = "Either due to never being informed, a memory issue, or perhaps a brain injury, you have no clue what gods are!"
	flaws = "Ignorant, Naive, Stupid"
	worshippers = "Younglings, Ignorant, Fools"
	sins = "..What's that?"
	boons = "..What is that?"
	confess_lines = list(
		"I DON'T KNOW WHAT YOU'RE TALKING ABOUT!",
		"WHAT'S A GOD?!",
		"NOBODY EVER TOLD ME ABOUT THE DIVINE!"
	)

/datum/patron/godless/rashan
	name = "Rashan-Kahl"
	domain = "Twin-faced god of ambition and chains"
	desc = "Rashan represents both creation and destruction, freedom and bondage: a duality that mirrors the rakshari's complex relationship with power. Temples to Rashan-Kahl often double as marketplaces, symbolizing the transactional nature of life."
	flaws = "Flaws of their followers"
	worshippers = "Rakshari, Slavers, His Majesty"
	sins = "Sins of their Followers"
	boons = "The will to meow"
	confess_lines = list(
		"WHAT MUST I PAY FOR THE PAIN TO STOP!",
		"I AM UNCHAINED!!",
		"I AM PROMISED FREEDOM",
		"MY GOD IS FREEDOM WHILE YOURS ARE SHACKLES!",
		"RASHAN-KAHL WILL ENSLAVE YOU!"
	)
	allowed_races = list(SPEC_ID_RAKSHARI)

/datum/patron/godless/galadros
	name = "Galadros"
	domain = "The Great Wyrm in the heart of Kruskros, Krusnakell"
	desc = "Galadros has brought himself to reverential status among Kobolds through generational servitude. They feed him the lux of the mountain. He gives their short lives purpose. For them, this is everything."
	flaws = "Ignorance, Co-dependency, Stubbornness"
	worshippers = "Kobolds, His Offspring"
	sins = "Self-dependency, Failing your sire, Discouraging servantry"
	boons = "A sense of purpose and accomplishment!"
	confess_lines = list(
		"I'LL NEVER LET YOU DOWN AGAIN!!",
		"I HAVE FAILED YOU, MASTER!",
		"HE IS HUNGRY! I MUST TO FEED HIM!!",
		"I FIND PURPOSE THROUGH SERVITUDE!",
		"THE GREAT WYRM WILL DEVOUR YOU!!",
	)
	allowed_races = list(SPEC_ID_KOBOLD)
