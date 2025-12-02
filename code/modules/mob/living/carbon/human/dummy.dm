
/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	mouse_drag_pointer = MOUSE_INACTIVE_POINTER
	visual_only_organs = TRUE
	var/in_use = FALSE

INITIALIZE_IMMEDIATE(/mob/living/carbon/human/dummy)

/mob/living/carbon/human/dummy/Initialize()
	. = ..()
	// Can we PLEASE get a consistent way to wipe these dummies no matter how we spawn in?
	GLOB.human_list -= src
	GLOB.carbon_list -= src
	GLOB.mob_living_list -= src
	GLOB.alive_mob_list -= src
	GLOB.mob_list -= src

/mob/living/carbon/human/dummy/Destroy()
	in_use = FALSE
	return ..()

/mob/living/carbon/human/dummy/Life()
	return

// no reason for these to ever be hearing sensitive, it just wastes time on spatial grid stuff
/mob/living/carbon/human/dummy/become_hearing_sensitive(trait_source)
	return

/mob/living/carbon/human/dummy/proc/wipe_state()
	delete_equipment()
	cut_overlays(TRUE)

/mob/living/carbon/human/dummy/setup_human_dna()
	randomize_human(src)
	dna.initialize_dna(skip_index = TRUE) //Skip stuff that requires full round init.

//Inefficient pooling/caching way.
GLOBAL_LIST_EMPTY(human_dummy_list)
GLOBAL_LIST_EMPTY(dummy_mob_list)

/proc/generate_or_wait_for_human_dummy(slotkey)
	if(!slotkey)
		return new /mob/living/carbon/human/dummy
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotkey]
	if(istype(D))
		UNTIL(!D.in_use)
	if(QDELETED(D))
		D = new
		GLOB.human_dummy_list[slotkey] = D
		GLOB.dummy_mob_list += D
	D.in_use = TRUE
	return D

/proc/unset_busy_human_dummy(slotnumber)
	if(!slotnumber)
		return
	var/mob/living/carbon/human/dummy/D = GLOB.human_dummy_list[slotnumber]
	if(istype(D))
		D.wipe_state()
		D.in_use = FALSE
