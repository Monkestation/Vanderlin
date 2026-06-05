/**
 * Get the organ object from the mob matching the passed in typepath
 *
 * Arguments:
 * * typepath The typepath of the organ to get
 */
/mob/proc/getorgan(typepath)
	return

/**
 * Get an organ relating to a specific slot
 *
 * Arguments:
 * * slot Slot to get the organ from
 */
/mob/proc/getorganslot(slot)
	return


/**
 * Get a list of organ objects from the mob matching the passed in typepath
 *
 * Arguments:
 * * typepath The typepath of the organ to get
 */
/mob/proc/getorganlist(typepath)
	return

/**
 * Get organ objects by zone
 *
 * This will return a list of all the organs that are relevant to the zone that is passedin
 *
 * Arguments:
 * * zone [a BODY_ZONE_X define](https://github.com/tgstation/tgstation/blob/master/code/__DEFINES/combat.dm#L187-L200)
 */
/mob/proc/getorganszone(zone, subzones = FALSE)
	return

/**
 * Returns a list of all organs in the specified slot, if there are any
 *
 * Arguments:
 * * slot Slot to get the list
 */
/mob/proc/getorganslotlist(slot)
	return

/**
 * Returns a list of all organs in the specified slot, in the specified zone, if there are any
 *
 * Arguments:
 * * slot Slot to get the list
 */
/mob/proc/getorganslotlistzone(slot, zone)
	return

/**
 * Returns an integer referring to the efficiency of a certain organ slot
 *
 * Arguments:
 * * slot Slot to get the efficiency from
 */
/mob/proc/getorganslotefficiency(slot)
	return

/**
 * Returns an integer referring to the efficiency of a certain organ slot within a specific body zone
 *
 * Arguments:
 * * slot Slot to get the efficiency from
 * * zone Body zone that the organ needs to be from
 */
/mob/proc/getorganslotefficiencyzone(slot)
	return

/**
 * Updates organ blood, oxygen and nutriment requirements
 */
/mob/proc/update_organ_requirements()
	return

/mob/living/carbon/getorgan(typepath)
	var/list/organs = list()
	for(var/thing in internal_organs)
		if(istype(thing, typepath))
			organs |= thing
	if(length(organs))
		return pick(organs)

/mob/living/carbon/getorganslot(slot)
	RETURN_TYPE(/obj/item/organ)
	if(length(internal_organs_slot[slot]))
		return pick(internal_organs_slot[slot])

/mob/living/carbon/getorganszone(zone, subzones = FALSE)
	var/list/returnorg = list()
	if(subzones)
		var/obj/item/bodypart/bodypart = get_bodypart(zone)
		if(bodypart)
			for(var/subzone in (bodypart.subtargets - zone))
				returnorg += getorganszone(subzone)

	for(var/obj/item/organ/organ as anything in internal_organs)
		if(organ.zone != zone)
			continue
		returnorg += organ
	return returnorg


/mob/living/carbon/getorganslotlist(slot)
	. = list()
	if(length(internal_organs_slot[slot]))
		. |= internal_organs_slot[slot]

/mob/living/carbon/getorganslotlistzone(slot, zone)
	. = list()
	var/obj/item/organ/organ
	for(var/thing in internal_organs_slot[slot])
		organ = thing
		if(zone == check_zone(organ.current_zone))
			. |= organ

/mob/living/carbon/getorganslotefficiency(slot)
	. = 0
	var/obj/item/organ/organ
	for(var/thing in internal_organs_slot[slot])
		organ = thing
		. += organ.get_slot_efficiency(slot)

/mob/living/carbon/getorganslotefficiencyzone(slot, zone)
	. = 0
	var/obj/item/organ/organ
	for(var/thing in internal_organs_slot[slot])
		organ = thing
		if(zone == check_zone(organ.current_zone))
			. += organ.get_slot_efficiency(slot)

/mob/living/carbon/update_organ_requirements()
	total_blood_req = 0
	total_oxygen_req = 0
	total_nutriment_req = 0
	total_hydration_req = 0
	for(var/thing in internal_organs)
		var/obj/item/organ/organ = thing
		total_blood_req += (organ.blood_req/100 * BLOOD_VOLUME_NORMAL)
		total_oxygen_req += organ.oxygen_req
		total_nutriment_req += (organ.nutriment_req/100)
		total_hydration_req += (organ.hydration_req/100)
	if(HAS_TRAIT(src, TRAIT_NORMALIZED_BLOOD))
		total_blood_req = DEFAULT_TOTAL_BLOOD_REQ
