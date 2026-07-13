/datum/sprite_accessory
	abstract_type = /datum/sprite_accessory
	/// Name of the sprite accessories, which may be presented to pick from in the preferences menu
	var/name
	/// Icon file of the accessory
	var/icon
	/// Icon state of the accessory
	var/icon_state
	///our dynamic file used incases where we need to cull a specific portion like hair
	var/dynamic_file
	///this accessories gender
	var/gender = NEUTER
	/// Whether the states for this accessory have an extra state that will get overlayed ontop of the resulting state. Per layer, suffix "_extra"
	var/extra_state = FALSE
	/// Pixel x offset
	var/pixel_x = 0
	/// Pixel y offset
	var/pixel_y = 0
	/// Layer of the accessory
	var/layer = BODY_LAYER
	/// Relevant layers. If this is defined, instead of a single image the code will generate an image for each defined layer, with a suffix for the layer.
	var/list/relevant_layers
	/// Amount of color keys this accessory uses.
	var/color_keys = 1
	/// Color key name to describe a single customizable color key.
	var/color_key_name = "Accessory"
	/// List of names for color keys, required if you use more than 1. This is to present the user with how every color will affect the accessory.
	var/list/color_key_names
	/// List of defines for determining which color to use for which key as a default.
	var/list/color_key_defaults
	/// List of explicitly defined default colors which dont derrive from a variable key. A null entry means it will read a color from a key for that index.
	var/list/default_colors
	/// Whether this accessory has gendered variants. This will add either a "m_" or "f_" prefix if TRUE, depending on gender. No prefix if FALSE
	var/gendered_variants = FALSE
	/// List of generated icons based on the [type x icon_state x colors] combination.
	var/static/list/accessory_icon_cache = list()
	///are we emissive
	var/glows = FALSE

/datum/sprite_accessory/New()
	if(color_keys > 1)
		if(!color_key_names)
			stack_trace("Sprite accessory of [type] has more than 1 color key but doesn't have a color key name list")
		else if (color_key_names.len < color_keys)
			stack_trace("Sprite accessory of [type] has missing color key names")
	return ..()

/datum/sprite_accessory/proc/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return TRUE

/datum/sprite_accessory/proc/generic_gender_feature_adjust(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner, feature_key)
	if(QDELETED(owner) || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner
	var/datum/species/species = H.dna?.species

	if(!species)
		return

	var/use_female_sprites = FALSE
	if(species?.sexes)
		if(H.gender == FEMALE && !species.swap_female_clothes || H.gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	var/list/offsets
	if(use_female_sprites)
		offsets = (H.age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
	else
		offsets = (H.age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	if(LAZYACCESS(offsets, feature_key))
		for(var/mutable_appearance/appearance as anything in appearance_list)
			appearance.pixel_x += offsets[feature_key][1]
			appearance.pixel_y += offsets[feature_key][2]

/datum/sprite_accessory/proc/validate_color_keys_for_owner(mob/living/carbon/owner, colors)
	if(!color_keys)
		return colors
	var/list/color_list = color_string_to_list(colors)
	if(color_list && color_list.len == color_keys)
		return colors

	if(!owner)
		return colors
	colors = get_default_colors(color_key_source_list_from_carbon(owner))
	return colors

/datum/sprite_accessory/proc/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return

/// Gets the appearance of the sprite accessory as a mutable appearance for an organ on a bodypart.
/datum/sprite_accessory/proc/get_appearance(obj/item/organ/organ, obj/item/bodypart/bodypart, color_string)
	var/mob/living/carbon/owner
	if(organ)
		owner = organ.owner
	else if (bodypart)
		owner = bodypart.owner
		if(!owner)
			owner = bodypart.original_owner
	else
		return
	if(!is_visible(organ, bodypart, owner))
		return
	var/icon_state_to_use = get_icon_state(organ, bodypart, owner)
	var/icon_to_use = get_icon(organ, bodypart, owner)
	if(!icon_state_to_use)
		return null
	var/list/appearance_list = get_overlay(icon_state_to_use, color_string, dummy_block = istype(owner, /mob/living/carbon/human/dummy), icon_file = icon_to_use)
	adjust_appearance_list(appearance_list, organ, bodypart, owner)
	return appearance_list

/datum/sprite_accessory/proc/get_overlay(overlay_icon_state, color_string, dummy_block = FALSE, icon_file)
	color_string = sanitize_color_string(color_string)
	var/key = "[type]-[overlay_icon_state]-[color_string]-[glows]"
	if(!accessory_icon_cache[key])
		var/list/icon_states = generate_icon_states(overlay_icon_state, color_string, icon_file)
		var/icon/icon_bundle = icon('icons/testing/greyscale_error.dmi')
		for(var/icon_state in icon_states)
			icon_bundle.Insert(icon_states[icon_state], icon_state)

		accessory_icon_cache[key] = icon_bundle

	var/icon/cached_icon = icon(accessory_icon_cache[key])
	/// Generate mutable appearances from the icon
	var/appearance_list = list()
	if(relevant_layers)
		for(var/iterated_layer in relevant_layers)
			var/mutable_appearance/appearance = mutable_appearance(cached_icon, "[overlay_icon_state]_[get_layer_suffix(iterated_layer)]", layer = -iterated_layer)
			appearance.pixel_x = pixel_x
			appearance.pixel_y = pixel_y
			if(!dummy_block)
				appearance.overlays += emissive_blocker(cached_icon, "[overlay_icon_state]_[get_layer_suffix(iterated_layer)]")
			appearance_list += appearance
			if(glows)
				var/mutable_appearance/emissive = emissive_appearance(icon, "[overlay_icon_state]_[get_layer_suffix(iterated_layer)]", layer = -iterated_layer, appearance_flags = KEEP_TOGETHER)
				emissive.pixel_x = pixel_x
				emissive.pixel_y = pixel_y
				appearance_list += emissive
	else
		var/mutable_appearance/appearance = mutable_appearance(cached_icon, overlay_icon_state, layer = -layer)
		appearance.pixel_x = pixel_x
		appearance.pixel_y = pixel_y
		if(!dummy_block)
			appearance.overlays += emissive_blocker(cached_icon, overlay_icon_state)
		appearance_list += appearance
		if(glows)
			var/mutable_appearance/emissive = emissive_appearance(icon, overlay_icon_state, layer = -layer)
			emissive.pixel_x = pixel_x
			emissive.pixel_y = pixel_y
			appearance_list += emissive

	return appearance_list

/datum/sprite_accessory/proc/sanitize_color_string(color_string)
	var/list/color_list = color_string_to_list(color_string)
	if(!color_list)
		color_list = list()
	if(color_list.len < color_keys)
		//stack_trace("Sprite accessory [type] was passed an insufficient amount of colors.")
		while(color_list.len < color_keys)
			color_list += "#FFFFFF"
	else if(color_list.len > color_keys)
		//stack_trace("Sprite accessory [type] was passed too much of colors.")
		while(color_list.len > color_keys)
			color_list -= color_list[color_list.len]
	return color_list_to_string(color_list)

/datum/sprite_accessory/proc/generate_icon_states(overlay_icon_state, color_string, icon_file)
	var/list/state_list = list()
	var/list/color_list = color_string_to_list(color_string)
	if(relevant_layers)
		for(var/iterated_layer in relevant_layers)
			var/layer_suffix = get_layer_suffix(iterated_layer)
			state_list["[overlay_icon_state]_[layer_suffix]"] = generate_icon_state(overlay_icon_state, color_list, iterated_layer, layer_suffix, icon_file)
	else
		state_list[overlay_icon_state] = generate_icon_state(overlay_icon_state, color_list, layer, icon_file = icon_file)
	return state_list

/datum/sprite_accessory/proc/generate_icon_state(overlay_icon_state, color_list, passed_layer, suffix, icon_file)
	var/one_color = (color_keys == 1)
	if(suffix)
		overlay_icon_state += "_[suffix]"
	var/icon/result_icon
	for(var/color_index in 1 to color_keys)
		var/color_to_use = color_list[color_index]
		var/lookup_state = one_color ? overlay_icon_state  : "[overlay_icon_state]_[color_index]"
		var/icon/color_key_icon = icon(icon_file, lookup_state)
		color_key_icon.Blend(color_to_use, ICON_MULTIPLY)
		if(!result_icon)
			result_icon = color_key_icon
		else
			result_icon.Blend(color_key_icon, ICON_OVERLAY)

	// Blend the extra state on top if we want that.
	if(extra_state)
		var/icon/extra_icon = icon(icon_file, "[overlay_icon_state]_extra")
		result_icon.Blend(extra_icon, ICON_OVERLAY)

	// Apparently new icons can do weird stuff unless you try and "read" something from it like this before using it.
	//result_icon.GetPixel(1, 1)

	return result_icon

/datum/sprite_accessory/proc/get_layer_suffix(passed_layer)
	switch(passed_layer)
		if(BODY_FRONT_LAYER)
			return "FRONT"
		if(BODY_ADJ_LAYER)
			return "ADJ"
		if(BODY_BEHIND_LAYER)
			return "BEHIND"
		if(BODY_UNDER_LAYER)
			return "UNDER"
		else
			CRASH("Tried to get an unimplemented layer suffix for sprite accessory of type [type]")

/datum/sprite_accessory/proc/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return icon_state

/datum/sprite_accessory/proc/get_icon(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return icon

/datum/sprite_accessory/proc/get_default_colors(key_source_list)
	var/list/color_list = list()
	for(var/i in 1 to color_keys)
		var/color
		if(length(default_colors) >= i && !isnull(default_colors[i]))
			color = default_colors[i]
		else
			var/used_define
			if(length(color_key_defaults) >= i && color_key_defaults[i] != null)
				used_define = color_key_defaults[i]
			else
				used_define = default_define_for_color_key(i)
			color = key_source_list[used_define]
		if(!color)
			color = "#FFFFFF"
		color = sanitize_hexcolor(color)
		color_list += color
	return color_list_to_string(color_list)

/datum/sprite_accessory/proc/default_define_for_color_key(index)
	switch(index)
		if(1)
			return KEY_MUT_COLOR_ONE
		if(2)
			return KEY_MUT_COLOR_TWO
		else
			return KEY_MUT_COLOR_THREE

/proc/color_key_source_list_from_prefs(datum/preferences/prefs)
	if(istype(prefs))
		var/list/sources = list()
		sources[KEY_SKIN_COLOR] = prefs.read_preference(/datum/preference/choiced/skin_tone)
		sources[KEY_EYE_COLOR] = prefs.get_eye_color()
		sources[KEY_HAIR_COLOR] = prefs.get_hair_color()
		sources[KEY_FACE_HAIR_COLOR] = prefs.get_facial_hair_color()
		sources[KEY_CHEST_COLOR] = sources[KEY_SKIN_COLOR]
		var/chest_color = prefs.get_chest_color()
		if(chest_color)
			sources[KEY_CHEST_COLOR] = chest_color
		return sources
	else
		return color_key_source_list_from_carbon(prefs)


/proc/color_key_source_list_from_carbon(mob/living/carbon/carbon)
	var/list/sources = list()
	/// Read specific organ DNA entries to deduce eye, hair and facial hair color
	if(ishuman(carbon))
		var/mob/living/carbon/human/human = carbon
		sources[KEY_SKIN_COLOR] = human.skin_tone
		sources[KEY_EYE_COLOR] = human.get_eye_color()
		sources[KEY_HAIR_COLOR] = human.get_hair_color()
		sources[KEY_FACE_HAIR_COLOR] = human.get_facial_hair_color()
		sources[KEY_CHEST_COLOR] = sources[KEY_SKIN_COLOR]
		var/chest_color = human.get_chest_color()
		if(chest_color)
			sources[KEY_CHEST_COLOR] = chest_color
	else
		sources[KEY_SKIN_COLOR] = "FFFFFF"
		sources[KEY_CHEST_COLOR] = sources[KEY_SKIN_COLOR]
	return sources

#ifdef UNIT_TESTS

/datum/sprite_accessory/proc/unit_testing_possible_icon_states()
	var/list/icon_states = list()
	var/list/final_states = list()
	var/list/layer_suffixes = list()
	unit_testing_icon_states(icon_states)

	if(relevant_layers)
		for(var/layer in relevant_layers)
			var/layer_suffix = get_layer_suffix(layer)
			if(layer_suffix)
				layer_suffixes += "_[layer_suffix]"

	for(var/state in icon_states)
		for(var/color_index in 1 to color_keys)
			var/color_suffix = ""
			if(color_keys != 1)
				color_suffix = "_[color_index]"
			if(length(layer_suffixes))
				for(var/layer_suffix in layer_suffixes)
					var/final_state = "[state][layer_suffix][color_suffix]"
					final_states += final_state
			else
				var/final_state = "[state][color_suffix]"
				final_states += final_state
	if(extra_state)
		for(var/icon_state in icon_states)
			if(length(layer_suffixes))
				for(var/layer_suffix in layer_suffixes)
					final_states += "[icon_state][layer_suffix]_extra"
			else
				final_states += "[icon_state]_extra"

	return final_states

/datum/sprite_accessory/proc/unit_testing_icon_states(list/states)
	states += icon_state

#endif

/// None state which just means no appearance. Exists for easier manipulation so we dont have to write cases for customizng into a null type.
/datum/sprite_accessory/none
	name = "None"
	color_keys = 0
	icon = null
	icon_state = null
