/datum/repeatable_crafting_recipe/ammo
	abstract_type = /datum/repeatable_crafting_recipe/ammo
	category = "Ammunition"
	subtypes_allowed = TRUE
	craftdiff = 0
	crafting_message = "starts shaping ammunition"
	skillcraft = /datum/attribute/skill/combat/firearms
	minimum_skill_level = 1
	reward_experience = FALSE //stops people from farming xp

/datum/repeatable_crafting_recipe/ammo/shardshot
	name = "shard pellet"
	requirements = list(
		/obj/item/natural/glass/shard = 2,
	)
	attacked_atom = /obj/item/natural/glass/shard
	starting_atom  = /obj/item/natural/glass/shard
	output = /obj/item/ammo_casing/caseless/pelletshot/glass
	craftdiff = 1

/datum/repeatable_crafting_recipe/ammo/saltshot
	name = "salt pellet"
	requirements = list(
		/obj/item/reagent_containers/powder/salt = 2,
	)
	attacked_atom = /obj/item/reagent_containers/powder/salt
	starting_atom  = /obj/item/reagent_containers/powder/salt
	output = /obj/item/ammo_casing/caseless/pelletshot/salt
	craftdiff = 1
