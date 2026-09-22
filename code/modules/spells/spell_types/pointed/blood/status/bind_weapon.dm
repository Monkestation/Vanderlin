/datum/action/cooldown/spell/blood_bind
	name = "Blood Bind Weapon"
	desc = "Bind your held weapon to be recalled to your hand from nearby pools of blood with Recall Blood Weapon. \
		You can rebind to restore a lost Blood Bind status, or bind a new weapon if your old one was destroyed. \
		Cast with empty hands to unbind your current weapon."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "bind_weapon"
	sound = 'sound/magic/charged.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_IMBUE
	spell_cost = 100
	associated_skill = /datum/attribute/skill/magic/blood

	invocation = "Vinculum Caedis."
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/blood_bind/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/weapon = H.get_active_held_item()
	if(!weapon)
		// Empty hands - unbind current weapon if one exists
		var/datum/status_effect/buff/blood_bound/unbind_M = H.has_status_effect(/datum/status_effect/buff/blood_bound)
		if(unbind_M?.bound_weapon && !QDELETED(unbind_M.bound_weapon))
			var/datum/component/blood_conduit/old_conduit = unbind_M.bound_weapon.GetComponent(/datum/component/blood_conduit)
			if(old_conduit)
				qdel(old_conduit)
			to_chat(H, span_notice("The blood bond on [unbind_M.bound_weapon] fades. I am unbound."))
			playsound(get_turf(H), 'sound/magic/charging.ogg', 30, TRUE)
			unbind_M.bound_weapon = null
			return TRUE
		to_chat(H, span_warning("I have no bound weapon to release!"))
		return FALSE

	var/datum/component/blood_conduit/existing_conduit = weapon.GetComponent(/datum/component/blood_conduit)
	if(existing_conduit)
		var/mob/living/existing_owner = existing_conduit.owner_ref?.resolve()
		if(existing_owner && existing_owner != H)
			to_chat(H, span_warning("[weapon] is already bound to another blood mage!"))
			return FALSE
		if(existing_owner == H)
			to_chat(H, span_warning("[weapon] is already bound as my blood weapon!"))
			return FALSE

	var/datum/status_effect/buff/blood_bound/M = H.has_status_effect(/datum/status_effect/buff/blood_bound)
	if(!M)
		M = H.apply_status_effect(/datum/status_effect/buff/blood_bound)

	if(M?.bound_weapon && !QDELETED(M.bound_weapon))
		var/datum/component/blood_conduit/old_conduit = M.bound_weapon.GetComponent(/datum/component/blood_conduit)
		if(old_conduit)
			qdel(old_conduit)
		to_chat(H, span_notice("The blood bond on [M.bound_weapon] fades."))

	weapon.AddComponent(/datum/component/blood_conduit, owner = H)
	if(M)
		M.bound_weapon = weapon
	to_chat(H, span_notice("I bind [weapon] as my blood weapon. Its strikes will build momentum."))
	playsound(get_turf(H), 'sound/magic/charged.ogg', 50, TRUE)
	H.visible_message(span_notice("[H] passes a hand over [weapon], which begins to glow faintly."))
	return TRUE
