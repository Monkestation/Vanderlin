
/obj/item/storage/fancy/ifak
	name = "personal patch kit"
	desc = "Personal treatment pouch; has all you need to stop you or someone else from meeting Necra."
	icon = 'icons/obj/medical.dmi'
	icon_state = "ifak"
	w_class = WEIGHT_CLASS_SMALL
	storage_type = /datum/storage/ifak
	throwforce = 1
	slot_flags = ITEM_SLOT_HIP

/obj/item/storage/fancy/ifak/populate_contents()
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/storage/fancy/pilltin/sate(src)
	new /obj/item/storage/fancy/pilltin/devour(src)
	new /obj/item/candle/yellow(src)
	new /obj/item/needle(src)

/obj/item/storage/fancy/ifak/update_icon_state()
	. = ..()
	if(is_open)
		if(length(contents) == 0)
			icon_state = "ifak_empty"
		else
			icon_state = "ifak_open"
	else
		icon_state = "ifak"

/obj/item/storage/fancy/ifak/examine(mob/user)
	. = ..()
	if(is_open)
		if(length(contents) == 1)
			. += "There is one item left."
		else
			. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] items left."

/obj/item/storage/fancy/ifak/attack_self(mob/user, params)
	. = ..()
	to_chat(user, span_notice("[src] is now [is_open ? "open" : "closed"]."))
