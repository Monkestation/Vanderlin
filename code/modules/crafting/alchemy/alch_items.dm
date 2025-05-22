/obj/item/reagent_containers/glass/alchemical
	name = "alchemical vial"
	desc = "A cute bottle, conviniently holding 3 swigs of a fluid."
	icon = 'icons/roguetown/items/glass_reagent_container.dmi'
	icon_state = "vial_bottle"
	amount_per_transfer_from_this = 9
	possible_transfer_amounts = list(9)
	volume = 27
	fill_icon_thresholds = list(0, 33, 66, 100)
	dropshrink = 0.8
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	obj_flags = CAN_BE_HIT
	spillable = FALSE
	var/closed = TRUE //Put a cork in it!
	reagent_flags = TRANSPARENT
	w_class = WEIGHT_CLASS_SMALL
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	experimental_onhip = TRUE
	sellprice = 1


/*
	The next two functions are copies from ..(), but edited to give the max per transfer.
	so if your child has a per-transfer of 100, its putting all 100 in that thing. Be careful...
*/
/obj/item/reagent_containers/glass/alchemical/attack(mob/M, mob/user, obj/target)
	if(istype(M))
		if(user.used_intent.type == INTENT_GENERIC)
			return ..()
		else
			if(!spillable)
				return
			if(!reagents || !reagents.total_volume)
				to_chat(user, "<span class='warning'>[src] is empty!</span>")
				return
			if(user.used_intent.type == INTENT_SPLASH)
				var/R
				M.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [M]!</span>", \
								"<span class='danger'>[user] splashes the contents of [src] onto you!</span>")
				if(reagents)
					for(var/datum/reagent/A in reagents.reagent_list)
						R += "[A] ([num2text(A.volume)]),"

				if(isturf(target) && reagents.reagent_list.len && thrownby)
					log_combat(thrownby, target, "splashed (thrown) [english_list(reagents.reagent_list)]")
					message_admins("[ADMIN_LOOKUPFLW(thrownby)] splashed (thrown) [english_list(reagents.reagent_list)] on [target] at [ADMIN_VERBOSEJMP(target)].")
				reagents.reaction(M, TOUCH)
				log_combat(user, M, "splashed", R)
				reagents.clear_reagents()
				return
			else if(user.used_intent.type == INTENT_POUR)
				if(!canconsume(M, user))
					return
				if(M != user)
					M.visible_message("<span class='danger'>[user] attempts to feed [M] something.</span>", \
								"<span class='danger'>[user] attempts to feed you something.</span>")
					if(!do_after(user, 3 SECONDS, M))
						return
					if(!reagents || !reagents.total_volume)
						return // The drink might be empty after the delay, such as by spam-feeding
					M.visible_message("<span class='danger'>[user] feeds [M] something.</span>", \
								"<span class='danger'>[user] feeds you something.</span>")
					log_combat(user, M, "fed", reagents.log_list())
				else
					to_chat(user, "<span class='notice'>I swallow a gulp of [src].</span>")
				addtimer(CALLBACK(reagents, TYPE_PROC_REF(/datum/reagents, trans_to), M, amount_per_transfer_from_this, TRUE, TRUE, FALSE, user, FALSE, INGEST), 5)
				playsound(M.loc,pick(drinksounds), 100, TRUE)
				return

/obj/item/reagent_containers/glass/alchemical/attack_obj(obj/target, mob/living/user)
	if(user.used_intent.type == INTENT_GENERIC)
		return ..()
	if(!spillable)
		return
	if(target.is_refillable() && (user.used_intent.type == INTENT_POUR)) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'>[src] is empty!</span>")
			return
		if(target.reagents.holder_full())
			to_chat(user, "<span class='warning'>[target] is full.</span>")
			return
		user.visible_message("<span class='notice'>[user] pours [src] into [target].</span>", \
						"<span class='notice'>I pour [src] into [target].</span>")
		if(user.m_intent != MOVE_INTENT_SNEAK)
			if(poursounds)
				playsound(user.loc,pick(poursounds), 100, TRUE)
		for(var/i in 1 to 10)
			if(do_after(user, 8 DECISECONDS, target))
				if(!reagents.total_volume)
					break
				if(target.reagents.holder_full())
					break
				if(!reagents.trans_to(target, amount_per_transfer_from_this, transfered_by = user))
					reagents.reaction(target, TOUCH, amount_per_transfer_from_this)
			else
				break
		return
	if(target.is_drainable() && (user.used_intent.type == /datum/intent/fill)) //A dispenser. Transfer FROM it TO us.
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='warning'>[target] is empty!</span>")
			return
		if(reagents.holder_full())
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return
		if(user.m_intent != MOVE_INTENT_SNEAK)
			if(fillsounds)
				playsound(user.loc,pick(fillsounds), 100, TRUE)
		user.visible_message("<span class='notice'>[user] fills [src] with [target].</span>", \
							"<span class='notice'>I fill [src] with [target].</span>")
		for(var/i in 1 to 10)
			if(do_after(user, 8 DECISECONDS, target))
				if(reagents.holder_full())
					break
				if(!target.reagents.total_volume)
					break
				target.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user)
			else
				break
		return
	if(reagents.total_volume && user.used_intent.type == INTENT_SPLASH)
		user.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [target]!</span>", \
							"<span class='notice'>I splash the contents of [src] onto [target].</span>")
		reagents.reaction(target, TOUCH)
		reagents.clear_reagents()
		return

/*
	This ends the copy-edited code.
*/
/obj/item/reagent_containers/glass/alchemical/attackby(obj/item/I, mob/user, params)
	if(reagents.total_volume)
		return
	if(closed)
		return
	else
		return ..()

/obj/item/reagent_containers/glass/alchemical/update_icon(dont_fill=FALSE)
	if(!fill_icon_thresholds || dont_fill)
		return

	cut_overlays()
	underlays.Cut()

	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon)

		var/percent = round((reagents.total_volume / volume) * 100)
		for(var/i in 1 to fill_icon_thresholds.len)
			var/threshold = fill_icon_thresholds[i]
			var/threshold_end = (i == fill_icon_thresholds.len)? INFINITY : fill_icon_thresholds[i+1]
			if(threshold <= percent && percent < threshold_end)
				filling.icon_state = "vial_fluid_[fill_icon_thresholds[i]]"
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		underlays += filling

	if(closed)
		add_overlay("vial_cork")
/obj/item/reagent_containers/glass/alchemical/rmb_self(mob/user)
	. = ..()
	closed = !closed
	user.changeNext_move(CLICK_CD_RAPID)
	if(closed)
		reagent_flags = TRANSPARENT
		reagents.flags = reagent_flags
		to_chat(user, span_notice("You carefully press the cork back into the mouth of [src]."))
		spillable = FALSE
		desc = initial(desc)
	else
		reagent_flags = OPENCONTAINER
		reagents.flags = reagent_flags
		to_chat(user, span_notice("You thumb off the cork from [src]."))
		playsound(user.loc,'sound/items/uncork.ogg', 100, TRUE)
		spillable = TRUE
		desc += "The cork appears to be off."
	update_icon()
