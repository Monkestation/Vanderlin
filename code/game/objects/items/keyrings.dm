/////////////////// KEYRING ////////////////////

/obj/item/storage/keyring
	name = "keyring"
	desc = "A circular ring of metal for hooking additional rings."
	icon_state = "keyring0"
	icon = 'icons/roguetown/items/keys.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_MOUTH|ITEM_SLOT_WRISTS
	experimental_inhand = FALSE
	dropshrink = 0.7
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	component_type = /datum/component/storage/concrete/grid/keyring
	var/list/keys = list() //Used to generate starting keys on initialization, check contents instead for actual keys
	var/list/combined_access

/obj/item/storage/keyring/Initialize()
	. = ..()
	if(!length(keys))
		return
	if(length(keys) > 10)
		stack_trace("Keyring [src] has too many keys and the list will get cut short!")
	for(var/X as anything in keys)
		var/obj/item/key/new_key = new X(loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_key, null, TRUE, FALSE))
			qdel(new_key)
		LAZYREMOVE(keys, X)

	update_appearance(UPDATE_ICON_STATE | UPDATE_DESC)

/obj/item/storage/keyring/update_icon_state()
	icon_state = "keyring[clamp(length(contents), 0, 5)]"
	return ..()

/obj/item/storage/keyring/update_desc()
	if(!length(contents))
		desc = initial(desc)
		return
	desc = span_info("Holds \Roman[length(contents)] key\s, including:")
	for(var/obj/item/key/KE in contents)
		desc += span_info("\n- [KE.name ? "\A [KE.name]." : "An unknown key."]")
	return ..()

/obj/item/storage/keyring/proc/refresh_keys()
	LAZYCLEARLIST(combined_access)

	if(!length(contents))
		return

	LAZYINITLIST(combined_access)

	for(var/obj/item/key/K in contents)
		if(!length(K.lockids))
			continue

		combined_access |= K.get_access()

/obj/item/storage/keyring/get_access()
	if(LAZYLEN(combined_access))
		return combined_access.Copy()
	return null

/obj/item/storage/keyring/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_appearance(UPDATE_ICON_STATE | UPDATE_DESC)
	refresh_keys()

/obj/item/storage/keyring/Exited(atom/movable/gone, direction)
	. = ..()
	update_appearance(UPDATE_ICON_STATE | UPDATE_DESC)
	refresh_keys()

/obj/item/storage/keyring/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
"sx" = -6,
"sy" = -3,
"nx" = 13,
"ny" = -3,
"wx" = -2,
"wy" = -3,
"ex" = 4,
"ey" = -5,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 15,
"sturn" = 0,
"wturn" = 0,
"eturn" = 39,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/lockpickring
	name = "lockpickring"
	desc = "A piece of bent wire to store lockpicking tools. Too bulky for fine work."
	icon_state = "pickring0"
	icon = 'icons/roguetown/items/keys.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0
	throwforce = 0
	var/list/picks = list()
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_MOUTH|ITEM_SLOT_WRISTS
	experimental_inhand = FALSE
	dropshrink = 0.7
	var/how_many_lockpicks = 9

/obj/item/lockpickring/Initialize()
	. = ..()
	if(picks.len)
		for(var/X in picks)
			addtoring(new X())
			picks -= X

/obj/item/lockpickring/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
"sx" = -6,
"sy" = -3,
"nx" = 13,
"ny" = -3,
"wx" = -2,
"wy" = -3,
"ex" = 4,
"ey" = -5,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 15,
"sturn" = 0,
"wturn" = 0,
"eturn" = 39,
"nflip" = 8,
"sflip" = 0,
"wflip" = 0,
"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/lockpickring/proc/addtoring(obj/item/I)
	if(!I || !istype(I))
		return 0
	I.loc = src
	picks += I
	update_appearance(UPDATE_ICON_STATE | UPDATE_DESC)

/obj/item/lockpickring/proc/removefromring(mob/user)
	if(!picks.len)
		return
	var/obj/item/lockpick/K = picks[picks.len]
	picks -= K
	K.loc = user.loc
	update_appearance(UPDATE_ICON_STATE | UPDATE_DESC)
	return K

/obj/item/lockpickring/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I,/obj/item/lockpick))
		if(picks.len >= how_many_lockpicks)
			to_chat(user, span_warning("Too many lockpicks."))
			return
		user.dropItemToGround(I)
		addtoring(I)
	else
		return ..()

/obj/item/lockpickring/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(length(picks))
		to_chat(user, span_notice("I steal a pick off the ring."))
		var/obj/item/lockpick/K = removefromring(user)
		user.put_in_active_hand(K)
	else
		to_chat(user, span_notice("No picks."))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/lockpickring/update_icon_state()
	icon_state = "pickring[clamp(length(contents), 0, 3)]"
	return ..()

/obj/item/lockpickring/update_desc()
	if(!length(contents))
		desc = initial(desc)
		return
	desc = span_info("\Roman[length(contents)] lockpick\s.")
	return ..()

/obj/item/lockpickring/mundane
	picks = list(/obj/item/lockpick, /obj/item/lockpick, /obj/item/lockpick)

/obj/item/storage/keyring/captain
	keys = list(/obj/item/key/captain, /obj/item/key/dungeon, /obj/item/key/garrison, /obj/item/key/lieutenant, /obj/item/key/forrestgarrison, /obj/item/key/atarms, /obj/item/key/walls, /obj/item/key/manor, /obj/item/key/guest)

/obj/item/storage/keyring/consort
	keys = list(/obj/item/key/dungeon, /obj/item/key/atarms, /obj/item/key/walls, /obj/item/key/manor, /obj/item/key/consort, /obj/item/key/guest)

/obj/item/storage/keyring/guard
	keys = list(/obj/item/key/garrison)

/obj/item/storage/keyring/lieutenant
	keys = list(/obj/item/key/garrison, /obj/item/key/lieutenant)

/obj/item/storage/keyring/manorguard
	keys = list(/obj/item/key/manor, /obj/item/key/dungeon, /obj/item/key/atarms, /obj/item/key/walls)

/obj/item/storage/keyring/archivist
	keys = list(/obj/item/key/archive, /obj/item/key/manor)

/obj/item/storage/keyring/merchant
	keys = list(/obj/item/key/merchant, /obj/item/key/mercenary, /obj/item/key/warehouse)

/obj/item/storage/keyring/mage
	keys = list(/obj/item/key/manor, /obj/item/key/tower, /obj/item/key/mage)

/obj/item/storage/keyring/mageapprentice
	keys = list(/obj/item/key/manor, /obj/item/key/tower)

/obj/item/storage/keyring/innkeep
	keys = list(/obj/item/key/tavern, /obj/item/key/roomhunt, /obj/item/key/medroomiv, /obj/item/key/medroomiii, /obj/item/key/medroomii, /obj/item/key/medroomi, /obj/item/key/luxroomiv, /obj/item/key/luxroomiii, /obj/item/key/luxroomii, /obj/item/key/luxroomi)

/obj/item/storage/keyring/priest
	keys = list(/obj/item/key/priest, /obj/item/key/church, /obj/item/key/graveyard)

/obj/item/storage/keyring/inquisitor
	keys = list(/obj/item/key/inquisition)

/obj/item/storage/keyring/adept
	keys = list(/obj/item/key/inquisition)

/obj/item/storage/keyring/gravetender
	keys = list(/obj/item/key/church, /obj/item/key/graveyard)

/obj/item/storage/keyring/hand
	keys = list(/obj/item/key/hand, /obj/item/key/manor, /obj/item/key/steward, /obj/item/key/church, /obj/item/key/merchant, /obj/item/key/dungeon, /obj/item/key/walls, /obj/item/key/garrison, /obj/item/key/forrestgarrison, /obj/item/key/atarms)

/obj/item/storage/keyring/steward
	keys = list(/obj/item/key/steward, /obj/item/key/vault, /obj/item/key/manor, /obj/item/key/warehouse)

/obj/item/storage/keyring/dungeoneer
	keys = list(/obj/item/key/dungeon, /obj/item/key/manor, /obj/item/key/walls, /obj/item/key/atarms)

/obj/item/storage/keyring/butler
	keys = list(/obj/item/key/manor, /obj/item/key/guest, /obj/item/key/atarms)

/obj/item/storage/keyring/jester
	keys = list(/obj/item/key/manor, /obj/item/key/atarms, /obj/item/key/walls)

/obj/item/storage/keyring/physician
	keys = list(/obj/item/key/manor, /obj/item/key/atarms, /obj/item/key/dungeon, /obj/item/key/courtphys)

/obj/item/storage/keyring/elder
	keys = list(/obj/item/key/veteran, /obj/item/key/walls, /obj/item/key/elder, /obj/item/key/butcher, /obj/item/key/soilson, /obj/item/key/manor)

/obj/item/storage/keyring/clinic
	keys = list(/obj/item/key/feldsher, /obj/item/key/clinic, /obj/item/key/bathhouse, /obj/item/key/apothecary)

/obj/item/storage/keyring/clinicapprentice
	keys = list(/obj/item/key/clinic, /obj/item/key/bathhouse)

/obj/item/storage/keyring/artificer
	keys = list(/obj/item/key/artificer, /obj/item/key/blacksmith, /obj/item/key/miner)

/obj/item/storage/keyring/veteran
	keys = list(/obj/item/key/veteran, /obj/item/key/dungeon, /obj/item/key/garrison, /obj/item/key/atarms, /obj/item/key/walls, /obj/item/key/elder, /obj/item/key/butcher, /obj/item/key/soilson, /obj/item/key/manor)

/obj/item/storage/keyring/stevedore
	keys = list(/obj/item/key/warehouse, /obj/item/key/merchant)

/obj/item/storage/keyring/gaffer
	keys = list(/obj/item/key/gaffer, /obj/item/key/mercenary, /obj/item/key/mercenary, /obj/item/key/mercenary, /obj/item/key/mercenary)

/obj/item/storage/keyring/master_of_crafts_and_labor
	keys = list(/obj/item/key/elder, /obj/item/key/blacksmith,/obj/item/key/tailor,/obj/item/key/tavern,/obj/item/key/apothecary, /obj/item/key/butcher, /obj/item/key/soilson,/obj/item/key/artificer,/obj/item/key/clinic)

/obj/item/storage/keyring/gaffer_assistant
	keys = list(/obj/item/key/gaffer, /obj/item/key/mercenary)
