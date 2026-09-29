/datum/antagonist/blood_mage
	antagpanel_category = "Blood Mages"
	roundend_category = "Blood Mages"
	show_name_in_check_antagonists = TRUE
	antag_hud_type = ANTAG_HUD_BLOOD_MAGE

	name = "Blood Mage"
	antag_hud_name = "bloodmage"
	confess_lines = list(
		"BLOOD IS POWER!",
		"YOUR VITAE IS MINE!",
		"LIFE AND DEATH IS IN MY HANDS!",
	)

/datum/antagonist/blood_mage/roundend_report()
	if(owner?.current)
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
			to_chat(world, "[the_name] was a [name].")
	return


/datum/antagonist/blood_mage/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/blood_mage/occult))
		return
	if(istype(examined_datum, /datum/antagonist/blood_mage/herald))
		return span_boldnotice("The Blood Herald of The Archdevils, bringer of ruin and death.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/sorcerer))
		return span_boldnotice("A formidable Blood Sorcerer, they could teach me much.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/student))
		return span_boldnotice("A student of Blood Magic.")
	if(istype(examined_datum, /datum/antagonist/blood_mage))
		return span_boldnotice("A fellow Blood Mage.")

/datum/antagonist/blood_mage/sorcerer
	name = "Blood Sorcerer"
	antag_hud_name = "bloodsorc"
	confess_lines = list(
		"THE POWER OF THE ANCIENTS!",
		"NO GOD CAN CLAIM MY POWER!",
		"BLOOD IS MY LEGACY!",
	)

/datum/antagonist/blood_mage/sorcerer/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire/lord/daewalker))
		return span_boldnotice("The immortal servant of the Sun Queen.")
	if(istype(examined_datum, /datum/antagonist/vampire/lord/nitewalker))
		return span_boldnotice("The immortal servant of the Moon Prince.")
	if(istype(examined_datum, /datum/antagonist/vampire/lord))
		return span_boldnotice("Firstborn lord of Kaine.")
	if(istype(examined_datum, /datum/antagonist/vampire/lords_spawn))
		return span_boldnotice("The spawn of the firstborn.")
	if(istype(examined_datum, /datum/antagonist/vampire))
		return span_boldnotice("A child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/vampire/outcast))
		return span_boldnotice("An outcast child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/herald))
		return span_boldnotice("The Blood Herald of The Archdevils, bringer of ruin and death.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/sorcerer))
		return span_boldnotice("A fellow Blood Sorcerer.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/student))
		return span_boldnotice("A student of Blood Magic.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/occult))
		return span_boldnotice("Someone who found forbidden knowledge...")
	if(istype(examined_datum, /datum/antagonist/blood_mage))
		return span_boldnotice("An established Blood Mage.")

/datum/antagonist/blood_mage/student
	name = "Blood Magic Apprentice"
	antag_hud_name = "bloodapp"
	increase_votepwr = FALSE

/datum/antagonist/blood_mage/student/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/blood_mage/occult))
		return
	if(istype(examined_datum, /datum/antagonist/blood_mage/herald))
		return span_boldnotice("The Blood Herald of The Archdevils, bringer of ruin and death.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/sorcerer))
		return span_boldnotice("A Scion of Blood Magic... the things I could learn...")
	if(istype(examined_datum, /datum/antagonist/blood_mage/student))
		return span_boldnotice("A fellow student of Blood Magic.")
	if(istype(examined_datum, /datum/antagonist/blood_mage))
		return span_boldnotice("An established Blood Mage, they could teach me much.")

/datum/antagonist/blood_mage/occult
	name = "Occult Librarian"
	antag_hud_name = null
	antag_hud_type = null
	increase_votepwr = FALSE
	isgoodguy = TRUE

/datum/antagonist/blood_mage/occult/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	return

/*############################################################
######################## BLOOD HERALD ########################
############################################################*/

/datum/antagonist/blood_mage/herald
	name = ROLE_BLOOD_HERALD
	antag_hud_name = "bloodherald"
	confess_lines = list(
		"MY MASTERS WILL BRING RUIN!",
		"THE FALSE GODS WILL BURN!",
		"FEAR THE COMING DARKNESS!",
	)

	innate_traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR,
		TRAIT_BLOOD_SORCERER,
		TRAIT_VITAE_USER,
		TRAIT_BLOOD_SENSE,
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED,
		TRAIT_BATTLE_READY,
		TRAIT_NOPAINSTUN,
		TRAIT_POISON_RESILIENCE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_THIEFSENSE,
		TRAIT_DEVIL_MARKED_ABRAXAS,
		TRAIT_DEVIL_MARKED_ABADDON,
		TRAIT_DEVIL_MARKED_MEPHISTOPHELES,
		TRAIT_DEVIL_MARKED_LEVIATHAN,
		TRAIT_NOMOOD,
	)

	var/list/spells = list(
		/datum/action/cooldown/spell/status/blood_sight/herald,
		/datum/action/cooldown/spell/blood_bind,
		/datum/action/cooldown/spell/recall_weapon/blood,
		/datum/action/cooldown/spell/blood_healing/herald,
		/datum/action/cooldown/spell/status/blood_mark/herald,
		/datum/action/cooldown/spell/status/blood_choke/herald,
		/datum/action/cooldown/spell/aoe/blood_harvest,
	)

/datum/antagonist/blood_mage/herald/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire/lord/daewalker))
		return span_boldnotice("The immortal servant of the Sun Queen.")
	if(istype(examined_datum, /datum/antagonist/vampire/lord/nitewalker))
		return span_boldnotice("The immortal servant of the Moon Prince.")
	if(istype(examined_datum, /datum/antagonist/vampire/lord))
		return span_boldnotice("Firstborn lord of Kaine.")
	if(istype(examined_datum, /datum/antagonist/vampire/lords_spawn))
		return span_boldnotice("The spawn of the firstborn.")
	if(istype(examined_datum, /datum/antagonist/vampire))
		return span_boldnotice("A child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/vampire/outcast))
		return span_boldnotice("An outcast child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/herald))
		return span_boldnotice("Blood Herald of The Archdevils, bringer of ruin and death.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/sorcerer))
		return span_boldnotice("A formidable Blood Sorcerer.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/student))
		return span_boldnotice("A student of Blood Magic.")
	if(istype(examined_datum, /datum/antagonist/blood_mage/occult))
		return span_boldnotice("Someone who found forbidden knowledge...")
	if(istype(examined_datum, /datum/antagonist/blood_mage))
		return span_boldnotice("An established Blood Mage.")

/datum/antagonist/blood_mage/herald/on_gain()
	var/mob/living/carbon/human/herald = owner?.current
	herald.purge_combat_knowledge() // purge all their combat skills first
	herald.reset_and_reroll_stats()
	herald.remove_all_traits()
	. = ..()
	for(var/datum/action/spell as anything in spells)
		owner.current.add_spell(spell, source = src)
	owner.special_role = name
	move_to_spawnpoint()
	remove_job()
	herald.delete_equipment()
	herald.update_age_stats(herald.age, TRUE)
	equip_herald()
	herald.AddComponent(/datum/component/violent_death)

/datum/antagonist/blood_mage/herald/on_removal()
	var/mob/living/herald = owner.current
	herald.remove_spells(source = src)
	qdel(GetComponent(/datum/component/violent_death))
	herald.maxbloodpool -= 1000
	herald.set_bloodpool(min(1500, herald.bloodpool))
	return ..()

/datum/antagonist/blood_mage/herald/proc/equip_herald()
	owner.forget_and_be_forgotten()
	var/mob/living/carbon/human/herald = owner.current

	for(var/datum/mind/found_mind in get_minds(JOB_ADMIN_BLOOD_SORCERER))
		herald.mind?.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds("Blood Mage"))
		herald.mind?.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds(ROLE_BLOOD_HERALD))
		herald.mind?.share_identities(found_mind)

	herald.set_faction(list(FACTION_BLOOD_MAGIC))
	herald.hud_used?.set_bloody_bloodpool()
	herald.maxbloodpool += 1000
	herald.set_bloodpool(2500)

	herald.equipOutfit(/datum/outfit/blood_herald)
	if(!istype(herald.patron, /datum/patron/archdevil))
		herald.set_patron(/datum/patron/archdevil/abraxas)

	herald.cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	if(length(herald.quirks))
		herald.clear_quirks()

/datum/antagonist/blood_mage/herald/greet()
	. = ..()
	to_chat(owner.current, SPAN_GOD_ARCHDEVILS("The Herald of The Forgotten, wielder of the darkest arts... you will bring ruin and remembrance to all."))
	owner.announce_objectives()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/lichintro.ogg', 80, FALSE, pressure_affected = FALSE)

/datum/outfit/blood_herald
	name = ROLE_BLOOD_HERALD
	head = /obj/item/clothing/head/helmet/visored/blkknight/bloodsteel
	neck = /obj/item/clothing/neck/chaincoif/bloodsteel
	armor = /obj/item/clothing/armor/plate/blkknight/bloodsteel
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/plate/blk/bloodsteel
	pants = /obj/item/clothing/pants/platelegs/blk/bloodsteel
	shoes = /obj/item/clothing/shoes/boots/armor/blkknight/bloodsteel
	ring = /obj/item/clothing/ring/rubybs
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel/black
	beltl = /obj/item/weapon/knife/dagger/bloodsteel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/stronghealthpot/labelled = 1,
		/obj/item/reagent_containers/glass/bottle/strongbloodpot/labelled = 1,
		/obj/item/weapon/hammer/steel = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/needle = 1,
	)

/datum/outfit/blood_herald/pre_equip(mob/living/carbon/human/herald, visuals_only)
	. = ..()

	herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald)

	herald.grant_language(/datum/language/hellspeak)
	herald.grant_language(/datum/language/sanguine)
	ADD_TRAIT(herald, TRAIT_NOAMBUSH, JOB_TRAIT)

	addtimer(CALLBACK(herald, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), ROLE_BLOOD_HERALD), 5 SECONDS)

/datum/outfit/blood_herald/post_equip(mob/living/carbon/human/herald, visuals_only)
	. = ..()
	if(!herald.client)
		herald.equip_to_slot_or_del(new /obj/item/weapon/sword/long/greatsword/claymore/bloodsteel, ITEM_SLOT_HANDS, TRUE)
		herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/sword)
		return

	var/static/list/weapons = list(
		"Broadsword" = /obj/item/weapon/sword/long/greatsword/claymore/bloodsteel,
		"Rapier" = /obj/item/weapon/sword/rapier/bloodsteel,
		"Spear" = /obj/item/weapon/polearm/spear/bloodsteel,
		"Halberd" = /obj/item/weapon/polearm/halberd/bloodsteel,
		"Whip" = /obj/item/weapon/whip/bloodsteel,
		"Handclaws" = /obj/item/weapon/handclaw/steel/bloodsteel,
	)
	var/weapon_choice = herald.select_equippable(herald.client, weapons, message = "Choose Your Specialisation", title = "BLOOD HERALD")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Broadsword")
			herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/sword)
		if("Rapier")
			herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/sword)
		if("Spear")
			herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/polearm)
		if("Halberd")
			herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/polearm)
		if("Whip")
			herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/whip)
		if("Handclaws")
			herald.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/claws)
			herald.equip_to_slot_or_del(new /obj/item/weapon/handclaw/steel/bloodsteel, ITEM_SLOT_BELT_R, TRUE)
			ADD_TRAIT(herald, TRAIT_DUALWIELDER, JOB_TRAIT)

/datum/attribute_holder/sheet/job/blood_herald
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = 2,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,

		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,

		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/magic/blood = 40,
		/datum/attribute/skill/craft/armor_repair = 30,
		/datum/attribute/skill/craft/weapon_repair = 30,
	)

/datum/attribute_holder/sheet/job/blood_herald/sword
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(40, 40)
	)

/datum/attribute_holder/sheet/job/blood_herald/polearm
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(40, 40)
	)

/datum/attribute_holder/sheet/job/blood_herald/claws
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/unarmed = list(40, 40)
	)

/datum/attribute_holder/sheet/job/blood_herald/whip
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(40, 40)
	)

/obj/item/clothing/head/helmet/visored/blkknight/bloodsteel
	name = "bloodsteel helmet"
	desc = "A helmet born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 200
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/head/helmet/visored/blkknight/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/armor/plate/blkknight/bloodsteel
	name = "bloodsteel plate"
	desc = "A chestplate born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 300
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/armor/plate/blkknight/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/shoes/boots/armor/blkknight/bloodsteel
	name = "bloodsteel boots"
	desc = "Plate boots born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 100
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/shoes/boots/armor/blkknight/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/gloves/plate/blk/bloodsteel
	name = "bloodsteel gauntlets"
	desc = "Gauntlets born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 100
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/gloves/plate/blk/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/pants/platelegs/blk/bloodsteel
	name = "bloodsteel greaves"
	desc = "Greaves born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 200
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/pants/platelegs/blk/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/neck/chaincoif/bloodsteel
	name = "bloodsteel chain coif"
	desc = "A coif made of interwoven bloodsteel rings, made to protect against arrows and blades. \
			Generally used as padding, but serviceable enough on its own."
	color = "#ff6066"
	armor_type = /datum/armor/neck/maille/bloodsteel
	smeltresult = null
	melt_amount = 100
	melting_material = /datum/material/bloodsteel

/obj/item/clothing/neck/chaincoif/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

