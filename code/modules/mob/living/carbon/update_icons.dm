

//IMPORTANT: Multiple animate() calls do not stack well, so try to do them all at once if you can.
/mob/living/carbon/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/final_pixel_y = pixel_y
	var/final_dir = dir
	var/changed = 0
	if(lying_angle != lying_prev && rotate_on_lying)
		changed++
		ntransform.TurnTo(lying_prev , lying_angle)
		if(!lying_angle) //Lying to standing
			final_pixel_y = get_standard_pixel_y_offset()
		else //if(lying != 0)
			if(lying_prev == 0) //Standing to lying
				pixel_y = get_standard_pixel_y_offset()
				final_pixel_y =  get_standard_pixel_y_offset()
				if(dir & (EAST|WEST)) //Facing east or west
					final_dir = pick(NORTH, SOUTH) //So you fall on your side rather than your face or ass
	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, UPDATE_TRANSFORM_TRAIT)
		addtimer(TRAIT_CALLBACK_REMOVE(src, TRAIT_NO_FLOATING_ANIM, UPDATE_TRANSFORM_TRAIT), 0.3 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
		pixel_x = get_standard_pixel_x_offset()
		pixel_y = final_pixel_y
		animate(src, transform = ntransform, time = (lying_prev == 0 || !resting) ? 2 : 0, pixel_y = final_pixel_y, dir = final_dir, easing = (EASE_IN|EASE_OUT))
		client?.pixel_x = pixel_x
		client?.pixel_y = pixel_y
		dir = final_dir
		update_vision_cone()
	else
		animate(src, time = 0.2 SECONDS, pixel_x = get_standard_pixel_x_offset(), pixel_y = get_standard_pixel_y_offset())
		client?.pixel_x = pixel_x
		client?.pixel_y = pixel_y

/mob/living
	var/list/overlays_standing[TOTAL_LAYERS]

/mob/living/proc/apply_overlay(cache_index)
	if((. = overlays_standing[cache_index]))
		add_overlay(.)
	if(client)
		update_vision_cone()

/mob/living/proc/remove_overlay(cache_index)
	var/I = overlays_standing[cache_index]
	if(I)
		cut_overlay(I)
		overlays_standing[cache_index] = null
	if(client)
		update_vision_cone()

/mob/living/carbon/regenerate_icons()
	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return 1
	update_inv_hands()
	update_inv_handcuffed()
	update_inv_legcuffed()
	update_fire()

/mob/living/carbon/update_inv_hands(hide_experimental = FALSE)
	remove_overlay(HANDS_LAYER)
	remove_overlay(HANDS_BEHIND_LAYER)
	var/age = AGE_ADULT
	var/datum/species/species
	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		species = human.dna?.species
		age = human.age

	if(handcuffed)
		drop_all_held_items()
		return

	var/list/hands = list()
	var/list/behindhands = list()

	var/list/offsets
	var/use_female_sprites = MALE_SPRITES
	if(species)
		if(species.sexes)
			if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES

		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	for(var/obj/item/I in held_items)
		if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
			if(I.bigboy)
				if(HAS_TRAIT(I, TRAIT_WIELDED))
					I.screen_loc = "WEST-4:16,SOUTH+7:-16"
				else
					if(get_held_index_of_item(I) == 1)
						I.screen_loc = "WEST-4:0,SOUTH+7:-16"
					else
						I.screen_loc = "WEST-3:0,SOUTH+7:-16"
			else
				if(HAS_TRAIT(I, TRAIT_WIELDED))
					I.screen_loc = "WEST-3:0,SOUTH+7"
				else
					I.screen_loc = ui_hand_position(get_held_index_of_item(I))
			client.screen += I
			if(observers && observers.len)
				for(var/mob/dead/observe as anything in observers)
					if(observe.client && observe.client.eye == src)
						observe.client.screen += I
					else
						observers -= observe
						if(!observers.len)
							observers = null
							break

		var/mutable_appearance/inhand_overlay
		var/mutable_appearance/behindhand_overlay
		if(I.experimental_inhand && !hide_experimental)
			var/used_prop
			var/list/prop
			if(I.altgripped)
				used_prop = "altgrip"
				prop = I.getonmobprop(used_prop)
			if(!prop && HAS_TRAIT(I, TRAIT_WIELDED))
				used_prop = "wielded"
				prop = I.getonmobprop(used_prop)
			if(!prop)
				used_prop = "gen"
				prop = I.getonmobprop(used_prop)
			if(I.force_reupdate_inhand)
				if(I.onprop?[used_prop])
					prop = I.onprop[used_prop]
				else
					LAZYSET(I.onprop, used_prop, prop)
			if(!prop)
				continue
			var/flipsprite = FALSE
			if(!(get_held_index_of_item(I) % 2 == 0)) //righthand
				flipsprite = TRUE
			inhand_overlay = mutable_appearance(I.getmoboverlay(used_prop,prop,mirrored=flipsprite), layer=-HANDS_LAYER)
			behindhand_overlay = mutable_appearance(I.getmoboverlay(used_prop,prop,behind=TRUE,mirrored=flipsprite), layer=-HANDS_BEHIND_LAYER)

			inhand_overlay = center_image(inhand_overlay, I.inhand_x_dimension, I.inhand_y_dimension)
			behindhand_overlay = center_image(behindhand_overlay, I.inhand_x_dimension, I.inhand_y_dimension)

			if(LAZYACCESS(offsets, OFFSET_HANDS))
				inhand_overlay.pixel_x += offsets[OFFSET_HANDS][1]
				inhand_overlay.pixel_y += offsets[OFFSET_HANDS][2]
				behindhand_overlay.pixel_x += offsets[OFFSET_HANDS][1]
				behindhand_overlay.pixel_y += offsets[OFFSET_HANDS][2]
			hands += inhand_overlay
			behindhands += behindhand_overlay
			if(I.blocks_emissive != EMISSIVE_BLOCK_NONE)
				var/mutable_appearance/emissive_front = emissive_blocker(I.getmoboverlay(used_prop,prop,mirrored=flipsprite), layer=-HANDS_LAYER, appearance_flags = NONE)

				emissive_front.pixel_y = inhand_overlay.pixel_y
				emissive_front.pixel_x = inhand_overlay.pixel_x

				var/mutable_appearance/emissive_back = emissive_blocker(I.getmoboverlay(used_prop,prop,behind=TRUE,mirrored=flipsprite), layer=-HANDS_BEHIND_LAYER, appearance_flags = NONE)
				emissive_back.pixel_y = behindhand_overlay.pixel_y
				emissive_back.pixel_x = behindhand_overlay.pixel_x

				hands += emissive_front
				behindhands += emissive_back
		else
			var/icon_file = I.lefthand_file
			if(get_held_index_of_item(I) % 2 == 0)
				icon_file = I.righthand_file
			inhand_overlay = I.build_worn_icon(age = age, default_layer = HANDS_LAYER, default_icon_file = icon_file, isinhands = TRUE)
			if(LAZYACCESS(offsets, OFFSET_HANDS))
				inhand_overlay.pixel_x += offsets[OFFSET_HANDS][1]
				inhand_overlay.pixel_y += offsets[OFFSET_HANDS][2]
			hands += inhand_overlay

	update_inv_cloak() //cloak held items

	overlays_standing[HANDS_BEHIND_LAYER] = behindhands
	overlays_standing[HANDS_LAYER] = hands
	apply_overlay(HANDS_BEHIND_LAYER)
	apply_overlay(HANDS_LAYER)

/mob/living/carbon/update_fire(fire_icon = "Generic_mob_burning")
	remove_overlay(FIRE_LAYER)
	if(on_fire || islava(loc))
		var/mutable_appearance/new_fire_overlay = mutable_appearance('icons/mob/OnFire.dmi', fire_icon, -FIRE_LAYER)
		if(divine_fire_stacks > fire_stacks)
			new_fire_overlay.color = list(0,0,0, 0,0,0, 0,0,0, 1,1,1)
		new_fire_overlay.appearance_flags = RESET_COLOR
		overlays_standing[FIRE_LAYER] = new_fire_overlay

	apply_overlay(FIRE_LAYER)

/mob/living/carbon/update_warning(datum/intent/I)
	remove_overlay(HALO_LAYER) //yoink
	if(I)
		if(client?.charging)
			var/mutable_appearance/warn_overlay = mutable_appearance('icons/effects/effects.dmi', I.warnie, -HALO_LAYER)
			warn_overlay.pixel_y = 16
//			if(I.warnoffset)
//				warn_overlay.pixel_y = I.warnoffset
//			else
//				switch(aimheight)
//					if(2)
//						warn_overlay.pixel_y = 16
//					if(1)
//						warn_overlay.pixel_y = 0
//					if(0)
//						warn_overlay.pixel_y = -8
			overlays_standing[HALO_LAYER] = warn_overlay

	apply_overlay(HALO_LAYER)

/mob/living/carbon/update_damage_overlays()
	remove_overlay(DAMAGE_LAYER)

	var/mutable_appearance/damage_overlay = mutable_appearance('icons/mob/dam_mob.dmi', "blank", -DAMAGE_LAYER)
	overlays_standing[DAMAGE_LAYER] = damage_overlay

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(BP.dmg_overlay_type)
			if(BP.brutestate)
				damage_overlay.add_overlay("[BP.dmg_overlay_type]_[BP.body_zone]_[BP.brutestate]0")	//we're adding icon_states of the base image as overlays
			if(BP.burnstate)
				damage_overlay.add_overlay("[BP.dmg_overlay_type]_[BP.body_zone]_0[BP.burnstate]")

	apply_overlay(DAMAGE_LAYER)


/mob/living/carbon/update_inv_wear_mask()
	remove_overlay(MASK_LAYER)
	var/age = AGE_ADULT
	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		age = human.age

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MASK) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_mask)
		if(!(ITEM_SLOT_MASK & check_obscured_slots()))
			overlays_standing[MASK_LAYER] = wear_mask.build_worn_icon(age = age, default_layer = MASK_LAYER, default_icon_file = 'icons/mob/clothing/mask.dmi')
		update_hud_wear_mask(wear_mask)

	apply_overlay(MASK_LAYER)

/mob/living/carbon/update_inv_neck()
	remove_overlay(NECK_LAYER)
	var/age = AGE_ADULT
	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		age = human.age

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_neck)
		if(!(ITEM_SLOT_NECK & check_obscured_slots()))
			overlays_standing[NECK_LAYER] = wear_neck.build_worn_icon(age = age, default_layer = NECK_LAYER, default_icon_file = 'icons/roguetown/clothing/neck.dmi')
		update_hud_neck(wear_neck)

	apply_overlay(NECK_LAYER)

/mob/living/carbon/update_inv_head(hide_nonstandard = FALSE)
	remove_overlay(HEAD_LAYER)

	var/age = AGE_ADULT
	if(ishuman(src))
		var/mob/living/carbon/human/human = src
		age = human.age

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_HEAD) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(head)
		if(hide_nonstandard && (head.worn_x_dimension != 32 || head.worn_y_dimension != 32))
			update_hud_head(head)
			return

		overlays_standing[HEAD_LAYER] = head.build_worn_icon(age = age, default_layer = HEAD_LAYER, default_icon_file = 'icons/roguetown/clothing/onmob/head.dmi')
		update_hud_head(head)

	apply_overlay(HEAD_LAYER)


/mob/living/carbon/update_inv_handcuffed()
	remove_overlay(HANDCUFF_LAYER)
	if(handcuffed)
		var/mutable_appearance/inhand_overlay = mutable_appearance('icons/roguetown/mob/bodies/cuffed.dmi', "[handcuffed.name]up", -HANDCUFF_LAYER)
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			var/datum/species/species = H.dna?.species
			var/list/offsets
			var/use_female_sprites = MALE_SPRITES
			if(species)
				if(species.sexes)
					if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
						use_female_sprites = FEMALE_SPRITES
				if(use_female_sprites)
					offsets = (H.age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
				else
					offsets = (H.age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

			if(LAZYACCESS(offsets, OFFSET_HANDS))
				inhand_overlay.pixel_x += offsets[OFFSET_HANDS][1]
				inhand_overlay.pixel_y += offsets[OFFSET_HANDS][2]

		overlays_standing[HANDCUFF_LAYER] = inhand_overlay
		apply_overlay(HANDCUFF_LAYER)

//mob HUD updates for items in our inventory

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(hud_used)
		for(var/hand in hud_used.hand_slots)
			var/atom/movable/screen/inventory/hand/H = hud_used.hand_slots[hand]
			if(H)
				H.update_appearance(UPDATE_OVERLAYS)

//update whether our head item appears on our hud.
/mob/living/carbon/proc/update_hud_head(obj/item/I)
	return

//update whether our mask item appears on our hud.
/mob/living/carbon/proc/update_hud_wear_mask(obj/item/I)
	return

//update whether our neck item appears on our hud.
/mob/living/carbon/proc/update_hud_neck(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_backl(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_backr(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_beltl(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_beltr(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_mouth(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_cloak(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_shirt(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_armor(obj/item/I)
	return

//update whether our back item appears on our hud.
/mob/living/carbon/proc/update_hud_pants(obj/item/I)
	return

//Overlays for the worn overlay so you can overlay while you overlay
//eg: ammo counters, primed grenade flashing, etc.
//"icon_file" is used automatically for inhands etc. to make sure it gets the right inhand file
/obj/item/proc/worn_overlays(mutable_appearance/standing, isinhands = FALSE, icon_file, dummy_block = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	. = list()
	if((blocks_emissive == EMISSIVE_BLOCK_NONE) || dummy_block)
		return

	var/mutable_appearance/blocker_overlay = mutable_appearance(standing.icon, standing.icon_state, plane = EMISSIVE_PLANE, appearance_flags = KEEP_APART)
	blocker_overlay.color = GLOB.em_block_color
	. += blocker_overlay


/mob/living/carbon/update_body()
	update_body_parts()

/mob/living/carbon/proc/update_body_parts()
	//CHECK FOR UPDATE
	var/oldkey = icon_render_key
	icon_render_key = generate_icon_render_key()
	if(oldkey == icon_render_key)
		return

	remove_overlay(BODYPARTS_LAYER)

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		BP.update_limb()

	//LOAD ICONS
	if(limb_icon_cache[icon_render_key])
		load_limb_from_cache()
		return

	//GENERATE NEW LIMBS
	var/list/new_limbs = list()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		new_limbs += BP.get_limb_icon()
	if(new_limbs.len)
		overlays_standing[BODYPARTS_LAYER] = new_limbs
		limb_icon_cache[icon_render_key] = new_limbs

	apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()



/////////////////////
// Limb Icon Cache //
/////////////////////
/*
	Called from update_body_parts() these procs handle the limb icon cache.
	the limb icon cache adds an icon_render_key to a human mob, it represents:
	- skin_tone (if applicable)
	- gender
	- limbs (stores as the limb name and whether it is removed/fine, organic/robotic)
	These procs only store limbs as to increase the number of matching icon_render_keys
	This cache exists because drawing 6/7 icons for humans constantly is quite a waste
	See RemieRichards on irc.rizon.net #coderbus
*/

//produces a key based on the mob's limbs

/mob/living/carbon/proc/generate_icon_render_key()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		. += "-[BP.body_zone]"
		if(BP.animal_origin)
			. += "-[BP.animal_origin]"
		if(BP.status == BODYPART_ORGANIC)
			. += "-organic"
		else
			. += "-robotic"

	if(HAS_TRAIT(src, TRAIT_HUSK))
		. += "-husk"


//change the mob's icon to the one matching its key
/mob/living/carbon/proc/load_limb_from_cache()
	if(limb_icon_cache[icon_render_key])
		remove_overlay(BODYPARTS_LAYER)
		overlays_standing[BODYPARTS_LAYER] = limb_icon_cache[icon_render_key]
		apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()
