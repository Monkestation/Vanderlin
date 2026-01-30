/datum/action/cooldown/spell/strengthen_undead
	name = "Repair Undead"
	desc = "Repair undead or smite the living."
	button_icon_state = "raiseskele"
	sound = 'sound/magic/whiteflame.ogg'

	attunements = list(
		/datum/attunement/dark = 0.4,
		/datum/attunement/death = 0.5,
	)

	charge_required = FALSE
	cooldown_time = 15 SECONDS
	spell_cost = 30

/datum/action/cooldown/spell/strengthen_undead/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/strengthen_undead/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(owner, span_warning("A distortive field prevents your magic taking hold!"))
		return
	if(cast_on.mob_biotypes & MOB_UNDEAD)
		var/obj/item/bodypart/affecting = cast_on.get_bodypart(check_zone(owner.zone_selected))
		if(affecting)
			if(affecting.heal_damage(50, 50))
				cast_on.update_damage_overlays()
			if(affecting.heal_wounds(50))
				cast_on.update_damage_overlays()
		cast_on.visible_message(span_danger("[cast_on] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
	else
		cast_on.visible_message(span_info("Necrotic energy floods over [cast_on]!"), span_userdanger("I feel colder as the dark energy floods into me!"))
		cast_on.Paralyze(5 SECONDS)
		cast_on.adjustBruteLoss(20)
