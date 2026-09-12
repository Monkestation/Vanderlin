/obj/item/reagent_containers/pill
	name = "pill"
	desc = ""
	icon = 'icons/obj/medical.dmi'
	icon_state = "pillb"
	item_state = "pillb"
	grid_height = 32
	grid_width = 32
	possible_transfer_amounts = list()
	volume = 50
	grind_results = list()
	item_weight = 5 GRAMS
	var/apply_type = INGEST
	var/apply_method = "swallow"
	var/rename_with_volume = FALSE
	var/self_delay = 0 //pills are instant, this is because patches inheret their aplication from pills
	var/dissolvable = TRUE

/obj/item/reagent_containers/pill/attack_self(mob/user)
	return

/obj/item/reagent_containers/pill/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		if(!dissolvable || !interacting_with.is_refillable())
			return NONE

		if(interacting_with.is_drainable() && !interacting_with.reagents.total_volume)
			to_chat(user, "<span class='warning'>[interacting_with] is empty! There's nothing to dissolve [src] in.</span>")
			return ITEM_INTERACT_BLOCKING

		if(interacting_with.reagents.holder_full())
			to_chat(user, "<span class='warning'>[interacting_with] is full.</span>")
			return ITEM_INTERACT_BLOCKING

		user.visible_message("<span class='warning'>[user] slips something into [interacting_with]!</span>", "<span class='notice'>I dissolve [src] in [interacting_with].</span>", null, 2)

		reagents.trans_to(interacting_with, reagents.total_volume, transfered_by = user)
		qdel(src)

		return ITEM_INTERACT_SUCCESS

	var/mob/living/M = interacting_with

	if(!canconsume(M, user))
		return ITEM_INTERACT_BLOCKING

	if(M == user)
		M.visible_message("<span class='notice'>[user] attempts to [apply_method] [src].</span>")
		if(self_delay)
			if(!do_after(user, self_delay, M))
				return ITEM_INTERACT_BLOCKING
		to_chat(M, "<span class='notice'>I [apply_method] [src].</span>")
		playsound(src, "sound/misc/pillpop.ogg", 100, TRUE)

	else
		M.visible_message("<span class='danger'>[user] attempts to force [M] to [apply_method] [src].</span>", \
							"<span class='danger'>[user] attempts to force you to [apply_method] [src].</span>")
		if(!do_after(user, 3 SECONDS, M))
			return ITEM_INTERACT_BLOCKING
		M.visible_message("<span class='danger'>[user] forces [M] to [apply_method] [src].</span>", \
							"<span class='danger'>[user] forces you to [apply_method] [src].</span>")
		playsound(src, "sound/misc/pillpop.ogg", 100, TRUE)

	if(icon_state == "pill4" && prob(5)) //you take the red pill - you stay in Wonderland, and I show you how deep the rabbit hole goes
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), M, "<span class='notice'>[pick(strings(REDPILL_FILE, "redpill_questions"))]</span>"), 50)

	if(reagents.total_volume)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user, method = apply_type)

	qdel(src)
	user.changeNext_move(CLICK_CD_MELEE)

	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/pill/sate
	name = "SATE pill"
	desc = "Prevents the loss of thaumiel blood."
	icon_state = "pinkb"

	list_reagents = list(/datum/reagent/sate = 50)

/obj/item/reagent_containers/pill/devour
	name = "DEVOUR pill"
	desc = "Devours thaumiel blood to forcibly induce the triggering of chimeric organs."

	icon_state = "pillg"
	list_reagents = list(/datum/reagent/devour = 10)
