
/obj/item/clothing/gloves
	var/transfer_blood = 0


/obj/item/reagent_containers/glass/rag
	name = "damp rag"
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	item_flags = NOBLUDGEON
	reagent_flags = TRANSFERABLE
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list()
	volume = 5
	spillable = FALSE

/obj/item/reagent_containers/glass/rag/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is smothering [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return (OXYLOSS)

/obj/item/reagent_containers/glass/rag/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(iscarbon(interacting_with) && interacting_with.reagents && reagents.total_volume)
		var/mob/living/carbon/C = interacting_with
		var/reagentlist = pretty_string_from_reagent_list(reagents)
		var/log_object = "containing [reagentlist]"
		if(user.used_intent.type == INTENT_HARM && !C.is_mouth_covered())
			reagents.trans_to(C, reagents.total_volume, transfered_by = user, method = INGEST)
			C.visible_message("<span class='danger'>[user] has smothered \the [C] with \the [src]!</span>", "<span class='danger'>[user] has smothered you with \the [src]!</span>", "<span class='hear'>I hear some struggling and muffled cries of surprise.</span>")
			log_combat(user, C, "smothered", src, log_object)
		else
			reagents.reaction(C, TOUCH)
			reagents.clear_reagents()
			C.visible_message("<span class='notice'>[user] has touched \the [C] with \the [src].</span>")
			log_combat(user, C, "touched", src, log_object)
		return ITEM_INTERACT_SUCCESS

	else if(istype(interacting_with) && (src in user))
		user.visible_message("<span class='notice'>[user] starts to wipe down [interacting_with] with [src]!</span>", "<span class='notice'>I start to wipe down [interacting_with] with [src]...</span>")
		if(do_after(user, 3 SECONDS, interacting_with))
			user.visible_message("<span class='notice'>[user] finishes wiping off [interacting_with]!</span>", "<span class='notice'>I finish wiping off [interacting_with].</span>")
			SEND_SIGNAL(interacting_with, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_SCRUB)
		return ITEM_INTERACT_SUCCESS
