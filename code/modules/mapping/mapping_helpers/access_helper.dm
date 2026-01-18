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
	difficulty = 4

/obj/effect/mapping_helpers/access/keyset/town/tailor
	accesses = list(ACCESS_TAILOR)

/obj/effect/mapping_helpers/access/keyset/town/smith
	accesses = list(ACCESS_SMITH)

/obj/effect/mapping_helpers/access/keyset/town/inn
	accesses = list(ACCESS_INN)
	difficulty = 5

/obj/effect/mapping_helpers/access/keyset/town/artificer
	accesses = list(ACCESS_ARTIFICER)
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/town/miner
	accesses = list(ACCESS_MINER)

/obj/effect/mapping_helpers/access/keyset/town/clinic
	accesses = list(ACCESS_CLINIC)

/obj/effect/mapping_helpers/access/keyset/town/merchant
	accesses = list(ACCESS_MERCHANT)
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/town/soilson
	accesses = list(ACCESS_FARM)

/obj/effect/mapping_helpers/access/keyset/town/butcher
	accesses = list(ACCESS_BUTCHER)

/obj/effect/mapping_helpers/access/keyset/town/apothecary
	accesses = list(ACCESS_APOTHECARY)
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/town/doctor
	accesses = list(ACCESS_FELDSHER)
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/town/matron
	accesses = list(ACCESS_MATRON)

/obj/effect/mapping_helpers/access/keyset/town/mercenary
	accesses = list(ACCESS_MERC)

/obj/effect/mapping_helpers/access/keyset/town/elder
	accesses = list(ACCESS_ELDER)

/obj/effect/mapping_helpers/access/keyset/town/veteran
	accesses = list(ACCESS_VETERAN)

/obj/effect/mapping_helpers/access/keyset/town/gaffer
	accesses = list(ACCESS_GAFFER)
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/town/tower
	accesses = list(ACCESS_TOWER)
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/town/warehouse
	accesses = list(ACCESS_WAREHOUSE)
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/town/bathhouse
	accesses = list(ACCESS_BATHHOUSE)
	difficulty = 5

// Town Garrison
/obj/effect/mapping_helpers/access/keyset/garrison
	color = "#b02323"
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/garrison/general
	accesses = list(ACCESS_GARRISON)

/obj/effect/mapping_helpers/access/keyset/garrison/lieutenant
	accesses = list(ACCESSS_LIEUTENANT)
	difficulty = 2

/obj/effect/mapping_helpers/access/keyset/garrison/captain
	accesses = list(ACCESS_CAPTAIN)
	difficulty = 2

/obj/effect/mapping_helpers/access/keyset/garrison/forest
	accesses = list(ACCESS_FOREST)

/obj/effect/mapping_helpers/access/keyset/garrison/gate
	accesses = list(ACCESS_GATE)

// Church locks
/obj/effect/mapping_helpers/access/keyset/church
	color = "#eaed3e"
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/church/general
	accesses = list(ACCESS_CHURCH)

/obj/effect/mapping_helpers/access/keyset/church/priest
	accesses = list(ACCESS_PRIEST)
	difficulty = 2

/obj/effect/mapping_helpers/access/keyset/church/inquisition
	accesses = list(ACCESS_RITTER)

/obj/effect/mapping_helpers/access/keyset/church/grave
	accesses = list(ACCESS_GRAVE)
	difficulty = 4

// Manor locks
/obj/effect/mapping_helpers/access/keyset/manor
	color = "#a926ad"
	difficulty = 3

/obj/effect/mapping_helpers/access/keyset/manor/general
	accesses = list(ACCESS_MANOR)

/obj/effect/mapping_helpers/access/keyset/manor/gate
	accesses = list(ACCESS_MANOR_GATE)

/obj/effect/mapping_helpers/access/keyset/manor/steward
	accesses = list(ACCESS_STEWARD)
	difficulty = 2

/obj/effect/mapping_helpers/access/keyset/manor/dungeon
	accesses = list(ACCESS_DUNGEON)

/obj/effect/mapping_helpers/access/keyset/manor/hand
	accesses = list(ACCESS_HAND)
	difficulty = 2

/obj/effect/mapping_helpers/access/keyset/manor/lord
	accesses = list(ACCESS_LORD)
	difficulty = 1

/obj/effect/mapping_helpers/access/keyset/manor/vault
	accesses = list(ACCESS_VAULT)
	difficulty = 1

/obj/effect/mapping_helpers/access/keyset/manor/mage
	accesses = list(ACCESS_MAGE)

/obj/effect/mapping_helpers/access/keyset/manor/archive
	accesses = list(ACCESS_ARCHIVE)

/obj/effect/mapping_helpers/access/keyset/manor/atarms
	accesses = list(ACCESS_AT_ARMS)

/obj/effect/mapping_helpers/access/keyset/manor/guest
	accesses = list(ACCESS_GUEST)
	difficulty = 4

/obj/effect/mapping_helpers/access/keyset/manor/physician
	accesses = list(ACCESS_PHYSICIAN)

/obj/effect/mapping_helpers/access/keyset/manor/Noble1
	accesses = list(ACCESS_NOBLE1)
	difficulty = 2

/obj/effect/mapping_helpers/access/keyset/manor/Noble2
	accesses = list(ACCESS_NOBLE2)
	difficulty = 2

/obj/effect/mapping_helpers/access/keyset/manor/Noble3
	accesses = list(ACCESS_NOBLE3)
	difficulty = 2

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
