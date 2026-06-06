/obj/item/parcel
	name = "parcel wrapping paper"
	desc = "A sturdy piece of paper used to wrap items for secure delivery. The final size of the parcel depends on the size of the original item."
	icon = 'icons/obj/ration.dmi'
	icon_state = "ration_wrapper"
	w_class = WEIGHT_CLASS_TINY
	grid_height = 32
	grid_width = 32
	dropshrink = 0.6
	var/obj/item/contained_item = null
	var/list/allowed_jobs = list()
	var/list/job_names = list()
	var/delivery_area_type
	var/datum/proximity_monitor/proximity_monitor

/obj/item/parcel/Initialize(mapload)
	. = ..()
	var/datum/component/quest_object/courier_quest = GetComponent(/datum/component/quest_object)
	if(courier_quest)
		var/datum/quest/quest = courier_quest.quest_ref?.resolve()
		if(quest && quest.quest_type == QUEST_COURIER && quest.target_delivery_location)
			delivery_area_type = quest.target_delivery_location
			allowed_jobs = get_area_jobs(delivery_area_type)
			for(var/datum/job/job as anything in allowed_jobs)
				job_names |= initial(job.title)

			RegisterSignal(courier_quest, COMSIG_QDELETING, PROC_REF(on_quest_component_deleted))

	invisibility = INVISIBILITY_OBSERVER
	proximity_monitor = new(src, 5)

/obj/item/parcel/HasProximity(mob/nearby)
	if(!istype(nearby))
		return

	var/datum/component/quest_object/quest_component = GetComponent(/datum/component/quest_object)
	if(!istype(quest_component))
		return

	var/datum/quest/quest = quest_component.quest_ref?.resolve()
	if(!istype(quest))
		return

	if(get_dist(get_turf(src), get_turf(quest.quest_scroll_ref?.resolve())) > 5)
		return

	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = get_turf(src), icon_state = "hidden", layer = 18)
	I.layer = 18
	I.plane = 18
	if(!I)
		return
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay_view(I, 5 SECONDS)
	invisibility = initial(invisibility)
	QDEL_NULL(proximity_monitor)

/obj/item/parcel/proc/get_area_jobs(area_type)
	var/static/list/area_jobs = list(
		/area/indoors/town/tavern = list(/datum/job/innkeep, /datum/job/innkeep_son, /datum/job/cook),
		/area/indoors/town/bath = list(/datum/job/clinicapprentice, /datum/job/apothecary),
		/area/indoors/town/church = list(/datum/job/priest, /datum/job/templar, /datum/job/churchling),
		/area/indoors/town/dwarfin = list(/datum/job/innkeep, /datum/job/innkeep_son, /datum/job/cook),
		/area/indoors/town/shop = list(/datum/job/merchant, /datum/job/shophand),
		/area/indoors/town/noble_manor = list(/datum/job/servant, /datum/job/hand, /datum/job/royalknight, /datum/job/men_at_arms, /datum/job/steward, /datum/job/lord),
		/area/indoors/town/keep/magician = list(/datum/job/magician, /datum/job/mageapprentice, /datum/job/archivist),
		/area/indoors/town = list(/datum/job/innkeep, /datum/job/innkeep_son, /datum/job/cook)
	)
	return area_jobs[area_type] || list(/datum/job/steward, /datum/job/merchant)

/obj/item/parcel/proc/on_quest_component_deleted(datum/source)
	SIGNAL_HANDLER
	return

/obj/item/parcel/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/parcel) || I.w_class > WEIGHT_CLASS_BULKY || contained_item)
		to_chat(user, span_warning("You can't wrap this in [src]."))
		return

	if(do_after(user, 2 SECONDS, target = src))
		user.transferItemToLoc(I, src)
		contained_item = I
		name = "parcel ([I.name])"
		desc = "A securely wrapped parcel containing [I.name]."
		icon_state = I.w_class >= WEIGHT_CLASS_NORMAL ? "ration_large" : "ration_small"
		dropshrink = 1
		update_icon()
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		to_chat(user, span_notice("You wrap [I] in the parcel wrapper."))

/obj/item/parcel/attack_self(mob/user)
	if(!contained_item)
		return

	if(delivery_area_type)
		var/area/quest_area = delivery_area_type
		if(ispath(quest_area, /area) && !(user.job_type in allowed_jobs))
			to_chat(user, span_warning("This parcel is sealed for delivery to [initial(quest_area.name)] and can only be opened by: [english_list(job_names)]!"))
			return FALSE

	if(do_after(user, 2 SECONDS, target = src))
		to_chat(user, span_notice("You unwrap [contained_item] from the parcel."))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		user.put_in_hands(contained_item)
		contained_item.update_icon()
		contained_item = null
		qdel(src)

/obj/item/parcel/examine(mob/user)
	. = ..()
	if(!delivery_area_type)
		return

	var/area/delivery_area = delivery_area_type
	if(!ispath(delivery_area, /area))
		return

	. += span_info("This parcel is addressed to [initial(delivery_area.name)].")
	. += (user.job_type in allowed_jobs) ? \
		span_notice("As [user.job], you're authorized to open this.") : \
		span_warning("It's sealed with an official guild mark - only authorized personnel should open this!")
