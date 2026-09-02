GLOBAL_LIST_INIT(global_quest_types, init_quest_types())

/proc/init_quest_types()
	. = list(
		QUEST_DIFFICULTY_EASY = list(),
		QUEST_DIFFICULTY_MEDIUM = list(),
		QUEST_DIFFICULTY_HARD = list(),
	)
	for(var/datum/quest/Q as anything in (typesof(/datum/quest) - typesof(/datum/quest/custom) - typesof(/datum/quest/objective)))
		if(initial(Q.quest_difficulty) && !IS_ABSTRACT(Q))
			.[initial(Q.quest_difficulty)] += Q
	return .
