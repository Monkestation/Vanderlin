/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter
	name = "Shatter"
	desc = "Wind up a blow, then strike a line straight ahead of you, hurling those struck back a tile. Cuts for 40 damage \
		The strike will not carry through walls, but it batters any structure in its path. \
		At 3+ momentum: consumes 3 to double damage. Builds momentum on a multi-target hit."

	required_form = FORM_EARTH
	button_icon_state = "shatter"
	invocation = "Frange!"
	damage = 40
	empowered_mult = 2
	windup_time = 6
	sweep_step = 0
	push_dist = 1
	sound = null
	detonate_sound = null
	momentum_on_hit = 0
	momentum_on_surge = 1
	var/line_length = 3

/datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter/get_pattern_offsets()
	var/list/offsets = list()
	for(var/i in 1 to line_length)
		offsets += list(list(0, i))
	return offsets
