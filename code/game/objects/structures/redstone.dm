GLOBAL_LIST_EMPTY(redstone_objs)


/obj/structure
	var/redstone_structure = FALSE //If you want the structure to interact with player built redstone
	var/redstone_id //Used for connecting mapload structures
	var/last_redstone_power
	var/list/redstone_attached = list()

/obj/structure/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(!redstone_structure)
		return
	if(!istype(I, /obj/item/contraption/linker))
		return
	var/obj/item/contraption/linker/multitool = I
	if(!multitool.current_charge)
		return
	if(user.get_skill_level(/datum/skill/craft/engineering) < 1)
		to_chat(user, span_warning("I have no idea how to use [multitool]!"))
		return
	user.visible_message("[user] starts tinkering with [src].", "You start tinkering with [src].")
	if(!do_after(user, 8 SECONDS, src))
		return
	var/datum/effect_system/spark_spread/noisy/S = new()
	var/turf/front = get_turf(src)
	S.set_up(1, 1, front)
	S.start()
	if(isstructure(multitool.buffer))
		var/obj/structure/buffer_structure = multitool.buffer
		if(src == buffer_structure)
			to_chat(user, "You uncalibrate [src] from all its connections.")
			for(var/obj/structure/O in redstone_attached)
				O.redstone_attached -= src
				redstone_attached -= O
			GLOB.redstone_objs -= src
			return
		buffer_structure.redstone_attached |= src
		redstone_attached |= buffer_structure
		GLOB.redstone_objs |= src
		GLOB.redstone_objs |= buffer_structure
		to_chat(user, "You calibrate [src] to the output of [buffer_structure].")
	else
		to_chat(user, "You store the internal schematics of [src] on [multitool].")
		multitool.set_buffer(src)
	multitool.charge_deduction(src, user, 1)

/obj/structure/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("redstone_id")
			update_redstone_id(var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

	return ..()

/obj/structure/proc/update_redstone_id(new_id)
	if(new_id)
		GLOB.redstone_objs |= src
		redstone_attached = list()
		redstone_id = new_id
		for(var/obj/structure/S in GLOB.redstone_objs)
			if(S == src)
				continue
			if(S.redstone_id == redstone_id)
				redstone_attached |= S
				S.redstone_attached |= src

/obj/structure/proc/redstone_triggered(mob/user)
	return

/obj/structure/lever
	name = "lever"
	desc = "I want to pull it."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "leverfloor0"
	density = FALSE
	anchored = TRUE
	max_integrity = 3000
	redstone_structure = TRUE
	var/toggled = FALSE

/obj/structure/lever/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		L.changeNext_move(CLICK_CD_MELEE)
		var/used_time = 10 SECONDS - (L.STASTR * 1 SECONDS)
		user.visible_message("<span class='warning'>[user] pulls the lever.</span>")
		user.log_message("pulled the lever with redstone id \"[redstone_id]\"", LOG_GAME)
		if(do_after(user, used_time))
			for(var/obj/structure/structure in redstone_attached)
				INVOKE_ASYNC(structure, PROC_REF(redstone_triggered), user)
			trigger_wire_network(user)
			toggled = !toggled
			icon_state = "leverfloor[toggled]"
			playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)

/obj/structure/lever/onkick(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		L.changeNext_move(CLICK_CD_MELEE)
		user.visible_message("<span class='warning'>[user] kicks the lever!</span>")
		user.log_message("kicked the lever with redstone id \"[redstone_id]\"", LOG_GAME)
		playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
		if(prob(L.STASTR * 4))
			for(var/obj/structure/structure in redstone_attached)
				INVOKE_ASYNC(structure, PROC_REF(redstone_triggered), user)
			trigger_wire_network(user)
			toggled = !toggled
			icon_state = "leverfloor[toggled]"
			playsound(src, 'sound/foley/lever.ogg', 100, extrarange = 3)

/obj/structure/lever/wall
	icon_state = "leverwall0"

/obj/structure/lever/wall/attack_hand(mob/user)
	. = ..()
	icon_state = "leverwall[toggled]"

/obj/structure/lever/wall/onkick(mob/user)
	. = ..()
	icon_state = "leverwall[toggled]"

/obj/structure/lever/hidden
	name = "hidden lever"
	desc = "If you can see this... how?"
	icon = null
	//the perception DC to use this
	var/hidden_dc = 10
	//ignore the DC's with a trait
	var/accessor_trait

/obj/structure/lever/hidden/proc/feel_button(mob/living/user, ignore_dc = FALSE)
	if(!isliving(user))
		return
	var/mob/living/L = user
	if(!(accessor_trait && HAS_MIND_TRAIT(user, accessor_trait)))
		var/bonuses = (HAS_TRAIT(user, TRAIT_THIEVESGUILD) || HAS_TRAIT(user, TRAIT_ASSASSIN)) ? 2 : 0
		if(L.STAPER + bonuses < hidden_dc)
			return // nothing here!
	L.changeNext_move(CLICK_CD_MELEE)
	user.visible_message(span_danger("[user] presses a hidden button."), span_notice("I push a hidden button."))
	user.log_message("pulled the lever with redstone id \"[redstone_id]\"", LOG_GAME)
	for(var/obj/structure/structure in redstone_attached)
		INVOKE_ASYNC(structure, PROC_REF(redstone_triggered), user)
	trigger_wire_network(user)
	toggled = !toggled
	playsound(src, 'sound/foley/lever.ogg', 50)

/obj/structure/lever/hidden/onkick(mob/user) // nice try
	return FALSE

/obj/structure/lever/hidden/IsObscured()
	. = ..()
	if(!icon)
		return TRUE

/obj/structure/lever/hidden/keep
	hidden_dc = 14
	accessor_trait = TRAIT_KNOW_KEEP_DOORS

/obj/structure/lever/hidden/inquisition
	hidden_dc = 14
	accessor_trait = TRAIT_KNOW_INQUISITION_DOORS

/obj/structure/lever/hidden/thieves_guild
	hidden_dc = 13
	accessor_trait = TRAIT_KNOW_THIEF_DOORS

/obj/structure/repeater
	name = "repeater"
	desc = "Repeats a signal a set amount of times into an adjacently linked machine when activated by a signal. Looks suspiciously like a barrel."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "repeater"
	w_class = WEIGHT_CLASS_HUGE // mechanical stuff is usually pretty heavy.
	max_integrity = 5
	density = TRUE
	anchored = TRUE
	redstone_structure = TRUE
	var/mode = 1 // 1 means repeat 5 times, 2 means random, 0 means indefinite but has chance to explode, 3 means indefinite no chance to explode
	var/obj/structure/linked_thing // because redstone code is weird

/obj/structure/repeater/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)

/obj/structure/repeater/attack_hand(mob/user)
	. = ..()
	if(user.get_skill_level(/datum/skill/craft/engineering) < 1)
		to_chat(user, span_warning("I have no idea how to use [src]!"))
		return
	if(user.used_intent.type == INTENT_HARM)
		playsound(src, 'sound/combat/hits/punch/punch (1).ogg', 100, FALSE, -1)
		sleep(1)
		switch(mode)
			if(0)
				mode = 1
				say("Mode: REPEATER 5 TIMES")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			if(1)
				mode = 2
				say("Mode: REPEATER RANDOM")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			if(2)
				mode = 0
				say("Mode: INDEFINITE, DANGEROUS")
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	linked_thing = null
	var/list/structures = list()
	for(var/obj/structure/adjc in get_step(src, dir).contents)
		if(!adjc.redstone_structure)
			continue
		structures += adjc
	var/input = browser_input_list(user, "Choose structure to link", "REPEATER", structures)
	if(input)
		playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
		if(istype(linked_thing, /obj/structure/repeater))
			say("BZZZZZZZZ!!!")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			sleep(10)
			explosion(src, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
			qdel(src)
			return
		linked_thing = input

/obj/structure/repeater/redstone_triggered(mob/user)
	. = ..()
	var/repeat_times = 0
	switch(mode)
		if(1)
			repeat_times = 5
		if(2)
			repeat_times = rand(2,8)

	if(!repeat_times)
		if(mode == 3)
			for(var/i in 1 to INFINITY)
				if(QDELETED(src) || mode != 3)
					break
				INVOKE_ASYNC(linked_thing, PROC_REF(redstone_triggered), user)
				sleep(5)
		else if(mode == 0)
			for(var/i in 1 to INFINITY)
				if(QDELETED(src) || mode != 0)
					break
				if(prob(25))
					explosion(src, light_impact_range = 1, flame_range = 2, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
					qdel(src)
					break
				INVOKE_ASYNC(linked_thing, PROC_REF(redstone_triggered), user)
				sleep(5)
		return

	for(var/i in 1 to repeat_times)
		INVOKE_ASYNC(linked_thing, PROC_REF(redstone_triggered), user)
		sleep(5)

/obj/structure/pressure_plate
	name = "pressure plate"
	desc = "Be careful. Stepping on this could either mean a bomb exploding or a door closing on you."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pressureplate"
	max_integrity = 45 // so it gets destroyed when used to explode a bomb
	density = FALSE
	anchored = TRUE
	redstone_structure = TRUE

/obj/structure/pressure_plate/Crossed(atom/movable/AM)
	. = ..()
	if(!anchored)
		return
	if(isliving(AM))
		var/mob/living/L = AM
		to_chat(L, "<span class='info'>I feel something click beneath me.</span>")
		AM.log_message("has activated a pressure plate", LOG_GAME)
		playsound(src, 'sound/misc/pressurepad_down.ogg', 65, extrarange = 2)
	if(isstructure(AM))
		var/obj/structure/structure = AM
		if(structure.w_class >= WEIGHT_CLASS_BULKY)
			playsound(src, 'sound/misc/pressurepad_down.ogg', 65, extrarange = 2)
			triggerplate()
			trigger_wire_network(AM)

/obj/structure/pressure_plate/Uncrossed(atom/movable/AM)
	. = ..()
	if(!anchored)
		return
	if(isliving(AM))
		triggerplate()
		trigger_wire_network(AM)

/obj/structure/pressure_plate/proc/triggerplate()
	playsound(src, 'sound/misc/pressurepad_up.ogg', 65, extrarange = 2)
	for(var/obj/structure/structure in redstone_attached)
		INVOKE_ASYNC(structure, PROC_REF(redstone_triggered))

/obj/structure/pressure_plate/attack_hand(mob/user)
	. = ..()
	if(user.used_intent.type == INTENT_HARM)
		playsound(src, 'sound/combat/hits/punch/punch (1).ogg', 100, FALSE, -1)
		triggerplate()
		anchored = !anchored

/obj/structure/activator
	name = "activator"
	desc = "A strange structure with an opening for an item on the top with an arrow etched into it pointing to where it is possibly aiming."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "activator"
	max_integrity = 45 // so it gets destroyed when used to explode a bomb
	w_class = WEIGHT_CLASS_HUGE // mechanical stuff is usually pretty heavy.
	density = TRUE
	anchored = TRUE
	redstone_structure = TRUE
	var/obj/item/containment
	var/obj/item/ammo_holder/ammo // used if the contained item is a bow or crossbow

/obj/structure/activator/Initialize(mapload, ...)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)

/obj/structure/activator/Destroy()
	ammo = null
	if(containment)
		containment.forceMove(get_turf(src))
	containment = null
	return ..()

/obj/structure/activator/attack_hand(mob/user)
	. = ..()
	playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	sleep(7)
	if(containment)
		playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		containment.forceMove(get_turf(src))
		containment = null
	if(ammo)
		playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		ammo.forceMove(get_turf(src))
		ammo = null
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/structure/activator/attackby(obj/item/I, mob/user, list/modifiers)
	if(!containment && (istype(I, /obj/item/gun/ballistic/revolver/grenadelauncher) || istype(I, /obj/item/explosive/bottle) || istype(I, /obj/item/flint)))
		if(!user.transferItemToLoc(I, src))
			return ..()
		containment = I
		playsound(src, 'sound/misc/chestclose.ogg', 25)
		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	if(!ammo && istype(I, /obj/item/ammo_holder))
		if(!user.transferItemToLoc(I, src))
			return
		playsound(src, 'sound/misc/chestclose.ogg', 25)
		ammo = I
		return TRUE
	return ..()

/obj/structure/activator/redstone_triggered(mob/user)
	if(!containment)
		return
	if(istype(containment, /obj/item/explosive/bottle))
		var/obj/item/explosive/bottle/bomba = containment
		bomba.arm_grenade()
	if(istype(containment, /obj/item/flint))
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_step(src, dir)
		S.set_up(1, 1, front)
		S.start()
	if(istype(containment, /obj/item/gun/ballistic/revolver/grenadelauncher))
		if(!ammo)
			return
		if(ammo.ammo_list.len)
			var/obj/item/gun/ballistic/revolver/grenadelauncher/B = containment
			var/obj/item/ammo_box/gun_magazine = B.mag_type
			var/obj/item/ammo_casing/caseless/gun_ammo = initial(gun_magazine?.ammo_type)
			for(var/obj/item/ammo_casing/BT in ammo.ammo_list)
				if(istype(BT, gun_ammo))
					ammo.ammo_list -= BT
					BT.fire_casing(get_step(src, dir), null, null, null, null, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST), 0,  src)
					ammo.contents -= BT
					ammo.update_appearance()
					break

/obj/structure/floordoor
	name = "floorhatch"
	desc = "A handy floor hatch for people who need privacy upstairs."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "floorhatch1"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	redstone_structure = TRUE
	var/togg = FALSE
	var/base_state = "floorhatch"
	resistance_flags = INDESTRUCTIBLE
/*
/obj/structure/floordoor/Initialize()
	AddComponent(/datum/component/squeak, list('sound/foley/footsteps/FTMET_A1.ogg','sound/foley/footsteps/FTMET_A2.ogg','sound/foley/footsteps/FTMET_A3.ogg','sound/foley/footsteps/FTMET_A4.ogg'), 40)
	return ..()
*/
/obj/structure/floordoor/atom_break(damage_flag)
	. = ..()
	obj_flags = null

/obj/structure/floordoor/atom_fix()
	. = ..()
	obj_flags = initial(obj_flags)

/obj/structure/floordoor/redstone_triggered(mob/user)
	if(obj_broken)
		return
	togg = !togg
	if(togg)
		icon_state = "[base_state]0"
		obj_flags = null
		var/turf/T = loc
		if(istype(T))
			for(var/atom/movable/M in loc)
				T.Entered(M)
	else
		icon_state = "[base_state]1"
		obj_flags = BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	if(user)
		log_game("[user] triggered [src] at [x], [y], [z]. REDSTONE ID: [redstone_id]")

/obj/structure/floordoor/gatehatch
	name = ""
	desc = ""
	base_state = ""
	icon_state = ""
	var/changing_state = FALSE
	var/delay2open = 0
	var/delay2close = 0
	resistance_flags = INDESTRUCTIBLE
	no_over_text = TRUE
	mouse_opacity = 0
	redstone_structure = TRUE

/obj/structure/floordoor/gatehatch/Initialize()
	AddComponent(/datum/component/squeak, list('sound/foley/footsteps/FTMET_A1.ogg','sound/foley/footsteps/FTMET_A2.ogg','sound/foley/footsteps/FTMET_A3.ogg','sound/foley/footsteps/FTMET_A4.ogg'), 40, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	return ..()

/obj/structure/floordoor/gatehatch/redstone_triggered(mob/user)
	if(changing_state)
		return
	if(obj_broken)
		return
	changing_state = TRUE
	togg = !togg
	if(togg)
		sleep(delay2open)
		icon_state = "[base_state]0"
		obj_flags = null
		var/turf/T = loc
		if(istype(T))
			for(var/atom/movable/M in loc)
				T.Entered(M)
		sleep(40-delay2open)
		changing_state = FALSE
	else
		sleep(delay2close)
		icon_state = "[base_state]1"
		obj_flags = BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
		sleep(40-delay2close)
		changing_state = FALSE

/obj/structure/floordoor/gatehatch/inner
	delay2open = 10
	delay2close = 30

/obj/structure/floordoor/gatehatch/outer
	delay2open = 30
	delay2close = 10

/obj/structure/kybraxor
	name = "Kybraxor the Devourer"
	desc = "Two massive slabs of metal flooring which threaten to swallow you whole. Watch out!"
	density = FALSE
	no_over_text = TRUE
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "kybraxor1"
	redstone_id = "gatelava"
	var/openn = FALSE
	var/changing_state = FALSE
	layer = ABOVE_OPEN_TURF_LAYER
	resistance_flags = INDESTRUCTIBLE

/obj/structure/kybraxor/redstone_triggered(mob/user)
	if(changing_state)
		return
	if(obj_broken)
		return
	changing_state = TRUE
	openn = !openn
	if(openn)
		playsound(src, 'sound/misc/kybraxorop.ogg', 100, FALSE)
		flick("kybraxoropening",src)
		sleep(40)
		icon_state = "kybraxor0"
		changing_state = FALSE
	else
		playsound(src, 'sound/misc/kybraxor.ogg', 100, FALSE)
		flick("kybraxorclosing",src)
		sleep(40)
		icon_state = "kybraxor1"
		changing_state = FALSE
