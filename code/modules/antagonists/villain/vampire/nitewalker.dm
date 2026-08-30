/datum/attribute_holder/sheet/job/nitewalker
	raw_attribute_list = list(
		STAT_STRENGTH = 6,
		STAT_PERCEPTION = 6,
		STAT_INTELLIGENCE = 6,
		STAT_CONSTITUTION = 6,
		STAT_ENDURANCE = 6,
		STAT_SPEED = 6,
		STAT_FORTUNE = 6,
		/datum/attribute/skill/combat/swords = 60,
		/datum/attribute/skill/combat/knives = 50,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/bows = 40,
		/datum/attribute/skill/combat/crossbows = 40,
		/datum/attribute/skill/combat/polearms = 40,
		/datum/attribute/skill/combat/unarmed = 50,
		/datum/attribute/skill/combat/wrestling = 50,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/craft/armorsmithing = 10,
		/datum/attribute/skill/craft/weaponsmithing = 20,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/traps = 40,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/misc/athletics = 60,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/medicine = 30,
		/datum/attribute/skill/misc/riding = 40,
		/datum/attribute/skill/misc/swimming = 50,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/reading = 30,
	)

/datum/antagonist/vampire/lord/nitewalker
	name = "The Nitewalker"
	confess_lines = list(
		"HE KNOWS ALL!!",
		"SILVER STILL STALKS THE NITE!!",
		"I. AM. LUNARIS!!",
	)
	isgoodguy = TRUE
	chooses_name = FALSE
	roundend_category = "Nitewardens"
	antagpanel_category = "Nitewarden"
	ascension_level = 4
	outfit = /datum/outfit/nitewalker
	patron = /datum/patron/divine/noc
	innate_traits = list(
		TRAIT_HARDDISMEMBER,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_BLINDFIGHTING,
		TRAIT_DODGEEXPERT,
		TRAIT_MEDIUMARMOR,
		TRAIT_FEARLESS,
		TRAIT_NOAMBUSH,
		TRAIT_NOHYGIENE, // too cool to stink
		TRAIT_NOPAINSTUN,
		TRAIT_SILVER_IMMUNE,
	)
	antag_memory = "Protect those who walk the nite.\n\
		The dark creachers are always present.\n\
		Serve The Moon or the dae will break you."
	antag_flags = FLAG_FAKE_ANTAG
	clan_selected = TRUE
	default_clan = /datum/clan/nitewalker
	allow_preference_switching = FALSE

/datum/antagonist/vampire/lord/nitewalker/on_gain()
	var/mob/living/carbon/human/blade = owner.current
	blade.age = AGE_ADULT
	blade.clear_quirks()

	blade.headshot_link = null
	blade.flavortext = null
	blade.flavortext_display = null
	blade.accent = ACCENT_NONE

	. = ..()

	owner.special_role = "Nitewalker"
	blade.attributes?.add_sheet(/datum/attribute_holder/sheet/job/nitewalker)

	blade.maxbloodpool = 5000
	blade.set_bloodpool(5000)
	blade.cmode_music = 'sound/music/cmode/church/CombatNoc.ogg'

	blade.remove_all_languages()
	blade.grant_language(/datum/language/common)
	blade.grant_language(/datum/language/elvish)
	blade.grant_language(/datum/language/hellspeak)
	blade.grant_language(/datum/language/celestial)
	blade.grant_language(/datum/language/celestial_moon)
	blade.grant_language(/datum/language/newpsydonic)
	blade.grant_language(/datum/language/oldpsydonic)
	blade.grant_language(/datum/language/sanguine)
	blade.add_quirk(/datum/quirk/vice/addiction/godfearing)

	blade.honorary_suffix = "the Nitewarden"

	RegisterSignal(blade, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/antagonist/vampire/lord/nitewalker/on_removal()
	if(owner.current)
		owner.current.remove_stat_modifier("[type]")
		UnregisterSignal(owner.current, COMSIG_ATOM_EXAMINE)
	. = ..()

/datum/antagonist/vampire/lord/nitewalker/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("A deadite.")
	if(istype(examined_datum, /datum/antagonist/purishep))
		return span_red("Silverblood.")

/datum/antagonist/vampire/lord/nitewalker/proc/on_examine(mob/living/carbon/human/blade, mob/living/carbon/human/user, list/examine_list)
	if(!istype(blade) || !istype(user))
		return
	if(blade == user)
		return
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		examine_list += span_boldred("Blood Drinker! They can have no excuses!")
	else if(user.mind?.has_antag_datum(/datum/antagonist/werewolf))
		examine_list += span_boldred("The bloodsucker of Noc...")
	else if(is_priest_job(user.mind?.assigned_role))
		examine_list += SPAN_GOD_NOC("The servant of The Moon!")
	else if(is_oracle_job(user.mind?.assigned_role))
		examine_list += SPAN_GOD_NOC("The everwalking servant of The Prince!")
	else if(user.mind?.has_antag_datum(/datum/antagonist/maniac))
		examine_list += span_green("Yet another legally distinct vampire hunter!")

/datum/antagonist/vampire/lord/nitewalker/greet()
	to_chat(owner.current, span_danger(antag_memory))

/datum/antagonist/vampire/lord/nitewalker/move_to_spawnpoint()
	return

/datum/outfit/nitewalker
	mask = /obj/item/clothing/face/shepherd/shadowmask
	neck = /obj/item/clothing/neck/psycross/silver/divine/noc
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	shirt = /obj/item/clothing/shirt/undershirt/formal
	pants = /obj/item/clothing/pants/trou/formal
	shoes = /obj/item/clothing/shoes/boots/hunter
	wrists = /obj/item/clothing/wrists/bracers/leather/scabbard
	gloves = /obj/item/clothing/gloves/leather
	ring =  /obj/item/clothing/ring/nitewalker
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/scabbard/sword/noble
	backl = /obj/item/storage/backpack/satchel/black
	r_hand = /obj/item/weapon/sword/long/silver/nitewalker
	l_hand = /obj/item/weapon/knife/dagger/steel/stiletto/nitewalker
	backpack_contents = list(/obj/item/needle/blessed = 1)

/datum/outfit/nitewalker/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/component/storage/concrete/scabbard/sword/holder = H.beltl?.GetComponent(/datum/component/storage/concrete/scabbard/sword)
	holder?.set_holdable(list(/obj/item/weapon/sword/long/silver/nitewalker), list())


/obj/item/weapon/sword/long/silver/nitewalker
	name = "nite's grace"
	desc = "A blade forged of lunar silver. The Moon Prince is watching."
	force_wielded = DAMAGE_GREATSWORD_WIELD
	wdefense = ULTMATE_PARRY
	max_blade_int = 50000
	max_integrity = 50000
	resistance_flags = INDESTRUCTIBLE
	sellprice = 0
	slot_flags = 0 //scabbard only

/obj/item/weapon/sword/long/silver/nitewalker/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/on_hit/vampiric)
	enchant(/datum/enchantment/anti_theft)

/obj/item/weapon/knife/dagger/steel/stiletto/nitewalker
	name = "nite's sting"
	desc = "A needle thin blade forged of lunar silver. The Moon Prince is watching."
	max_blade_int = 50000
	max_integrity = 50000
	resistance_flags = INDESTRUCTIBLE

/obj/item/weapon/knife/dagger/steel/stiletto/nitewalker/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/on_hit/lightning)
	enchant(/datum/enchantment/silver)
	enchant(/datum/enchantment/anti_theft)

/obj/item/clothing/ring/nitewalker
	name = "nitewarden's ring"
	icon_state = "bs_ring_ruby"
	desc = "A ring of blacksteel with a shimmering rontz set within. It thrums with unseen power."
	sellprice = 500
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/ring/nitewalker/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/life_eternal)
	enchant(/datum/enchantment/leaping)
	enchant(/datum/enchantment/anti_theft)
