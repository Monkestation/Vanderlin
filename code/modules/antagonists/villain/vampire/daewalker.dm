/datum/antagonist/vampire/lord/daewalker
	name = "The Daewalker"
	antag_hud_type = null
	antag_hud_name = null
	confess_lines = list(
		"BLOODSUCKERS GAVE ME MY POWERS, I MAKE THEM REGRET IT!!",
		"MOTHERFUCKER, ARE YOU OUTTA YOUR DAMN MIND?!!",
		"YOU'RE A THRALL OF THRONLEER!!",
	)
	isgoodguy = TRUE
	chooses_name = FALSE
	ascended = 4
	outfit = /datum/outfit/daewalker
	patron = /datum/patron/divine/astrata
	innate_traits = list(
		TRAIT_SILVER_BLESSED,
		TRAIT_HARDDISMEMBER,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_BLINDFIGHTING,
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR,
		TRAIT_FEARLESS,
		TRAIT_NOAMBUSH,
		TRAIT_NOHYGIENE, // too cool to stink
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_NOPAINSTUN
	)
	antag_memory = "It's open season on all bloodsuckers. Nothing else matters.\n\
		Avoid the Oratorium Throni Vacui. They know naught who they serve. Attack them as a last resort.\n\
		Serve Astrata's will or suffer it."
	antag_flags = FLAG_FAKE_ANTAG
	clan_selected = TRUE
	default_clan = /datum/clan/daewalker


/datum/antagonist/vampire/lord/daewalker/on_gain()
	var/mob/living/carbon/human/blade = owner.current
	blade.gender = MALE
	blade.age = AGE_ADULT
	blade.clear_quirks()
	blade.set_species(/datum/species/human/northern)

	blade.skin_tone = SKIN_COLOR_CRIMSONLANDS
	blade.set_eye_color("#ffff00", updates_dna = TRUE)
	blade.voice_color = "ffff00"
	blade.set_hair_color("#181a1d", FALSE)
	blade.set_facial_hair_color("#181a1d", FALSE)
	blade.set_hair_style(/datum/sprite_accessory/hair/head/hunter, FALSE)
	blade.set_facial_hair_style(/datum/sprite_accessory/hair/facial/shaved, FALSE)
	blade.fully_replace_character_name(blade.real_name, "\improper Daewalker")
	blade.article = "the"
	blade.dna?.update_dna_identity()

	blade.headshot_link = null
	blade.flavortext = null
	blade.flavortext_display = null
	blade.culture = GLOB.culture_singletons[/datum/culture/universal/grenzelhoft]
	blade.accent = ACCENT_NONE

	. = ..()

	blade.adjust_stat_modifier_list("[type]", list(
		STATKEY_STR = 6,
		STATKEY_PER = 6,
		STATKEY_INT = 6,
		STATKEY_CON = 6,
		STATKEY_END = 6,
		STATKEY_SPD = 6,
		STATKEY_LCK = 6,
	))
	blade.adjust_skillrank(/datum/skill/combat/swords, 6, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/firearms, 6, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/knives, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)

	blade.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/bombs, 2, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	blade.adjust_skillrank(/datum/skill/craft/traps, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)

	blade.adjust_skillrank(/datum/skill/misc/athletics, 6, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
	blade.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)

	blade.maxbloodpool = 5000
	blade.set_bloodpool(5000)
	blade.cmode_music = 'sound/music/cmode/antag/CombatDaywalker.ogg'

	blade.remove_all_languages()
	blade.grant_language(/datum/language/common)
	blade.grant_language(/datum/language/celestial)
	blade.grant_language(/datum/language/newpsydonic)
	blade.grant_language(/datum/language/oldpsydonic)
	blade.add_quirk(/datum/quirk/vice/godfearing)

	RegisterSignal(blade, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/antagonist/vampire/lord/daewalker/on_removal()
	if(owner.current)
		owner.current.remove_stat_modifier("[type]")
		UnregisterSignal(owner.current, COMSIG_PARENT_EXAMINE)
	. = ..()

/datum/antagonist/vampire/lord/daewalker/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/purishep))
		return span_red("Silverblood.")


/datum/antagonist/vampire/lord/daewalker/proc/on_examine(mob/living/carbon/human/blade, mob/living/carbon/human/user, list/examine_list)
	if(!istype(blade) || !istype(user))
		return
	if(blade == user)
		return
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		examine_list += span_boldred("TRAITOR! His capture has been ordered by the highest authority!")
	else if(user.mind?.has_antag_datum(/datum/antagonist/werewolf))
		examine_list += span_boldred("The bloodsucker of Astrata...")
	else if(is_priest_job(user.mind?.assigned_role))
		examine_list += SPAN_GOD_ASTRATA("The servant of our Sun Queen!")
	else if(istype(user.culture, /datum/culture/universal/grenzelhoft))
		examine_list += span_boldred("The nitebeast of Grenz! He's here!")
	else if(user.mind?.has_antag_datum(/datum/antagonist/maniac))
		examine_list += span_green("The legally distinct vampire hunter!")


/datum/antagonist/vampire/lord/daewalker/greet()
	to_chat(owner.current, span_silver( \
	"You were the most promising Sacrestant in all of the Oratorium. Your dedication led to a steady rise through the ranks until your induction to the Sanctae Cruoris. \
	Still, you rose further until you were to begin your training as a Ritter to House Thronleer, the highest noble house in all of Grenzelhoft. \
	It was at this point you were witness to something you should not have seen - the true faces of Thronleer, and consequently, Grenzelhoft. \
	Psydon was a marionette, and these were the puppeteers. \
	\n\n\
	To not throw your potential away, you were sired as spawn. Still, you resisted, and so a display was made - the burning of a heretic by daelight. \
	You awaited your death upon the false cross. As daelight broke at noon, you glimpsed her blinding face. In that moment, she offered you an accord - to redeem your vile blood: \
	\n\n\
	Walk the dae, so they may remember to fear it."))
	to_chat(owner.current, span_danger(antag_memory))

/datum/antagonist/vampire/lord/daewalker/move_to_spawnpoint()
	return


/datum/outfit/daewalker
	mask = /obj/item/clothing/face/spectacles/sglasses/daewalker
	neck = /obj/item/clothing/neck/psycross/silver/divine/astrata
	armor = /obj/item/clothing/armor/medium/scale/inqcoat/armored/daewalker
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq/daewalker
	pants = /obj/item/clothing/pants/trou/beltpants/daewalker
	shoes = /obj/item/clothing/shoes/boots/leather/daewalker
	wrists = /obj/item/clothing/wrists/bracers/leather/scabbard/daewalker
	gloves = /obj/item/clothing/gloves/fingerless
	ring =  /obj/item/clothing/ring/active/nomag

	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/pistol
	beltr = /obj/item/ammo_holder/bullet/bullets
	backl = /obj/item/storage/backpack/satchel/otavan
	backr = /obj/item/weapon/scabbard/sword/noble
	r_hand = /obj/item/weapon/sword/long/daewalker
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/aflask = 1, /obj/item/smokebomb = 2, /obj/item/needle/blessed = 1)

/datum/outfit/daewalker/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/component/storage/concrete/scabbard/sword/holder = H.backr?.GetComponent(/datum/component/storage/concrete/scabbard/sword)
	holder?.set_holdable(list(/obj/item/weapon/sword/long/daewalker), list())

// The Sword

/obj/item/weapon/sword/long/daewalker
	name = "\proper the Daewalker's blade"
	icon_state = "churchsword"
	desc = "A blade blessed with Pysdon's blood, now a tool of Astrata's Daewalker. It's open season on all suckheads."
	force_wielded = DAMAGE_GREATSWORD_WIELD
	wdefense = ULTMATE_PARRY
	max_blade_int = 50000
	max_integrity = 50000
	randomize_blade_int = FALSE
	resistance_flags = INDESTRUCTIBLE
	sellprice = 0
	slot_flags = 0 //scabbard only

/obj/item/weapon/sword/long/daewalker/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/vampiric)
	enchant(/datum/enchantment/silver)
	RegisterSignal(src, COMSIG_ITEM_AFTER_PICKUP, PROC_REF(hands_off))

/obj/item/weapon/sword/long/daewalker/examine(mob/user)
	. = ..()
	if(isobserver(user) || user.mind?.has_antag_datum(/datum/antagonist/vampire/lord/daewalker))
		. += span_smallnotice("The handle will score the hand of anyone who tries to pick it up.")

/obj/item/weapon/sword/long/daewalker/Destroy()
	UnregisterSignal(src, COMSIG_ITEM_AFTER_PICKUP)
	. = ..()

/obj/item/weapon/sword/long/daewalker/proc/hands_off(datum/source, mob/hand_haver)
	if(!unauthorized_user(hand_haver))
		return
	to_chat(hand_haver, span_warningbig("I hear a winding sound."))
	playsound(src, 'sound/foley/winding.ogg', 50, TRUE)
	if(!do_after(hand_haver, 3 SECONDS, src, (IGNORE_USER_LOC_CHANGE|IGNORE_HELD_ITEM|IGNORE_INCAPACITATED|IGNORE_SLOWDOWNS|IGNORE_USER_DIR_CHANGE|IGNORE_USER_DOING), FALSE, CALLBACK(src, PROC_REF(unauthorized_user), hand_haver)))
		return
	playsound(src, 'sound/items/beartrap2.ogg', 100, TRUE)
	hand_haver.visible_message(span_danger("Blades expand from [src]'s hilt!"), span_userdanger("Blades expand from the hilt!"))
	var/obj/item/bodypart/hand_to_lose = hand_haver.has_hand_for_held_index(hand_haver.get_held_index_of_item(src))
	if(!hand_to_lose)
		return
	var/bodyzone = hand_to_lose.aux_zone || hand_to_lose.body_zone
	hand_to_lose.bodypart_attacked_by(BCLASS_PIERCE, 150, null, bodyzone)
	hand_to_lose.add_wound(/datum/wound/scarring)

/obj/item/weapon/sword/long/daewalker/proc/unauthorized_user(mob/living/carbon/user)
	. = FALSE
	if(QDELETED(src) || QDELETED(user))
		return
	if(!istype(user))
		return
	if(user.status_flags & GODMODE)
		return
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord/daewalker))
		return
	return user.get_held_index_of_item(src)


/// Random bullshit clothing

/obj/item/clothing/face/spectacles/sglasses/daewalker
	name = "sun blockers"
	desc = "Some knave's always trying to wade upstream."
	color = "#1E1E1E"
	max_integrity = 500
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/armor/medium/scale/inqcoat/armored/daewalker
	name = "dark armored inquisitorial duster"
	color = CLOTHING_ROYAL_BLACK
	pocket_storage_component_path = /datum/component/storage/concrete/grid/cloak
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/armor/gambeson/heavy/inq/daewalker
	name = "dark inquisitorial leather tunic"
	color = CLOTHING_ROYAL_BLACK
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shoes/boots/leather/daewalker
	name = "dark boots"
	icon_state = "psydonboots"
	item_state = "psydonboots"
	color = CLOTHING_ROYAL_BLACK
	armor = list("blunt" = 80, "slash" = 60, "stab" = 40, "piercing" = 0,"fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP)
	max_integrity = INTEGRITY_STRONG
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shoes/boots/leather/daewalker/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, custom_sounds = list(SFX_WATCH_BOOT_STEP))

/obj/item/clothing/pants/trou/beltpants/daewalker
	color = CLOTHING_ROYAL_BLACK
	armor = list("blunt" = 70, "slash" = 60, "stab" = 30, "piercing" = 20,"fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = INTEGRITY_STRONG
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/wrists/bracers/leather/scabbard/daewalker
	armor = list("blunt" = 60, "slash" = 40, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	max_integrity = INTEGRITY_STANDARD + 50
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/wrists/bracers/leather/scabbard/daewalker/Initialize()
	. = ..()
	new /obj/item/weapon/knife/dagger/silver/psydon(src)
	update_appearance(UPDATE_ICON_STATE)


