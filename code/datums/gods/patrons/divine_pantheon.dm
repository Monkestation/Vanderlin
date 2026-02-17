GLOBAL_LIST_INIT(patron_sound_themes, list(
	ASTRATA = 'sound/magic/bless.ogg',
	NOC = 'sound/ambience/noises/mystical (4).ogg',
	EORA = 'sound/vo/female/gen/giggle (1).ogg',
	DENDOR = 'sound/magic/barbroar.ogg',
	MALUM = 'sound/magic/dwarf_chant01.ogg',
	XYLIX = 'sound/misc/gods/xylix_omen.ogg',
	NECRA = 'sound/ambience/noises/genspooky (1).ogg',
	ABYSSOR = 'sound/items/bucket_transfer (2).ogg',
	RAVOX = 'sound/vo/male/knight/rage (6).ogg',
	PESTRA = 'sound/magic/cosmic_expansion.ogg',
	ZIZO = 'sound/misc/gods/zizo_omen.ogg',
	GRAGGAR = 'sound/misc/gods/graggar_omen.ogg',
	BAOTHA = 'sound/misc/gods/baotha_omen.ogg',
	MATTHIOS = 'sound/misc/gods/matthios_omen.ogg'
))

/datum/patron/divine
	abstract_type = /datum/patron/divine
	associated_faith = /datum/faith/divine_pantheon
	profane_words = list("zizo", "cock", "dick", "fuck", "shit", "pussy", "cuck", "cunt", "asshole")
	var/associated_psycross = /obj/item/clothing/neck/psycross

/datum/patron/divine/can_pray(mob/living/carbon/human/follower)
	//you can pray anywhere inside a church
	if(istype(get_area(follower), /area/indoors/town/church))
		return TRUE

	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(!cross.obj_broken)
			return TRUE

	if(istype(follower.wear_wrists, associated_psycross) || istype(follower.wear_neck, associated_psycross) || istype(follower.get_active_held_item(), associated_psycross))
		return TRUE


	to_chat(follower, span_danger("I need an amulet of my patron, or a nearby Pantheon Cross, for my prayers to be heard..."))
	return FALSE

/* ----------------- */

/datum/patron/divine/astrata
	name = ASTRATA
	domain = "Goddess of Order, the Sun Queen"
	desc = "Crafted from the head of Psydon, twin of Noc. She gifted mankind the Sun, protecting Psydonia from all forces which may seek it harm: from both outside and within."
	flaws = "Tyrannical, Ill-Tempered, Uncompromising"
	worshippers = "Nobles, Zealots, Commoners"
	sins = "Betrayal, Sloth, Witchcraft"
	boons = "Your stamina regeneration delay is lowered during daytime."
	added_traits = list(TRAIT_APRICITY)
	devotion_holder = /datum/devotion/divine/astrata
	confess_lines = list(
		"ASTRATA IS MY LIGHT!",
		"ASTRATA BRINGS LAW!",
		"I SERVE THE GLORY OF THE SUN!",
	)
	storyteller = /datum/storyteller/astrata
	associated_psycross = /obj/item/clothing/neck/psycross/silver/astrata

/datum/patron/divine/noc
	name = NOC
	domain = "God of Knowledge, the Moon Prince"
	desc = "Crafted from the helmet of Psydon, twin of Astrata. He gifted mankind divine wisdom."
	flaws = "Cynical, Isolationist, Unfiltered Honesty"
	worshippers = "Magic Practitioners, Scholars, Scribes"
	sins = "Suppressing Truth, Burning Books, Censorship"
	boons = "You learn, dream, and teach apprentices slightly better. Access to roles with magic."
	added_traits = list(TRAIT_TUTELAGE)
	devotion_holder = /datum/devotion/divine/noc
	confess_lines = list(
		"NOC IS NIGHT!",
		"NOC SEES THE TRUTH!",
		"I SEEK THE MYSTERIES OF THE MOON!",
	)
	storyteller = /datum/storyteller/noc
	associated_psycross = /obj/item/clothing/neck/psycross/silver/noc

/datum/patron/divine/dendor
	name = DENDOR
	domain = "God of Nature and Beasts"
	desc = "Crafted from the bones of Psydon as the embodiment of the natural world. Driven mad with time."
	flaws = "Madness, Rebelliousness, Disorderliness"
	worshippers = "Druids, Beasts, Madmen"
	sins = "Deforestation, Overhunting, Disrespecting Nature"
	boons = "You are immune to kneestingers."
	added_traits = list(TRAIT_KNEESTINGER_IMMUNITY)
	devotion_holder = /datum/devotion/divine/dendor
	confess_lines = list(
		"DENDOR PROVIDES!",
		"THE TREEFATHER BRINGS BOUNTY!",
		"I ANSWER THE CALL OF THE WILD!",
	)
	storyteller = /datum/storyteller/dendor
	associated_psycross = /obj/item/clothing/neck/psycross/silver/dendor

/datum/patron/divine/abyssor
	name = ABYSSOR
	domain = "God of Seas and Storms"
	desc = "Crafted from the blood of Psydon as sovereign of the waters. Enraged by ignorance of Him from followers of The Ten."
	flaws= "Reckless, Stubborn, Destructive"
	worshippers = "Sailors of the Sea and Sky, Horrid Sea-Creachers, Fog Islanders"
	sins = "Fear, Hubris, Forgetfulness"
	boons = "Leeches will drain very little of your blood."
	added_traits = list(TRAIT_LEECHIMMUNE)
	devotion_holder = /datum/devotion/divine/abyssor
	confess_lines = list(
		"ABYSSOR COMMANDS THE WAVES!",
		"THE OCEAN'S FURY IS ABYSSOR'S WILL!",
		"I AM DRAWN BY THE PULL OF THE TIDE!",
	)
	storyteller = /datum/storyteller/abyssor
	associated_psycross = /obj/item/clothing/neck/psycross/silver/abyssor

/datum/patron/divine/necra
	name = NECRA
	domain = "Mother Goddess of Death and Time"
	desc = "The Veiled Lady, once close partner to Psydon. She created the Nine others from his corpse, guiding them from the Underworld."
	flaws = "Unchanging, Apathetic, Easy to Bore"
	worshippers = "Orderlies, Gravetenders, Mourners"
	sins = "Heretical Magic, Untimely Death, Disturbance of Rest"
	boons = "You may see the presence of a soul in a body."
	added_traits = list(TRAIT_SOUL_EXAMINE)
	devotion_holder = /datum/devotion/divine/necra
	confess_lines = list(
		"ALL SOULS FIND THEIR WAY TO NECRA!",
		"THE UNDERMAIDEN IS OUR FINAL REPOSE!",
		"I FEAR NOT DEATH, MY LADY AWAITS ME!",
	)
	storyteller = /datum/storyteller/necra
	associated_psycross = /obj/item/clothing/neck/psycross/silver/necra

/datum/patron/divine/ravox
	name = RAVOX
	domain = "God of Warfare, Justice, and Bravery"
	desc = "Crafted from the blade of Psydon, a champion of all who seek righteousness for themselves and others."
	flaws = "Carelessness, Aggression, Pride"
	worshippers = "Warriors, Sellswords, Guardsmen"
	sins = "Cowardice, Cruelty, Stagnation"
	boons = "Your used weapons dull slower."
	added_traits = list(TRAIT_SHARPER_BLADES)
	devotion_holder = /datum/devotion/divine/ravox
	confess_lines = list(
		"RAVOX IS JUSTICE!",
		"THROUGH STRIFE, GRACE!",
		"THE DRUMS OF WAR BEAT IN MY CHEST!",
	)
	storyteller = /datum/storyteller/ravox
	associated_psycross = /obj/item/clothing/neck/psycross/silver/ravox

/datum/patron/divine/xylix
	name = XYLIX
	domain = "Deity of Trickery, Freedom, and Inspiration"
	desc = "Crafted from the silver tongue of Psydon. Xylix is a force of change and deceit, yet allows little known of their gender let alone presence."
	flaws = "Petulance, Deception, Gambling-Prone"
	worshippers = "Cheats, Performers, The Hopeless"
	sins = "Boredom, Predictability, Routine"
	boons = "You can rig different forms of gambling in your favor."
	added_traits = list(TRAIT_BLACKLEG)
	devotion_holder = /datum/devotion/divine/xylix
	confess_lines = list(
		"ASTRATA IS MY LIGHT!",
		"NOC IS NIGHT!",
		"DENDOR PROVIDES!",
		"ABYSSOR COMMANDS THE WAVES!",
		"RAVOX IS JUSTICE!",
		"ALL SOULS FIND THEIR WAY TO NECRA!",
		"HAHAHAHA! AHAHAHA! HAHAHAHA!", //the only xylix-related confession
		"PESTRA SOOTHES ALL ILLS!",
		"MALUM IS MY FORGE!",
		"EORA BRINGS US TOGETHER!",
	)
	storyteller = /datum/storyteller/xylix
	associated_psycross = /obj/item/clothing/neck/psycross/silver/xylix

/datum/patron/divine/pestra
	name = PESTRA
	domain = "Goddess of Disease, Alchemy, and Medicine"
	desc = "A mistake; Psydon's intestines left behind. She slithered out, bringing forth the cycle of life and decay."
	flaws = "Drunkenness, Crudeness, Irresponsibility"
	worshippers = "The Ill and Infirm, Alchemists, Physicians"
	sins = "´Curing´ Abnormalities, Refusing to Help Unfortunates, Groveling"
	boons = "You may consume rotten food without being sick."
	added_traits = list(TRAIT_ROT_EATER)
	devotion_holder = /datum/devotion/divine/pestra
	confess_lines = list(
		"PESTRA SOOTHES ALL ILLS!",
		"DECAY IS A CONTINUATION OF LIFE!",
		"MY AFFLICTION IS MY TESTAMENT!",
	)
	storyteller = /datum/storyteller/pestra
	associated_psycross = /obj/item/clothing/neck/psycross/silver/pestra

/datum/patron/divine/pestra/preference_accessible(datum/preferences/prefs)
	. = ..()
	if(!.)
		return

	// These guys believe in a wurm, not pestra. They won't accept pestra as not being a giant acid wurm.
	return prefs.pref_species.id != SPEC_ID_DWARF_SUBTERRAN

/datum/patron/divine/malum
	name = MALUM
	domain = "God of Toil, Innovation, and Creation"
	desc = "Crafted from the hands of Psydon. He would later use his own to construct wondrous inventions."
	flaws = "Obsessive, Exacting, Overbearing"
	worshippers = "Smiths, Miners, Sculptors"
	sins = "Cheating, Shoddy Work, Suicide"
	boons = "You recover more energy when sleeping."
	added_traits = list(TRAIT_BETTER_SLEEP)
	devotion_holder = /datum/devotion/divine/malum
	confess_lines = list(
		"MALUM IS MY FORGE!",
		"TRUE VALUE IS IN THE TOIL!",
		"I AM AN INSTRUMENT OF CREATION!",
	)
	storyteller = /datum/storyteller/malum
	associated_psycross = /obj/item/clothing/neck/psycross/silver/malum

/datum/patron/divine/eora
	name = EORA
	domain = "Goddess of Love, Family, and Art"
	desc = "Crafted from the heart of Psydon, a spreader of love and beauty, and strengthener of bonds."
	flaws= "Naivete, Impulsiveness, Bigotry"
	worshippers = "Mothers, Artists, Married Couples"
	sins = "Sadism, Abandonment, Ruining Beauty"
	boons = "You can understand others' needs better."
	added_traits = list(TRAIT_EXTEROCEPTION)
	devotion_holder = /datum/devotion/divine/eora
	confess_lines = list(
		"EORA BRINGS US TOGETHER!",
		"HER BEAUTY IS EVEN IN THIS TORMENT!",
		"I LOVE YOU, EVEN AS YOU TRESPASS AGAINST ME!",
	)
	storyteller = /datum/storyteller/eora
	associated_psycross = /obj/item/clothing/neck/psycross/silver/eora
