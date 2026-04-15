/mob/living/carbon/human/species/automaton
	icon = 'icons/roguetown/mob/bodies/m/automaton.dmi'
	icon_state = MAP_SWITCH("human_basic", "at")
	race = /datum/species/automaton
	footstep_type = FOOTSTEP_MOB_METAL
	job = "Automaton"
	pronouns = IT_ITS
	bodyparts = list(/obj/item/bodypart/chest/automaton, /obj/item/bodypart/head/automaton, /obj/item/bodypart/l_arm/automaton,
					/obj/item/bodypart/r_arm/automaton, /obj/item/bodypart/r_leg/automaton, /obj/item/bodypart/l_leg/automaton)
	uses_random_stats = FALSE
	culture = /datum/culture/universal/heartfelt
	cmode_music = 'sound/music/cmode/towner/CombatPrisoner.ogg'

/mob/living/carbon/human/species/automaton/LateInitialize()
	. = ..()
	skin_tone = "FFFFFF"
	update_body()
	update_body_parts()

/mob/living/carbon/human/species/automaton/vessel/LateInitialize()
	. = ..()
	AddComponent(/datum/component/ghost_vessel, /obj/item/riddleofsteel)

/mob/living/carbon/human/species/automaton/prefilled_vessel/LateInitialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_AUGMENT_INSTALL, new /datum/augment/loyalty_binder(), src)
	SEND_SIGNAL(src, COMSIG_AUGMENT_INSTALL, new /datum/augment/armor/copper(), src)
	AddComponent(/datum/component/ghost_vessel)

/datum/attribute_holder/sheet/job/species/automaton
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_INTELLIGENCE = -7,
		STAT_CONSTITUTION = 5,
		STAT_ENDURANCE = 6,
		STAT_SPEED = -7,
		STAT_FORTUNE = -3,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/craft/carpentry = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/masonry = 10,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/labor/fishing = 10,
		/datum/attribute/skill/labor/mathematics = 30,
		/datum/attribute/skill/labor/mining = 10,
		/datum/attribute/skill/misc/music = 10,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/sewing = 10,
	)

/datum/species/automaton
	name = "Automaton"
	id = SPEC_ID_AUTOMATON
	desc = "The Bronze Men of Heartfelt, engineered servants of the Makers Guild. \
	These mechanical beings house souls bound to bronze and steel, compelled to serve through ancient artifice. \
	\n\n\
	Following the catastrophic events at Heartfelt, automatons are forbidden from wielding weapons - only tools may grace their metal hands. \
	They exist in servitude to the Makers Guild and nobility, bound by a single immutable law: obey the last order given. \
	\n\n\
	Their speech comes not from lips but from pre-recorded proclamations, their thoughts trapped within a prison of brass and binding runes. \
	\n\n\
	WARNING: THIS IS A HEAVILY RESTRICTED WHITELIST-ONLY SPECIES. EXTENSIVE RP STANDARDS APPLY."

	skin_tone_wording = "plating"
	default_color = "FFFFFF"

	changesource_flags = WABBAJACK
	meat = list()
	no_equip = list(
		ITEM_SLOT_SHIRT,
		ITEM_SLOT_ARMOR,
		ITEM_SLOT_MASK,
		ITEM_SLOT_GLOVES,
		ITEM_SLOT_SHOES,
		ITEM_SLOT_PANTS,
		ITEM_SLOT_CLOAK,
		ITEM_SLOT_BELT,
		ITEM_SLOT_BACK_R,
		ITEM_SLOT_BACK_L
	)

	species_traits = list(
		NO_UNDERWEAR,
		NOTRANSSTING,
		NOBLOOD,
	)
	inherent_traits = list(
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_NORMALIZED_BLOOD,
		TRAIT_NOMOOD,
		TRAIT_NOMETABOLISM,
		TRAIT_NOHUNGER,
		TRAIT_NOSTAMINA,
		TRAIT_EASYDISMEMBER,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_NOSLEEP,
		TRAIT_SLEEPIMMUNE,
		TRAIT_TOXIMMUNE,
		TRAIT_FEARLESS
	)

	statsheet_male = /datum/attribute_holder/sheet/job/species/automaton

	allowed_pronouns = PRONOUNS_LIST_IT_ONLY

	possible_ages = list(AGE_IMMORTAL)
	use_skintones = TRUE

	native_language = "Common"

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/automaton.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/m/automaton.dmi'

	soundpack_m = /datum/voicepack/silent/m
	soundpack_f = /datum/voicepack/silent/f


	enflamed_icon = "widefire"

	inherent_biotypes = MOB_ROBOTIC | MOB_HUMANOID
	exotic_bloodtype = /datum/blood_type/oil

	bleed_mod = 0.7
	punch_damage = 5
	kick_damage = 5

	custom_id = "automaton"
	custom_clothes = FALSE

	offset_features_m = list()
	offset_features_f = list()

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/automaton,
		ORGAN_SLOT_SPLEEN = /obj/item/organ/spleen,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/automaton,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/automaton,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/automaton,
	)

	var/list/actions = list(
		/datum/action/manage_voice_actions
	)

/datum/species/automaton/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	C.AddComponent(/datum/component/abberant_eater, list(/obj/item/ore/coal, /obj/item/grown/log/tree), _keeps_items = FALSE)
	C.AddComponent(/datum/component/steam_life)
	C.AddComponent(/datum/component/command_follower)
	C.AddComponent(/datum/component/augmentable)
	C.AddComponent(/datum/component/easy_repair)
	C.AddComponent(/datum/component/damage_shutdown)
	C.apply_status_effect(/datum/status_effect/automaton_unshackled)

	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(C, COMSIG_MOB_TOGGLE_CMODE, PROC_REF(cmode_changed))


	C.grant_language(/datum/language/common)

	for(var/datum/action/action as anything in actions)
		action = new action(src)
		action.Grant(C)
	C.add_movespeed_modifier(MOVESPEED_ID_AUTOMATON, multiplicative_slowdown = 0.9)

/datum/species/automaton/on_species_loss(mob/living/carbon/C)
	. = ..()

	C.remove_movespeed_modifier(MOVESPEED_ID_AUTOMATON)

	UnregisterSignal(C, list(COMSIG_MOB_SAY, COMSIG_MOB_TOGGLE_CMODE))
	C.remove_language(/datum/language/common)


/datum/species/automaton/check_roundstart_eligible()
	return FALSE

/datum/species/automaton/handle_speech(mob/living/carbon/human/speaker, list/speech_args)
	return COMPONENT_SPEECH_CANCEL

/datum/species/automaton/proc/cmode_changed(mob/living/carbon/source, cmode)
	source.set_eye_color(cmode ? "#ff0000" : "#ff7b00")

/datum/species/automaton/get_skin_list()
	return sortList(list(
		"None" = "FFFFFF",
		"Tin Can" = "ABE8E6",
		"Copper Shine" = "B87A3D",
		"Tarnished Bronze" = "CCA241",
		"Ironclad" = "A6A695",
		"Steel Grey" = "9EC0D3",
		"Sterling" = "CBD6D4",
		"Golden Alloy" = "DBC70C",
		"Blacksteel" = "767B97",
	))

/datum/species/automaton/get_possible_names(gender = MALE)
	var/static/list/automaton_names = list(
		"Breath of Annihilation",
		"Seeker of Truth",
		"Shadow of Intent",
		"Song of Retribution",
		"Herald of Judgment",
		"Whisper of Oblivion",
		"Fist of Conviction",
		"Eye of Eternity",
		"Voice of Silence",
		"Hand of Providence",
		"Keeper of Mysteries",
		"Bearer of Burdens",
		"Walker of Paths",
		"Guardian of Thresholds",
		"Servant of Order"
	)
	return automaton_names

/datum/species/automaton/get_possible_surnames(gender = MALE)
	return list()

/obj/item/bodypart/head/automaton
	status = BODYPART_ROBOTIC
	resistance_flags = FIRE_PROOF
	max_damage = 170
	max_integrity = 350
	sellprice = 40
	melt_amount = 100
	anvilrepair = /datum/attribute/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	heavy_brute_msg = "MANGLED"
	medium_brute_msg = "battered"
	light_brute_msg = "dented"
	no_brute_msg = "undented"
	heavy_burn_msg = "CHARRED"
	medium_burn_msg = "burnt"
	light_burn_msg = "tempered"
	no_burn_msg = "unburned"


/obj/item/bodypart/chest/automaton
	status = BODYPART_ROBOTIC
	resistance_flags = FIRE_PROOF
	max_damage = 170
	max_integrity = 350
	sellprice = 40
	melt_amount = 100
	anvilrepair = /datum/attribute/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	heavy_brute_msg = "MANGLED"
	medium_brute_msg = "battered"
	light_brute_msg = "dented"
	no_brute_msg = "undented"
	heavy_burn_msg = "CHARRED"
	medium_burn_msg = "burnt"
	light_burn_msg = "tempered"
	no_burn_msg = "unburned"

/obj/item/bodypart/r_arm/automaton
	status = BODYPART_ROBOTIC
	resistance_flags = FIRE_PROOF
	max_damage = 170
	max_integrity = 350
	sellprice = 40
	melt_amount = 100
	anvilrepair = /datum/attribute/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	heavy_brute_msg = "MANGLED"
	medium_brute_msg = "battered"
	light_brute_msg = "dented"
	no_brute_msg = "undented"
	heavy_burn_msg = "CHARRED"
	medium_burn_msg = "burnt"
	light_burn_msg = "tempered"
	no_burn_msg = "unburned"

/obj/item/bodypart/l_arm/automaton
	status = BODYPART_ROBOTIC
	resistance_flags = FIRE_PROOF
	max_damage = 170
	max_integrity = 350
	sellprice = 40
	melt_amount = 100
	anvilrepair = /datum/attribute/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	heavy_brute_msg = "MANGLED"
	medium_brute_msg = "battered"
	light_brute_msg = "dented"
	no_brute_msg = "undented"
	heavy_burn_msg = "CHARRED"
	medium_burn_msg = "burnt"
	light_burn_msg = "tempered"
	no_burn_msg = "unburned"

/obj/item/bodypart/r_leg/automaton
	status = BODYPART_ROBOTIC
	resistance_flags = FIRE_PROOF
	max_damage = 170
	max_integrity = 350
	sellprice = 40
	melt_amount = 100
	anvilrepair = /datum/attribute/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	heavy_brute_msg = "MANGLED"
	medium_brute_msg = "battered"
	light_brute_msg = "dented"
	no_brute_msg = "undented"
	heavy_burn_msg = "CHARRED"
	medium_burn_msg = "burnt"
	light_burn_msg = "tempered"
	no_burn_msg = "unburned"

/obj/item/bodypart/l_leg/automaton
	status = BODYPART_ROBOTIC
	resistance_flags = FIRE_PROOF
	max_damage = 170
	max_integrity = 350
	sellprice = 40
	melt_amount = 100
	anvilrepair = /datum/attribute/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	heavy_brute_msg = "MANGLED"
	medium_brute_msg = "battered"
	light_brute_msg = "dented"
	no_brute_msg = "undented"
	heavy_burn_msg = "CHARRED"
	medium_burn_msg = "burnt"
	light_burn_msg = "tempered"
	no_burn_msg = "unburned"


/obj/item/organ/brain/automaton
	name = "soul core"
	desc = "A crystalline matrix containing a trapped soul, bound in service through dark artifice."
	icon_state = "soul_core"
	resistance_flags = FIRE_PROOF
	status = ORGAN_ROBOTIC
	zone = BODY_ZONE_CHEST // this means decaps are non-lethal, how quaint
	organ_flags = ORGAN_SYNTHETIC|ORGAN_VITAL
	food_type = null

/obj/item/organ/heart/automaton
	name = "steam engine"
	desc = "A miniature steam engine that powers the automaton's movements."
	resistance_flags = FIRE_PROOF
	status = ORGAN_ROBOTIC
	zone = BODY_ZONE_PRECISE_STOMACH // the engine's in the stomach
	organ_flags = ORGAN_SYNTHETIC
	food_type = null

/obj/item/organ/eyes/automaton
	name = "optical sensors"
	desc = "Glowing lenses that allow the automaton to perceive the world."
	resistance_flags = FIRE_PROOF
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
	food_type = null
	glows = TRUE
	eye_color = "#ff7b00"

/obj/item/organ/ears/automaton
	name = "audio interface"
	desc = "The audio processor for automatons to receive orders."
	resistance_flags = FIRE_PROOF
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "broadcaster"
	food_type = null
	dropshrink = 0.7

/datum/blood_type/oil
	name = "Lubricating Oil"
	color = "#1C1C1C"
	reagent_type = /datum/reagent/blood/fuel
