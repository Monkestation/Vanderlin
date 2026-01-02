/datum/round_event_control/hostile_animal_migration
	name = "Hostile Animal Migration"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/animal_migration/hostile
	weight = 5
	max_occurrences = 8
	min_players = 0
	earliest_start = 10 MINUTES

	tags = list(
		TAG_NATURE,
		TAG_CURSE,
		TAG_COMBAT,
	)

/datum/round_event/animal_migration/hostile
	animals = list(
		/mob/living/simple_animal/hostile/retaliate/wolf,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/mob/living/simple_animal/hostile/retaliate/bigrat,
		/mob/living/simple_animal/hostile/retaliate/mole,
		/mob/living/simple_animal/hostile/retaliate/bogbug,
	)
