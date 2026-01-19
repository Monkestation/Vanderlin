/obj/item/weapon
	name = "weapon"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	force = 15
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	block_chance = 0
	armor_penetration = 5
	sharpness = IS_SHARP
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST)
	can_parry = TRUE
	sellprice = 1
	has_inspect_verb = TRUE
	pickup_sound = "rustle" // Sound list define strings are in code/game/sound.dm
	parrysound = list('sound/combat/parry/parrygen.ogg')
	drop_sound = 'sound/foley/dropsound/mace_drop.ogg'
	anvilrepair = /datum/skill/craft/weaponsmithing
	obj_flags = CAN_BE_HIT
	blade_dulling = DULLING_BASH
	resistance_flags = FIRE_PROOF
	max_integrity = INTEGRITY_STANDARD
	wdefense = GOOD_PARRY
	experimental_onhip = TRUE
	experimental_onback = TRUE
	embedding = list(
		"embed_chance" = 0, //Leave this at 0 until embed code is given an overhaul. Ideally each weapon should have a different value. Doesn't affect ranged or things like mantraps.
		"embedded_pain_multiplier" = 1,
		"embedded_fall_chance" = 0,
	)
	var/initial_sl
	var/list/possible_enhancements
	var/renamed_name
	var/axe_cut = 0
	istrainable = TRUE // You can train weapon skills on a dummy with these.

/obj/item/weapon/Initialize(mapload)
	. = ..()
	if(!destroy_message)
		destroy_message = span_warning("[pick("[src] is broken!", "[src] is useless!", "[src] is destroyed!")]")

	update_integrity(max_integrity + rand(-(max_integrity * 0.2), 0), FALSE)

/obj/item/weapon/attack_hand(mob/user)
	if(is_species(user, /datum/species/werewolf)) //slop fix
		return TRUE
	. = ..()

/obj/item/weapon/pickup(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_RAVOX_CURSE) && prob(33))
		var/mob/living/carbon/human/H = user
		to_chat(H, span_warning("The idea repulses me!"))
		H.cursed_freak_out()
		H.Paralyze(4 SECONDS)
		return

/obj/item/weapon/get_examine_string(mob/user, thats = FALSE)
	return "[thats? "That's ":""]<b>[get_examine_name(user)]</b>"

/obj/item/weapon/get_dismemberment_chance(obj/item/bodypart/affecting, mob/user)
	if(!get_sharpness() || !affecting.can_dismember(src))
		return 0

	var/total_dam = affecting.get_damage()
	var/nuforce = get_complex_damage(src, user)
	var/pristine_blade = TRUE
	if(max_blade_int && dismember_blade_int)
		var/blade_int_modifier = (blade_int / dismember_blade_int)
		//blade is about as sharp as a brick it won't dismember shit
		if(blade_int_modifier <= 0.15)
			return 0
		nuforce *= blade_int_modifier
		pristine_blade = (blade_int >= (dismember_blade_int * 0.95))

	if(user)
		if(istype(user.rmb_intent, /datum/rmb_intent/weak))
			nuforce = 0
		else if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			nuforce *= 1.1

		if(user.used_intent.blade_class == BCLASS_CHOP) //chopping attacks always attempt dismembering
			nuforce *= 1.1
		else if(user.used_intent.blade_class == BCLASS_CUT)
			if(!pristine_blade && (total_dam < affecting.max_damage * 0.8))
				return 0
		else
			return 0

	if(nuforce < 23) //End force needs to be at least this high, after accounting for strong intent and chop. An iron messer should be able to do it, but not a dagger.
		return 0

	var/probability = (nuforce * (total_dam / affecting.max_damage) - 5) //More weight given to total damage accumulated on the limb
	if(affecting.body_zone == BODY_ZONE_HEAD) //Decapitations are harder to pull off in general
		probability *= 0.5
	var/hard_dismember = HAS_TRAIT(affecting, TRAIT_HARDDISMEMBER)
	var/easy_dismember = affecting.rotted || affecting.skeletonized || HAS_TRAIT(affecting, TRAIT_EASYDISMEMBER)
	if(affecting.owner)
		if(!hard_dismember)
			hard_dismember = HAS_TRAIT(affecting.owner, TRAIT_HARDDISMEMBER)
		if(!easy_dismember)
			easy_dismember = HAS_TRAIT(affecting.owner, TRAIT_EASYDISMEMBER)
	if(hard_dismember)
		return min(probability, 5)
	else if(easy_dismember)
		return probability * 1.5
	return probability

/obj/item/weapon/OnCrafted(dirin, mob/user)
	. = ..()
	update_integrity(max_integrity)
