/obj/effect/mapping_helpers/access/keyset
	name = "accesses helper"
	icon_state = "access_helper"
	var/list/accesses
	var/difficulty

/obj/effect/mapping_helpers/access/keyset/payload(obj/payload)
	if(!length(accesses))
		log_mapping("[src] at [AREACOORD(src)] tried to set lockids, but had nothing to assign!")
		return
	if(!payload.lock_check(TRUE))
		log_mapping("[src] at [AREACOORD(src)] tried to set lockids, but [payload.type] hasn't got a keylock!")
		return
	var/datum/lock/key/KL = payload.lock
	if(KL.lockid_list)
		log_mapping("[src] at [AREACOORD(src)] tried to set lockids, but [payload.type] has them set!")
		return
	if(difficulty)
		KL.set_pick_difficulty(difficulty)
	KL.set_access(accesses)

// Town locks
/obj/effect/mapping_helpers/access/keyset/town
	color = "#58431e"
	difficulty = LOCK_SKILLED

/obj/effect/mapping_helpers/access/keyset/town/tailor
	accesses = list(ACCESS_TAILOR)

/obj/effect/mapping_helpers/access/keyset/town/smith
	accesses = list(ACCESS_SMITH)

/obj/effect/mapping_helpers/access/keyset/town/inn
	accesses = list(ACCESS_INN)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/inn_room
	color = "#1f4a60"
	accesses = list(ACCESS_INN)
	difficulty = LOCK_MASTER
	var/room_id

/obj/effect/mapping_helpers/access/keyset/town/inn_room/LateInitialize()
	if(room_id)
		accesses += room_id
	return ..()

/obj/effect/mapping_helpers/access/keyset/town/artificer
	accesses = list(ACCESS_ARTIFICER)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/miner
	accesses = list(ACCESS_MINER)

/obj/effect/mapping_helpers/access/keyset/town/clinic
	accesses = list(ACCESS_CLINIC)

/obj/effect/mapping_helpers/access/keyset/town/merchant
	accesses = list(ACCESS_MERCHANT)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/soilson
	accesses = list(ACCESS_FARM)

/obj/effect/mapping_helpers/access/keyset/town/butcher
	accesses = list(ACCESS_BUTCHER)

/obj/effect/mapping_helpers/access/keyset/town/apothecary
	accesses = list(ACCESS_APOTHECARY)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/doctor
	accesses = list(ACCESS_FELDSHER)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/matron
	accesses = list(ACCESS_MATRON)

/obj/effect/mapping_helpers/access/keyset/town/mercenary
	accesses = list(ACCESS_MERC)

/obj/effect/mapping_helpers/access/keyset/town/tomb
	accesses = list(ACCESS_TOMB)

/obj/effect/mapping_helpers/access/keyset/town/elder
	accesses = list(ACCESS_ELDER)

/obj/effect/mapping_helpers/access/keyset/town/tombwarden
	accesses = list(ACCESS_TOMBWARDEN)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/tower
	accesses = list(ACCESS_TOWER)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/warehouse
	accesses = list(ACCESS_WAREHOUSE)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/town/bathhouse
	accesses = list(ACCESS_BATHHOUSE)
	difficulty = LOCK_NOVICE

/obj/effect/mapping_helpers/access/keyset/town/sweeper
	accesses = list(ACCESS_SWEEPER)

/obj/effect/mapping_helpers/access/keyset/town/hunter
	accesses = list(ACCESS_HUNTER)

// Town Garrison
/obj/effect/mapping_helpers/access/keyset/garrison
	color = "#b02323"
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/garrison/general
	accesses = list(ACCESS_GARRISON)

/obj/effect/mapping_helpers/access/keyset/garrison/lieutenant
	accesses = list(ACCESSS_LIEUTENANT)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/garrison/captain
	accesses = list(ACCESS_CAPTAIN)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/garrison/captain/butler
	accesses = list(ACCESS_CAPTAIN, ACCESS_BUTLER)

/obj/effect/mapping_helpers/access/keyset/garrison/forest
	accesses = list(ACCESS_FOREST)

/obj/effect/mapping_helpers/access/keyset/garrison/gate
	accesses = list(ACCESS_GATE)

// Church locks
/obj/effect/mapping_helpers/access/keyset/church
	color = "#eaed3e"
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/church/general
	accesses = list(ACCESS_CHURCH)

/obj/effect/mapping_helpers/access/keyset/church/priest
	accesses = list(ACCESS_PRIEST)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/church/inquisition
	accesses = list(ACCESS_RITTER)

/obj/effect/mapping_helpers/access/keyset/church/grave
	accesses = list(ACCESS_GRAVE)
	difficulty = LOCK_SKILLED

// Manor locks
/obj/effect/mapping_helpers/access/keyset/manor
	color = "#a926ad"
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/manor/general
	accesses = list(ACCESS_MANOR)
	color = "#efa6f1"

/obj/effect/mapping_helpers/access/keyset/manor/gate
	accesses = list(ACCESS_MANOR_GATE)

/obj/effect/mapping_helpers/access/keyset/manor/steward
	accesses = list(ACCESS_STEWARD)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/manor/dungeon
	accesses = list(ACCESS_DUNGEON)

/obj/effect/mapping_helpers/access/keyset/manor/hand
	accesses = list(ACCESS_HAND)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/manor/hand/butler
	accesses = list(ACCESS_HAND, ACCESS_BUTLER)

/obj/effect/mapping_helpers/access/keyset/manor/courtagent
	accesses = list(ACCESS_COURTAGENT)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/manor/lord
	accesses = list(ACCESS_LORD)
	difficulty = LOCK_LEGENDARY

/obj/effect/mapping_helpers/access/keyset/manor/lord/consort
	accesses = list(ACCESS_LORD, ACCESS_CONSORT)

/obj/effect/mapping_helpers/access/keyset/manor/lord/butler
	accesses = list(ACCESS_LORD, ACCESS_CONSORT, ACCESS_BUTLER)

/obj/effect/mapping_helpers/access/keyset/manor/vault
	accesses = list(ACCESS_VAULT)
	difficulty = LOCK_LEGENDARY

/obj/effect/mapping_helpers/access/keyset/manor/mage
	accesses = list(ACCESS_MAGE)

/obj/effect/mapping_helpers/access/keyset/manor/archive
	accesses = list(ACCESS_ARCHIVIST)

/obj/effect/mapping_helpers/access/keyset/manor/archive/semipublic
	accesses = list(ACCESS_ARCHIVIST, ACCESS_LIBRARY)

/obj/effect/mapping_helpers/access/keyset/manor/archive/wiz_shared
	accesses = list(ACCESS_ARCHIVIST, ACCESS_MAGE)

/obj/effect/mapping_helpers/access/keyset/manor/archive/butler
	accesses = list(ACCESS_ARCHIVIST, ACCESS_BUTLER)

/obj/effect/mapping_helpers/access/keyset/manor/atarms
	accesses = list(ACCESS_AT_ARMS)

/obj/effect/mapping_helpers/access/keyset/manor/atarms/butler
	accesses = list(ACCESS_AT_ARMS, ACCESS_BUTLER)

/obj/effect/mapping_helpers/access/keyset/manor/servant
	accesses = list(ACCESS_SERVANT)
	difficulty = LOCK_SKILLED

/obj/effect/mapping_helpers/access/keyset/manor/servant/garrison
	accesses = list(ACCESS_SERVANT, ACCESS_AT_ARMS)

/obj/effect/mapping_helpers/access/keyset/manor/butler
	accesses = list(ACCESS_BUTLER)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/manor/heir
	accesses = list(ACCESS_HEIR, ACCESS_CONSORT, ACCESS_BUTLER)
	difficulty = LOCK_EXPERT

/obj/effect/mapping_helpers/access/keyset/manor/guest1
	accesses = list(ACCESS_GUEST1, ACCESS_CONSORT)
	difficulty = LOCK_SKILLED

/obj/effect/mapping_helpers/access/keyset/manor/guest2
	accesses = list(ACCESS_GUEST2, ACCESS_CONSORT)
	difficulty = LOCK_SKILLED

/obj/effect/mapping_helpers/access/keyset/manor/guest3
	accesses = list(ACCESS_GUEST3, ACCESS_CONSORT)
	difficulty = LOCK_SKILLED

/obj/effect/mapping_helpers/access/keyset/manor/physician
	accesses = list(ACCESS_PHYSICIAN)

/obj/effect/mapping_helpers/access/keyset/manor/physician/butler
	accesses = list(ACCESS_PHYSICIAN, ACCESS_BUTLER)

/obj/effect/mapping_helpers/access/keyset/manor/Noble1
	accesses = list(ACCESS_NOBLE1)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/manor/Noble2
	accesses = list(ACCESS_NOBLE2)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/manor/Noble3
	accesses = list(ACCESS_NOBLE3)
	difficulty = LOCK_MASTER

// Thatchwood

/obj/effect/mapping_helpers/access/keyset/thatchwood/inn1
	accesses = list("oldinn1")

/obj/effect/mapping_helpers/access/keyset/thatchwood/inn2
	accesses = list("oldinn2")

/obj/effect/mapping_helpers/access/keyset/thatchwood/inn3
	accesses = list("oldinn3")

/obj/effect/mapping_helpers/access/keyset/thatchwood/farm
	accesses = list("oldfarm")

/obj/effect/mapping_helpers/access/keyset/thatchwood/smith
	accesses = list("oldsmith")


/obj/effect/mapping_helpers/access/keyset/other
	color = "#3eed64"

/obj/effect/mapping_helpers/access/keyset/other/bogwitch
	accesses = list(ACCESS_BOGWITCH)
	difficulty = LOCK_MASTER


/obj/effect/mapping_helpers/access/keyset/antag
	color = "#990000"

/obj/effect/mapping_helpers/access/keyset/antag/bandit
	accesses = list(ACCESS_BANDIT)

/obj/effect/mapping_helpers/access/keyset/antag/vampire_manor
	accesses = list(ACCESS_VAMPIRE)
	difficulty = LOCK_MASTER

/obj/effect/mapping_helpers/access/keyset/antag/lich
	accesses = list(ACCESS_LICH)
	difficulty = LOCK_MASTER
