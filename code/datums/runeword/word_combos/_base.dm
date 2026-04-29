GLOBAL_LIST_INIT(all_runewords, initialize_runewords())

/proc/initialize_runewords()
	var/list/runewords = list()
	for(var/datum/runeword/runeword as anything in subtypesof(/datum/runeword))
		if(IS_ABSTRACT(runeword))
			continue
		runewords |= runeword
		runewords[runeword] = new runeword

	return runewords


/datum/runeword
	var/name = ""
	var/list/runes = list() // Required rune sequence
	var/sockets_required = 2
	var/list/allowed_items = list() // Item types that can hold this runeword
	var/list/stat_bonuses = list() // Direct stat modifications
	var/list/combat_effects = list() // Combat-related effects
	var/list/spell_actions = list() // Spell actions to grant
	var/obj/item/attached_item = null // The item this runeword is on

/datum/runeword/New(obj/item/item)
	..()
	if(item)
		attached_item = item
		register_signals()

	var/list/new_combat = list()
	for(var/datum/rune_effect/effect as anything in combat_effects)
		new_combat |= new effect(combat_effects[effect])

	var/list/new_stat_bonuses = list()
	for(var/datum/rune_effect/effect as anything in stat_bonuses)
		new_stat_bonuses |= new effect(stat_bonuses[effect])

	stat_bonuses = new_stat_bonuses
	combat_effects = new_combat

/datum/runeword/Destroy()
	clear_signals()
	attached_item = null
	return ..()

/datum/runeword/proc/register_signals()
	if(!attached_item)
		return

	// Register for attack signals to handle damage bonuses and effects
	RegisterSignal(attached_item, COMSIG_ITEM_AFTERATTACK, PROC_REF(handle_afterattack))

/datum/runeword/proc/clear_signals()
	if(!attached_item)
		return

	UnregisterSignal(attached_item, COMSIG_ITEM_AFTERATTACK)

/datum/runeword/proc/handle_afterattack(obj/item/source, atom/target, mob/living/user, proximity_flag, list/modifiers)
	if(!proximity_flag || !isliving(target) || !isliving(user))
		return

	var/mob/living/living_target = target

	// Apply all combat effects through the elemental system
	apply_combat_effects(living_target, user, 0)

/datum/runeword/proc/apply_combat_effects(mob/living/target, mob/living/user, damage_dealt)
	for(var/datum/rune_effect/effect as anything in combat_effects)
		effect.apply_combat_effect(target, user, damage_dealt)
