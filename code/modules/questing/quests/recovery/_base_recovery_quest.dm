/datum/quest/recovery
	abstract_type = /datum/quest/recovery
	quest_type = QUEST_RECOVERY
	quest_difficulty = QUEST_DIFFICULTY_MEDIUM

	var/list/mob_types_to_spawn = list()
	var/count_min = 1
	var/count_max = 3

	var/group_name = "bandits"

	var/datum/recovery_pack/recovery_pack_type = null
	/// Weakref to the quest_package that drops on final kill.
	var/datum/weakref/recovery_package_ref

/datum/quest/recovery/get_title()
	if(title)
		return title
	var/pack_name = recovery_pack_type ? initial(recovery_pack_type.pack_name) : "stolen goods"
	return "Recover [pack_name] from [group_name]"

/datum/quest/recovery/get_objective_text()
	var/pack_name = recovery_pack_type ? initial(recovery_pack_type.pack_name) : "the package"
	return "Defeat the [group_name] ([progress_current]/[progress_required]) \
		and recover the [pack_name]. Return it to the Notice Board."

/datum/quest/recovery/get_location_text()
	return target_spawn_area ? "Reported sighting in [target_spawn_area] region." : "Location unknown."

/datum/quest/recovery/get_additional_reward(turf/target_turf)
	var/kill_reward = progress_required * QUEST_KILL_MOBS_LIST[target_mob_type]
	return ROUND_UP(kill_reward + QUEST_COURIER_BONUS_FLAT)

/datum/quest/recovery/generate(obj/effect/landmark/quest_spawner/landmark)
	. = ..()
	if(!landmark)
		return FALSE
	if(!length(mob_types_to_spawn))
		return FALSE

	// Resolve threat region for this landmark.
	var/datum/threat_region/TR = SSregionthreat.get_region_for_turf(get_turf(landmark))
	var/region = TR ? TR.region_name : ""

	// Filter registered packs to those valid for this region.
	var/list/valid_packs = list()
	for(var/pack_type in subtypesof(/datum/recovery_pack))
		//I cannot begin to describe the hate I feel for lists not working with inital()
		var/datum/recovery_pack/P = new pack_type()
		var/allowed = P.allowed_regions
		var/denied = P.denied_regions
		qdel(P)
		if(length(denied) && (region in denied))
			continue
		if(length(allowed) && !(region in allowed))
			continue
		valid_packs += pack_type

	if(!length(valid_packs))
		recovery_pack_type = /datum/recovery_pack/beast
	else
		recovery_pack_type = pick(valid_packs)

	target_mob_type = pick(mob_types_to_spawn)
	progress_required = rand(count_min, count_max)
	target_spawn_area = region ? region : get_area_name(get_turf(landmark))

	for(var/i in 1 to progress_required)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/mob/living/new_mob = new target_mob_type(spawn_effect)
		new_mob.add_faction("quest")
		new_mob.AddComponent(/datum/component/quest_object/kill, src)
		ADD_TRAIT(new_mob, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(new_mob, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		addtimer(CALLBACK(new_mob, TYPE_PROC_REF(/mob/living, setup_equip_block)), 3 SECONDS)
		spawn_effect.contained_atom = new_mob
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		add_tracked_atom(new_mob)
		landmark.add_quest_faction_to_nearby_mobs(spawn_turf)
		sleep(0.5 SECONDS)

	return TRUE

/*
 * Fires when the last mob dies and progress_current reaches progress_required.
 * Calls the parent for threat reduction, then drops the recovery package.
 */
/datum/quest/recovery/on_complete()
	. = ..()
	spawn_recovery_package()

/datum/quest/recovery/proc/spawn_recovery_package()
	// Find the turf of the last resolvable tracked atom (the just-killed mob).
	var/turf/drop_turf
	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/A = ref.resolve()
		if(A)
			drop_turf = get_turf(A)
			break
	if(!drop_turf)
		drop_turf = get_turf(quest_scroll)
	if(!drop_turf)
		return

	var/pack_name = recovery_pack_type ? initial(recovery_pack_type.pack_name) : "recovered goods"

	var/obj/item/quest_package/package = new(drop_turf)
	package.name = pack_name
	package.desc = "A bundle of [pack_name]. Return this to the Notice Board along with your quest scroll."
	package.quest_title = title
	package.linked_quest_ref = WEAKREF(src)
	package.icon_state = "ration_large"
	package.update_icon()

	var/datum/recovery_pack/pack_instance = new recovery_pack_type()
	pack_instance.roll_items(package)
	qdel(pack_instance)

	recovery_package_ref = WEAKREF(package)
	// Compass now points to the package instead of the (dead) mobs.
	add_tracked_atom(package)

	for(var/mob/living/carbon/human/H in range(7, drop_turf))
		to_chat(H, span_notice("A bundle of [pack_name] has been left behind!"))

/datum/quest/recovery/Destroy()
	var/obj/item/quest_package/package = recovery_package_ref?.resolve()
	if(package && !QDELETED(package))
		qdel(package)
	recovery_package_ref = null
	return ..()
