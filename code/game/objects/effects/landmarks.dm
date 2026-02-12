/obj/effect/landmark
	name = "landmark"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

// Please stop bombing the Observer-Start landmark.
/obj/effect/landmark/ex_act()
	return

INITIALIZE_IMMEDIATE(/obj/effect/landmark)

/obj/effect/landmark/Initialize()
	. = ..()
	GLOB.landmarks_list += src

/obj/effect/landmark/Destroy()
	GLOB.landmarks_list -= src
	return ..()

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/list/jobspawn_override = list()
	var/delete_after_roundstart = TRUE
	var/used = FALSE

/obj/effect/landmark/start/Initialize(mapload)
	. = ..()
	GLOB.start_landmarks_list += src

	if(length(jobspawn_override))
		for(var/X in jobspawn_override)
			if(!GLOB.jobspawn_overrides[X])
				GLOB.jobspawn_overrides[X] = list()
			GLOB.jobspawn_overrides[X] += src

	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy(force)
	GLOB.start_landmarks_list -= src
	for(var/X in jobspawn_override)
		GLOB.jobspawn_overrides[X] -= src
	return ..()

/obj/effect/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/obj/effect/landmark/events/haunts
	name = "hauntz"
	icon_state = MAP_SWITCH("", "generic_event")

/obj/effect/landmark/events/haunts/Initialize(mapload)
	. = ..()
	GLOB.hauntstart |= src

/obj/effect/landmark/events/haunts/Destroy()
	GLOB.hauntstart -= src
	return ..()

/obj/effect/landmark/events/testportal
	name = "testserverportal"
	icon_state = "x4"
	var/aportalloc = "a"

/obj/effect/landmark/events/testportal/Initialize(mapload)
	. = ..()
//	GLOB.hauntstart += loc
#ifdef TESTSERVER
	var/obj/structure/fluff/testportal/T = new /obj/structure/fluff/testportal(loc)
	T.aportalloc = aportalloc
	GLOB.testportals += T
#endif
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/start/adventurerlate
	name = "Adventurerlate"
	icon_state = "arrow"
	jobspawn_override = list("Pilgrim", "Adventurer", "Wretch")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vagrantlate
	name = "Beggarlate"
	icon_state = "arrow"
	jobspawn_override = list("Beggar")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/orphanlate
	name = "Orphanlate"
	icon_state = "arrow"
	jobspawn_override = list("Orphan")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/mercenarylate
	name = "Mercenarylate"
	icon_state = "arrow"
	jobspawn_override = list("Mercenary")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/villagerlate
	name = "Townerlate"
	icon_state = "arrow"
	jobspawn_override = list("Towner")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/combatlate
	name = "Combatlate"
	icon_state = "arrow"
	jobspawn_override = list( "Pilgrim", "Adventurer", "Mercenary")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/lord
	name = "Monarch"
	icon_state = "arrow"

/obj/effect/landmark/start/captain
	name = "Captain"
	icon_state = "arrow"

/obj/effect/landmark/start/steward
	name = "Steward"
	icon_state = "arrow"

/obj/effect/landmark/start/magician
	name = "Court Magician"
	icon_state = "arrow"

/obj/effect/landmark/start/courtphys
	name = "Court Physician"
	icon_state = "arrow"

/obj/effect/landmark/start/guardsman
	name = "City Watchmen"
	icon_state = "arrow"

/obj/effect/landmark/start/lieutenant
	name = "City Watch Lieutenant"
	icon_state = "arrow"

/obj/effect/landmark/start/manorguardsman
	name = "Royal Knight"
	icon_state = "arrow"

/obj/effect/landmark/start/veteran
	name = "Veteran"
	icon_state = "arrow"

/obj/effect/landmark/start/jailor
	name = "Jailor"
	icon_state = "arrow"

/obj/effect/landmark/start/dungeoneer
	name = "Dungeoneer"
	icon_state = "arrow"

/obj/effect/landmark/start/watchman
	name = "Men-at-arms"
	icon_state = "arrow"

/obj/effect/landmark/start/gatemaster
	name = "Gatemaster"
	icon_state = "arrow"

/obj/effect/landmark/start/forestwarden
	name = "Forest Warden"
	icon_state = "arrow"

/obj/effect/landmark/start/forestguard
	name = "Forest Guard"
	icon_state = "arrow"

/obj/effect/landmark/start/villager
	name = "Towner"
	icon_state = "arrow"
	jobspawn_override = list("Hunter","Lumberjack","Miner","Bard","Carpenter","Cheesemaker")

/obj/effect/landmark/start/cheesemaker
	name = "Cheesemaker"
	icon_state = "arrow"

/obj/effect/landmark/start/woodsman
	name = "Town Elder"
	icon_state = "arrow"

/obj/effect/landmark/start/priest
	name = "Priest"
	icon_state = "arrow"


/obj/effect/landmark/start/monk
	name = "Acolyte"
	icon_state = "arrow"

/obj/effect/landmark/start/puritan
	name = "Inquisitor"
	icon_state = "arrow"

/obj/effect/landmark/start/orthodoxist
	name = "Orthodoxist"
	icon_state = "arrow"

/obj/effect/landmark/start/absolver
	name = "Absolver"
	icon_state = "arrow"

/obj/effect/landmark/start/adept
	name = "Adept"
	icon_state = "arrow"

/obj/effect/landmark/start/templar
	name = "Templar"
	icon_state = "arrow"

/obj/effect/landmark/start/nightman
	name = "Apothecary"
	icon_state = "arrow"

/obj/effect/landmark/start/nightmaiden
	name = "Nitemaiden"
	icon_state = "arrow"

/obj/effect/landmark/start/merchant
	name = "Merchant"
	icon_state = "arrow"

/obj/effect/landmark/start/grabber
	name = "Stevedore"
	icon_state = "arrow"

/obj/effect/landmark/start/shophand
	name = "Shophand"
	icon_state = "arrow"

/obj/effect/landmark/start/innkeep
	name = "Innkeep"
	icon_state = "arrow"

/obj/effect/landmark/start/archivist
	name = "Archivist"
	icon_state = "arrow"

/obj/effect/landmark/start/weaponsmith
	name = "Weaponsmith"
	icon_state = "arrow"

/obj/effect/landmark/start/armorsmith
	name = "Armorer"
	icon_state = "arrow"

/obj/effect/landmark/start/tailor
	name = "Tailor"
	icon_state = "arrow"

/obj/effect/landmark/start/alchemist
	name = "Alchemist"
	icon_state = "arrow"

/obj/effect/landmark/start/artificer
	name = "Artificer"
	icon_state = "arrow"

/obj/effect/landmark/start/scribe
	name = "Scribe"
	icon_state = "arrow"

/obj/effect/landmark/start/matron
	name = "Matron"
	icon_state = "arrow"

/obj/effect/landmark/start/farmer
	name = "Soilson"
	icon_state = "arrow"

/obj/effect/landmark/start/beastmonger
	name = "Butcher"
	icon_state = "arrow"

/obj/effect/landmark/start/cook
	name = "Cook"
	icon_state = "arrow"

/obj/effect/landmark/start/gravedigger
	name = "Gravetender"
	icon_state = "arrow"

/obj/effect/landmark/start/mercenary
	name = "Mercenary"
	icon_state = "arrow"

/obj/effect/landmark/start/minor_noble
	name = "Noble"
	icon_state = "arrow"

/obj/effect/landmark/start/miner
	name = "Miner"
	icon_state = "arrow"

/obj/effect/landmark/start/carpenter
	name = "Carpenter"
	icon_state = "arrow"

/obj/effect/landmark/start/bard
	name = "Bard"
	icon_state = "arrow"

/obj/effect/landmark/start/vagrant
	name = "Beggar"
	icon_state = "arrow"

/obj/effect/landmark/start/consort
	name = "Consort"
	icon_state = "arrow"

/obj/effect/landmark/start/prince
	name = "Prince"
	icon_state = "arrow"

/obj/effect/landmark/start/prisoner
	name = "Prisoner"
	icon_state = "arrow"

/obj/effect/landmark/start/jester
	name = "Jester"
	icon_state = "arrow"

/obj/effect/landmark/start/hand
	name = "Hand"
	icon_state = "arrow"

/obj/effect/landmark/start/courtagent
	name = "Court Agent"
	icon_state = "arrow"

/obj/effect/landmark/start/hunter
	name = "Hunter"
	icon_state = "arrow"

/obj/effect/landmark/start/fisher
	name = "Fisher"
	icon_state = "arrow"

/obj/effect/landmark/start/lumberjack
	name = "Lumberjack"
	icon_state = "arrow"

/obj/effect/landmark/start/butler
	name = "Butler"
	icon_state = "arrow"

/obj/effect/landmark/start/adventurer
	name = "Adventurer"
	icon_state = "arrow"

/obj/effect/landmark/start/feldsher
	name = "Feldsher"
	icon_state = "arrow"

/obj/effect/landmark/start/gaffer
	name = "Gaffer"
	icon_state = "arrow"
//yrf

/obj/effect/landmark/start/squire
	name = "Squire"
	icon_state = "arrow"

/obj/effect/landmark/start/wapprentice
	name = "Magician Apprentice"
	icon_state = "arrow"

/obj/effect/landmark/start/servant
	name = "Servant"
	icon_state = "arrow"

/obj/effect/landmark/start/tapster
	name = "Tapster"
	icon_state = "arrow"

/obj/effect/landmark/start/matron_assistant
	name = "Matron Assistant"
	icon_state = "arrow"

/obj/effect/landmark/start/gaffer_assistant
	name = "Ring Servant"
	icon_state = "arrow"

/obj/effect/landmark/start/churchling
	name = "Churchling"
	icon_state = "arrow"

/obj/effect/landmark/start/orphan
	name = "Orphan"
	icon_state = "arrow"

/obj/effect/landmark/start/sapprentice
	name = "Smithy Apprentice"
	icon_state = "arrow"

/obj/effect/landmark/start/innkeep_son
	name = "Innkeepers Son"
	icon_state = "arrow"

/obj/effect/landmark/start/clinicapprentice
	name = "Clinic Apprentice"
	icon_state = "arrow"

/obj/effect/landmark/start/evilskeleton	// Trying to make EVIL SKELTON actually spawn
	name = "Skeleton"
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "raiseskele"
	alpha = 20
	delete_after_roundstart = FALSE

//Antagonist spawns

/obj/effect/landmark/start/bandit
	name = "Bandit"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow"
	jobspawn_override = list("Bandit")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/bandit/Initialize()
	. = ..()
	GLOB.bandit_starts += loc

/obj/effect/landmark/start/lich
	name = "Lich"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow"
	jobspawn_override = list("Lich")
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/lich/Initialize()
	. = ..()
	GLOB.lich_starts += loc

/obj/effect/landmark/admin
	name = "admin"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow"

/obj/effect/landmark/admin/Initialize()
	. = ..()
	GLOB.admin_warp += loc

/obj/effect/landmark/start/delf
	name = "delf"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow"

/obj/effect/landmark/start/delf/Initialize()
	. = ..()
	GLOB.delf_starts += loc

/obj/effect/landmark/start/jarosite
	name = "jarosite"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow"

/obj/effect/landmark/start/jarosite/Initialize()
	. = ..()
	GLOB.jarosite_starts += loc

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/start/new_player)

/obj/effect/landmark/start/new_player
	name = "New Player"

/obj/effect/landmark/start/new_player/Initialize()
	. = ..()
	GLOB.newplayer_start += loc

/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/Initialize(mapload)
	..()
	SSjob.latejoin_trackers += loc
	return INITIALIZE_HINT_QDEL

//space carps, magicarps, lone ops, slaughter demons, possibly revenants spawn here
/obj/effect/landmark/carpspawn
	name = "carpspawn"
	icon_state = "carp_spawn"

//observer start
/obj/effect/landmark/observer_start
	name = "Observer-Start"
	icon_state = "x"


//players that get put in admin jail show up here
/obj/effect/landmark/prisonwarp
	name = "prisonwarp"
	icon_state = "prisonwarp"

/obj/effect/landmark/prisonwarp/Initialize(mapload)
	..()
	GLOB.prisonwarp += loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/ert_spawn
	name = "Emergencyresponseteam"
	icon_state = "ert_spawn"

/obj/effect/landmark/ert_spawn/Initialize(mapload)
	..()
	GLOB.emergencyresponseteamspawn += loc
	return INITIALIZE_HINT_QDEL

//generic event spawns
/obj/effect/landmark/event_spawn
	name = "generic event spawn"
	icon_state = "generic_event"
	layer = HIGH_LANDMARK_LAYER


/obj/effect/landmark/event_spawn/Initialize(mapload)
	. = ..()
	GLOB.generic_event_spawns += src

/obj/effect/landmark/event_spawn/Destroy()
	GLOB.generic_event_spawns -= src
	return ..()

/obj/effect/landmark/ruin
	var/datum/map_template/ruin/ruin_template

/obj/effect/landmark/ruin/Initialize(mapload, my_ruin_template)
	. = ..()
	name = "ruin_[length(GLOB.ruin_landmarks) + 1]"
	ruin_template = my_ruin_template
	GLOB.ruin_landmarks |= src

/obj/effect/landmark/ruin/Destroy()
	GLOB.ruin_landmarks -= src
	ruin_template = null
	. = ..()

/// Marks the bottom left of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_bottom_left
	name = "unit test zone bottom left"

/// Marks the top right of the testing zone.
/// In landmarks.dm and not unit_test.dm so it is always active in the mapping tools.
/obj/effect/landmark/unit_test_top_right
	name = "unit test zone top right"

//Underworld landmarks

/obj/effect/landmark/underworld_spawnpoint
	name = "underworld spawnpoint"

/obj/effect/landmark/underworld_spawnpoint/Initialize(mapload)
	. = ..()
	GLOB.underworldspiritspawns |= loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/underworld_pull_location
	name = "coin pull teleport zone"

/obj/effect/landmark/underworld_pull_location/Initialize()
	. = ..()
	GLOB.underworld_coinpull_locs |= loc
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/death_arena
	name = "Death arena spawn 1"

/obj/effect/landmark/death_arena/Initialize()
	. = ..()
	SSdeath_arena.assign_death_spawn(src)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/death_arena/second
	name = "Death arena spawn 2"
