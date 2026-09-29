/datum/component/storage/concrete/grid/drill
	screen_max_rows = 4
	screen_max_columns = 5
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/drill/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check, list/modifiers, storage_click)
	if(!istype(storing, /obj/item/ore) && !istype(storing, /obj/item/natural/rock))
		return FALSE
	return ..()

/obj/structure/drill
	name = "large drill"
	desc = "A heavy, bolted-down drill."
	icon = 'icons/obj/drill.dmi'
	icon_state = "drill1"
	density = TRUE
	anchored = TRUE
	max_integrity = 500
	layer = parent_type::layer + 0.1 //above the general fluff layer

	SET_BASE_PIXEL(-12, -10)
	rotation_structure = TRUE
	stress_use = 96
	initialize_dirs = CONN_DIR_ALL_CARDINAL

	/// Progress toward the next "chip" of damage dealt to whatever's ahead, out of 100.
	var/drill_progress = 0
	/// Base brute damage dealt per completed drilling cycle at 8rpm; scales with speed.
	var/drill_damage = 8

/obj/structure/drill/Initialize(mapload, ...)
	. = ..()
	START_PROCESSING(SSobj, src)
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)
	AddComponent(/datum/component/storage/concrete/grid/drill)
	set_turf_weight(get_step(src, dir))

/obj/structure/drill/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/drill/setDir(newdir)
	var/turf/old_dir = get_step(src, dir)
	. = ..()
	set_turf_weight(get_step(src, newdir), old_dir)

/obj/structure/drill/proc/set_turf_weight(turf/new_turf, turf/old_turf)
	if(old_turf)
		old_turf.path_weight -= 300
	new_turf.path_weight += 300

/obj/structure/drill/set_rotations_per_minute(speed)
	. = ..()
	if(!.)
		return
	set_stress_use(96 * (speed / 8))

/obj/structure/drill/update_animation_effect()
	if(!rotation_network || length(rotation_network.connected) == 1)
		animate(src, icon_state = "drill1", time = 1)
		return
	if(rotation_network?.overstressed || !rotations_per_minute || !rotation_network?.total_stress)
		animate(src, icon_state = "drill1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 6)
	if(rotation_direction == WEST)
		animate(src, icon_state = "drill1", time = frame_stage, loop = -1)
		animate(icon_state = "drill2", time = frame_stage)
		animate(icon_state = "drill3", time = frame_stage)
		animate(icon_state = "drill4", time = frame_stage)
		animate(icon_state = "drill5", time = frame_stage)
		animate(icon_state = "drill6", time = frame_stage)
	else
		animate(src, icon_state = "drill6", time = frame_stage, loop = -1)
		animate(icon_state = "drill5", time = frame_stage)
		animate(icon_state = "drill4", time = frame_stage)
		animate(icon_state = "drill3", time = frame_stage)
		animate(icon_state = "drill2", time = frame_stage)
		animate(icon_state = "drill1", time = frame_stage)

/obj/structure/drill/process()
	if(!rotations_per_minute || rotation_network?.overstressed)
		return
	drill_progress += rotations_per_minute
	if(drill_progress < 100)
		return
	while(drill_progress >= 100)
		drill_progress -= 100
		work_the_drill()

/obj/structure/drill/proc/work_the_drill()
	var/turf/target_turf = get_step(src, dir)
	if(!target_turf)
		return FALSE

	var/drill_power = max(drill_damage, rotations_per_minute * 0.5)

	playsound(src, 'sound/foley/milling.ogg', 100, TRUE, -1)// :(

	//owie
	for(var/mob/living/victim in target_turf)
		drill_hit_mob(victim, drill_power)

	//destroy things
	for(var/obj/structure/blocker in target_turf)
		if(blocker == src)
			continue
		if(istype(blocker, /obj/structure/ore_core))
			continue
		if(!blocker.density)
			continue
		blocker.take_damage(drill_power, BRUTE, PIERCE, 0)
		playsound(blocker, pick(list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')), 100, FALSE)

	for(var/atom/atom in target_turf)
		if(atom == src)
			continue
		atom.drill_act(drill_power)

	var/obj/structure/ore_core/core = locate(/obj/structure/ore_core) in target_turf
	if(core)
		core.drill_on_core(src, drill_power * 0.1)
		playsound(core, pick(list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')), 100, FALSE)
		return TRUE

	if(ismineralturf(target_turf))
		drill_mineral_turf(target_turf, drill_power)
		return TRUE

	return FALSE

/obj/structure/drill/proc/drill_hit_mob(mob/living/victim, power)
	if(!power || !istype(victim))
		return
	to_chat(victim, span_userdanger("[src] grinds into you!"))
	if(ishuman(victim))
		var/mob/living/carbon/human/human_victim = victim
		var/obj/item/bodypart/hit_part = human_victim.get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		if(hit_part)
			hit_part.bodypart_attacked_by(BCLASS_PIERCE, power)
	else
		victim.apply_damage(power, BRUTE)
	victim.Knockdown(2 SECONDS)
	playsound(victim, pick(list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')), 100, FALSE)

/obj/structure/drill/proc/drill_mineral_turf(turf/closed/mineral/target, power)
	if(!istype(target))
		return FALSE
	var/olddam = target.get_integrity()
	target.take_damage(power, BRUTE, PIERCE, 0)
	if(target.uses_integrity && target.get_integrity() > 10 && target.get_integrity() < olddam)
		if(prob(50))
			var/rock_path = target.rockType || /obj/item/natural/rock
			var/obj/item/dug_rock = new rock_path(get_turf(src))
			try_insert_ore(dug_rock)
	return TRUE

/obj/structure/drill/proc/try_insert_ore(obj/item/dug_item)
	var/inserted = SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, dug_item, null, TRUE, FALSE)
	if(!inserted)
		dug_item.forceMove(get_turf(src))
	return inserted
