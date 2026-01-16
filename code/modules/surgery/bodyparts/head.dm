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

	grid_width = 64
	grid_height = 64

	var/mob/living/brain/brainmob = null //The current occupant.
	var/obj/item/organ/brain/brain = null //The brain organ
	var/obj/item/organ/eyes/eyes
	var/obj/item/organ/ears/ears
	var/obj/item/organ/tongue/tongue

	//Limb appearance info:
	var/real_name = "" //Replacement name
	//Eye Colouring

	var/lip_style = null
	var/lip_color = "white"

	offset = OFFSET_HEAD

	//subtargets for crits
	subtargets = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_NECK)
	//grabtargets for grabs
	grabtargets = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_NECK)
	resistance_flags = FLAMMABLE

	/// Brainkill means that this head is considered dead and revival is impossible
	var/brainkill = FALSE

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

/obj/item/bodypart/head/Destroy()
	QDEL_NULL(brainmob) //order is sensitive, see warning in handle_atom_del() below
	QDEL_NULL(brain)
	QDEL_NULL(eyes)
	QDEL_NULL(ears)
	QDEL_NULL(tongue)
	return ..()

/obj/item/bodypart/head/handle_atom_del(atom/A)
	if(A == brain)
		brain = null
		update_icon_dropped()
		if(!QDELETED(brainmob)) //this shouldn't happen without badminnery.
			message_admins("Brainmob: ([ADMIN_LOOKUPFLW(brainmob)]) was left stranded in [src] at [ADMIN_VERBOSEJMP(src)] without a brain!")
			log_game("Brainmob: ([key_name(brainmob)]) was left stranded in [src] at [AREACOORD(src)] without a brain!")
	if(A == brainmob)
		brainmob = null
	if(A == eyes)
		eyes = null
		update_icon_dropped()
	if(A == ears)
		ears = null
	if(A == tongue)
		tongue = null
	return ..()

/obj/item/bodypart/head/drop_organs(mob/user, violent_removal)
	var/turf/T = get_turf(src)
	if(status != BODYPART_ROBOTIC)
		playsound(T, 'sound/blank.ogg', 50, TRUE, -1)
	for(var/obj/item/I in src)
		if(I == brain)
			if(user)
				user.visible_message("<span class='warning'>[user] saws [src] open and pulls out a brain!</span>", "<span class='notice'>I saw [src] open and pull out a brain.</span>")
			if(brainmob)
				brainmob.forceMove(brain)
				brain.brainmob = brainmob
				brainmob = null
			if(violent_removal && prob(rand(80, 100))) //ghetto surgery can damage the brain.
				to_chat(user, "<span class='warning'>[brain] was damaged in the process!</span>")
				brain.setOrganDamage(brain.maxHealth)
			brain.forceMove(T)
			brain = null
			update_icon_dropped()
		else
			I.forceMove(T)
	eyes = null
	ears = null
	tongue = null

/obj/item/bodypart/head/update_limb(dropping_limb, mob/living/carbon/source)
	var/mob/living/carbon/C
	if(source)
		C = source
	else
		C = owner

	real_name = C.real_name
	if(HAS_TRAIT(C, TRAIT_HUSK))
		real_name = "Unknown"
		lip_style = null

	else if(!animal_origin)
		var/mob/living/carbon/human/H = C
		if(!H.dna || !H.dna.species)
			return ..()
		var/datum/species/S = H.dna.species
		// lipstick
		if(H.lip_style && (LIPS in S.species_traits))
			lip_style = H.lip_style
			lip_color = H.lip_color
		else
			lip_style = null
			lip_color = "white"
	..()

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
				if(!(NOBLOOD in species_flags_list))
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
		var/image/eyes_overlay = image('icons/mob/human_face.dmi', "eyes_missing", -BODY_LAYER, SOUTH)
		. += eyes_overlay
		if(eyes)
			eyes_overlay.icon_state = eyes.eye_icon_state

			if(eyes.eye_color)
				eyes_overlay.color = "#" + eyes.eye_color

/obj/item/bodypart/head/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_head"
	animal_origin = MONKEY_BODYPART
