/obj/effect/proc_holder/spell/invoked/sacred_flame_rogue
	name = "Sacred Flame"
	overlay_state = "sacredflame"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 12
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	req_items = list(/obj/item/clothing/neck/psycross)
	sound = 'sound/magic/heal.ogg'
	invocation = "Cleansing flames, kindle!"
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 8 SECONDS	// the cooldown
	miracle = TRUE
	devotion_cost = 45

/obj/effect/proc_holder/spell/invoked/sacred_flame_rogue/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/L = targets[1]
		user.visible_message("<font color='yellow'>[user] points at [L]!</font>")
		if(L.anti_magic_check(TRUE, TRUE))
			return FALSE
		playsound(user, 'sound/items/flint.ogg', 150, FALSE)
		L.adjust_divine_fire_stacks(3.5)
		L.IgniteMob()
		// addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living, ExtinguishMob)), 7 SECONDS)
		return ..()

	// Spell interaction with ignitable objects (burn wooden things, light torches up)
	else if(isobj(targets[1]))
		var/obj/O = targets[1]
		if(O.fire_act())
			user.visible_message("<font color='yellow'>[user] points at [O], igniting it with sacred flames!</font>")
			var/mob/living/carbon/human/C = user
			var/datum/devotion/cleric_holder/D = C.cleric
			D.update_devotion(25)
			return ..()
		else
			to_chat(user, "<span class='warning'>You point at [O], but it fails to catch fire.</span>")
	return FALSE

/obj/effect/proc_holder/spell/invoked/revive
	name = "Anastasis"
	overlay_state = "revive"
	releasedrain = 90
	chargedrain = 0
	chargetime = 50
	range = 1
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = TRUE
	chargedloop = /datum/looping_sound/invokeholy
	req_items = list(/obj/item/clothing/neck/psycross)
	sound = 'sound/magic/revive.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES
	miracle = TRUE
	healing_miracle = TRUE
	devotion_cost = 100
//	req_inhand = list(/obj/item/coin/gold)

/obj/effect/proc_holder/spell/invoked/revive/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/lux_state = target.get_lux_status()
		if(lux_state != LUX_HAS_LUX)
			return
		if(target == user)
			return FALSE
		if(target.stat < DEAD)
			to_chat(user, "<span class='warning'>Nothing happens.</span>")
			return FALSE
		if(HAS_TRAIT(target, TRAIT_NECRA_CURSE))
			to_chat(user, span_warning("Necra's grasp prevents revival."))
			return FALSE
		if(GLOB.tod == "night")
			to_chat(user, "<span class='warning'>Let there be light.</span>")
		for(var/obj/structure/fluff/psycross/S in oview(5, user))
			S.AOE_flash(user, range = 7)
		if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
			target.visible_message("<span class='danger'>[target] is unmade by holy light!</span>", "<span class='userdanger'>I'm unmade by holy light!</span>")
			target.gib()
			return ..()
		if(target.stat == DEAD && target.can_be_revived()) //we have to grab ghost first
			var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
			//GET OVER HERE!
			if(underworld_spirit)
				var/mob/dead/observer/ghost = underworld_spirit.ghostize()
				qdel(underworld_spirit)
				ghost.mind.transfer_to(target, TRUE)
			target.grab_ghost(force = TRUE) // even suicides
		if(!target.revive(full_heal = FALSE))
			to_chat(user, "<span class='warning'>Astrata's light fails to heal [target]!</span>")
			return FALSE
		GLOB.vanderlin_round_stats[STATS_ASTRATA_REVIVALS]++
		target.emote("breathgasp")
		target.Jitter(100)
		target.update_body()
		target.visible_message("<span class='notice'>[target] is revived by holy light!</span>", "<span class='green'>I awake from the void.</span>")
		target.apply_status_effect(/datum/status_effect/debuff/revive)
		if(target.mind && !HAS_TRAIT(target, TRAIT_IWASREVIVED))
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
		return ..()
	return FALSE

/obj/effect/proc_holder/spell/invoked/revive/cast_check(skipcharge = 0,mob/user = usr)
	if(!..())
		return FALSE
	var/found = null
	for(var/obj/structure/fluff/psycross/S in oview(5, user))
		found = S
	if(!found)
		to_chat(user, "<span class='warning'>I need a holy cross.</span>")
		return FALSE
	return TRUE
