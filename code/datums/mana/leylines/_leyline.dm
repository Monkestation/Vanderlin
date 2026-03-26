GLOBAL_LIST_EMPTY_TYPED(all_leylines, /datum/mana_pool/leyline)
// uses pickweight
/proc/generate_initial_leylines()
	RETURN_TYPE(/list/datum/mana_pool/leyline)

	var/list/datum/mana_pool/leyline/leylines = list()

	for(var/z in SSmapping.levels_by_trait(ZTRAIT_LEYLINES))
		var/leylines_to_generate = get_initial_leyline_amount()
		while (leylines_to_generate-- > 0)
			leylines += generate_leyline(z)

	return leylines

/proc/get_initial_leyline_amount()
	var/list/leyline_amount_list = list(
		"12" = 5000,
		"16" = 500,
		"20" = 200,
		"24" = 10
	)
	var/leyline_amount = text2num(pickweight(leyline_amount_list))
	return leyline_amount

/proc/generate_leyline(z)
	RETURN_TYPE(/datum/mana_pool/leyline)

	return new /datum/mana_pool/leyline(null, z)

/// The lines of latent energy that run under the universe. Available to all people in the game. Should be high capacity, but slow to recharge.
/datum/mana_pool/leyline
	var/datum/leyline_variable/leyline_intensity/intensity
	var/list/datum/leyline_variable/attunement_theme/themes

	maximum_mana_capacity = LEYLINE_BASE_CAPACITY

	ethereal_recharge_rate = LEYLINE_BASE_RECHARGE
	max_donation_rate_per_second = BASE_LEYLINE_DONATION_RATE

	transfer_method = MANA_DISPERSE_EVENLY

	discharge_destinations = NONE
	intrinsic_recharge_sources = NONE //we don't pull from leylines

	var/datum/beam/current_beam

/datum/mana_pool/leyline/Destroy(force)
	QDEL_NULL(intensity)
	QDEL_LIST(themes)
	if(current_beam)
		QDEL_NULL(current_beam)

	GLOB.all_leylines -= src

	return ..()

/datum/mana_pool/leyline/New(atom/parent = null, z_level = SSmapping.levels_by_trait(ZTRAIT_STATION)[1])
	GLOB.all_leylines += src

	intensity = generate_initial_intensity()
	themes = generate_initial_themes()

	for (var/datum/leyline_variable/attunement_theme/theme as anything in themes)
		theme.adjust_attunements(attunements_to_generate)

	maximum_mana_capacity *= (intensity.overall_mult)
	softcap = maximum_mana_capacity

	ethereal_recharge_rate *= (intensity.overall_mult)
	max_donation_rate_per_second *= (intensity.overall_mult)

	amount = maximum_mana_capacity

	create_leyline_objects(z_level)

	return ..()

/datum/mana_pool/leyline/generate_initial_attunements()
	return attunements_to_generate.Copy()

/datum/mana_pool/leyline/proc/generate_initial_intensity()
	var/picked_intensity = pickweight(GLOB.leyline_intensities)
	return new picked_intensity

/datum/mana_pool/leyline/proc/generate_initial_themes()
	var/list/datum/leyline_variable/attunement_theme/themes = get_random_attunement_themes()

	return themes

/// GETTERS / SETTERS

/datum/proc/get_accessable_leylines()
	RETURN_TYPE(/list/datum/mana_pool/leyline)

	var/list/datum/mana_pool/leyline/accessable_leylines = list()

	for (var/datum/mana_pool/leyline/entry as anything in GLOB.all_leylines)
		if (entry.can_entity_access(src))
			accessable_leylines += entry

	return accessable_leylines

/datum/proc/can_access_leyline(datum/mana_pool/leyline/leyline_in_question)
	return TRUE

/datum/mana_pool/leyline/proc/can_entity_access(datum/entity)
	return entity.can_access_leyline(src)

// A leyline variable is a thing to be generated when a leyline is instantiated and affects many features of said leyline

/datum/leyline_variable
	var/name = "abstract, do not instantiate"
	var/beam_color = COLOR_WHITE


/datum/mana_pool/leyline/proc/generate_start_and_end(station_z)
	var/starting_y = 0
	var/starting_x = 0
	var/stuck_dir = pick(GLOB.cardinals)

	var/ending_x = 0
	var/ending_y = 0

	var/stuck_axis
	switch(stuck_dir)
		if(NORTH)
			starting_y = world.maxy
			ending_y = 1
			stuck_axis = "Y"
		if(SOUTH)
			starting_y = 1
			ending_y = world.maxy
			stuck_axis = "Y"
		if(EAST)
			starting_x = 1
			ending_x = world.maxx
			stuck_axis = "X"
		if(WEST)
			starting_x = world.maxx
			ending_x = 1
			stuck_axis = "X"

	switch(stuck_axis)
		if("X")
			starting_y = rand(1, world.maxy)
			ending_y = rand(1, world.maxy)
		if("Y")
			starting_x = rand(1, world.maxx)
			ending_x = rand(1, world.maxx)

	var/turf/ending = locate(ending_x, ending_y, station_z)
	var/turf/starting = locate(starting_x, starting_y, station_z)

	return list(starting, ending, stuck_axis)

/datum/mana_pool/leyline/proc/create_leyline_objects(z_level)
	var/list/data = generate_start_and_end(z_level)
	var/turf/starting = data[1]
	var/turf/ending = data[2]
	var/datum/leyline_variable/attunement_theme/theme

	if(length(themes))
		theme = themes[1]

	current_beam = starting.Beam(
		ending,
		icon_state = "blood",
		time = INFINITY,
		beam_type = /obj/effect/ebeam/leyline,
		max_distance = world.maxx,
		beam_color = theme?.beam_color,
		beam_layer = UPPER_LEYLINE_LAYER,
		beam_plane = LEYLINE_PLANE,
		invisibility = INVISIBILITY_LEYLINES,
		mana_pool = src,
	)

/obj/effect/ebeam/leyline
	vis_flags = VIS_HIDE
