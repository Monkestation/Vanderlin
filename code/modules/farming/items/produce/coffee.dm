/obj/item/reagent_containers/food/snacks/produce/coffee
	name = "coffee cherry"
	desc = "A small sweet, small red fruit that contains coffee bean(s) inside. Can be grounded in a millstone for coffee beans."
	icon_state = "coffee"
	seed = /obj/item/neuFarm/seed/coffee
	tastes = list("hibicus sweetness" = 1)
	bitesize = 1
	mill_result = /obj/item/reagent_containers/food/snacks/produce/coffeebeans
	rotprocess = null

/obj/item/reagent_containers/food/snacks/produce/coffeebeans
	name = "coffee beans"
	desc = "Freshly extracted coffee beans, with a hard texture. Should be roasted first."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "coffeebeans"
	tastes = list("unpleasant bitterness" = 1)
	bitesize = 1
	seed = /obj/item/neuFarm/seed/coffee
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/produce/coffeebeansroasted
	name = "roasted coffee beans"
	desc = "Roasted coffee beans, with a much deeper flavor. Can be used to brew coffee."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "coffeebeans_roasted"
	tastes = list("rich caramel smoothness" = 1)
	bitesize = 1
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
