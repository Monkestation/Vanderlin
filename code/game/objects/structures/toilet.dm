/obj/structure/toilet
	name = "toilet"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "toilet"
	density = FALSE
	anchored = TRUE
	var/open = FALSE			//if the lid is up
	var/cistern = 1			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie
	var/buildstacktype
	var/buildstackamount = 1

/obj/structure/toilet/Initialize()
	. = ..()

/obj/structure/toilet/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return

	if(cistern && user.CanReach(src))
		if(!contents.len)
			to_chat(user, "<span class='notice'>The toilet is empty.</span>")
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.forceMove(drop_location())
			to_chat(user, "<span class='notice'>I find [I] in the toilet.</span>")
			w_items -= I.w_class

/obj/structure/toilet/deconstruct()
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/toilet/attackby(obj/item/I, mob/living/user, list/modifiers)
	add_fingerprint(user)
	if(I.tool_behaviour == TOOL_CROWBAR)
		to_chat(user, "<span class='notice'>I start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]...</span>")
		playsound(src, 'sound/blank.ogg', 50, TRUE)
		if(I.use_tool(src, user, 30))
			user.visible_message("<span class='notice'>[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!</span>", "<span class='notice'>I [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!</span>", "<span class='hear'>I hear grinding porcelain.</span>")
			cistern = !cistern
	else if(I.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		I.play_tool_sound(src)
		deconstruct()
	else if(cistern)
		if(user.used_intent.type != INTENT_HARM)
			if(I.w_class > WEIGHT_CLASS_NORMAL)
				to_chat(user, "<span class='warning'>[I] does not fit!</span>")
				return
			if(w_items + I.w_class > WEIGHT_CLASS_HUGE)
				to_chat(user, "<span class='warning'>The toilet is full!</span>")
				return
			if(!user.transferItemToLoc(I, src))
				to_chat(user, "<span class='warning'>\The [I] is stuck to your hand, you cannot put it in the cistern!</span>")
				return
			w_items += I.w_class
			to_chat(user, "<span class='notice'>I carefully place [I] into the toilet.</span>")

	else if(istype(I, /obj/item/reagent_containers))
		if (!open)
			return
		var/obj/item/reagent_containers/RG = I
		RG.reagents.add_reagent(/datum/reagent/water/gross, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		to_chat(user, "<span class='notice'>I fill [RG] from [src].</span>")
	else
		return ..()
