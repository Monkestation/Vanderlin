/datum/component/easy_repair
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/easy_repair/Initialize(mapload)
	. = ..()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/easy_repair/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION, PROC_REF(on_item_interact))

/datum/component/easy_repair/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_ITEM_INTERACTION)

/datum/component/easy_repair/proc/on_item_interact(datum/source, mob/living/user, obj/item/tool, modifiers)
	SIGNAL_HANDLER

	if(user.cmode)
		return NONE

	var/mob/living/carbon/carbon_parent = parent
	if(user == carbon_parent)
		return NONE

	if(!istype(tool, /obj/item/weapon/hammer))
		return NONE

	var/obj/item/bodypart/targeted_part = carbon_parent.get_bodypart(user.zone_selected)

	if(!targeted_part)
		return NONE

	if(targeted_part.status != BODYPART_ROBOTIC)
		return NONE

	INVOKE_ASYNC(src, PROC_REF(try_heal), user, tool, targeted_part)

	return ITEM_INTERACT_SUCCESS

/datum/component/easy_repair/proc/try_heal(mob/living/user, obj/item/tool, obj/item/bodypart/repaired)
	var/mob/living/carbon/carbon_parent = parent

	var/damaged = TRUE
	while(damaged)
		if(!do_after(user, 3 SECONDS, carbon_parent))
			return
		tool.play_tool_sound(carbon_parent)
		var/heal_value = tool.force * max(1, (0.5 * user.get_skill_level(/datum/skill/craft/engineering)))
		repaired.heal_damage(heal_value, heal_value) // repairs brute and burn equal to tool force
		user.visible_message(
			span_notice("[user] taps [carbon_parent]'s [repaired.name] with [tool], straightening out the damage."),
			span_notice("You tap [carbon_parent]'s [repaired.name] with [tool], repairing some damage.")
		)
		damaged = carbon_parent.getBruteLoss() + carbon_parent.getFireLoss()
		user.adjust_experience(/datum/skill/craft/engineering, 10)
