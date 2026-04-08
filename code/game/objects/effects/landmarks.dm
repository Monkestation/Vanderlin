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
	icon_state = "arrow"
	anchored = TRUE
	layer = MOB_LAYER
	var/used = FALSE
	var/list/jobs_to_spawn = list()
	/// Is this for round start or late join? Should only ever be TRUE or FALSE.
	var/roundstart = TRUE
	/// Does this landmark have custom setup for joining?
	var/custom_handling = FALSE

/obj/effect/landmark/start/Initialize(mapload)
	. = ..()

	if(custom_handling)
		return

	if(roundstart)
		GLOB.roundstart_landmarks += src
	else
		GLOB.latejoin_landmarks += src

	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/Destroy(force)
	GLOB.roundstart_landmarks -= src
	GLOB.latejoin_landmarks -=src
	return ..()

/obj/effect/landmark/start/late
	roundstart = FALSE
	icon_state = "arrow_blue"

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

/obj/effect/landmark/start/late/villager
	name = "Towner"
	jobs_to_spawn = list("Towner")

/obj/effect/landmark/start/lord
	name = JOB_MONARCH
	jobs_to_spawn = list(JOB_MONARCH)

/obj/effect/landmark/start/captain
	name = "Captain"
	jobs_to_spawn = list("Captain")

/obj/effect/landmark/start/steward
	name = JOB_STEWARD
	jobs_to_spawn = list(JOB_STEWARD)

/obj/effect/landmark/start/magician
	name = JOB_COURT_MAGE
	jobs_to_spawn = list(JOB_COURT_MAGE)

/obj/effect/landmark/start/courtphys
	name = JOB_COURT_PHYSICIAN
	jobs_to_spawn = list(JOB_COURT_PHYSICIAN)

/obj/effect/landmark/start/guardsman
	name = "City Watchmen"
	jobs_to_spawn = list("City Watchmen")

/obj/effect/landmark/start/lieutenant
	name = "City Watch Lieutenant"
	jobs_to_spawn = list("City Watch Lieutenant")

/obj/effect/landmark/start/manorguardsman
	name = "Royal Knight"
	jobs_to_spawn = list("Royal Knight")

/obj/effect/landmark/start/tombwarden
	name = "Veteran"
	jobs_to_spawn = list("Veteran")

/obj/effect/landmark/start/dungeoneer
	name = "Dungeoneer"
	jobs_to_spawn = list("Dungeoneer")

/obj/effect/landmark/start/watchman
	name = "Men-at-arms"
	jobs_to_spawn = list("Men-at-arms")

/obj/effect/landmark/start/gatemaster
	name = "Gatemaster"
	jobs_to_spawn = list("Gatemaster")

/obj/effect/landmark/start/forestwarden
	name = "Forest Warden"
	jobs_to_spawn = list("Forest Warden")

/obj/effect/landmark/start/forestguard
	name = "Forest Guard"
	jobs_to_spawn = list("Forest Guard")

/obj/effect/landmark/start/woodsman
	name = "Town Elder"
	jobs_to_spawn = list("Town Elder")

/obj/effect/landmark/start/priest
	name = "Priest"
	jobs_to_spawn = list("Priest")

/obj/effect/landmark/start/monk
	name = "Acolyte"
	jobs_to_spawn = list("Acolyte")

/obj/effect/landmark/start/templar
	name = "Templar"
	jobs_to_spawn = list("Grandmaster Templar", "Templar") // Temp until I can map in the spawn

/obj/effect/landmark/start/gmtemplar
	name = "Grandmaster Templar"
	jobs_to_spawn = list("Grandmaster Templar")

/obj/effect/landmark/start/puritan
	name = "Herr Prafekt"
	jobs_to_spawn = list("Herr Prafekt")

/obj/effect/landmark/start/late/puritan
	name = "Herr Prafekt"
	jobs_to_spawn = list("Herr Prafekt")

/obj/effect/landmark/start/orthodoxist
	name = "Sacrestants"
	jobs_to_spawn = list("Sacrestants")

/obj/effect/landmark/start/late/orthodoxist
	name = "Sacrestants"
	jobs_to_spawn = list("Sacrestants")

/obj/effect/landmark/start/absolver
	name = "Absolver"
	jobs_to_spawn = list("Absolver")

/obj/effect/landmark/start/late/absolver
	name = "Absolver"
	jobs_to_spawn = list("Absolver")

/obj/effect/landmark/start/adept
	name = "Adept"
	jobs_to_spawn = list("Adept")

/obj/effect/landmark/start/late/adept
	name = "Adept"
	jobs_to_spawn = list("Adept")

/obj/effect/landmark/start/apothecary
	name = JOB_APOTHECARY
	jobs_to_spawn = list(JOB_APOTHECARY)

/obj/effect/landmark/start/merchant
	name = JOB_MERCHANT
	jobs_to_spawn = list(JOB_MERCHANT)

/obj/effect/landmark/start/grabber
	name = JOB_STEVEDORE
	jobs_to_spawn = list(JOB_STEVEDORE)

/obj/effect/landmark/start/shophand
	name = JOB_SHOPHAND
	jobs_to_spawn = list(JOB_SHOPHAND)

/obj/effect/landmark/start/innkeep
	name = "Innkeep"
	jobs_to_spawn = list("Innkeep")

/obj/effect/landmark/start/archivist
	name = "Archivist"
	jobs_to_spawn = list("Archivist")

/obj/effect/landmark/start/blacksmith
	name = "Blacksmith"
	jobs_to_spawn = list("Blacksmith")

/obj/effect/landmark/start/tailor
	name = "Tailor"
	jobs_to_spawn = list("Tailor")

/obj/effect/landmark/start/alchemist
	name = "Alchemist"
	jobs_to_spawn = list("Alchemist")

/obj/effect/landmark/start/artificer
	name = "Artificer"
	jobs_to_spawn = list("Artificer")

/obj/effect/landmark/start/matron
	name = "Matron"
	jobs_to_spawn = list("Matron")

/obj/effect/landmark/start/farmer
	name = "Soilson"
	jobs_to_spawn = list("Soilson")

/obj/effect/landmark/start/beastmonger
	name = "Butcher"
	jobs_to_spawn = list("Butcher")

/obj/effect/landmark/start/cook
	name = "Cook"
	jobs_to_spawn = list("Cook")

/obj/effect/landmark/start/gravedigger
	name = JOB_GRAVETENDER
	jobs_to_spawn = list(JOB_GRAVETENDER)

/obj/effect/landmark/start/mercenary
	name = JOB_MERCENARY
	jobs_to_spawn = list(JOB_MERCENARY)

/obj/effect/landmark/start/late/mercenary
	name = JOB_MERCENARY
	jobs_to_spawn = list(JOB_MERCENARY)

/obj/effect/landmark/start/minor_noble
	name = JOB_MINOR_NOBLE
	jobs_to_spawn = list(JOB_MINOR_NOBLE)

/obj/effect/landmark/start/villager
	name = "Towners"
	jobs_to_spawn = list("Hunter","Lumberjack","Miner","Bard","Carpenter","Cheesemaker")

/obj/effect/landmark/start/hunter
	name = "Hunter"
	jobs_to_spawn = list("Hunter")

/obj/effect/landmark/start/lumberjack
	name = "Lumberjack"
	jobs_to_spawn = list("Lumberjack")

/obj/effect/landmark/start/miner
	name = "Miner"
	jobs_to_spawn = list("Miner")

/obj/effect/landmark/start/bard
	name = "Bard"
	jobs_to_spawn = list("Bard")

/obj/effect/landmark/start/carpenter
	name = "Carpenter"
	jobs_to_spawn = list("Carpenter")

/obj/effect/landmark/start/cheesemaker
	name = "Cheesemaker"
	jobs_to_spawn = list("Cheesemaker")

/obj/effect/landmark/start/vagrant
	name = JOB_BEGGAR
	jobs_to_spawn = list(JOB_BEGGAR)

/obj/effect/landmark/start/late/vagrant
	name = JOB_BEGGAR
	jobs_to_spawn = list(JOB_BEGGAR)

/obj/effect/landmark/start/consort
	name = JOB_CONSORT
	jobs_to_spawn = list(JOB_CONSORT)

/obj/effect/landmark/start/prince
	name = JOB_PRINCE
	jobs_to_spawn = list(JOB_PRINCE)

/obj/effect/landmark/start/prisoner
	name = JOB_PRISONER
	jobs_to_spawn = list(JOB_PRISONER)

/obj/effect/landmark/start/jester
	name = JOB_JESTER
	jobs_to_spawn = list(JOB_JESTER)

/obj/effect/landmark/start/hand
	name = JOB_HAND
	jobs_to_spawn = list(JOB_HAND)

/obj/effect/landmark/start/courtagent
	name = JOB_COURT_AGENT
	jobs_to_spawn = list(JOB_COURT_AGENT)

/obj/effect/landmark/start/fisher
	name = JOB_FISHER
	jobs_to_spawn = list(JOB_FISHER)

/obj/effect/landmark/start/butler
	name = JOB_BUTLER
	jobs_to_spawn = list(JOB_BUTLER)

/obj/effect/landmark/start/adventurer
	name = JOB_ADVENTURER
	jobs_to_spawn = list(JOB_ADVENTURER)

/obj/effect/landmark/start/outsider
	name = "Outsiders"
	jobs_to_spawn = list(JOB_PILGRIM, JOB_ADVENTURER, "Wretch")
	custom_handling = TRUE

/obj/effect/landmark/start/outsider/Initialize(mapload)
	. = ..()
	GLOB.roundstart_landmarks += src
	GLOB.latejoin_landmarks +=src

/obj/effect/landmark/start/feldsher
	name = JOB_FELDSHER
	jobs_to_spawn = list(JOB_FELDSHER)

/obj/effect/landmark/start/tombwarden
	name = JOB_TOMB_WARDEN
	jobs_to_spawn = list(JOB_TOMB_WARDEN)

/obj/effect/landmark/start/squire
	name = JOB_SQUIRE
	jobs_to_spawn = list(JOB_SQUIRE)

/obj/effect/landmark/start/wapprentice
	name = JOB_MAGIC_APP
	jobs_to_spawn = list(JOB_MAGIC_APP)

/obj/effect/landmark/start/servant
	name = JOB_SERVANT
	jobs_to_spawn = list(JOB_SERVANT)

/obj/effect/landmark/start/tapster
	name = JOB_TAPSTER
	jobs_to_spawn = list(JOB_TAPSTER)

/obj/effect/landmark/start/churchling
	name = JOB_CHURCHLING
	jobs_to_spawn = list(JOB_CHURCHLING)

/obj/effect/landmark/start/orphan
	name = JOB_ORPHAN
	jobs_to_spawn = list(JOB_ORPHAN)

/obj/effect/landmark/start/late/orphan
	name = JOB_ORPHAN
	jobs_to_spawn = list(JOB_ORPHAN)

/obj/effect/landmark/start/sapprentice
	name = JOB_SMITHY_APP
	jobs_to_spawn = list(JOB_SMITHY_APP)

/obj/effect/landmark/start/innkeep_son
	name = JOB_INKEEP_SON
	jobs_to_spawn = list(JOB_INKEEP_SON)

/obj/effect/landmark/start/clinicapprentice
	name = JOB_CLINIC_APP
	jobs_to_spawn = list(JOB_CLINIC_APP)

/obj/effect/landmark/start/bogwitch
	name = "Bog Witch and Apprentice"
	jobs_to_spawn = list(JOB_BOGWITCH, JOB_BOGWITCH_APP)

/obj/effect/landmark/start/late/bogwitch
	name = "Bog Witch and Apprentice"
	jobs_to_spawn = list(JOB_BOGWITCH, JOB_BOGWITCH_APP)

//Antagonist spawns

/obj/effect/landmark/start/bandit
	name = "Bandit"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow_purple"
	jobs_to_spawn = list("Bandit")
	custom_handling = TRUE

/obj/effect/landmark/start/bandit/Initialize()
	. = ..()
	GLOB.bandit_starts += loc
	GLOB.roundstart_landmarks += src

/obj/effect/landmark/start/lich
	name = "Lich"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow_purple"
	jobs_to_spawn = list("Lich")
	custom_handling = TRUE

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
	icon_state = "arrow_purple"
	custom_handling = TRUE

/obj/effect/landmark/start/delf/Initialize()
	. = ..()
	GLOB.delf_starts += loc

/obj/effect/landmark/start/jarosite
	name = "jarosite"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "arrow_purple"
	custom_handling = TRUE

/obj/effect/landmark/start/jarosite/Initialize()
	. = ..()
	GLOB.jarosite_starts += loc

// Must be immediate because players will
// join before SSatom initializes everything.
INITIALIZE_IMMEDIATE(/obj/effect/landmark/start/new_player)

/obj/effect/landmark/start/new_player
	name = "New Player"
	icon_state = "x"

/obj/effect/landmark/start/new_player/Initialize()
	. = ..()
	GLOB.newplayer_start += loc

/obj/effect/landmark/backup_join
	name = "Backup Late Spawn"
	icon_state = "arrow_blue"

/obj/effect/landmark/backup_join/Initialize(mapload)
	..()
	SSjob.backup_join_landmarks += loc
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
