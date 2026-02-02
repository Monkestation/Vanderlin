
/obj/item/bodypart/proc/can_dismember(obj/item/I)
	return dismemberable

// /obj/item/bodypart/proc/can_disable(obj/item/I)
// 	return disableable

/obj/item/bodypart
	/// Wound we get when surgically reattached
	var/attach_wound = /datum/wound/slash/large
	/// Wound we leave on the chest when violently dismembered
	var/dismember_wound
	/// Sound we make when violently dismembered
	var/list/dismemsound = list(
		'sound/combat/dismemberment/dismem (1).ogg',
		'sound/combat/dismemberment/dismem (2).ogg',
		'sound/combat/dismemberment/dismem (3).ogg',
		'sound/combat/dismemberment/dismem (5).ogg',
		'sound/combat/dismemberment/dismem (6).ogg',
	)

//Dismember a limb
/obj/item/bodypart/head/dismember(dam_type, bclass, mob/living/user, zone_precise)
	. = ..()
	add_abstract_elastic_data(ELASCAT_COMBAT, ELASDATA_DECAPITATIONS, 1)

/obj/item/bodypart/proc/dismember(dam_type = BRUTE, bclass = BCLASS_CUT, mob/living/user, zone_precise = src.body_zone)
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		if(zone_precise != BODY_ZONE_PRECISE_NECK)
			return FALSE
	if(C.status_flags & GODMODE)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		var/obj/item/clothing/checked_armor = human_owner.check_crit_armor(zone_precise, bclass)
		if(checked_armor)
			var/int_percent = round(((checked_armor.get_integrity() / checked_armor.max_integrity) * 100), 1)
			if(int_percent > 30 && !HAS_TRAIT(human_owner, TRAIT_CRITICAL_WEAKNESS) && !HAS_TRAIT(human_owner, TRAIT_EASYDISMEMBER))
				to_chat(human_owner, span_green("My [checked_armor.name] just saved me from losing my [src.name]!"))
				checked_armor.take_damage(checked_armor.max_integrity / 2, damage_flag = bclass)
				return FALSE

	var/obj/item/bodypart/affecting = C.get_bodypart(BODY_ZONE_CHEST)
	if(affecting && dismember_wound)
		affecting.add_wound(dismember_wound)
	playsound(C, pick(dismemsound), 50, FALSE, -1)
	if(body_zone == BODY_ZONE_HEAD)
		C.visible_message("<span class='danger'><B>[C] is [pick("BRUTALLY","VIOLENTLY","BLOODILY","MESSILY")] DECAPITATED!</B></span>")
	else
		C.visible_message("<span class='danger'><B>The [src.name] is [pick("torn off", "sundered", "severed", "separated", "unsewn")]!</B></span>")
	C.emote("painscream")
	src.add_mob_blood(C)
	C.add_stress(/datum/stress_event/dismembered)
	C.add_stress(/datum/stress_event/dismembered)
	var/stress2give
	if(!skeletonized && C.dna?.species) //we need a skeleton species for skeleton npcs
		if(C.dna.species.id != SPEC_ID_GOBLIN && C.dna.species.id != SPEC_ID_ROUSMAN) //convert this into a define list later
			stress2give = /datum/stress_event/viewdismember
	if(C)
		if(C.buckled)
			if(istype(C.buckled, /obj/structure/fluff/psycross) || istype(C.buckled, /obj/machinery/light/fueled/campfire/pyre))
				if((C.real_name in GLOB.excommunicated_players) || (C.real_name in GLOB.heretical_players))
					stress2give = /datum/stress_event/viewsinpunish
			else if(istype(C.buckled, /obj/structure/guillotine))
				stress2give = null
	if(stress2give)
		for(var/mob/living/carbon/CA in hearers(world.view, C))
			if(CA != C && !CA.is_blind())
				if(stress2give == /datum/stress_event/viewdismember)
					if(HAS_TRAIT(CA, TRAIT_STEELHEARTED))
						continue
					if(CA.has_quirk(/datum/quirk/vice/maniac))
						CA.add_stress(/datum/stress_event/viewdismembermaniac)
						CA.sate_addiction(/datum/quirk/vice/maniac)
						continue
					if(CA.gender == FEMALE)
						CA.add_stress(/datum/stress_event/fviewdismember)
						continue
				CA.add_stress(stress2give)
	if(grabbedby)
		QDEL_LIST(grabbedby)
	drop_limb()

	if(dam_type == BURN)
		burn()
		return TRUE

	var/turf/location = C.loc
	if(istype(location))
		C.add_splatter_floor(location)
	var/direction = pick(GLOB.cardinals)
	var/t_range = rand(2,max(throw_range/2, 2))
	var/turf/target_turf = get_turf(src)
	for(var/i in 1 to t_range-1)
		var/turf/new_turf = get_step(target_turf, direction)
		if(!new_turf)
			break
		target_turf = new_turf
		if(new_turf.density)
			break
	throw_at(target_turf, throw_range, throw_speed)
	return TRUE

/obj/item/bodypart/chest/dismember(dam_type = BRUTE, bclass = BCLASS_CUT, mob/living/user, zone_precise = src.body_zone)
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(!dismemberable)
		return FALSE
	if(skeletonized)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE
	. = list()
	var/organ_spilled = 0
	var/turf/T = get_turf(C)
	C.add_splatter_floor(T)
	playsound(C, 'sound/combat/crit2.ogg', 100, FALSE, 5)
	C.emote("painscream")
	for(var/obj/item/organ/O as anything in C.internal_organs)
		var/org_zone = check_zone(O.zone)
		if(org_zone != BODY_ZONE_CHEST)
			continue
		O.Remove(C)
		O.forceMove(T)
		O.add_mob_blood(C)
		organ_spilled = 1
		. += O
	if(cavity_item)
		cavity_item.forceMove(T)
		. += cavity_item
		cavity_item = null
		organ_spilled = 1

	if(organ_spilled)
		C.visible_message("<span class='danger'><B>[C] spills [C.p_their()] guts!</B></span>")
	return TRUE

//limb removal. The "special" argument is used for swapping a limb with a new one without the effects of losing a limb kicking in.
/obj/item/bodypart/proc/drop_limb(special)
	if(!owner)
		return FALSE
	var/atom/drop_location = owner.drop_location()
	var/mob/living/carbon/was_owner = owner
	update_limb(TRUE, owner)

	if(length(wounds))
		var/list/stored_wounds = list()
		for(var/datum/wound/wound as anything in wounds)
			wound.remove_from_bodypart()
			if(wound.qdel_on_droplimb)
				qdel(wound)
			else
				stored_wounds += wound //store for later when the limb is reattached
		wounds = stored_wounds
	//if we had an ongoing surgery on this limb, we stop it
	for(var/body_zone in was_owner.surgeries)
		if(check_zone(body_zone) != body_zone)
			continue
		was_owner.surgeries -= body_zone
	for(var/obj/item/embedded in embedded_objects)
		remove_embedded_object(embedded)
	if(bandage)
		if(drop_location)
			bandage.forceMove(drop_location)
		else
			qdel(bandage)
		bandage = null

	if(!special)
		for(var/obj/item/organ/organ as anything in was_owner.internal_organs) //internal organs inside the dismembered limb are dropped.
			var/org_zone = check_zone(organ.zone)
			if(org_zone != body_zone)
				continue
			organ.transfer_to_limb(src, was_owner)

	if(held_index)
		was_owner.dropItemToGround(owner.get_item_for_held_index(held_index), force = TRUE)
		was_owner.hand_bodyparts[held_index] = null
	was_owner.remove_bodypart(src)
	owner = null
	update_icon_dropped()
	was_owner.update_health_hud() //update the healthdoll
	was_owner.update_body()

	// drop_location = null happens when a "dummy human" used for rendering icons on prefs screen gets its limbs replaced.
	if(!drop_location)
		qdel(src)
		return TRUE

	forceMove(drop_location)
	return TRUE

//when a limb is dropped, the internal organs are removed from the mob and put into the limb
/obj/item/organ/proc/transfer_to_limb(obj/item/bodypart/LB, mob/living/carbon/C)
	Remove(C)
	forceMove(LB)
	return TRUE

/obj/item/organ/brain/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	Remove(C) //Changeling brain concerns are now handled in Remove
	forceMove(LB)
	if(istype(LB))
		LB.brain = src
	if(brainmob)
		LB.brainmob = brainmob
		LB.brainmob.forceMove(LB)
		LB.brainmob.set_stat(DEAD)
	brainmob = null
	return TRUE

/obj/item/organ/eyes/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	if(istype(LB))
		LB.eyes = src
	return ..()

/obj/item/organ/ears/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	if(istype(LB))
		LB.ears = src
	return ..()

/obj/item/organ/tongue/transfer_to_limb(obj/item/bodypart/head/LB, mob/living/carbon/human/C)
	if(istype(LB))
		LB.tongue = src
	return ..()

/obj/item/bodypart/chest/drop_limb(special)
	if(special)
		return ..()
	return FALSE

/obj/item/bodypart/r_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.set_handcuffed(null)
			C.update_handcuffed()
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/R = C.hud_used.hand_slots["[held_index]"]
			if(R)
				R.update_appearance(UPDATE_OVERLAYS)
		if(C.gloves && (C.num_hands < 1))
			C.dropItemToGround(C.gloves, force = TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay
		C.update_inv_armor()


/obj/item/bodypart/l_arm/drop_limb(special)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.set_handcuffed(null)
			C.update_handcuffed()
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/L = C.hud_used.hand_slots["[held_index]"]
			if(L)
				L.update_appearance(UPDATE_OVERLAYS)
		if(C.gloves && (C.num_hands < 1))
			C.dropItemToGround(C.gloves, force = TRUE)
		C.update_inv_gloves() //to remove the bloody hands overlay
		C.update_inv_armor()

/obj/item/bodypart/r_leg/drop_limb(special)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.legcuffed)
			C.legcuffed.forceMove(C.drop_location()) //At this point bodypart is still in nullspace
			C.legcuffed.dropped(C)
			C.legcuffed = null
			C.remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
			C.update_inv_legcuffed()
		if(C.shoes && (C.num_legs < 1))
			C.dropItemToGround(C.shoes, force = TRUE)
		C.update_inv_shoes()
		C.update_inv_pants()

/obj/item/bodypart/l_leg/drop_limb(special) //copypasta
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.legcuffed)
			C.legcuffed.forceMove(C.drop_location())
			C.legcuffed.dropped(C)
			C.legcuffed = null
			C.remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
			C.update_inv_legcuffed()
		if(C.shoes && (C.num_legs < 1))
			C.dropItemToGround(C.shoes, force = TRUE)
		C.update_inv_shoes()
		C.update_inv_pants()

/obj/item/bodypart/head/drop_limb(special)
	if(!special)
		//Drop all worn head items
		var/list/worn_items = list(
			owner.get_item_by_slot(ITEM_SLOT_HEAD),
			owner.get_item_by_slot(ITEM_SLOT_NECK),
			owner.get_item_by_slot(ITEM_SLOT_MASK),
			owner.get_item_by_slot(ITEM_SLOT_MOUTH),
		)
		for(var/obj/item/worn_item in worn_items)
			owner.dropItemToGround(worn_item, force = TRUE)

	name = "[owner.real_name]'s head"
	. = ..()

//Attach a limb to a human and drop any existing limb of that type.
/obj/item/bodypart/proc/replace_limb(mob/living/carbon/C, special)
	if(!istype(C))
		return
	var/obj/item/bodypart/O = C.get_bodypart(body_zone)
	if(O)
		O.drop_limb(1)
	return attach_limb(C, special)

/obj/item/bodypart/head/replace_limb(mob/living/carbon/C, special)
	if(!istype(C))
		return
	var/obj/item/bodypart/head/O = C.get_bodypart(body_zone)
	if(O)
		if(!special)
			return
		else
			O.drop_limb(1)
	return attach_limb(C, special)

/obj/item/bodypart/proc/attach_limb(mob/living/carbon/C, special)
	moveToNullspace()
	set_owner(C)
	C.add_bodypart(src)
	if(held_index)
		if(held_index > C.hand_bodyparts.len)
			C.hand_bodyparts.len = held_index
		C.hand_bodyparts[held_index] = src
		if(C.dna.species.mutanthands)
			C.put_in_hand(new C.dna.species.mutanthands(), held_index)
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/hand = C.hud_used.hand_slots["[held_index]"]
			if(hand)
				hand.update_appearance(UPDATE_OVERLAYS)
		C.update_inv_gloves()

	if(special) //non conventional limb attachment
		//if we had an ongoing surgery to attach a new limb, we stop it.
		for(var/body_zone in C.surgeries)
			if(check_zone(body_zone) != body_zone)
				continue
			C.surgeries -= body_zone

	for(var/obj/item/organ/stored_organ as anything in src)
		stored_organ.Insert(C)

	for(var/datum/wound/wound as anything in wounds)
		wounds -= wound
		wound.apply_to_bodypart(src, silent = TRUE, crit_message = FALSE)

	var/obj/item/bodypart/affecting = C.get_bodypart(BODY_ZONE_CHEST)
	if(affecting && dismember_wound)
		affecting.remove_wound(dismember_wound)

	update_bodypart_damage_state()

	C.updatehealth()
	C.update_body()
	C.update_damage_overlays()

/obj/item/bodypart/head/attach_limb(mob/living/carbon/C, special)
	//Transfer some head appearance vars over
	if(brain)
		if(brainmob)
			brainmob.forceMove(brain) //Throw mob into brain.
			brain.brainmob = brainmob //Set the brain to use the brainmob
			brainmob = null //Set head brainmob var to null
		brain.Insert(C) //Now insert the brain proper
		brain = null //No more brain in the head

	if(tongue)
		tongue = null
	if(ears)
		ears = null
	if(eyes)
		eyes = null

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.lip_style = lip_style
		H.lip_color = lip_color
	if(real_name)
		C.real_name = real_name
	real_name = ""
	name = initial(name)

	return ..()

/// Restores lost limbs. Does not heal existing limbs.
/mob/living/carbon/proc/regenerate_limbs(list/excluded_zones = list())
	SEND_SIGNAL(src, COMSIG_CARBON_REGENERATE_LIMBS, excluded_zones)
	var/list/limb_list = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	if(excluded_zones)
		limb_list -= excluded_zones
	for(var/limb_zone in limb_list)
		. += regenerate_limb(limb_zone)

/mob/living/carbon/proc/regenerate_limb(limb_zone)
	var/obj/item/bodypart/limb
	if(get_bodypart(limb_zone))
		return FALSE
	limb = newBodyPart(limb_zone, 0, 0)
	if(limb)
		limb.attach_limb(src, TRUE)
		return TRUE
