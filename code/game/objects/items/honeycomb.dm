
/obj/item/reagent_containers/food/snacks/spiderhoney
	name = "honeycomb"
	desc = ""
	icon_state = "honey"
	dropshrink = 0.8
	possible_transfer_amounts = list()
	spillable = FALSE
	volume = 10
	amount_per_transfer_from_this = 0
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/consumable/nutriment = SNACK_DECENT)
	grind_results = list()
	tastes = list("sweetness" = 1)
	var/honey_color

/obj/item/reagent_containers/food/snacks/spiderhoney/Initialize()
	. = ..()
	pixel_x = base_pixel_x + rand(8,-8)
	pixel_y = base_pixel_y + rand(8,-8)

/obj/item/reagent_containers/food/snacks/spiderhoney/proc/set_reagent(reagent)
	var/datum/reagent/R = GLOB.chemical_reagents_list[reagent]
	if(istype(R))
		name = "honeycomb ([R.name])"
		reagents.add_reagent(R.type,5)

/obj/item/reagent_containers/food/snacks/spiderhoney/honey
	name = "honey"
	icon_state = "honeycomb"
	tastes = list("sweetness" = 1)

/obj/item/reagent_containers/food/snacks/spiderhoney/honey/mad
	name = "mad honey"
	desc = "Dark green honey tainted by the strange plants of the bog, yet often sought by Dendorite Melissae."
	icon_state = "honey_green"
	volume = 20
	tastes = list("earthy sweetness" = 1, "something spicy" = 1)
	list_reagents = list(/datum/reagent/consumable/honey = 4, /datum/reagent/consumable/nutriment = 1, /datum/reagent/druqks = 10, /datum/reagent/toxin = 5)

/obj/item/reagent_containers/food/snacks/spiderhoney/honey/poppy
	name = "rouge honey"
	desc = "A rich red honey, still used in traditional medicine and prized by the faithful of Pestra."
	icon_state = "honey_red"
	volume = 20
	tastes = list("numbing sweetness" = 1, "a flash of white" = 1)
	list_reagents = list(/datum/reagent/consumable/honey = 4, /datum/reagent/consumable/nutriment = 1, /datum/reagent/ozium = 10, /datum/reagent/medicine/herbal/herbalist_panacea = 5)

/obj/item/reagent_containers/food/snacks/spiderhoney/honey/toxic
	name = "honey"
	desc = ""
	icon_state = "honeycomb"
	tastes = list("bitterness" = 1)
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/berrypoison = 5)

/obj/item/reagent_containers/food/snacks/spiderhoney/honey/luminescent
	name = "moon honey"
	desc = "Strange blue honey, softly glowing with all the promise and danger of Noc's starborne knowledge."
	icon_state = "honey_glowing"
	volume = 20
	tastes = list("complex sweetness" = 1, "sharp floral tones" = 1)
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/consumable/nutriment = 3, /datum/reagent/toxin/manabloom_juice = 2, /datum/reagent/medicine/manapot = 10)
	light_system = MOVABLE_LIGHT
	light_outer_range = 2
	light_power = 1
	light_color = "#CCFF99"

/obj/item/reagent_containers/food/snacks/spiderhoney/honey/wild
	name = "wild honey"
	desc = "Sweet wild honey. It has a more complex flavor than regular honey."
	icon_state = "honey_wild"
	honey_color = "#6d4633"
	list_reagents = list(/datum/reagent/consumable/honey = 7, /datum/reagent/consumable/nutriment = 3)
