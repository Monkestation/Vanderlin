/datum/component/easy_repair
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/easy_repair/Initialize(mapload)
	. = ..()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/easy_repair/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attacked))

/datum/component/easy_repair/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_ATTACKBY)

/datum/component/easy_repair/proc/on_attacked(datum/source, obj/item/held, mob/living/carbon/attacker, modifiers)
	SIGNAL_HANDLER

	var/mob/living/carbon/carbon_parent = parent
	if(attacker == carbon_parent)
		return

	if(!held || !(istype(held, /obj/item/weapon/hammer)))
		return

	if(attacker.cmode)
		return

	var/zone = attacker.zone_selected
	var/obj/item/bodypart/targeted_part = carbon_parent.get_bodypart(zone)

	if(!targeted_part)
		return

	if(targeted_part.status != BODYPART_ROBOTIC)
		return NONE // not robotic, do nothing

	INVOKE_ASYNC(src, TYPE_PROC_REF(/datum/component/easy_repair, try_heal), source, held, attacker, modifiers)

	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/easy_repair/proc/try_heal(datum/source, obj/item/held, mob/living/carbon/attacker, modifiers)
	var/mob/living/carbon/carbon_parent = parent
	var/zone = attacker.zone_selected
	var/obj/item/bodypart/targeted_part = carbon_parent.get_bodypart(zone)
	var/damaged = TRUE
	while(damaged)
		if(!do_after(attacker, 3 SECONDS, parent))
			return
		held.play_tool_sound(carbon_parent)
		var/heal_value = held.force * max(1, (0.5 * attacker.get_skill_level(/datum/skill/craft/engineering)))
		targeted_part.heal_damage(heal_value,heal_value) // repairs brute and burn equal to tool force
		attacker.visible_message(
			span_notice("[attacker] taps [carbon_parent]'s [targeted_part.name] with [held], straightening out the damage."),
			span_notice("You tap [carbon_parent]'s [targeted_part.name] with [held], repairing some damage.")
		)
		damaged = carbon_parent.getBruteLoss() + carbon_parent.getFireLoss()
		attacker.adjust_experience(/datum/skill/craft/engineering, 10)
