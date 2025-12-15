/datum/objective/bandit
	name = "bandit"
	explanation_text = "Feed valuables to the idol."

/datum/objective/bandit/check_completion()
	if(SSmapping.retainer.bandit_contribute >= SSmapping.retainer.bandit_goal)
		return TRUE

/datum/objective/bandit/update_explanation_text()
	..()
	explanation_text = "Feed [SSmapping.retainer.bandit_goal] mammon to an idol of greed."


/datum/objective/delf
	name = "delf"
	explanation_text = "Feed Ears to the mother."

/datum/objective/delf/check_completion()
	if(SSmapping.retainer.delf_ears >= SSmapping.retainer.delf_goal)
		return TRUE

/datum/objective/delf/update_explanation_text()
	..()
	explanation_text = "Feed [SSmapping.retainer.delf_goal] EARS to the mother."


/datum/objective/rt_maniac
	name = "slaying"
	explanation_text = "Mark pieces of flesh and leave them to be discovered. Have at least 4 different people witness your crimes."
	martyr_compatible = 0
	triumph_count = 10
	var/people_seen[0]

/datum/objective/rt_maniac/check_completion()
	if(people_seen.len >= 4)
		return TRUE

/// Vamp VS. Wolves, be the last faction standing
/datum/objective/dominate
	name = "dominate"
	triumph_count = 5
	var/faction_ident

/datum/objective/dominate/check_completion()
	return (vampire_werewolf() == faction_ident)

/datum/objective/dominate/vampire
	explanation_text = "Purge this land of all elder werevolves."
	faction_ident = "vampire"

/datum/objective/dominate/werewolf
	explanation_text = "Purge this land of all vampire lords."
	faction_ident = "werewolf"

/datum/objective/werewolf/spread
	name = "spread"
	explanation_text = "Have 6 lesser werevolfs."
	triumph_count = 5

/datum/objective/werewolf/spread/check_completion()
	if(length(SSmapping.retainer.werewolves) >= 6)
		return TRUE

/datum/objective/werewolf/infiltrate/one
	name = "infiltrate1"
	explanation_text = "Infect a member of the Church as my spawn."
	triumph_count = 5

/datum/objective/werewolf/infiltrate/one/check_completion()
	var/list/churchjobs = list("Priest", "Priestess", "Cleric", "Acolyte", "Templar", "Churchling", "Crusader", "Inquisitor")
	for(var/datum/mind/V in SSmapping.retainer.werewolves)
		if(V.current.job in churchjobs)
			return TRUE

/datum/objective/werewolf/infiltrate/two
	name = "infiltrate2"
	explanation_text = "Infect a member of the Nobility."
	triumph_count = 5

/datum/objective/werewolf/infiltrate/two/check_completion()
	var/list/noblejobs = list("Monarch", "Consort", "Prince", "Captain", "Hand", "Steward")
	for(var/datum/mind/V in SSmapping.retainer.werewolves)
		if(V.current.job in noblejobs)
			return TRUE

/datum/objective/werewolf/survive
	name = "survive"
	explanation_text = "My lycanthropia won't allow me to die, I mustn't die."
	triumph_count = 3

/datum/objective/werewolf/survive/check_completion()
	if(considered_alive(owner))
		return TRUE
