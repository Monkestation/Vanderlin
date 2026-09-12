/atom/movable/screen/alert/status_effect/buff/adrenaline_rush
	name = "Adrenaline Rush"
	desc = "The gambit worked! I can do anything! My heart races, the throb of my wounds wavers."
	icon_state = "adrrush"

/datum/status_effect/buff/adrenaline_rush
	id = "adrrush"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/buff/adrenaline_rush
	duration = 18 SECONDS
	examine_text = "SUBJECTPRONOUN is amped up!"
	effectedstats = list(STAT_ENDURANCE = 1)
	var/blood_restore = 30

/datum/status_effect/buff/adrenaline_rush/on_apply()
	. = ..()
	var/mob/living/carbon/human/human = owner
	if(istype(human))
		human.blood_volume = min((human.blood_volume + blood_restore), BLOOD_VOLUME_NORMAL)
		human.physiology.pain_mod *= 0.5

/datum/status_effect/buff/adrenaline_rush/on_remove()
	. = ..()
	clear_adrenaline_rush()

/datum/status_effect/buff/adrenaline_rush/be_replaced()
	clear_adrenaline_rush()
	return ..()

/datum/status_effect/buff/adrenaline_rush/proc/clear_adrenaline_rush()
	var/mob/living/carbon/human/human = owner
	if(istype(human))
		human.physiology.pain_mod *= 2

/datum/status_effect/buff/adrenaline_rush/ranged
	effectedstats = list(STAT_SPEED = 2)

/datum/status_effect/buff/adrenaline_rush/melee
	effectedstats = list(STAT_ENDURANCE = 1, STAT_CONSTITUTION = 1)

/datum/status_effect/buff/adrenaline_rush/graggar
	effectedstats = list(STAT_CONSTITUTION = 3)
