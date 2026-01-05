/// List of all mob prefabs so we only have one copy
GLOBAL_LIST_INIT(mob_prefabs, init_mob_prefabs())

/proc/init_mob_prefabs()
	var/list/mob_prefabs = list()
	for(var/prefab_type in typesof(/datum/mob_prefab))
		mob_prefabs[prefab_type] = new prefab_type()
	return mob_prefabs

/proc/assign_mob_prefab_to_target(mob/living/target, requested_prefab)
	var/datum/mob_prefab/prefab
	if(istype(requested_prefab, /datum/mob_prefab))
		prefab = requested_prefab
	else
		prefab = LAZYACCESS(GLOB.mob_prefabs, requested_prefab)
	if(!prefab)
		return FALSE
	return prefab.assign_prefab(target)

/mob/living
	var/list/stat_prefabs
	var/list/skill_prefabs
	var/list/outfit_prefabs

/// mob prefabs hold preset data sets for mobs to apply on creation.
/// for the most part this is used for stat blocks, skills, traits, but could see use otherwise if needed.
/// unless you're dealing some really fucky shit these should only be used for mob bases (NPC mobs), but there still aren't any checks for this.
/datum/mob_prefab
	abstract_type = /datum/mob_prefab
	//yep. pretty sparse here.

/datum/mob_prefab/proc/assign_prefab(mob/living/target)
	if(isliving(target))
		return TRUE
