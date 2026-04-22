/obj/item/organ/eyes
	name = "eye"
	icon_state = "eyeball"
	base_icon_state = "eyeball"
	desc = ""
	zone = BODY_ZONE_PRECISE_R_EYE
	slot = ORGAN_SLOT_EYES
	side = RIGHT_SIDE
	sellprice = DEFAULT_ORGAN_VALUE/2

	visible_organ = TRUE

	organ_dna_type = /datum/organ_dna/eyes
	accessory_type = /datum/sprite_accessory/eyes/humanoid
	organ_efficiency = list(ORGAN_SLOT_EYES = 100)

	healing_factor = STANDARD_ORGAN_HEALING

	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD		//half the normal health max since we go blind at 30, a permanent blindness at 50 therefore makes sense unless medicine is administered
	high_threshold = 0.3 * STANDARD_ORGAN_THRESHOLD	//threshold at 30
	low_threshold = 0.2 * STANDARD_ORGAN_THRESHOLD	//threshold at 20

	low_threshold_passed = "<span class='info'>Distant objects become somewhat less tangible.</span>"
	high_threshold_passed = "<span class='info'>Everything starts to look a lot less clear.</span>"
	now_failing = "<span class='warning'>Darkness envelops me, as my eye goes blind!</span>"
	now_fixed = "<span class='info'>Color and shapes are once again perceivable.</span>"
	high_threshold_cleared = "<span class='info'>My vision functions passably once more.</span>"
	low_threshold_cleared = "<span class='info'>My vision is cleared of any ailment.</span>"

	// remember that this is normally DOUBLED (2 eyes)
	organ_volume = 0.25
	max_blood_storage = 5
	current_blood = 5
	blood_req = 1
	oxygen_req = 0.5
	nutriment_req = 0.15
	hydration_req = 0.15

	var/sight_flags = 0
	var/see_in_dark = 8
	var/tint = 0
	var/eye_icon_state = "eye"
	var/flash_protect = FLASH_PROTECTION_NONE
	var/see_invisible = SEE_INVISIBLE_LIVING
	var/lighting_alpha
	var/no_glasses
	var/damaged = FALSE	//damaged indicates that our eyes are undergoing some level of negative effect

	/// This eye's color, seeded from organ_dna on creation
	var/eye_color = null
	/// Overlay iris when possible
	var/iris_icon_state = "eyeball-iris"
	/// Changes how the eyes overlay is applied, makes it apply over the lighting layer
	var/overlay_ignore_lighting = FALSE
	/// Glows with emissive in the dark
	var/glows = FALSE

/obj/item/organ/eyes/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/Initialize()
	. = ..()
	if(!owner && !eye_color)
		eye_color = random_eye_color(TRUE)
	update_appearance()

/obj/item/organ/eyes/update_overlays()
	. = ..()
	if(iris_icon_state)
		var/image/iris = image(icon, src, iris_icon_state, layer + 0.1)
		iris.color = eye_color || "#FFFFFF"
		. += iris
		if(glows)
			var/image/emissive_iris = emissive_appearance(icon, iris_icon_state)
			emissive_iris.color = eye_color || "#FFFFFF"
			. += emissive_iris

/obj/item/organ/eyes/switch_side(new_side = RIGHT_SIDE)
	side = new_side
	if(side == RIGHT_SIDE)
		zone = BODY_ZONE_PRECISE_R_EYE
		eye_icon_state = "[initial(eye_icon_state)]-right"
	else
		zone = BODY_ZONE_PRECISE_L_EYE
		eye_icon_state = "[initial(eye_icon_state)]-left"
	if(!owner)
		current_zone = zone
	update_appearance()

/obj/item/organ/eyes/update_accessory_colors()
	accessory_colors = color_list_to_string(list(eye_color || "#FFFFFF"))

/obj/item/organ/eyes/imprint_organ_dna(datum/organ_dna/organ_dna)
	. = ..()
	var/datum/organ_dna/eyes/eyes_dna = organ_dna
	if(side == RIGHT_SIDE)
		eyes_dna.eye_color = eye_color
	else
		eyes_dna.second_color = eye_color

/obj/item/organ/eyes/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE, initialising, new_zone = null)
	. = ..()

	var/new_side = (current_zone == BODY_ZONE_PRECISE_L_EYE ? LEFT_SIDE : (current_zone == BODY_ZONE_PRECISE_R_EYE ? RIGHT_SIDE : side))
	switch_side(new_side)

	// Place this eye in the correct slot of the owner's eye_organs list
	var/sight_index = (side == RIGHT_SIDE) ? 2 : 1
	M.eye_organs.len = max(length(M.eye_organs), sight_index)
	M.eye_organs[sight_index] = src

	if(ishuman(owner))
		var/mob/living/carbon/human/HMN = owner
		HMN.regenerate_icons()

	M.update_eyes()
	M.update_tint()
	owner.update_sight()
	if(M.has_dna() && ishuman(M))
		M.dna.species.handle_body(M)
	if(M.hud_used)
		var/atom/movable/screen/eye_intent/eyet = locate() in M.hud_used.static_inventory
		eyet?.update_appearance(UPDATE_OVERLAYS)

/obj/item/organ/eyes/handle_attaching_item(obj/item/tool, mob/living/user, params)
	. = ..()
	owner.update_eyes()

/obj/item/organ/eyes/Remove(mob/living/carbon/M, special = 0)
	var/sight_index = (side == RIGHT_SIDE) ? 2 : 1

	. = ..()

	M.eye_organs[sight_index] = null
	M.update_eyes()
	M.update_sight()
	M.update_tint()

	if(ishuman(M))
		var/mob/living/carbon/human/HMN = M
		HMN.regenerate_icons()

	if(M.has_dna() && ishuman(M))
		M.dna.species.handle_body(M)

/obj/item/organ/eyes/applyOrganDamage(amount, maximum = maxHealth, silent = FALSE)
	. = ..()
	if(owner)
		owner.update_eyes()
		owner.update_sight()
		owner.update_tint()

/obj/item/organ/eyes/proc/refresh()
	if(ishuman(owner))
		var/mob/living/carbon/human/HMN = owner
		HMN.regenerate_icons()
	owner.update_eyes()
	owner.update_sight()
	owner.update_tint()
	if(owner.has_dna() && ishuman(owner))
		owner.dna.species.handle_body(owner)

/obj/item/organ/eyes/proc/get_eye_damage_level()
	switch(get_slot_efficiency(ORGAN_SLOT_EYES))
		if(-INFINITY to 1)
			return 3
		if(1 to 50)
			return 2
		if(50 to 80)
			return 1
		if(80 to INFINITY)
			return 0


/obj/item/organ/eyes/night_vision
	name = "shadow eye"
	desc = ""
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/night_vision = TRUE

/obj/item/organ/eyes/night_vision/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/night_vision/ui_action_click()
	sight_flags = initial(sight_flags)
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
		if (LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			sight_flags &= ~SEE_BLACKNESS
	owner.update_sight()

/obj/item/organ/eyes/night_vision/alien
	name = "alien eye"
	desc = ""
	sight_flags = SEE_MOBS

/obj/item/organ/eyes/night_vision/alien/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/night_vision/zombie
	name = "undead eye"
	desc = ""
	eye_color = "#FFFFFF"

/obj/item/organ/eyes/night_vision/zombie/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/night_vision/werewolf
	name = "moonlight eye"
	desc = ""

/obj/item/organ/eyes/night_vision/werewolf/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/night_vision/nightmare
	name = "burning red eye"
	desc = ""
	eye_color = BLOODCULT_EYE
	glows = TRUE

/obj/item/organ/eyes/night_vision/nightmare/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/night_vision/mushroom
	name = "fung-eye"
	desc = ""

/obj/item/organ/eyes/night_vision/mushroom/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/elf
	name = "elf eye"
	desc = ""
	see_in_dark = 4
	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT

/obj/item/organ/eyes/elf/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/elf/less
	see_in_dark = 3
	lighting_alpha = LIGHTING_PLANE_ALPHA_LESSER_NV_TRAIT

/obj/item/organ/eyes/elf/less/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/kobold
	name = "slitted eye"
	accessory_type = /datum/sprite_accessory/eyes/humanoid/kobold
	see_in_dark = 3
	lighting_alpha = LIGHTING_PLANE_ALPHA_LESSER_NV_TRAIT

/obj/item/organ/eyes/kobold/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/triton
	name = "dead fish eye"
	accessory_type = /datum/sprite_accessory/eyes/humanoid/triton
	glows = TRUE
	flash_protect = FLASH_PROTECTION_SENSITIVE

/obj/item/organ/eyes/triton/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/rakshari
	name = "eye of cat"
	accessory_type = /datum/sprite_accessory/eyes/humanoid/rakshari

/obj/item/organ/eyes/rakshari/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/no_render
	accessory_type = null

/obj/item/organ/eyes/no_render/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE
