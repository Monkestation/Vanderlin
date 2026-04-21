/mob/living/carbon/human/proc/get_hair_color()
	var/datum/bodypart_feature/hair/feature = get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	if(!feature)
		return "FFFFFF"
	return feature.hair_color

/mob/living/carbon/human/proc/get_facial_hair_color()
	var/datum/bodypart_feature/hair/feature = get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
	if(!feature)
		return "FFFFFF"
	return feature.hair_color

/mob/living/carbon/human/proc/get_eye_color(side = RIGHT_SIDE)
	var/sight_index = (side == RIGHT_SIDE) ? 2 : 1
	var/obj/item/organ/eyes/eye = LAZYACCESS(eye_organs, sight_index)
	if(!eye)
		return "#FFFFFF"
	return eye.eye_color || "#FFFFFF"

/mob/living/carbon/human/proc/get_chest_color()
	var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return null
	for(var/marking_name in chest.markings)
		var/datum/body_marking/marking = GLOB.body_markings[marking_name]
		if(!marking.covers_chest)
			continue
		var/marking_color = chest.markings[marking_name]
		return marking_color
	return null

/mob/living/carbon/proc/get_bodypart_feature_of_slot(feature_slot)
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		for(var/datum/bodypart_feature/feature as anything in bodypart.bodypart_features)
			if(feature.feature_slot == feature_slot)
				return feature
	return null


/mob/living/carbon/human/proc/set_hair_color(new_color, updates_body = TRUE)
	var/datum/bodypart_feature/hair/feature = get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	if(!feature)
		return
	feature.hair_color = new_color
	feature.accessory_colors = new_color
	if(updates_body)
		update_body_parts()

/mob/living/carbon/human/proc/set_facial_hair_color(new_color, updates_body = TRUE)
	var/datum/bodypart_feature/hair/feature = get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
	if(!feature)
		return
	feature.hair_color = new_color
	if(updates_body)
		update_body_parts()

/mob/living/carbon/proc/set_eye_color(new_right_color, new_left_color, updates_body = TRUE, updates_dna = FALSE)
	var/obj/item/organ/eyes/right_eye = LAZYACCESS(eye_organs, 2)
	var/obj/item/organ/eyes/left_eye = LAZYACCESS(eye_organs, 1)
	if(right_eye && new_right_color)
		right_eye.eye_color = new_right_color
		right_eye.update_accessory_colors()
	if(left_eye)
		left_eye.eye_color = new_left_color || new_right_color || "#FFFFFF"
		left_eye.update_accessory_colors()
	if(updates_body)
		update_body_parts(TRUE)
	if(hud_used)
		var/atom/movable/screen/eye_intent/eyet = locate() in hud_used.static_inventory
		eyet?.update_appearance(UPDATE_OVERLAYS)
	if(updates_dna)
		var/datum/organ_dna/eyes/eye_dna = dna?.organ_dna[ORGAN_SLOT_EYES]
		if(istype(eye_dna))
			if(new_right_color)
				eye_dna.eye_color = new_right_color
			eye_dna.second_color = new_left_color || new_right_color || "#FFFFFF"

/mob/living/carbon/human/proc/set_hair_style(datum/sprite_accessory/hair/head/style, updates_body = TRUE)
	if(!ispath(style) && !istype(style))
		return
	if(istype(style))
		style = style.type
	var/datum/bodypart_feature/hair/feature = get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	if(!feature)
		return
	feature.accessory_type = style
	if(updates_body)
		update_body_parts()

/mob/living/carbon/human/proc/set_facial_hair_style(datum/sprite_accessory/hair/facial/style, updates_body = TRUE)
	if(!ispath(style) && !istype(style))
		return
	if(istype(style))
		style = style.type
	var/datum/bodypart_feature/hair/feature = get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
	if(!feature)
		return
	feature.accessory_type = style
	if(updates_body)
		update_body_parts()
