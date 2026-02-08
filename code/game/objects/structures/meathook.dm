////// Roguetown version of the kitchen spike
/obj/structure/meathook
	name = "meathook"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "meathook"
	desc = "A hook used to secure livestock for butchering."
	density = TRUE
	anchored = TRUE
	max_integrity = 250
	buckle_lying = 0
	can_buckle = TRUE
	buckle_prevents_pull = TRUE

	var/draining_blood = FALSE

/obj/structure/meathook/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I
		if(!container.is_open_container())
			return
		container.forceMove(get_turf(src))
		to_chat(user, span_notice("You place [I] under [src]"))
		return TRUE
	. = ..()

/obj/structure/meathook/examine(mob/user)
	. = ..()
	if(has_buckled_mobs())
		var/mob/living/L = buckled_mobs[1]
		if(L.stat == DEAD)
			if(L.blood_drained >= 60)
				if(L.skinned)
					. += span_warning("[L] has been fully drained of blood and skinned. I can butcher it with a cleaver.")
				else
					. += span_warning("[L] has had its blood fully drained. I can skin it with a knife.")
			else
				if(draining_blood && L.blood_drained > 0)
					. += span_warning("[L] is having its blood drained. If I try to skin or butcher it now, I may lose some parts.")
				else
					. += span_warning("There is a corpse ready to be worked on. I might need a knife for this.")

/obj/structure/meathook/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/meathook/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(!isliving(user.pulling))
		return FALSE
	if(has_buckled_mobs())
		return FALSE

	var/mob/living/L = user.pulling
	L.visible_message(span_danger("[user] starts hanging [L] on [src]!"), span_danger("[user] starts hanging you on [src]]!"), span_hear("I hear the sound of clanging chains..."))
	if(!do_after(user, 12 SECONDS, src))
		return FALSE

	if(has_buckled_mobs())
		return FALSE
	if(L.buckled)
		return FALSE
	if(user.pulling != L)
		return FALSE

	playsound(src, 'sound/foley/butcher.ogg', 25, TRUE)
	L.visible_message(span_danger("[user] hangs [L] on [src]!"), span_danger("[user] hangs you on [src]]!"))
	L.forceMove(drop_location())
	L.emote("scream")
	L.add_splatter_floor()
	L.adjustBruteLoss(30)
	L.setDir(2)
	buckle_mob(L, force=1)
	var/matrix/m90 = matrix(L.transform)
	m90.Turn(90)
	m90.Translate(12,12)
	animate(L, transform = m90, time = 3)
	L.pixel_y = L.get_standard_pixel_x_offset()
	draining_blood = FALSE
	return TRUE

/obj/structure/meathook/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(buckled_mob)
		var/mob/living/M = buckled_mob
		if (M != user)
			M.visible_message(span_notice("[user] is trying to pull [M] free of [src]!"),\
				span_notice("[user] is trying to pull me off [src]! It hurts!"),\
				span_hear("I hear the sound of torn flesh and whimpering..."))
			if(!do_after(user, 12 SECONDS, src))
				if(M && M.buckled)
					M.visible_message(span_notice("[user] fails to free [M]!"),\
					span_notice("[user] fails to pull me off of [src]!"))
				return
		else
			M.visible_message(span_warning("[M] struggles to break free from [src]!"),\
				span_notice("I struggle to break free from [src], tearing my legs! (Stay still for two minutes.)"),\
				span_hear("I hear the sound of torn flesh and whimpering..."))
			M.adjustBruteLoss(30)
			if(!do_after(M, 30 SECONDS, src))
				if(M && M.buckled)
					to_chat(M, span_warning("I fail to free myself!"))
				return
			if(!M.buckled)
				return
		release_mob(M)

/obj/structure/meathook/process()
	if(!length(buckled_mobs) || !draining_blood)
		draining_blood = FALSE
		STOP_PROCESSING(SSmachines, src)
		return
	var/mob/living/L = buckled_mobs[1]
	if(L.blood_drained >= 60)
		L.blood_drained = 60
		draining_blood = FALSE
		STOP_PROCESSING(SSmachines, src)
		return
	L.blood_drained++

	var/obj/item/reagent_containers/container = locate(/obj/item/reagent_containers) in get_turf(src)
	playsound(src, 'sound/misc/bleed (3).ogg', 100, FALSE)
	if(container && container.is_open_container() && container.reagents.total_volume < container.reagents.maximum_volume)
		var/datum/blood_type/type = L.get_blood_type()
		container.reagents.add_reagent(initial(type.reagent_type), 5, data = type.get_blood_data(L))
	else
		var/obj/effect/decal/cleanable/blood/puddle/P = locate() in get_turf(src)
		if(P)
			P.blood_vol += 5
			P.update_appearance(UPDATE_ICON_STATE)
		else
			var/obj/effect/decal/cleanable/blood/drip/D = locate() in get_turf(src)
			if(D)
				D.blood_vol += 5
				D.drips++
				D.update_appearance(UPDATE_ICON_STATE)
			else
				new /obj/effect/decal/cleanable/blood/drip(get_turf(src))

/obj/structure/meathook/proc/release_mob(mob/living/M)
	var/matrix/m270 = matrix(M.transform)
	m270.Translate(-12,-12)
	m270.Turn(-90)
	animate(M, transform = m270, time = 3)
	M.pixel_y = M.get_standard_pixel_y_offset()
	M.adjustBruteLoss(30)
	src.visible_message(span_danger("[M] falls free of [src]!"))
	unbuckle_mob(M,force=1)
	M.emote("scream")
	M.AdjustParalyzed(20)
	draining_blood = FALSE

/obj/structure/meathook/Destroy()
	if(has_buckled_mobs())
		for(var/mob/living/L in buckled_mobs)
			release_mob(L)
	return ..()

/obj/structure/meathook/deconstruct()
	new /obj/item/grown/log/tree/small(loc, 1)
	new /obj/item/rope(loc, 1)
	qdel(src)

/obj/structure/meathook/proc/butchery(mob/living/user, mob/living/simple_animal/butchery_target)
	var/list/butcher = list()
	if(butchery_target.butcher_results)
		if(prob(50 + (user.get_skill_level(/datum/skill/labor/butchering, TRUE) * 25))) // need level 2 to get consistent result
			if(prob((user.get_skill_level(/datum/skill/labor/butchering, TRUE) * 25) - 50)) // level 3 to 6 get better result
				butcher = butchery_target.perfect_butcher_results
			else
				butcher = butchery_target.butcher_results
		else
			butcher = butchery_target.botched_butcher_results

	// Get happiness bonus for yield calculations
	var/happiness_bonus = butchery_target.get_happiness_yield_bonus(1)

	if(!draining_blood && butchery_target.blood_drained < 60)
		if(!(user.used_intent.type == /datum/intent/dagger/cut || user.used_intent.type == /datum/intent/sword/cut || user.used_intent.type == /datum/intent/axe/cut))
			return
		var/cut_time = 4 SECONDS - (0.5 SECONDS * user.get_skill_level(/datum/skill/labor/butchering, TRUE))
		to_chat(user, span_notice("I prepare to drain [butchery_target]'s blood by cutting the skin..."))
		if(do_after(user, cut_time, src, (IGNORE_HELD_ITEM)))
			butchery_target.blood_drained++
			draining_blood = TRUE
			START_PROCESSING(SSmachines, src)
		return

	if(!butchery_target.skinned && (user.used_intent.type == /datum/intent/dagger/cut || user.used_intent.type == /datum/intent/sword/cut || user.used_intent.type == /datum/intent/axe/cut))
		var/cut_time = 6 SECONDS - (0.5 SECONDS * user.get_skill_level(/datum/skill/labor/butchering, TRUE))
		to_chat(user, span_notice("I start to skin [butchery_target]."))
		if(do_after(user, cut_time, src, (IGNORE_HELD_ITEM)))
			var/first_fail = TRUE
			var/total_bonus_items = 0
			for(var/listed_item in butcher)
				if(ispath(listed_item, /obj/item/natural/hide) || ispath(listed_item, /obj/item/natural/fur))
					var/base_amount = butcher[listed_item]
					var/final_amount = base_amount

					// Apply skill-based bonuses
					if(prob(40 + (user.get_skill_level(/datum/skill/labor/butchering, TRUE) * 10) - (60 - butchery_target.blood_drained)))
						final_amount += round(base_amount * 0.5)
					if(prob(10 + (user.get_skill_level(/datum/skill/labor/butchering, TRUE) * 5)) - (60 - butchery_target.blood_drained))
						final_amount += round(base_amount * 0.5)
					if(prob((60 - butchery_target.blood_drained)))
						if(first_fail)
							to_chat(user, span_notice("The flowing blood got in the way and messed up some of the skin."))
							first_fail = FALSE
						final_amount -= round(base_amount * 0.5)

					// Apply happiness bonus (only if we have items to bonus)
					var/bonus_amount = 0
					if(final_amount > 0 && happiness_bonus > 0)
						var/total_bonus = final_amount * happiness_bonus
						bonus_amount = round(total_bonus)
						// Handle fractional bonuses with probability
						var/fractional_part = total_bonus - bonus_amount
						if(fractional_part > 0 && prob(fractional_part * 100))
							bonus_amount++
						total_bonus_items += bonus_amount

					final_amount += bonus_amount

					var/current_happiness = SEND_SIGNAL(butchery_target, COMSIG_HAPPINESS_RETURN_VALUE)
					var/recipe_quality = clamp(FLOOR(current_happiness / 30, 1) + 1, 1, 4)
					for(var/i in 1 to final_amount)
						var/obj/item/I = new listed_item(get_turf(user))
						I.add_mob_blood(butchery_target)
						if(istype(I, /obj/item/reagent_containers/food))
							var/obj/item/reagent_containers/food/F = I
							F.set_quality(recipe_quality)
					butcher -= listed_item

			// Show happiness message for skinning if we got bonus items
			if(total_bonus_items > 0)
				var/happiness_message = butchery_target.get_happiness_butcher_message(happiness_bonus)
				if(happiness_message)
					to_chat(user, span_notice("[happiness_message] (+[total_bonus_items] bonus hide/fur)"))

			var/boon = user.get_learning_boon(/datum/skill/labor/butchering)
			var/amt2raise = user.STAINT
			user.mind.add_sleep_experience(/datum/skill/labor/butchering, amt2raise * boon, FALSE)
			butchery_target.skinned = TRUE
		return

	if(!butchery_target.skinned)
		return

	if(user.used_intent.type == /datum/intent/dagger/chop/cleaver)
		var/cut_time = 6 SECONDS - (0.5 SECONDS * user.get_skill_level(/datum/skill/labor/butchering, TRUE))
		to_chat(user, span_notice("I start to butcher [butchery_target]."))
		if(do_after(user, cut_time, src, (IGNORE_HELD_ITEM)))
			var/first_fail = TRUE
			var/total_bonus_items = 0

			// Handle meat and fat with skill bonuses and happiness
			for(var/listed_item in butcher)
				if(ispath(listed_item, /obj/item/reagent_containers/food/snacks/meat) || ispath(listed_item, /obj/item/reagent_containers/food/snacks/fat))
					var/base_amount = butcher[listed_item]
					var/final_amount = base_amount

					// Apply skill-based bonuses
					if(prob(40 + (user.get_skill_level(/datum/skill/labor/butchering, TRUE) * 10) - (60 - butchery_target.blood_drained)))
						final_amount += round(base_amount * 0.5)
					if(prob(10 + (user.get_skill_level(/datum/skill/labor/butchering, TRUE) * 5)) - (60 - butchery_target.blood_drained))
						final_amount += round(base_amount * 0.5)
					if(prob((60 - butchery_target.blood_drained)))
						if(first_fail)
							to_chat(user, span_notice("The flowing blood got in the way and messed up some of the meat."))
							first_fail = FALSE
						final_amount -= round(base_amount * 0.5)

					// Apply happiness bonus (only if we have items to bonus)
					var/bonus_amount = 0
					if(final_amount > 0 && happiness_bonus > 0)
						var/total_bonus = final_amount * happiness_bonus
						bonus_amount = round(total_bonus)
						// Handle fractional bonuses with probability
						var/fractional_part = total_bonus - bonus_amount
						if(fractional_part > 0 && prob(fractional_part * 100))
							bonus_amount++
						total_bonus_items += bonus_amount

					final_amount += bonus_amount

					var/current_happiness = SEND_SIGNAL(butchery_target, COMSIG_HAPPINESS_RETURN_VALUE)
					var/recipe_quality = clamp(FLOOR(current_happiness / 30, 1) + 1, 1, 4)
					for(var/i in 1 to final_amount)
						var/obj/item/I = new listed_item(get_turf(user))
						I.add_mob_blood(butchery_target)
						var/rotstuff = FALSE
						var/datum/component/rot/simple/CR = butchery_target.GetComponent(/datum/component/rot/simple)
						if(CR)
							if(CR.amount >= 10 MINUTES)
								rotstuff = TRUE
						if(istype(I, /obj/item/reagent_containers/food/snacks))
							var/obj/item/reagent_containers/food/snacks/F = I
							F.set_quality(recipe_quality)
							if(rotstuff)
								F.become_rotten()
						else if(rotstuff && istype(I,/obj/item/reagent_containers/food/snacks))
							var/obj/item/reagent_containers/food/snacks/F = I
							F.become_rotten()
					butcher -= listed_item

			// Handle remaining items (bones, organs, etc.) with happiness bonus
			for(var/listed_item in butcher)
				var/base_amount = butcher[listed_item]
				var/bonus_amount = 0

				// Apply happiness bonus to remaining items too
				if(base_amount > 0 && happiness_bonus > 0)
					var/total_bonus = base_amount * happiness_bonus
					bonus_amount = round(total_bonus)
					// Handle fractional bonuses with probability
					var/fractional_part = total_bonus - bonus_amount
					if(fractional_part > 0 && prob(fractional_part * 100))
						bonus_amount++
					total_bonus_items += bonus_amount

				var/final_amount = base_amount + bonus_amount

				var/current_happiness = SEND_SIGNAL(butchery_target, COMSIG_HAPPINESS_RETURN_VALUE)
				var/recipe_quality = clamp(FLOOR(current_happiness / 30, 1) + 1, 1, 4)
				for(var/i in 1 to final_amount)
					var/obj/item/I = new listed_item(get_turf(user))
					I.add_mob_blood(butchery_target)
					if(istype(I, /obj/item/reagent_containers/food))
						var/obj/item/reagent_containers/food/F = I
						F.set_quality(recipe_quality)

			// Show happiness message for butchering if we got bonus items
			if(total_bonus_items > 0)
				var/happiness_message = butchery_target.get_happiness_butcher_message(happiness_bonus)
				if(happiness_message)
					to_chat(user, span_notice("[happiness_message] (+[total_bonus_items] bonus items)"))

			butchery_target.gib()
			var/boon = user.get_learning_boon(/datum/skill/labor/butchering)
			var/amt2raise = user.STAINT
			user.mind.add_sleep_experience(/datum/skill/labor/butchering, amt2raise * boon, FALSE)
