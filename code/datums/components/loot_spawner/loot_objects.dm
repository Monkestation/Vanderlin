/obj/structure/lootable_structure
	anchored = TRUE


	icon = 'icons/obj/structures/lootable_objects.dmi'
	var/empty_icon_state = ""
	var/empty = FALSE

	var/datum/loot_table/spawned_table
	var/max_spawns = 5
	var/spawns_per_person = 1
	//if this is set its what gets displayed when looting this
	var/interacting_text = "starts sifting through"
	var/interaction_time = 2 SECONDS

	var/component_on_init = TRUE

/obj/structure/lootable_structure/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_LOOT_SPAWNER_EMPTY, PROC_REF(update_loot))
	if(spawned_table && component_on_init)
		AddComponent(/datum/component/loot_spawner, spawned_table, max_spawns, spawns_per_person, TRUE, interaction_time, interacting_text)

/obj/structure/lootable_structure/proc/update_loot()
	empty = TRUE
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/lootable_structure/update_icon_state()
	. = ..()
	if(empty)
		icon_state = empty_icon_state

/obj/structure/lootable_structure/fish_barrel
	name = "fish barrel"

	icon_state = "fish_barrel_full"
	empty_icon_state = "fish_barrel_empty"

	spawned_table = /datum/loot_table/fish_barrel
	max_spawns = 4
	spawns_per_person = 1

/obj/structure/lootable_structure/grain_barrel
	name = "grain barrel"

	icon_state = "grain_barrel_full"
	empty_icon_state = "grain_barrel_empty"

	spawned_table = /datum/loot_table/grain_barrel
	max_spawns = 4
	spawns_per_person = 1

/obj/structure/lootable_structure/powder_sack
	name = "powder sack"

	icon_state = "flour_sack_full"
	empty_icon_state = "flour_sack_empty"

	spawned_table = /datum/loot_table/powder_sack
	max_spawns = 4
	spawns_per_person = 1

/obj/structure/lootable_structure/mining_cache
	name = "mining sack"

	icon_state = "ore_sack_full"
	empty_icon_state = "ore_sack_empty"

	spawned_table = /datum/loot_table/mining_cache
	max_spawns = 4
	spawns_per_person = 1
