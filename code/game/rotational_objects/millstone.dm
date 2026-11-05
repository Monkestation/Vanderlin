/datum/component/storage/concrete/grid/millstone
	screen_max_rows = 3
	screen_max_columns = 4
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/millstone/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check, list/modifiers, storage_click)
	var/can_mill = FALSE

	if(istype(storing, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/S = storing
		if(S.mill_result)
			can_mill = TRUE
	else if(istype(storing, /obj/item/ore))
		var/obj/item/ore/O = storing
		if(O.mill_result)
			can_mill = TRUE

	if(!can_mill)
		return FALSE

	return ..()

/obj/structure/fluff/millstone
	name = "millstone"
	desc = ""
	icon = 'icons/obj/rotation_machines.dmi'
	icon_state = "millstone"
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 400

	rotation_structure = TRUE
	stress_use = 64
	initialize_dirs = CONN_DIR_ALL_CARDINAL

	var/mill_progress = 0

/obj/structure/fluff/millstone/Initialize(mapload, ...)
	. = ..()
	START_PROCESSING(SSobj, src)
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)
	AddComponent(/datum/component/storage/concrete/grid/millstone)
	RegisterSignal(src, COMSIG_STORAGE_REMOVED, PROC_REF(on_item_removed))

/obj/structure/fluff/millstone/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/fluff/millstone/proc/on_item_removed(datum/source, obj/item/I, mob/living/carbon/human/user)
	if(!istype(user))
		return
	var/wound_prob = 60
	if(user.age == AGE_CHILD)
		wound_prob -= 20
	if(rotations_per_minute > 16 && prob(wound_prob))
		visible_message(span_warning("[user] gets their arm stuck in [src]!"), span_warning("You get your arm caught in [src]"))
		user.flash_fullscreen("redflash3")
		user.emote("painscream")
		var/obj/item/bodypart/arm = user.get_active_hand()
		if(arm)
			arm.bodypart_attacked_by(BCLASS_BLUNT, 4 + rotations_per_minute)

/obj/structure/fluff/millstone/attack_hand(mob/user)
	var/running = TRUE
	while(running)
		running = work_on_mill(user)
	..()

/obj/structure/fluff/millstone/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(64 * (speed / 8))

/obj/structure/fluff/millstone/update_animation_effect()
	if(!rotation_network || length(rotation_network.connected) == 1)
		animate(src, icon_state = "millstone", time = 1)
		return
	if(rotation_network?.overstressed || !rotations_per_minute || !rotation_network?.total_stress)
		animate(src, icon_state = "millstone1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 6)
	if(rotation_direction == WEST)
		animate(src, icon_state = "millstone1", time = frame_stage, loop = -1)
		animate(icon_state = "millstone2", time = frame_stage)
		animate(icon_state = "millstone3", time = frame_stage)
		animate(icon_state = "millstone4", time = frame_stage)
		animate(icon_state = "millstone5", time = frame_stage)
		animate(icon_state = "millstone6", time = frame_stage)
	else
		animate(src, icon_state = "millstone6", time = frame_stage, loop = -1)
		animate(icon_state = "millstone5", time = frame_stage)
		animate(icon_state = "millstone4", time = frame_stage)
		animate(icon_state = "millstone3", time = frame_stage)
		animate(icon_state = "millstone2", time = frame_stage)
		animate(icon_state = "millstone1", time = frame_stage)

/obj/structure/fluff/millstone/process()
	if(rotations_per_minute && !rotation_network?.overstressed)
		work_on_mill(powered = TRUE)

/obj/structure/fluff/millstone/proc/work_on_mill(mob/living/user, powered = FALSE)
	if(!user && !powered)
		return FALSE

	if(!length(contents))
		return FALSE

	playsound(src, 'sound/foley/milling.ogg', 100, TRUE, -1)
	if(powered)
		mill_progress += rotations_per_minute * 2
	else
		if(do_after(user, 2 SECONDS, src))
			mill_progress += 50
		else
			return FALSE

	if(mill_progress >= 100)
		mill_progress -= 100
		if(!length(contents))
			return FALSE

		var/obj/item/millable_item = contents[1]
		var/result_type
		var/quality = millable_item.recipe_quality

		if(istype(millable_item, /obj/item/reagent_containers/food/snacks))
			var/obj/item/reagent_containers/food/snacks/S = millable_item
			result_type = S.mill_result
		else if(istype(millable_item, /obj/item/ore))
			var/obj/item/ore/ore = millable_item
			result_type = ore.mill_result

		if(result_type)
			var/obj/item/mill_result = new result_type(get_turf(loc))
			mill_result.set_quality(quality)

		qdel(millable_item)

	return TRUE
