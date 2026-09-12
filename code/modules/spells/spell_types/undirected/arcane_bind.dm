/datum/action/cooldown/spell/bind_armament
	name = "Arcane Binding"
	desc = "Bind a weapon, changing its skills to Arcane instead of its original skill. Once it is unbound, it returns to the original skill. Cast with an empty hand to release the bond. If another takes up the weapon, the bond snaps."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "bind_weapon"
	sound = 'sound/magic/charged.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_cost = 10

	invocation = "Vinculum Ferri."
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = CHARGETIME_MINOR
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	cooldown_time = 3 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/bind_skill = /datum/attribute/skill/magic/arcane
	var/obj/item/bound

/datum/action/cooldown/spell/bind_armament/Destroy()
	release_bind()
	return ..()

/datum/action/cooldown/spell/bind_armament/proc/release_bind()
	if(bound && !QDELETED(bound))
		var/datum/component/skill_bind/existing = bound.GetComponent(/datum/component/skill_bind)
		if(existing)
			qdel(existing)
	bound = null

/datum/action/cooldown/spell/bind_armament/proc/get_bound_weapon()
	if(bound && !QDELETED(bound) && bound.GetComponent(/datum/component/skill_bind))
		return bound
	bound = null
	return null

/datum/action/cooldown/spell/bind_armament/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/weapon = H.get_active_held_item()
	if(!weapon)
		var/obj/item/current_bound = get_bound_weapon()
		if(current_bound)
			to_chat(H, span_notice("The arcyne bond on [current_bound] fades."))
			release_bind()
			return TRUE
		to_chat(H, span_warning("I have no bound weapon to release!"))
		return FALSE
	if(!istype(weapon, /obj/item/weapon) || !ispath(weapon.associated_skill, /datum/attribute/skill/combat))
		to_chat(H, span_warning("[weapon] is not something my arts can guide."))
		return FALSE
	if(weapon.GetComponent(/datum/component/skill_bind))
		to_chat(H, span_warning("[weapon] already carries an arcyne bond."))
		return FALSE
	release_bind()
	weapon.AddComponent(/datum/component/skill_bind, bind_skill, H)
	bound = weapon
	to_chat(H, span_notice("I lay an arcyne bond on [weapon]; it answers to my conjurer's training now."))
	playsound(get_turf(H), 'sound/magic/charged.ogg', 50, TRUE)
	H.visible_message(span_notice("[H] passes a hand over [weapon], which glows faintly."))
	return TRUE
