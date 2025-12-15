SUBSYSTEM_DEF(fire_burning)
	name = "Fire Burning"
	priority = FIRE_PRIORITY_BURNING
	flags = SS_NO_INIT|SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/list/processing = list()

/datum/controller/subsystem/fire_burning/stat_entry()
	..("P:[processing.len]")

/datum/controller/subsystem/fire_burning/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	var/fire_multiplier = CONFIG_GET(number/damage_multiplier/fire)
	var/max_fire_damage_per_tick = CONFIG_GET(number/per_tick/max_fire_damage)
	/// The longer the burn timer / stack the more intense the burn damage. Increases by  (Default: 5)
	var/fire_intensity = 5

	while(currentrun.len)
		var/obj/O = currentrun[currentrun.len]
		currentrun.len--
		fire_intensity = fire_intensity + CLAMP(fire_multiplier, 1, INFINITY) // 6 -> 7 -> 8 etc...
		if (!O || QDELETED(O))
			processing -= O
			if (MC_TICK_CHECK)
				return
			continue

		var/is_wet = FALSE

		if(istype(O, /obj/item/clothing))
			var/obj/item/clothing/cloth = O
			if(cloth.wet)
				var/dry_amount = round(fire_intensity / 5)
				cloth.wet.use_water(dry_amount)

				if(cloth.wet.water_stacks < 0)
					is_wet = TRUE   // stop it from burning while it is wet

		if(O.resistance_flags & ON_FIRE) //in case an object is extinguished while still in currentrun
			if(!(O.resistance_flags & FIRE_PROOF) && !is_wet)
				// Minimum of 8 burn per tick. Config for max fire damage per tick found in game_options.
				O.take_damage((2 * fire_multiplier) + CLAMP(fire_intensity, 0, max_fire_damage_per_tick), BURN, "fire", 0)
			else
				O.extinguish()
			if(!O.fire_burn_start)
				O.fire_burn_start = world.time
			if(world.time > O.fire_burn_start + 30 SECONDS)
				O.extinguish()
		else
			O.extinguish()

		if (MC_TICK_CHECK)
			return

