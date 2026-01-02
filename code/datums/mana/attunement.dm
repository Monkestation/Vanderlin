GLOBAL_LIST_INIT(magic_attunements, create_attunement_list())
/// List of typepaths - to access the singletons, access magic attunements
GLOBAL_LIST_INIT(default_attunements, create_default_attunement_list())

// Color definitions for attunements
GLOBAL_LIST_INIT(attunement_colors, list(
	/datum/attunement/fire = "#FF4500",        // Orange-red
	/datum/attunement/ice = "#00BFFF",         // Deep sky blue
	/datum/attunement/electric = "#FFD700",    // Gold/yellow
	/datum/attunement/blood = "#8B0000",       // Dark red
	/datum/attunement/life = "#32CD32",        // Lime green
	/datum/attunement/death = "#800080",       // Purple
	/datum/attunement/earth = "#8B4513",       // Saddle brown
	/datum/attunement/light = "#FFFFFF",       // White
	/datum/attunement/dark = "#2F2F2F",        // Dark gray
	/datum/attunement/time = "#C0C0C0",        // Silver
	/datum/attunement/aeromancy = "#87CEEB",   // Sky blue
	/datum/attunement/arcyne = "#9932CC",      // Dark orchid
	/datum/attunement/illusion = "#FF1493",    // Deep pink
	/datum/attunement/polymorph = "#FF69B4"    // Hot pink
))

// Proc to get the dominant attunement color from a spell's attunements
/proc/get_spell_attunement_color(list/attunements)
	if(!attunements || !length(attunements))
		return "#FFFFFF" // Default white if no attunements

	var/highest_weight = 0
	var/dominant_attunement = null

	// Find the attunement with the highest weight
	for(var/attunement_type in attunements)
		var/weight = attunements[attunement_type]
		if(weight > highest_weight)
			highest_weight = weight
			dominant_attunement = attunement_type

	// If no dominant attunement found, use the first one
	if(!dominant_attunement && length(attunements))
		dominant_attunement = attunements[1]

	return GLOB.attunement_colors[dominant_attunement] || "#FFFFFF"

// Proc to blend multiple attunement colors based on their weights
/proc/get_blended_attunement_color(list/attunements)
	if(!attunements || !length(attunements))
		return "#FFFFFF"

	var/total_weight = 0
	var/red_sum = 0
	var/green_sum = 0
	var/blue_sum = 0

	// Calculate weighted average of RGB values
	for(var/attunement_type in attunements)
		var/weight = attunements[attunement_type]
		var/color = GLOB.attunement_colors[attunement_type]
		if(!color)
			continue

		total_weight += weight

		// Extract RGB components (assuming hex format #RRGGBB)
		var/red = hex2num(copytext(color, 2, 4))
		var/green = hex2num(copytext(color, 4, 6))
		var/blue = hex2num(copytext(color, 6, 8))

		red_sum += red * weight
		green_sum += green * weight
		blue_sum += blue * weight

	if(total_weight == 0)
		return "#FFFFFF"

	// Calculate final RGB values
	var/final_red = round(red_sum / total_weight)
	var/final_green = round(green_sum / total_weight)
	var/final_blue = round(blue_sum / total_weight)

	return rgb(final_red, final_green, final_blue)

/obj/effect/spell_rune
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "rune"
	vis_flags = NONE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SET_BASE_PIXEL(-8, -8)
	var/datum/weakref/mob
	var/original_color

/obj/effect/spell_rune/Initialize(mapload, mob/target_mob, spell_color = "#FFFFFF")
	. = ..()
	original_color = spell_color
	color = spell_color
	mob = WEAKREF(target_mob)
	overlays += emissive_appearance(icon, icon_state, alpha = src.alpha)

/obj/effect/spell_rune/Destroy(force)
	if(mob)
		var/mob/holder = mob.resolve()
		holder.vis_contents -= src
		mob = null
	return ..()

/obj/effect/temp_visual/wave_up
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "wave_up"
	vis_flags = NONE
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SET_BASE_PIXEL(-8, -8)
	duration = 1.8 SECONDS
	var/datum/weakref/mob

/obj/effect/temp_visual/wave_up/Initialize(mapload, mob/target_mob)
	. = ..()
	mob = WEAKREF(target_mob)
	overlays += emissive_appearance(icon, icon_state, alpha = src.alpha)

/obj/effect/temp_visual/wave_up/Destroy(force)
	if(mob)
		var/mob/holder = mob.resolve()
		holder.vis_contents -= src
		mob = null
	return ..()

/obj/effect/temp_visual/particle_up
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "particle_up"
	vis_flags = NONE
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SET_BASE_PIXEL(0, -8)
	duration = 3.8 SECONDS
	var/datum/weakref/mob

/obj/effect/temp_visual/particle_up/Initialize(mapload, mob/target_mob, obj/spell_rune)
	. = ..()
	mob = WEAKREF(target_mob)
	RegisterSignal(spell_rune, COMSIG_PARENT_QDELETING, PROC_REF(clean_up))
	overlays += emissive_appearance(icon, icon_state, alpha = src.alpha)

/obj/effect/temp_visual/particle_up/Destroy(force)
	if(mob)
		var/mob/holder = mob.resolve()
		holder.vis_contents -= src
		mob = null
	return ..()

/obj/effect/temp_visual/particle_up/proc/clean_up()
	SIGNAL_HANDLER

	qdel(src)

/proc/create_attunement_list()
	. = list()

	var/list/typecache = typecacheof(/datum/attunement, ignore_root_path = TRUE)
	for (var/datum/attunement/typepath as anything in typecache)
		.[typepath] = new typepath

/proc/create_default_attunement_list()
	. = list()
	for (var/datum/attunement/iterated_attunement as anything in GLOB.magic_attunements)
		.[iterated_attunement] = 0 // make it an assoc list

// Not touching subtypes right now or compound attunements

/// The "attunement" a certain spell or piece of mana may have. When mana is consumed, it's attunements will be compared to the attunements of
/// what consumed it, and then the result will be used to generate how much mana will be actually consumed. Matching attunements decreases cost,
/// vice versa.
/datum/attunement
	var/name = "Base attunement"
	var/desc = "Some coder forgot to set desc"

	var/list/alignments = list() // no alignments by default

/datum/attunement/Destroy(force, ...)
	stack_trace("Destroy called on [src], [src.type], a singleton attunement instance!")
	if (!force)
		return QDEL_HINT_LETMELIVE //should not be deleted, ever
	// forced
	. = ..()

	GLOB.magic_attunements[src.type] = new src.type // recover

/// Should return how much we want the cost multiplier on a cast to be incremented by.
/// Inverse - Higher positive increments = lower cost, higher negative increments = higher cost
/datum/attunement/proc/get_bias_mult_increment(atom/caster)
	return 0

/datum/attunement/fire
	name = "Pyromancy"
	desc = "Perhaps the most well-known, and often many a mage's first study of the elements, pyromancy covers any heat or other flame related magic."

	alignments = list(
		/datum/patron/divine/astrata = 1,
		/datum/patron/inhumen/zizo = 0.25,
		/datum/patron/divine/noc = 0.15,
		/datum/patron/divine/malum = 1.2,
	)

/datum/attunement/ice
	name = "Cryomancy"
	desc = "Sibling and eternal rival of Pyromancy, Cryomancy centers on the manipulation of the cold, far beyond just water."

	alignments = list(
		/datum/patron/divine/noc = 1,
		/datum/patron/inhumen/zizo = 0.4,
	)

/datum/attunement/electric
	name = "Electric"
	desc = "An element typically associated with weather, sometimes with divinity, and often technology."

	alignments = list(
		/datum/patron/divine/noc = 0.25,
		/datum/patron/inhumen/zizo = 0.15,
		/datum/patron/divine/abyssor = 0.5,
	)

/datum/attunement/blood
	name = "Hydrosophy"
	desc = "The lifeblood of all organics, water is ubiquitous with any land, and is a core aspect of any town."

	alignments = list(
		/datum/patron/divine/abyssor = 2,
		/datum/patron/divine/pestra = 0.5,
		/datum/patron/divine/dendor = 0.5,
		/datum/patron/inhumen/zizo = 1,
		/datum/patron/inhumen/graggar = 2,
	)

/datum/attunement/life
	name = "Life"
	desc = "The driving force of, and most effectively seen in, all living matter. Life is the most far-reaching of all elements, with its effects seen across the lands."

	alignments = list(
		/datum/patron/divine/pestra = 1,
		/datum/patron/divine/astrata = 0.5,
		/datum/patron/inhumen/baotha = 1,
	)

/datum/attunement/death
	name = "Death"
	desc = "The energy that fuels the end of effectively all living matter."

	alignments = list(
		/datum/patron/divine/necra = 0.5,
		/datum/patron/inhumen/zizo = 0.5,
	)


/datum/attunement/earth
	name = "Earth"
	desc = "The very ground you stand on, a raging earthquake, or a paved road, earth is all encompassing."

	alignments = list(
		/datum/patron/divine/dendor = 1.2,
		/datum/patron/divine/malum = 0.5,
		/datum/patron/divine/ravox = 1,
	)

/datum/attunement/light
	name = "Light"
	desc = "Light is the natural enemy of the dark."

	alignments = list(
		/datum/patron/divine/astrata = 0.15,
		/datum/patron/divine/noc = 0.15,
		/datum/patron/divine/necra = 0.15,
		/datum/patron/divine/xylix = 0.15,
		/datum/patron/divine/eora = 0.15,
		/datum/patron/divine/ravox = 0.15,
	)

/datum/attunement/dark
	name = "Dark"
	desc = "Able to subtract Light, combine with other elements, and manifest on its own."

	alignments = list(
		/datum/patron/inhumen/zizo = 0.15,
		/datum/patron/inhumen/baotha = 0.15,
		/datum/patron/inhumen/graggar = 0.15,
		/datum/patron/inhumen/matthios = 0.15,
	)

/datum/attunement/time
	name = "Time"
	desc = "A unique and nigh-impossible element to master by all but those with either endless lifespans, or non-Euclidean existence. Measured by all civilizations, and the defining aspect of countless realms and systems."

	alignments = list(
		/datum/patron/divine/necra = 1,
		/datum/patron/divine/eora = 0.6,
		/datum/patron/inhumen/matthios = 0.75,
	)

/datum/attunement/aeromancy
	name = "Aeromancy"
	desc =  "Air, breathing, motion, and atmosphere. These are all products of aeromancy."

	alignments = list(
		/datum/patron/divine/abyssor = 0.5
	)

/datum/attunement/arcyne
	name = "Arcyne"
	desc = ""

	alignments = list(
		/datum/patron/divine/noc = 2,
		/datum/patron/inhumen/zizo = 1.2,
	)

/datum/attunement/illusion
	name = "Illusion"
	desc = ""

	alignments = list(
		/datum/patron/divine/xylix = 1,
	)

/datum/attunement/polymorph
	name = "Polymorph"
	desc = ""

	alignments = list(
		/datum/patron/divine/xylix = 1,
	)
