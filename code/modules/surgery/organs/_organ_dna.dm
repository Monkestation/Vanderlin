/datum/organ_dna
	/// Type of the organ thats imprinted.
	var/organ_type
	/// Accessory type thats imprinted.
	var/accessory_type
	/// Accessory colors thats imprinted.
	var/accessory_colors
	/// Whether the DNA shouldn't yield an organ. This is so people can customize species that usually have an organ to not have one.
	var/disabled = FALSE

/datum/organ_dna/proc/can_create_organ()
	if(disabled)
		return FALSE
	return TRUE

/// Creates an organ at location, imprints its information on it and returns it
/datum/organ_dna/proc/create_organ(atom/location, datum/species/species)
	var/obj/item/organ/new_organ = new organ_type(location)
	imprint_organ(new_organ, species = species)
	return new_organ

/// Imprints information on the organ.
/datum/organ_dna/proc/imprint_organ(obj/item/organ/organ, datum/species/species)
	if(accessory_type)
		organ.set_accessory_type(accessory_type, accessory_colors)

/datum/organ_dna/eyes
	var/eye_color = "#FFFFFF"
	var/second_color = "#FFFFFF"

/datum/organ_dna/eyes/imprint_organ(obj/item/organ/organ, datum/species/species)
	if(NOEYESPRITES in species?.species_traits)
		organ.accessory_type = null
		organ.accessory_colors = null
	else
		..()
	var/obj/item/organ/eyes/eyes_organ = organ
	if(eyes_organ.side == RIGHT_SIDE)
		eyes_organ.eye_color = eye_color
	else
		eyes_organ.eye_color = second_color
