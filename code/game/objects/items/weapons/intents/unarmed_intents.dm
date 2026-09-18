
/datum/intent/unarmed
	unarmed = TRUE

/datum/intent/unarmed/punch
	name = "punch"
	icon_state = "inpunch"
	attack_verb = list("punches", "jabs", "clocks")
	chargetime = 0
	animname = "punch"
	hitsound = list('sound/combat/hits/punch/punch (1).ogg', 'sound/combat/hits/punch/punch (2).ogg', 'sound/combat/hits/punch/punch (3).ogg')
	misscost = 5
	releasedrain = 1
	swingdelay = 0
	rmb_ranged = TRUE
	candodge = TRUE
	canparry = TRUE
	blade_class = BCLASS_PUNCH
	miss_text = "swings a fist at the air!"
	miss_sound = "punchwoosh"
	item_damage_type = "blunt"

/datum/intent/unarmed/punch/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_red("[user] taunts [M]!"), span_red("I taunt [M]!"), ignored_mobs = targetl)
		user.emote("taunt")
		if(M.client)
			M.taunted(user)
			if(M.can_see_cone(user))
				to_chat(M, span_red("[user] taunts me!"))
		else
			M.taunted(user)
	return

/datum/intent/unarmed/shove
	name = "shove"
	icon_state = "inshove"
	attack_verb = list("shoves")
	chargetime = 0
	noaa = TRUE
	rmb_ranged = TRUE
	misscost = 5
	releasedrain = 2
	item_damage_type = "blunt"

/datum/intent/unarmed/shove/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_blue("[user] shoos [M] away."), span_blue("I shoo [M] away."), ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_blue("[user] shoos me away."))
		else
			M.shood(user)
	return

/datum/intent/unarmed/grab
	name = "grab"
	icon_state = "ingrab"
	attack_verb = list("grabs")
	chargetime = 0
	noaa = TRUE
	rmb_ranged = TRUE
	releasedrain = 3
	misscost = 6.5
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "blunt"

/datum/intent/unarmed/grab/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_yellow("[user] beckons [M] to come closer."), span_yellow("I beckon [M] to come closer."), ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_yellow("[user] beckons me to come closer."))
		else
			M.beckoned(user)
	return

/datum/intent/unarmed/help
	name = "touch"
	icon_state = "intouch"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
	releasedrain = 0
	rmb_ranged = TRUE

/datum/intent/unarmed/help/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		user.visible_message(span_green("[user] waves friendly at [M]."), span_green("I wave friendly at [M]."), ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, span_green("[user] gives me a friendly wave."))
	return
