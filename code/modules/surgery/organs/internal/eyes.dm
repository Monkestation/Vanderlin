/obj/item/organ/eyes
	name = "eyes"
	icon_state = "eyeball"
	desc = ""
	zone = BODY_ZONE_PRECISE_R_EYE
	slot = ORGAN_SLOT_EYES
	gender = PLURAL

	visible_organ = TRUE

	organ_dna_type = /datum/organ_dna/eyes
	accessory_type = /datum/sprite_accessory/eyes/humanoid

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY
	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD		//half the normal health max since we go blind at 30, a permanent blindness at 50 therefore makes sense unless medicine is administered
	high_threshold = 0.3 * STANDARD_ORGAN_THRESHOLD	//threshold at 30
	low_threshold = 0.2 * STANDARD_ORGAN_THRESHOLD	//threshold at 20

	low_threshold_passed = "<span class='info'>Distant objects become somewhat less tangible.</span>"
	high_threshold_passed = "<span class='info'>Everything starts to look a lot less clear.</span>"
	now_failing = "<span class='warning'>Darkness envelops me, as my eyes go blind!</span>"
	now_fixed = "<span class='info'>Color and shapes are once again perceivable.</span>"
	high_threshold_cleared = "<span class='info'>My vision functions passably once more.</span>"
	low_threshold_cleared = "<span class='info'>My vision is cleared of any ailment.</span>"

	var/sight_flags = 0
	var/see_in_dark = 8
	var/tint = 0
	var/eye_icon_state = "eyes"
	var/flash_protect = FLASH_PROTECTION_NONE
	var/see_invisible = SEE_INVISIBLE_LIVING
	var/lighting_alpha
	var/no_glasses
	var/damaged	= FALSE	//damaged indicates that our eyes are undergoing some level of negative effect

	var/old_eye_color = "fff" //cache owners original eye color before inserting new eyes
	/// Current eye color
	var/eye_color = null
	/// Whether eyes are different colors
	var/heterochromia = FALSE
	/// Second color for heterochromia
	var/second_color = "FFFFFF"

	/// Glows with emissive in the dark
	var/glows = FALSE

/obj/item/organ/eyes/Initialize()
	. = ..()
	if(!owner && !eye_color)
		eye_color = random_eye_color()
		if(prob(5))
			heterochromia = TRUE
			second_color = random_eye_color()

	update_appearance(UPDATE_OVERLAYS)

/obj/item/organ/eyes/update_overlays()
	. = ..()
	if(eye_color)
		var/mutable_appearance/iris_overlay = mutable_appearance(icon, "[icon_state]-iris")

		var/used_color = "#[eye_color]"
		if(heterochromia && prob(50))
			used_color = "#[second_color]"

		iris_overlay.color = used_color
		. += iris_overlay
		if(glows)
			iris_overlay = mutable_appearance(icon, "[icon_state]-iris", plane = EMISSIVE_PLANE)
			iris_overlay.color = used_color
			. += iris_overlay

/obj/item/organ/eyes/update_accessory_colors()
	var/list/colors_list = list()
	colors_list += eye_color
	if(heterochromia)
		colors_list += second_color
	else
		colors_list += eye_color
	accessory_colors = color_list_to_string(colors_list)

/obj/item/organ/eyes/imprint_organ_dna(datum/organ_dna/organ_dna)
	. = ..()
	var/datum/organ_dna/eyes/eyes_dna = organ_dna
	eyes_dna.eye_color = eye_color
	eyes_dna.heterochromia = heterochromia
	eyes_dna.second_color = second_color

/obj/item/organ/eyes/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE, initialising)
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/HMN = owner
		if(eye_color)
			HMN.regenerate_icons()
	for(var/datum/wound/facial/eyes/eye_wound as anything in M.get_wounds())
		qdel(eye_wound)
	M.update_tint()
	owner.update_sight()
	if(M.has_dna() && ishuman(M))
		M.dna.species.handle_body(M) //updates eye icon



/obj/item/organ/eyes/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	if(ishuman(M) && eye_color)
		var/mob/living/carbon/human/HMN = M
		HMN.regenerate_icons()
	// Cure blindness from eye damage
	M.cure_blind(EYE_DAMAGE)
	M.cure_nearsighted(EYE_DAMAGE)
	// Eye blind and temp blind go to, even if this is a bit of cheesy way to clear blindness
	M.remove_status_effect(/datum/status_effect/eye_blur)
	M.remove_status_effect(/datum/status_effect/temporary_blindness)
	M.set_eye_blur(0)
	M.update_sight()

/obj/item/organ/eyes/on_life()
	..()
	var/mob/living/carbon/C = owner
	//since we can repair fully damaged eyes, check if healing has occurred
	if((organ_flags & ORGAN_FAILING) && (damage < maxHealth))
		organ_flags &= ~ORGAN_FAILING
		C.cure_blind(EYE_DAMAGE)
	//various degrees of "oh fuck my eyes", from "point a laser at my eye" to "staring at the Sun" intensities
	if(damage > 20)
		damaged = TRUE
		if((organ_flags & ORGAN_FAILING))
			C.become_blind(EYE_DAMAGE)
		else if(damage > 30)
			C.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, 2)
		else
			C.overlay_fullscreen("eye_damage", /atom/movable/screen/fullscreen/impaired, 1)
	//called once since we don't want to keep clearing the screen of eye damage for people who are below 20 damage
	else if(damaged)
		damaged = FALSE
		C.clear_fullscreen("eye_damage")
	return


/obj/item/organ/eyes/night_vision
	name = "shadow eyes"
	desc = ""
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/night_vision = TRUE

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
	name = "alien eyes"
	desc = ""
	sight_flags = SEE_MOBS

/obj/item/organ/eyes/night_vision/zombie
	name = "undead eyes"
	desc = ""
	eye_color = "FFFFFF"

/obj/item/organ/eyes/night_vision/werewolf
	name = "moonlight eyes"
	desc = ""

/obj/item/organ/eyes/night_vision/nightmare
	name = "burning red eyes"
	desc = ""
	eye_color = BLOODCULT_EYE

/obj/item/organ/eyes/night_vision/mushroom
	name = "fung-eye"
	desc = ""

/obj/item/organ/eyes/elf
	name = "elf eyes"
	desc = ""
	see_in_dark = 4
	lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT

/obj/item/organ/eyes/elf/less
	see_in_dark = 3
	lighting_alpha = LIGHTING_PLANE_ALPHA_LESSER_NV_TRAIT

/obj/item/organ/eyes/kobold
	name = "slitted eyes" // SPRITE PLS
	accessory_type = /datum/sprite_accessory/eyes/humanoid/kobold
	see_in_dark = 3
	lighting_alpha = LIGHTING_PLANE_ALPHA_LESSER_NV_TRAIT

/obj/item/organ/eyes/triton
	name = "dead fish eyes"
	accessory_type = /datum/sprite_accessory/eyes/humanoid/triton
	glows = TRUE
	flash_protect = FLASH_PROTECTION_SENSITIVE

/obj/item/organ/eyes/rakshari
	name = "eyes of cat"
	accessory_type = /datum/sprite_accessory/eyes/humanoid/rakshari

/obj/item/organ/eyes/no_render
	accessory_type = null

/proc/set_eye_color(mob/living/carbon/mob, color_one, color_two)
	var/obj/item/organ/eyes/eyes = mob.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		return
	if(color_one)
		eyes.eye_color = color_one
	if(color_two)
		eyes.second_color = color_two
	eyes.update_accessory_colors()
	if(eyes.owner)
		eyes.owner.update_body_parts(TRUE)
