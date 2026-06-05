/datum/action/cooldown/spell/attach_bodypart
	name = "Bodypart Miracle"
	desc = "Reattach a held limb or organ instantly. The bodypart will be sewn back together."
	button_icon_state = "limb_attach"
	sound = 'sound/gore/flesh_eat_03.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	cast_range = 2
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver)

	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_cost = 125

/datum/action/cooldown/spell/attach_bodypart/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/attach_bodypart/cast(mob/living/carbon/human/cast_on)
	. = ..()
	for(var/obj/item/bodypart/limb as anything in get_limbs(cast_on, owner))
		if(!limb?.attach_limb(cast_on))
			continue
		limb.heal_damage(limb.brute_dam, limb.burn_dam)//heals the limb by the amount of burn and brute damage it has
		for(var/datum/wound/limb_wounds as anything in limb.wounds)
			qdel(limb_wounds)
		for(var/datum/injury/limb_wounds as anything in limb.injuries)
			if(limb_wounds.damage_type == WOUND_DIVINE)
				continue
			qdel(limb_wounds)
		limb.update_damages()
		cast_on.visible_message(
			span_info("\The [limb] attaches itself to [cast_on]!"),
			span_notice("\The [limb] attaches itself to me!")
		)
	for(var/obj/item/organ/organ as anything in get_organs(cast_on, owner))
		if(!organ?.Insert(cast_on))
			continue
		organ.setOrganDamage(0)
		cast_on.visible_message(
			span_info("\The [organ] forces itself into [cast_on]!"),
			span_notice("\The [organ] forces itself into me!")
		)
	var/obj/item/bodypart/mouth/jaw = cast_on.get_bodypart(BODY_ZONE_PRECISE_MOUTH)
	if(jaw)
		var/space = jaw.max_teeth - jaw.get_teeth_amount()
		if(space)
			for(var/obj/item/teeth_item as anything in get_teeth(cast_on, owner))
				if(!space)
					break
				if(istype(teeth_item, /obj/item/natural/bundle/teeth))
					var/obj/item/natural/bundle/teeth/bundle = teeth_item
					var/to_add = min(bundle.amount, space)
					var/obj/item/natural/bundle/teeth/existing = locate(bundle.type) in jaw.teeth
					if(existing)
						existing.amount += to_add
					else
						var/obj/item/natural/bundle/teeth/new_bundle = new bundle.type(jaw)
						new_bundle.amount = to_add
						jaw.teeth += new_bundle
					bundle.amount -= to_add
					if(!bundle.amount)
						qdel(bundle)
					space -= to_add
				else if(istype(teeth_item, /obj/item/natural/teeth))
					var/obj/item/natural/teeth/single = teeth_item
					var/obj/item/natural/bundle/teeth/existing = locate(single.bundletype) in jaw.teeth
					if(existing)
						existing.amount++
					else
						var/obj/item/natural/bundle/teeth/new_bundle = new single.bundletype(jaw)
						new_bundle.amount = 1
						jaw.teeth += new_bundle
					qdel(single)
					space--
			jaw.update_teeth()
			cast_on.visible_message(
				span_info("[cast_on]'s teeth restore themselves!"),
				span_notice("My teeth restore themselves!")
			)

	owner.update_inv_hands()
	cast_on.update_body()

/datum/action/cooldown/spell/attach_bodypart/proc/get_organs(mob/living/carbon/target, mob/living/user)
	var/list/missing_organs = GLOB.organ_process_order

	for(var/missing_organ_slot in missing_organs)
		if(!target.getorganslot(missing_organ_slot))
			continue
		missing_organs -= missing_organ_slot
	if(!length(missing_organs))
		return
	var/list/organs = list()
	//try to get from user's hands first
	for(var/obj/item/organ/potential_organ in user?.held_items)
		if(potential_organ.owner || !(potential_organ.slot in missing_organs))
			continue
		organs += potential_organ
	//then target's hands
	for(var/obj/item/organ/dismembered in target.held_items)
		if(dismembered.owner || !(dismembered.slot in missing_organs))
			continue
		organs += dismembered
	//then finally, 1 tile range around target
	for(var/obj/item/organ/dismembered in range(1, target))
		if(dismembered.owner || !(dismembered.slot in missing_organs))
			continue
		organs += dismembered
	return organs

/datum/action/cooldown/spell/attach_bodypart/proc/get_teeth(mob/living/carbon/target, mob/living/user)
	var/list/teeth_items = list()
	for(var/obj/item/natural/bundle/teeth/bundle in user?.held_items)
		teeth_items += bundle
	for(var/obj/item/natural/teeth/single in user?.held_items)
		teeth_items += single
	for(var/obj/item/natural/bundle/teeth/bundle in target.held_items)
		teeth_items += bundle
	for(var/obj/item/natural/teeth/single in target.held_items)
		teeth_items += single
	for(var/obj/item/natural/bundle/teeth/bundle in range(1, target))
		teeth_items += bundle
	for(var/obj/item/natural/teeth/single in range(1, target))
		teeth_items += single
	return teeth_items

/datum/action/cooldown/spell/attach_bodypart/proc/get_limbs(mob/living/carbon/target, mob/living/user)
	var/list/missing_limbs = target.get_missing_limbs()
	if(!length(missing_limbs))
		return
	var/list/limbs = list()
	//try to get from user's hands first
	for(var/obj/item/bodypart/potential_limb in user?.held_items)
		if(potential_limb.owner || !(potential_limb.body_zone in missing_limbs))
			continue
		limbs += potential_limb
	//then target's hands
	for(var/obj/item/bodypart/dismembered in target.held_items)
		if(dismembered.owner || !(dismembered.body_zone in missing_limbs))
			continue
		limbs += dismembered
	//then finally, 1 tile range around target
	for(var/obj/item/bodypart/dismembered in range(1, target))
		if(dismembered.owner || !(dismembered.body_zone in missing_limbs))
			continue
		limbs += dismembered
	return limbs

