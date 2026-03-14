/datum/quest/courier
	quest_type = QUEST_COURIER
	var/list/target_delivery_locations = list(
		/area/indoors/town/tavern,
		/area/indoors/town/church,
		/area/indoors/town/dwarfin,
		/area/indoors/town/shop,
		/area/indoors/town/noble_manor,
		/area/indoors/town/keep/magician,
	)

/datum/quest/courier/get_title()
	if(title)
		return title
	return "Deliver [pick("an important", "a sealed", "a confidential", "a valuable")] [pick("package", "parcel", "letter", "delivery")]"

/datum/quest/courier/get_objective_text()
	return "Deliver [initial(target_delivery_item.name)] to [initial(target_delivery_location.name)]."

/datum/quest/courier/get_location_text()
	var/text = ""
	if(target_spawn_area)
		text += "Pickup location: Reported sighting in [target_spawn_area] region.<br>"
	text += "Destination: [initial(target_delivery_location.name)]."
	return text

/datum/quest/courier/get_additional_reward(target_turf)
	var/turf/scroll_turf = get_turf(quest_scroll)
	var/distance = CLAMP(get_dist(scroll_turf, target_turf), 0, 200) // Avoid infinity rewards if it bugs out
	var/distance_reward = (distance / QUEST_DELIVERY_DISTANCE_DIVISOR) * QUEST_DELIVERY_DISTANCE_BONUS
	return ROUND_UP(distance_reward + QUEST_COURIER_BONUS_FLAT)

/datum/quest/courier/proc/spawn_courier_item(area/delivery_area, obj/effect/landmark/quest_spawner/landmark)
	if(!delivery_area)
		return null

	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return

	var/obj/item/parcel/delivery_parcel = new(spawn_turf)
	var/static/list/area_delivery_items = list(
		/area/indoors/town/tavern = list(
			/obj/item/cooking/pan,
			/obj/item/reagent_containers/glass/bottle/beer/aurorian,
			/obj/item/reagent_containers/food/snacks/cheddar,
		),
		/area/indoors/town/bath = list(
			/obj/item/reagent_containers/glass/bottle/beer/aurorian,
			/obj/item/reagent_containers/food/snacks/pie/cooked/meat/fish,
			/obj/item/perfume/random,
		),
		/area/indoors/town/church = list(
			/obj/item/natural/cloth,
			/obj/item/reagent_containers/powder/ozium,
			/obj/item/reagent_containers/food/snacks/hardtack,
		),
		/area/indoors/town/dwarfin = list(
			/obj/item/ingot/iron,
			/obj/item/ingot/bronze,
			/obj/item/ore/coal,
		),
		/area/indoors/town/shop = list(
			/obj/item/coin/gold,
			/obj/item/clothing/ring/silver,
			/obj/item/scomstone/bad,
		),
		/area/indoors/town/noble_manor = list(
			/obj/item/clothing/cloak/raincloak/furcloak,
			/obj/item/reagent_containers/glass/bottle/whitewine,
			/obj/item/reagent_containers/food/snacks/cheddar/aged,
			/obj/item/perfume/random,
		),
		/area/indoors/town/keep/magician = list(
			/obj/item/book/granter/spellbook,
			/obj/item/gem/yellow,
			/obj/item/reagent_containers/glass/bottle/manapot,
		),
	)

	var/list/possible_items = area_delivery_items[delivery_area] || list(
		/obj/item/natural/cloth,
		/obj/item/ration,
		/obj/item/reagent_containers/food/snacks/hardtack,
	)

	var/contained_item_type = pick(possible_items)
	var/obj/item/contained_item = new contained_item_type(delivery_parcel)
	delivery_parcel.contained_item = contained_item
	delivery_parcel.delivery_area_type = delivery_area
	delivery_parcel.allowed_jobs = delivery_parcel.get_area_jobs(delivery_area)
	delivery_parcel.name = "Delivery for [initial(delivery_area.name)]"
	delivery_parcel.desc = "A securely wrapped parcel addressed to [initial(delivery_area.name)]. [pick("Handle with care.", "Do not bend.", "Confidential contents.", "Urgent delivery.")]"
	delivery_parcel.icon_state = contained_item.w_class >= WEIGHT_CLASS_NORMAL ? "ration_large" : "ration_small"
	delivery_parcel.dropshrink = 1
	delivery_parcel.update_icon()

	target_delivery_item = contained_item_type
	delivery_parcel.AddComponent(/datum/component/quest_object/courier, src)
	contained_item.AddComponent(/datum/component/quest_object/courier, src)
	add_tracked_atom(delivery_parcel)

	return delivery_parcel

/datum/quest/courier/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE

	// Select delivery location
	target_delivery_location = pick(target_delivery_locations)
	progress_required = 1
	target_spawn_area = get_area_name(get_turf(landmark))

	// Spawn parcel
	var/obj/item/parcel/delivery_parcel = spawn_courier_item(target_delivery_location, landmark)
	if(!delivery_parcel)
		return FALSE

	return TRUE
