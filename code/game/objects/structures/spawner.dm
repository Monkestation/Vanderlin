/obj/structure/spawner
	name = "monster nest"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	max_integrity = 500

	move_resist = MOVE_FORCE_EXTREMELY_STRONG
	anchored = TRUE
	density = FALSE

	var/max_mobs = 5
	var/spawn_time = 300 //30 seconds default
	var/mob_types = list(/mob/living/simple_animal/hostile/retaliate/bigrat)
	var/spawn_text = "emerges from"
	var/faction = list("hostile")
	var/spawner_type = /datum/component/spawner
	var/wait = FALSE

/obj/structure/spawner/wait
	wait = TRUE

/obj/structure/spawner/wait/goblin
	mob_types = list(/mob/living/carbon/human/species/goblin/npc/cave, /mob/living/carbon/human/species/goblin/npc/sea, /mob/living/carbon/human/species/goblin/npc/moon, /mob/living/carbon/human/species/goblin/npc/hell)
	max_mobs = 3

/obj/structure/spawner/wait/skeleton
	mob_types = list(/mob/living/carbon/human/species/skeleton/npc/peasant, /mob/living/carbon/human/species/skeleton/npc/warrior)
	max_mobs = 3

/obj/structure/spawner/Initialize()
	. = ..()
	if(!wait)
		AddComponent(spawner_type, mob_types, spawn_time, faction, spawn_text, max_mobs)

/obj/structure/spawner/proc/set_spawner()
	AddComponent(spawner_type, mob_types, spawn_time, faction, spawn_text, max_mobs)

/obj/structure/spawner/attack_animal(mob/living/simple_animal/M)
	if(faction_check(faction, M.faction, FALSE)&&!M.client)
		return
	..()
