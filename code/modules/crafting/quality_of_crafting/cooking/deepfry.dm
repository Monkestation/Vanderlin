/datum/repeatable_crafting_recipe/cooking/deepfry
	category = "Deep Frying"
	abstract_type = /datum/repeatable_crafting_recipe/cooking/deepfry
	required_table = TRUE
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	starting_atom = /obj/item/reagent_containers/food/snacks/toastcrumbs
	skillcraft = /datum/attribute/skill/craft/cooking/preparation
	crafting_message = "coats with toastcrumbs"

/datum/repeatable_crafting_recipe/cooking/deepfry/cutlet
	name = "Crumb Coated Bird Meat"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/toastcrumbs = 1,
		/obj/item/reagent_containers/food/snacks/meat/poultry/cutlet/egg_washed = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/poultry/cutlet/egg_washed
	output = /obj/item/reagent_containers/food/snacks/meat/poultry/cutlet/coated


