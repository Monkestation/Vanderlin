/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	var/mob/living/carbon/owner = null
	var/status = ORGAN_ORGANIC
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	sellprice = 10

	grid_width = 32
	grid_height = 32

	var/zone = BODY_ZONE_CHEST
	var/slot
	// DO NOT add slots with matching names to different zones - it will break internal_organs_slot list!
	var/organ_flags = 0
	var/maxHealth = STANDARD_ORGAN_THRESHOLD
	var/damage = 0		//total damage this organ has sustained
	///Healing factor and decay factor function on % of maxhealth, and do not work by applying a static number per tick
	var/healing_factor 	= 0										//fraction of maxhealth healed per on_life(), set to 0 for generic organs
	var/decay_factor 	= 0										//same as above but when without a living owner, set to 0 for generic organs
	var/high_threshold	= STANDARD_ORGAN_THRESHOLD * 0.45		//when severe organ damage occurs
	var/low_threshold	= STANDARD_ORGAN_THRESHOLD * 0.1		//when minor organ damage occurs

	///Organ variables for determining what we alert the owner with when they pass/clear the damage thresholds
	var/prev_damage = 0
	var/low_threshold_passed
	var/high_threshold_passed
	var/now_failing
	var/now_fixed
	var/high_threshold_cleared
	var/low_threshold_cleared
	dropshrink = 0.85

	/// What food typepath should be used when eaten
	var/food_type = /obj/item/reagent_containers/food/snacks/organ
	/// Original owner of the organ, the one who had it inside them last
	var/mob/living/carbon/last_owner = null

/obj/item/organ/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	if(use_mob_sprite_as_obj_sprite)
		update_appearance(UPDATE_OVERLAYS)

/obj/item/organ/Destroy()
	if(owner)
		Remove(owner, special=TRUE)
	last_owner = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/organ/attack(mob/living/carbon/M, mob/user, list/modifiers)
	if(M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(status == ORGAN_ORGANIC)
			var/obj/item/reagent_containers/food/snacks/S = prepare_eat(H)
			if(S && H.put_in_active_hand(S))
				S.attack(H, H)
	else
		..()

/obj/item/organ/item_action_slot_check(slot,mob/user)
	return //so we don't grant the organ's action to mobs who pick up the organ.

/obj/item/organ/proc/generate_chimeric_organ(mob/living/source_mob)
	if(!source_mob)
		return
	var/datum/component/chimeric_organ/organ = AddComponent(/datum/component/chimeric_organ, 3)
	var/node_count = rand(3, 5)
	var/list/obj/item/chimeric_node/generated_nodes = list()

	for(var/i in 1 to node_count)
		var/obj/item/chimeric_node/new_node = source_mob.generate_chimeric_node_from_mob()
		if(!new_node)
			continue

		if(!organ.check_node_compatibility(new_node.stored_node))
			qdel(new_node)
			continue

		generated_nodes += new_node

	if(!length(generated_nodes))
		return

	for(var/obj/item/chimeric_node/node as anything in generated_nodes)
		organ.handle_node_injection(node.node_tier, node.node_purity, node.stored_node.slot, node.stored_node, node.icon_state)
		node.forceMove(src)

	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/item/organ/update_overlays()
	. = ..()
	var/datum/component/chimeric_organ/organ = GetComponent(/datum/component/chimeric_organ)

	if(!organ)
		return

	for(var/mutable_appearance/node_overlay in organ.overlay_states)
		. += node_overlay

/obj/item/organ/proc/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	if(!iscarbon(M) || owner == M)
		return

	var/obj/item/organ/replaced = M.getorganslot(slot)
	if(replaced)
		replaced.Remove(M, special = 1)
		if(drop_if_replaced)
			replaced.forceMove(get_turf(M))
		else
			qdel(replaced)

	SEND_SIGNAL(src, COMSIG_ORGAN_INSERTED, M)
	owner = M
	last_owner = M
	M.internal_organs |= src
	M.internal_organs_slot[slot] = src
	moveToNullspace()
	for(var/datum/action/A as anything in actions)
		A.Grant(M)
	update_accessory_colors()
	STOP_PROCESSING(SSobj, src)

//Special is for instant replacement like autosurgeons
/obj/item/organ/proc/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	SEND_SIGNAL(src, COMSIG_ORGAN_REMOVED, M)
	owner = null
	if(M)
		M.internal_organs -= src
		if(M.internal_organs_slot[slot] == src)
			M.internal_organs_slot.Remove(slot)
		if((organ_flags & ORGAN_VITAL) && !special && !(M.status_flags & GODMODE))
			M.death()
	for(var/datum/action/A as anything in actions)
		A.Remove(M)
	if(visible_organ)
		M.update_body_parts(TRUE)
	update_appearance(UPDATE_ICON_STATE)

/obj/item/organ/proc/on_find(mob/living/finder)
	return

/obj/item/organ/process()
	on_death() //Kinda hate doing it like this, but I really don't want to call process directly.

/obj/item/organ/proc/on_death()	//runs decay when outside of a person
	if(organ_flags & (ORGAN_SYNTHETIC | ORGAN_FROZEN))
		return
	applyOrganDamage(maxHealth * decay_factor)

/obj/item/organ/proc/on_life()	//repair organ damage if the organ is not failing
	if(organ_flags & ORGAN_FAILING)
		return
	///Damage decrements by a percent of its maxhealth
	var/healing_amount = -(maxHealth * healing_factor)
	///Damage decrements again by a percent of its maxhealth, up to a total of 4 extra times depending on the owner's health
	healing_amount -= owner.satiety > 0 ? 4 * healing_factor * owner.satiety / MAX_SATIETY : 0
	applyOrganDamage(healing_amount)

/obj/item/organ/examine(mob/user)
	. = ..()

	. += span_notice("It should be inserted in the [parse_zone(zone)].")

	if(organ_flags & ORGAN_FAILING)
		if(status == ORGAN_ROBOTIC)
			. += span_warning("[src] seems to be broken.")
			return
		. += span_warning("[src] has decayed for too long, and has turned a sickly color. Only Pestra herself could restore it its functionality.")
		return
	if(damage > high_threshold)
		. += span_warning("[src] is starting to look discolored.")

/obj/item/organ/proc/prepare_eat(mob/living/carbon/human/user)
	var/obj/item/reagent_containers/food/snacks/organ/S = new food_type()
	S.name = name
	S.desc = desc
	S.icon = icon
	S.icon_state = icon_state
	S.w_class = w_class
	S.organ_inside = src
	forceMove(S)
	if(damage > high_threshold)
		S.eat_effect = /datum/status_effect/debuff/rotfood
	S.rotprocess = S.rotprocess * ((high_threshold - damage) / high_threshold)
	return S

/obj/item/reagent_containers/food/snacks/organ
	name = "appendix"
	icon_state = "appendix"
	icon = 'icons/obj/surgery.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR, /datum/reagent/organpoison = 1)
	grind_results = list(/datum/reagent/organpoison = 3)
	foodtype = RAW | MEAT | GROSS
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = 5 MINUTES
	var/obj/item/organ/organ_inside

/obj/item/reagent_containers/food/snacks/organ/on_consume(mob/living/eater)
	if(HAS_TRAIT(eater, TRAIT_ORGAN_EATER) && eat_effect != /datum/status_effect/debuff/rotfood)
		eat_effect = /datum/status_effect/buff/foodbuff
	if(bitecount >= bitesize)
		record_featured_stat(FEATURED_STATS_CRIMINALS, eater)
		record_round_statistic(STATS_ORGANS_EATEN)
		SEND_SIGNAL(eater, COMSIG_ORGAN_CONSUMED, type, organ_inside)
	. = ..()
	eat_effect = initial(eat_effect)

/obj/item/reagent_containers/food/snacks/organ/Destroy()
	QDEL_NULL(organ_inside)
	return ..()

/obj/item/reagent_containers/food/snacks/organ/heart
	name = "heart"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/organpoison = 2)
	grind_results = list(/datum/reagent/organpoison = 6)

/obj/item/reagent_containers/food/snacks/organ/lungs
	name = "lungs"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/organpoison = 2)
	grind_results = list(/datum/reagent/organpoison = 6)

/obj/item/reagent_containers/food/snacks/organ/liver
	name = "liver"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/organpoison = 2)
	grind_results = list(/datum/reagent/organpoison = 6)

///Adjusts an organ's damage by the amount "d", up to a maximum amount, which is by default max damage
/obj/item/organ/proc/applyOrganDamage(d, maximum = maxHealth)	//use for damaging effects
	if(!d) //Micro-optimization.
		return
	if(maximum < damage)
		return
	damage = CLAMP(damage + d, 0, maximum)
//	var/mess = check_damage_thresholds(owner)
	prev_damage = damage
//	if(mess && owner)
//		to_chat(owner, mess)

///SETS an organ's damage to the amount "d", and in doing so clears or sets the failing flag, good for when you have an effect that should fix an organ if broken
/obj/item/organ/proc/setOrganDamage(d)	//use mostly for admin heals
	applyOrganDamage(d - damage)

/** check_damage_thresholds
 * input: M (a mob, the owner of the organ we call the proc on)
 * output: returns a message should get displayed.
 * description: By checking our current damage against our previous damage, we can decide whether we've passed an organ threshold.
 *				 If we have, send the corresponding threshold message to the owner, if such a message exists.
 */
/obj/item/organ/proc/check_damage_thresholds(mob/M)
	if(damage == prev_damage)
		return
	var/delta = damage - prev_damage
	if(delta > 0)
		if(damage >= maxHealth)
			organ_flags |= ORGAN_FAILING
			if((organ_flags & ORGAN_VITAL) && M && (M.stat < DEAD) && !(M.status_flags & GODMODE))
				M.death()
			return now_failing
		if(damage > high_threshold && prev_damage <= high_threshold)
			return high_threshold_passed
		if(damage > low_threshold && prev_damage <= low_threshold)
			return low_threshold_passed
	else
		organ_flags &= ~ORGAN_FAILING
		if(prev_damage > low_threshold && damage <= low_threshold)
			return low_threshold_cleared
		if(prev_damage > high_threshold && damage <= high_threshold)
			return high_threshold_cleared
		if(prev_damage == maxHealth)
			return now_fixed

/obj/item/organ/on_enter_storage(datum/component/storage/concrete/S)
	. = ..()
	if(recursive_loc_check(src, /obj/item/storage/backpack/backpack/artibackpack))
		organ_flags |= ORGAN_FROZEN

/obj/item/organ/on_exit_storage(datum/component/storage/concrete/S)
	. = ..()
	if(!recursive_loc_check(src, /obj/item/storage/backpack/backpack/artibackpack))
		organ_flags &= ~ORGAN_FROZEN

//Looking for brains?
//Try code/modules/mob/living/carbon/brain/brain_item.dm

/mob/living/proc/regenerate_organs()
	return 0

/mob/living/carbon/regenerate_organs()
	if(dna?.species)
		dna.species.regenerate_organs(src)

		// Species regenerate organs doesn't ALWAYS handle healing the organs because it's dumb
		for(var/obj/item/organ/organ as anything in internal_organs)
			organ.setOrganDamage(0)
		set_heartattack(FALSE)

		// heal ears after healing traits, since ears check TRAIT_DEAF trait
		// when healing.
		restoreEars()

		return

	// Default organ fixing handling
	// May result in kinda cursed stuff for mobs which don't need these organs
	var/obj/item/organ/lungs/lungs = getorganslot(ORGAN_SLOT_LUNGS)
	if(!lungs)
		lungs = new()
		lungs.Insert(src)
	lungs.setOrganDamage(0)

	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(heart)
		set_heartattack(FALSE)
	else
		heart = new()
		heart.Insert(src)
	heart.setOrganDamage(0)

	var/obj/item/organ/tongue/tongue = getorganslot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		tongue = new()
		tongue.Insert(src)
	tongue.setOrganDamage(0)

	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		eyes = new()
		eyes.Insert(src)
	eyes.setOrganDamage(0)

	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	if(!ears)
		ears = new()
		ears.Insert(src)
	// ears.adjustEarDamage(-INFINITY, -INFINITY) // actually do: set_organ_damage(0) and deaf = 0

	// heal ears after healing traits, since ears check TRAIT_DEAF trait
	// when healing.
	restoreEars()

GLOBAL_LIST_INIT(all_organ_slots, get_all_slots())

/// Get all possible organ slots by checking every organ, and then store it and give it whenever needed
/proc/get_all_slots()
	var/list/all_organ_slots = list()

	if(!length(all_organ_slots))
		for(var/obj/item/organ/an_organ as anything in subtypesof(/obj/item/organ))
			if(!initial(an_organ.slot))
				continue
			all_organ_slots |= initial(an_organ.slot)

	return all_organ_slots
