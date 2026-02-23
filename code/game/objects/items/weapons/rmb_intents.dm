/datum/rmb_intent
	var/name = "intent"
	var/desc = ""
	var/icon_state = ""
	var/def_bonus = 0
	/// Whether the rclick will try to get turfs as target.
	var/target_turf = FALSE

/datum/rmb_intent/proc/get_target(atom/initial_target)
	if(target_turf)
		return get_turf(initial_target)

	if(ismob(initial_target))
		return initial_target

	for(var/mob/living/potential in get_turf(initial_target))
		return potential

/datum/rmb_intent/proc/special_attack(mob/living/user, atom/target)
	if(!user)
		return FALSE

	if(!user.Adjacent(target))
		return FALSE

	if(user.incapacitated(IGNORE_GRAB))
		return FALSE

	var/mob/living/L = get_target(target)
	if(!istype(L))
		return FALSE

	user.changeNext_move(CLICK_CD_FAST)
	playsound(user, 'sound/combat/feint.ogg', 100, TRUE)
	user.visible_message(span_danger("[user] feints an attack at [target]!"))
	var/perc = 50
	if(user.mind)
		var/obj/item/I = user.get_active_held_item()
		var/ourskill = 0
		var/theirskill = 0
		if(I)
			if(I.associated_skill)
				ourskill = user.get_skill_level(I.associated_skill, TRUE)
			if(L.mind)
				I = L.get_active_held_item()
				if(I?.associated_skill)
					theirskill = L.get_skill_level(I.associated_skill, TRUE)
		perc += (ourskill - theirskill) * 15 	//skill is of the essence
		perc += (user.STAINT - L.STAINT) * 10	//but it's also mostly a mindgame
		perc += (user.STASPD - L.STASPD) * 5 	//yet a speedy feint is hard to counter
		perc += (user.STAPER - L.STAPER) * 5 	//a good eye helps

	if(!user.cmode)
		perc = 0

	if(L.has_status_effect(/datum/status_effect/debuff/exposed))
		perc = 0

	if(user.has_status_effect(/datum/status_effect/debuff/feintcd))
		perc -= rand(10,30)

	user.apply_status_effect(/datum/status_effect/debuff/feintcd)
	perc = CLAMP(perc, 0, 90) //no zero risk superfeinting

	if(prob(perc)) //feint intent increases the immobilize duration significantly
		if(istype(user.rmb_intent, /datum/rmb_intent/feint))
			L.changeNext_move(10)
			L.Immobilize(15)
		else
			L.changeNext_move(4)
			L.Immobilize(5)
		L.apply_status_effect(/datum/status_effect/debuff/exposed, 5 SECONDS)
		to_chat(user, span_notice("[L] fell for my feint attack!"))
		to_chat(L, span_danger("I fall for [user]'s feint attack!"))
	else if(user.client?.prefs.showrolls)
		to_chat(user, span_warning("[L] did not fall for my feint... [perc]%"))

	return TRUE

/datum/rmb_intent/aimed
	name = "aimed"
	desc = "Your attacks are more precise but have a longer recovery time. Higher chance for certain critical hits. Reduced dodge bonus."
	icon_state = "rmbaimed"
	def_bonus = -20

/datum/rmb_intent/strong
	name = "strong"
	desc = "Your attacks have increased strength and have increased force but use more stamina. Higher chance for certain critical hits. Intentionally fails surgery steps. Reduced dodge bonus."
	icon_state = "rmbstrong"
	def_bonus = -20
	target_turf = TRUE

/datum/rmb_intent/strong/special_attack(mob/living/user, atom/target)
	if(!user)
		return FALSE

	if(user.incapacitated(IGNORE_GRAB))
		return FALSE

	if(user.has_status_effect(/datum/status_effect/debuff/specialcd))
		return FALSE

	var/turf/T = get_target(target)
	if(!istype(T))
		return FALSE

	var/obj/item/weapon/held_weapon = user.get_active_held_item()

	if(!istype(held_weapon) || !held_weapon.weapon_special)
		return FALSE

	var/datum/special_intent/special = held_weapon.weapon_special

	if(!special.deploy(user, held_weapon, target))
		return FALSE // Invalid starting args somehow

	special.apply_cost(user)

	user.changeNext_move(CLICK_CD_MELEE)

	return TRUE

/datum/rmb_intent/swift
	name = "swift"
	desc = "Your attacks have less recovery time but are less accurate and have reduced strength."
	icon_state = "rmbswift"

/datum/rmb_intent/feint
	name = "feint"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) A deceptive half-attack with no follow-through, meant to force your opponent to open their guard. Useless against someone who is dodging."
	icon_state = "rmbfeint"
	def_bonus = 10

/datum/status_effect/debuff/riposted
	id = "riposted"
	duration = 30

/datum/rmb_intent/riposte
	name = "defend"
	desc = "No delay between dodge and parry rolls."
	icon_state = "rmbdef"
	def_bonus = 10

/datum/rmb_intent/guard
	name = "guarde"
	desc = "(RMB WHILE DEFENSE IS ACTIVE) Raise your weapon, ready to attack any creature who moves onto the space you are guarding."
	icon_state = "rmbguard"

/datum/rmb_intent/weak
	name = "weak"
	desc = "Your attacks have halved strength and will never critically-hit. Surgery steps can only be done with this intent. Useful for longer punishments, play-fighting, and bloodletting."
	icon_state = "rmbweak"
