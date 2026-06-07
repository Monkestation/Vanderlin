
/mob/living/carbon/human/harlequinn_vessel
	name = "a cloaked figure"
	real_name = "a cloaked figure"
	invisibility = INVISIBILITY_MAXIMUM
	var/datum/weakref/spawning_region
	var/list/viable_species = list(
		/datum/species/human/northern,
		/datum/species/halforc,
		/datum/species/halfling,
		/datum/species/demihuman,
		/datum/species/dwarf/mountain,
		/datum/species/elf/snow,
		/datum/species/elf/dark,
		/datum/species/triton,
		/datum/species/rakshari,
		/datum/species/medicator,
		/datum/species/kobold,
	)

/mob/living/carbon/human/harlequinn_vessel/Initialize(mapload, datum/threat_region/TR)
	. = ..()
	set_species(pick(viable_species))
	spawning_region = WEAKREF(TR)
	status_flags |= GODMODE
	AddComponent(/datum/component/ghost_vessel, null, HARLEQUINN_VESSEL_ID)
	RegisterSignal(src, COMSIG_GHOST_VESSEL_POSSESSED, PROC_REF(on_possessed))

/mob/living/carbon/human/harlequinn_vessel/proc/on_possessed(datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(setup_harlequinn))

/mob/living/carbon/human/harlequinn_vessel/proc/setup_harlequinn()
	status_flags &= ~GODMODE
	invisibility = 0
	anchored = FALSE

	mind.add_antag_datum(/datum/antagonist/harlequinn)

	var/datum/threat_region/TR = spawning_region?.resolve()
	var/region = TR ? TR.region_name : "the realm"

	var/datum/quest/custom/harlequinn_hunt/HQ = new()
	HQ.target_harlequinn = WEAKREF(src)
	HQ.harlequinn_region = region
	HQ.generate(null)
	GLOB.harlequinn_hunt_quest = WEAKREF(HQ)

	// Push directly into the hard pool
	// special system-issued quest
	SSquestboard.quest_pool[QUEST_DIFFICULTY_HARD] += HQ


/mob/living/carbon/human/harlequinn_vessel/death(gibbed)
	. = ..()
	var/datum/weakref/hunt_ref = GLOB.harlequinn_hunt_quest
	var/datum/quest/custom/harlequinn_hunt/HQ = hunt_ref?.resolve()
	if(!QDELETED(HQ))
		HQ.mark_harlequinn_dead()
