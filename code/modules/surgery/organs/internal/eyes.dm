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

	maxHealth = 0.5 * STANDARD_ORGAN_THRESHOLD		//half the normal health max since we go blind at 30, a permanent blindness at 50 therefore makes sense unless medicine is administered
	high_threshold = 0.3 * STANDARD_ORGAN_THRESHOLD	//threshold at 30
	low_threshold = 0.2 * STANDARD_ORGAN_THRESHOLD	//threshold at 20

	low_threshold_passed = span_info("Distant objects become somewhat less tangible.")
	high_threshold_passed = span_info("Everything starts to look a lot less clear.")
	now_failing = span_warning("Darkness envelops me, as my eyes goes blind!")
	now_fixed = span_info("Color and shapes are once again perceivable.")
	high_threshold_cleared = span_info("My vision functions passably once more.")
	low_threshold_cleared = span_info("My vision is cleared of any ailment.")

	pain_multiplier = 0.35 / 2
	// remember that this is normally DOUBLED (2 eyes)
	organ_volume = 0.25
	max_blood_storage = 5
	current_blood = 5
	blood_req = 0.5
	oxygen_req = 0.5
	nutriment_req = 0.002
	hydration_req = 0.002

	var/sight_flags = 0
	var/see_in_dark = SEE_IN_DARK_DEFAULT_EYES
	/// How much innate tint these eyes have
	var/tint = 0
	var/eye_icon_state = "eye-right"
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
	/// Does this eye have blinking animations?
	var/blink_animation = TRUE
	// A abstract eyelid object (yes, really) used to animate blinking
	var/obj/effect/abstract/eyelid_effect/eyelid
	var/mutable_appearance/eyelid_overlay
	var/obj/item/bodypart/head/wound_signal_head

/obj/item/organ/eyes/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/Initialize()
	. = ..()
	eye_icon_state = (side == RIGHT_SIDE) ? "eye-right" : "eye-left"
	if(!owner && !eye_color)
		eye_color = random_eye_color(TRUE)

	if(blink_animation)
		eyelid = new /obj/effect/abstract/eyelid_effect(src, eye_icon_state)

	update_appearance()

/obj/item/organ/eyes/Destroy()
	if(ishuman(owner))
		detach_eyelid(owner)
	QDEL_NULL(eyelid)

	. = ..()

/obj/item/organ/eyes/proc/generate_body_overlay(image/overlay, obj/item/bodypart/head/my_head)
	. = list()

	var/generated_eye = generate_eye_overlay(overlay, my_head)
	if(!generated_eye)
		return

	. += generated_eye

	. += get_eyelid_overlay(overlay, my_head)

/obj/item/organ/eyes/proc/generate_eye_overlay(image/overlay, obj/item/bodypart/head/my_head)
	. = overlay

	if(!eye_icon_state)
		return

	overlay.icon_state = eye_icon_state

	if(eye_color)
		overlay.color = eye_color

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

#define BLINK_DURATION 0.15 SECONDS

/// Modifies eye overlays to also act as eyelids, both for blinking and for when you're knocked out cold
/obj/item/organ/eyes/proc/get_eyelid_overlay(image/eye, obj/item/bodypart/head/my_head)
	var/mob/living/carbon/human/parent = my_head.owner

	if(!istype(parent))
		return

	if(HAS_TRAIT(parent, TRAIT_NO_EYELIDS))
		return

	var/base_eyelid_color = my_head.skin_tone
	var/eyelid_color = get_eyelid_color(base_eyelid_color)
	// If we're knocked out, just color the eyes
	if(IS_DEAD_OR_INCAP(parent))
		eye.color = eyelid_color
		return

	if(!blink_animation || HAS_TRAIT(parent, TRAIT_PREVENT_BLINKING))
		return

	attach_eyelid(parent, base_eyelid_color)
	return eyelid_overlay

/obj/item/organ/eyes/proc/get_eyelid_color(base_color)
	if(!base_color)
		return "#0f010c"
	return BlendRGB(base_color, "#000000", 0.3)

/obj/item/organ/eyes/proc/attach_eyelid(mob/living/carbon/human/parent, eyelid_color)
	if(!eyelid || !parent || HAS_TRAIT(parent, TRAIT_NO_EYELIDS))
		return
	eyelid.render_target = "*[REF(src)]_eyelid"
	if(eyelid_color)
		eyelid.color = get_eyelid_color(eyelid_color)
	parent.vis_contents |= eyelid
	if(!eyelid_overlay)
		eyelid_overlay = mutable_appearance(layer = -EYES_LAYER + 0.1)
		eyelid_overlay.render_source = eyelid.render_target
		parent.add_overlay(eyelid_overlay)

/obj/item/organ/eyes/proc/detach_eyelid(mob/living/carbon/human/parent)
	if(!parent)
		return
	if(eyelid)
		parent.vis_contents -= eyelid
	if(eyelid_overlay)
		parent.cut_overlay(eyelid_overlay)
		eyelid_overlay = null

/obj/item/organ/eyes/proc/update_eyelid_state()
	if(!eyelid || !ishuman(owner))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/obj/item/bodypart/head/head = human_owner.get_bodypart(BODY_ZONE_HEAD)
	attach_eyelid(human_owner, head?.skin_tone)
	var/should_close_eyelid = human_owner.eyesclosed || human_owner.stat >= UNCONSCIOUS || has_eye_wound(head)
	animate(eyelid, alpha = should_close_eyelid ? 255 : 0, time = 0, flags = ANIMATION_END_NOW)

/obj/item/organ/eyes/proc/has_eye_wound(obj/item/bodypart/head/head)
	if(!head)
		return FALSE
	for(var/datum/wound/wound as anything in head.wounds)
		if(!istype(wound, /datum/wound/facial/eyes) && !istype(wound, /datum/wound/fracture/head/eyes))
			continue
		if(zone in wound.viable_zones)
			return TRUE
	return FALSE

/obj/item/organ/eyes/proc/register_head_wound_signal(obj/item/bodypart/head/head)
	if(wound_signal_head == head)
		return
	unregister_head_wound_signal()
	if(!head)
		return
	wound_signal_head = head
	RegisterSignal(head, COMSIG_BODYPART_WOUND_REMOVED, PROC_REF(on_eye_wound_removed))

/obj/item/organ/eyes/proc/unregister_head_wound_signal()
	if(!wound_signal_head)
		return
	UnregisterSignal(wound_signal_head, COMSIG_BODYPART_WOUND_REMOVED)
	wound_signal_head = null

/obj/item/organ/eyes/proc/on_eye_wound_gained(mob/living/source, datum/wound/wound)
	SIGNAL_HANDLER
	if(istype(wound, /datum/wound/facial/eyes) || istype(wound, /datum/wound/fracture/head/eyes))
		update_eyelid_state()

/obj/item/organ/eyes/proc/on_eye_wound_removed(obj/item/bodypart/head/source, datum/wound/wound)
	SIGNAL_HANDLER
	if(istype(wound, /datum/wound/facial/eyes) || istype(wound, /datum/wound/fracture/head/eyes))
		update_eyelid_state()

/obj/item/organ/eyes/proc/blink_once(duration = BLINK_DURATION)
	if(!eyelid || !blink_animation)
		return
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.eyesclosed || human_owner.stat >= UNCONSCIOUS || has_eye_wound(human_owner.get_bodypart(BODY_ZONE_HEAD)))
			update_eyelid_state()
			return

	animate(eyelid, alpha = 255, time = 0, flags = ANIMATION_END_NOW)
	animate(time = duration)
	animate(alpha = 0, time = 0)

/obj/effect/abstract/eyelid_effect
	name = "eyelid"
	icon = 'icons/mob/human_face.dmi'
	layer = -EYES_LAYER + 0.1
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	color = "#0f010c"

/obj/effect/abstract/eyelid_effect/Initialize(mapload, new_state)
	. = ..()
	icon_state = new_state
	alpha = 0

#undef BLINK_DURATION

/obj/item/organ/eyes/switch_side(new_side = RIGHT_SIDE)
	side = new_side
	if(side == RIGHT_SIDE)
		zone = BODY_ZONE_PRECISE_R_EYE
		eye_icon_state = "eye-right"
	else
		zone = BODY_ZONE_PRECISE_L_EYE
		eye_icon_state = "eye-left"
	if(eyelid)
		eyelid.icon_state = eye_icon_state
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

/obj/item/organ/eyes/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()

	// Place this eye in the correct slot of the owner's eye_organs list
	var/sight_index = (side == RIGHT_SIDE) ? 2 : 1
	organ_owner.eye_organs.len = max(length(organ_owner.eye_organs), sight_index)
	organ_owner.eye_organs[sight_index] = src

	if(ishuman(organ_owner))
		var/mob/living/carbon/human/human_owner = organ_owner
		var/obj/item/bodypart/head/head = human_owner.get_bodypart(BODY_ZONE_HEAD)
		RegisterSignal(organ_owner, COMSIG_LIVING_WOUND_GAINED, PROC_REF(on_eye_wound_gained))
		register_head_wound_signal(head)
		attach_eyelid(human_owner, head?.skin_tone)
		update_eyelid_state()
		head?.start_eye_blinking()

	if(!(owner.status_flags & BUILDING_ORGANS))
		if(ishuman(owner))
			var/mob/living/carbon/human/HMN = owner
			HMN.regenerate_icons()

	organ_owner.update_eyes()
	organ_owner.update_tint()
	organ_owner.update_sight()

	if(organ_owner.has_dna())
		organ_owner.dna.species.handle_body(organ_owner)

	if(organ_owner.hud_used)
		var/atom/movable/screen/eye_intent/eyet = locate() in organ_owner.hud_used.static_inventory
		eyet?.update_appearance(UPDATE_OVERLAYS)

/obj/item/organ/eyes/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	if(ishuman(organ_owner))
		detach_eyelid(organ_owner)
		UnregisterSignal(organ_owner, COMSIG_LIVING_WOUND_GAINED)
	unregister_head_wound_signal()

	. = ..()

	var/sight_index = (side == RIGHT_SIDE) ? 2 : 1
	organ_owner.eye_organs[sight_index] = null

	organ_owner.update_eyes()
	organ_owner.update_sight()
	organ_owner.update_tint()

	if(ishuman(organ_owner))
		var/mob/living/carbon/human/HMN = organ_owner
		HMN.regenerate_icons()

	if(organ_owner.has_dna())
		organ_owner.dna.species.handle_body(organ_owner)

/obj/item/organ/eyes/handle_attaching_item(obj/item/tool, mob/living/user, params)
	. = ..()
	owner.update_eyes()

/obj/item/organ/eyes/applyOrganDamage(amount, maximum = maxHealth)
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
	see_in_dark = SEE_IN_DARK_DARKVISION
	lighting_alpha = LIGHTING_PLANE_ALPHA_DARKVISION
	actions_types = list(/datum/action/item_action/organ_action/use)
	var/night_vision = TRUE

/obj/item/organ/eyes/night_vision/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/night_vision/ui_action_click()
	sight_flags = initial(sight_flags)
	switch(lighting_alpha)
		if (LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_NV_EYES_TIER_1
		if (LIGHTING_NV_EYES_TIER_1)
			lighting_alpha = LIGHTING_NV_EYES_TIER_2
		if (LIGHTING_NV_EYES_TIER_2)
			lighting_alpha = LIGHTING_NV_EYES_TIER_3
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
	see_in_dark = SEE_IN_DARK_ELVEN_EYES
	lighting_alpha = LIGHTING_PLANE_ALPHA_ELVEN_EYES

/obj/item/organ/eyes/elf/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/elf/less
	see_in_dark = SEE_IN_DARK_HALF_ELVEN_EYES
	lighting_alpha = LIGHTING_PLANE_ALPHA_HALF_ELVEN_EYES

/obj/item/organ/eyes/elf/less/left
	zone = BODY_ZONE_PRECISE_L_EYE
	side = LEFT_SIDE

/obj/item/organ/eyes/kobold
	name = "slitted eye"
	accessory_type = /datum/sprite_accessory/eyes/humanoid/kobold
	see_in_dark = SEE_IN_DARK_DARKVISION
	lighting_alpha = LIGHTING_PLANE_ALPHA_DARKVISION

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
