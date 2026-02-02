/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Cigarette Box
 *		Cigar Case
 *		Heart Shaped Box w/ Chocolates
 */

/obj/item/storage/fancy
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox6"
	base_icon_state = "donutbox"
	resistance_flags = FLAMMABLE
	/// Used by examine to report what this thing is holding.
	var/contents_tag = "errors"
	/// What type of thing to fill this storage with.
	var/spawn_type = null
	/// Whether the container is open or not
	var/is_open = FALSE

/obj/item/storage/fancy/populate_contents()
	if(!spawn_type)
		return ..()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, spawn_type)

/obj/item/storage/fancy/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][is_open ? contents.len : null]"

/obj/item/storage/fancy/examine(mob/user)
	. = ..()
	if(!is_open)
		return
	if(!contents_tag)
		return
	if(length(contents) == 1)
		. += "There is one [contents_tag] left."
	else
		. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] [contents_tag]s left."

/obj/item/storage/fancy/attack_self(mob/user, list/modifiers)
	. = ..()
	is_open = !is_open
	update_appearance(UPDATE_ICON)

/obj/item/storage/fancy/Exited()
	. = ..()
	is_open = TRUE
	update_appearance(UPDATE_ICON)

/obj/item/storage/fancy/Entered()
	. = ..()
	is_open = TRUE
	update_appearance(UPDATE_ICON)

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	name = "egg box"
	desc = "A carton for holding eggs."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "eggbox"
	base_icon_state = "eggbox"
	item_state = "eggbox"
	contents_tag = "egg"
	spawn_type = /obj/item/reagent_containers/food/snacks/egg

/obj/item/storage/fancy/egg_box/Initialize(mapload, ...)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 12
	STR.set_holdable(list(/obj/item/reagent_containers/food/snacks/egg))

/*
 * Candle Box
 */

/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = ""
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	base_icon_state = "candlebox"
	item_state = "candlebox5"
	contents_tag = "candle"
	throwforce = 2
	slot_flags = ITEM_SLOT_HIP
	spawn_type = /obj/item/candle
	is_open = TRUE

/obj/item/storage/fancy/candle_box/Initialize(mapload, ...)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 5

/obj/item/storage/fancy/candle_box/attack_self(mob_user)
	return

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "\improper Space Cigarettes packet"
	desc = ""
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	base_icon_state = "cig"
	item_state = "cigpacket"
	contents_tag = "cigarette"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	spawn_type = /obj/item/clothing/face/cigarette/rollie/nicotine
	var/candy = FALSE //for cigarette overlay

/obj/item/storage/fancy/cigarettes/Initialize(mapload, ...)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.set_holdable(list(/obj/item/clothing/face/cigarette, /obj/item/lighter))

/obj/item/storage/fancy/cigarettes/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to extract contents.</span>"

/obj/item/storage/fancy/cigarettes/AltClick(mob/living/carbon/user, list/modifiers)
	if(!istype(user) || !user.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
		return
	var/obj/item/clothing/face/cigarette/cig = locate() in contents
	if(!cig)
		to_chat(user, "<span class='notice'>There are no [contents_tag]s left in the pack.</span>")
		return
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, cig, user)
	user.put_in_hands(cig)
	contents -= cig
	to_chat(user, "<span class='notice'>You take \a [cig] out of the pack.</span>")

/obj/item/storage/fancy/cigarettes/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][contents.len ? null : "_empty"]"

/obj/item/storage/fancy/cigarettes/update_overlays()
	. = ..()
	if(!is_open && !length(contents))
		return
	. += "[icon_state]_open"
	var/cig_position = 1
	for(var/obj/item/C as anything in contents)
		var/mutable_appearance/inserted_overlay = mutable_appearance(icon)

		if(istype(C, /obj/item/lighter/greyscale))
			inserted_overlay.icon_state = "lighter_in"
		else if(istype(C, /obj/item/lighter))
			inserted_overlay.icon_state = "zippo_in"
		else if(candy)
			inserted_overlay.icon_state = "candy"
		else
			inserted_overlay.icon_state = "cigarette"

		inserted_overlay.icon_state = "[inserted_overlay.icon_state]_[cig_position]"
		. += inserted_overlay
		cig_position++

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/target, mob/living/carbon/user, list/modifiers)
	if(!istype(target))
		return

	var/obj/item/clothing/face/cigarette/cig = locate() in contents
	if(!cig)
		to_chat(user, "<span class='notice'>There are no [contents_tag]s left in the pack.</span>")
		return
	if(target != user || !contents.len || user.mouth)
		return ..()

	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_TAKE, cig, target)
	target.equip_to_slot_if_possible(cig, ITEM_SLOT_MOUTH)
	contents -= cig
	to_chat(user, "<span class='notice'>You take \a [cig] out of the pack.</span>")

/obj/item/storage/fancy/cigarettes/zig
	name = "zigbox"
	desc = ""
	icon_state = "zig"
	base_icon_state = "zig"
	contents_tag = "zig"
	spawn_type = /obj/item/clothing/face/cigarette/rollie/nicotine
	component_type = /datum/component/storage/concrete/grid/zigbox

/obj/item/storage/fancy/cigarettes/zig/empty
	spawn_type = null
