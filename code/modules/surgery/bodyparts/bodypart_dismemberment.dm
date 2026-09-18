
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
/obj/item/bodypart/proc/dismember(dam_type = BRUTE, bclass = BCLASS_CUT, mob/living/user, zone_precise = body_zone, forced = FALSE)
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

	if(HAS_TRAIT(C, TRAIT_NODECAPITATE) && ((zone_precise == BODY_ZONE_HEAD) || (zone_precise == BODY_ZONE_PRECISE_NECK)))
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_CARBON_DISMEMBER, src) & COMPONENT_CANCEL_DISMEMBER)
		return FALSE //signal handled the dropping

	if(!forced && ishuman(owner))
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

	if(C.can_feel_pain())
		C.emote("painscream")

	add_mob_blood(C)

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
					if(CA.has_quirk(/datum/quirk/vice/addiction/sadist))
						CA.add_stress(/datum/stress_event/viewdismembermaniac)
						CA.sate_addiction(/datum/quirk/vice/addiction/sadist)
						continue
					if(CA.gender == FEMALE)
						CA.add_stress(/datum/stress_event/fviewdismember)
						continue
				CA.add_stress(stress2give)

	if(LAZYLEN(grabbedby))
		QDEL_LIST(grabbedby)

	drop_limb()

	if(dam_type == BURN)
		burn()
		return TRUE

	var/turf/location = C.loc
	for(var/atom/movable/item as anything in cavity_items)
		item.forceMove(location)
		cavity_items -= item

	if(istype(location))
		var/attack_direction = pick(GLOB.alldirs)
		C.add_splatter_floor(location)
		C.add_splatter_wall(force = 2, spill_amount = 3, splatter_direction = attack_direction) //Garunteed at least 2 tile distance of blood spattering on the walls, and up to 3 walls to splat.
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

/obj/item/bodypart/chest/dismember(dam_type = BRUTE, bclass = BCLASS_CUT, mob/living/user, zone_precise = body_zone, forced = FALSE)
	if(!owner)
		return FALSE

	var/mob/living/carbon/chest_owner = owner
	if(!dismemberable)
		return FALSE

	if(skeletonized)
		return FALSE

	if(HAS_TRAIT(chest_owner, TRAIT_NODISMEMBER))
		return FALSE

	. = list()
	if(isturf(chest_owner.loc))
		chest_owner.add_splatter_floor(chest_owner.loc)
	playsound(chest_owner, 'sound/combat/crit2.ogg', 100, FALSE, 5)

	chest_owner.emote("painscream")

	var/list/dropped_items = drop_organs()
	if(length(dropped_items))
		for(var/atom/movable/thing as anything in dropped_items)
			thing.add_mob_blood(chest_owner)
		chest_owner.visible_message("<span class='danger'><B>[chest_owner] spills [chest_owner.p_their()] guts!</B></span>")

	return TRUE

/obj/item/bodypart/head/dismember(dam_type, bclass, mob/living/user, zone_precise, forced)
	if(owner && HAS_TRAIT(owner, TRAIT_NODECAPITATE))
		return FALSE
	. = ..()

	if(owner?.client)
		add_abstract_elastic_data(ELASCAT_COMBAT, ELASDATA_DECAPITATIONS, 1)

//limb removal. The "special" argument is used for swapping a limb with a new one without the effects of losing a limb kicking in.
/obj/item/bodypart/proc/drop_limb(special, dismembered, move_to_floor = TRUE)
	if(!owner)
		return FALSE

	var/atom/drop_location = owner.drop_location()

	remove_chronic()
	update_limb(TRUE)
	owner.remove_bodypart(src, special)

	if(length(wounds))
		var/list/stored_wounds = list()
		for(var/datum/wound/wound as anything in wounds)
			wound.remove_from_bodypart()
			if(wound.qdel_on_droplimb)
				qdel(wound)
			else
				stored_wounds += wound //store for later when the limb is reattached
		wounds = stored_wounds

	var/mob/living/carbon/phantom_owner = update_owner(null) // so we can still refer to the guy who lost their limb after said limb forgets 'em

	for(var/obj/item/embedded in embedded_objects)
		remove_embedded_object(embedded)

	for(var/datum/injury/injury as anything in injuries)
		injury.remove_from_mob()

	if(bandage)
		if(drop_location)
			bandage.forceMove(drop_location)
		else
			qdel(bandage)
		bandage = null
		unbandage_limb()

	if(held_index)
		phantom_owner.dropItemToGround(phantom_owner.get_item_for_held_index(held_index), force = TRUE)
		phantom_owner.hand_bodyparts[held_index] = null

	update_icon_dropped()
	phantom_owner.update_health_hud() //update the healthdoll
	phantom_owner.update_body()
	phantom_owner.update_body_parts()

	if(CHECK_BITFIELD(limb_flags, BODYPART_VITAL))
		phantom_owner.death()

	if(move_to_floor)
		if(!drop_location) // drop_location = null happens when a "dummy human" used for rendering icons on prefs screen gets its limbs replaced.
			qdel(src)
			return
		forceMove(drop_location)

	return TRUE

/obj/item/organ/eyes/on_bodypart_insert(obj/item/bodypart/head/head)
	if(istype(head))
		if(side == RIGHT_SIDE)
			head.eyes_right = src
		if(side == LEFT_SIDE)
			head.eyes_left = src

	return ..()

/obj/item/organ/ears/on_bodypart_insert(obj/item/bodypart/head/head)
	if(istype(head))
		head.ears = src
	return ..()

/obj/item/organ/brain/on_bodypart_insert(obj/item/bodypart/head/head)
	if(istype(head))
		head.brain = src
	return ..()

/obj/item/organ/eyes/on_bodypart_remove(obj/item/bodypart/head/head)
	if(istype(head))
		if(side == RIGHT_SIDE)
			head.eyes_right = null
		if(side == LEFT_SIDE)
			head.eyes_left = null

	return ..()

/obj/item/organ/ears/on_bodypart_remove(obj/item/bodypart/head/head)
	if(istype(head))
		head.ears = null
	return ..()

/obj/item/organ/brain/on_bodypart_remove(obj/item/bodypart/head/head)
	if(istype(head))
		head.brain = null
	return ..()

/obj/item/bodypart/chest/drop_limb(special, dismembered, move_to_floor = TRUE)
	if(special)
		return ..()
	return FALSE

/obj/item/bodypart/r_arm/drop_limb(special, dismembered, move_to_floor = TRUE)
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
		if(!(C?.status_flags & BUILDING_ORGANS))
			C.update_inv_gloves() //to remove the bloody hands overlay
			C.update_inv_armor()


/obj/item/bodypart/l_arm/drop_limb(special, dismembered, move_to_floor = TRUE)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.handcuffed)
			C.handcuffed.forceMove(drop_location())
			C.handcuffed.dropped(C)
			C.set_handcuffed(null)
			if(!(C.status_flags & BUILDING_ORGANS))
				C.update_handcuffed()
		if(C.hud_used)
			var/atom/movable/screen/inventory/hand/L = C.hud_used.hand_slots["[held_index]"]
			if(L)
				L.update_appearance(UPDATE_OVERLAYS)
		if(C.gloves && (C.num_hands < 1))
			C.dropItemToGround(C.gloves, force = TRUE)
		if(!(C.status_flags & BUILDING_ORGANS))
			C.update_inv_gloves() //to remove the bloody hands overlay
			C.update_inv_armor()

/obj/item/bodypart/r_leg/drop_limb(special, dismembered, move_to_floor = TRUE)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.legcuffed)
			C.legcuffed.forceMove(C.drop_location()) //At this point bodypart is still in nullspace
			C.legcuffed.dropped(C)
			C.legcuffed = null
			if(!(C.status_flags & BUILDING_ORGANS))
				C.remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
				C.update_inv_legcuffed()
		if(C.shoes && (C.num_legs < 1))
			C.dropItemToGround(C.shoes, force = TRUE)
		if(!(C.status_flags & BUILDING_ORGANS))
			C.update_inv_shoes()
			C.update_inv_pants()

/obj/item/bodypart/l_leg/drop_limb(special, dismembered, move_to_floor = TRUE)
	var/mob/living/carbon/C = owner
	. = ..()
	if(C && !special)
		if(C.legcuffed)
			C.legcuffed.forceMove(C.drop_location())
			C.legcuffed.dropped(C)
			C.legcuffed = null
			if(!(C.status_flags & BUILDING_ORGANS))
				C.remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
				C.update_inv_legcuffed()
		if(C.shoes && (C.num_legs < 1))
			C.dropItemToGround(C.shoes, force = TRUE)
		if(!(C.status_flags & BUILDING_ORGANS))
			C.update_inv_shoes()
			C.update_inv_pants()

/obj/item/bodypart/head/drop_limb(special, dismembered, move_to_floor = TRUE)
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

/obj/item/bodypart/proc/attach_limb(mob/living/carbon/new_limb_owner, special)
	update_chronic()

	new_limb_owner.add_bodypart(src)

	if(held_index)
		if(held_index > new_limb_owner.hand_bodyparts.len)
			new_limb_owner.hand_bodyparts.len = held_index
		new_limb_owner.hand_bodyparts[held_index] = src
		if(new_limb_owner.dna.species.mutanthands)
			new_limb_owner.put_in_hand(new new_limb_owner.dna.species.mutanthands(), held_index)
		if(new_limb_owner.hud_used)
			var/atom/movable/screen/inventory/hand/hand = new_limb_owner.hud_used.hand_slots["[held_index]"]
			if(hand)
				hand.update_appearance(UPDATE_OVERLAYS)
		if(!(new_limb_owner.status_flags & BUILDING_ORGANS))
			new_limb_owner.update_inv_gloves()

	if(special) //non conventional limb attachment
		for(var/obj/item/organ/organ as anything in new_limb_owner.internal_organs)
			if(deprecise_zone(organ.current_zone) != body_zone)
				continue
			organ.bodypart_insert(src)

	for(var/datum/wound/wound as anything in wounds)
		wounds -= wound
		wound.apply_to_bodypart(src, silent = TRUE, crit_message = FALSE)

	//Add injuries to the owner's injury list
	for(var/datum/injury/injury as anything in injuries)
		injury.parent_mob = new_limb_owner
		LAZYADD(new_limb_owner.all_injuries, injury)

	var/obj/item/bodypart/affecting = new_limb_owner.get_bodypart(BODY_ZONE_CHEST)
	if(affecting && dismember_wound)
		affecting.remove_wound(dismember_wound)

	update_bodypart_damage_state()

	if(!(new_limb_owner.status_flags & BUILDING_ORGANS))
		new_limb_owner.updatehealth()
		new_limb_owner.update_body()
		new_limb_owner.update_damage_overlays()

/obj/item/bodypart/head/attach_limb(mob/living/carbon/C, special)
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
	var/list/generated_limbs = list()
	for(var/limb_zone in limb_list)
		var/obj/item/bodypart/limb = regenerate_limb(limb_zone)
		if(limb)
			generated_limbs += limb
	return generated_limbs

/// Restore a limb. Pass with no args to choose a random missing one.
/mob/living/carbon/proc/regenerate_limb(limb_zone, silent=TRUE)
	if(!limb_zone)
		limb_zone = safepick(get_missing_limbs())
		if(!limb_zone)
			return

	var/obj/item/bodypart/limb
	if(get_bodypart(limb_zone))
		return
	limb = newBodyPart(limb_zone, 0, 0)
	if(limb)
		limb.attach_limb(src, TRUE)
		if(!silent)
			visible_message(span_green("[src]'s [limb] regenerates!"), span_green("My [limb] regenerates!"), vision_distance = COMBAT_MESSAGE_RANGE)
		return limb
