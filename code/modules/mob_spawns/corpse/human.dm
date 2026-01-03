/obj/effect/mob_spawn/corpse/human
	name = "human corpse spawner"
	icon_state = "corpsehuman"
	mob_type = /mob/living/carbon/human
	mob_species = /datum/species/human/northern

/obj/effect/mob_spawn/corpse/half_elf
	mob_species = /datum/species/human/halfelf

/obj/effect/mob_spawn/corpse/half_drow
	mob_species = /datum/species/human/halfdrow

/obj/effect/mob_spawn/corpse/human/elf_wood
	mob_species = /datum/species/elf/snow

/obj/effect/mob_spawn/corpse/human/elf_dark
	mob_species = /datum/species/elf/dark

/obj/effect/mob_spawn/corpse/random
	name = "randomised species corpse spawner"

/obj/effect/mob_spawn/corpse/random/special(mob/living/carbon/human/spawned)
	. = ..()
	mob_species = GLOB.species_list[pick(get_selectable_species())]

/obj/effect/mob_spawn/corpse/random/pilgrim
	name = "pilgrim corpse"

/obj/effect/mob_spawn/corpse/random/pilgrim/special(mob/living/spawned_mob)
	. = ..()
	equipment_job = pick(subtypesof(/datum/job/advclass/pilgrim) - subtypesof(/datum/job/advclass/pilgrim/rare))

