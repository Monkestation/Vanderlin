/**
 * Generate HTML for turf selections
 *
 * @return {string} - HTML for the turf list
 */
/datum/buildmode/proc/generate_turf_list()
	var/list/dat = list()

	var/list/turf_types = subtypesof(/turf)
	var/list/filtered_types = list()
	for(var/turf/T as anything in turf_types)
		if(initial(T.icon) && !ispath(T, /turf/template_noop))
			filtered_types += T
	sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/turf_html = list()
	if("[BM_CATEGORY_TURF]" in cached_buildmode_html)
		turf_html = cached_buildmode_html["[BM_CATEGORY_TURF]"]

	if(!length(turf_html))
		for(var/turf/T as anything in filtered_types)
			var/name_display = initial(T.name) || T
			dat += "<div class='item' data-path='[T]' title='[T]' onclick='window.location=\"?src=[REF(src)];item=[T]\"'>"
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
		for(var/obj/O as anything in obj_types)
			if(IS_ABSTRACT(O))
				continue
			if(ispath(O, /obj/item))
				continue
			if(ispath(O, /obj/abstract))
				continue

			if(initial(O.icon) && !ispath(O, /obj/effect))
				filtered_types += O
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/obj_html = list()
	if("[BM_CATEGORY_OBJ]" in cached_buildmode_html)
		obj_html = cached_buildmode_html["[BM_CATEGORY_OBJ]"]

	if(!length(obj_html))
		for(var/obj/O as anything in filtered_types)
			var/name_display = initial(O.name) || O

			dat += "<div class='item' data-path='[O]' title='[O]' onclick='window.location=\"?src=[REF(src)];item=[O]\"'>"
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
		for(var/mob/M as anything in mob_types)
			if(initial(M.icon) && !ispath(M, /mob/dead) && !ispath(M, /mob/camera))
				filtered_types += M
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/mob_html = list()
	if("[BM_CATEGORY_MOB]" in cached_buildmode_html)
		mob_html = cached_buildmode_html["[BM_CATEGORY_MOB]"]

	if(!length(mob_html))
		for(var/mob/M as anything in filtered_types)
			var/name_display = initial(M.name) || M

			dat += "<div class='item' data-path='[M]' title='[M]' onclick='window.location=\"?src=[REF(src)];item=[M]\"'>"
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
		for(var/obj/item/I as anything in item_types)
			if(ispath(I, /obj/item/clothing) || ispath(I, /obj/item/weapon) || ispath(I, /obj/item/reagent_containers))
				continue
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/item_html = list()
	if("[BM_CATEGORY_ITEM]" in cached_buildmode_html)
		item_html = cached_buildmode_html["[BM_CATEGORY_ITEM]"]

	if(!length(item_html))
		for(var/obj/item/I as anything in filtered_types)
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[I]' title='[I]' onclick='window.location=\"?src=[REF(src)];item=[I]\"'>"
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
		for(var/obj/item/I as anything in item_types)
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/food_html = list()
	if("[BM_CATEGORY_FOOD]" in cached_buildmode_html)
		food_html = cached_buildmode_html["[BM_CATEGORY_FOOD]"]

	if(!length(food_html))
		for(var/obj/item/I as anything in filtered_types)
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[I]' title='[I]' onclick='window.location=\"?src=[REF(src)];item=[I]\"'>"
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
		for(var/obj/item/I as anything in item_types)
			if(ispath(I, /obj/item/reagent_containers/food))
				continue
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/container_html = list()
	if("[BM_CATEGORY_REAGENT_CONTAINERS]" in cached_buildmode_html)
		container_html = cached_buildmode_html["[BM_CATEGORY_REAGENT_CONTAINERS]"]

	if(!length(container_html))
		for(var/obj/item/I as anything in filtered_types)
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[I]' title='[I]' onclick='window.location=\"?src=[REF(src)];item=[I]\"'>"
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
		for(var/obj/item/I as anything in item_types)
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/clothing_html = list()
	if("[BM_CATEGORY_CLOTHING]" in cached_buildmode_html)
		clothing_html = cached_buildmode_html["[BM_CATEGORY_CLOTHING]"]

	if(!length(clothing_html))
		for(var/obj/item/I as anything in filtered_types)
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[I]' title='[I]' onclick='window.location=\"?src=[REF(src)];item=[I]\"'>"
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
		for(var/obj/item/I as anything in item_types)
			if(initial(I.icon))
				filtered_types += I
		sortTim(filtered_types, GLOBAL_PROC_REF(cmp_typepaths_asc))

	var/list/weapon_html = list()
	if("[BM_CATEGORY_WEAPON]" in cached_buildmode_html)
		weapon_html = cached_buildmode_html["[BM_CATEGORY_WEAPON]"]

	if(!length(weapon_html))
		for(var/obj/item/I as anything in filtered_types)
			var/name_display = initial(I.name) || I
			dat += "<div class='item' data-path='[I]' title='[I]' onclick='window.location=\"?src=[REF(src)];item=[I]\"'>"
			dat += "<div class='item-icon'><img src='\ref[I.icon]?state=[I.icon_state]&dir=[I.dir]'/></div>"
			dat += "<div class='item-name'>[name_display]</div>"
			dat += "</div>"
		cached_buildmode_html["[BM_CATEGORY_WEAPON]"] = dat.Copy()
	else
		dat = weapon_html.Copy()

	return dat.Join()
