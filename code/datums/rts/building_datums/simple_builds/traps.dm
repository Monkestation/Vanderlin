/datum/building_datum/simple/spike
	name = "Spike Trap"
	created_atom = /obj/structure/trap/spike

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/bomb
	name = "Bomb Trap"
	created_atom = /obj/structure/trap/bomb

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/saw
	name = "Sawblade Trap"
	created_atom = /obj/structure/trap/saw_blades

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/wall_arrow
	name = "Arrow Trap"
	created_atom = /obj/structure/trap/wall_projectile

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/wall_fire
	name = "Fireball Trap"
	created_atom = /obj/structure/trap/wall_projectile/fireball

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/chill
	name = "Frost Trap"
	created_atom = /obj/structure/trap/chill

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/poison
	name = "Poison Trap"
	created_atom = /obj/structure/trap/poison

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/flame
	name = "Firejet Trap"
	created_atom = /obj/structure/trap/fire

	resource_cost = list(
		MAT_INGOT = 5
	)

/datum/building_datum/simple/spawner
	name = "Rat Spawner"
	created_atom = /obj/structure/spawner/wait

	resource_cost = list(
		MAT_GEM = 10,
		MAT_STONE = 3,
	)

/datum/building_datum/simple/spawner/after_construction(obj/structure/spawner/wait/spawner)
	. = ..()
	spawner.faction |= "overlord"
	spawner.set_spawner()

/datum/building_datum/simple/spawner/goblin
	name = "Goblin Spawner"
	created_atom = /obj/structure/spawner/wait/goblin

/datum/building_datum/simple/spawner/skeleton
	name = "Skeleton Spawner"
	created_atom = /obj/structure/spawner/wait/skeleton
