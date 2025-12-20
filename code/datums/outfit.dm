/**
 * # Outfit datums
 *
 * This is a clean system of applying outfits to mobs, if you need to equip someone in a uniform
 * this is the way to do it cleanly and properly.
 *
 * You can also specify an outfit datum on a job to have it auto equipped to the mob on join
 *
 * /mob/living/carbon/human/proc/equipOutfit(outfit) is the mob level proc to equip an outfit
 * and you pass it the relevant datum outfit
 *
 * outfits can also be saved as json blobs downloadable by a client and then can be uploaded
 * by that user to recreate the outfit, this is used by admins to allow for custom event outfits
 * that can be restored at a later date
 */
/datum/outfit
	///Name of the outfit (shows up in the equip admin verb)
	var/name = "Naked"

	/// Id for outfits,it is used with the Custom Outfits Glob.
	var/id

	/// Type path of item to go in suit slot
	var/suit = null

	/// Type path of item to go in belt slot
	var/belt = null

	/// Type path of item to go in gloves slot
	var/gloves = null

	/// Type path of item to go in shoes slot
	var/shoes = null

	/// Type path of item to go in head slot
	var/head = null

	/// Type path of item to go in mask slot
	var/mask = null

	/// Type path of item to go in neck slot
	var/neck = null

	/// Type path of item to go in the glasses slot
	var/glasses = null

	/// Type path of item to go in the idcard slot
	var/wrists = null

	/// Type path of item for left pocket slot
	var/l_pocket = null

	/// Type path of item for right pocket slot
	var/r_pocket = null

	var/beltr = null

	var/beltl = null

	var/backr = null

	var/backl = null

	var/cloak = null

	var/shirt = null

	var/mouth = null

	var/pants = null

	var/armor = null

	var/ring = null

	///Type path of item to go in the right hand
	var/r_hand = null

	//Type path of item to go in left hand
	var/l_hand = null

	/// Should the toggle helmet proc be called on the helmet during equip
	var/toggle_helmet = TRUE

	/**
	 * list of items that should go in the backpack of the user
	 *
	 * Format of this list should be: list(path=count,otherpath=count)
	 */
	var/list/backpack_contents = null

	/// Any undershirt. While on humans it is a string, here we use paths to stay consistent with the rest of the equips.
	var/datum/sprite_accessory/undershirt = null

	/// Any clothing accessory item
	var/accessory = null

	/// Set to FALSE if your outfit requires runtime parameters
	var/can_be_admin_equipped = TRUE

	/**
	 * extra types for chameleon outfit changes, mostly guns
	 *
	 * Format of this list is (typepath, typepath, typepath)
	 *
	 * These are all added and returns in the list for get_chamelon_diguise_info proc
	 */
	var/list/chameleon_extras

	/**
	  * The sheaths this job should start with
	  *
	  * Format of this list is (typepath, typepath, typepath)
	  */
	var/list/scabbards = null

/**
 * Called at the start of the equip proc
 *
 * Override to change the value of the slots depending on client prefs, species and
 * other such sources of change
 *
 * Extra Arguments
 * * visuals_only true if this is only for display (in the character setup screen)
 *
 * If visuals_only is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	//to be overridden for customization depending on client prefs,species etc
	return

/datum/outfit/proc/map_override(mob/living/carbon/human/H, visuals_only = FALSE)
	return

/**
 * Called after the equip proc has finished
 *
 * All items are on the mob at this point, use this proc to toggle internals
 * fiddle with id bindings and accesses etc
 *
 * Extra Arguments
 * * visuals_only true if this is only for display (in the character setup screen)
 *
 * If visuals_only is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	//to be overridden for toggling internals, id binding, access etc
	return

/**
 * Equips all defined types and paths to the mob passed in
 *
 * Extra Arguments
 * * visuals_only true if this is only for display (in the character setup screen)
 *
 * If visuals_only is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/equip(mob/living/carbon/human/H, visuals_only = FALSE)
	pre_equip(H, visuals_only)
	map_override(H, visuals_only)

	if(belt)
		H.equip_to_slot_or_del(new belt(H),ITEM_SLOT_BELT, TRUE)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),ITEM_SLOT_GLOVES, TRUE)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),ITEM_SLOT_SHOES, TRUE)
	if(head)
		H.equip_to_slot_or_del(new head(H),ITEM_SLOT_HEAD, TRUE)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),ITEM_SLOT_MASK, TRUE)
	if(neck)
		H.equip_to_slot_or_del(new neck(H),ITEM_SLOT_NECK, TRUE)
	if(ring)
		H.equip_to_slot_or_del(new ring(H),ITEM_SLOT_RING, TRUE)
	if(wrists)
		H.equip_to_slot_or_del(new wrists(H),ITEM_SLOT_WRISTS, TRUE)
	if(cloak)
		H.equip_to_slot_or_del(new cloak(H),ITEM_SLOT_CLOAK, TRUE)
	if(beltl)
		H.equip_to_slot_or_del(new beltl(H),ITEM_SLOT_BELT_L, TRUE)
	if(beltr)
		H.equip_to_slot_or_del(new beltr(H),ITEM_SLOT_BELT_R, TRUE)
	if(backr)
		H.equip_to_slot_or_del(new backr(H),ITEM_SLOT_BACK_R, TRUE)
	if(backl)
		H.equip_to_slot_or_del(new backl(H),ITEM_SLOT_BACK_L, TRUE)
	if(mouth)
		H.equip_to_slot_or_del(new mouth(H),ITEM_SLOT_MOUTH, TRUE)
	if(undershirt)
		H.undershirt = initial(undershirt.name)
	if(pants)
		H.equip_to_slot_or_del(new pants(H),ITEM_SLOT_PANTS, TRUE)
	if(armor)
		H.equip_to_slot_or_del(new armor(H),ITEM_SLOT_ARMOR, TRUE)
	if(shirt)
		H.equip_to_slot_or_del(new shirt(H),ITEM_SLOT_SHIRT, TRUE)
	if(accessory)
		var/obj/item/clothing/pants/U = H.wear_pants
		if(U)
			U.attach_accessory(new accessory(H))
		else
			WARNING("Unable to equip accessory [accessory] in outfit [name]. No uniform present!")

	if(!visuals_only)
		if(l_hand)
	//		H.put_in_hands(new l_hand(get_turf(H)),TRUE)
			H.equip_to_slot_or_del(new l_hand(H),ITEM_SLOT_HANDS, TRUE)
		if(r_hand)
		//	H.put_in_hands(new r_hand(get_turf(H)),TRUE)
			H.equip_to_slot_or_del(new r_hand(H),ITEM_SLOT_HANDS, TRUE)
		if(scabbards)
			var/list/copied_scabbards = scabbards.Copy()
			for(var/obj/item/item as anything in H.get_equipped_items())
				if(!length(copied_scabbards))
					break
				var/slot = H.get_slot_by_item(item)
				for(var/obj/item/weapon/scabbard/scabbard_path as anything in copied_scabbards)
					var/obj/item/weapon/scabbard/scabbard = new scabbard_path()
					if(SEND_SIGNAL(scabbard, COMSIG_TRY_STORAGE_INSERT, item, null, TRUE, FALSE))
						H.temporarilyRemoveItemFromInventory(item, TRUE)
						H.equip_to_slot_or_del(scabbard, slot, TRUE)
						copied_scabbards -= scabbard_path
						break

	if(!visuals_only) // Items in pockets or backpack don't show up on mob's icon.
		if(backpack_contents)
			for(var/path in backpack_contents)
				var/number = backpack_contents[path]
				if(!isnum(number))//Default to 1
					number = 1
				for(var/i in 1 to number)
					var/obj/item/new_item = new path(H)
					var/obj/item/item = H.get_item_by_slot(ITEM_SLOT_BACK_L)
					if(!item)
						item = H.get_item_by_slot(ITEM_SLOT_BACK_R)
					if(!item || !attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
						item = H.get_item_by_slot(ITEM_SLOT_BACK_R)
						if(!item || !attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
							item = H.get_item_by_slot(ITEM_SLOT_BELT)
							if(!item || !attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
								item = H.get_item_by_slot(ITEM_SLOT_NECK)
								if(!item || !attempt_insert_with_flipping(item, new_item, null, TRUE, TRUE))
									new_item.forceMove(get_turf(H))
									message_admins("[type] had backpack_contents set but no room to store:[new_item]")


	post_equip(H, visuals_only)

	if(!visuals_only)
		apply_fingerprints(H)

	H.update_body()
	return TRUE

/datum/outfit/proc/attempt_insert_with_flipping(obj/item/storage_item, obj/item/object_to_insert, mob/living/carbon/human/H, silent, force)
	var/success = FALSE
	success = SEND_SIGNAL(storage_item, COMSIG_TRY_STORAGE_INSERT, object_to_insert, H, silent, force)
	if(!success)
		object_to_insert.inventory_flip()
		success = SEND_SIGNAL(storage_item, COMSIG_TRY_STORAGE_INSERT, object_to_insert, H, silent, force)
	return success

/client/proc/test_spawn_outfits()
	for(var/path in subtypesof(/datum/outfit))
		var/mob/living/carbon/human/new_human = new(mob.loc)
		var/datum/outfit/new_outfit = new path()
		new_outfit.equip(new_human)
/**
 * Apply a fingerprint from the passed in human to all items in the outfit
 *
 * Used for forensics setup when the mob is first equipped at roundstart
 * essentially calls add_fingerprint to every defined item on the human
 *
 */
/datum/outfit/proc/apply_fingerprints(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.wear_ring)
		H.wear_ring.add_fingerprint(H,1)
	if(H.wear_pants)
		H.wear_pants.add_fingerprint(H,1)
	if(H.wear_armor)
		H.wear_armor.add_fingerprint(H,1)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H,1)
	if(H.wear_neck)
		H.wear_neck.add_fingerprint(H,1)
	if(H.head)
		H.head.add_fingerprint(H,1)
	if(H.shoes)
		H.shoes.add_fingerprint(H,1)
	if(H.gloves)
		H.gloves.add_fingerprint(H,1)
	if(H.belt)
		H.belt.add_fingerprint(H,1)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H,1)
	for(var/obj/item/I in H.held_items)
		I.add_fingerprint(H,1)
	return 1

/// Return a list of all the types that are required to disguise as this outfit type
/datum/outfit/proc/get_chameleon_disguise_info()
	var/list/types = list(suit, belt, gloves, shoes, head, mask, neck, glasses, ring, l_pocket, r_pocket, r_hand, l_hand)
	types += chameleon_extras
	listclearnulls(types)
	return types

/// Return a json list of this outfit
/datum/outfit/proc/get_json_data()
	. = list()
	.["outfit_type"] = type
	.["name"] = name
	.["head"] = head
	.["mask"] = mask
	.["neck"] = neck
	.["cloak"] = cloak
	.["backl"] = backl
	.["backr"] = backr
	.["ring"] = ring
	.["wrists"] = wrists
	.["gloves"] = gloves
	.["shirt"] = shirt
	.["armor"] = armor
	.["pants"] = pants
	.["belt"] = belt
	.["beltl"] = beltl
	.["beltr"] = beltr
	.["shoes"] = shoes
	.["scabbards"] = scabbards
	.["id"] = id
	if(length(scabbards))
		var/list/scabbard_text = list()
		for(var/path in scabbards)
			scabbard_text += "[path]"
		.["scabbards"] = scabbard_text
	else
		.["scabbards"] = list()

/// Prompt the passed in mob client to download this outfit as a json blob
/datum/outfit/proc/save_to_file(mob/admin)
	var/stored_data = get_json_data()
	var/json = json_encode(stored_data)
	//Kinda annoying but as far as i can tell you need to make actual file.
	var/f = file("data/TempOutfitUpload")
	fdel(f)
	WRITE_FILE(f,json)
	admin << ftp(f,"[name].json")

/// Create an outfit datum from a list of json data
/datum/outfit/proc/load_from(list/outfit_data)
	//This could probably use more strict validation

	name = outfit_data["name"]
	head = text2path(outfit_data["head"])
	mask = text2path(outfit_data["mask"])
	neck = text2path(outfit_data["neck"])
	cloak = text2path(outfit_data["cloak"])
	backl = text2path(outfit_data["backl"])
	backr = text2path(outfit_data["backr"])
	ring = text2path(outfit_data["ring"])
	wrists = text2path(outfit_data["wrists"])
	gloves = text2path(outfit_data["gloves"])
	shirt = text2path(outfit_data["shirt"])
	armor = text2path(outfit_data["armor"])
	pants = text2path(outfit_data["pants"])
	belt = text2path(outfit_data["belt"])
	beltl = text2path(outfit_data["beltl"])
	beltr = text2path(outfit_data["beltr"])
	shoes = text2path(outfit_data["shoes"])
	id = outfit_data["id"]
	var/list/scabbard_list = outfit_data["scabbards"]
	if(islist(scabbard_list))
		for(var/scabbard_path in scabbard_list)
			var/path = text2path(scabbard_path)
			if(path)
				LAZYADD(scabbards, path)

	return TRUE
