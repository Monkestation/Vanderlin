/obj/structure/chair/bench
	name = "bench"
	icon_state = "bench"
	icon = 'icons/roguetown/misc/structure.dmi'
	buildstackamount = 1
	item_chair = null
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	sleepy = 0.55
	layer = OBJ_LAYER
	metalizer_result = /obj/item/statue/iron/deformed
	anchored = TRUE

/obj/structure/chair/bench/church
	icon_state = "church_benchleft"

/obj/structure/chair/bench/church/mid
	icon_state = "church_benchmid"

/obj/structure/chair/bench/church/r
	icon_state = "church_benchright"

/obj/structure/chair/bench/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)
	handle_layer()

/obj/structure/chair/bench/post_buckle_mob(mob/living/M)
	..()
	density = TRUE

/obj/structure/chair/bench/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE

/obj/structure/chair/bench/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover, /obj/projectile))
		return TRUE
	if(get_dir(mover, loc) == dir)
		return FALSE

/obj/structure/chair/bench/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(istype(leaving, /obj/projectile))
		return
	if(get_dir(new_location, leaving.loc) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/chair/bench/church/smallbench
	icon_state = "benchsmall"

/obj/structure/chair/bench/coucha
	icon_state = "redcouch"

/obj/structure/chair/bench/coucha/r
	icon_state = "redcouch2"

/obj/structure/chair/bench/ultimacouch
	icon_state = "ultimacouchleft"

/obj/structure/chair/bench/ultimacouch/r
	icon_state = "ultimacouchright"

/obj/structure/chair/bench/coucha
	icon_state = "couchaleft"

/obj/structure/chair/bench/coucha/r
	icon_state = "coucharight"

/obj/structure/chair/bench/couchablack
	icon_state = "couchablackaleft"

/obj/structure/chair/bench/couchablack/r
	icon_state = "couchablackaright"

/obj/structure/chair/bench/throne
	name = "small throne"
	icon_state = "thronechair"

// dirtier sofa
/obj/structure/chair/bench/coucha/redleft
	icon_state = "redcouch_alt"

/obj/structure/chair/bench/coucha/redright
	icon_state = "redcouch2_alt"

/obj/structure/chair/wood/alt
	icon_state = "chair2"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	metalizer_result = /obj/item/statue/iron/deformed

/obj/structure/chair/wood/alt/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/chair/wood/alt/uncomfortable
	icon_state = "chair_bronze"
	desc = "This has to be the most uncomfortable chair in Psydonia. It looks like it will *violate* your backside." //This is a DE reference don't be fucking weird about it.
	item_chair = /obj/item/chair/bronze
	attacked_sound = "sound/combat/hits/onmetal/metalimpact (1).ogg"

/obj/item/chair/bronze
	icon_state = "chair_bronze"
	origin_type = /obj/structure/chair/wood/alt/uncomfortable

/obj/structure/chair/wood/alt/chair3
	icon_state = "chair3"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/chair3
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/item/chair/chair3
	icon_state = "chair3"
	origin_type = /obj/structure/chair/wood/alt/chair3

/*	..................   "Noble" chairs   ................... */
/obj/structure/chair/wood/alt/chair_noble
	name = "fine chair"
	icon_state = "chair_green"
	icon = 'icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/chair_nobles
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/item/chair/chair_nobles
	icon_state = "chair_green"
	origin_type = /obj/structure/chair/wood/alt/chair_noble

/obj/structure/chair/wood/alt/chair_noble/purple
	icon_state = "chair_purple"
	item_chair = /obj/item/chair/chair_nobles/purple

/obj/item/chair/chair_nobles/purple
	icon_state = "chair_purple"
	origin_type = /obj/structure/chair/wood/alt/chair_noble/purple

/obj/structure/chair/wood/alt/chair_noble/red
	icon_state = "chair_red"
	item_chair = /obj/item/chair/chair_nobles/red

/obj/item/chair/chair_nobles/red
	icon_state = "chair_red"
	origin_type = /obj/structure/chair/wood/alt/chair_noble/red


/obj/structure/chair/wood/alt/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(isliving(mover))
		var/mob/living/M = mover
		if((M.body_position != LYING_DOWN))
			if(isturf(loc))
				var/movefrom = get_dir(M.loc, loc)
				if(movefrom == dir && item_chair != null)
					playsound(src, 'sound/foley/chairfall.ogg', 100, FALSE)
					var/obj/item/I = new item_chair(loc)
					item_chair = null
					I.dir = dir
					qdel(src)
					return FALSE

/obj/structure/chair/wood/alt/onkick(mob/user)
	if(!user)
		return
	if(isturf(loc))
		playsound(src, 'sound/foley/chairfall.ogg', 100, FALSE)
		var/obj/item/I = new item_chair(loc)
		item_chair = null
		I.dir = dir
		qdel(src)
		return FALSE

/obj/structure/chair/wood/alt/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(!isliving(leaving))
		return
	var/mob/living/M = leaving
	if(M.body_position == LYING_DOWN)
		return
	if(get_dir(leaving.loc, new_location) == REVERSE_DIR(dir))
		playsound(src, 'sound/foley/chairfall.ogg', 100, FALSE)
		var/obj/item/I = new item_chair(loc)
		item_chair = null
		I.dir = dir
		qdel(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/chair/wood/alt/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	if(damage_amount > 5 && item_chair != null)
		playsound(src, 'sound/foley/chairfall.ogg', 100, FALSE)
		var/obj/item/I = new item_chair(loc)
		item_chair = null
		I.dir = dir
		qdel(src)
		return FALSE
	return ..()

/obj/structure/chair/wood/alt/fancy
	icon_state = "chair1"
	item_chair = /obj/item/chair/fancy

/obj/item/chair/fancy
	icon_state = "chair1"
	origin_type = /obj/structure/chair/wood/alt/fancy

/obj/structure/chair/wood/alt/post_buckle_mob(mob/living/M)
	..()
	density = TRUE

/obj/structure/chair/wood/alt/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE

/obj/item/chair/stool/bar
	name = "barstool"
	icon_state = "barstoolover"
	icon = 'icons/roguetown/misc/structure.dmi'
	origin_type = /obj/structure/chair/stool/bar
	blade_dulling = DULLING_BASHCHOP
	can_parry = TRUE
	gripped_intents = list(/datum/intent/hit)
	obj_flags = CAN_BE_HIT
	max_integrity = 100
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/item/chair/stool/bar/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("wieldedl")
				return list("shrink" = 0.8,"sx" = 3,"sy" = -8,"nx" = -19,"ny" = -6,"wx" = -13,"wy" = -7,"ex" = 1,"ey" = -5,"westabove" = 1,"eastbehind" = 0,"nturn" = 30,"sturn" = -18,"wturn" = 30,"eturn" = -24,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = -20,"sy" = -6,"nx" = 0,"ny" = -7,"wx" = -18,"wy" = -5,"ex" = -4,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -42,"sturn" = 33,"wturn" = 33,"eturn" = -21,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

// ------------ GOOD BEDS ----------------------
/obj/structure/bed/inn
	icon_state = "inn_bed"
	sleepy = 3

/obj/structure/bed/inn/double
	icon_state = "double"
	max_buckled_mobs = 2
	sleepy = 3
	debris = list(/obj/item/grown/log/tree/small = 2)
	/// The mob who buckled to this bed second, to avoid other mobs getting pixel-shifted before they unbuckle.
	var/mob/living/goldilocks

/obj/structure/bed/inn/double/post_buckle_mob(mob/living/target)
	. = ..()
	if(length(buckled_mobs) > 1 && !goldilocks) //  Push the second buckled mob a bit higher from the normal lying position
		target.set_mob_offsets("bed_buckle", _x = 0, _y = 12)
		goldilocks = target

/obj/structure/bed/inn/double/post_unbuckle_mob(mob/living/target)
	. = ..()
	if(target == goldilocks)
		goldilocks = null

// ------------ DECENT BEDS ----------------------
/obj/structure/bed/wool
	name = "wool bed"
	desc = "A comfy bed, made from soft cloth"
	icon_state = "woolbed"
	sleepy = 2

/obj/structure/bed/wool/double
	name = "big wool bed"
	desc = "A large soft bed, could fit two people."
	icon_state = "double_wool"
	max_buckled_mobs = 2
	debris = list(/obj/item/grown/log/tree/small = 2)
	/// The mob who buckled to this bed second, to avoid other mobs getting pixel-shifted before they unbuckle.
	var/mob/living/goldilocks

/obj/structure/bed/wool/double/post_buckle_mob(mob/living/target)
	. = ..()
	if(length(buckled_mobs) > 1 && !goldilocks) //  Push the second buckled mob a bit higher from the normal lying position
		target.set_mob_offsets("bed_buckle", _x = 0, _y = 12)
		goldilocks = target

/obj/structure/bed/wool/double/post_unbuckle_mob(mob/living/target)
	. = ..()
	if(target == goldilocks)
		goldilocks = null

// ------------ ACCEPTABLE BEDS ----------------------
/obj/structure/bed/hay
	name = "hay bed"
	desc = "A bed padded with hay. At least you're not sleeping on the floor."
	icon_state = "haybed"
	sleepy = 1
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/bed/mediocre
	icon_state = "shitbed2"
	sleepy = 1

// Inhumen boss bed. Sleeping on a bear! Kinda comfy, sort of
/obj/structure/bed/bear
	desc = "A hide of a slain bear. It looks like someone sleeps on it often."
	icon = 'icons/obj/bear.dmi'
	icon_state = "bear"
	sleepy = 1


// ------------ UNCOMFORTABLE BEDS ----------------------
/obj/structure/bed/shit
	name = "uncomfortable bed"
	desc = "Slightly better than a patch of grass."
	icon_state = "shitbed"
	sleepy = 0.75

/obj/structure/bed/sleepingbag
	name = "bedroll"
	desc = "So you can sleep on the ground in relative peace."
	icon_state = "sleepingcloth"
	attacked_sound = 'sound/foley/cloth_rip.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	sleepy = 0.75
	var/item_path = /obj/item/sleepingbag

/obj/structure/bed/sleepingbag/MiddleClick(mob/user, list/modifiers)
	..()
	user.visible_message("<span class='notice'>[user] begins rolling up \the [src].</span>")
	if(do_after(user, 2 SECONDS, target = src))
		var/obj/item/new_bedroll = new item_path(get_turf(src))
		new_bedroll.color = color
		user.put_in_hands(new_bedroll)
		qdel(src)

/obj/structure/bed/sleepingbag/deluxe
	name = "deluxe bedroll"
	desc = "For people who want to sleep on the ground in a relatively more comfortable peace."
	sleepy = 1
	item_path = /obj/item/sleepingbag/deluxe

/obj/item/sleepingbag
	name = "rolled-up bedroll"
	desc = "A quick and simple way to create a resting place on the ground."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "sleepingcloth_rolled"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BACK
	grid_height = 64
	grid_width = 96
	var/bed_path = /obj/structure/bed/sleepingbag

/obj/item/sleepingbag/attack_self(mob/user, list/modifiers)
	..()
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, "<span class='warning'>I need ground to plant this on!</span>")
		return
	for(var/obj/A in T)
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, "<span class='warning'>There is already something here!</span>")
			return
	user.visible_message("<span class='notice'>[user] begins placing \the [src] down on the ground.</span>")
	if(do_after(user, 2 SECONDS, src, (IGNORE_HELD_ITEM)))
		var/obj/structure/new_bedroll = new bed_path(get_turf(src))
		new_bedroll.color = color
		qdel(src)

/obj/item/sleepingbag/MiddleClick(mob/user, list/modifiers)
	. = ..()
	attack_self(user, modifiers)

/obj/item/sleepingbag/deluxe
	name = "rolled-up deluxe bedroll"
	desc = "A portable bedroll made from durable and comfortable material."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bedroll_r"
	bed_path = /obj/structure/bed/sleepingbag/deluxe

/obj/structure/bed/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0 + src.pixel_x, _y = src.pixel_y)

/obj/structure/bed/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

/obj/structure/chair/wood/alt/chair3/crafted
	item_chair = /obj/item/chair/chair3/crafted
	sellprice = 6

/obj/item/chair/chair3/crafted
	origin_type = /obj/structure/chair/wood/alt/chair3/crafted
	sellprice = 6

/obj/structure/chair/wood/alt/fancy/crafted
	item_chair = /obj/item/chair/fancy/crafted
	sellprice = 12

/obj/item/chair/fancy/crafted
	origin_type = /obj/structure/chair/wood/alt/fancy/crafted
	sellprice = 12

/obj/structure/chair/stool/crafted
	item_chair = /obj/item/chair/stool/crafted
	sellprice = 6

/obj/item/chair/stool/crafted
	origin_type = /obj/structure/chair/stool/crafted
	sellprice = 6
