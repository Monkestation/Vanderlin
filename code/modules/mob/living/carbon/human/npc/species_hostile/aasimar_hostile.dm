GLOBAL_LIST_INIT(species_hostile, world.file2list('strings/rt/species_hostile.txt'))

/mob/living/carbon/human/species/aasimar/base
	ai_controller = /datum/ai_controller/species_hostile
	faction = list(FACTION_HOSTILE)
	ambushable = FALSE
	dodgetime = 50
	flee_in_pain = TRUE
	canparry = TRUE
	candodge = TRUE
	wander = FALSE
	d_intent = INTENT_PARRY


/mob/living/carbon/human/species/aasimar/base/Initialize()
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	set_species(/datum/species/aasimar)
	AddComponent(/datum/component/ai_aggro_system)
	set_patron(/datum/patron/inhumen/graggar, TRUE)
	job = "Graggarite Aasimar"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

// --- Base Variants ---

/mob/living/carbon/human/species/aasimar/base/unskilled
	skill_prefabs = list(/datum/mob_prefab/skills/combat/weak)

/mob/living/carbon/human/species/aasimar/base/average
	skill_prefabs = list(/datum/mob_prefab/skills/combat/average)

/mob/living/carbon/human/species/aasimar/base/skilled
	flee_in_pain = FALSE
	skill_prefabs = list(/datum/mob_prefab/skills/combat/skilled)

/mob/living/carbon/human/species/aasimar/base/very_skilled
	flee_in_pain = FALSE
	skill_prefabs = list(/datum/mob_prefab/skills/combat/expert)

// --- Naked ---

/mob/living/carbon/human/species/aasimar/base/unskilled/naked
	stat_prefabs = list(/datum/mob_prefab/stats/weak)

/mob/living/carbon/human/species/aasimar/base/average/naked
	stat_prefabs = list(/datum/mob_prefab/stats/average)

/mob/living/carbon/human/species/aasimar/base/skilled/naked
	stat_prefabs = list(/datum/mob_prefab/stats/average)

/mob/living/carbon/human/species/aasimar/base/very_skilled/naked
	stat_prefabs = list(/datum/mob_prefab/stats/hard)

// --- Light Gear ----

/mob/living/carbon/human/species/aasimar/base/unskilled/light_gear
	stat_prefabs = list(/datum/mob_prefab/stats/weak)
	outfit_prefabs = list(/datum/mob_prefab/loadout/light)

/mob/living/carbon/human/species/aasimar/base/average/light_gear
	stat_prefabs = list(/datum/mob_prefab/stats/average)
	outfit_prefabs = list(/datum/mob_prefab/loadout/light)

/mob/living/carbon/human/species/aasimar/base/skilled/light_gear
	stat_prefabs = list(/datum/mob_prefab/stats/average)
	outfit_prefabs = list(/datum/mob_prefab/loadout/light/dualwield)

/mob/living/carbon/human/species/aasimar/base/very_skilled/light_gear
	stat_prefabs = list(/datum/mob_prefab/stats/hard)
	outfit_prefabs = list(/datum/mob_prefab/loadout/light/dualwield)

// --- Medium Gear ----

/mob/living/carbon/human/species/aasimar/base/unskilled/medium_gear
	stat_prefabs = list(/datum/mob_prefab/stats/weak)
	outfit_prefabs = list(/datum/mob_prefab/loadout/medium)

/mob/living/carbon/human/species/aasimar/base/average/medium_gear
	stat_prefabs = list(/datum/mob_prefab/stats/average)
	outfit_prefabs = list(/datum/mob_prefab/loadout/medium)

/mob/living/carbon/human/species/aasimar/base/skilled/medium_gear
	stat_prefabs = list(/datum/mob_prefab/stats/average)
	outfit_prefabs = list(/datum/mob_prefab/loadout/medium/no_painstun)

/mob/living/carbon/human/species/aasimar/base/very_skilled/medium_gear
	stat_prefabs = list(/datum/mob_prefab/stats/hard)
	outfit_prefabs = list(/datum/mob_prefab/loadout/medium/no_painstun)

// --- Heavy Gear ----

/mob/living/carbon/human/species/aasimar/base/unskilled/heavy_gear
	stat_prefabs = list(/datum/mob_prefab/stats/weak)
	outfit_prefabs = list(/datum/mob_prefab/loadout/medium)

/mob/living/carbon/human/species/aasimar/base/average/heavy_gear
	stat_prefabs = list(/datum/mob_prefab/stats/average)
	outfit_prefabs = list(/datum/mob_prefab/loadout/medium)

/mob/living/carbon/human/species/aasimar/base/skilled/heavy_gear
	stat_prefabs = list(/datum/mob_prefab/stats/average)
	outfit_prefabs = list(/datum/mob_prefab/loadout/heavy/no_painstun)

/mob/living/carbon/human/species/aasimar/base/very_skilled/heavy_gear
	stat_prefabs = list(/datum/mob_prefab/stats/hard)
	outfit_prefabs = list(/datum/mob_prefab/loadout/heavy/no_painstun)
