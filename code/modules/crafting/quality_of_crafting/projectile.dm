/datum/repeatable_crafting_recipe/projectile
	abstract_type = /datum/repeatable_crafting_recipe/projectile
	category = "Projectiles"
	skillcraft = /datum/skill/craft/crafting

/datum/repeatable_crafting_recipe/projectile/arrow
	name = "stone arrow"
	requirements = list(
		/obj/item/grown/log/tree/stick= 1,
		/obj/item/natural/stone = 1,
	)
	starting_atom = /obj/item/grown/log/tree/stick
	attacked_atom = /obj/item/natural/stone
	output = /obj/item/ammo_casing/caseless/arrow/stone
	output_amount = 2
	craft_time = 1 SECONDS

/datum/repeatable_crafting_recipe/projectile/pyro_arrow
	name = "pyroclastic arrow"
	requirements = list(
		/obj/item/ammo_casing/caseless/arrow = 1,
		/obj/item/reagent_containers/food/snacks/produce/fyritius = 1,
	)
	blacklisted_paths = list(/obj/item/ammo_casing/caseless/arrow/pyro)
	attacked_atom = /obj/item/ammo_casing/caseless/arrow
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fyritius
	output = /obj/item/ammo_casing/caseless/arrow/pyro
	craftdiff = 1
	skillcraft = /datum/skill/craft/bombs
	craft_time = 1 SECONDS

/datum/repeatable_crafting_recipe/projectile/pyro_bolt
	name = "pyroclastic bolt"
	requirements = list(
		/obj/item/ammo_casing/caseless/bolt = 1,
		/obj/item/reagent_containers/food/snacks/produce/fyritius = 1,
	)
	blacklisted_paths = list(/obj/item/ammo_casing/caseless/bolt/pyro)
	attacked_atom = /obj/item/ammo_casing/caseless/bolt
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fyritius
	output = /obj/item/ammo_casing/caseless/bolt/pyro
	craftdiff = 1
	skillcraft = /datum/skill/craft/bombs
	craft_time = 1 SECONDS

/datum/repeatable_crafting_recipe/projectile/water_arrow
	name = "water arrow"
	requirements = list(
		/obj/item/ammo_casing/caseless/arrow = 3,
		/obj/item/alch/waterdust = 1,
	)
	blacklisted_paths = list(/obj/item/ammo_casing/caseless/arrow/water)
	attacked_atom = /obj/item/ammo_casing/caseless/arrow
	starting_atom = /obj/item/alch/waterdust
	output = /obj/item/ammo_casing/caseless/arrow/water
	output_amount = 3
	craftdiff = 2
	skillcraft = /datum/skill/craft/alchemy
	craft_time = 4 SECONDS

/datum/repeatable_crafting_recipe/projectile/water_bolt
	name = "water bolt"
	requirements = list(
		/obj/item/ammo_casing/caseless/bolt = 3,
		/obj/item/alch/waterdust = 1,
	)
	blacklisted_paths = list(/obj/item/ammo_casing/caseless/bolt/water)
	attacked_atom = /obj/item/ammo_casing/caseless/bolt
	starting_atom = /obj/item/alch/waterdust
	output = /obj/item/ammo_casing/caseless/bolt/water
	output_amount = 3
	craftdiff = 2
	skillcraft = /datum/skill/craft/alchemy
	craft_time = 4 SECONDS

/datum/repeatable_crafting_recipe/projectile/vial_arrow
	abstract_type = /datum/repeatable_crafting_recipe/projectile/vial_arrow
	requirements = list(
		/obj/item/ammo_casing/caseless/arrow = 1,
		/obj/item/reagent_containers/glass/alchemical = 1,
		/obj/item/natural/fibers = 1,
	)
	blacklisted_paths = list(/obj/item/ammo_casing/caseless/arrow/vial)
	attacked_atom = /obj/item/ammo_casing/caseless/arrow
	starting_atom = /obj/item/natural/fibers // Vials get a little bit quirky
	skillcraft = /datum/skill/craft/crafting

/datum/repeatable_crafting_recipe/projectile/vial_arrow/water
	name = "vial arrow (water)"
	reagent_requirements = list(
		/datum/reagent/water = 15,
	)
	output = /obj/item/ammo_casing/caseless/arrow/vial/water
