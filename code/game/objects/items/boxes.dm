/obj/item/storage/box
	name = "box"
	desc = ""
	icon_state = "box"
	item_state = "syringe_kit"
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/matchboxdrop.ogg'
	pickup_sound =  'sound/blank.ogg'
	var/foldable
	var/illustration = "writing"

/obj/item/storage/box/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/storage/box/suicide_act(mob/living/carbon/user)
	var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
	if(myhead)
		user.visible_message("<span class='suicide'>[user] puts [user.p_their()] head into \the [src], and begins closing it! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		myhead.dismember()
		myhead.forceMove(src)//force your enemies to kill themselves with your head collection box!
		playsound(user, "desceration-01.ogg", 50, TRUE, -1)
		return BRUTELOSS
	user.visible_message("<span class='suicide'>[user] beating [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/item/storage/box/update_icon()
	. = ..()
	if(illustration)
		cut_overlays()
		add_overlay(illustration)

/obj/item/storage/box/attack_self(mob/user)
	..()

	if(!foldable)
		return
	if(contents.len)
		to_chat(user, "<span class='warning'>I can't fold this box with items still inside!</span>")
		return
	if(!ispath(foldable))
		return

	to_chat(user, "<span class='notice'>I fold [src] flat.</span>")
	var/obj/item/I = new foldable
	qdel(src)
	user.put_in_hands(I)

/obj/item/storage/box/matches
	name = "matchbox"
	desc = ""
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "matchbox"
	item_state = "zippo"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP
	foldable = FALSE

/obj/item/storage/box/matches/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10
	STR.set_holdable(list(/obj/item/match))

/obj/item/storage/box/matches/PopulateContents()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_FILL_TYPE, /obj/item/match)

/obj/item/storage/box/matches/attackby(obj/item/match/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/match))
		if(prob(30))
			W.matchignite()
		else
			playsound(src, "sound/items/match_fail.ogg", 100, FALSE)
