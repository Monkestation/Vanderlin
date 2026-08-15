/datum/material_trait/silver_bane
	name = "Silver Bane"

/datum/material_trait/silver_bane/proc/touch_bane(mob/living/carbon/human/user)
	var/datum/antagonist/vampire/vamp_datum = user.mind.has_antag_datum(/datum/antagonist/vampire)
	var/datum/antagonist/werewolf/wolf_datum = user.mind.has_antag_datum(/datum/antagonist/werewolf)
	if(!vamp_datum || !wolf_datum)
		return

	if(istype(vamp_datum, /datum/antagonist/vampire/lord))
		var/datum/antagonist/vampire/lord/lord_datum = vamp_datum
		var/resistance = lord_datum.ascension_resistance()
		if(resistance < 1)
			to_chat(user, span_userdanger("I've consumed silver, it is my BANE!"))
			user.Knockdown(10 * (1 - resistance))
			user.Paralyze(10 * (1 - resistance))
		return

	if(wolf_datum?.transformed == TRUE || vamp_datum)
		to_chat(user, span_userdanger("I've consumed silver, it is my BANE!"))
		user.Knockdown(10)
		user.Paralyze(10)
		user.adjustFireLoss(25)
		user.fire_act(1,10)


/datum/material_trait/silver_bane/on_consume(mob/user, amount)
	if(ishuman(user) && user.mind)
		touch_bane(user)

/datum/material_trait/silver_bane/on_life(mob/user)
	if(ishuman(user) && user.mind)
		touch_bane(user)
