/datum/job/advclass/wretch/heretic
	title = "Iconoclast"
	tutorial = "You are either a heretic or a fanatic, spurned by the church, cast out from society - frowned upon by the tens for your type of faith."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	allowed_patrons = ALL_ICONOCLAST_PATRONS
	outfit = /datum/outfit/wretch/heretic
	total_positions = 2
	exp_type = list(EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)
	exp_types_granted  = list(EXP_TYPE_COMBAT, EXP_TYPE_CLERIC)

/datum/outfit/wretch/heretic/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/heavy/necked
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/chainmail
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/storage/belt/pouch/coins/poor
	ring = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/chain
	H.change_stat(STATKEY_STR, 2) //weaker version of templar
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_END, 2)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FANATICAL, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INHUMENCAMP, TRAIT_GENERIC)
	switch(H.patron?.type) //this is a ridiculous way of doing it and it is annoying, this is genuinely a cry for help
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
			head = /obj/item/clothing/head/helmet/heavy/necked/astrata
			cloak = /obj/item/clothing/cloak/stabard/templar/astrata
			H.cmode_music = 'sound/music/cmode/church/CombatAstrata.ogg'
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/psycross/silver/noc
			head = /obj/item/clothing/head/helmet/heavy/necked/noc
			cloak = /obj/item/clothing/cloak/stabard/templar/noc
			H.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/psycross/silver/dendor
			head = /obj/item/clothing/head/helmet/heavy/necked/dendorhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/dendor
			H.cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/necra
			head = /obj/item/clothing/head/helmet/heavy/necked/necra
			cloak = /obj/item/clothing/cloak/stabard/templar/necra
			H.cmode_music = 'sound/music/cmode/church/CombatGravekeeper.ogg'
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/psycross/silver/pestra
			head = /obj/item/clothing/head/helmet/heavy/necked/pestrahelm
			cloak = /obj/item/clothing/cloak/stabard/templar/pestra
			H.cmode_music = 'sound/music/cmode/adventurer/CombatMonk.ogg'
			beltr = /obj/item/reagent_containers/glass/bottle/strongpoison //hm
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
		if(/datum/patron/divine/eora)
			head = /obj/item/clothing/head/helmet/sallet/eoran
			wrists = /obj/item/clothing/neck/psycross/silver/eora
			cloak = /obj/item/clothing/cloak/stabard/templar/eora
			H.cmode_music = 'sound/music/cmode/church/CombatEora.ogg'
			H.virginity = FALSE
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
			head = /obj/item/clothing/head/helmet/heavy/necked/ravox
			cloak = /obj/item/clothing/cloak/stabard/templar/ravox
			H.cmode_music = 'sound/music/cmode/church/CombatRavox.ogg'
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/malum
			head = /obj/item/clothing/head/helmet/heavy/necked/malumhelm
			cloak = /obj/item/clothing/cloak/stabard/templar/malum
			H.cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
		if(/datum/patron/divine/abyssor)
			head = /obj/item/clothing/head/helmet/heavy/necked/abyssor
			armor = /obj/item/clothing/armor/brigandine/abyssor
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
			cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
			H.cmode_music = 'sound/music/cmode/church/CombatAbyssor.ogg'
			H.adjust_skillrank(/datum/skill/labor/fishing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
			head = /obj/item/clothing/head/helmet/heavy/necked/xylix
			cloak = /obj/item/clothing/cloak/stabard/templar/xylix
			H.cmode_music = 'sound/music/cmode/church/CombatXylix.ogg'
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
		if(/datum/patron/inhumen/graggar) //They get cooler outfits cause of non-unique weapon
			head = /obj/item/clothing/head/helmet/graggar
			armor = /obj/item/clothing/armor/plate/full/graggar
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/graggar
			pants = /obj/item/clothing/pants/platelegs/graggar
			shoes = /obj/item/clothing/shoes/boots/armor/graggar
			cloak = /obj/item/clothing/cloak/graggar
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
			H.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
		if(/datum/patron/inhumen/graggar_zizo)
			head = /obj/item/clothing/head/helmet/graggar
			armor = /obj/item/clothing/armor/plate/full/graggar
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/graggar
			pants = /obj/item/clothing/pants/platelegs/graggar
			shoes = /obj/item/clothing/shoes/boots/armor/graggar
			cloak = /obj/item/clothing/cloak/graggar
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
			H.cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
		if(/datum/patron/inhumen/zizo)
			head = /obj/item/clothing/head/helmet/visored/zizo
			armor = /obj/item/clothing/armor/plate/full/zizo
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/zizo
			pants = /obj/item/clothing/pants/platelegs/zizo
			shoes = /obj/item/clothing/shoes/boots/armor/zizo
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			H.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
			H.grant_language(/datum/language/undead)
			to_chat(H, "<span class='info'>I can speak in zizo chant with ,w before my speech.</span>")
		if(/datum/patron/inhumen/matthios)
			head = /obj/item/clothing/head/helmet/heavy/matthios
			armor = /obj/item/clothing/armor/plate/full/matthios
			neck = /obj/item/clothing/neck/gorget
			gloves = /obj/item/clothing/gloves/plate/matthios
			pants = /obj/item/clothing/pants/platelegs/matthios
			shoes = /obj/item/clothing/shoes/boots/armor/matthios
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			H.cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
		if(/datum/patron/inhumen/baotha) //give them custom armor i beg
			head = /obj/item/clothing/head/helmet/heavy/baotha
			mask = /obj/item/clothing/face/spectacles/sglasses
			neck = /obj/item/clothing/neck/gorget
			armor = /obj/item/clothing/armor/plate
			gloves = /obj/item/clothing/gloves/plate
			pants = /obj/item/clothing/pants/platelegs
			shoes = /obj/item/clothing/shoes/boots/armor
			H.cmode_music = 'sound/music/cmode/antag/CombatBaotha.ogg'
			H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
		if(/datum/patron/psydon)
			wrists = /obj/item/clothing/neck/psycross/g
			armor = /obj/item/clothing/armor/cuirass/fluted
			cloak = /obj/item/clothing/cloak/psydontabard
			gloves = /obj/item/clothing/gloves/chain/psydon
			shoes = /obj/item/clothing/shoes/psydonboots
			head = /obj/item/clothing/head/helmet/heavy/psydonhelm
			H.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			H.grant_language(/datum/language/oldpsydonic)
			to_chat(H, "<span class='info'>I can speak Old Psydonic with ,m before my speech.</span>")
		else //Just in case.
			head = /obj/item/clothing/head/helmet/heavy/bucket
			wrists = /obj/item/clothing/neck/psycross/silver/undivided
			cloak = /obj/item/clothing/cloak/templar/undivided
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
			H.cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'
	if(!H.has_language(/datum/language/celestial) && (H.patron?.type in ALL_TEMPLE_PATRONS))
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")
	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(H)
	if(H.dna?.species)
		if(H.dna.species.id == SPEC_ID_HUMEN)
			H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/wretch/heretic/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	switch(H.patron?.type) //this is a ridiculous way of doing it and it is annoying.
		if(/datum/patron/divine/astrata)
			var/obj/item/weapon/sword/long/exe/astrata/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/noc)
			var/obj/item/weapon/sword/sabre/noc/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/dendor)
			var/obj/item/weapon/polearm/halberd/bardiche/dendor/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/necra)
			var/obj/item/weapon/flail/sflail/necraflail/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/pestra)
			var/obj/item/weapon/knife/dagger/steel/pestrasickle/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
			var/obj/item/weapon/knife/dagger/steel/pestrasickle/L = new(get_turf(src))
			H.equip_to_appropriate_slot(L)
		if(/datum/patron/divine/eora)
			var/obj/item/weapon/sword/rapier/eora/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/ravox)
			var/obj/item/weapon/sword/long/ravox/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/malum)
			var/obj/item/weapon/hammer/sledgehammer/war/malum/P = new(get_turf(src))
			H.put_in_hands(P, forced = TRUE)
		if(/datum/patron/divine/abyssor)
			var/obj/item/weapon/polearm/spear/abyssor/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/divine/xylix)
			var/obj/item/weapon/whip/xylix/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/inhumen/graggar)
			var/obj/item/weapon/greataxe/steel/doublehead/graggar/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/inhumen/graggar_zizo)
			var/obj/item/weapon/greataxe/steel/doublehead/graggar/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/inhumen/zizo)
			var/obj/item/weapon/sword/long/greatsword/zizo/P = new(get_turf(src))
			H.put_in_hands(P, forced = TRUE)
		if(/datum/patron/inhumen/matthios)
			var/obj/item/weapon/flail/peasantwarflail/matthios/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
		if(/datum/patron/inhumen/baotha) //Literally crying on my knees, baotha has nothing useless, let's give them something for once.
			var/obj/item/weapon/knife/dagger/steel/dirk/baotha/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
			var/obj/item/weapon/knife/dagger/steel/dirk/baotha/L = new(get_turf(src))
			H.equip_to_appropriate_slot(L)
		if(/datum/patron/psydon)
			var/obj/item/weapon/sword/long/psydon/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
			var/obj/item/weapon/scabbard/sword/L = new(get_turf(src))
			H.equip_to_appropriate_slot(L)
		else
			var/obj/item/weapon/sword/long/decorated/P = new(get_turf(src))
			H.equip_to_appropriate_slot(P)
	wretch_select_bounty(H)
