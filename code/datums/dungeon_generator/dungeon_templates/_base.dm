/datum/map_template/dungeon
	z_levels = 2
	///the pickweight of this dungeon type
	var/rarity = 100
	///our type_pick weight
	var/type_weight = 1

	///basically if these are set we assume it exists
	///I will close any pr that attempts to add the spawners outside the middle
	///this is to be assumed how many to the left
	var/north_offset
	///this is to be assumed how many to the left
	var/south_offset
	///this is to be assumed how many down
	var/east_offset
	///this is to be assumed how many down
	var/west_offset

	/// Room cannot be placed closer than this many rooms from the start.
	var/min_depth = 0
	/// Can only be placed once per dungeon.
	var/unique = FALSE
	/// Max placements per dungeon. 0 = unlimited. Ignored if unique is set.
	var/max_occurrences = 0
	/// Each placement multiplies this template's weight by (1 - repeat_falloff). 0 = no falloff, 0.5 = halves each time, 1 = effectively unique.
	var/repeat_falloff = 0.6
