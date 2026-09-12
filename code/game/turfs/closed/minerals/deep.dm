/turf/closed/mineral/deep
	icon = 'icons/turf/smooth/walls/mineral_grey.dmi'

/turf/closed/mineral/random/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "rand_low_deep")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/deep = 20,
		/turf/closed/mineral/copper/deep = 15,
		/turf/closed/mineral/tin/deep = 12,
		/turf/closed/mineral/iron/deep = 5,
		/turf/closed/mineral/coal/deep = 5
	)

/turf/closed/mineral/random/deep/med
	icon_state = MAP_SWITCH("mineral", "rand_med_deep")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/salt/deep = 20,
		/turf/closed/mineral/iron/deep = 25,
		/turf/closed/mineral/coal/deep = 20,
		/turf/closed/mineral/copper/deep = 10,
		/turf/closed/mineral/tin/deep = 10,
		/turf/closed/mineral/silver/deep = 1
	)

/turf/closed/mineral/random/deep/high
	icon_state = MAP_SWITCH("mineral", "rand_high_deep")
	mineralSpawnChanceList = list(
		/turf/closed/mineral/mana_crystal/deep = 15,
		/turf/closed/mineral/cinnabar/deep = 5,
		/turf/closed/mineral/gold/deep = 15,
		/turf/closed/mineral/iron/deep = 25,
		/turf/closed/mineral/silver/deep = 15
	)

/turf/closed/mineral/copper/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "copper_deep")

/turf/closed/mineral/tin/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "tin_deep")

/turf/closed/mineral/silver/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "silver_deep")

/turf/closed/mineral/gold/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_deep")

/turf/closed/mineral/salt/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "salt_deep")

/turf/closed/mineral/cinnabar/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_deep")

/turf/closed/mineral/mana_crystal/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "gold_deep")

/turf/closed/mineral/iron/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "iron_deep")

/turf/closed/mineral/coal/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "coal_deep")

/turf/closed/mineral/gemeralds/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "gem_deep")

/turf/closed/mineral/bedrock/deep
	icon = MAP_SWITCH('icons/turf/smooth/walls/mineral_grey.dmi', 'icons/turf/mining/mining_deep.dmi')
	icon_state = MAP_SWITCH("mineral", "bedrock_deep")
