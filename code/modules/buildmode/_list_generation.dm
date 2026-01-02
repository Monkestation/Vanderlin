/**
 * Generate HTML for turf selections
 *
 * @return {string} - HTML for the turf list
 */
/datum/buildmode/proc/generate_turf_list()
	var/list/dat = list()

	var/list/turf_types = subtypesof(/turf)
	var/list/filtered_types = list()
	for(var/turf_path in turf_types)
		var/turf/T = turf_path
		if(initial(T.icon) && !ispath(turf_path, /turf/template_noop))
			filtered_types += turf_path
	sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/turf_html = list()
	if("[BM_CATEGORY_TURF]" in cached_buildmode_html)
		turf_html = cached_buildmode_html["[BM_CATEGORY_TURF]"]

	if(!length(turf_html))
		for(var/turf_path in filtered_types)
			var/turf/T = turf_path
			var/name_display = initial(T.name) || T
			dat += "<div class='item' data-path='[turf_path]' title='[turf_path]' onclick='window.location=\"?src=[REF(src)];item=[turf_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[T.icon]?state=[T.icon_state]&dir=[T.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_TURF]"] = dat.Copy()
	else
		dat = turf_html.Copy()

	return dat.Join()

/**
 * Generate HTML for object selections
 *
 * @return {string} - HTML for the object list
 */
/datum/buildmode/proc/generate_obj_list()
	var/list/dat = list()
	var/list/obj_types = subtypesof(/obj)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/obj_path in obj_types)
			var/obj/O = obj_path
			if(is_abstract(O))
				continue
			if(ispath(O, /obj/item))
				continue
			if(ispath(O, /obj/abstract))
				continue

			if(initial(O.icon) && !ispath(obj_path, /obj/effect))
				filtered_types += obj_path
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/obj_html = list()
	if("[BM_CATEGORY_OBJ]" in cached_buildmode_html)
		obj_html = cached_buildmode_html["[BM_CATEGORY_OBJ]"]

	if(!length(obj_html))
		for(var/obj_path in filtered_types)
			var/obj/O = obj_path
			var/name_display = initial(O.name) || O

			dat += "<div class='item' data-path='[obj_path]' title='[obj_path]' onclick='window.location=\"?src=[REF(src)];item=[obj_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[O.icon]?state=[O.icon_state]&dir=[O.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_OBJ]"] = dat.Copy()
	else
		dat = obj_html.Copy()

	return dat.Join()

/**
 * Generate HTML for mob selections
 *
 * @return {string} - HTML for the mob list
 */
/datum/buildmode/proc/generate_mob_list()
	var/list/dat = list()
	var/list/mob_types = subtypesof(/mob)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/mob_path in mob_types)
			var/mob/M = mob_path
			if(initial(M.icon) && !ispath(mob_path, /mob/dead) && !ispath(mob_path, /mob/camera))
				filtered_types += mob_path
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/mob_html = list()
	if("[BM_CATEGORY_MOB]" in cached_buildmode_html)
		mob_html = cached_buildmode_html["[BM_CATEGORY_MOB]"]

	if(!length(mob_html))
		for(var/mob_path in filtered_types)
			var/mob/M = mob_path
			var/name_display = initial(M.name) || M

			dat += "<div class='item' data-path='[mob_path]' title='[mob_path]' onclick='window.location=\"?src=[REF(src)];item=[mob_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[M.icon]?state=[M.icon_state]&dir=[M.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_MOB]"] = dat.Copy()
	else
		dat = mob_html.Copy()

	return dat.Join()

/**
 * Generate HTML for item selections
 *
 * @return {string} - HTML for the item list
 */
/datum/buildmode/proc/generate_item_list()
	var/list/dat = list()

	var/list/item_types = subtypesof(/obj/item)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/item_path in item_types)
			var/obj/item/I = item_path
			if(ispath(I, /obj/item/clothing) || ispath(I, /obj/item/weapon) || ispath(I, /obj/item/reagent_containers))
				continue
			if(initial(I.icon))
				filtered_types += item_path
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/item_html = list()
	if("[BM_CATEGORY_ITEM]" in cached_buildmode_html)
		item_html = cached_buildmode_html["[BM_CATEGORY_ITEM]"]

	if(!length(item_html))
		for(var/item_path in filtered_types)
			var/obj/item/I = item_path
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[item_path]' title='[item_path]' onclick='window.location=\"?src=[REF(src)];item=[item_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[I.icon]?state=[I.icon_state]&dir=[I.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_ITEM]"] = dat.Copy()
	else
		dat = item_html.Copy()

	return dat.Join()

/**
 * Generate HTML for food selections
 *
 * @return {string} - HTML for the food list
 */
/datum/buildmode/proc/generate_food_list()
	var/list/dat = list()

	var/list/item_types = subtypesof(/obj/item/reagent_containers/food)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/item_path in item_types)
			var/obj/item/I = item_path
			if(initial(I.icon))
				filtered_types += item_path
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/food_html = list()
	if("[BM_CATEGORY_FOOD]" in cached_buildmode_html)
		food_html = cached_buildmode_html["[BM_CATEGORY_FOOD]"]

	if(!length(food_html))
		for(var/item_path in filtered_types)
			var/obj/item/I = item_path
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[item_path]' title='[item_path]' onclick='window.location=\"?src=[REF(src)];item=[item_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[I.icon]?state=[I.icon_state]&dir=[I.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_FOOD]"] = dat.Copy()
	else
		dat = food_html.Copy()

	return dat.Join()

/**
 * Generate HTML for reagent container selections
 *
 * @return {string} - HTML for the reagent container list
 */
/datum/buildmode/proc/generate_reagentcontainer_list()
	var/list/dat = list()

	var/list/item_types = subtypesof(/obj/item/reagent_containers)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/item_path in item_types)
			var/obj/item/I = item_path
			if(ispath(I, /obj/item/reagent_containers/food))
				continue
			if(initial(I.icon))
				filtered_types += item_path
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/container_html = list()
	if("[BM_CATEGORY_REAGENT_CONTAINERS]" in cached_buildmode_html)
		container_html = cached_buildmode_html["[BM_CATEGORY_REAGENT_CONTAINERS]"]

	if(!length(container_html))
		for(var/item_path in filtered_types)
			var/obj/item/I = item_path
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[item_path]' title='[item_path]' onclick='window.location=\"?src=[REF(src)];item=[item_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[I.icon]?state=[I.icon_state]&dir=[I.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_REAGENT_CONTAINERS]"] = dat.Copy()
	else
		dat = container_html.Copy()

	return dat.Join()

/**
 * Generate HTML for clothing selections
 *
 * @return {string} - HTML for the clothing list
 */
/datum/buildmode/proc/generate_clothing_list()
	var/list/dat = list()
	var/list/item_types = subtypesof(/obj/item/clothing)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/item_path in item_types)
			var/obj/item/I = item_path
			if(initial(I.icon))
				filtered_types += item_path
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/clothing_html = list()
	if("[BM_CATEGORY_CLOTHING]" in cached_buildmode_html)
		clothing_html = cached_buildmode_html["[BM_CATEGORY_CLOTHING]"]

	if(!length(clothing_html))
		for(var/item_path in filtered_types)
			var/obj/item/I = item_path
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[item_path]' title='[item_path]' onclick='window.location=\"?src=[REF(src)];item=[item_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[I.icon]?state=[I.icon_state]&dir=[I.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_CLOTHING]"] = dat.Copy()
	else
		dat = clothing_html.Copy()

	return dat.Join()

/**
 * Generate HTML for weapon selections
 *
 * @return {string} - HTML for the weapon list
 */
/datum/buildmode/proc/generate_weapon_list()
	var/list/dat = list()
	var/list/item_types = subtypesof(/obj/item/weapon)
	var/static/list/filtered_types = list()

	if(!length(filtered_types))
		for(var/item_path in item_types)
			var/obj/item/I = item_path
			if(initial(I.icon))
				filtered_types += item_path
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/weapon_html = list()
	if("[BM_CATEGORY_WEAPON]" in cached_buildmode_html)
		weapon_html = cached_buildmode_html["[BM_CATEGORY_WEAPON]"]

	if(!length(weapon_html))
		for(var/item_path in filtered_types)
			var/obj/item/I = item_path
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[item_path]' title='[item_path]' onclick='window.location=\"?src=[REF(src)];item=[item_path]\"'>"
			dat += "<div class='item-icon'><img src='\ref[I.icon]?state=[I.icon_state]&dir=[I.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_WEAPON]"] = dat.Copy()
	else
		dat = weapon_html.Copy()

	return dat.Join()
