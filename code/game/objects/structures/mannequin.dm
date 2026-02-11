/////////////////////////////////////////////////////////MANNEQUINS//////////////////////////////////////////////////////////
//Basically statues that you can dress up. Poorly Translate from VG station

#define SLOT_MANNEQUIN_SHIRT "shirt"
#define SLOT_MANNEQUIN_FEET "feet"
#define SLOT_MANNEQUIN_GLOVES "gloves"
#define SLOT_MANNEQUIN_WRISTS "wrists"
#define SLOT_MANNEQUIN_ARMOR "armor"
#define SLOT_MANNEQUIN_NECK "neck"
#define SLOT_MANNEQUIN_BELT "belt"
#define SLOT_MANNEQUIN_MASK "mask"
#define SLOT_MANNEQUIN_HEAD "head"
#define SLOT_MANNEQUIN_PANTS "pants"
#define SLOT_MANNEQUIN_CLOAK "cloak"
#define SLOT_MANNEQUIN_RING "ring"

/*
* Important note:
* Cloaks and rings do not have a target zone and can only be equipped via the menu.
* To summarize some comments, they were possibly excluded because they had no target zones,
* and there was no menu. Now there is a menu.
* I specifically left out hip and back slots so as not to display weapons/equipment.
* I think it's best to keep mannequins for armor/clothing/jewelry.
*/

/*
* If you are porting this from another codebase
* some of the procs that you will need to replace are
* get_active_held_item(), build_worn_icon()
*/

/*
* Additional note: This was a absolute nightmare to code
* i learned the absurd secrets of how sleeves and hands work
* and the fact that creatures have 3 sprites for each bodypart.
* This is cursed code -IP
*/

/obj/structure/mannequin
	name = "display stand"
	desc = "It looks like a decorative training dummy."
	icon = 'icons/obj/mannequin.dmi'
	icon_state = "coat_hanger"
	density = TRUE
	anchored = FALSE
	gender = MALE
	max_integrity = 50
	//If the mannequin can have its items changed. Useful for purely decorative displays.
	var/unchangeable = FALSE
	//If the mannequin has fallen onto the floor
	var/tipped_over = FALSE
	/*
	* Equipment Slots.
	*/
	var/list/clothing = list(
		SLOT_MANNEQUIN_ARMOR,
		SLOT_MANNEQUIN_SHIRT,
		SLOT_MANNEQUIN_BELT,
		SLOT_MANNEQUIN_MASK,
		SLOT_MANNEQUIN_PANTS,
		SLOT_MANNEQUIN_FEET,
		SLOT_MANNEQUIN_HEAD,
		SLOT_MANNEQUIN_CLOAK,
		SLOT_MANNEQUIN_NECK,
		SLOT_MANNEQUIN_GLOVES,
		SLOT_MANNEQUIN_WRISTS,
		SLOT_MANNEQUIN_RING,
		)

	//Easily Editable Mapping Variables
	/*
	* Ideally this would be items placed ontop of the mannequin
	* instead of this. If we did the everything ontop of this
	* mannequin becomes its equipment on spawn we couldnt
	* choose if a tabbard is placed on a mannequin's armor
	* or cloak slot. Predefined spawners with a New(items_to_wear)
	* list can define where each object is equipped but it would
	* require code or subtypes.
	*/
	var/mapping_pants
	var/mapping_shirt
	var/mapping_shoes
	var/mapping_gloves
	var/mapping_ring
	var/mapping_wrists
	var/mapping_armor
	var/mapping_belt
	var/mapping_mask
	var/mapping_head
	var/mapping_cloak
	var/mapping_neck

//Code//
/obj/structure/mannequin/Initialize(mapload)
	. = ..()
	MapEquip()
	if(mapload)
		for(var/obj/item/clothing/clothing in get_turf(src))
			var/slot = MannequinSlotHelper(clothing.slot_flags)
			if(slot)
				MannequinEquip(clothing, slot)

	update_appearance(UPDATE_OVERLAYS)

/obj/structure/mannequin/attack_hand(mob/living/user)
	if(user.a_intent.name == "punch")
		if(!tipped_over)
			TipOver()
			return
		return ..()
	if(tipped_over)
		StandUp(user)
		return
	//For easy moving of mannequins.
	if(!anchored && user.a_intent == INTENT_GRAB)
		user.start_pulling(src)
		return
	tryEquip(user)

/obj/structure/mannequin/attack_paw(mob/user)
	return attack_hand(user)

/*
* Taken from paperbin code. Its a bit immersion breaking
* but easier to use.
*/
/obj/structure/mannequin/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || M.incapacitated(IGNORE_GRAB) || !Adjacent(M) || unchangeable)
		return
	ShowInventory(M)

/*
* This is where the button presses from ShowInventory() go.
* Press turn? then the word turn will be sent here and
* the resulting effects will be placed in its if(href_list["turn"]) statement.
*/
/obj/structure/mannequin/Topic(href, href_list)
	..()
	if(tipped_over || !(iscarbon(usr)) || usr.incapacitated(IGNORE_GRAB) || !Adjacent(usr))
		return
	var/mob/living/carbon/user = usr
	switch(href_list["command"])
		if("item_placement")
			var/obj/item/item_in_hand = user.get_active_held_item()
			var/item_slot = href_list["item_slot"]

			var/targ_to_slot = MannequinEquipHelper(item_slot)
			if(!item_in_hand)
				if(clothing[targ_to_slot])
					var/obj/item/I = clothing[targ_to_slot]
					MannequinUnequip(null,targ_to_slot)
					user.put_in_hand(I)
					add_fingerprint(user)
					to_chat(user, "You pick up \the [I] from \the [src].")
			else
				FinalEquipCheck(user, item_in_hand, item_slot)

		//Utility Button Effects
		if("turn_mannequin")
			switch(dir)
				if(NORTH)
					dir = EAST
				if(SOUTH)
					dir = WEST
				if(WEST)
					dir = NORTH
				//Safety Net
				else
					dir = SOUTH
		else
			if(user?.client)
				user << browse(null, "window=mannequin[REF(src)]")
			return
	update_appearance(UPDATE_OVERLAYS)
	ShowInventory(user)

//Mannequin Interaction UI
/obj/structure/mannequin/proc/ShowInventory(mob/user)
	var/dat

	dat += EquippableSlots()
	dat += "<HR>Turn Mannequin:<B><A href='byond://?src=[REF(src)];command=turn_mannequin'>[dir2text(dir)]</A></B>"
	dat += "<BR><A href='byond://?src=[REF(src)];command=close' style='position:absolute;right:50px'>Close</A>"

	var/datum/browser/noclose/popup = new(user, "mannequin[REF(src)]", "<div align='center'>Mannequin Fitting</div>", 275, 425)
	//I don't think generating a new popup datum every ui update is a good thing, but what do I know. I'm so used to tgui.
	popup.set_content(dat)
	popup.open()

//UI SLOTS
/obj/structure/mannequin/proc/EquippableSlots()
	. += "<BR><B>Head:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_HEAD]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_HEAD])]</A>"
	. += "<BR><B>Mask:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_PRECISE_MOUTH]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_MASK])]</A>"
	. += "<BR><B>Neck:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_PRECISE_NECK]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_NECK])]</A>"
	. += "<BR><B>Cloak:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[SLOT_MANNEQUIN_CLOAK]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_CLOAK])]</A>" //No direct slot to equip.
	. += "<BR><B>Armor:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_CHEST]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_ARMOR])]</A>"
	. += "<BR><B>Shirt:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_PRECISE_STOMACH]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_SHIRT])]</A>"
	. += "<BR><B>Belt:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_PRECISE_GROIN]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_BELT])]</A>"
	. += "<BR><B>Ring:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[SLOT_MANNEQUIN_RING]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_RING])]</A>" //No direct slot to equip.

/obj/structure/mannequin/attackby(obj/item/I, mob/user, list/modifiers)
	if(user.cmode || user.a_intent == INTENT_HARM || user.a_intent == INTENT_DISARM)
		if(!tipped_over)
			TipOver()
			return
		return ..()
	tryEquip(user)

//Mannequin exploded.
/obj/structure/mannequin/Destroy()
	DropAll()
	return ..()

/obj/structure/mannequin/examine(mob/user)
	..()
	var/msg = ""
	var/slot_examine

	for(var/slot_cloth in clothing)
		var/obj/item/cloth_to_examine = clothing[slot_cloth]
		if(cloth_to_examine)
			switch(slot_cloth)
				if(SLOT_MANNEQUIN_HEAD)
					slot_examine = " on its head."
				if(SLOT_MANNEQUIN_NECK)
					slot_examine = " on its neck."
				if(SLOT_MANNEQUIN_GLOVES)
					slot_examine = " on its hands."
				if(SLOT_MANNEQUIN_WRISTS)
					slot_examine = " around its arms."
				if(SLOT_MANNEQUIN_BELT)
					slot_examine = " about its waist."
				if(SLOT_MANNEQUIN_SHIRT)
					slot_examine = " close to its skin."
				if(SLOT_MANNEQUIN_ARMOR)
					slot_examine = " over its body."
				if(SLOT_MANNEQUIN_PANTS)
					slot_examine = " on its legs."
				if(SLOT_MANNEQUIN_FEET)
					slot_examine = " on its feet."
				if(SLOT_MANNEQUIN_MASK)
					slot_examine = " on its face."
				if(SLOT_MANNEQUIN_CLOAK)
					slot_examine = " over its shoulders."
				if(SLOT_MANNEQUIN_RING)
					slot_examine = " around its finger."
			msg += "Wearing [cloth_to_examine][slot_examine].<br>"
	/*
	* This is placed here due to the fact
	* that some clothing is gender locked.
	* Very annoying that without this consideration
	* some clothing will be invisible on the mannequin.
	*/
	msg += "This mannequin has a [gender == FEMALE ? "feminine" : "masculine"] body.<br>"
	msg += ":Aim for the place where the clothing fits, drag the mannequin onto yourself for a less immersive panel:"
	to_chat(user, msg)

//Tries to equip the mannequin. Part of attack_hand() reflection of Topic()
/obj/structure/mannequin/proc/tryEquip(mob/user, equipment_slot)
	if(unchangeable)
		return
	var/obj/item/item_in_hand = usr.get_active_held_item()
	var/item_slot = user.zone_selected
	if(!item_in_hand)
		if(clothing[item_slot])
			var/obj/item/I = clothing[item_slot]
			MannequinUnequip(I, MannequinEquipHelper(item_slot))
			add_fingerprint(user)
			to_chat(user, "<span class='info'>You pick up \the [I] from \the [src].</span>")
	else
		FinalEquipCheck(user, item_in_hand, item_slot)

/*
* This code is used in Topic and tryEquip
* It requires slot_placement to be user
* targeting so that it can be converted
* to item flags and mannequin slots.
*/
/obj/structure/mannequin/proc/FinalEquipCheck(mob/living/user, obj/item/item_thing, slot_placement)
	if(canEquip(user ,item_thing, EquipHelper(slot_placement)))
		if(user.dropItemToGround(item_thing))
			if(clothing[slot_placement])
				to_chat(user, "<span class='info'>You switch \the [item_thing] and \the [clothing[slot_placement]] on the [src].</span>")
				MannequinEquip(item_thing, MannequinEquipHelper(slot_placement))
				add_fingerprint(user)
			else
				MannequinEquip(item_thing, MannequinEquipHelper(slot_placement))
				add_fingerprint(user)
				to_chat(user, "<span class='info'>You place \the [item_thing] on \the [src].</span>")
		//If drop to ground proc fails
		else
			to_chat(user, "<span class='warning'>You can't drop that!</span>")

/*
* Checks if the item can be equipped by the manniquin.
* EquipHelper() is used to make sure the item has the slot
* flags to be placed in that area.
* Targeted Area goes in Item Slot comes out
*/
/obj/structure/mannequin/proc/canEquip(mob/user, obj/item/item_to_check, selected_area)

	if(isclothing(item_to_check))
		var/obj/item/clothing/C = item_to_check
		//Thank you DM Refrence website for telling me how to find out negative if in arguments.
		if(!(gender in C.allowed_sex) || !(SPEC_ID_HUMEN in C.allowed_race))
			to_chat(user, "<span class='warning'>This clothing won't fit this mannequin's frame.</span>")
			return FALSE

	if(item_to_check.slot_flags & selected_area)
		return TRUE

	if(user)
		to_chat(user, "<span class='warning'>\The [item_to_check] doesn't fit on the mannequin's [PlacementDescriber(selected_area)].</span>")
	return FALSE

/*
* These two small procs add and remove
* the item from the mannequins
* physical form and clothing list.
* WARNING THESE PROCS REQUIRE MANNEQUIN SLOT
* DEFINES. USE CONVERSION PROCS TO TURN
* INPUT INTO MANNEQUIN SLOTS.
* such as MannequinEquipHelper
*/
/obj/structure/mannequin/proc/MannequinEquip(obj/item/O, item_slot)
	var/obj/item/existing_item = clothing[item_slot]
	if(istype(existing_item))
		MannequinUnequip(existing_item, item_slot)
	O.forceMove(src)
	clothing[item_slot] = O

	update_appearance(UPDATE_OVERLAYS)
	return O

/obj/structure/mannequin/proc/MannequinUnequip(obj/item/O, item_slot)
	if(!O)
		O = clothing[item_slot]
		//I know its sloppy but i do have to double check.
		if(!O)
			return
	O.forceMove(get_turf(src))
	clothing[item_slot] = null

	update_appearance(UPDATE_OVERLAYS)
	return O

/*
* THIS IS WHAT HAPPENS WHEN YOU
* HAVE 3 SPRITES FOR EACH BODYPART!!!
*/
/obj/structure/mannequin/update_overlays()
	. = ..()
	var/list/mannequin_overlays = list()
	for(var/cloth_slot in clothing)
		if(isitem(clothing[cloth_slot]))
			mannequin_overlays += FormatOverlay(clothing[cloth_slot], cloth_slot)
	mannequin_overlays += bodypartsNightmare()
	. += mannequin_overlays

/*
* This proc returns a mutative overlay that
* figures out what icon and icon_state to apply.
* This is used in update_appearance(UPDATE_OVERLAYS)
*/
/obj/structure/mannequin/proc/FormatOverlay(obj/item/worn_thing, slot_worn_on)
	if(!worn_thing)
		return
	//Is it not even a item?
	if(!isitem(worn_thing))
		return

	var/overlay_icon = worn_thing.mob_overlay_icon
	var/list/mannequin_overlays = list()
	//The consequences of coded sexual dimorphism.
	var/is_female = (gender == FEMALE ? TRUE : FALSE)
	var/clothing_layer
	var/fitting
	//If we run the sleeve formatting proc
	var/sleeves = FALSE
	switch(slot_worn_on)
		if(SLOT_MANNEQUIN_FEET)
			clothing_layer = SHOES_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/feet.dmi'
		if(SLOT_MANNEQUIN_GLOVES)
			sleeves = TRUE
			clothing_layer = GLOVES_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
		if(SLOT_MANNEQUIN_WRISTS)
			sleeves = TRUE
			clothing_layer = WRISTS_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
		if(SLOT_MANNEQUIN_ARMOR)
			sleeves = TRUE
			clothing_layer = ARMOR_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
		if(SLOT_MANNEQUIN_MASK)
			is_female = FALSE
			clothing_layer = MASK_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/masks.dmi'
		if(SLOT_MANNEQUIN_BELT)
			clothing_layer = BELT_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
		if(SLOT_MANNEQUIN_SHIRT)
			sleeves = TRUE
			clothing_layer = SHIRT_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
		if(SLOT_MANNEQUIN_PANTS)
			clothing_layer = PANTS_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
		if(SLOT_MANNEQUIN_HEAD)
			is_female = FALSE
			clothing_layer = HEAD_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
		if(SLOT_MANNEQUIN_NECK)
			is_female = FALSE
			clothing_layer = NECK_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/neck.dmi'
		if(SLOT_MANNEQUIN_CLOAK)
			sleeves = TRUE
			clothing_layer = CLOAK_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
		if(SLOT_MANNEQUIN_RING)
		//Rings are gendered, and most rings won't show up because there are currently a handful of ring onmob sprites.
			clothing_layer = RING_LAYER
			overlay_icon = 'icons/roguetown/clothing/onmob/rings.dmi'

	if(worn_thing.alternate_worn_layer)
		clothing_layer = worn_thing.alternate_worn_layer

	if(istype(worn_thing, /obj/item/clothing/pants))
		var/obj/item/clothing/pants/C = worn_thing
		fitting = C.fitted

	var/added_overlays = worn_thing.build_worn_icon(default_layer = clothing_layer, default_icon_file = overlay_icon, isinhands = FALSE, femaleuniform = fitting, coom = is_female)
	//Cloaks refuse to be shown behind the mannequin unless they are applied to the underlays.
	if(clothing_layer >= CLOAK_BEHIND_LAYER)
		underlays += added_overlays
	else
		mannequin_overlays += added_overlays
	if(sleeves)
		mannequin_overlays += MakeSleeveLayer(worn_thing, slot_worn_on)
	return mannequin_overlays

// Nightmare having to APPLY BODYPARTS TO THIS.
/obj/structure/mannequin/proc/bodypartsNightmare()
	return

/*
* The fact that the side profiles of
* things require a seperate icon
* is a nightmare. This proc forms the
* sleeve icons.
* taken from /mob/living/carbon/proc/get_sleeves_layer()
*/
/obj/structure/mannequin/proc/MakeSleeveLayer(obj/item/I, cloth_slot, layer2use = ARMORSLEEVE_LAYER, sleeveindex = 4)
	switch(cloth_slot)
		if(SLOT_MANNEQUIN_WRISTS)
			layer2use = WRISTSLEEVE_LAYER
		if(SLOT_MANNEQUIN_GLOVES)
			layer2use = GLOVESLEEVE_LAYER
		if(SLOT_MANNEQUIN_ARMOR)
			layer2use = ARMORSLEEVE_LAYER
		if(SLOT_MANNEQUIN_SHIRT)
			layer2use = SHIRTSLEEVE_LAYER
		if(SLOT_MANNEQUIN_CLOAK)
			layer2use = CLOAK_LAYER

	if(!cloth_slot)
		return
	if(!I)
		return
	var/list/sleeves = list()

	if(I.r_sleeve_status == SLEEVE_TORN || I.r_sleeve_status == SLEEVE_ROLLED)
		if(sleeveindex == 4 || sleeveindex == 2)
			sleeveindex -= 1
	if(I.l_sleeve_status == SLEEVE_TORN || I.l_sleeve_status == SLEEVE_ROLLED)
		if(sleeveindex == 4 || sleeveindex == 3)
			sleeveindex -= 2

	var/index = "[I.icon_state][gender == FEMALE ? "_f" : ""]"
	var/static/list/bloody_r = list()
	var/static/list/bloody_l = list()
	if(I.nodismemsleeves && sleeveindex) //armor pauldrons that show up above arms but don't get dismembered
		sleeveindex = 4

	//Right Sleeve
	if(sleeveindex == 2 || sleeveindex == 4 || !sleeveindex)
		sleeves += SleeveDetails(I, index, "r", layer2use, bloody_r, sleeveindex)
	//Left Sleeve
	if(sleeveindex == 3 || sleeveindex == 4 || !sleeveindex)
		sleeves += SleeveDetails(I, index, "l", layer2use, bloody_l, sleeveindex)

	return sleeves

// This code was run in MakeSleeveLayer() twice so im turning it into a proc.
/obj/structure/mannequin/proc/SleeveDetails(obj/item/I, the_index, left_right, layer_used, list/bloody_layer, sleeve_index)
	. = list()
	var/used = "[left_right]_[the_index]"
	if(!sleeve_index)
		used = "x[left_right]_[the_index]"
	var/mutable_appearance/sleeve_overlay = mutable_appearance(I.sleeved, used, layer=-layer_used)
	sleeve_overlay.color = I.color
	sleeve_overlay.alpha = I.alpha
	. += sleeve_overlay

	if(GET_ATOM_BLOOD_DNA_LENGTH(I))
		var/icon/blood_overlay = bloody_layer[used]
		if(!blood_overlay)
			blood_overlay = icon(I.sleeved, used)
			blood_overlay.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
			blood_overlay.Blend(icon(I.bloody_icon, I.bloody_icon_state), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
			bloody_layer[used] = fcopy_rsc(blood_overlay)
		var/mutable_appearance/pic = mutable_appearance(blood_overlay, layer=-layer_used)
		. += pic

//For dropping all clothing unless the mannequin is unchangeable.
/obj/structure/mannequin/proc/DropAll()
	if(unchangeable)
		return
	for(var/slot in clothing)
		MannequinUnequip(null, slot)

	update_appearance(UPDATE_OVERLAYS)

//For knocking the mannequin over whenever it is hit by a hostile.
/obj/structure/mannequin/proc/TipOver()
	playsound(src, 'sound/foley/dropsound/wooden_drop.ogg', 50, TRUE)
	density = FALSE
	tipped_over = TRUE
	DropAll()
	var/matrix/mat = transform
	transform = mat.Turn(90)

//For picking the mannequin back up off the floor
/obj/structure/mannequin/proc/StandUp(mob/living/L)
	//This is here to prevent mannequins from being stacked ontop of eachother.
	for(var/obj/structure/mannequin/O in get_turf(src))
		if(O.density && !O.tipped_over)
			return
	playsound(src, 'sound/foley/woodclimb.ogg', 50, TRUE)
	density = TRUE
	tipped_over = FALSE
	var/matrix/mat = transform
	transform = mat.Turn(-90)
	to_chat(L, "You pull [src] off the ground.")

/*
* Procs at creation or mapload. If no items_to_wear then it will equip
* the mannequin with whatever is in the mapping variables.
* Remember when equipping mannequin with a spawner to to create the
* items in the list with new /obj/whatever(src).
*/

/obj/structure/mannequin/proc/MapEquip(list/items_to_wear)
	if(items_to_wear?.len)
		for(var/slot in clothing)
			var/obj/item/O = items_to_wear[slot]
			if (O)
				clothing[slot] = O
				O.forceMove(src)
		return

	//There must be a better way to do this other than spawners.
	SpawnQuickEquip(mapping_pants, SLOT_MANNEQUIN_PANTS)
	SpawnQuickEquip(mapping_shirt, SLOT_MANNEQUIN_SHIRT)
	SpawnQuickEquip(mapping_shoes, SLOT_MANNEQUIN_FEET)
	SpawnQuickEquip(mapping_gloves, SLOT_MANNEQUIN_GLOVES)
	SpawnQuickEquip(mapping_wrists, SLOT_MANNEQUIN_WRISTS)
	SpawnQuickEquip(mapping_armor, SLOT_MANNEQUIN_ARMOR)
	SpawnQuickEquip(mapping_belt, SLOT_MANNEQUIN_BELT)
	SpawnQuickEquip(mapping_mask, SLOT_MANNEQUIN_MASK)
	SpawnQuickEquip(mapping_head, SLOT_MANNEQUIN_HEAD)
	SpawnQuickEquip(mapping_neck, SLOT_MANNEQUIN_NECK)
	SpawnQuickEquip(mapping_cloak, SLOT_MANNEQUIN_CLOAK)
	SpawnQuickEquip(mapping_ring, SLOT_MANNEQUIN_RING)

//For simplifying the MapEquip() proc.
/obj/structure/mannequin/proc/SpawnQuickEquip(obj/O, slot)
	if(!O || !slot)
		return
	var/obj/thing = new O(src)
	clothing[slot] = thing

/*
* UI formatting button that makes
* it greyed out if not empty.
*/
/obj/structure/mannequin/proc/makeStrippingButton(obj/item/I)
	if(!istype(I))
		return "<font color=grey>Empty</font>"
	else
		return I
/*
* A Little Explanation of Conversion Procs
* EquipHelper = [Aim Targeting] --> [Item Equip Slots]
* MannequinEquipHelper = [Aim Targeting] --> [Mannequin Equip Slots]
* PlacementDescriber = [Item Equip Slots] --> [Text Words]
*/

/*
* Translates the area targeted into a item
* equipment slot. The Male subtype has additional
* returns due to its additional limbs.
*/
/obj/structure/mannequin/proc/EquipHelper(target_zone)
	switch(target_zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_SKULL)
			return ITEM_SLOT_HEAD
		if(BODY_ZONE_PRECISE_NECK)
			return ITEM_SLOT_NECK
		if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return ITEM_SLOT_MASK
		if(SLOT_MANNEQUIN_CLOAK)
			return ITEM_SLOT_CLOAK
		if(BODY_ZONE_CHEST)
			return ITEM_SLOT_ARMOR
		if(BODY_ZONE_PRECISE_STOMACH)
			return ITEM_SLOT_SHIRT
		if(BODY_ZONE_PRECISE_GROIN)
			return ITEM_SLOT_BELT
		if(SLOT_MANNEQUIN_RING)
			return ITEM_SLOT_RING

/*
* Translates the item slot into a text
* so people know where they are placing it.
*/
/obj/structure/mannequin/proc/PlacementDescriber(target_zone)
	switch(target_zone)
		if(ITEM_SLOT_HEAD)
			return "head"
		if(ITEM_SLOT_CLOAK)
			return "shoulders"
		if(ITEM_SLOT_NECK)
			return "neck"
		if(ITEM_SLOT_MASK)
			return "face"
		if(ITEM_SLOT_ARMOR)
			return "chest"
		if(ITEM_SLOT_SHIRT)
			return "belly"
		if(ITEM_SLOT_BELT)
			return "crotch"
		if(ITEM_SLOT_RING)
			return "finger"
		if(ITEM_SLOT_PANTS)
			return "legs"
		if(ITEM_SLOT_GLOVES)
			return "hands"
		if(ITEM_SLOT_WRISTS)
			return "wrists"
		if(ITEM_SLOT_SHOES)
			return "feet"
	return "thing"

/*
* Translates target zone into mannequin equipment zone.
* The reason this doesnt have all equipment slots is because
* i ran out of bodyparts to target. The alternative was
* having a byond UI but i dont think the maintainer would
* want that.
*/
/obj/structure/mannequin/proc/MannequinEquipHelper(target_zone)
	switch(target_zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_SKULL)
			return SLOT_MANNEQUIN_HEAD
		if(BODY_ZONE_PRECISE_NECK)
			return SLOT_MANNEQUIN_NECK
		if(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return SLOT_MANNEQUIN_MASK
		if(SLOT_MANNEQUIN_CLOAK)
			return SLOT_MANNEQUIN_CLOAK
		if(BODY_ZONE_CHEST)
			return SLOT_MANNEQUIN_ARMOR
		if(BODY_ZONE_PRECISE_STOMACH)
			return SLOT_MANNEQUIN_SHIRT
		if(BODY_ZONE_PRECISE_GROIN)
			return SLOT_MANNEQUIN_BELT
		if(SLOT_MANNEQUIN_RING)
			return SLOT_MANNEQUIN_RING
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			return SLOT_MANNEQUIN_PANTS
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			return SLOT_MANNEQUIN_WRISTS
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			return SLOT_MANNEQUIN_GLOVES
		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return SLOT_MANNEQUIN_FEET

/obj/structure/mannequin/proc/MannequinSlotHelper(slots_flags)
	if(slots_flags & ITEM_SLOT_HEAD)
		return SLOT_MANNEQUIN_HEAD

	if(slots_flags & ITEM_SLOT_NECK)
		return SLOT_MANNEQUIN_CLOAK

	if(slots_flags & ITEM_SLOT_MASK)
		return SLOT_MANNEQUIN_MASK

	if(slots_flags & ITEM_SLOT_ARMOR)
		return SLOT_MANNEQUIN_ARMOR

	if(slots_flags & ITEM_SLOT_SHIRT)
		return SLOT_MANNEQUIN_SHIRT

	if(slots_flags & ITEM_SLOT_BELT)
		return SLOT_MANNEQUIN_BELT

	if(slots_flags & ITEM_SLOT_PANTS)
		return SLOT_MANNEQUIN_PANTS

	if(slots_flags & ITEM_SLOT_GLOVES)
		return SLOT_MANNEQUIN_GLOVES

	if(slots_flags & ITEM_SLOT_SHOES)
		return SLOT_MANNEQUIN_FEET

////Subtypes/////
/obj/structure/mannequin/male
	name = "mannequin"
	desc = "It's unsettlingly still."
	icon_state = "man"

/*
* Decorative Mannequins cannot be equipped
* or unequipped of their clothing.
*/
/obj/structure/mannequin/male/decorative
	name = "decorative display"
	desc = "Due to magic or fragile material the clothing on this one cannot be taken off."
	unchangeable = TRUE

/obj/structure/mannequin/male/female
	name = "mannequin"
	icon_state = "woman"
	gender = FEMALE

/*
* Allows mannequins to wear pants,
* gloves, and shoes.
*/
/obj/structure/mannequin/male/EquipHelper(target_zone)
	switch(target_zone)
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			return ITEM_SLOT_PANTS
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			return ITEM_SLOT_WRISTS
		if(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
			return ITEM_SLOT_GLOVES
		if(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT)
			return ITEM_SLOT_SHOES
	return ..()

/obj/structure/mannequin/male/EquippableSlots()
	. = ..()
	. += "<BR><B>Wrists:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_L_ARM]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_WRISTS])]</A>"
	. += "<BR><B>Gloves:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_PRECISE_L_HAND]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_GLOVES])]</A>"
	. += "<BR><B>Pants:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_L_LEG]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_PANTS])]</A>"
	. += "<BR><B>Shoes:</B> <A href='byond://?src=[REF(src)];command=item_placement;item_slot=[BODY_ZONE_PRECISE_L_FOOT]'>[makeStrippingButton(clothing[SLOT_MANNEQUIN_FEET])]</A>"

/obj/structure/mannequin/male/bodypartsNightmare()
	var/isfemale = (gender == FEMALE ? "f" : "m")
	var/mutable_appearance/bodyparts = mutable_appearance('icons/obj/mannequin.dmi', "mannequin_arms[isfemale]", -HANDS_PART_LAYER)

	return bodyparts

#undef SLOT_MANNEQUIN_SHIRT
#undef SLOT_MANNEQUIN_FEET
#undef SLOT_MANNEQUIN_GLOVES
#undef SLOT_MANNEQUIN_WRISTS
#undef SLOT_MANNEQUIN_ARMOR
#undef SLOT_MANNEQUIN_CLOAK
#undef SLOT_MANNEQUIN_NECK
#undef SLOT_MANNEQUIN_BELT
#undef SLOT_MANNEQUIN_RING
#undef SLOT_MANNEQUIN_MASK
#undef SLOT_MANNEQUIN_HEAD
#undef SLOT_MANNEQUIN_PANTS
