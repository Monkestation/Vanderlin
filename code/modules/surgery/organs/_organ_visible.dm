/obj/item/organ
	/// Whether the organ is fully internal and should not be seen by bare eyes.
	var/visible_organ = FALSE
	/// Description when the organ is visible and examined while it's attached to a bodypart.
	var/bodypart_desc = "This is an organ."
	/// Icon of the organ when it's on a bodypart.
	var/bodypart_icon
	/// Icon state of the organ when it's on a bodypart.
	var/bodypart_icon_state
	/// Layer of the overlay this organs renders for being on limbs.
	var/bodypart_layer = BODY_LAYER
	/// Instead of creating an overlay from above variables we can use a sprite accessory.
	var/accessory_type
	/// Color list string for complex overlay generation through sprite accessory.
	var/accessory_colors
	/// Whether the bodypart organ overlay is an emissive blocker
	var/bodypart_emissive_blocker = TRUE
	/// Type of organ DNA that this organ will create.
	var/organ_dna_type = /datum/organ_dna
	/// Draw icon as overlays from the acessory or bodypart icons
	var/use_mob_sprite_as_obj_sprite = TRUE

/// Gets organ description for when its attached to a bodypart.
/obj/item/organ/proc/get_bodypart_desc()
	return bodypart_desc

/// Whether the organ is visible and should appear on a bodypart.
/obj/item/organ/proc/is_visible()
	/// It's an internal organ, always hidden.
	if(!visible_organ)
		return FALSE
	/// Doesn't have an owner so it couldn't be covered by anything.
	if(!owner)
		return TRUE
	if(!is_visible_on_owner())
		return FALSE
	return TRUE

/obj/item/organ/proc/is_visible_on_owner()
	return TRUE

/// Gets the organ overlay.
/obj/item/organ/proc/get_bodypart_overlay(obj/item/bodypart/bodypart)
	if(!bodypart_icon && !accessory_type)
		return

	if(accessory_type)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		var/list/appearances = accessory.get_appearance(src, bodypart, accessory_colors)
		if(!appearances)
			return
		for(var/standing in appearances)
			bodypart_icon(standing)
			bodypart_overlays(standing)
		return appearances

	var/mutable_appearance/organ_overlay = mutable_appearance(bodypart_icon, bodypart_icon_state, layer = -bodypart_layer)
	organ_overlay.color = color
	bodypart_icon(organ_overlay)
	bodypart_overlays(organ_overlay)
	return organ_overlay

/obj/item/organ/update_overlays()
	. = ..()

	if(!use_mob_sprite_as_obj_sprite)
		return

	// Scuffed
	if(accessory_type)
		var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
		. += accessory.get_appearance(src, null, accessory_colors)
		return

	. += mutable_appearance(bodypart_icon, bodypart_icon_state, layer = -bodypart_layer, color = color)

/// Proc to customize the base icon of the organ.
/obj/item/organ/proc/bodypart_icon(mutable_appearance/standing)
	return

/// This proc can add overlays to the organ image that is to be attached to a bodypart.
/obj/item/organ/proc/bodypart_overlays(mutable_appearance/standing)
	return

/** get_availability
 * returns whether the species should innately have this organ.
 *
 * regenerate organs works with generic organs, so we need to get whether it can accept certain organs just by what this returns.
 * This is set to return true or false, depending on if a species has a trait that would nulify the purpose of the organ.
 * For example, lungs won't be given if you have NO_BREATH, stomachs check for NO_HUNGER, and livers check for NO_METABOLISM.
 * If you want a carbon to have a trait that normally blocks an organ but still want the organ. Attach the trait to the organ using the organ_traits var
 * Arguments:
 * owner_species - species, needed to return the mutant slot as true or false. stomach set to null means it shouldn't have one.
 * owner_mob - for more specific checks, like nightmares.
 */
/obj/item/organ/proc/get_availability(datum/species/owner_species)
	return slot in owner_species.organs

/// Called before organs are replaced in regenerate_organs with new ones
/obj/item/organ/proc/before_organ_replacement(obj/item/organ/replacement)
	SHOULD_CALL_PARENT(TRUE)

	// If we're being replace with an identical type we should take organ damage
	if(replacement.type == type)
		replacement.setOrganDamage(damage)

/// Sets an accessory type and optionally colors too.
/obj/item/organ/proc/set_accessory_type(new_accessory_type, colors)
	accessory_type = new_accessory_type
	if(!isnull(colors))
		accessory_colors = colors
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	if(accessory)
		accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)
	update_accessory_colors()

/obj/item/organ/proc/build_colors_for_accessory(list/source_key_list)
	if(!accessory_type)
		return
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!accessory)
		return
	if(accessory.use_static)
		return
	if(!source_key_list)
		if(!owner)
			return
		source_key_list = color_key_source_list_from_carbon(owner)
	accessory_colors = accessory.get_default_colors(source_key_list)
	accessory_colors = accessory.validate_color_keys_for_owner(owner, accessory_colors)
	update_accessory_colors()

/// Creates, imprints and returns an organ DNA datum.
/obj/item/organ/proc/create_organ_dna()
	var/datum/organ_dna/organ_dna = new organ_dna_type()
	imprint_organ_dna(organ_dna)
	return organ_dna

/// Imprints an organ DNA datum.
/obj/item/organ/proc/imprint_organ_dna(datum/organ_dna/organ_dna)
	organ_dna.organ_type = type
	if(accessory_type)
		organ_dna?.accessory_type = accessory_type
		organ_dna.accessory_colors = accessory_colors

/obj/item/organ/proc/update_accessory_colors()
	return
