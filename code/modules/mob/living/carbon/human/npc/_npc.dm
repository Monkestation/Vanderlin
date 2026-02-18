#define MAX_RANGE_FIND 32

/mob/living/carbon/human
	var/resisting = FALSE
	var/pickpocketing = FALSE
	var/del_on_deaggro = null
	var/last_aggro_loss = null
	var/wander = TRUE
	var/ai_when_client = FALSE
	var/flee_in_pain = FALSE
	var/stand_attempts = 0
	var/resist_attempts = 0
	var/attack_speed = 0

	var/returning_home = FALSE

/mob/living/carbon/human/proc/IsStandingStill()
	return resisting || pickpocketing

/mob/living/carbon/human/proc/npc_stand()
	// the sane way to do this would be to try and check if we can even realistically stand
	resisting = TRUE
	if(stand_up())
		stand_attempts = 0
		resisting = FALSE
		return TRUE
	else
		stand_attempts += rand(1,3)
		resisting = FALSE
		return FALSE

// taken from /mob/living/carbon/human/interactive/
/mob/living/carbon/human/proc/IsDeadOrIncap(checkDead = TRUE)
	// if(!(mobility_flags & MOBILITY_FLAGS_INTERACTION))
	// 	return 1
	if(health <= 0 && checkDead)
		return 1
	if(HAS_TRAIT(src, TRAIT_INCAPACITATED))
		return 1
	if(stat)
		return 1
	return 0


/mob/living/carbon/human/proc/equip_item(obj/item/I)
	if(I.loc == src)
		return TRUE

	if(I.anchored)
		return FALSE

	if(istype(I, /obj/item/clothing))
		if(pickup_and_wear(I))
			return TRUE

	// WEAPONS
	if(istype(I, /obj/item))
		if(get_active_held_item())
			dropItemToGround(get_active_held_item())
		if(put_in_hands(I))
			return TRUE

	return FALSE

/mob/living/carbon/human/proc/pickup_and_wear(obj/item/clothing/C)
	if(!equip_to_appropriate_slot(C))
		monkeyDrop(get_item_by_slot(C)) // remove the existing item if worn
		addtimer(CALLBACK(src, PROC_REF(equip_to_appropriate_slot), C), 5)
	return TRUE

/mob/living/carbon/human/proc/monkeyDrop(obj/item/A)
	if(A)
		dropItemToGround(A, TRUE)

/mob/living/carbon/human/resist_restraints()
	var/obj/item/I = null
	if(handcuffed)
		I = handcuffed
	else if(legcuffed)
		I = legcuffed
	if(I)
		changeNext_move(CLICK_CD_BREAKOUT)
		last_special = world.time + CLICK_CD_BREAKOUT
		cuff_resist(I)

// attack using a held weapon otherwise bite the enemy, then if we are angry there is a chance we might calm down a little
/mob/living/carbon/human/proc/monkey_attack(mob/living/L)
	if(next_move > world.time)
		return
	var/obj/item/Weapon = get_active_held_item()
	var/obj/item/OffWeapon = get_inactive_held_item()
	if(Weapon && OffWeapon)
		if(OffWeapon.force > Weapon.force)
			swap_hand()
			Weapon = get_active_held_item()
			OffWeapon = get_inactive_held_item()
	if(!Weapon)
		swap_hand()
		Weapon = get_active_held_item()
		OffWeapon = get_inactive_held_item()
	if(body_position == LYING_DOWN)
		aimheight_change(rand(1,10))
	else
		aimheight_change(rand(10,19))

	// attack with weapon if we have one
	if(Weapon)
		if(!HAS_TRAIT(Weapon, TRAIT_WIELDED))
			if(Weapon.force_wielded > Weapon.force)
				if(!OffWeapon)
					Weapon.attack_self(src)
		rog_intent_change(1)
		used_intent = a_intent
		cast_move = 0
		Weapon.melee_attack_chain(src, L)
	else
		rog_intent_change(4)
		used_intent = a_intent
		cast_move = 0
		UnarmedAttack(L,1)

	var/adf = ((used_intent.clickcd + 8) - round((src.STASPD - 10) / 2) - attack_speed)
	if(istype(rmb_intent, /datum/rmb_intent/aimed))
		adf = round(adf * 1.4)
	if(istype(rmb_intent, /datum/rmb_intent/swift))
		adf = round(adf * 0.6)
	changeNext_move(adf)


/mob/living/proc/npc_detect_sneak(mob/living/target, extra_prob = 0)
	if (target.alpha > 0 || !target.rogue_sneaking)
		return TRUE
	var/probby = 4 * STAPER //this is 10 by default - npcs get an easier time to detect to slightly thwart cheese
	probby += extra_prob
	var/sneak_bonus = 0
	if(target.mind)
		if(target.has_status_effect(/datum/status_effect/invisibility))
			// we're invisible as per the spell effect, so use the highest of our arcane magic (or holy) skill instead of our sneaking
			sneak_bonus = (max(target.get_skill_level(/datum/skill/magic/arcane, TRUE), target.get_skill_level(/datum/skill/magic/holy, TRUE)) * 10)
			probby -= 20 // also just a fat lump of extra difficulty for the npc since spells are hard, you know?
		else
			sneak_bonus = (target.get_skill_level(/datum/skill/misc/sneaking, TRUE) * 5)
		probby -= sneak_bonus

	probby += 100 * target.get_encumbrance()
	if (target.stat_roll(STATKEY_LCK,5,10,TRUE))
		probby += (10 - target.STALUC) * 5 // drop 5% chance for every bit of fortune we're missing
	if (target.stat_roll(STATKEY_LCK,5,10))
		probby -= (10 - target.STALUC) * 5 // make it 5% harder for every bit of fortune over 10 that we do have

	if (prob(probby))
		// whoops it saw us
		MOBTIMER_SET(target, MT_FOUNDSNEAK)
		to_chat(target, span_danger("[src] sees me! I'm found!"))
		target.update_sneak_invis(TRUE)
		return TRUE
	else
		return FALSE

#undef MAX_RANGE_FIND
