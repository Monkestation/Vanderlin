#define VERGLAS_MODE_LAY 1
#define VERGLAS_MODE_HOLD 2
#define VERGLAS_DURATION (15 SECONDS)

/datum/action/cooldown/spell/verglas
	button_icon = 'icons/mob/actions/spells/mage_cryomancy.dmi'
	name = "Verglas"
	desc = "Lay a 7x7 patch of treacherous ice; anyone who steps onto it slides in the direction they were moving until they run off. \
	Use the Alt Mode keybind to switch between Lay (cast and forget) and Hold (maintained by concentration for as long as you like, but shattered the instant you are struck or cast another spell)."
	button_icon_state = "snap_freeze"

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	required_form = FORM_ICE
	required_technique = TECHNIQUE_CREATION

	invocation = "Gelu Fallax!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	cooldown_time = 20 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/verglas_radius = 3
	var/verglas_mode = VERGLAS_MODE_LAY

/datum/action/cooldown/spell/verglas/Grant(mob/grant_to)
	. = ..()
	update_mode_maptext()

/datum/action/cooldown/spell/verglas/toggle_alt_mode(mob/user)
	verglas_mode = (verglas_mode == VERGLAS_MODE_LAY) ? VERGLAS_MODE_HOLD : VERGLAS_MODE_LAY
	update_mode_maptext()
	return TRUE

/datum/action/cooldown/spell/verglas/proc/update_mode_maptext()
	var/label = (verglas_mode == VERGLAS_MODE_LAY) ? "LAY" : "HOLD"
	var/label_color = (verglas_mode == VERGLAS_MODE_LAY) ? GLOW_COLOR_ICE : "#ff6a3d"
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(label)
		holder.maptext_x = 5
		holder.color = label_color

/datum/action/cooldown/spell/verglas/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(verglas_mode == VERGLAS_MODE_HOLD && H.has_status_effect(/datum/status_effect/verglas_concentration))
		H.remove_status_effect(/datum/status_effect/verglas_concentration)
		return TRUE

	var/turf/centerpoint = get_turf(cast_on)
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	var/hold = (verglas_mode == VERGLAS_MODE_HOLD)
	playsound(centerpoint, 'sound/spellbooks/crystal.ogg', 80, TRUE)
	var/list/spawned = list()
	for(var/turf/open/T in get_hear(verglas_radius, centerpoint))
		if(!(T in get_hear(cast_range, source_turf)))
			continue
		if(T.density)
			continue
		T.MakeSlippery(TURF_WET_PERMAFROST, hold ? MAXIMUM_WET_TIME : VERGLAS_DURATION)
		spawned |= T

	if(hold && length(spawned))
		H.apply_status_effect(/datum/status_effect/verglas_concentration, spawned, centerpoint)
	return TRUE

/datum/status_effect/verglas_concentration
	id = "verglas_concentration"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/verglas_concentration
	var/list/tiles
	var/atom/field_center
	var/datum/beam/link_beam

/datum/status_effect/verglas_concentration/on_creation(mob/living/new_owner, list/field_tiles, atom/center)
	tiles = field_tiles
	field_center = center
	. = ..()

/datum/status_effect/verglas_concentration/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_struck))
	RegisterSignal(owner, COMSIG_MOB_CAST_SPELL, PROC_REF(on_cast))
	if(field_center)
		link_beam = owner.Beam(field_center, "b_beam", 'icons/effects/beam.dmi', INFINITY, 32, /obj/effect/ebeam/verglas_link)
	owner.balloon_alert_to_viewers("<font color='#ff6a3d'>concentrating - fragile!</font>")

/datum/status_effect/verglas_concentration/on_remove()
	. = ..()
	QDEL_NULL(link_beam)
	field_center = null
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE)
	UnregisterSignal(owner, COMSIG_MOB_CAST_SPELL)
	for(var/turf/open/T in tiles)
		T.MakeDry(TURF_WET_PERMAFROST)
	tiles = list()
	to_chat(owner, span_warning("My concentration breaks and the verglas melts away!"))

/obj/effect/ebeam/verglas_link
	color = "#ff6a3d"

/datum/status_effect/verglas_concentration/proc/on_struck(mob/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(!damage)
		return
	owner.remove_status_effect(/datum/status_effect/verglas_concentration)

/datum/status_effect/verglas_concentration/proc/on_cast(mob/source, datum/action/cooldown/spell/spell, atom/cast_on)
	SIGNAL_HANDLER
	if(istype(spell, /datum/action/cooldown/spell/verglas))
		return
	owner.remove_status_effect(/datum/status_effect/verglas_concentration)

/atom/movable/screen/alert/status_effect/verglas_concentration
	name = "Verglas Concentration"
	desc = "I am concentrating to hold the verglas in place. A single blow or casting another spell will shatter it."
	icon_state = "debuff"

#undef VERGLAS_MODE_LAY
#undef VERGLAS_MODE_HOLD
#undef VERGLAS_DURATION
