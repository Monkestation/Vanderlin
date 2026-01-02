

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M)
	. = ..()
	switch(M.used_intent.type)
		if(INTENT_HELP)
			if (health > 0)
				visible_message("<span class='notice'>[M] [response_help_continuous] [src].</span>", \
								"<span class='notice'>[M] [response_help_continuous] you.</span>", null, null, M)
				to_chat(M, "<span class='notice'>I [response_help_simple] [src].</span>")
				playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)
			return TRUE

		if(INTENT_GRAB)
			if(!M.has_hand_for_held_index(M.active_hand_index, TRUE)) //we obviously have a hand, but we need to check for fingers/prosthetics
				to_chat(M, "<span class='warning'>I can't move the fingers of my [M.active_hand_index == 1 ? "left" : "right"] hand.</span>")
				return
			grabbedby(M)
			return TRUE

		if(INTENT_HARM)
			var/atk_verb = pick(M.used_intent.attack_verb)
			if(HAS_TRAIT(M, TRAIT_PACIFISM))
				to_chat(M, "<span class='warning'>I don't want to hurt [src]!</span>")
				return
			M.do_attack_animation(src, M.used_intent.animname, atom_bounce = TRUE)
			playsound(loc, punched_sound, 25, TRUE, -1)
			var/damage = M.get_punch_dmg()
			next_attack_msg.Cut()
			attack_threshold_check(damage)
			log_combat(M, src, "attacked")
			updatehealth()
			var/hitlim = simple_limb_hit(M.zone_selected)
			simple_woundcritroll(M.used_intent.blade_class, damage, M, hitlim)
			visible_message("<span class='danger'>[M] [atk_verb] [src]![next_attack_msg.Join()]</span>",\
							"<span class='danger'>[M] [atk_verb] me![next_attack_msg.Join()]</span>", null, COMBAT_MESSAGE_RANGE)
			next_attack_msg.Cut()
			return TRUE

		if(INTENT_DISARM)
			var/mob/living/carbon/human/user = M
			var/mob/living/simple_animal/target = src
			if(HAS_TRAIT(src, TRAIT_FLOORED))
				return FALSE
			if(user == target)
				return FALSE
			if(user.loc == target.loc)
				return FALSE
			else
				user.do_attack_animation(target, ATTACK_EFFECT_DISARM, atom_bounce = TRUE)
				playsound(target, 'sound/combat/shove.ogg', 100, TRUE, -1)

				var/turf/target_oldturf = target.loc
				var/shove_dir = get_dir(user.loc, target_oldturf)
				var/turf/target_shove_turf = get_step(target.loc, shove_dir)
				var/mob/living/target_collateral_mob
				var/obj/structure/table/target_table
				var/shove_blocked = FALSE //Used to check if a shove is blocked so that if it is knockdown logic can be applied
				if(prob(clamp(30 + (user.stat_compare(target, STATKEY_STR, STATKEY_CON)*10),0,100)))//check if we actually shove them
					target_collateral_mob = locate(/mob/living) in target_shove_turf.contents
					if(target_collateral_mob)
						shove_blocked = TRUE
					else
						target.Move(target_shove_turf, shove_dir)
						if(get_turf(target) == target_oldturf)
							target_table = locate(/obj/structure/table) in target_shove_turf.contents
							if(target_table)
								shove_blocked = TRUE

				if(shove_blocked && !target.buckled)
					var/directional_blocked = FALSE
					if(shove_dir in GLOB.cardinals) //Directional checks to make sure that we're not shoving through a windoor or something like that
						var/target_turf = get_turf(target)
						for(var/obj/O in target_turf)
							if(O.flags_1 & ON_BORDER_1 && O.dir == shove_dir && O.density)
								directional_blocked = TRUE
								break
						if(target_turf != target_shove_turf) //Make sure that we don't run the exact same check twice on the same tile
							for(var/obj/O in target_shove_turf)
								if(O.flags_1 & ON_BORDER_1 && O.dir == turn(shove_dir, 180) && O.density)
									directional_blocked = TRUE
									break
					if((!target_table && !target_collateral_mob) || directional_blocked)
						target.Stun(10)
						target.visible_message("<span class='danger'>[user.name] shoves [target.name]!</span>",
										"<span class='danger'>I'm shoved by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
						to_chat(user, "<span class='danger'>I shove [target.name]!</span>")
						log_combat(user, target, "shoved", "knocking them down")
					else if(target_table)
						target.Stun(10)
						target.visible_message("<span class='danger'>[user.name] shoves [target.name] onto \the [target_table]!</span>",
										"<span class='danger'>I'm shoved onto \the [target_table] by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
						to_chat(user, "<span class='danger'>I shove [target.name] onto \the [target_table]!</span>")
						target.throw_at(target_table, 1, 1, null, FALSE) //1 speed throws with no spin are basically just forcemoves with a hard collision check
						log_combat(user, target, "shoved", "onto [target_table] (table)")
					else if(target_collateral_mob)
						target.Stun(10)
						target_collateral_mob.Stun(SHOVE_KNOCKDOWN_COLLATERAL)
						target.visible_message("<span class='danger'>[user.name] shoves [target.name] into [target_collateral_mob.name]!</span>",
							"<span class='danger'>I'm shoved into [target_collateral_mob.name] by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", COMBAT_MESSAGE_RANGE, user)
						to_chat(user, "<span class='danger'>I shove [target.name] into [target_collateral_mob.name]!</span>")
						log_combat(user, target, "shoved", "into [target_collateral_mob.name]")
				else
					target.visible_message("<span class='danger'>[user.name] shoves [target.name]!</span>",
									"<span class='danger'>I'm shoved by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, user)
					to_chat(user, "<span class='danger'>I shove [target.name]!</span>")
					log_combat(user, target, "shoved")
			return TRUE

	if(M.used_intent.unarmed)
		var/atk_verb = pick(M.used_intent.attack_verb)
		if(HAS_TRAIT(M, TRAIT_PACIFISM))
			to_chat(M, "<span class='warning'>I don't want to hurt [src]!</span>")
			return
		M.do_attack_animation(src, M.used_intent.animname, atom_bounce = TRUE)
		playsound(loc, punched_sound, 25, TRUE, -1)
		var/damage = M.get_punch_dmg()
		next_attack_msg.Cut()
		attack_threshold_check(damage)
		log_combat(M, src, "attacked")
		updatehealth()
		var/hitlim = simple_limb_hit(M.zone_selected)
		simple_woundcritroll(M.used_intent.blade_class, damage, M, hitlim)
		visible_message("<span class='danger'>[M] [atk_verb] [src]![next_attack_msg.Join()]</span>",\
						"<span class='danger'>[M] [atk_verb] me![next_attack_msg.Join()]</span>", null, COMBAT_MESSAGE_RANGE)
		next_attack_msg.Cut()
		return TRUE

/mob/living/simple_animal/attack_paw(mob/living/carbon/monkey/M)
	if(..()) //successful monkey bite.
		if(stat != DEAD)
			var/damage = rand(1, 3)
			attack_threshold_check(damage)
			return 1
	if (M.used_intent.type == INTENT_HELP)
		if (health > 0)
			visible_message("<span class='notice'>[M.name] [response_help_continuous] [src].</span>", \
							"<span class='notice'>[M.name] [response_help_continuous] you.</span>", null, COMBAT_MESSAGE_RANGE, M)
			to_chat(M, "<span class='notice'>I [response_help_simple] [src].</span>")
			playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)


/mob/living/simple_animal/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		next_attack_msg.Cut()
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/hitlim = simple_limb_hit(M.zone_selected)
		attack_threshold_check(damage, M.melee_damage_type)
		simple_woundcritroll(M.a_intent.blade_class, damage, M, hitlim)
		visible_message("<span class='danger'>\The [M] [pick(M.a_intent.attack_verb)] [src]![next_attack_msg.Join()]</span>", \
					"<span class='danger'>\The [M] [pick(M.a_intent.attack_verb)] me![next_attack_msg.Join()]</span>", null, COMBAT_MESSAGE_RANGE)
		next_attack_msg.Cut()



/mob/living/simple_animal/onkick(mob/M)
	var/mob/living/simple_animal/target = src
	var/mob/living/carbon/human/user = M
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='warning'>I don't want to harm [target]!</span>")
		return FALSE
	if(HAS_TRAIT(src, TRAIT_FLOORED))
		return FALSE
	if(user == target)
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_GARROTED))
		if(user.check_leg_grabbed(1) || user.check_leg_grabbed(2))
			to_chat(user, "<span class='notice'>I can't move my leg!</span>")
			return
	if(user.stamina >= user.maximum_stamina)
		return FALSE
	if(user.loc == target.loc)
		to_chat(user, "<span class='warning'>I'm too close to get a good kick in.</span>")
		return FALSE
	else
		playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)

		var/shove_dir = get_dir(user.loc, target.loc)
		var/turf/target_shove_turf = get_step(target.loc, shove_dir)

		target.Move(target_shove_turf, shove_dir)

		target.visible_message("<span class='danger'>[user.name] kicks [target.name]!</span>",
						"<span class='danger'>I'm kicked by [user.name]!</span>", "<span class='hear'>I hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, user)
		to_chat(user, "<span class='danger'>I kick [target.name]!</span>")
		log_combat(user, target, "kicked")
		playsound(target, 'sound/combat/hits/kick/kick.ogg', 100, TRUE, -1)
		target.lastattacker = user.real_name
		target.lastattackerckey = user.ckey
		target.lastattacker_weakref = WEAKREF(user)
		if(target.mind)
			target.mind.attackedme[user.real_name] = world.time
		user.adjust_stamina(15)

/mob/living/simple_animal/proc/attack_threshold_check(damage, damagetype = BRUTE, armorcheck = "blunt")
	var/temp_damage = damage
	if(!damage_coeff[damagetype])
		temp_damage = 0
	else
		temp_damage *= damage_coeff[damagetype]

	if(temp_damage >= 0 && temp_damage <= force_threshold)
		visible_message("<span class='warning'>[src] looks unharmed!</span>")
		return FALSE
	else
		apply_damage(damage, damagetype, null, getarmor(null, armorcheck))
		return TRUE

/mob/living/simple_animal/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	..()
	if (!severity)
		return
	var/ddist = devastation_range
	var/hdist = heavy_impact_range
	var/ldist = light_impact_range
	var/fdist = flame_range
	var/fodist = get_dist(src, epicenter)
	var/brute_loss = 0
	var/burn_loss = 0
	var/dmgmod = round(rand(0.5, 1.5), 0.1)

	if(fdist)
		var/stacks = ((fdist - fodist) * 2)
		fire_act(stacks)

	switch(severity)
		if(EXPLODE_DEVASTATE)
			brute_loss = ((120 * ddist) - (120 * fodist) * dmgmod)
			burn_loss = ((60 * ddist) - (60 * fodist) * dmgmod)
			Unconscious((50 * ddist) - (15 * fodist))
			Knockdown((30 * ddist) - (30 * fodist))

		if(EXPLODE_HEAVY)
			brute_loss = ((40 * hdist) - (40 * fodist) * dmgmod)
			burn_loss = ((20 * hdist) - (20 * fodist) * dmgmod)
			Unconscious((10 * hdist) - (5 * fodist))
			Knockdown((30 * hdist) - (30 * fodist))

		if(EXPLODE_LIGHT)
			brute_loss = ((10 * ldist) - (10 * fodist) * dmgmod)

	take_overall_damage(brute_loss,burn_loss)

/mob/living/simple_animal/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect, item_animation_override = null, datum/intent/used_intent, atom_bounce)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()
