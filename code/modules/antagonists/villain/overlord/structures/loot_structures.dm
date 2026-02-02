/obj/structure/lootable_structure/stockpile
	component_on_init = FALSE

	max_spawns = 10000
	// Resource costs for generating loot
	var/list/resource_costs = list()
	// Reference to the stockpile datum
	var/datum/stockpile/linked_stockpile
	// Whether to check for any resources or exact amounts
	var/require_exact_resources = TRUE
	var/cooldown_time = 1 MINUTES
	var/enable_cooldown = TRUE

/obj/structure/lootable_structure/stockpile/proc/apply_component()
	if(spawned_table && linked_stockpile)
		AddComponent(/datum/component/stockpile_loot_spawner, spawned_table, max_spawns, spawns_per_person, TRUE, interaction_time, interacting_text, linked_stockpile, resource_costs, require_exact_resources, null, cooldown_time, enable_cooldown)


/obj/structure/lootable_structure/stockpile/CanLoot(mob/living/looter)
	. = ..()
	if(!.)
		return FALSE

	if(!linked_stockpile)
		return FALSE

	// Check if stockpile has required resources
	if(require_exact_resources)
		return linked_stockpile.has_resources(resource_costs)
	else
		return linked_stockpile.has_any_resources(resource_costs)

// Specific stockpile lootable structures
/obj/structure/lootable_structure/stockpile/fish_barrel
	name = "fish stockpile barrel"
	icon_state = "fish_barrel_full"
	empty_icon_state = "fish_barrel_empty"
	spawned_table = /datum/loot_table/fish_barrel
	resource_costs = list(MAT_MEAT = 1) // Cost 1 meat per loot
	spawns_per_person = 1

/obj/structure/lootable_structure/stockpile/grain_barrel
	name = "grain stockpile barrel"
	icon_state = "grain_barrel_full"
	empty_icon_state = "grain_barrel_empty"
	spawned_table = /datum/loot_table/grain_barrel
	resource_costs = list(MAT_GRAIN = 1) // Cost 1 grain per loot
	spawns_per_person = 1

/obj/structure/lootable_structure/stockpile/powder_sack
	name = "powder stockpile sack"
	icon_state = "flour_sack_full"
	empty_icon_state = "flour_sack_empty"
	spawned_table = /datum/loot_table/powder_sack
	resource_costs = list(MAT_GRAIN = 2) // Cost 2 grain per loot (processed)
	spawns_per_person = 1

/obj/structure/lootable_structure/stockpile/mining_cache
	name = "mining stockpile cache"
	icon_state = "ore_sack_full"
	empty_icon_state = "ore_sack_empty"
	spawned_table = /datum/loot_table/mining_cache
	resource_costs = list(MAT_ORE = 1, MAT_STONE = 1) // Cost ore and stone
	spawns_per_person = 1
