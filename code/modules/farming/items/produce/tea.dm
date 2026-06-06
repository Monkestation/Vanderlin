/obj/item/reagent_containers/food/snacks/produce/tea
	name = "tea leaves"
	desc = "Tea leaves plucked from the plant. It is still fresh and needs to be dried before use."
	icon_state = "tea"
	seed = /obj/item/neuFarm/seed/tea
	tastes = list("grass" = 1)
	bitesize = 1
	rotprocess = null

/obj/item/reagent_containers/food/snacks/produce/tealeaves_dry
	name = "dried tea leaves"
	desc = "Dried tea leaves. Edible. Seeds can be extracted from them. Needs to be processed in a millstone."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "teadry"
	tastes = list("bitterness" = 1)
	seed = /obj/item/neuFarm/seed/tea
	bitesize = 1
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	mill_result = /obj/item/reagent_containers/food/snacks/produce/tealeaves_ground

/obj/item/reagent_containers/food/snacks/produce/tealeaves_ground
	name = "ground tea leaves"
	desc = "Ground tea leaves that can be used to brew tea"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "teaground"
	tastes = list("bitterness" = 1)
	bitesize = 1
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
