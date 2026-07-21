/obj/effect/mob_spawn/corpse/human
	name = "human corpse spawner"
	icon_state = "corpsehuman"
	mob_type = /mob/living/carbon/human
	mob_species = /datum/species/human/northern

CREATE_ALL_SPECIES_SPAWNERS(/obj/effect/mob_spawn/corpse/human)

/obj/effect/mob_spawn/corpse/human/damaged
	brute_damage = 150

CREATE_ALL_SPECIES_SPAWNERS(/obj/effect/mob_spawn/corpse/human/damaged)

/obj/effect/mob_spawn/corpse/human/random
	name = "randomised species corpse spawner"

/obj/effect/mob_spawn/corpse/human/random/special(mob/living/carbon/human/spawned)
	. = ..()
	mob_species = GLOB.species_list[pick(GLOB.roundstart_species)]

/obj/effect/mob_spawn/corpse/human/random/damaged
	brute_damage = 150

/obj/effect/mob_spawn/corpse/human/random/pilgrim
	name = "pilgrim corpse"

/obj/effect/mob_spawn/corpse/human/random/pilgrim/special(mob/living/spawned_mob)
	. = ..()
	equipment_job = pick(subtypesof(/datum/job/advclass/pilgrim) - subtypesof(/datum/job/advclass/pilgrim/rare))
