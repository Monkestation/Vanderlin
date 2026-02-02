/obj/structure/chair
	name = "chair"
	desc = ""
	icon = 'icons/obj/chairs.dmi'
	icon_state = "chair"
	anchored = FALSE
	can_buckle = 1
	buckle_lying = 0 //you sit in a chair, not lay
	resistance_flags = NONE
	max_integrity = 250
	integrity_failure = 0.1
	pass_flags_self = PASSTABLE|LETPASSTHROW
	var/buildstacktype
	var/buildstackamount = 1
	var/item_chair = /obj/item/chair // if null it can't be picked up
	layer = OBJ_LAYER

/obj/structure/chair/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/structure/chair/deconstruct()
	// If we have materials, and don't have the NOCONSTRUCT flag
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/chair/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/chair/narsie_act()
	var/obj/structure/chair/wood/W = new/obj/structure/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/structure/chair/attackby(obj/item/W, mob/user, list/modifiers)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		deconstruct()
	else
		return ..()

/obj/structure/chair/proc/handle_rotation(direction)
	handle_layer()
	if(has_buckled_mobs())
		for(var/mob/living/buckled_mob as anything in buckled_mobs)
			buckled_mob.setDir(direction)

/obj/structure/chair/proc/handle_layer()
	if(dir == NORTH)
		layer = ABOVE_MOB_LAYER
		plane = GAME_PLANE_UPPER
	else
		layer = OBJ_LAYER
		plane = GAME_PLANE

/obj/structure/chair/post_buckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	M.set_mob_offsets("chair", _x = pixel_x, _y = pixel_y)

/obj/structure/chair/post_unbuckle_mob(mob/living/M)
	. = ..()
	handle_layer()
	M.reset_offsets("chair")

/obj/structure/chair/setDir(newdir)
	..()
	handle_rotation(newdir)

/obj/structure/chair/wood
	icon_state = "chair1"
	name = "chair"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	resistance_flags = FLAMMABLE
	max_integrity = 70
	buildstacktype = null
	buildstackamount = 0
	item_chair = /obj/item/chair/wood
	anchored = FALSE

/obj/structure/chair/wood/narsie_act()
	return
//Stool

/obj/structure/chair/stool
	name = "stool"
	desc = ""
	icon_state = "stool"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/stool
	max_integrity = 100
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	metalizer_result = /obj/item/cooking/pan

/obj/structure/chair/stool/handle_layer()
	return

/obj/structure/chair/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(QDELETED(src) || !item_chair || !usr.can_hold_items() || has_buckled_mobs() || src.flags_1 & NODECONSTRUCT_1)
			return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return
		usr.visible_message("<span class='notice'>[usr] grabs \the [src.name].</span>", "<span class='notice'>I grab \the [src.name].</span>")
		var/obj/item/C = new item_chair(loc)
		item_chair = null
		TransferComponents(C)
		usr.put_in_hands(C)
		qdel(src)

/obj/structure/chair/stool/bar
	name = "barstool"
	desc = ""
	icon_state = "barstool"
	item_chair = /obj/item/chair/stool/bar
	sleepy = 0.2

/obj/item/chair
	name = "chair"
	desc = ""
	icon = 'icons/roguetown/items/chairs.dmi'
	icon_state = "chair2"
	item_state = "chair"
	lefthand_file = 'icons/mob/inhands/misc/chairs_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/chairs_righthand.dmi'
	blade_dulling = DULLING_BASHCHOP
	can_parry = TRUE
	gripped_intents = list(/datum/intent/hit)

	w_class = WEIGHT_CLASS_HUGE
	force = 15
	throwforce = 10
	throw_range = 3
	hitsound = 'sound/blank.ogg'
	hit_reaction_chance = 50
	obj_flags = CAN_BE_HIT
	max_integrity = 100
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	sleepy = 0.1
	var/break_chance = 23 //Likely hood of smashing the chair.
	var/obj/structure/chair/origin_type = /obj/structure/chair/wood/alt

/obj/item/chair/apply_components()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))

/obj/item/chair/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("wieldedl")
				return list("shrink" = 0.7,"sx" = 2,"sy" = 1,"nx" = -17,"ny" = 0,"wx" = -11,"wy" = 0,"ex" = 2,"ey" = 0,"westabove" = 1,"eastbehind" = 0,"nturn" = 9,"sturn" = -42,"wturn" = 21,"eturn" = -27,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 2,"sy" = 1,"nx" = -17,"ny" = 0,"wx" = -11,"wy" = 0,"ex" = 2,"ey" = 0,"westabove" = 1,"eastbehind" = 0,"nturn" = 9,"sturn" = -42,"wturn" = 21,"eturn" = -27,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,)
	..()


/obj/item/chair/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins hitting [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	playsound(src,hitsound,50,TRUE)
	return BRUTELOSS

/obj/item/chair/narsie_act()
	var/obj/item/chair/wood/W = new/obj/item/chair/wood(get_turf(src))
	W.setDir(dir)
	qdel(src)

/obj/item/chair/attack_self(mob/user, list/modifiers)
	plant(user)

/obj/item/chair/proc/plant(mob/user)
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, "<span class='warning'>I need ground to plant this on!</span>")
		return
	for(var/obj/A in T)
		if(istype(A, /obj/structure/chair))
			to_chat(user, "<span class='warning'>There is already a chair here!</span>")
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, "<span class='warning'>There is already something here!</span>")
			return

	user.visible_message("<span class='notice'>[user] rights \the [src.name].</span>", "<span class='notice'>I right \the [name].</span>")
	var/obj/structure/chair/C = new origin_type(get_turf(loc))
	TransferComponents(C)
	C.setDir(user.dir)
	qdel(src)

/obj/item/chair/proc/smash(mob/living/user)
	qdel(src)

/obj/item/chair/afterattack(atom/target, mob/living/carbon/user, proximity, list/modifiers)
	. = ..()
	if(!proximity)
		return
	if(prob(break_chance))
		user.visible_message("<span class='warning'>[src] is smashed to pieces!</span>")
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			if(C.health < C.maxHealth*0.5)
				C.Paralyze(20)
		smash(user)

/obj/item/chair/stool
	name = "stool"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "stoolover"
	item_state = "stool"
	origin_type = /obj/structure/chair/stool

/obj/item/chair/stool/bar
	name = "barstool"
	icon_state = "barstoolover"
	item_state = "barstool"
	origin_type = /obj/structure/chair/stool/bar

/obj/item/chair/stool/narsie_act()
	return //sturdy enough to ignore a god

/obj/item/chair/wood
	name = "wooden chair"
	origin_type = /obj/structure/chair/wood
	break_chance = 50

/obj/item/chair/wood/narsie_act()
	return

/obj/structure/chair/mime
	name = "invisible chair"
	desc = ""
	anchored = FALSE
	icon_state = null
	buildstacktype = null
	item_chair = null
	flags_1 = NODECONSTRUCT_1
	alpha = 0

/obj/structure/chair/mime/post_buckle_mob(mob/living/M)
	M.pixel_y += 5

/obj/structure/chair/mime/post_unbuckle_mob(mob/living/M)
	M.pixel_y -= 5
