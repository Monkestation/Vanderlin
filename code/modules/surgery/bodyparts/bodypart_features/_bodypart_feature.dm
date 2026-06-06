/datum/bodypart_feature
	/// Name of the feature
	var/name = "Feature"
	/// Body zone of the feature, it's to which bodypart the feature will be inserted to
	var/body_zone
	/// Sprite accessory of the feature
	var/accessory_type
	/// Colors of the accessory
	var/accessory_colors
	/// Slot of the bodypart feature
	var/feature_slot
	/// Render on skeletonization?
	var/draw_on_skeleton = FALSE

/// Proc to customize the base icon of the organ.
/datum/bodypart_feature/proc/bodypart_icon(mutable_appearance/standing)
	return

/// This proc can add overlays to the organ image that is to be attached to a bodypart.
/datum/bodypart_feature/proc/bodypart_overlays(mutable_appearance/standing, obj/item/bodypart/bodypart)
	return

/datum/bodypart_feature/proc/get_bodypart_overlay(obj/item/bodypart/bodypart)
	if(!accessory_type)
		return
	if(bodypart.skeletonized && !draw_on_skeleton)
		return

	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	var/list/appearances = accessory.get_appearance(null, bodypart, accessory_colors)
	if(!appearances)
		return
	for(var/standing in appearances)
		bodypart_icon(standing)
		bodypart_overlays(standing, bodypart)
	return appearances

/// Sets an accessory type and optionally colors too.
/datum/bodypart_feature/proc/set_accessory_type(new_accessory_type, colors, owner)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	if(accessory?.use_static)
		return
	if(!isnull(colors))
		accessory_colors = colors
	else
		accessory_colors = accessory.get_default_colors(color_key_source_list_from_carbon(owner))
	accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)

/datum/bodypart_feature/proc/build_colors_for_accessory(list/source_key_list, mob/living/carbon/owner)
	if(!accessory_type)
		return
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	if(accessory?.use_static)
		return
	if(!source_key_list)
		if(!owner)
			return
		source_key_list = color_key_source_list_from_carbon(owner)
	accessory_colors = accessory.get_default_colors(source_key_list)

/obj/item/bodypart/proc/add_bodypart_feature(datum/bodypart_feature/feature)
	if(feature.body_zone != body_zone)
		return FALSE
	if(!bodypart_features)
		bodypart_features = list()
	// Remove existing features that occupy this slot
	for(var/datum/bodypart_feature/existing_feature as anything in bodypart_features)
		if(!(existing_feature.feature_slot == feature.feature_slot))
			continue
		remove_bodypart_feature(existing_feature)
	bodypart_features += feature
	if(owner)
		owner.update_body()
	return TRUE

/obj/item/bodypart/proc/remove_bodypart_feature(datum/bodypart_feature/feature)
	if(!(feature in bodypart_features))
		return
	bodypart_features -= feature
	if(owner)
		owner.update_body()
	return

/obj/item/bodypart/proc/remove_all_bodypart_features()
	if(!bodypart_features)
		return
	for(var/datum/bodypart_feature/feature as anything in bodypart_features)
		if(istype(feature))
			qdel(feature)
	bodypart_features.Cut()
	if(owner)
		owner.update_body()

/mob/living/carbon/proc/remove_all_bodypart_features()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		bodypart.remove_all_bodypart_features()

/mob/living/carbon/proc/add_bodypart_feature(datum/bodypart_feature/feature)
	var/obj/item/bodypart/bodypart = get_bodypart(feature.body_zone)
	if(!bodypart)
		return
	bodypart.add_bodypart_feature(feature)

/mob/living/carbon/proc/add_bodypart_feature_list(list/feature_list)
	for(var/feature in feature_list)
		add_bodypart_feature(feature)
