
/datum/action/cooldown/spell/undirected/psydonrespite
	name = "RESPITE"
	spell_type = SPELL_PSYDONIC_MIRACLE
	spell_flags = SPELL_PSYDON
	spell_cost = 10
	charge_time = 1
	sound = null
	invocation = ". . ."
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	cooldown_time  = 60 SECONDS

/datum/action/cooldown/spell/undirected/psydonrespite/cast(mob/living/user) // It's a very tame self-heal. Nothing too special.
	. = ..()
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	var/brute = H.getBruteLoss()
	var/burn = H.getFireLoss()
	var/conditional_buff = FALSE
	var/zcross_trigger = FALSE
	var/sit_bonus1 = 0
	var/sit_bonus2 = 0
	var/psicross_bonus = 0

	for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
		if(istype(current_item, /obj/item/clothing/neck/psycross))
			switch(current_item.type) // Worn Psicross Piety bonus. For fun.
				if(/obj/item/clothing/neck/psycross)
					psicross_bonus = -5
				if(/obj/item/clothing/neck/psycross/silver)
					psicross_bonus = -7
				if(/obj/item/clothing/neck/psycross/g) // PURITY AFLOAT.
					psicross_bonus = -7
	if(brute > 100)
		sit_bonus1 = -2
	if(brute > 150)
		sit_bonus1 = -4
	if(brute > 200)
		sit_bonus1 = -6
	if(brute > 300)
		sit_bonus1 = -8
	if(brute > 350)
		sit_bonus1 = -10
	if(brute > 400)
		sit_bonus1 = -14

	if(burn > 100)
		sit_bonus2 = -2
	if(burn > 150)
		sit_bonus2 = -4
	if(burn > 200)
		sit_bonus2 = -6
	if(burn > 300)
		sit_bonus2 = -8
	if(burn > 350)
		sit_bonus2 = -10
	if(burn > 400)
		sit_bonus2 = -14

	if(sit_bonus1 || sit_bonus2)
		conditional_buff = TRUE

	var/bruthealval = -7 + psicross_bonus + sit_bonus1
	var/burnhealval = -7 + psicross_bonus + sit_bonus2

	to_chat(H, span_info("I take a moment to collect myself..."))
	if(zcross_trigger)
		user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		to_chat(H, span_info("In a moment of quiet contemplation, I feel bolstered by my faith."))
		if (conditional_buff)
			to_chat(user, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))
		return TRUE
	else
		to_chat(H, span_warning("My thoughts and sense of quiet escape me."))

	return FALSE
