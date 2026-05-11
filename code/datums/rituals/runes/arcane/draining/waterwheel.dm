/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/waterwheel
	name = "arcyne torrent sigil"
	desc = "A churning, current-etched sigil that drives water faster and wrings more power from the wheels bound to it..."
	color = "#4A90D9"
	invocation = "Aev'kael un'draum!"
	user_facing = FALSE
	var/list/waterwheels = list()

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/waterwheel/activate_siphon(mob/living/user)
	. = ..()
	set_waterwheel_stress(2)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/waterwheel/deactivate_siphon()
	set_waterwheel_stress(0.5) // undo the doubling
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/waterwheel/trigger_effects()
	set_waterwheel_stress(2, TRUE)
	return //literally only cause we can build one midway

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/waterwheel/proc/set_waterwheel_stress(multiplier, ignore_list = FALSE)
	for(var/obj/structure/waterwheel/W in range(runesize, src))
		if(ignore_list && (W in waterwheels))
			continue
		if(!W.stress_generator || !W.last_stress_generation)
			continue
		if(multiplier > 1)
			waterwheels |= W
		else
			waterwheels -= W
		W.set_stress_generation(W.last_stress_generation * multiplier)
