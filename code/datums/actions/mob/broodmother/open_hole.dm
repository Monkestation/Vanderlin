
GLOBAL_LIST_EMPTY(broodmother_base_holes)

#define BROODMOTHER_HOLE_COLLAPSE_TIME 15 MINUTES

/datum/map_template/broodmother_sinkhole_one
	width = 6
	height = 5

	id = "broodmother_sinkhole_one"
	name = "Broodmother Escape One"
	mappath = "_maps/templates/broodmother/broodmother_escape1.dmm"

/datum/map_template/broodmother_sinkhole_two
	width = 7
	height = 5

	id = "broodmother_sinkhole_two"
	name = "Broodmother Escape Two"
	mappath = "_maps/templates/broodmother/broodmother_escape2.dmm"

/datum/map_template/broodmother_sinkhole_three
	width = 7
	height = 4

	id = "broodmother_sinkhole_three"
	name = "Broodmother Escape Three"
	mappath = "_maps/templates/broodmother/broodmother_escape3.dmm"

/datum/map_template/broodmother_sinkhole_four
	width = 4
	height = 6

	id = "broodmother_sinkhole_four"
	name = "Broodmother Escape Four"
	mappath = "_maps/templates/broodmother/broodmother_escape4.dmm"

/obj/structure/broodmother_hole_base
	name = "gaping hole"
	desc = "A dark tunnel mouth leading up to the surface."
	icon = 'icons/roguetown/topadd/rousman/structures.dmi'
	icon_state = "rousman_hole_inactive"
	density = FALSE
	anchored = TRUE
	/// The unique schematic that gets built topside when a hole using
	/// this base connection collapses.
	var/datum/map_template/collapse_template = /datum/map_template/broodmother_sinkhole_one
	/// The temporary field-end hole currently linked to us, if any.
	var/obj/structure/broodmother_hole_field/linked_hole

/obj/structure/broodmother_hole_base/Initialize(mapload)
	. = ..()
	if(!collapse_template)
		stack_trace("broodmother_hole_base placed without a collapse_template set at [AREACOORD(src)]")
	LAZYADD(GLOB.broodmother_base_holes, src)

/obj/structure/broodmother_hole_base/Destroy()
	LAZYREMOVE(GLOB.broodmother_base_holes, src)
	if(linked_hole)
		var/obj/structure/broodmother_hole_field/other = linked_hole
		linked_hole = null
		if(!QDELETED(other))
			other.linked_base = null
			qdel(other)
	return ..()

/obj/structure/broodmother_hole_base/Crossed(atom/movable/crosser)
	. = ..()
	try_teleport(crosser)

/obj/structure/broodmother_hole_base/proc/try_teleport(atom/movable/crosser)
	if(!isliving(crosser))
		return
	var/mob/living/user = crosser
	if(!is_broodmother_faction(user))
		return
	if(!linked_hole || QDELETED(linked_hole))
		return
	do_teleport(user, get_turf(linked_hole), 0, channel = TELEPORT_CHANNEL_MAGIC)

/obj/structure/broodmother_hole_base/proc/is_broodmother_faction(mob/living/user)
	return HAS_TRAIT(user, TRAIT_BROOD)

/obj/structure/broodmother_hole_field
	name = "gaping hole"
	desc = "A dark, wet tunnel that leads straight down."
	icon = 'icons/roguetown/topadd/rousman/structures.dmi'
	icon_state = "rousman_hole_inactive"
	density = FALSE
	anchored = TRUE
	var/obj/structure/broodmother_hole_base/linked_base

/obj/structure/broodmother_hole_field/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(collapse)), BROODMOTHER_HOLE_COLLAPSE_TIME)

/obj/structure/broodmother_hole_field/Destroy()
	if(linked_base)
		var/obj/structure/broodmother_hole_base/other = linked_base
		linked_base = null
		if(!QDELETED(other))
			other.linked_hole = null
			qdel(other)
	return ..()

/obj/structure/broodmother_hole_field/proc/collapse()
	var/turf/turf = get_turf(src)
	var/datum/map_template/template = linked_base?.collapse_template
	qdel(src)
	if(template)
		var/datum/map_template/built = new template()
		built.load(turf, TRUE)

/obj/structure/broodmother_hole_field/Crossed(atom/movable/crosser)
	. = ..()
	try_teleport(crosser)

/obj/structure/broodmother_hole_field/proc/try_teleport(atom/movable/crosser)
	if(!isliving(crosser))
		return
	var/mob/living/user = crosser
	if(!is_broodmother_faction(user))
		return
	if(!linked_base || QDELETED(linked_base))
		return
	do_teleport(user, get_turf(linked_base), 0, channel = TELEPORT_CHANNEL_WORMHOLE)

/obj/structure/broodmother_hole_field/proc/is_broodmother_faction(mob/living/user)
	return HAS_TRAIT(user, TRAIT_BROOD)

/datum/action/cooldown/spell/broodmother_hole
	name = "Open Hole"
	desc = "Tears a hole to the broodmother's lair. It collapses after a few minutes, sealing shut for good."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "spell_default"
	cooldown_time = 2 MINUTES
	spell_type = NONE
	charge_required = FALSE

/datum/action/cooldown/spell/broodmother_hole/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!istype(caster))
		return

	var/turf/cast_turf = get_turf(caster)

	if(!check_valid_area(cast_turf))
		to_chat(caster, span_warning("You need open sky above you to tear a hole like this."))
		return

	var/obj/structure/broodmother_hole_base/destination = pick_free_base_hole()
	if(!destination)
		to_chat(caster, span_warning("There's nowhere left for the hole to lead."))
		return

	var/obj/structure/broodmother_hole_field/field_hole = new(cast_turf)
	field_hole.linked_base = destination
	destination.linked_hole = field_hole

	caster.visible_message(span_danger("[caster] tears open a hole in the ground!"))
	playsound(cast_turf, "genblunt", 60, TRUE)

	if(!length(GLOB.broodmother_base_holes))
		to_chat(caster, span_warning("You feel the last of your tunnels seal shut for good."))
		Remove(caster)

/datum/action/cooldown/spell/broodmother_hole/proc/check_valid_area(turf/center)
	if(!center)
		return FALSE
	for(var/turf/nearby_turf in RANGE_TURFS(3, center))
		if(istype(nearby_turf, /turf/open/openspace))
			return FALSE
	return TRUE

/// Picks a mapped-in base hole that hasn't been used yet.
/datum/action/cooldown/spell/broodmother_hole/proc/pick_free_base_hole()
	var/list/candidates = list()
	for(var/obj/structure/broodmother_hole_base/base_hole in GLOB.broodmother_base_holes)
		if(!base_hole.linked_hole)
			candidates += base_hole
	if(!length(candidates))
		return null
	return pick(candidates)

#undef BROODMOTHER_HOLE_COLLAPSE_TIME
