
/datum/enchantment
	var/atom/enchanted_item
	var/starting_duration = 15 MINUTES
	var/examine_text
	var/enchantment_name
	var/enchantment_end_message
	var/random_enchantment_weight = 10
	var/should_process = FALSE
	var/enchantment_color = COLOR_BLUE_GRAY
	var/list/essence_recipe = list()
	var/required_type // Can be a single type or list of types
	var/list/registered_signals = list()

/datum/enchantment/New()
	. = ..()
	if(should_process)
		START_PROCESSING(SSenchantment, src)

/datum/enchantment/Destroy(force, ...)
	if(enchanted_item)
		remove_item(enchanted_item)
	if(should_process)
		STOP_PROCESSING(SSenchantment, src)
	enchanted_item = null
	registered_signals = null
	return ..()

/datum/enchantment/proc/add_item(atom/item)
	if(!item)
		return FALSE

	enchanted_item = item
	register_triggers(item)

	return TRUE

/datum/enchantment/proc/register_triggers(atom/item)
	if(!item)
		return
	registered_signals += COMSIG_PARENT_QDELETING
	RegisterSignal(item, COMSIG_PARENT_QDELETING, PROC_REF(on_item_deleted))

	registered_signals += COMSIG_PARENT_EXAMINE
	RegisterSignal(item, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/enchantment/proc/unregister_triggers()
	if(!enchanted_item || !length(registered_signals))
		return

	for(var/signal in registered_signals)
		UnregisterSignal(enchanted_item, signal)
	registered_signals.Cut()

/datum/enchantment/proc/on_item_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/enchantment/proc/remove_item(atom/item)
	if(!item || item != enchanted_item)
		return

	unregister_triggers()

	if(enchantment_end_message)
		item.visible_message(enchantment_end_message)

	enchanted_item = null

/datum/enchantment/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(examine_text)
		examine_list += span_info(examine_text)
