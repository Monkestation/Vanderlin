
/obj/item/storage/fancy/ifak
	name = "personal patch kit"
	desc = "Personal treatment pouch; has all you need to stop you or someone else from meeting Necra."
	icon = 'icons/obj/medical.dmi'
	icon_state = "ifak"
	w_class = WEIGHT_CLASS_NORMAL // So you can put stuff like bottles and Vials into it
	storage_type = /datum/storage/ifak
	throwforce = 1
	slot_flags = ITEM_SLOT_HIP
	item_weight = 740 GRAMS
	contents_tag = "item"

/obj/item/storage/fancy/ifak/populate_contents()
	new /obj/item/reagent_containers/syringe(src)
	new /obj/item/natural/cloth/bandage(src)
	new /obj/item/natural/cloth/bandage(src)
	new /obj/item/natural/bundle/fibers/full(src)
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

/obj/item/storage/fancy/ifak/attack_self(mob/user, list/modifiers)
	. = ..()
	to_chat(user, span_notice("[src] is now [is_open ? "open" : "closed"]."))
