GLOBAL_LIST_INIT(marking_zones, list(BODY_ZONE_HEAD,BODY_ZONE_CHEST,BODY_ZONE_L_LEG,BODY_ZONE_R_LEG,BODY_ZONE_L_ARM,BODY_ZONE_R_ARM,BODY_ZONE_PRECISE_L_HAND,BODY_ZONE_PRECISE_R_HAND))
GLOBAL_LIST_INIT(marking_zone_to_bitflag, list(
	BODY_ZONE_HEAD = HEAD,
	BODY_ZONE_CHEST = CHEST,
	BODY_ZONE_L_LEG = LEG_LEFT,
	BODY_ZONE_R_LEG = LEG_RIGHT,
	BODY_ZONE_L_ARM = ARM_LEFT,
	BODY_ZONE_R_ARM = ARM_RIGHT,
	BODY_ZONE_PRECISE_L_HAND = HAND_LEFT,
	BODY_ZONE_PRECISE_R_HAND = HAND_RIGHT
	))
GLOBAL_LIST_EMPTY_TYPED(body_markings_per_limb, /list)
GLOBAL_LIST_EMPTY(body_markings_by_type)
GLOBAL_LIST_EMPTY(body_marking_sets_by_type)
GLOBAL_LIST_INIT(body_markings, build_body_marking_references())
GLOBAL_LIST_INIT(body_marking_sets, build_body_marking_set_references())

/proc/build_body_marking_references()
	// Here we build the global list for all body markings
	. = list()
	for(var/datum/body_marking/BM as anything in subtypesof(/datum/body_marking))
		if(initial(BM.name))
			BM = new BM()
			.[BM.name] = BM
			GLOB.body_markings_by_type[BM.type] = BM
			//We go through all the possible affected bodyparts and a name reference where applicable
			for(var/marking_zone in GLOB.marking_zones)
				var/bitflag = GLOB.marking_zone_to_bitflag[marking_zone]
				if(BM.affected_bodyparts & bitflag)
					if(!GLOB.body_markings_per_limb[marking_zone])
						GLOB.body_markings_per_limb[marking_zone] = list()
					GLOB.body_markings_per_limb[marking_zone] += BM.name

/proc/build_body_marking_set_references()
	// Here we build the global list for all body markings sets
	. = list()
	for(var/datum/body_marking_set/BM as anything in subtypesof(/datum/body_marking_set))
		if(initial(BM.name))
			BM = new BM()
			.[BM.name] = BM
			GLOB.body_marking_sets_by_type[BM.type] = BM

