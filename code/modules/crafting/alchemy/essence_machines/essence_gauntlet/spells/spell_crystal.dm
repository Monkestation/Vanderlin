/datum/action/cooldown/spell/essence/spell_crystal
	name = "Spell Crystal"
	desc = "Creates a crystal that can store and later release a spell."
	button_icon_state = "quartz"
	button_icon = 'icons/roguetown/items/gems.dmi'
	cast_range = 1
	point_cost = 9
	cooldown_time = 3 MINUTES
	essences = list(/datum/thaumaturgical_essence/magic, /datum/thaumaturgical_essence/crystal)

/datum/action/cooldown/spell/essence/spell_crystal/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] creates a crystal capable of storing magical energy."))

	new /obj/item/spell_crystal(target_turf)


/obj/item/spell_crystal
	name = "spell storage crystal"
	desc = "A crystal capable of storing magical energy for later use."
	icon_state = "quartz"
	icon = 'icons/roguetown/items/gems.dmi'
	w_class = WEIGHT_CLASS_SMALL
	/// Type path of the stored spell
	var/datum/action/cooldown/spell/stored_spell_type = null
	/// Display name of the stored spell
	var/stored_spell_name = null
	/// The live granted spell instance while the user is holding it active
	var/datum/action/cooldown/spell/granted_spell = null

/obj/item/spell_crystal/examine(mob/user)
	. = ..()
	if(stored_spell_type)
		. += span_notice("It hums with stored energy — [stored_spell_name].")
	else
		. += span_warning("It is dormant, waiting to be filled.")

/obj/item/spell_crystal/Destroy()
	if(granted_spell)
		revoke_spell()
	return ..()

/obj/item/spell_crystal/update_overlays()
	. = ..()
	if(!stored_spell_type)
		return
	var/mutable_appearance/MA = mutable_appearance(initial(stored_spell_type.button_icon), initial(stored_spell_type.button_icon_state))
	MA.alpha = 120
	. += MA

/obj/item/spell_crystal/proc/attune_crystal(mob/user)
	if(stored_spell_type)
		to_chat(user, span_warning("The crystal already holds [stored_spell_name]."))
		return

	var/list/eligible = list()
	for(var/datum/action/cooldown/spell/S in user.actions)
		// Exclude the essence family (creation spells) and anything already essence-flagged
		if(S.spell_type == SPELL_ESSENCE)
			continue
		if(S.spell_flags & SPELL_TEMPORARY)
			continue
		eligible[S.name] = S

	if(!eligible.len)
		to_chat(user, span_warning("You have no storable spells."))
		return

	var/chosen_name = tgui_input_list(user, "Choose a spell to store:", "Attune Crystal", eligible)
	if(!chosen_name || !eligible[chosen_name])
		return
	if(stored_spell_type) // race guard
		return

	var/datum/action/cooldown/spell/chosen = eligible[chosen_name]
	stored_spell_type = chosen.type
	stored_spell_name = chosen.name
	name = "[chosen.name] crystal"
	desc = "A crystal storing [chosen.name]."
	update_appearance(UPDATE_OVERLAYS)

	user.visible_message(
		span_notice("[user] presses their palm to the crystal — it drinks in the light of [chosen.name]."),
		span_notice("You attune the crystal to [chosen.name].")
	)

/obj/item/spell_crystal/proc/grant_spell(mob/user)
	if(granted_spell || !stored_spell_type)
		return

	granted_spell = new stored_spell_type(user)
	granted_spell.point_cost = 0
	granted_spell.cooldown_time = 0
	granted_spell.background_icon_state = "spelltemp"
	granted_spell.base_background_icon_state = "spelltemp0"
	granted_spell.active_background_icon_state = "spelltemp1"
	granted_spell.spell_cost = 0
	granted_spell.spell_flags |= SPELL_TEMPORARY
	granted_spell.Grant(user)

	RegisterSignal(user, COMSIG_MOB_ABILITY_FINISHED, PROC_REF(on_spell_fired))

	to_chat(user, span_notice("The crystal's magic flows into you — [stored_spell_name] is ready."))

/obj/item/spell_crystal/proc/revoke_spell()
	if(!granted_spell)
		return

	var/mob/owner = granted_spell.owner
	if(owner)
		UnregisterSignal(owner, COMSIG_MOB_ABILITY_FINISHED)
		granted_spell.Remove(owner)

	qdel(granted_spell)
	granted_spell = null

/obj/item/spell_crystal/proc/on_spell_fired(mob/source, datum/action/cooldown/spell/fired)
	SIGNAL_HANDLER

	// Only care about our specific spell instance
	if(fired != granted_spell)
		return

	UnregisterSignal(source, COMSIG_MOB_ABILITY_FINISHED)

	source.visible_message(
		span_notice("The [name] shatters as its stored magic is spent!"),
		span_notice("The stored [stored_spell_name] releases and the crystal crumbles.")
	)

	granted_spell.Remove(source)
	qdel(granted_spell)
	granted_spell = null
	qdel(src) // crystal consumed

/// Click in hand: grant the spell so the user can cast it normally
/obj/item/spell_crystal/attack_self(mob/user)
	if(!stored_spell_type)
		attune_crystal(user)
		return

	if(granted_spell)
		// Clicking again before firing cancels/revokes
		to_chat(user, span_notice("You withdraw the crystal's magic without spending it."))
		revoke_spell()
		return

	grant_spell(user)
