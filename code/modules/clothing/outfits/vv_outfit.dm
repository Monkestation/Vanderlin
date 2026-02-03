// This outfit preserves varedits made on the items
// Created from admin helpers.
/datum/outfit/varedit
	var/list/vv_values
	var/list/stored_access
	var/update_id_name = FALSE //If the name of the human is same as the name on the id they're wearing we'll update provided id when equipping

/datum/outfit/varedit/pre_equip(mob/living/carbon/human/H, visuals_only)
	H.delete_equipment() //Applying VV to wrong objects is not reccomended.
	. = ..()

/datum/outfit/varedit/proc/set_equipment_by_slot(slot, item_path)
	switch(slot)
		if(ITEM_SLOT_PANTS)
			pants = item_path
		if(ITEM_SLOT_SHIRT)
			shirt = item_path
		if(ITEM_SLOT_ARMOR)
			armor = item_path
		if(ITEM_SLOT_SHOES)
			shoes = item_path
		if(ITEM_SLOT_GLOVES)
			gloves = item_path
		if(ITEM_SLOT_RING)
			ring = item_path
		if(ITEM_SLOT_MASK)
			mask = item_path
		if(ITEM_SLOT_MOUTH)
			mouth = item_path
		if(ITEM_SLOT_HEAD)
			head = item_path
		if(ITEM_SLOT_CLOAK)
			cloak = item_path
		if(ITEM_SLOT_NECK)
			neck = item_path
		if(ITEM_SLOT_HANDS)
			gloves = item_path
		if(ITEM_SLOT_BELT)
			belt = item_path
		if(ITEM_SLOT_BACK_R)
			backr = item_path
		if(ITEM_SLOT_BACK_L)
			backl = item_path
		if(ITEM_SLOT_WRISTS)
			wrists = item_path
		if(ITEM_SLOT_BELT_L)
			beltl = item_path
		if(ITEM_SLOT_BELT_R)
			beltr = item_path

/datum/outfit/varedit/proc/add_scabbard(scabbard_path)
	LAZYADD(scabbards, scabbard_path)

/proc/collect_vv(obj/item/I)
	//Temporary/Internal stuff, do not copy these.
	var/static/list/ignored_vars = list("vars","x","y","z","plane","layer","override","animate_movement","pixel_step_size","screen_loc","fingerprintslast","tip_timer")

	if(istype(I) && I.datum_flags & DF_VAR_EDITED)
		var/list/vedits = list()
		for(var/varname in I.vars)
			if(!I.can_vv_get(varname))
				continue
			if(varname in ignored_vars)
				continue
			var/vval = I.vars[varname]
			//Does it even work ?
			if(vval == initial(I.vars[varname]))
				continue
			//Only text/numbers and icons variables to make it less weirdness prone.
			if(!istext(vval) && !isnum(vval) && !isicon(vval))
				continue
			vedits[varname] = I.vars[varname]
		return vedits

/mob/living/carbon/human/proc/copy_outfit()
	var/datum/outfit/varedit/O = new

	//Copy equipment
	var/list/result = list()
	var/list/slots_to_check = DEFAULT_SLOT_PRIORITY
	for(var/s in slots_to_check)
		var/obj/item/I = get_item_by_slot(s)
		var/vedits = collect_vv(I)
		if(vedits)
			result["[s]"] = vedits
		if(istype(I))
			if(isscabbard(I)) // dogshit.
				O.add_scabbard(I.type)
				var/obj/item/thing_inside_scabbard = I.contents[length(I.contents)]
				if(istype(thing_inside_scabbard))
					O.set_equipment_by_slot(s, thing_inside_scabbard.type)
			else
				O.set_equipment_by_slot(s,I.type)

	//Copy hands
	if(held_items.len >= 2) //Not in the mood to let outfits transfer amputees
		var/obj/item/left_hand = held_items[1]
		var/obj/item/right_hand = held_items[2]
		if(istype(left_hand))
			O.l_hand = left_hand.type
			var/vedits = collect_vv(left_hand)
			if(vedits)
				result["LHAND"] = vedits
		if(istype(right_hand))
			O.r_hand = right_hand.type
			var/vedits = collect_vv(left_hand)
			if(vedits)
				result["RHAND"] = vedits
	O.vv_values = result
	//Copy to outfit cache
	var/outfit_name = stripped_input(usr,"Enter the outfit name")
	O.name = outfit_name
	O.id = "[O.name]_[world.time]"
	GLOB.custom_outfits[O.id] = O
	to_chat(usr,"Outfit [O.id] registered, use select equipment to equip it.")

/datum/outfit/varedit/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	//Apply VV
	for(var/slot in vv_values)
		var/list/edits = vv_values[slot]
		var/obj/item/I
		switch(slot)
			if("LHAND")
				I = H.held_items[1]
			if("RHAND")
				I = H.held_items[2]
			else
				I = H.get_item_by_slot(text2num(slot))
		for(var/vname in edits)
			I.vv_edit_var(vname,edits[vname])

/datum/outfit/varedit/get_json_data()
	. = .. ()
	.["stored_access"] = stored_access
	.["update_id_name"] = update_id_name
	var/list/stripped_vv = list()
	for(var/slot in vv_values)
		var/list/vedits = vv_values[slot]
		var/list/stripped_edits = list()
		for(var/edit in vedits)
			if(istext(vedits[edit]) || isnum(vedits[edit]) || isnull(vedits[edit]))
				stripped_edits[edit] = vedits[edit]
		if(stripped_edits.len)
			stripped_vv[slot] = stripped_edits
	.["vv_values"] = stripped_vv

/datum/outfit/varedit/load_from(list/outfit_data)
	. = ..()
	stored_access = outfit_data["stored_access"]
	vv_values = outfit_data["vv_values"]
	update_id_name = outfit_data["update_id_name"]
