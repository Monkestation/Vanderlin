#define PREFAB_MANUAL 0
#define PREFAB_LAZY_CLAMP 1 // lazy clamp uses lazy level as the clamp
#define PREFAB_LAZY_ADJUST 2
#define PREFAB_LAZY_SET 3

/// Assigns skills. Incredible.
/datum/mob_prefab/skills
	abstract_type = /datum/mob_prefab/skills

	var/lazy_config = PREFAB_LAZY_CLAMP //default for these are clamps!
	/// used for lazy set, it autopopulates the needed list on creation because writing this code sucks
	var/list/lazy_skills
	/// what level will all the lazy skills be?
	var/lazy_level = SKILL_LEVEL_NONE

	// manual configs, you can set these manually but they'll overwrite if you're not on manual prefab mode when it's made
	/// An associative list of adjusted skills to their value. This still calls clamped_adjust_skillrank, you can use this list as I[J] or I[J][K] for specific clamps.
	var/alist/adjusted_skills
	/// an associative list of skills to their value. These are hard-sets and use set_skillrank
	var/alist/set_skills

	/// leave null to not override
	var/dodgetime

/datum/mob_prefab/skills/New()
	. = ..()
	for(var/skill_path in lazy_skills)
		switch(lazy_config)
			if(PREFAB_LAZY_CLAMP)
				LAZYADDASSOC(adjusted_skills, skill_path, list(lazy_level, lazy_level))
			if(PREFAB_LAZY_ADJUST)
				LAZYADDASSOC(adjusted_skills, skill_path, list(lazy_level, SKILL_LEVEL_LEGENDARY))
			if(PREFAB_LAZY_SET)
				LAZYADDASSOC(set_skills, skill_path, lazy_level)

/datum/mob_prefab/skills/assign_prefab(mob/living/target)
	. = ..()
	if(!.)
		return
	for(var/skill_path in adjusted_skills)
		if(!ispath(skill_path, /datum/skill))
			stack_trace("[skill_path] is not a valid skill path, but it was found in [nameof(adjusted_skills)]!")
			continue
		var/clamp = LAZYACCESSASSOC(adjusted_skills, skill_path, 2) || SKILL_LEVEL_LEGENDARY
		target.clamped_adjust_skillrank(skill_path, adjusted_skills[skill_path], clamp, TRUE)
	for(var/skill_path in set_skills)
		if(!ispath(skill_path, /datum/skill))
			stack_trace("[skill_path] is not a valid skill path, but it was found in [nameof(set_skills)]!")
			continue
		target.set_skillrank(skill_path, set_skills[skill_path], TRUE)
	if(dodgetime)
		target.dodgetime = min(target.dodgetime, dodgetime)


/// COMBAT SETS ///
/datum/mob_prefab/skills/combat
	abstract_type = /datum/mob_prefab/skills/combat

	lazy_skills = list(
		/datum/skill/combat/axesmaces,
		/datum/skill/combat/bows,
		/datum/skill/combat/crossbows,
		/datum/skill/combat/firearms,
		/datum/skill/combat/knives,
		/datum/skill/combat/polearms,
		/datum/skill/combat/shields,
		/datum/skill/combat/swords,
		/datum/skill/combat/unarmed,
		/datum/skill/combat/whipsflails,
		/datum/skill/combat/wrestling,
		/datum/skill/misc/athletics
	)

/datum/mob_prefab/skills/combat/weak
	lazy_level = SKILL_LEVEL_NOVICE
	dodgetime = 50

/datum/mob_prefab/skills/combat/average
	lazy_level = SKILL_LEVEL_APPRENTICE
	dodgetime = 40

/datum/mob_prefab/skills/combat/skilled
	lazy_level = SKILL_LEVEL_JOURNEYMAN
	dodgetime = 30

/datum/mob_prefab/skills/combat/expert
	lazy_level = SKILL_LEVEL_EXPERT
	dodgetime = 20

/datum/mob_prefab/skills/combat/master
	lazy_level = SKILL_LEVEL_MASTER
	dodgetime = 15

/datum/mob_prefab/skills/combat/legendary
	lazy_level = SKILL_LEVEL_LEGENDARY
	dodgetime = 10

#undef PREFAB_MANUAL
#undef PREFAB_LAZY_CLAMP
#undef PREFAB_LAZY_ADJUST
#undef PREFAB_LAZY_SET
