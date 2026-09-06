GLOBAL_VAR_INIT(pocket_portal, null)

/obj/structure/pocket_portal
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	icon_state = "obelisk"
	pixel_x = -16
	density = FALSE
	anchored = TRUE
	max_integrity = INTEGRITY_UNBREAKABLE

	var/list/mob_exit_point = list()

/obj/structure/pocket_portal/Initialize()
	. = ..()
	GLOB.pocket_portal = src

/obj/structure/pocket_portal/Destroy()
	. = ..()
	GLOB.pocket_portal = null

/obj/structure/pocket_portal/attack_hand(mob/living/user)
	. = ..()
	var/atom/output = pick(mob_exit_point)
	if(!output || QDELETED(output))
		return
	user.forceMove(get_turf(output))
/*
/datum/enchantment/pocket_dimension
	enchantment_name = "Pocket Dimension"
	examine_text = "An alternative space exists in here."

	essence_recipe = list(
		/datum/thaumaturgical_essence/magic = 50,
	)

	var/static/obj/structure/pocket_portal/portal

/datum/enchantment/pocket_dimension/can_enchant(atom/item)
	var/datum/storage/atom_storage = item.atom_storage
	if(!atom_storage)
		return FALSE
	return !item.atom_storage.no_interface

/datum/enchantment/pocket_dimension/register_triggers(atom/item)
	. = ..()
	if(!portal)
		portal = GLOB.pocket_portal
	registered_signals += COMSIG_STORAGE_STORED_ITEM
	RegisterSignal(item, COMSIG_STORAGE_STORED_ITEM, PROC_REF(warp))
	portal?.mob_exit_point += item

/datum/enchantment/pocket_dimension/proc/warp(datum/storage/source, obj/item/added, mob/user)
	SIGNAL_HANDLER

	if(!portal)
		return

	var/mob/mob
	if(istype(added, /obj/item/mob_holder))
		var/obj/item/mob_holder/holder = added
		mob = holder.held_mob

	enchanted_item.atom_storage.attempt_remove(added, get_turf(portal), silent = TRUE)

	if(!QDELETED(added))
		added.forceMove(get_turf(portal))
	else if(mob)
		mob.forceMove(get_turf(portal))
*/
