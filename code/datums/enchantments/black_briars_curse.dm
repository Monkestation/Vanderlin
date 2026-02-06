
/datum/enchantment/black_briar
	enchantment_name = "\improper Black Briar's curse"
	examine_text = span_briar("Everything sprouts into something beautiful one dae.")
	enchantment_color = "#6b3a4a"
	var/last_used = 0

/datum/enchantment/black_briar/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_AFTERATTACK
	RegisterSignal(item, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_hit))

/datum/enchantment/black_briar/add_item(obj/item/enchanter)
	.=..()
	enchanter.force += 10

/datum/enchantment/black_briar/proc/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!iscarbon(target))
		return
	if(world.time - last_used < 5 SECONDS)
		return
	last_used = world.time
	var/mob/living/carbon/targeted = target
	var/obj/item/bodypart/chest/c = targeted.get_bodypart()
	c?.add_wound(/datum/wound/black_briar_curse/chest)

