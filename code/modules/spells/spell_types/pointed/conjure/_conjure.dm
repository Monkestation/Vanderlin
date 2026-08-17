/datum/action/cooldown/spell/conjure
	/// A list of types that will be created on summon.
	/// The type is picked from this list, not all provided are guaranteed.
	var/list/summon_type = list()
	/// The radius around the caster the items will appear. 0 = spawns on top of the caster.
	var/summon_radius = 7
	/// How long before the summons will be despawned. Set to 0 for permanent.
	var/summon_lifespan = 0
	/// Amount of summons to create. Set to 0 for all turfs in range.
	var/summon_amount = 1
	/// If TRUE, summoned objects will not be spawned in dense turfs.
	var/summon_respects_density = TRUE
	/// If TRUE, no two summons can be spawned in the same turf.
	var/summon_respects_prev_spawn_points = TRUE

/datum/action/cooldown/spell/conjure/cast(atom/cast_on)
	. = ..()
	var/list/to_summon_in = list()
	for(var/turf/summon_turf in range(summon_radius, cast_on))
		if(isopenspace(summon_turf))
			continue
		if(summon_respects_density && summon_turf.density)
			continue
		to_summon_in += summon_turf

	if(!summon_amount)
		summon_amount = length(to_summon_in)

	for(var/i in 1 to summon_amount)
		if(!length(to_summon_in))
			break

		var/atom/summoned_object_type = pick(summon_type)
		var/turf/spawn_place = pick(to_summon_in)
		if(summon_respects_prev_spawn_points)
			to_summon_in -= spawn_place

		if(ispath(summoned_object_type, /turf))
			spawn_place.ChangeTurf(summoned_object_type, flags = CHANGETURF_INHERIT_AIR)

		else
			var/atom/summoned_object = new summoned_object_type(spawn_place)

			summoned_object.flags_1 |= ADMIN_SPAWNED_1
			if(summon_lifespan > 0)
				QDEL_IN(summoned_object, summon_lifespan)

			post_summon(summoned_object, cast_on)

/// Called on atoms summoned after they are created, allows extra variable editing and such of created objects
/datum/action/cooldown/spell/conjure/proc/post_summon(atom/summoned_object, atom/cast_on)
	return
