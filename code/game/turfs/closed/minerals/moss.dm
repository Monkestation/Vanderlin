/turf/closed/mineral/moss
	icon = 'icons/turf/smooth/walls/mineral_moss.dmi'

/turf/closed/mineral/random/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "rand_low_moss")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/moss = 20,
		/turf/closed/mineral/copper/moss = 15,
		/turf/closed/mineral/tin/moss = 12,
		/turf/closed/mineral/iron/moss = 5,
		/turf/closed/mineral/coal/moss = 5
	)

/turf/closed/mineral/random/moss/med
	icon_state = MAP_SWITCH("mineral", "rand_med_moss")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/moss = 20,
		/turf/closed/mineral/iron/moss = 25,
		/turf/closed/mineral/coal/moss = 20,
		/turf/closed/mineral/copper/moss = 10,
		/turf/closed/mineral/tin/moss = 10,
		/turf/closed/mineral/silver/moss = 1
	)

/turf/closed/mineral/random/moss/high
	icon_state = MAP_SWITCH("mineral", "rand_high_moss")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/mana_crystal/moss = 15,
		/turf/closed/mineral/cinnabar/moss = 5,
		/turf/closed/mineral/gold/moss = 15,
		/turf/closed/mineral/iron/moss = 25,
		/turf/closed/mineral/silver/moss = 15
	)

/turf/closed/mineral/copper/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "copper_moss")

/turf/closed/mineral/tin/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "tin_moss")

/turf/closed/mineral/silver/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "silver_moss")

/turf/closed/mineral/gold/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_moss")

/turf/closed/mineral/salt/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "salt_moss")

/turf/closed/mineral/cinnabar/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_moss")

/turf/closed/mineral/mana_crystal/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_moss")

/turf/closed/mineral/iron/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "iron_moss")

/turf/closed/mineral/coal/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "coal_moss")

/turf/closed/mineral/gemeralds/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "gem_moss")

/turf/closed/mineral/bedrock/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_moss.dmi', 'icons/turf/mining/mining_moss.dmi')
	icon_state = MAP_SWITCH("mineral", "bedrock_moss")
