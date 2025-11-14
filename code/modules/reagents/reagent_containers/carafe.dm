/obj/item/reagent_containers/glass/carafe
	name = "glass carafe"
	desc = "A slightly grimey glass container with a flared lip, most often used for serving water and wine"
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "glass_carafe"
	w_class = WEIGHT_CLASS_SMALL
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10)
	volume = 100 // Four full cups
	fill_icon_thresholds = list(0, 25, 50, 75, 100)
	dropshrink = 0.7
	obj_flags = CAN_BE_HIT
	spillable = TRUE
	reagent_flags = OPENCONTAINER
	w_class = WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	sellprice = 5
	gripped_intents = list(INTENT_POUR)

/obj/item/reagent_containers/glass/carafe/silver
	name = "silver carafe"
	desc = "A shining silver container with a flared lip, most often used for serving water and wine"
	icon_state = "silver_carafe"
	fill_icon_thresholds = null
	dropshrink = 0.8
	sellprice = 45
	last_used = 0

/obj/item/reagent_containers/glass/carafe/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/reagent_containers/glass/carafe/silver/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.dna && H.dna.species)
			if(istype(H.dna.species, /datum/species/werewolf))
				return FALSE
	if(M.mind && M.mind.has_antag_datum(/datum/antagonist/vampire))
		return FALSE

/obj/item/reagent_containers/glass/carafe/gold
	name = "golden carafe"
	desc = "An opulent golden container with a flared lip, most often used for serving water and wine"
	icon_state = "gold_carafe"
	fill_icon_thresholds = null
	dropshrink = 0.8
	sellprice = 65


/* Teapots */

/obj/item/reagent_containers/glass/carafe/teapot
	name = "fancy teapot"
	desc = "A fancy tea pot made out of ceramic. Used to hold tea."
	icon_state = "teapot_fancy"
	fill_icon_thresholds = null
	volume = 100
	dropshrink = 0.7
	sellprice = 30

	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)


/obj/item/reagent_containers/glass/carafe/teapot/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/teapot)
	AddComponent(/datum/component/container_craft, subtypesof(/datum/container_craft/cooking/tea), TRUE)

//this functionality is off for now, it was from before i refactored but it doesn't really fit in well with the current layout
/*/obj/item/reagent_containers/glass/carafe/teapot/random/Initialize()
	. = ..()
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()
*/

/obj/item/reagent_containers/glass/carafe/teapot/set_material_information()
	. = ..()
	name = "[lowertext(initial(main_material.name))] clay teapot"

/obj/item/reagent_containers/glass/carafe/teapot/gold
	name = "golden teapot"
	desc = "A dainty golden teapot. The perfect item for a noble's tea party."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "teapot_gold"
	fill_icon_thresholds = null
	dropshrink = 1.0
	smeltresult = /obj/item/ingot/gold
	sellprice = 65

/obj/item/reagent_containers/glass/carafe/teapot/silver
	name = "silver teapot"
	desc = "A dainty silver teapot. The perfect item for a noble's tea party."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "teapot_silv"
	fill_icon_thresholds = null
	dropshrink = 1.0
	smeltresult = /obj/item/ingot/silver
	sellprice = 35

/obj/item/reagent_containers/glass/carafe/teapot/jade
	name = "joapstone teapot"
	desc = "A dainty teapot carved out of joapstone."
	icon_state = "teapot_jade"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 60

/obj/item/reagent_containers/glass/carafe/teapot/amber
	name = "petriamber teapot"
	desc = "A dainty teapot carved out of petriamber."
	icon_state = "teapot_amber"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 60

/obj/item/reagent_containers/glass/carafe/teapot/shell
	name = "shell teapot"
	desc = "A dainty teapot carved out of shell."
	icon_state = "teapot_shell"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 20

/obj/item/reagent_containers/glass/carafe/teapot/rose
	name = "rosellusk teapot"
	desc = "A dainty teapot carved out of rosellusk."
	icon_state = "teapot_rose"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 25

/obj/item/reagent_containers/glass/carafe/teapot/opal
	name = "opaloise teapot"
	desc = "A dainty teapot carved out of opaloise."
	icon_state = "teapot_opal"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 90

/obj/item/reagent_containers/glass/carafe/teapot/onyxa
	name = "onyxa teapot"
	desc = "A dainty teapot carved out of onyxa."
	icon_state = "teapot_onyxa"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 40

/obj/item/reagent_containers/glass/carafe/teapot/coral
	name = "aoetal teapot"
	desc = "A dainty teapot carved out of aoetal."
	icon_state = "teapot_coral"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 70

/obj/item/reagent_containers/glass/carafe/teapot/turq
	name = "ceruleabaster teapot"
	desc = "A dainty teapot carved out of ceruleabaster."
	icon_state = "teapot_turq"
	fill_icon_thresholds = null
	dropshrink = 1.0
	sellprice = 85

/obj/item/reagent_containers/glass/carafe/teapot/clay
	name = "clay teapot"
	desc = "A teapot fired from clay."

	icon = 'icons/obj/handmade/teapot.dmi'
	icon_state = "world"

/obj/item/reagent_containers/glass/carafe/decanter
	name = "clay decanter"
	desc = "A decanter fired from clay."
	icon = 'icons/obj/handmade/decanter.dmi'
	icon_state = "world"
	volume = 50
	amount_per_transfer_from_this = 8
	possible_transfer_amounts = list(8)
	can_label_container = FALSE
	spillable = TRUE
	fill_icon_thresholds = null

/obj/item/reagent_containers/glass/carafe/decanter/Initialize()
	. = ..()
	icon_state = "world"

/obj/item/reagent_containers/glass/carafe/decanter/set_material_information()
	. = ..()
	name = "[lowertext(initial(main_material.name))] clay decanter"


/* Spawning full */

/obj/item/reagent_containers/glass/carafe/water
	list_reagents = list(/datum/reagent/water = 100)

/obj/item/reagent_containers/glass/carafe/redwine
	list_reagents = list(/datum/reagent/consumable/ethanol/redwine = 100)

/obj/item/reagent_containers/glass/carafe/silver/redwine
	list_reagents = list(/datum/reagent/consumable/ethanol/redwine = 100)

/obj/item/reagent_containers/glass/carafe/gold/redwine
	list_reagents = list(/datum/reagent/consumable/ethanol/redwine = 100)

/obj/item/reagent_containers/glass/carafe/teapot/tea
	list_reagents = list(/datum/reagent/consumable/tea/compot = 100)
