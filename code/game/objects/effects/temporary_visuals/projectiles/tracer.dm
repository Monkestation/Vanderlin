/proc/generate_tracer_between_points(datum/point/starting, datum/point/ending, beam_type, color, qdel_in = 5, light_outer_range =  2, light_color_override, light_intensity = 1, instance_key)		//Do not pass z-crossing points as that will not be properly (and likely will never be properly until it's absolutely needed) supported!
	if(!istype(starting) || !istype(ending) || !ispath(beam_type))
		return
	var/datum/point/midpoint = point_midpoint_points(starting, ending)
	var/obj/effect/projectile/tracer/PB = new beam_type(midpoint.return_turf())
	if(isnull(light_color_override))
		light_color_override = color
	PB.apply_vars(angle_between_points(starting, ending), midpoint.return_px(), midpoint.return_py(), color, pixel_length_between_points(starting, ending) / world.icon_size, midpoint.return_turf(), 0)
	PB.plane = GAME_PLANE_UPPER
	. = PB
	if(light_outer_range > 0 && light_intensity > 0)
		var/list/turf/line = getline(starting.return_turf(), ending.return_turf())
		tracing_line:
			for(var/turf/T as anything in line)
				for(var/obj/effect/projectile_lighting/PL in T)
					if(PL.owner == instance_key)
						continue tracing_line
				QDEL_IN(new /obj/effect/projectile_lighting(T, light_color_override, light_outer_range, light_intensity, instance_key), qdel_in > 0? qdel_in : 5)
		line = null
	if(qdel_in)
		QDEL_IN(PB, qdel_in)

/obj/effect/projectile/tracer
	name = "beam"
	icon = 'icons/obj/projectiles_tracer.dmi'

/obj/effect/projectile/tracer/stun
	name = "stun beam"
	icon_state = "stun"

/obj/effect/projectile/tracer/blood
	name = "blood bolt"
	icon_state = "cult"

/obj/effect/projectile/tracer/bloodsteal
	name = "blood steal"
	icon_state = "hcult"
