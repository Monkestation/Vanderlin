///Unit test that spawns all mobs that can be spawned by golden slimes
/datum/unit_test/spawn_mobs/Run()
	for(var/mob/living/simple_animal/animal as anything in subtypesof(/mob/living/simple_animal))
		if(IS_ABSTRACT(animal))
			continue
		if(initial(animal.gold_core_spawnable) == HOSTILE_SPAWN || initial(animal.gold_core_spawnable) == FRIENDLY_SPAWN)
			allocate(animal)
