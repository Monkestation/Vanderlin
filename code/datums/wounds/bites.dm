/datum/wound/bite
	name = "bite"
	bleed_rate = 0
	sewn_bleed_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = null
	whp = 30
	woundpain = 6
	sew_threshold = 50
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	passive_healing = 0.5
	werewolf_infection_probability = 15
	associated_bclasses = list(BCLASS_BITE)

/datum/wound/bite/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(affected.status == BODYPART_ROBOTIC)
		return FALSE

/datum/wound/bite/small
	name = "nip"
	whp = 15
	woundpain = 3
	werewolf_infection_probability = 10

/datum/wound/bite/large
	name = "gnarly bite"
	whp = 40
	sewn_whp = 15
	bleed_rate = 2
	sewn_bleed_rate = 0.2
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.5
	sewn_clotting_threshold = 0.25
	woundpain = 12
	sewn_woundpain = 5
	can_sew = TRUE
	can_cauterize = TRUE
	passive_healing = 0
	werewolf_infection_probability = 20

// Bite dynamic wounds
// Vaguely: Hella painful. Hella bleedy. Armor is very effective. Similar to lashing in this way.
/datum/wound/dynamic/bite
	name = "bite"
	bleed_rate = 0
	sewn_bleed_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = null
	whp = 30
	woundpain = 6
	sew_threshold = 50
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	passive_healing = 0.5
	werewolf_infection_probability = 10
	associated_bclasses = list(BCLASS_BITE)

	severity_names = list(
		"shallow" = 3,
		"deep" = 8,
		"gnarly" = 12,
		"lethal" = 15,
		"impossible" = 20,
	)
	upgrade_bleed_rate = 0.2
	upgrade_bleed_clamp = 1
	upgrade_bleed_clamp_armor = 3
	upgrade_whp = 0.1
	upgrade_sew_threshold = 1
	upgrade_pain = 1
	protected_bleed_clamp = 5

	var/upgrade_infection = 0.05

/datum/wound/dynamic/bite/upgrade(bclass, damage)
	. = ..()
	if(!.)
		return
	werewolf_infection_probability += damage * upgrade_infection

/datum/wound/dynamic/bite/downgrade(multiplier)
	. = ..()
	werewolf_infection_probability = max(werewolf_infection_probability - (werewolf_infection_probability * multiplier), initial(werewolf_infection_probability))
