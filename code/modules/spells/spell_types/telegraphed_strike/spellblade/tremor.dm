/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor
	name = "Tremor"
	desc = "The earth answers. Wind up a strike, then erupt the ground in a ring around you, hurling back everyone adjacent a tile. The ring follows you as you wind up your weapon, and follow your weapon's damage type. \
		Builds 1 momentum on hit. At 3+ momentum: consumes 3 to double damage."

	required_form = FORM_EARTH
	button_icon_state = "tremor"
	sound = null
	invocation = "Tremor!"
	damage = 30
	empowered_mult = 2
	push_dist = 1
	detonate_sound = null
	momentum_on_hit = 1
	momentum_on_surge = 1

/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor/get_pattern_offsets()
	return list(
		list(-1, -1), list(0, -1), list(1, -1),
		list(-1, 0), list(1, 0),
		list(-1, 1), list(0, 1), list(1, 1),
	)

/datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	. = ..()
	var/obj/item/weapon = get_strike_weapon(H)
	if(blade_class == BCLASS_BLUNT)
		H.visible_message(span_danger("[H] slams [weapon ? "\the [weapon.name]" : "down"] into the ground, sending shockwaves outward!"))
	else
		H.visible_message(span_danger("[H] sweeps [weapon ? "\the [weapon.name]" : "around"] low, scything everything around [H.p_them()]!"))
