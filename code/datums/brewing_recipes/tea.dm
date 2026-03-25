/datum/brewing_recipe/golden_calendula_tea
	name = "Golden Calendula Tea"
	reagent_to_brew = /datum/reagent/consumable/golden_calendula_tea
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/alch/herb/calendula = 1, /obj/item/alch/herb/mentha = 1, /obj/item/reagent_containers/food/snacks/spiderhoney = 1)
	brewed_amount = 3
	brew_time = 2 MINUTES
	sell_value = 40
	heat_required = 320
	brewing_skill = /datum/attribute/skill/craft/cooking/fine_cuisine

/datum/brewing_recipe/soothing_valerian_tea
	name = "Soothing Valerian Tea"
	reagent_to_brew = /datum/reagent/consumable/soothing_valerian_tea
	needed_reagents = list(/datum/reagent/water = 100)
	needed_items = list(/obj/item/alch/herb/valeriana = 1, /obj/item/alch/herb/hypericum = 1, /obj/item/reagent_containers/food/snacks/spiderhoney = 1)
	brewed_amount = 3
	brew_time = 2 MINUTES
	sell_value = 35
	heat_required = 310
	brewing_skill = /datum/attribute/skill/craft/cooking/fine_cuisine
