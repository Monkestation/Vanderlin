/turf/closed/mineral/warm
	icon = 'icons/turf/smooth/walls/mineral_red.dmi'

/turf/closed/mineral/random/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "rand_low_warm")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/warm = 20,
		/turf/closed/mineral/copper/warm = 15,
		/turf/closed/mineral/tin/warm = 12,
		/turf/closed/mineral/iron/warm = 5,
		/turf/closed/mineral/coal/warm = 5
	)

/turf/closed/mineral/random/warm/med
	icon_state = MAP_SWITCH("mineral", "rand_med_warm")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/warm = 20,
		/turf/closed/mineral/iron/warm = 25,
		/turf/closed/mineral/coal/warm = 20,
		/turf/closed/mineral/copper/warm = 10,
		/turf/closed/mineral/tin/warm = 10,
		/turf/closed/mineral/silver/warm = 1
	)

/turf/closed/mineral/random/warm/high
	icon_state = MAP_SWITCH("mineral", "rand_high_warm")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/mana_crystal/warm = 15,
		/turf/closed/mineral/cinnabar/warm = 5,
		/turf/closed/mineral/gold/warm = 15,
		/turf/closed/mineral/iron/warm = 25,
		/turf/closed/mineral/silver/warm = 15
	)

/turf/closed/mineral/copper/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "copper_warm")

/turf/closed/mineral/tin/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "tin_warm")

/turf/closed/mineral/silver/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "silver_warm")

/turf/closed/mineral/gold/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_warm")

/turf/closed/mineral/salt/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "salt_warm")

/turf/closed/mineral/cinnabar/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_warm")

/turf/closed/mineral/mana_crystal/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_warm")

/turf/closed/mineral/iron/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "iron_warm")

/turf/closed/mineral/coal/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "coal_warm")

/turf/closed/mineral/gemeralds/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "gem_warm")

/turf/closed/mineral/bedrock/warm
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_red.dmi', 'icons/turf/mining/mining_hot.dmi')
	icon_state = MAP_SWITCH("mineral", "bedrock_warm")
