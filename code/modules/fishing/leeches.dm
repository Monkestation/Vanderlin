#define MAX_LEECH_EVILNESS 10

/obj/item/natural/worms/leech
	name = "leech"
	desc = "A disgusting, blood-sucking parasite."
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "leech"
	baitpenalty = 0
	isbait = TRUE
	fishloot = list(/obj/item/reagent_containers/food/snacks/fish/carp = 5,
					/obj/item/reagent_containers/food/snacks/fish/eel = 5,
					/obj/item/reagent_containers/food/snacks/fish/angler = 1)
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
		"embedded_ignore_throwspeed_threshold" = TRUE,
	)
	bundletype = null
	/// Consistent AKA no lore
	var/consistent = FALSE
	/// Are we giving or receiving blood?
	var/giving = FALSE
	/// How much blood we waste away on process()
	var/drainage = 1
	/// How much blood we suck on on_embed_life()
	var/blood_sucking = 2
	/// How much toxin damage we heal on on_embed_life()
	var/toxin_healing = 1.5
	/// Amount of blood we have stored
	var/blood_storage = 0
	/// Maximum amount of blood we can store
	var/blood_maximum = BLOOD_VOLUME_SURVIVE
	// Completely silent, no do_after and no visible_message
	var/completely_silent = FALSE


/obj/item/natural/worms/leech/Initialize()
	. = ..()
	//leech lore
	leech_lore()
	if(drainage)
		START_PROCESSING(SSobj, src)

/obj/item/natural/worms/leech/process()
	if(!drainage)
		return PROCESS_KILL
	blood_storage = max(blood_storage - drainage, 0)

/obj/item/natural/worms/leech/examine(mob/user)
	. = ..()
	switch(blood_storage/blood_maximum)
		if(0.8 to INFINITY)
			. += "<span class='bloody'><B>[p_theyre(TRUE)] fat and engorged with blood.</B></span>"
		if(0.5 to 0.8)
			. += "<span class='bloody'>[p_theyre(TRUE)] well-fed.</span>"
		if(0.1 to 0.5)
			. += "<span class='warning'>[p_they(TRUE)] want[p_s()] a meal.</span>"
		if(-INFINITY to 0.1)
			. += "<span class='dead'>[p_theyre(TRUE)] starved.</span>"
	if(!giving)
		. += "<span class='warning'>[p_theyre(TRUE)] [pick("slurping", "sucking", "inhaling")].</span>"
	else
		. += "<span class='notice'>[p_theyre(TRUE)] [pick("vomiting", "gorfing", "exhaling")].</span>"
	if(drainage)
		START_PROCESSING(SSobj, src)

/obj/item/natural/worms/leech/attack(mob/living/M, mob/user, list/modifiers)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			return
		if(!get_location_accessible(H, check_zone(user.zone_selected)))
			to_chat(user, "<span class='warning'>Something in the way.</span>") //ooooooooooooooo
			return
		var/used_time
		if(completely_silent)
			used_time = 0
		else
			used_time = (7 SECONDS - (H.get_skill_level(/datum/skill/misc/medicine, TRUE) * 1 SECONDS))/2
		if(!do_after(user, used_time, H))
			return
		if(!H)
			return
		user.dropItemToGround(src)
		src.forceMove(H)
		affecting.add_embedded_object(src, silent = TRUE, crit_message = FALSE)
		if(completely_silent)
			return
		if(M == user)
			user.visible_message("<span class='notice'>[user] places [src] on [user.p_their()] [affecting].</span>", "<span class='notice'>I place a leech on my [affecting].</span>")
		else
			user.visible_message("<span class='notice'>[user] places [src] on [M]'s [affecting].</span>", "<span class='notice'>I place a leech on [M]'s [affecting].</span>")
		return
	return ..()

/obj/item/natural/worms/leech/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	if(!user)
		return
	if(giving)
		var/blood_given = min(BLOOD_VOLUME_MAXIMUM - user.blood_volume, blood_storage, blood_sucking)
		user.blood_volume += blood_given
		blood_storage = max(blood_storage - blood_given, 0)
		if((blood_storage <= 0) || (user.blood_volume >= BLOOD_VOLUME_MAXIMUM))
			if(bodypart)
				bodypart.remove_embedded_object(src)
			else
				user.simple_remove_embedded_object(src)
			return TRUE
	else
		var/modifier = bodypart.has_wound(/datum/wound/slash/incision) ? 1.5 : 1
		user.adjustToxLoss(-1 * toxin_healing * modifier)
		var/blood_extracted = min(blood_maximum - blood_storage, user.blood_volume, blood_sucking) * modifier
		if(HAS_TRAIT(user, TRAIT_LEECHIMMUNE))
			blood_extracted *= 0.05 // 95% drain reduction
		user.blood_volume = max(user.blood_volume - blood_extracted, 0)
		blood_storage += blood_extracted
		if((blood_storage >= blood_maximum) || (user.blood_volume <= 0))
			if(bodypart)
				bodypart.remove_embedded_object(src)
			else
				user.simple_remove_embedded_object(src)
			return TRUE
	return FALSE

/// LEECH LORE... Collect em all!
/obj/item/natural/worms/leech/proc/leech_lore()
	if(consistent)
		return FALSE
	var/static/list/all_colors = list(
		"#8471a7" = 8,
		"#94ad6a" = 4,
		"#af995e" = 2,
		"#83a7b3" = 2,
		"#b88383" = 1,
		"#bc69b1" = 1,
	)
	var/static/list/all_adjectives = list(
		"blood-sucking" = 20,
		"disgusting" = 10,
		"vile" = 8,
		"repugnant" = 4,
		"revolting" = 4,
		"grotesque" = 4,
		"hideous" = 4,
		"stupid" = 2,
		"dumb" = 2,
		"demonic" = 1,
		"graggoid" = 1,
		"zizoid" = 1,
	)
	var/static/list/all_descs = list(
		"What a disgusting creature." = 10,
		"Fucking gross." = 5,
		"Slippery..." = 3,
		"So yummy and full of blood." = 3,
		"I love this leech!" = 2,
		"It is so beautiful." = 2,
		"I wish I was a leech." = 1,
	)
	var/list/possible_adjectives = all_adjectives.Copy()
	var/list/possible_descs = all_descs.Copy()
	var/list/adjectives = list()
	var/list/descs = list()
	var/evilness_rating = rand(0, MAX_LEECH_EVILNESS)
	switch(evilness_rating)
		if(MAX_LEECH_EVILNESS to INFINITY) //maximized evilness holy shit
			color = "#dc4b4b"
			adjectives += pick("evil", "malevolent", "misanthropic")
			descs += "<span class='danger'>This one is bursting with hatred!</span>"
		if(5) //this leech is painfully average, it gets no adjectives
			if(prob(3))
				adjectives += pick("average", "ordinary", "boring")
				descs += "This one is extremely boring to look at."
		if(-INFINITY to 1) //this leech is pretty terrible at being a leech
			adjectives += pick("pitiful", "pathetic", "depressing")
			descs += "<span class='dead'>This one yearns for nothing but death.</span>"
		else
			var/adjective_amount = 1
			if(prob(5))
				adjective_amount = 3
			else if(prob(30))
				adjective_amount = 2
			for(var/i in 1 to adjective_amount)
				var/picked_adjective = pickweight(possible_adjectives)
				possible_adjectives -= picked_adjective
				adjectives += pickweight(possible_adjectives)
				var/picked_desc = pickweight(possible_descs)
				possible_descs -= picked_desc
				descs += pickweight(possible_descs)
	toxin_healing = min(round((MAX_LEECH_EVILNESS - evilness_rating)/MAX_LEECH_EVILNESS * 2 * initial(toxin_healing), 0.1), 1)
	blood_sucking = max(round(evilness_rating/MAX_LEECH_EVILNESS * 2 * initial(blood_sucking), 0.1), 1)
	if(evilness_rating < 10)
		color = pickweight(all_colors)
	if(length(adjectives))
		name = "[english_list(adjectives)] [name]"
	if(length(descs))
		desc = "[desc] [jointext(descs, " ")]"
	return TRUE

/obj/item/natural/worms/leech/parasite
	name = "the parasite"
	desc = "A foul, wriggling creecher. Known to suck whole villages of their blood, these rare freeks have been domesticated for medical purposes."
	icon_state = "parasite"
	dropshrink = 0.9
	baitpenalty = 0
	isbait = TRUE
	color = null
	consistent = TRUE
	drainage = 0
	blood_sucking = 5
	toxin_healing = 3
	blood_storage = BLOOD_VOLUME_SURVIVE
	blood_maximum = BLOOD_VOLUME_BAD

/obj/item/natural/worms/leech/parasite/attack_self(mob/user, list/modifiers)
	. = ..()
	giving = !giving
	if(giving)
		user.visible_message("<span class='notice'>[user] squeezes [src].</span>",\
							"<span class='notice'>I squeeze [src]. It will now infuse blood.</span>")
	else
		user.visible_message("<span class='notice'>[user] squeezes [src].</span>",\
							"<span class='notice'>I squeeze [src]. It will now extract blood.</span>")

/obj/item/natural/worms/leech/propaganda
	name = "accursed leech"
	desc = "A leech like none other."
	icon_state = "leech"
	drainage = 0
	blood_sucking = 0
	completely_silent = TRUE
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
	)

/obj/item/natural/worms/leech/propaganda/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	. = ..()
	if(!user)
		return
	if(iscarbon(user))
		var/mob/living/carbon/V = user
		if(prob(5))
			record_round_statistic(STATS_ZIZO_PRAISED)
			V.say(pick( \
				"PRAISE ZIZO!", \
				"DEATH TO THE TEN...", \
				"Astrata will fail!", \
				"The Ten cannot stop me!", \
				"Zizo shows the way!", \
				"The Dark Lady has shown me the truth!", \
				"My life for Zizo...", \
				"Curse your Beast God!", \
				"Noc's magick is nothing to Zizo!", \
				"Abyssor is but a grain of salt!", \
				"Pestra is the most foul of goddesses!", \
				"Ravox's justice is flawed and dull!", \
				"Rip the Sun Tyrant from the sky!", \
				"Xylix is the tongue that must be severed off!", \
				"Cast Malum into the fires of hell!", \
				"The only truth there is lies with the Dark Elves!", \
				"I will defile Necra's dead, a thousand times!", \
				"I will butcher the Ten like Necra butchered Psydon!", \
				"Snuff out the beating hearts of Eora!"))
		V.add_stress(/datum/stress_event/leechcult)

/obj/item/natural/worms/leech/abyssoid
	name = "abyssoid leech"
	desc = "A holy leech sent by Abyssor himself."
	icon_state = "leech"
	drainage = 0
	blood_sucking = 0
	completely_silent = TRUE
	embedding = list(
		"embed_chance" = 100,
		"embedded_unsafe_removal_time" = 0,
		"embedded_pain_chance" = 0,
		"embedded_fall_chance" = 0,
		"embedded_bloodloss"= 0,
	)

/obj/item/natural/worms/leech/abyssoid/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	. = ..()
	if(!user)
		return
	if(iscarbon(user))
		var/mob/living/carbon/V = user
		if(prob(3))
			V.say(pick("PRAISE ABYSSOR!", "REMEMBER ABYSSOR!", "ABYSSOR LIVES!", "GLORY TO ABYSSOR!", "ABYSSOR IS COMING!"))

#undef MAX_LEECH_EVILNESS
