/obj/item/reagent_containers/glass/bottle/waterskin
	name = "waterskin"
	desc = "A leather waterskin."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "waterskin"
	fill_icon_state = ""
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10)
	fill_icon_thresholds = null
	volume = 60
	dropshrink = 0.5
	sellprice = 50
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	obj_flags = CAN_BE_HIT
	reagent_flags = TRANSFERABLE | AMOUNT_VISIBLE
	w_class =  WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	dyeable = TRUE
	grid_width = 32
	grid_height = 64
	can_label_container = FALSE
	item_weight = 732 GRAMS // I am getting a ton of conflicting information in this tbh
	fancy = TRUE

/obj/item/reagent_containers/glass/bottle/waterskin/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/glass/bottle/waterskin/update_overlays()
	. = ..()
	if(closed)
		. += "[icon_state]_corked"
	else
		. += "[icon_state]_uncorked"

/obj/item/reagent_containers/glass/bottle/waterskin/milk // Filled subtype used by the cheesemaker
	list_reagents = list(/datum/reagent/consumable/milk = 64)

/obj/item/reagent_containers/glass/bottle/waterskin/purifier
	name = "purifying waterskin"
	desc = "Bronze tubes spiral about from the mouth of this waterskin in complex, dizzying patterns."
	icon_state = "water-purifier"
	item_weight = 1.34 KILOGRAMS
	var/filtered_reagents = list(/datum/reagent/water/gross) // List of liquids it turns into drinkable water

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/Initialize()
	. = ..()
	filtered_reagents = typecacheof(filtered_reagents)

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/on_reagent_change(changetype)
	. = ..()
	cleanwater()

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/proc/cleanwater()
	// If there is dirty water inside the device, clean it!
	var/cleaned = FALSE
	for(var/datum/reagent/R in reagents.reagent_list)
		if(!is_type_in_typecache(R.type, filtered_reagents))
			continue
		var/amt2clean = reagents.get_reagent_amount(R.type)
		reagents.remove_reagent(R.type, amt2clean)
		reagents.add_reagent(/datum/reagent/water, amt2clean)
		cleaned = TRUE
	if(!cleaned)
		return
	playsound(src, 'sound/items/waterfilter.ogg', 40, TRUE)
	audible_message(span_hear("I hear whizzing clockwork and gurgling water within [src]."), hearing_distance = COMBAT_MESSAGE_RANGE)
	if (prob(25))
		var/obj/smoke = new /obj/effect/temp_visual/small_smoke(get_turf(src))
		smoke.layer = ABOVE_MOB_LAYER
		visible_message(span_notice("[src] sputters and spews a cloud of steam!"))
