/obj/item/bodypart/head
	name = BODY_ZONE_HEAD
	desc = ""
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "default_human_head"
	max_damage = 200
	body_zone = BODY_ZONE_HEAD
	body_part = HEAD
	w_class = WEIGHT_CLASS_NORMAL //Quite a hefty load
	slowdown = 1 //Balancing measure
	throw_range = 2 //No head bowling
	px_x = 0
	px_y = -8
	dismember_wound = /datum/wound/dismemberment/head
	sellprice = 8

	grid_width = 64
	grid_height = 64

	max_cavity_item_size = WEIGHT_CLASS_BULKY
	max_cavity_volume = 8

	artery_type = list(ARTERY_HEAD, ARTERY_NECK)
	limb_flags = BODYPART_HAS_ARTERY | BODYPART_BONE_ENCASED

	var/mob/living/brain/brainmob = null //The current occupant.
	var/obj/item/organ/brain/brain = null //The brain organ
	var/obj/item/organ/eyes/eyes_right
	var/obj/item/organ/eyes/eyes_left
	var/obj/item/organ/ears/ears
	var/obj/item/organ/tongue/tongue

	//Limb appearance info:
	var/real_name = "" //Replacement name
	//Eye Colouring

	var/lip_style = null
	var/lip_color = "white"

	offset = OFFSET_HEAD

	//subtargets for crits
	subtargets = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_NECK)
	//grabtargets for grabs
	grabtargets = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_NECK)
	resistance_flags = FLAMMABLE

/obj/item/bodypart/head/Initialize()
	. = ..()
	randomize_price()

/obj/item/bodypart/head/attackby(obj/item/I, mob/user, list/modifiers)
	if(length(contents) && I.get_sharpness() && !user.cmode)
		add_fingerprint(user)
		playsound(src, 'sound/combat/hits/bladed/genstab (1).ogg', 60, vary = FALSE)
		user.visible_message("<span class='warning'>[user] begins to cut open [src].</span>",\
			"<span class='notice'>You begin to cut open [src]...</span>")
		if(do_after(user, 5 SECONDS, src))
			drop_organs(user)
			user.visible_message("<span class='danger'>[user] cuts [src] open!</span>",\
				"<span class='notice'>You finish cutting [src] open.</span>")
		return
	return ..()

/obj/item/bodypart/head/skeletonize(lethal = TRUE)
	. = ..()

	sellprice = round((sellprice || 0) * 0.2)
	if(lethal && owner && CAN_HAVE_BLOOD(owner))
		owner.death()

/obj/item/bodypart/head/grabbedintents(mob/living/user, atom/grabbed, precise)
	var/used_limb = precise
	switch(used_limb)
		if(BODY_ZONE_HEAD)
			return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
		if(BODY_ZONE_PRECISE_EARS)
			return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
		if(BODY_ZONE_PRECISE_NOSE)
			return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
		if(BODY_ZONE_PRECISE_SKULL)
			return list(/datum/intent/grab/move, /datum/intent/grab/smash)
		if(BODY_ZONE_PRECISE_L_EYE)
			return list(/datum/intent/grab/move, /datum/intent/grab/smash)
		if(BODY_ZONE_PRECISE_R_EYE)
			return list(/datum/intent/grab/move, /datum/intent/grab/smash)
		if(BODY_ZONE_PRECISE_MOUTH)
			return list(/datum/intent/grab/move, /datum/intent/grab/twist, /datum/intent/grab/smash)
		if(BODY_ZONE_PRECISE_NECK)
			if(user == grabbed)
				return list(/datum/intent/grab/move, /datum/intent/grab/choke)
			else
				return list(/datum/intent/grab/move, /datum/intent/grab/choke, /datum/intent/grab/hostage)

/obj/item/bodypart/head/Exited(atom/movable/gone, direction)
	if(gone == brain)
		brain = null
		update_icon_dropped()
		if(!QDELETED(brainmob)) //this shouldn't happen without badminnery.
			message_admins("Brainmob: ([ADMIN_LOOKUPFLW(brainmob)]) was left stranded in [src] at [ADMIN_VERBOSEJMP(src)] without a brain!")
			brainmob.log_message(", brainmob, was left stranded in [src] without a brain", LOG_GAME)

	if(gone == brainmob)
		brainmob = null

	if(gone == eyes_left)
		eyes_left = null
		update_icon_dropped()

	if(gone == eyes_right)
		eyes_right = null
		update_icon_dropped()

	if(gone == ears)
		ears = null

	if(gone == tongue)
		tongue = null

	return ..()

/obj/item/bodypart/head/drop_organs(mob/user, violent_removal)
	if(user)
		user.visible_message(span_warning("[user] saws [src] open and pulls out a brain!"), span_notice("You saw [src] open and pull out a brain."))

	if(brain && violent_removal && prob(90)) //ghetto surgery can damage the brain.
		to_chat(user, span_warning("[brain] was damaged in the process!"))
		brain.setOrganDamage(brain.maxHealth)

	update_limb()
	sellprice = 0
	return ..()

/obj/item/bodypart/head/update_limb(dropping_limb)
	if(!owner)
		return

	// There should technically to be an ishuman(owner) check here, but it is absent because no basetype carbons use bodyparts
	// No, xenos don't actually use bodyparts. Don't ask.
	var/mob/living/carbon/human/human_owner = owner

	real_name = human_owner.real_name
	if(HAS_TRAIT(human_owner, TRAIT_HUSK))
		real_name = "Unknown"
		lip_style = null

	else if(!animal_origin)
		if(!human_owner?.dna?.species)
			return ..()
		var/datum/species/S = human_owner.dna.species
		// lipstick
		if(human_owner.lip_style && (LIPS in S.species_traits))
			lip_style = human_owner.lip_style
			lip_color = human_owner.lip_color
		else
			lip_style = null
			lip_color = "white"

	return ..()

/obj/item/bodypart/head/update_icon_dropped()
	var/list/standing = get_limb_icon(1)
	if(!standing.len)
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
		return
	for(var/image/I in standing)
		I.pixel_x = px_x
		I.pixel_y = px_y
	add_overlay(standing)

/obj/item/bodypart/head/get_limb_icon(dropped, hideaux = FALSE)
	cut_overlays()
	. = ..()
	if(dropped) //certain overlays only appear when the limb is being detached from its owner.

		if(status != BODYPART_ROBOTIC) //having a robotic head hides certain features.
			//Applies the debrained overlay if there is no brain
			if(!brain)
				var/image/debrain_overlay = image(layer = -HAIR_LAYER, dir = SOUTH)
				debrain_overlay.icon = 'icons/mob/human_face.dmi'
				debrain_overlay.icon_state = "debrained"
				. += debrain_overlay
			//ROGTODO add accessories (earrings, piercings) here

		// lipstick
		if(lip_style)
			var/image/lips_overlay = image('icons/mob/human_face.dmi', "lips_[lip_style]", -BODY_LAYER, SOUTH)
			lips_overlay.color = lip_color
			. += lips_overlay

		// eyes

		var/mutable_appearance/left_overlay
		left_overlay = image('icons/mob/human_face.dmi', "eye-left-missing", -BODY_LAYER, SOUTH)
		. += left_overlay
		if(eyes_left)
			left_overlay.icon_state = eyes_left.eye_icon_state

			if(eyes_left.eye_color)
				left_overlay.color = eyes_left.eye_color

		var/mutable_appearance/right_overlay
		right_overlay = image('icons/mob/human_face.dmi', "eye-right-missing", -BODY_LAYER, SOUTH)
		. += right_overlay
		if(eyes_right)
			right_overlay.icon_state = eyes_right.eye_icon_state

			if(eyes_right.eye_color)
				right_overlay.color = eyes_right.eye_color

/obj/item/bodypart/head/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_head"
	animal_origin = MONKEY_BODYPART
