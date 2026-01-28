/mob/living/carbon/human/species/werewolf
	race = /datum/species/werewolf
	footstep_type = FOOTSTEP_MOB_HEAVY
	base_strength = 15
	base_constitution = 15
	base_endurance = 15

	cmode_music = 'sound/music/cmode/antag/combat_werewolf.ogg'
	limb_destroyer = TRUE
	ambushable = FALSE
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)

/datum/species/werewolf
	name = "werewolf"
	id = "werewolf"

	species_traits = list(NO_UNDERWEAR, NOEYESPRITES)
	inherent_traits = list(
		TRAIT_NOSTAMINA,
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RADIMMUNE,
		TRAIT_NODISMEMBER,
		TRAIT_STRONGBITE,
		TRAIT_ZJUMP,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_BASHDOORS,
		TRAIT_STEELHEARTED,
		TRAIT_BREADY,
		TRAIT_ORGAN_EATER,
		TRAIT_NASTY_EATER,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_IGNORESLOWDOWN,
		TRAIT_HARDDISMEMBER,
		TRAIT_UNDODGING,
		TRAIT_UNPARRYING,
		TRAIT_LONGSTRIDER
	)

	inherent_biotypes = MOB_HUMANOID

	no_equip = list(ITEM_SLOT_SHIRT, ITEM_SLOT_HEAD, ITEM_SLOT_MASK, ITEM_SLOT_ARMOR, ITEM_SLOT_GLOVES, ITEM_SLOT_SHOES, ITEM_SLOT_PANTS, ITEM_SLOT_CLOAK, ITEM_SLOT_BELT, ITEM_SLOT_BACK_R, ITEM_SLOT_BACK_L)

	offset_features_m = list(OFFSET_HANDS = list(0,2))
	offset_features_f = list(OFFSET_HANDS = list(0,2))

	soundpack_m = /datum/voicepack/werewolf
	soundpack_f = /datum/voicepack/werewolf

	specstats_m = list(STATKEY_STR = 5, STATKEY_PER = 5, STATKEY_INT = -3, STATKEY_CON = 5, STATKEY_END = 5, STATKEY_SPD = 3, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = 5, STATKEY_PER = 5, STATKEY_INT = -3, STATKEY_CON = 5, STATKEY_END = 5, STATKEY_SPD = 3, STATKEY_LCK = 0)

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/werewolf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	changesource_flags = WABBAJACK
	bleed_mod = 0.6
	pain_mod = 0.2

/datum/species/werewolf/send_voice(mob/living/carbon/human/H)
	playsound(H, pick('sound/vo/mobs/wwolf/wolftalk1.ogg', 'sound/vo/mobs/wwolf/wolftalk2.ogg'), 100, TRUE, -1)

/datum/species/werewolf/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/werewolf.dmi'
	if(H.gender == MALE)
		H.icon_state = "wwolf_m"
	if(H.gender == FEMALE)
		H.icon_state = "wwolf_f"
	if(H.age == AGE_CHILD)
		H.icon_state = "wwolf_c"
	H.update_damage_overlays()
	return TRUE

/datum/species/werewolf/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.remove_all_languages()
	C.grant_language(/datum/language/beast)

/datum/species/werewolf/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	var/list/hands = list()
	var/mutable_appearance/inhand_overlay = mutable_appearance("[H.icon_state]-dam", layer=-DAMAGE_LAYER)
	var/burnhead = 0
	var/brutehead = 0
	var/burnch = 0
	var/brutech = 0
	var/obj/item/bodypart/affecting = H.get_bodypart(BODY_ZONE_HEAD)
	if(affecting)
		burnhead = (affecting.burn_dam / affecting.max_damage)
		brutehead = (affecting.brute_dam / affecting.max_damage)
	affecting = H.get_bodypart(BODY_ZONE_CHEST)
	if(affecting)
		burnch = (affecting.burn_dam / affecting.max_damage)
		brutech = (affecting.brute_dam / affecting.max_damage)
	var/usedloss = 0
	if(burnhead > usedloss)
		usedloss = burnhead
	if(brutehead > usedloss)
		usedloss = brutehead
	if(burnch > usedloss)
		usedloss = burnch
	if(brutech > usedloss)
		usedloss = brutech
	inhand_overlay.alpha = 255 * usedloss
	hands += inhand_overlay
	H.overlays_standing[DAMAGE_LAYER] = hands
	H.apply_overlay(DAMAGE_LAYER)
	return TRUE

/datum/species/werewolf/random_name(gender,unique,lastname)
	return "WEREVOLF"

/datum/species/werewolf/check_species_weakness(obj/item, mob/living/attacker, mob/living/parent)
	if(parent.has_status_effect(/datum/status_effect/debuff/silver_bane))
		return 0.75
	return 0
