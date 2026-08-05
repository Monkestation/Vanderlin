/datum/attribute_holder/sheet/job/hexknife
	raw_attribute_list = list(
		STAT_SPEED = 1,
		STAT_INTELLIGENCE = -1,
		STAT_ENDURANCE = -1,
		STAT_FORTUNE = -1,
		STAT_STRENGTH = -1,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/reading = 60,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/sewing = 40,
		/datum/attribute/skill/misc/medicine = 40,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/combat/knives = 30,
	)

// INSPIRATIONS: Perfect Blue, ToME4 Solipsist Class, Hotline Miami, Killer7, Second Sight, The Hat Man.
// Go buy Collect Call when it comes out I've been waiting for 1-900-cult for like nine fucking years man

// TODO: Fix AOE spell that inflicts a temporary nightmares debuff
// Fix(?) sections that use force emote (may cause crash while sleeping?)
// Balance cost and cooldown overall
// DOUBLECHECK to see if we gotta give the knife a shortsword statblock

/datum/job/advclass/wretch/hexknife
	title = "Dreamweaver"
	tutorial = "I was a natural at what I did. Noc blessed me, truly - my time at the Wizard's Colleges had been short, but I had learned more in two years than many do \
	within twenty. But I had no life. All my time was spent toiling within the weave, even in dreams. Noc showed me the way. The honey-sweet dreams of my peers called me to \
	temptation. Baotha's fingers hold the chalice to my lips. When I look in the mirror, I do not see me, I see the idea of me. The real me is in the mirror. I MUST MAKE IT REAL."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/wretch/hexknife
	total_positions = 1
	roll_chance = 100
	cmode_music = 'sound/music/cmode/adventurer/CombatDream2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/hexknife

	traits = list(
		TRAIT_DREAMPARANOIAAGENT,
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_NO_REFLECTION,
		TRAIT_KEENEARS,
		TRAIT_KEENEYES,
		TRAIT_SILENT_FOOTSTEPS,
		TRAIT_STEELHEARTED
	)

	voicepack_m = /datum/voicepack/male/dreamweaver

	spells = list(
		/datum/action/cooldown/spell/undirected/trespasser,
		/datum/action/cooldown/spell/undirected/sleepwalk,
		/datum/action/cooldown/spell/stealdream,
		/datum/action/cooldown/spell/status/phantasm,
		/datum/action/cooldown/spell/aoe/agamemnon
	)

	honoraries = list(
		"the Dreamweaver" = HONORARY_SUFFIX,
		"the Sleepwalker" = HONORARY_SUFFIX,
		"the Sandman" = HONORARY_SUFFIX,
		"the Dreamcatcher" = HONORARY_SUFFIX,
		"the Dreameater" = HONORARY_SUFFIX,
		"the Idea" = HONORARY_SUFFIX,
		"the Shape" = HONORARY_SUFFIX,
		"the Solipsist" = HONORARY_SUFFIX,
		"The Real" = HONORARY_PREFIX,
		"The Fake" = HONORARY_PREFIX,
		"the Hatmaker" = HONORARY_SUFFIX,
		"the Idealist" = HONORARY_SUFFIX,
	)

/datum/outfit/wretch/hexknife
	name = "Dreamweaver (Wretch)"
	mask = /obj/item/clothing/face/spectacles/sglasses
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/armor/gambeson/heavy/colored/dark
	head = /obj/item/clothing/head/hexknifehat
	armor = /obj/item/clothing/armor/regenerating/skin/easttats/hexknife
	backr = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/weapon/knife/dagger/navaja/hexknife
	neck = /obj/item/storage/belt/pouch/coins/rich
	gloves = /obj/item/clothing/gloves/leather
	shoes = /obj/item/clothing/shoes/nobleboot
	wrists = /obj/item/clothing/wrists/bracers/leather
	backpack_contents = list(
		/obj/item/lockpick = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/storage/fancy/cigarettes/zig = 1,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)
// This would be Thermal Vision if it had worked.
/datum/job/advclass/wretch/hexknife/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/obj/item/organ/eyes/eyes = spawned.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(spawned,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/nightmare
	eyes.Insert(spawned)

/datum/job/advclass/wretch/hexknife/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.set_patron(/datum/patron/divine/noc, TRUE)

	to_chat(spawned, span_notice("<span class='boldwarning'>Noc's whims no longer concern you. You have seen what mortals dream of. It drips sweet into your chalice. </span> \
	Like a rat in a cage, you are reduced to gnawing through the barriers between them and you. \
	<span class='redtext'>You must burn a fingerprint on the psyche of the living.</span> \
	<span class='hypnophrase'>STEALING the DREAMS of a target while they are ASLEEP is the only way to EMBED YOURSELF INTO THE WEAVE.</span> \
	Inside the thoughts of other people there's a perfect reflection of you. You need to find it. \
	<span class='smallnotice'>REWEAVE THE TAPESTRY. BECOME ARCANA. </span> \
	<span class='redtext'>Mortal flesh rots and dies at the hands of cowards. Ideas remain.</span> "))
	playsound(spawned, 'sound/music/dreamweaverintro.ogg', 80, FALSE)
