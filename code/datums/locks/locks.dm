// This file should be used for special static locks that always remain the same

///// Locks
/datum/lock/locked
	locked = TRUE

///// Key locks
/datum/lock/key/locked
	locked = TRUE

/datum/lock/key/steward
	lockid_list = list(ACCESS_STEWARD)
	locked = TRUE

/datum/lock/key/merchant
	lockid_list = list(ACCESS_MERCHANT)
	locked = TRUE

/datum/lock/key/lord
	lockid_list = list(ACCESS_LORD)
	locked = TRUE

/datum/lock/key/apothecary
	lockid_list = list(ACCESS_APOTHECARY)
	locked = TRUE

/datum/lock/key/manor
	lockid_list = list(ACCESS_MANOR)
	locked = TRUE

/datum/lock/key/atarms
	lockid_list = list(ACCESS_AT_ARMS)
	locked = TRUE

/datum/lock/key/inn
	lockid_list = list(ACCESS_INN)
	locked = TRUE

/datum/lock/key/vendor
	locked = TRUE
	difficulty = 3
	requires_turning = FALSE

/datum/lock/key/goldface
	lockid_list = list(ACCESS_MERCHANT)
	locked = TRUE
	difficulty = 3

/datum/lock/key/purity
	lockid_list = list(ACCESS_APOTHECARY)
	locked = TRUE
	difficulty = 3

/datum/lock/key/nerve
	lockid_list = list(ACCESS_STEWARD)
	locked = TRUE
	difficulty = 1

///// Multiple key locks
/datum/lock/key/pillory
	lockid_list = list(ACCESS_GARRISON, ACCESS_FOREST, ACCESS_AT_ARMS, ACCESS_DUNGEON)

/datum/lock/key/pillory/church
	lockid_list = list(ACCESS_CHURCH, ACCESS_PRIEST)
