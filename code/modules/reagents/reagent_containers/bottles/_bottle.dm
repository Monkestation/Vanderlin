GLOBAL_LIST_INIT(wisdoms, world.file2list("strings/rt/wisdoms.txt"))

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A bottle with a cork."
	icon = 'icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_bottle1"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10)
	volume = 70
	fill_icon_thresholds = list(0, 10, 25, 50, 75, 100)
	dropshrink = 0.8
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	obj_flags = CAN_BE_HIT
	spillable = FALSE
	reagent_flags = TRANSPARENT
	fill_icon_under_override = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	experimental_onhip = TRUE
	can_label_container = TRUE
	label_prefix = "bottle of "
	var/closed = TRUE
	/// Do not change desc when opened or closed
	var/fancy = FALSE
	/// Name to slap on a label, replaces current name
	var/auto_label_name
	/// Auto label description, appended to current desc
	var/auto_label_desc
	///custom icon?
	var/custom_icon = FALSE

/obj/item/reagent_containers/glass/bottle/Initialize()
	if(!custom_icon)
		icon_state = "clear_bottle[rand(1,4)]"
	return ..()

/obj/item/reagent_containers/glass/bottle/apply_initial_label()
	if(!auto_label_name && !auto_label_desc)
		return
	label_container(label_name = auto_label_name, label_desc = auto_label_desc)

/obj/item/reagent_containers/glass/bottle/label_container(mob/user, label_name, label_desc)
	. = ..()
	if(label_desc)
		fancy = TRUE

/obj/item/reagent_containers/glass/bottle/remove_label(mob/user, force)
	. = ..()
	if(desc != initial(desc))
		fancy = initial(fancy)

/obj/item/reagent_containers/glass/bottle/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/paper/scroll))
		if(reagents?.total_volume)
			to_chat(user, span_notice("I cannot put a message in [src] while it is full!"))
			return
		if(closed)
			to_chat(user, span_notice("I cannot put a message in [src] while it is closed!"))
			return
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/paper/scroll/P = I
			var/obj/item/bottlemessage/BM = new
			BM.icon_state = "[icon_state]_message"

			P.forceMove(BM)
			BM.contained = P
			H.put_in_active_hand(BM)
			playsound(src, 'sound/items/scroll_open.ogg', 100, FALSE)
			qdel(src)
		return
	return ..()

/obj/item/reagent_containers/glass/bottle/update_overlays()
	. = ..()
	if(closed)
		. += "[icon_state]cork"

/obj/item/reagent_containers/glass/bottle/attack_self_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	toggle_cork(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/glass/bottle/proc/toggle_cork(mob/user)
	closed = !closed
	user.changeNext_move(CLICK_CD_RAPID)
	if(closed)
		reagent_flags &= ~TRANSFERABLE
		reagents.flags = reagent_flags
		balloon_alert(user, "I press the cork back in.")
		spillable = FALSE
		GLOB.weather_act_upon_list -= src
		if(!fancy)
			desc = "A bottle with a cork."
	else
		reagent_flags |= TRANSFERABLE
		reagents.flags = reagent_flags
		playsound(user.loc,'sound/items/uncork.ogg', 100, TRUE)
		balloon_alert(user, "I thumb off the cork.")
		spillable = TRUE
		GLOB.weather_act_upon_list |= src
		if(!fancy)
			desc = "An open bottle, hopefully a cork is close by."
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = ""
	list_reagents = list(/datum/reagent/toxin = 30)

/obj/item/reagent_containers/glass/bottle/plasma
	name = "purple aetherium bottle"
	desc = ""
	list_reagents = list(/datum/reagent/toxin/plasma = 30)

/obj/item/reagent_containers/glass/bottle/venom
	name = "venom bottle"
	desc = ""
	list_reagents = list(/datum/reagent/toxin/venom = 30)

/obj/item/reagent_containers/glass/bottle/fentanyl
	name = "fentanyl bottle"
	desc = ""
	list_reagents = list(/datum/reagent/toxin/fentanyl = 30)

/obj/item/reagent_containers/glass/bottle/amanitin
	name = "amanitin bottle"
	desc = ""
	list_reagents = list(/datum/reagent/toxin/amanitin = 30)

/obj/item/reagent_containers/glass/bottle/mercury
	name = "mercury bottle"
	list_reagents = list(/datum/reagent/mercury = 30)

/obj/item/reagent_containers/glass/bottle/water
	name = "water bottle"
	list_reagents = list(/datum/reagent/water = 30)

/obj/item/reagent_containers/glass/bottle/ethanol
	name = "ethanol bottle"
	list_reagents = list(/datum/reagent/consumable/ethanol = 30)

/obj/item/reagent_containers/glass/bottle/sugar
	name = "sugar bottle"
	list_reagents = list(/datum/reagent/consumable/sugar = 30)

/obj/item/reagent_containers/glass/bottle/sacid
	name = "sulphuric acid bottle"
	list_reagents = list(/datum/reagent/toxin/acid = 30)

/obj/item/reagent_containers/glass/bottle/welding_fuel
	name = "naphta bottle"
	list_reagents = list(/datum/reagent/fuel = 30)

// message in a bootl

/obj/item/bottlemessage
	name = "message bottle"
	desc = "Inside is a scroll, pop it open and read the ancient wisdoms."
	icon = 'icons/roguetown/items/glass_reagent_container.dmi'
	dropshrink = 0.8
	icon_state = "clear_bottle1"
	w_class = WEIGHT_CLASS_NORMAL
	var/obj/item/paper/contained

/obj/item/bottlemessage/ancient/Initialize()
	. = ..()
	var/obj/item/paper/scroll/pp = new(src)
	contained = pp
	pp.info = pick(GLOB.wisdoms)

/obj/item/bottlemessage/attack_self_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	playsound(user.loc,'sound/items/uncork.ogg', 100, TRUE)
	if(!contained)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/obj/item/reagent_containers/glass/bottle/btle = new
	btle.icon_state = replacetext("[icon_state]","_message","")
	btle.closed = FALSE
	user.dropItemToGround(src, silent=TRUE)
	user.put_in_active_hand(btle)
	contained = null
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// vials
/obj/item/reagent_containers/glass/bottle/vial
	name = "vial"
	desc = "A vial with a cork."
	icon = 'icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "clear_vial1"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 30
	fill_icon_thresholds = list(0, 10, 25, 50, 75, 100)
	dropshrink = 0.8
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_MOUTH
	obj_flags = CAN_BE_HIT
	spillable = FALSE
	closed = TRUE
	reagent_flags = TRANSPARENT
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	label_prefix = "vial of "

/obj/item/reagent_containers/glass/bottle/vial/Initialize()
	. = ..()
	icon_state = "clear_vial1"
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/glass/bottle/vial/attack_self_secondary(mob/user, params)
	closed = !closed
	user.changeNext_move(CLICK_CD_RAPID)
	if(closed)
		reagent_flags &= ~TRANSFERABLE
		reagents.flags = reagent_flags
		desc = "A vial with a cork."
		balloon_alert(user, "I press the cork back in.")
		spillable = FALSE
	else
		reagent_flags |= TRANSFERABLE
		reagents.flags = reagent_flags
		balloon_alert(user, "I thumb off the cork.")
		playsound(user.loc,'sound/items/uncork.ogg', 100, TRUE)
		desc = "An open vial, easy to drink quickly."
		spillable = TRUE
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/glass/bottle/decanter
	name = "clay decanter"
	desc = "A decanter fired from clay."
	icon = 'icons/obj/handmade/decanter.dmi'
	icon_state = "world"
	volume = 50
	amount_per_transfer_from_this = 8
	possible_transfer_amounts = list(8)
	dropshrink = 1
	can_label_container = FALSE
	spillable = TRUE
	fill_icon_thresholds = null

/obj/item/reagent_containers/glass/bottle/decanter/Initialize()
	. = ..()
	icon_state = "world"

/obj/item/reagent_containers/glass/bottle/decanter/set_material_information()
	. = ..()
	name = "[lowertext(initial(main_material.name))] clay decanter"

/obj/item/reagent_containers/glass/bottle/teapot
	name = "clay teapot"
	desc = "A teapot fired from clay."

	icon = 'icons/obj/handmade/teapot.dmi'
	icon_state = "world"
	volume = 100
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	dropshrink = 1
	spillable = TRUE
	fill_icon_thresholds = null
	can_label_container = FALSE

/obj/item/reagent_containers/glass/bottle/teapot/Initialize()
	. = ..()
	icon_state = "world"
	AddComponent(/datum/component/storage/concrete/grid/teapot)
	AddComponent(/datum/component/container_craft, subtypesof(/datum/container_craft/cooking/tea), TRUE)

/obj/item/reagent_containers/glass/bottle/teapot/random/Initialize()
	. = ..()
	main_material = pick(typesof(/datum/material/clay))
	set_material_information()

/obj/item/reagent_containers/glass/bottle/teapot/set_material_information()
	. = ..()
	name = "[lowertext(initial(main_material.name))] clay teapot"


/obj/item/reagent_containers/glass/bottle/glazed_teacup
	name = "fancy teacup"
	desc = "A fancy tea cup made out of ceramic. Used to serve tea."
	icon_state = "cup_fancy"
	volume = 30
	dropshrink = 0.7
	can_label_container = FALSE
	custom_icon = TRUE

/obj/item/reagent_containers/glass/bottle/glazed_teapot
	name = "fancy teapot"
	desc = "A fancy tea pot made out of ceramic. Used to hold tea."
	icon_state = "teapot_fancy"
	volume = 100
	dropshrink = 0.7
	can_label_container = FALSE
	custom_icon = TRUE

/obj/item/reagent_containers/glass/bottle/glazed_teapot/tea
	list_reagents = list(/datum/reagent/consumable/tea/compot = 100)

/obj/item/reagent_containers/glass/bottle/black
	name = "wine pot"
	desc = "A wine pot made of glazed clay."
	icon_state = "blackbottle"
	fill_icon_thresholds = null
	label_prefix = "pot of "
	custom_icon = TRUE

/obj/item/reagent_containers/glass/bottle/black/Initialize()
	. = ..()
	icon_state = "blackbottle"
	update_appearance(UPDATE_OVERLAYS)
