//the parent buff has the buff icon state, no need to apply it here aswell
/atom/movable/screen/alert/status_effect/buff/alch
	desc = "Power rushes through your veins."

/datum/status_effect/buff/alch
	duration = 10 MINUTES

/datum/status_effect/buff/alch/strengthpot/weak
	effectedstats = list(STAT_STRENGTH = 1)
	duration = 5 MINUTES

/datum/status_effect/buff/alch/strengthpot
	id = "Strength Potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/strengthpot
	effectedstats = list(STAT_STRENGTH = 3)

/datum/status_effect/buff/alch/strengthpot/concentrated
	id = "Concentrated Strength Potion"
	effectedstats = list(STAT_STRENGTH = 6)

/atom/movable/screen/alert/status_effect/buff/alch/strengthpot
	name = "Strength"

/datum/status_effect/buff/alch/perceptionpot/weak
	effectedstats = list(STAT_PERCEPTION = 1)
	duration = 5 MINUTES

/datum/status_effect/buff/alch/perceptionpot
	id = "Perception Potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/perceptionpot
	effectedstats = list(STAT_PERCEPTION = 3)

/datum/status_effect/buff/alch/perceptionpot/concentrated
	id = "Concentrated Perception Potion"
	effectedstats = list(STAT_PERCEPTION = 6)

/atom/movable/screen/alert/status_effect/buff/alch/perceptionpot
	name = "Perception"

/datum/status_effect/buff/alch/intelligencepot
	id = "Intelligence Potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	effectedstats = list(STAT_INTELLIGENCE = 3)

/datum/status_effect/buff/alch/intelligencepot/concentrated
	id = "Concentrated Intelligence Potion"
	effectedstats = list(STAT_INTELLIGENCE = 6)

/atom/movable/screen/alert/status_effect/buff/alch/intelligencepot
	name = "Intelligence"

/datum/status_effect/buff/alch/constitutionpot/weak
	effectedstats = list(STAT_CONSTITUTION = 1)
	duration = 5 MINUTES

/datum/status_effect/buff/alch/constitutionpot
	id = "Constitution Potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/constitutionpot
	effectedstats = list(STAT_CONSTITUTION = 3)

/datum/status_effect/buff/alch/constitutionpot/concentrated
	id = "Concentrated Constitution Potion"
	effectedstats = list(STAT_CONSTITUTION = 6)

/atom/movable/screen/alert/status_effect/buff/alch/constitutionpot
	name = "Constitution"

/datum/status_effect/buff/alch/endurancepot/weak
	effectedstats = list(STAT_ENDURANCE = 1)
	duration = 5 MINUTES

/datum/status_effect/buff/alch/endurancepot
	id = "Endurance Potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/endurancepot
	effectedstats = list(STAT_ENDURANCE = 3)

/datum/status_effect/buff/alch/endurancepot/concentrated
	id = "Concentrated Endurance Potion"
	effectedstats = list(STAT_ENDURANCE = 6)

/atom/movable/screen/alert/status_effect/buff/alch/endurancepot
	name = "Endurance"

/atom/movable/screen/alert/status_effect/buff/alch/artemisia_luck
	name = "Artemisia Fortune"

/datum/status_effect/buff/alch/artemisia_luck
	id = "artemisia_luck"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/artemisia_luck
	effectedstats = list(STAT_SPEED = 1, STAT_FORTUNE = 1)
	duration = 5 MINUTES

/datum/status_effect/buff/alch/speedpot
	id = "Speed Potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/speedpot
	effectedstats = list(STAT_SPEED = 3)

/datum/status_effect/buff/alch/speedpot/concentrated
	id = "Concentrated Speed Potion"
	effectedstats = list(STAT_SPEED = 6)


/atom/movable/screen/alert/status_effect/buff/alch/speedpot
	name = "Speed"

/datum/status_effect/buff/alch/fortunepot
	id = "Fortune Potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	effectedstats = list(STAT_FORTUNE = 3)

/datum/status_effect/buff/alch/fortunepot/concentrated
	id = "Concentrated Fortune Potion"
	effectedstats = list(STAT_FORTUNE = 6)


/atom/movable/screen/alert/status_effect/buff/alch/fortunepot
	name = "Fortune"

