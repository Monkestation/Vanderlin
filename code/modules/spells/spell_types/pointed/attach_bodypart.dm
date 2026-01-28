/datum/action/cooldown/spell/attach_bodypart
	name = "Bodypart Miracle"
	desc = "Reattach a held limb or organ instantly. The bodypart will be sewn back together."
	button_icon_state = "limb_attach"
	sound = 'sound/gore/flesh_eat_03.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	cast_range = 2
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
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
	owner.update_inv_hands()
	cast_on.update_body()

/datum/action/cooldown/spell/attach_bodypart/proc/get_organs(mob/living/carbon/target, mob/living/user)
	var/list/missing_organs = list(
		ORGAN_SLOT_EARS,
		ORGAN_SLOT_EYES,
		ORGAN_SLOT_TONGUE,
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_STOMACH,
		ORGAN_SLOT_APPENDIX,
	)
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

