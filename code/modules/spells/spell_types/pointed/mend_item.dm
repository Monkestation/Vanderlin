/datum/action/cooldown/spell/mend_item
	name = "Mend Item"
	desc = "Use arcyne energy to mend an item."
	sound = 'sound/magic/whiteflame.ogg'
	self_cast_possible = FALSE
	spell_flags = SPELL_RITUOS

	required_form = FORM_LIFE
	required_technique = TECHNIQUE_ALTERATION

	charge_time = 3 SECONDS
	cooldown_time = 30 SECONDS
	spell_cost = 40

	/// Amount to repair by
	var/repair_percent = 0.25

/datum/action/cooldown/spell/mend_item/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isitem(cast_on)

/datum/action/cooldown/spell/mend_item/cast(obj/item/cast_on)
	. = ..()
	var/integrity = cast_on.get_integrity()
	var/max_integrity = cast_on.max_integrity
	if(integrity >= max_integrity)
		to_chat(owner, span_info("\The [cast_on] appears to be in pefect condition."))
		return

	cast_on.visible_message(span_info("[cast_on] glows in a faint green light."))

	cast_on.repair_damage(max_integrity * repair_percent)
	cast_on.atom_fix()
