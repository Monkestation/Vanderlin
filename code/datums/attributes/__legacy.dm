//
// These accept the OLD level values (0-6) and multiply by 10 internally.
// Use these when migrating call sites that still pass old-style values,
// e.g:  blade.adjust_skillrank(/datum/attribute/skill/combat/swords, 3, TRUE)
// becomes: blade.adjust_skillrank(/datum/attribute/skill/combat/swords, 3, TRUE)
// with no change at the call site - the helper does the conversion. it should NOT be used going forward

/**
 * LEGACY: Adjusts a skill by a delta in the old 0-6 scale.
 * Multiplies delta by 10 before applying.
 *
 * Example (unchanged call site):
 *   blade.adjust_skillrank(/datum/attribute/skill/combat/swords, 3, TRUE)
 *   -> internally calls adjust_skill_level(skill, 30, null, TRUE)
 */
/mob/proc/adjust_skillrank(skill_type, amt, silent = FALSE)
	attributes?.adjust_skill_level(skill_type, amt * 10, null, silent)
