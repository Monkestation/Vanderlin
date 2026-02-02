/*	use_available_blood
	user: the mob (generally a cultist) trying to spend blood
	amount_needed: the amount of blood required
	previous_result: the result of the previous call of this proc if any, to prevent the same flavor text from displaying every single call of this proc in a row
	tribute: set to 1 when called by a contributor to Blood Communion

	returns: a /list with information on the success/failure of the proc, and in the former case, information the blood that was used (color, type, dna)
*/
/proc/use_available_blood(mob/user, amount_needed = 0, previous_result = "", tribute = 0, feedback = TRUE)
	//Blood Communion
	var/communion = 0
	var/communion_data = null
	var/total_accumulated = 0
	var/total_needed = amount_needed
	//Getting nearby blood sources
	var/list/data = get_available_blood(user, amount_needed-total_accumulated)

	var/datum/reagent/blood/blood

	//Flavour text and blood data transfer
	switch (data[BLOODCOST_RESULT])
		if (BLOODCOST_TRIBUTE)//if the drop of blood was paid for through blood communion, let's get the reference to the blood they used because we can
			blood = new()
			if (communion_data && communion_data[BLOODCOST_RESULT])
				switch(communion_data[BLOODCOST_RESULT])
					if (BLOODCOST_TARGET_SPLATTER)
						var/obj/effect/decal/cleanable/blood/B = communion_data[BLOODCOST_TARGET_SPLATTER]
						blood = new()
						blood.color = B.color
					if (BLOODCOST_TARGET_GRAB)
						var/mob/living/carbon/CA = communion_data[BLOODCOST_TARGET_GRAB]
						var/datum/blood_type/blood_type = CA.get_blood_type()
						blood.data = blood_type.get_blood_data(CA)

					if (BLOODCOST_TARGET_BLEEDER)
						var/mob/living/carbon/CA = communion_data[BLOODCOST_TARGET_BLEEDER]
						if (isliving(CA))
							var/datum/blood_type/blood_type = CA.get_blood_type()
							blood.data = blood_type.get_blood_data(CA)
					if (BLOODCOST_TARGET_HELD)
						var/obj/item/reagent_containers/G = communion_data[BLOODCOST_TARGET_HELD]
						blood = locate() in G.reagents.reagent_list
					if (BLOODCOST_TARGET_CONTAINER)
						var/obj/item/reagent_containers/G = communion_data[BLOODCOST_TARGET_CONTAINER]
						blood = locate() in G.reagents.reagent_list
					if (BLOODCOST_TARGET_USER)
						var/mob/living/carbon/CA = communion_data[BLOODCOST_USER]
						if (iscarbon(CA))
							var/datum/blood_type/blood_type = CA.get_blood_type()
							blood.data =blood_type.get_blood_data(CA)
			if (feedback && !tribute && previous_result != BLOODCOST_TRIBUTE)
				user.visible_message(span_warning("Drips of blood seem to appear out of thin air around \the [user], and fall onto the floor!") ,
									span_rose("An ally has lent you a drip of their blood for your ritual.") ,
									span_warning("You hear a liquid flowing.") )
		if (BLOODCOST_TARGET_SPLATTER)
			var/obj/effect/decal/cleanable/blood/B = data[BLOODCOST_TARGET_SPLATTER]
			blood = new()
			blood.color = B.color
			if (feedback && !tribute && previous_result != BLOODCOST_TARGET_SPLATTER)
				user.visible_message(span_warning("The blood on the floor below \the [user] starts moving!") ,
									span_rose("You redirect the flow of blood inside the splatters on the floor toward the pool of your summoning.") ,
									span_warning("You hear a liquid flowing.") )
		if (BLOODCOST_TARGET_GRAB)
			var/mob/living/carbon/C = data[BLOODCOST_TARGET_GRAB]
			if (iscarbon(C))
				blood = new()
				var/datum/blood_type/blood_type = C.get_blood_type()
				blood.data =blood_type.get_blood_data(C)
				if (feedback && !tribute && previous_result != BLOODCOST_TARGET_GRAB)
					user.visible_message(span_warning("\The [user] stabs their nails inside \the [data[BLOODCOST_TARGET_GRAB]], drawing blood from them!") ,
										span_rose("You stab your nails inside \the [data[BLOODCOST_TARGET_GRAB]] to draw some blood from them.") ,
										span_warning("You hear a liquid flowing.") )

		if (BLOODCOST_TARGET_BLEEDER)
			var/mob/living/carbon/C = data[BLOODCOST_TARGET_BLEEDER]
			if (iscarbon(C))
				blood = new()
				var/datum/blood_type/blood_type = C.get_blood_type()
				blood.data =blood_type.get_blood_data(C)
				if (feedback && !tribute && previous_result != BLOODCOST_TARGET_BLEEDER)
					user.visible_message(span_warning("\The [user] dips their fingers inside \the [data[BLOODCOST_TARGET_BLEEDER]]'s wounds!") ,
										span_rose("You dip your fingers inside \the [data[BLOODCOST_TARGET_BLEEDER]]'s wounds to draw some blood from them.") ,
										span_warning("You hear a liquid flowing.") )
		if (BLOODCOST_TARGET_HELD)
			var/obj/item/reagent_containers/G = data[BLOODCOST_TARGET_HELD]
			blood = locate() in G.reagents.reagent_list
			if (!tribute && previous_result != BLOODCOST_TARGET_HELD)
				user.visible_message(span_warning("\The [user] tips \the [data[BLOODCOST_TARGET_HELD]], pouring blood!") ,
									span_rose("You tip \the [data[BLOODCOST_TARGET_HELD]] to pour the blood contained inside.") ,
									span_warning("You hear a liquid flowing.") )

		if (BLOODCOST_TARGET_CONTAINER)
			var/obj/item/reagent_containers/G = data[BLOODCOST_TARGET_CONTAINER]
			blood = locate() in G.reagents.reagent_list
			if (feedback && !tribute && previous_result != BLOODCOST_TARGET_CONTAINER)
				user.visible_message(span_warning("\The [user] dips their fingers inside \the [data[BLOODCOST_TARGET_CONTAINER]], covering them in blood!") ,
									span_rose("You dip your fingers inside \the [data[BLOODCOST_TARGET_CONTAINER]], covering them in blood.") ,
									span_warning("You hear a liquid flowing.") )
		if (BLOODCOST_TARGET_USER)
			blood = new()
			if (!tribute)
				if (data[BLOODCOST_HOLES_BLOODPACK])
					to_chat(user, span_warning("You must puncture \the [data[BLOODCOST_TARGET_BLOODPACK]] before you can squeeze blood from it!") )
				else if (data[BLOODCOST_LID_HELD])
					to_chat(user, span_warning("Remove \the [data[BLOODCOST_TARGET_HELD]]'s lid first!") )
				else if (data[BLOODCOST_LID_CONTAINER])
					to_chat(user, span_warning("Remove \the [data[BLOODCOST_TARGET_CONTAINER]]'s lid first!") )
			if (iscarbon(user))
				var/mob/living/carbon/C_user = user
				var/datum/blood_type/blood_type = C_user.get_blood_type()
				blood.data =blood_type.get_blood_data(C_user)

			if (feedback && !tribute && (previous_result != BLOODCOST_TARGET_USER))
				if (iscarbon(user))//if the user is holding a sharp weapon, they get a custom message
					var/obj/item/weapon/W = user.get_active_held_item()
					if (W && W.sharpness == IS_SHARP)
						to_chat(user, span_rose("You slice open your finger with \the [W] to let a bit of blood flow.") )
					else
						var/obj/item/weapon/W2 = user.get_inactive_held_item()
						if (W2 && W2.sharpness == IS_SHARP)
							to_chat(user, span_rose("You slice open your finger with \the [W] to let a bit of blood flow.") )
						else
							to_chat(user, span_rose("You bite your finger and let the blood pearl up.") )
		if (BLOODCOST_FAILURE)
			if (!tribute)
				if (data[BLOODCOST_HOLES_BLOODPACK])
					to_chat(user, span_danger("You must puncture \the [data[BLOODCOST_TARGET_BLOODPACK]] before you can squeeze blood from it!") )
				else if (data[BLOODCOST_LID_HELD])
					to_chat(user, span_danger("Remove \the [data[BLOODCOST_TARGET_HELD]]'s lid first!") )
				else if (data[BLOODCOST_LID_CONTAINER])
					to_chat(user, span_danger("Remove \the [data[BLOODCOST_TARGET_HELD]]'s lid first!") )
				else
					to_chat(user, span_danger("There is no blood available. Not even in your own body!") )

	//Blood is only consumed if there is enough of it
	if (!data[BLOODCOST_FAILURE])
		if (data[BLOODCOST_TARGET_HANDS])
			data[BLOODCOST_TOTAL] += data[BLOODCOST_AMOUNT_HANDS]
		if (data[BLOODCOST_TARGET_GRAB])
			data[BLOODCOST_TOTAL] += data[BLOODCOST_AMOUNT_GRAB]
			if (ishuman(data[BLOODCOST_TARGET_GRAB]))
				var/mob/living/carbon/human/H = data[BLOODCOST_TARGET_GRAB]
				H.blood_volume -= data[BLOODCOST_AMOUNT_GRAB]
				H.adjust_bloodpool(-data[BLOODCOST_AMOUNT_GRAB])
				H.take_overall_damage(data[BLOODCOST_AMOUNT_GRAB] ? 0.1 : 0)
		if (data[BLOODCOST_TARGET_BLEEDER])
			data[BLOODCOST_TOTAL] += data[BLOODCOST_AMOUNT_BLEEDER]
			var/mob/living/carbon/human/H = data[BLOODCOST_TARGET_BLEEDER]
			H.blood_volume -= data[BLOODCOST_AMOUNT_BLEEDER]
			H.adjust_bloodpool(-data[BLOODCOST_AMOUNT_BLEEDER])
			H.take_overall_damage(data[BLOODCOST_AMOUNT_BLEEDER] ? 0.1 : 0)
		if (data[BLOODCOST_TARGET_HELD])
			data[BLOODCOST_TOTAL] += data[BLOODCOST_AMOUNT_HELD]
			var/obj/item/reagent_containers/G = data[BLOODCOST_TARGET_HELD]
			G.reagents.remove_reagent(/datum/reagent/blood, data[BLOODCOST_AMOUNT_HELD])
		if (data[BLOODCOST_TARGET_BLOODPACK])
			data[BLOODCOST_TOTAL] += data[BLOODCOST_AMOUNT_BLOODPACK]
			var/obj/item/reagent_containers/G = data[BLOODCOST_TARGET_BLOODPACK]
			G.reagents.remove_reagent(/datum/reagent/blood, data[BLOODCOST_AMOUNT_BLOODPACK])
		if (data[BLOODCOST_TARGET_CONTAINER])
			data[BLOODCOST_TOTAL] += data[BLOODCOST_AMOUNT_CONTAINER]
			var/obj/item/reagent_containers/G = data[BLOODCOST_TARGET_CONTAINER]
			G.reagents.remove_reagent(/datum/reagent/blood, data[BLOODCOST_AMOUNT_CONTAINER])
		if (data[BLOODCOST_TARGET_USER])
			data[BLOODCOST_TOTAL] += data[BLOODCOST_AMOUNT_USER]
			if (ishuman(user))
				var/mob/living/carbon/human/H = user
				var/blood_before = H.blood_volume
				H.blood_volume -= data[BLOODCOST_AMOUNT_USER]
				H.adjust_bloodpool(-data[BLOODCOST_AMOUNT_USER])
				var/blood_after = H.blood_volume
				if (blood_before > BLOOD_VOLUME_SAFE && blood_after < BLOOD_VOLUME_SAFE)
					to_chat(user, span_cult("You start looking pale.") )
				else if (blood_before > BLOOD_VOLUME_OKAY && blood_after < BLOOD_VOLUME_OKAY)
					to_chat(user, span_cult("You are about to pass out from the lack of blood.") )
				else if (blood_before > BLOOD_VOLUME_BAD && blood_after < BLOOD_VOLUME_BAD)
					to_chat(user, span_cult("You have trouble focusing, things will go bad if you keep using your blood.") )
				else if (blood_before > BLOOD_VOLUME_SURVIVE && blood_after < BLOOD_VOLUME_SURVIVE)
					to_chat(user, span_cult("It will be all over soon.") )
				H.take_overall_damage(data[BLOODCOST_AMOUNT_USER] ? 0.1 : 0)
			else if (ismonkey(user))
				var/mob/living/carbon/C = user
				var/blood_before = C.health
				if (ismonkey(C))
					C.adjustOxyLoss(data[BLOODCOST_AMOUNT_USER])
				C.updatehealth()
				var/blood_after = C.health
				if (blood_before > (C.maxHealth*5/6) && blood_after < (C.maxHealth*5/6))
					to_chat(user, span_cult("You start looking pale.") )
				else if (blood_before > (C.maxHealth*4/6) && blood_after < (C.maxHealth*4/6))
					to_chat(user, span_cult("You feel weak from the lack of blood.") )
				else if (blood_before > (C.maxHealth*3/6) && blood_after < (C.maxHealth*3/6))
					to_chat(user, span_cult("You are about to pass out from the lack of blood.") )
				else if (blood_before > (C.maxHealth*2/6) && blood_after < (C.maxHealth*2/6))
					to_chat(user, span_cult("You have trouble focusing, things will go bad if you keep using your blood.") )
				else if (blood_before > (C.maxHealth*1/6) && blood_after < (C.maxHealth*1/6))
					to_chat(user, span_cult("It will be all over soon.") )


	if (communion && data[BLOODCOST_TOTAL] + total_accumulated >= amount_needed)
		data[BLOODCOST_TOTAL] = max(data[BLOODCOST_TOTAL], total_needed)
	data["blood"] = blood
	return data

//When cultists need to pay in blood to use their spells, they have a few options at their disposal:
// * If their hands are bloody, they can use the few units of blood on them.
// * If there is a blood splatter on the ground that still has a certain amount of fresh blood in it, they can use that?
// * If they are grabbing another person, they can stab their nails in their vessels to draw some blood from them
// * If they are standing above a bleeding person, they can dip their fingers into their wounds.
// * If they are holding a container that has blood in it (such as a beaker or a blood pack), they can pour/squeeze blood from them
// * If they are standing above a container that has blood in it, they can dip their fingers into them
// * Finally if there are no alternative blood sources, you can always use your own blood.

/*	get_available_blood
	user: the mob (generally a cultist) trying to spend blood
	amount_needed: the amount of blood required

	returns: a /list with information on nearby available blood. For use by use_available_blood().
*/
/proc/get_available_blood(mob/user, amount_needed = 0)
	var/data = list(
		BLOODCOST_TARGET_BLEEDER = null,
		BLOODCOST_AMOUNT_BLEEDER = 0,
		BLOODCOST_TARGET_GRAB = null,
		BLOODCOST_AMOUNT_GRAB = 0,
		BLOODCOST_TARGET_HANDS = null,
		BLOODCOST_AMOUNT_HANDS = 0,
		BLOODCOST_TARGET_HELD = null,
		BLOODCOST_AMOUNT_HELD = 0,
		BLOODCOST_LID_HELD = 0,
		BLOODCOST_TARGET_SPLATTER = null,
		BLOODCOST_AMOUNT_SPLATTER = 0,
		BLOODCOST_TARGET_BLOODPACK = null,
		BLOODCOST_AMOUNT_BLOODPACK = 0,
		BLOODCOST_HOLES_BLOODPACK = 0,
		BLOODCOST_TARGET_CONTAINER = null,
		BLOODCOST_AMOUNT_CONTAINER = 0,
		BLOODCOST_LID_CONTAINER = 0,
		BLOODCOST_TARGET_USER = null,
		BLOODCOST_AMOUNT_USER = 0,
		BLOODCOST_RESULT = "",
		BLOODCOST_TOTAL = 0,
		BLOODCOST_USER = null,
		)
	var/turf/T = get_turf(user)
	var/amount_gathered = 0

	data[BLOODCOST_RESULT] = user

	if (amount_needed == 0)//the cost was probably 1u, and already paid for by blood communion from another cultist
		data[BLOODCOST_RESULT] = BLOODCOST_TRIBUTE
		return data

	if (user.pulling)
		if(ishuman(user.pulling))
			var/mob/living/carbon/human/H = user.pulling
			if(!(NOBLOOD in H.dna.species.species_traits))
				var/blood_volume = H.blood_volume
				var/blood_gathered = min(amount_needed-amount_gathered, blood_volume)
				data[BLOODCOST_TARGET_GRAB] = H
				data[BLOODCOST_AMOUNT_GRAB] = blood_gathered
				amount_gathered += blood_gathered

	if (amount_gathered >= amount_needed)
		data[BLOODCOST_RESULT] = BLOODCOST_TARGET_GRAB
		return data

	//Is there a bleeding mob/corpse on the turf that still has blood in it?
	for (var/mob/living/carbon/human/H in T)
		if((NOBLOOD in H.dna.species.species_traits))
			continue
		if(user != H)
			if(H.get_bleed_rate() > 0)
				var/blood_volume = H.blood_volume
				var/blood_gathered = min(amount_needed-amount_gathered, blood_volume)
				data[BLOODCOST_TARGET_BLEEDER] = H
				data[BLOODCOST_AMOUNT_BLEEDER] = blood_gathered
				amount_gathered += blood_gathered
				break
		if (data[BLOODCOST_TARGET_BLEEDER])
			break

	if (amount_gathered >= amount_needed)
		data[BLOODCOST_RESULT] = BLOODCOST_TARGET_BLEEDER
		return data

	var/mob/living/carbon/human/H_user = user
	for(var/obj/item/reagent_containers/G_held in H_user.held_items) //Accounts for if the person has multiple grasping organs
		if (!istype(G_held) || !round(G_held.reagents.get_reagent_amount(/datum/reagent/blood)))
			continue
		else
			var/blood_volume = round(G_held.reagents.get_reagent_amount(/datum/reagent/blood))
			if (blood_volume)
				data[BLOODCOST_TARGET_HELD] = G_held
				if (G_held.is_open_container())
					var/blood_gathered = min(amount_needed-amount_gathered, blood_volume)
					data[BLOODCOST_AMOUNT_HELD] = blood_gathered
					amount_gathered += blood_gathered
				else
					data[BLOODCOST_LID_HELD] = 1

			if (amount_gathered >= amount_needed)
				data[BLOODCOST_RESULT] = BLOODCOST_TARGET_HELD
				return data


	//Is there a reagent container on the turf that has blood in it?
	for (var/obj/item/reagent_containers/G in T)
		var/blood_volume = round(G.reagents.get_reagent_amount(/datum/reagent/blood))
		if (blood_volume)
			data[BLOODCOST_TARGET_CONTAINER] = G
			if (G.is_open_container())
				var/blood_gathered = min(amount_needed-amount_gathered, blood_volume)
				data[BLOODCOST_AMOUNT_CONTAINER] = blood_gathered
				amount_gathered += blood_gathered
				break
			else
				data[BLOODCOST_LID_CONTAINER] = 1

	if (amount_gathered >= amount_needed)
		data[BLOODCOST_RESULT] = BLOODCOST_TARGET_CONTAINER
		return data

	//Does the user have blood? (the user can pay in blood without having to bleed first)
	if(istype(H_user))
		var/blood_volume = H_user.blood_volume
		var/blood_gathered = min(amount_needed-amount_gathered, blood_volume)
		data[BLOODCOST_TARGET_USER] = H_user
		data[BLOODCOST_AMOUNT_USER] = blood_gathered
		amount_gathered += blood_gathered


	if (amount_gathered >= amount_needed)
		data[BLOODCOST_RESULT] = BLOODCOST_TARGET_USER
		return data

	data[BLOODCOST_RESULT] = BLOODCOST_FAILURE
	return data
