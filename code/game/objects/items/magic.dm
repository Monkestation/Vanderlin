/////////////////////////////////////////Scrying///////////////////

/obj/item/scrying
	name = "scrying orb"
	desc = "On its glass depths, you can scry on many unsuspecting beings..."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state ="scrying"
	throw_speed = 3
	throw_range = 7
	throwforce = 15
	damtype = BURN
	force = 15
	hitsound = 'sound/blank.ogg'
	sellprice = 30
	dropshrink = 0.6

	grid_height = 32
	grid_width = 32

	var/mob/current_owner
	var/last_scry
	var/cooldown = 30 SECONDS

/obj/item/scrying/eye
	name = "accursed eye"
	desc = "It is pulsating."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state ="scryeye"
	cooldown = 5 MINUTES

/obj/item/scrying/attack_self(mob/user, list/modifiers)
	. = ..()
	if(world.time < last_scry + cooldown)
		to_chat(user, span_warning("I look into [src] but only see inky smoke. Maybe I should wait."))
		return
	var/input = stripped_input(user, "Who are you looking for?", "Scrying Orb")
	if(!input)
		return
	if(!user.key)
		return
	if(!user.mind || !user.mind.do_i_know(name=input))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return
	//check is applied twice to prevent someone from bypassing the cooldown
	if(world.time < last_scry + cooldown)
		to_chat(user, span_warning("I look into [src] but only see inky smoke. Maybe I should wait."))
		return
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == input)
			var/turf/T = get_turf(HL)
			if(!T)
				continue
			if(HAS_TRAIT(HL, TRAIT_ANTISCRYING))
				to_chat(user, span_warning("I peer into [src], but an impenetrable fog shrouds [input]."))
				to_chat(HL, span_warning("My magical shrouding reacted to something."))
				return
			log_game("SCRYING: [user.real_name] ([user.ckey]) has used the scrying orb to leer at [HL.real_name] ([HL.ckey])")
			ADD_TRAIT(user, TRAIT_NOSSDINDICATOR, "scryingorb")
			var/mob/dead/observer/screye/S = user.scry_ghost()
			if(!S)
				return
			S.ManualFollow(HL)
			last_scry = world.time
			user.visible_message(span_danger("[user] stares into [src], [p_their()] eyes rolling back into [p_their()] head."))
			addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)
			if(!HL.stat)
				if(HL.STAPER >= 15)
					if(HL.mind)
						if(HL.mind.do_i_know(name=user.real_name))
							to_chat(HL, span_warning("I can clearly see the face of [user.real_name] staring at me!"))
							to_chat(user, span_warning("[HL.real_name] stares back at me!"))
							return
					to_chat(HL, span_warning("I can clearly see the face of an unknown [user.gender == FEMALE ? "woman" : "man"] staring at me!"))
					return
				if(HL.STAPER >= 11)
					to_chat(HL, span_warning("I feel a pair of unknown eyes on me."))
			REMOVE_TRAIT(user, TRAIT_NOSSDINDICATOR, "scryingorb")
			return
	to_chat(user, span_warning("I peer into [src], but can't find [input]."))
	return

//23.08.2025
//crystallball and nocdevice are depreciated?

/////////////////////////////////////////Crystal ball ghsot vision///////////////////

/obj/item/crystalball/attack_self(mob/user, list/modifiers)
	user.visible_message("<span class='danger'>[user] stares into [src], their eyes rolling back into their head.</span>")
	user.ghostize(1)

/*	..................   NOC Device (Fixed scrying ball)   ................... */
/obj/structure/nocdevice
	name = "NOC Device"
	desc = "An intricate lunar observation machine, that allows its user to study the face of Noc in the sky, reflecting the true whereabouts of hidden beings..."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "nocdevice"
	plane = -1
	layer = 4.2
	var/last_scry

/obj/structure/nocdevice/attack_hand(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(H.virginity)
		if(world.time < last_scry + 30 SECONDS)
			to_chat(user, "<span class='warning'>I peer into the sky but cannot focus the lens on the face of Noc. Maybe I should wait.</span>")
			return
		var/input = stripped_input(user, "Who are you looking for?", "Scrying Orb")
		if(!input)
			return
		if(!user.key)
			return
		if(world.time < last_scry + 30 SECONDS)
			to_chat(user, "<span class='warning'>I peer into the sky but cannot focus the lens on the face of Noc. Maybe I should wait.</span>")
			return
		if(!user.mind || !user.mind.do_i_know(name=input))
			to_chat(user, "<span class='warning'>I don't know anyone by that name.</span>")
			return
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			if(HL.real_name == input)
				var/turf/T = get_turf(HL)
				if(!T)
					continue
				var/mob/dead/observer/screye/S = user.scry_ghost()
				if(!S)
					return
				S.ManualFollow(HL)
				last_scry = world.time
				user.visible_message("<span class='danger'>[user] stares into [src], [p_their()] squinting and concentrating...</span>")
				addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), 8 SECONDS)
				if(!HL.stat)
					if(HL.STAPER >= 15)
						if(HL.mind)
							if(HL.mind.do_i_know(name=user.real_name))
								to_chat(HL, "<span class='warning'>I can clearly see the face of [user.real_name] staring at me!.</span>")
								return
						to_chat(HL, "<span class='warning'>I can clearly see the face of an unknown [user.gender == FEMALE ? "woman" : "man"] staring at me!</span>")
						return
					if(HL.STAPER >= 11)
						to_chat(HL, "<span class='warning'>I feel a pair of unknown eyes on me.</span>")
				return
		to_chat(user, "<span class='warning'>I peer into the viewpiece, but Noc does not reveal where [input] is.</span>")
		return
	else
		to_chat(user, "<span class='notice'>Noc looks angry with me...</span>")
