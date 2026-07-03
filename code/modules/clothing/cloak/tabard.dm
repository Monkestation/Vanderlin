/obj/item/clothing/cloak/tabard
	name = "tabard"
	desc = "A common short coat commonly worn by just about anyone."
	icon_state = "tabard"
	item_state = "tabard"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/detailed/tabards.dmi'
	detail_tag = "_spl"
	detail_color = CLOTHING_BERRY_BLUE
	color = CLOTHING_PEAR_YELLOW
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	var/picked

/obj/item/clothing/cloak/tabard/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(picked)
		return

	var/the_time = world.time

	var/design = tgui_input_list(user, "Select a design.", "Tabard Design", list("None", "Split", "Quadrants", "Boxes", "Diamonds"))
	if(!design)
		return

	if(design == "Symbol")
		design = null
		design = tgui_input_list(user, "Select a symbol.", "Tabard Design", list("chalice", "psy", "peace", "z", "imp", "skull", "widow", "arrow"))
		if(!design)
			return
		design = "_[design]"

	var/colorone = tgui_input_list(user, "Select a primary color.", "Tabard Design", GLOB.noble_dyes)
	if(!colorone)
		return

	var/colortwo
	if(design != "None")
		colortwo = tgui_input_list(user, "Select a primary color.", "Tabard Design", GLOB.noble_dyes)
		if(!colortwo)
			return

	if(world.time > (the_time + 30 SECONDS))
		return

	switch(design)
		if("Split")
			detail_tag = "_spl"
		if("Quadrants")
			detail_tag = "_quad"
		if("Boxes")
			detail_tag = "_box"
		if("Diamonds")
			detail_tag = "_dim"

	color = GLOB.noble_dyes[colorone]
	if(colortwo)
		detail_color = GLOB.noble_dyes[colortwo]

	update_appearance(UPDATE_OVERLAYS)

	if(tgui_alert(user, "Are you pleased with your heraldry?", "Heraldry", list("Yes", "No")) != "Yes")
		detail_color = initial(detail_color)
		color = initial(color)
		detail_tag = initial(detail_tag)
		update_appearance(UPDATE_OVERLAYS)
		return

	picked = TRUE

/obj/item/clothing/cloak/tabard/knight
	detail_color = CLOTHING_RED_OCHRE
	color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/tabard/knight/attack_hand_secondary(mob/user, list/modifiers)
	return

/obj/item/clothing/cloak/tabard/crusader
	color = CLOTHING_MAGE_GREY
	detail_tag = "_psy"
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/crusader/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "Select a design.","Tabard Design") as null|anything in list("Default", "Gold Cross", "Jeruah", "BlackGold", "BlackWhite")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "Gold Cross")
		detail_color = "#b5b004"
	if(design == "Jeruah")
		detail_color = "#b5b004"
		color = "#249589"
	if(design == "BlackGold")
		detail_color = CLOTHING_MUSTARD_YELLOW
		color = CLOTHING_SOOT_BLACK
	if(design == "BlackWhite")
		detail_color = CLOTHING_WHITE
		color = CLOTHING_SOOT_BLACK
	update_appearance(UPDATE_ICON)
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(tgui_alert(usr, "Are you pleased with your heraldry?", "Heraldry", list("Yes", "No")) != "Yes")
		detail_color = initial(detail_color)
		color = initial(color)
		update_appearance(UPDATE_ICON)
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/crusader/tief
	color = CLOTHING_BLOOD_RED
	detail_tag = "_quad"
	detail_color = CLOTHING_SOOT_BLACK

/obj/item/clothing/cloak/tabard/crusader/tief/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(picked)
		return
	var/the_time = world.time
	var/design = input(user, "Select a design.","Tabard Design") as null|anything in list("Default", "RedBlack", "BlackRed")
	if(!design)
		return
	if(world.time > (the_time + 30 SECONDS))
		return
	if(design == "RedBlack")
		detail_color = CLOTHING_SOOT_BLACK
		color = CLOTHING_BLOOD_RED
	if(design == "BlackRed")
		detail_color = CLOTHING_BLOOD_RED
		color = CLOTHING_SOOT_BLACK
	update_appearance(UPDATE_ICON)
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(tgui_alert(usr, "Are you pleased with your heraldry?", "Heraldry", list("Yes", "No")) != "Yes")
		detail_color = initial(detail_color)
		color = initial(color)
		update_appearance(UPDATE_ICON)
	picked = TRUE

/obj/item/clothing/cloak/tabard/knight/guard
	desc = "A tabard with the lord's heraldic colors."
	color = CLOTHING_BLOOD_RED
	detail_tag = "_spl"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/tabard/knight/guard/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(picked)
		return
	var/the_time = world.time
	var/chosen = input(user, "Select a design.","Tabard Design") as null|anything in list("Split", "Quadrants", "Boxes", "Diamonds")
	if(world.time > (the_time + 10 SECONDS))
		return
	if(!chosen)
		return
	switch(chosen)
		if("Split")
			detail_tag = "_spl"
		if("Quadrants")
			detail_tag = "_quad"
		if("Boxes")
			detail_tag = "_box"
		if("Diamonds")
			detail_tag = "_dim"
	update_appearance(UPDATE_ICON)
	if(ismob(loc))
		var/mob/L = loc
		L.update_inv_cloak()
	if(tgui_alert(usr, "Are you pleased with your heraldry?", "Heraldry", list("Yes", "No")) != "Yes")
		detail_tag = initial(detail_tag)
		update_appearance(UPDATE_ICON)
		if(ismob(loc))
			var/mob/L = loc
			L.update_inv_cloak()
		return
	picked = TRUE

/obj/item/clothing/cloak/tabard/adept
	detail_tag = "_psy"
	color = CLOTHING_SOOT_BLACK
	detail_color = CLOTHING_WHITE

/obj/item/clothing/cloak/tabard/adept/attack_hand_secondary(mob/user, list/modifiers)
	return
