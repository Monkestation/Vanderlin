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
 * Called at the start of the equip proc
 *
 * Override to change the value of the slots depending on client prefs, species and
 * other such sources of change
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overridden for customization depending on client prefs,species etc
	return

/**
 * Called after the equip proc has finished
 *
 * All items are on the mob at this point, use this proc to toggle internals
 * fiddle with id bindings and accesses etc
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overridden for toggling internals, id binding, access etc
	return

/**
 * Equips all defined types and paths to the mob passed in
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	pre_equip(H, visualsOnly)

	if(belt)
		H.equip_to_slot_or_del(new belt(H),SLOT_BELT, TRUE)
	if(gloves)
		H.equip_to_slot_or_del(new gloves(H),SLOT_GLOVES, TRUE)
	if(shoes)
		H.equip_to_slot_or_del(new shoes(H),SLOT_SHOES, TRUE)
	if(head)
		H.equip_to_slot_or_del(new head(H),SLOT_HEAD, TRUE)
	if(mask)
		H.equip_to_slot_or_del(new mask(H),SLOT_WEAR_MASK, TRUE)
	if(neck)
		H.equip_to_slot_or_del(new neck(H),SLOT_NECK, TRUE)
	if(ring)
		H.equip_to_slot_or_del(new ring(H),SLOT_RING, TRUE)
	if(wrists)
		H.equip_to_slot_or_del(new wrists(H),SLOT_WRISTS, TRUE)
	if(cloak)
		H.equip_to_slot_or_del(new cloak(H),SLOT_CLOAK, TRUE)
	if(beltl)
		H.equip_to_slot_or_del(new beltl(H),SLOT_BELT_L, TRUE)
	if(beltr)
		H.equip_to_slot_or_del(new beltr(H),SLOT_BELT_R, TRUE)
	if(backr)
		H.equip_to_slot_or_del(new backr(H),SLOT_BACK_R, TRUE)
	if(backl)
		H.equip_to_slot_or_del(new backl(H),SLOT_BACK_L, TRUE)
	if(mouth)
		H.equip_to_slot_or_del(new mouth(H),SLOT_MOUTH, TRUE)
	if(undershirt)
		H.undershirt = initial(undershirt.name)
	if(pants)
		H.equip_to_slot_or_del(new pants(H),SLOT_PANTS, TRUE)
	if(armor)
		H.equip_to_slot_or_del(new armor(H),SLOT_ARMOR, TRUE)
	if(shirt)
		H.equip_to_slot_or_del(new shirt(H),SLOT_SHIRT, TRUE)
	if(accessory)
		var/obj/item/clothing/pants/U = H.wear_pants
		if(U)
			U.attach_accessory(new accessory(H))
		else
			WARNING("Unable to equip accessory [accessory] in outfit [name]. No uniform present!")

	if(!visualsOnly)
		if(l_hand)
	//		H.put_in_hands(new l_hand(get_turf(H)),TRUE)
			H.equip_to_slot_or_del(new l_hand(H),SLOT_HANDS, TRUE)
		if(r_hand)
		//	H.put_in_hands(new r_hand(get_turf(H)),TRUE)
			H.equip_to_slot_or_del(new r_hand(H),SLOT_HANDS, TRUE)

	if(!visualsOnly) // Items in pockets or backpack don't show up on mob's icon.
		if(backpack_contents)
			for(var/path in backpack_contents)
				var/number = backpack_contents[path]
				if(!isnum(number))//Default to 1
					number = 1
				for(var/i in 1 to number)
					var/obj/item/new_item = new path(H)
					var/obj/item/item = H.get_item_by_slot(SLOT_BACK_L)
					if(!item)
						item = H.get_item_by_slot(SLOT_BACK_R)
					if(!item || !SEND_SIGNAL(item, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
						item = H.get_item_by_slot(SLOT_BACK_R)
						if(!item || !SEND_SIGNAL(item, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
							item = H.get_item_by_slot(SLOT_BELT)
							if(!item || !SEND_SIGNAL(item, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
								new_item.forceMove(get_turf(H))
								message_admins("[type] had backpack_contents set but no room to store:[new_item]")


	post_equip(H, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(H)

	H.update_body()
	return TRUE

/client/proc/test_spawn_outfits()
	for(var/path in subtypesof(/datum/outfit/job))
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
	if(H.ears)
		H.ears.add_fingerprint(H,1)
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
	.["shoes"] = shoes

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
	shoes = text2path(outfit_data["shoes"])
	return TRUE
