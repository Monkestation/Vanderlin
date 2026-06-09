/datum/quest/objective
	quest_type = QUEST_OBJECTIVE
	quest_difficulty = QUEST_DIFFICULTY_EASY
	minimum_payout = QUEST_REWARD_EASY_LOW
	maximum_payout = QUEST_REWARD_EASY_HIGH

/datum/quest/objective/on_claim(mob/user)
	..()
	register_signals(user)

/datum/quest/objective/Destroy()
	var/mob/receiver = quest_receiver_reference?.resolve()
	if(receiver)
		unregister_signals(receiver)
	return ..()

/// Register signals on the claimant
/datum/quest/objective/proc/register_signals(mob/user)
	return

/// Unregister signals on the claimant
/datum/quest/objective/proc/unregister_signals(mob/user)
	return
