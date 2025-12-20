#define PRICE_GOD_ARTIFACT 6000
#define PRICE_SUBGOD_ARTIFACT 3000
#define PRICE_BOSS_ARTIFACT 1000
#define PRICE_ARTIFACT 500

/datum/outfit/artifact
	head = /obj/item/clothing/head/leather/duelhat
	mask = /obj/item/clothing/face/facemask/steel/harlequin
	armor = /obj/item/clothing/armor/plate/full/matthios
	cloak = /obj/item/clothing/cloak/graggar
	shirt = /obj/item/clothing/shirt/undershirt/artificer
	shoes = /obj/item/clothing/shoes/nobleboot/duelboots
	pants = /obj/item/clothing/pants/trou/leathertights

/obj/effect/mob_spawn/human/elf/artifact
	outfit = /datum/outfit/artifact

/datum/trader_data/artifact_weapons
	name = "Artifact"
	outfit_override = list(/obj/effect/mob_spawn/human/elf/artifact)

	initial_products = list()
	max_custom_items = 1
	custom_items = list(
		/obj/item/weapon/flail/peasantwarflail/matthios = list(1, PRICE_SUBGOD_ARTIFACT, 1),
		/obj/item/weapon/sword/long/martyr = list(1, PRICE_SUBGOD_ARTIFACT, 1),
		/obj/item/weapon/greataxe/dreamscape = list(1, PRICE_SUBGOD_ARTIFACT, 1),
		/obj/item/weapon/greataxe/steel/doublehead/graggar = list(1, PRICE_SUBGOD_ARTIFACT, 1),
		/obj/item/weapon/polearm/woodstaff/naledi = list(1, PRICE_BOSS_ARTIFACT, 1),
		/obj/item/weapon/polearm/halberd/bardiche/woodcutter/gorefeast = list(1, PRICE_GOD_ARTIFACT, 1),
		/obj/item/weapon/polearm/neant = list(1, PRICE_GOD_ARTIFACT, 1),
		/obj/item/gun/ballistic/revolver/grenadelauncher/bow/turbulenta = list(1, PRICE_GOD_ARTIFACT, 1),
		/obj/item/weapon/sword/long/pleonexia = list(1, PRICE_GOD_ARTIFACT, 1),
		/obj/item/flashlight/flare/torch/lantern/psycenser = list(1, PRICE_ARTIFACT, 1),
	)

	initial_wanteds = list(
		/obj/item/ore/gold = list(20, INFINITY, ""),
		/obj/item/gem = list(30, INFINITY, ""),
	)

	// Custom trader dialogue
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"These trinkets are beneath my notice. Bring me something of true value.",
			"I deal only in the finest artifacts. This... this is not worthy.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"Perhaps you need more time to consider such a momentous purchase.",
			"The artifacts will wait for a worthy owner.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"May this ancient weapon serve you well in battle.",
			"You have chosen wisely. This artifact has a storied history.",
		),
		INTERESTED_PHRASE = list(
			"Ah, that item catches my eye! I would pay handsomely for such a piece.",
			"Now that is something I could add to my collection.",
		),
		BUY_PHRASE = list(
			"A fine addition to my inventory. You have my thanks.",
			"Excellent! This will complement my other wares perfectly.",
		),
		NO_CASH_PHRASE = list(
			"These are artifacts of legend, not common trinkets. Return when your purse is heavier.",
			"Six thousand gold pieces is the price. No credit, no exceptions.",
		),
		NO_STOCK_PHRASE = list(
			"That particular artifact has already found a new owner.",
			"Alas, that weapon has been claimed by another adventurer.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I have no need for such items at this time.",
			"My collection is complete for now. Perhaps another day.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This holds no value to one who deals in legendary artifacts.",
			"Worthless baubles have no place in my shop.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already possess enough of these items.",
			"My vaults are full of such things already.",
		),
		TRADER_LORE_PHRASE = list(
			"Welcome, seeker of legendary weapons! Each artifact here has tasted blood in epic battles.",
			"These weapons carry the souls of ancient warriors. Choose carefully.",
			"I have traveled the world collecting these legendary arms. Each tells a story of glory and conquest.",
			"Six thousand gold pieces may seem steep, but these are weapons of legend!",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I seek nothing at this moment. My focus is on selling these magnificent artifacts.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"My vault is temporarily empty, but check back soon for new arrivals.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"You dare steal from a dealer of legendary weapons? Face my wrath!",
			"Fool! These artifacts will defend themselves!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"The artifacts... have chosen... a new master...",
			"Perhaps... you were... worthy after all...",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Greetings, warrior! Behold my collection of legendary artifacts!",
			"Welcome to my shop of wonders! Each weapon here is worth a king's ransom!",
		),
	)

#undef PRICE_GOD_ARTIFACT
#undef PRICE_SUBGOD_ARTIFACT
#undef PRICE_BOSS_ARTIFACT
#undef PRICE_ARTIFACT
