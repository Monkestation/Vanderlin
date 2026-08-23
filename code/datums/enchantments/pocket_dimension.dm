GLOBAL_VAR_INIT(pocket_portal, null)

/obj/structure/pocket_portal
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	icon_state = "obelisk"
	pixel_x = -16
	density = FALSE
	anchored = TRUE
	max_integrity = 10000000

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

/datum/enchantment/pocket_dimension
	enchantment_name = "Pocket Dimension"
	examine_text = "An alternative space exists in here."

	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/magic = 50,
	)
	var/static/obj/structure/pocket_portal/portal


/datum/enchantment/pocket_dimension/register_triggers(atom/item)
	. = ..()
	if(!portal)
		portal = GLOB.pocket_portal
	registered_signals += COMSIG_STORAGE_ADDED
	RegisterSignal(item, COMSIG_STORAGE_ADDED, PROC_REF(warp))
	portal?.mob_exit_point += item

/datum/enchantment/pocket_dimension/proc/warp(atom/source, obj/item/added)
	var/mob/mob
	if(istype(added, /obj/item/mob_holder))
		var/obj/item/mob_holder/holder = added
		mob = holder.held_mob
	SEND_SIGNAL(enchanted_item, COMSIG_TRY_STORAGE_TAKE, added, get_turf(portal), TRUE)
	if(!QDELETED(added))
		added.forceMove(get_turf(portal))
	else if (mob)
		mob.forceMove(get_turf(portal))
