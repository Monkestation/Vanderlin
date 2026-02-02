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
	var/apply_type = INGEST
	var/apply_method = "swallow"
	var/rename_with_volume = FALSE
	var/self_delay = 0 //pills are instant, this is because patches inheret their aplication from pills
	var/dissolvable = TRUE

/obj/item/reagent_containers/pill/attack_self(mob/user)
	return

/obj/item/reagent_containers/pill/attack(mob/M, mob/user, def_zone)
	if(!canconsume(M, user))
		return FALSE

	if(M == user)
		M.visible_message("<span class='notice'>[user] attempts to [apply_method] [src].</span>")
		if(self_delay)
			if(!do_after(user, self_delay, M))
				return FALSE
		to_chat(M, "<span class='notice'>I [apply_method] [src].</span>")
		playsound(src, "sound/misc/pillpop.ogg", 100, TRUE)

	else
		M.visible_message("<span class='danger'>[user] attempts to force [M] to [apply_method] [src].</span>", \
							"<span class='danger'>[user] attempts to force you to [apply_method] [src].</span>")
		if(!do_after(user, 3 SECONDS, M))
			return FALSE
		M.visible_message("<span class='danger'>[user] forces [M] to [apply_method] [src].</span>", \
							"<span class='danger'>[user] forces you to [apply_method] [src].</span>")
		playsound(src, "sound/misc/pillpop.ogg", 100, TRUE)

	if(icon_state == "pill4" && prob(5)) //you take the red pill - you stay in Wonderland, and I show you how deep the rabbit hole goes
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), M, "<span class='notice'>[pick(strings(REDPILL_FILE, "redpill_questions"))]</span>"), 50)

	if(reagents.total_volume)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user, method = apply_type)
	qdel(src)
	return TRUE

/obj/item/reagent_containers/pill/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(!dissolvable || !target.is_refillable())
		return
	if(target.is_drainable() && !target.reagents.total_volume)
		to_chat(user, "<span class='warning'>[target] is empty! There's nothing to dissolve [src] in.</span>")
		return

	if(target.reagents.holder_full())
		to_chat(user, "<span class='warning'>[target] is full.</span>")
		return

	user.visible_message("<span class='warning'>[user] slips something into [target]!</span>", "<span class='notice'>I dissolve [src] in [target].</span>", null, 2)
	reagents.trans_to(target, reagents.total_volume, transfered_by = user)
	qdel(src)

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
