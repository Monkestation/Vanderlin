/obj/item/storage/fancy/pilltin
	name = "pill tin"
	desc = "A tin for all your pill needs."
	icon = 'icons/obj/medical.dmi'
	icon_state = "pilltin"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 1
	slot_flags = null
	contents_tag = null
	component_type = /datum/component/storage/concrete/grid/pilltin

/obj/item/storage/fancy/pilltin/update_icon_state()
	. = ..()
	if(is_open)
		if(length(contents) == 0)
			icon_state = "pilltin_empty"
		else if(istype(contents[1], /obj/item/reagent_containers/pill/devour))
			icon_state = "pilltinwake_open"
		else if(istype(contents[1], /obj/item/reagent_containers/pill/sate))
			icon_state = "pilltinpink_open"
		else
			icon_state = "pilltincustom_open"
	else
		icon_state = "pilltin"

/obj/item/storage/fancy/pilltin/MiddleClick(mob/user, params)
	is_open = !is_open
	update_appearance(UPDATE_ICON_STATE)
	to_chat(user, span_notice("[src] is now [is_open ? "open" : "closed"]."))

/obj/item/storage/fancy/pilltin/sate
	name = "pill tin (SATE)"
	desc = "A tin labelled 'SATE', staves off the loss of thaumiel blood."
	spawn_type = /obj/item/reagent_containers/pill/sate

/obj/item/storage/fancy/pilltin/devour
	name = "pill tin (DEVOUR)"
	desc = "A tin labelled 'DEVOUR', devours thaumiel blood to forcibly induce the triggering of chimeric organs."
	spawn_type = /obj/item/reagent_containers/pill/devour
