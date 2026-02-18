/mob/living/carbon/spirit
	name = "Wanderer"
	verb_say = "moans"
	initial_language_holder = /datum/language_holder/universal
	icon = 'icons/roguetown/underworld/enigma_husks.dmi'
	icon_state = "hollow"
	gender = NEUTER
	pass_flags = PASSTABLE
	mob_biotypes = MOB_SPIRIT|MOB_HUMANOID
	gib_type = /obj/effect/decal/cleanable/blood/gibs
	bodyparts = list(/obj/item/bodypart/chest/spirit, /obj/item/bodypart/head/spirit, /obj/item/bodypart/l_arm/spirit,
					/obj/item/bodypart/r_arm/spirit, /obj/item/bodypart/r_leg/spirit, /obj/item/bodypart/l_leg/spirit)
	hud_type = /datum/hud/spirit
	var/paid = FALSE
	var/beingmoved = FALSE //repurposed for speak with soul
	var/livingname = null
	var/summoned = FALSE //summoned by Speak with Soul spell before

/obj/item/bodypart/chest/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/head/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/l_arm/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/l_leg/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/r_arm/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/obj/item/bodypart/r_leg/spirit
	icon = 'icons/roguetown/underworld/underworld.dmi'
	icon_state = "spiritpart"

/mob/living/carbon/spirit/Initialize(mapload, cubespawned=FALSE, mob/spawner)
//	coin_upkeep()	costly and not needed with the give_patron_toll failsafe if maze is drained
	// add_verb(src, /mob/living/proc/mob_sleep)
	add_verb(src, /mob/living/proc/lay_down)
	ADD_TRAIT(src, TRAIT_PACIFISM, "status effects")
	var/first_part = pick("Sorrowful", "Forlorn", "Regretful", "Piteous", "Rueful", "Dejected", "Desolate", "Mournful", "Melancholic", "Woeful")
	var/second_part = pick("Wanderer", "Traveler", "Pilgrim", "Vagabond", "Nomad", "Wayfarer", "Spirit", "Specter", "Wraith", "Phantom")
	name = first_part + " " + second_part
	GLOB.spirit_list += src

	//initialize limbs
	create_bodyparts()
	create_internal_organs()
	. = ..()
	var/L = new /obj/item/flashlight/flare/torch/lantern/shrunken(src.loc)
	put_in_hands(L)
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_BAREFOOT, 1, -6)

/mob/living/carbon/spirit/create_internal_organs()
	internal_organs += new /obj/item/organ/lungs
	internal_organs += new /obj/item/organ/heart
	internal_organs += new /obj/item/organ/brain
	internal_organs += new /obj/item/organ/tongue
	internal_organs += new /obj/item/organ/eyes/no_render
	internal_organs += new /obj/item/organ/ears
	internal_organs += new /obj/item/organ/liver
	internal_organs += new /obj/item/organ/stomach
	..()

/mob/living/carbon/spirit/Destroy()
	GLOB.spirit_list -= src
	return ..()


/mob/living/carbon/spirit/IgniteMob() // Override so they don't catch on fire.
	return

/mob/living/carbon/spirit/proc/give_patron_toll()
	if(QDELETED(src) || paid)
		return
	for(var/item in held_items)
		if(istype(item, /obj/item/underworld/coin))
			return

	if(beingmoved)
		paid = TRUE
	else
		src.put_in_hands(new /obj/item/underworld/coin)

	if(patron)
		to_chat(src, span_danger("Your suffering has not gone unnoticed, [patron] has [paid ? "paid for your toll" : "rewarded you with your toll"]."))
	else
		to_chat(src, span_danger("Your suffering has not gone unnoticed, your patron has [paid ? "paid for your toll" : "rewarded you with your toll"]."))
	playsound(src, 'sound/combat/caught.ogg', 80, TRUE, -1)

/mob/living/carbon/spirit/updatehealth(amount)
	. = ..()
	var/slow = 0
	if(!HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		var/health_deficiency = (maxHealth - health)
		if(health_deficiency >= 45)
			slow += (health_deficiency / 25)
	add_movespeed_modifier(MOVESPEED_ID_MONKEY_HEALTH_SPEEDMOD, TRUE, 100, override = TRUE, multiplicative_slowdown = slow)


/mob/living/carbon/spirit/returntolobby()
	set name = "{RETURN TO LOBBY}"
	set category = "Preferences.Options"
	set hidden = 1

	if(key)
		GLOB.respawntimes[key] = world.time

	log_game("[key_name(usr)] respawned from underworld")

	to_chat(src, span_info("Returned to lobby successfully."))

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void

	remove_client_colour(/datum/client_colour/monochrome)
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
	qdel(src)
	return


/*/mob/living/carbon/spirit/attack_animal(mob/living/simple_animal/M)
	if(beingmoved)
		return
	beingmoved = TRUE
	to_chat(src, "<B><font size=3 color=red>Your soul is dragged to an infathomably cruel place where it endures severe torment. You've all but given up hope when you feel a presence drag you back to that Forest.</font></B>")
	playsound(src, 'sound/combat/caught.ogg', 80, TRUE, -1)
	for(var/obj/effect/landmark/underworld/A in GLOB.landmarks_list)
		forceMove(A.loc)
	beingmoved = FALSE*/

///Get the underworld spirit associated with this mob (from the mind)
/mob/proc/get_spirit()
	var/mind_key = key || mind?.key
	if(!mind_key)
		return
	for(var/mob/living/carbon/spirit/spirit in GLOB.spirit_list)
		if((ckey(spirit.key) == ckey(mind_key)) || (ckey(spirit.mind?.key) == ckey(mind_key)))
			return spirit

/mob/living/carbon/spirit/get_spirit()
	return src

/mob/proc/pacifyme(mob/user)
	return pacify_corpse(src, user)

/// Proc that will search inside a given atom for any corpses and pacify them
/proc/pacify_coffin(atom/movable/coffin, mob/user, deep = TRUE)
	if(!coffin)
		return FALSE
	var/success = FALSE
	if(isliving(coffin))
		if(pacify_corpse(coffin, user))
			success = TRUE
	for(var/mob/living/corpse in coffin)
		if(pacify_corpse(corpse, user))
			success = TRUE
	for(var/mob/living/carbon/human/human_corpse in coffin)
		if(human_corpse.funeral) /* The proc succeeds even if the corpse already received a funeral before.
	    Coffins and graves have checks to prevent giving too much influence / devotion to Necra. */
			success = TRUE
	for(var/obj/item/bodypart/head/head in coffin)
		if(!head.brainmob)
			continue
		if(pacify_corpse(head.brainmob, user))
			success = TRUE
	//if this is a deep search, we will also search the contents of the container to pacify (EXCEPT MOBS, SINCE WE HANDLED THOSE)
	if(deep)
		for(var/atom/movable/stuffing in coffin)
			if(isliving(stuffing) || istype(stuffing, /obj/item/bodypart/head))
				continue
			if(pacify_coffin(stuffing, user, deep))
				success = TRUE
	return success



/// Proc that finds the client associated with a given corpse and either 1. Lets ghosts skip Underworld and return to lobby 2. Gives spirits a toll
/proc/pacify_corpse(mob/living/corpse, mob/user)
	. = FALSE
	if(QDELETED(corpse) || (corpse.stat != DEAD))
		return
	// funeral + buried will make Journey to Underworld function as return to lobby
	if(ishuman(corpse))
		var/mob/living/carbon/human/human_corpse = corpse
		if(!human_corpse.funeral)
			human_corpse.funeral = TRUE
			. = TRUE
	var/datum/mind/corpse_mind = get_mind(corpse, include_last = TRUE)
	if(corpse_mind?.remove_antag_datum(/datum/antagonist/zombie))
		. = TRUE
	if(QDELETED(corpse_mind) || corpse.has_quirk(/datum/quirk/vice/hardcore))
		return
	var/mob/ghost
	//Try to find a lost ghost if there is no client
	if(!corpse.client && !corpse.has_quirk(/datum/quirk/vice/hardcore))
		ghost = corpse.get_ghost()
		//Try to find underworld spirit, if there is no observer ghost
		if(!ghost)
			ghost = corpse.get_spirit()
			if(ghost && ishuman(corpse))
				var/mob/living/carbon/spirit/spirit = ghost
				var/mob/living/carbon/human/human_corpse = corpse
				if(istype(human_corpse.mouth, /obj/item/coin) && !HAS_TRAIT(corpse, TRAIT_BURIED_COIN_GIVEN))
					ADD_TRAIT(human_corpse, TRAIT_BURIED_COIN_GIVEN, TRAIT_GENERIC)
					if(spirit.beingmoved)
						to_chat(ghost, span_rose("Your toll to the Carriageman has been paid!"))
						spirit.paid = TRUE
					else
						spirit.put_in_hands(new /obj/item/underworld/coin)
						to_chat(spirit, span_rose("A coin falls from above into your hands!"))
					return TRUE
	else
		ghost = corpse.ghostize(force_respawn = TRUE)

	if(ghost)
		var/user_acknowledgement = user ? user.real_name : "a mysterious force"
		to_chat(ghost, span_rose("My soul finds peace buried in consecrated ground, thanks to [user_acknowledgement]."))

/mob/living/carbon/spirit/show_inv(mob/user)
	return

/mob/living/carbon/spirit/toggle_move_intent()
	m_intent = MOVE_INTENT_WALK
