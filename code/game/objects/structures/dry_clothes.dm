/obj/structure/dryclothes
	name = "clothline"
	desc = "This seems like a nice place to dry some clothes."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "dryclothes"
	max_integrity = 200
	density = TRUE
	climbable = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	var/drying_timer
	var/has_wet_items = FALSE

/obj/structure/dryclothes/Initialize()
	. = ..()
	create_storage(type = /datum/storage/drying_rack)

	RegisterSignal(src, COMSIG_STORAGE_STORED_ITEM, PROC_REF(on_item_stored))
	RegisterSignal(src, COMSIG_STORAGE_REMOVED_ITEM, PROC_REF(on_item_removed))

/obj/structure/dryclothes/Destroy(force)
	if(drying_timer)
		deltimer(drying_timer)

	atom_storage.remove_all(get_turf(src))

	return ..()

/obj/structure/dryclothes/proc/on_item_stored(datum/source, obj/item/I)
	if(!drying_timer && !has_wet_items)
		// Start loop
		drying_timer = addtimer(CALLBACK(src, PROC_REF(process_drying)), 10 SECONDS, TIMER_STOPPABLE)

	if(!isliving(source))
		return

	var/mob/living/user = source
	user.nobles_seen_servant_work()

/obj/structure/dryclothes/proc/on_item_removed(datum/source, obj/item/I)
	if(!atom_storage)
		return

	if(drying_timer && !length(contents))
		deltimer(drying_timer)

	if(!isliving(source))
		return

	var/mob/living/user = source
	user.nobles_seen_servant_work()

/obj/structure/dryclothes/proc/process_drying()
	if(!atom_storage)
		return

	has_wet_items = FALSE

	for(var/obj/item/clothing/C in contents)
		if(!C.wetable)
			continue
		var/old_wet = C.wet.water_stacks
		C.wet.use_water(5)
		if(old_wet < 0 && C.wet.water_stacks == 0 && !C.wet.dirty_water && C.wet.washed)
			C.proper_drying = TRUE
			C.AddComponent(/datum/component/particle_spewer/sparkle)
		else if(old_wet < 0 && C.wet.water_stacks == 0 && C.wet.dirty_water)
			C.wet.dirty_water = FALSE

		if(C.wet.water_stacks < 0)
			has_wet_items = TRUE

	// Reschedule only if we still have wet items
	if(has_wet_items)
		drying_timer = addtimer(CALLBACK(src, PROC_REF(process_drying)), 10 SECONDS, TIMER_STOPPABLE)
	else
		deltimer(drying_timer)
