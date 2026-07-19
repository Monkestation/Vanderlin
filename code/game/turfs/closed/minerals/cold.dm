/turf/closed/mineral/cold
	icon = 'icons/turf/smooth/walls/mineral_blue.dmi'

/turf/closed/mineral/random/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "rand_low_ice")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/cold = 20,
		/turf/closed/mineral/copper/cold = 15,
		/turf/closed/mineral/tin/cold = 12,
		/turf/closed/mineral/iron/cold = 5,
		/turf/closed/mineral/coal/cold = 5
	)

/turf/closed/mineral/random/cold/med
	icon_state = MAP_SWITCH("mineral", "rand_med_ice")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/cold = 20,
		/turf/closed/mineral/iron/cold = 25,
		/turf/closed/mineral/coal/cold = 20,
		/turf/closed/mineral/copper/cold = 10,
		/turf/closed/mineral/tin/cold = 10,
		/turf/closed/mineral/silver/cold = 1
	)

/turf/closed/mineral/random/cold/high
	icon_state = MAP_SWITCH("mineral", "rand_high_ice")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/mana_crystal/cold = 15,
		/turf/closed/mineral/cinnabar/cold = 5,
		/turf/closed/mineral/gold/cold = 15,
		/turf/closed/mineral/iron/cold = 25,
		/turf/closed/mineral/silver/cold = 15
	)

/turf/closed/mineral/copper/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "copper_ice")

/turf/closed/mineral/tin/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "tin_ice")

/turf/closed/mineral/silver/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "silver_ice")

/turf/closed/mineral/gold/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_ice")

/turf/closed/mineral/salt/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "salt_ice")

/turf/closed/mineral/cinnabar/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_ice")

/turf/closed/mineral/mana_crystal/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_ice")

/turf/closed/mineral/iron/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "iron_ice")

/turf/closed/mineral/coal/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "coal_ice")

/turf/closed/mineral/gemeralds/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "gem_ice")

/turf/closed/mineral/bedrock/cold
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_blue.dmi', 'icons/turf/mining/mining_cold.dmi')
	icon_state = MAP_SWITCH("mineral", "bedrock_ice")
