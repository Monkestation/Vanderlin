/datum/action/cooldown/spell/blood_purge
	name = "Blood Purge"
	desc = "Purges the bloodstream of a target of all toxins and poisons."
	button_icon_state = "detect_poison"
	cast_range = 3
	charge_sound = 'sound/magic/chargingold.ogg'

	charge_time = 2 SECONDS
	cooldown_time = 1.5 MINUTES
	charge_slowdown = 0.3
	spell_cost = 75

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_RESTORATION
	required_level = 3

/datum/action/cooldown/spell/blood_purge/cast(atom/cast_on)
	. = ..()
	if(!isliving(cast_on))
		return
	var/mob/living/target = cast_on
	target.reagents?.remove_all_type(/datum/reagent/toxin, 999)
	target.reagents?.remove_all_type(/datum/reagent/poison, 999)
	target.visible_message(span_info("A thin veil of red mist eminates from [cast_on] as their blood expels any toxins!"), span_notice("Needles! Needles stabbing me everywhere!"))
	new /obj/effect/temp_visual/snake/twin_up(null, target)
