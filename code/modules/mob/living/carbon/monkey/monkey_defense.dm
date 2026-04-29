/mob/living/carbon/monkey/help_shake_act(mob/living/carbon/M)
	if(health < 0 && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.do_cpr(src)
	else
		..()

/mob/living/carbon/monkey/attack_paw(mob/living/M)
	if(..()) //successful monkey bite.
		var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
		if(!affecting)
			affecting = get_bodypart(BODY_ZONE_CHEST)
		if(M.limb_destroyer)
			dismembering_strike(M, affecting.body_zone)
		if(stat != DEAD)
			var/dmg = rand(1, 5)
			apply_damage(dmg, BRUTE, affecting)

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M)
	if(..())	//To allow surgery to return properly.
		return

	switch(M.used_intent.type)
		if(INTENT_HELP)
			help_shake_act(M)
		if(INTENT_GRAB)
			grabbedby(M)
		if(INTENT_HARM)
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			if (prob(75))
				visible_message("<span class='danger'>[M] punches [name]!</span>", \
								"<span class='danger'>[M] punches you!</span>", "<span class='hear'>I hear a sickening sound of flesh hitting flesh!</span>", COMBAT_MESSAGE_RANGE, M)
				to_chat(M, "<span class='danger'>I punch [name]!</span>")

				playsound(src, "punch", 25, TRUE, -1)
				var/damage = rand(5, 10)
				if(prob(40))
					damage = rand(10, 15)
					if(AmountUnconscious() < 100 && health > 0)
						Unconscious(rand(200, 300))
						visible_message("<span class='danger'>[M] knocks [name] out!</span>", \
										"<span class='danger'>[M] knocks you out!</span>", "<span class='hear'>I hear a sickening sound of flesh hitting flesh!</span>", 5, M)
						to_chat(M, "<span class='danger'>I knock [name] out!</span>")
				var/obj/item/bodypart/affecting = get_bodypart(ran_zone(M.zone_selected))
				if(!affecting)
					affecting = get_bodypart(BODY_ZONE_CHEST)
				apply_damage(damage, BRUTE, affecting)
				log_combat(M, src, "attacked")

			else
				playsound(src, 'sound/blank.ogg', 25, TRUE, -1)
				visible_message("<span class='danger'>[M]'s punch misses [name]!</span>", \
								"<span class='danger'>I avoid [M]'s punch!</span>", "<span class='hear'>I hear a swoosh!</span>", COMBAT_MESSAGE_RANGE, M)
				to_chat(M, "<span class='warning'>My punch misses [name]!</span>")
		if(INTENT_DISARM)
			if(stat < UNCONSCIOUS)
				M.do_attack_animation(src, ATTACK_EFFECT_DISARM)
				if (prob(25))
					Paralyze(40)
					playsound(src, 'sound/blank.ogg', 50, TRUE, -1)
					log_combat(M, src, "pushed")
					visible_message("<span class='danger'>[M] pushes [src] down!</span>", \
									"<span class='danger'>[M] pushes you down!</span>", "<span class='hear'>I hear aggressive shuffling followed by a loud thud!</span>", null, M)
					to_chat(M, "<span class='danger'>I push [src] down!</span>")
				else if(dropItemToGround(get_active_held_item()))
					playsound(src, 'sound/blank.ogg', 50, TRUE, -1)
					visible_message("<span class='danger'>[M] disarms [src]!</span>", \
									"<span class='danger'>[M] disarms you!</span>", "<span class='hear'>I hear aggressive shuffling!</span>", COMBAT_MESSAGE_RANGE, M)
					to_chat(M, "<span class='danger'>I disarm [src]!</span>")


/mob/living/carbon/monkey/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		var/dam_zone = dismembering_strike(M, pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
		if(!dam_zone) //Dismemberment successful
			return TRUE
		var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
		if(!affecting)
			affecting = get_bodypart(BODY_ZONE_CHEST)
		apply_damage(damage, M.melee_damage_type, affecting)

/mob/living/carbon/monkey/acid_act(acidpwr, acid_volume, bodyzone_hit)
	. = 1
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_HEAD)
		if(wear_mask)
			if(!(wear_mask.resistance_flags & UNACIDABLE))
				wear_mask.acid_act(acidpwr, acid_volume)
			else
				to_chat(src, "<span class='warning'>My mask protects you from the acid.</span>")
			return
		if(head)
			if(!(head.resistance_flags & UNACIDABLE))
				head.acid_act(acidpwr, acid_volume)
			else
				to_chat(src, "<span class='warning'>My hat protects you from the acid.</span>")
			return
	take_bodypart_damage(acidpwr * min(0.6, acid_volume*0.1))


/mob/living/carbon/monkey/ex_act(severity, target, origin)
	if(origin && istype(origin, /datum/vine_mutation) && isvineimmune(src))
		return
	..()

	switch (severity)
		if (EXPLODE_DEVASTATE)
			gib()
			return

		if (EXPLODE_HEAVY)
			take_overall_damage(60, 60)
			damage_clothes(200, BRUTE, "blunt")
			adjustEarDamage(30, 120)
			if(prob(70))
				Unconscious(200)

		if(EXPLODE_LIGHT)
			take_overall_damage(30, 0)
			damage_clothes(50, BRUTE, "blunt")
			adjustEarDamage(15,60)
			if (prob(50))
				Unconscious(160)


	//attempt to dismember bodyparts
	if(severity <= 2)
		var/max_limb_loss = round(4/severity) //so you don't lose four limbs at severity 3.
		for(var/obj/item/bodypart/BP as anything in bodyparts)
			if(prob(50/severity) && BP.body_zone != BODY_ZONE_CHEST)
				BP.brute_dam = BP.max_damage
				BP.dismember()
				max_limb_loss--
				if(!max_limb_loss)
					break
