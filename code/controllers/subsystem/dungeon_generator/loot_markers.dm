/obj/effect/dungeon_loot_spawner
	name = "dungeon loot spawner"
	icon = 'icons/obj/structures_spawners.dmi'
	icon_state = "lootblank"

	invisibility = INVISIBILITY_ABSTRACT

	/// Total item value this spawner will hold before it goes inactive
	var/max_value = LOOT_VALUE_LOW * 1.5
	/// Only pool items with a value in this range can come from this spawner
	var/min_item_value = 0
	var/max_item_value = 5
	/// Relative chance of being picked while the budget is handed out (before depth scaling)
	var/spawn_weight = 1
	/// Value of the items this spawner has produced so far
	var/used_value = 0
	/// Depth (rooms from the start) of the room this spawner sits in. Set by the generator.
	var/depth = 0
	///total items we can spawn
	var/total_items = 1
	///the amount of items we've generated
	var/used_items = 0

/obj/effect/dungeon_loot_spawner/Initialize(mapload)
	. = ..()
	SSdungeon_generator.loot_spawners |= src

/obj/effect/dungeon_loot_spawner/Destroy()
	SSdungeon_generator?.loot_spawners -= src
	return ..()

/obj/effect/dungeon_loot_spawner/proc/get_remaining_value()
	return max_value - used_value

/obj/effect/dungeon_loot_spawner/proc/can_accept_loot()
	if(used_items == total_items)
		return FALSE
	return get_remaining_value() > 0

/// Picks a pool item that fits this spawner's value range and the given cap. Returns a path or null.
/obj/effect/dungeon_loot_spawner/proc/pick_loot(value_cap)
	var/upper = min(max_item_value, value_cap)
	var/list/eligible = list()
	for(var/item_path in GLOB.dungeon_loot_pool)
		var/value = GLOB.dungeon_loot_pool[item_path]
		if(value < min_item_value || value > upper)
			continue
		eligible += item_path
	if(!length(eligible))
		return null
	return pick(eligible)

/// Spawns the item here and returns its value.
/obj/effect/dungeon_loot_spawner/proc/spawn_loot(item_path)
	var/value = GLOB.dungeon_loot_pool[item_path]
	new item_path(get_turf(src))
	used_value += value
	used_items++
	return value

/obj/effect/dungeon_loot_spawner/low
	icon_state = "lootlow"
	name = "low value loot spawner"
	min_item_value = LOOT_VALUE_LOW * 0.5
	max_item_value = LOOT_VALUE_LOW * 1.5
	spawn_weight = 3

/obj/effect/dungeon_loot_spawner/low/chest
	max_value = parent_type::max_value * 5
	total_items = 5

/obj/effect/dungeon_loot_spawner/medium
	icon_state = "lootmed"
	name = "medium value loot spawner"
	max_value = LOOT_VALUE_MEDIUM * 1.5
	min_item_value = LOOT_VALUE_MEDIUM
	max_item_value = LOOT_VALUE_MEDIUM * 1.5
	spawn_weight = 2

/obj/effect/dungeon_loot_spawner/medium/chest
	max_value = parent_type::max_value * 5
	total_items = 5

/obj/effect/dungeon_loot_spawner/high
	icon_state = "loothigh"
	name = "high value loot spawner"
	max_value = LOOT_VALUE_HIGH * 1.5
	min_item_value = LOOT_VALUE_HIGH
	max_item_value = LOOT_VALUE_HIGH * 1.5
	spawn_weight = 1

/obj/effect/dungeon_loot_spawner/high/chest
	max_value = parent_type::max_value * 5
	total_items = 5

/client/proc/regenerate_dungeon_loot()
	set category = "Debug"
	set name = "Regenerate Dungeon Loot"

	if(!check_rights(R_DEBUG))
		return
	var/spent = SSdungeon_generator.regenerate_loot()
	message_admins("[key_name_admin(usr)] regenerated dungeon loot ([spent]/[SSdungeon_generator.loot_budget] value placed).")
