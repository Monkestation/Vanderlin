/datum/action/cooldown/spell/bind_weapon
	name = "Bind Weapon"
	desc = "Bind your held weapon as an arcyne conduit. Successful strikes with bound weapons build arcyne momentum, fueling your abilities. \
		It can also be recalled to your hand from anywhere with Recall Weapon. \
		You can rebind to restore a lost Arcyne Momentum status, or bind a new weapon if your old one was destroyed. \
		Cast with empty hands to unbind your current weapon."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "bind_weapon"
	sound = 'sound/magic/charged.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_IMBUE
	spell_cost = 40

	invocation = "Vinculum Arcanum."
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/bind_weapon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/weapon = H.get_active_held_item()
	if(!weapon)
		// Empty hands - unbind current weapon if one exists
		var/datum/status_effect/buff/arcyne_momentum/unbind_M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(unbind_M?.bound_weapon && !QDELETED(unbind_M.bound_weapon))
			var/datum/component/arcyne_conduit/old_conduit = unbind_M.bound_weapon.GetComponent(/datum/component/arcyne_conduit)
			if(old_conduit)
				qdel(old_conduit)
			to_chat(H, span_notice("The arcyne bond on [unbind_M.bound_weapon] fades. I am unbound."))
			playsound(get_turf(H), 'sound/magic/charging.ogg', 30, TRUE)
			unbind_M.bound_weapon = null
			return TRUE
		to_chat(H, span_warning("I have no bound weapon to release!"))
		return FALSE

	var/datum/component/arcyne_conduit/existing_conduit = weapon.GetComponent(/datum/component/arcyne_conduit)
	if(existing_conduit)
		var/mob/living/existing_owner = existing_conduit.owner_ref?.resolve()
		if(existing_owner && existing_owner != H)
			to_chat(H, span_warning("[weapon] is already bound to another spellblade!"))
			return FALSE
		if(existing_owner == H)
			to_chat(H, span_warning("[weapon] is already bound as my conduit!"))
			return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		M = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)

	if(M?.bound_weapon && !QDELETED(M.bound_weapon))
		var/datum/component/arcyne_conduit/old_conduit = M.bound_weapon.GetComponent(/datum/component/arcyne_conduit)
		if(old_conduit)
			qdel(old_conduit)
		to_chat(H, span_notice("The arcyne bond on [M.bound_weapon] fades."))

	weapon.AddComponent(/datum/component/arcyne_conduit, owner = H)
	if(M)
		M.bound_weapon = weapon
	to_chat(H, span_notice("I bind [weapon] as my arcyne conduit. Its strikes will build momentum."))
	playsound(get_turf(H), 'sound/magic/charged.ogg', 50, TRUE)
	H.visible_message(span_notice("[H] passes a hand over [weapon], which begins to glow faintly."))
	return TRUE
