//Fluff structures serve no purpose and exist only for enriching the environment. They can be destroyed with a wrench.

/obj/structure/fluff
	name = "fluff structure"
	desc = ""
	icon_state = "minibar"
	anchored = TRUE
	density = FALSE
	opacity = 0
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 150
	var/deconstructible = TRUE

/obj/structure/fluff/big_chain
	name = "giant chain"
	desc = ""
	icon = 'icons/effects/32x96.dmi'
	icon_state = "chain"
	layer = ABOVE_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	deconstructible = FALSE

/obj/structure/fluff/railing
	name = "railing"
	icon = 'icons/roguetown/misc/railing.dmi'
	icon_state = "railing"
	density = TRUE
	anchored = TRUE
	deconstructible = FALSE
	flags_1 = ON_BORDER_1
	climbable = TRUE
	layer = ABOVE_MOB_LAYER
	pass_flags_self = PASSSTRUCTURE|LETPASSCLICKS

	/// Living mobs can lay down to go past
	var/pass_crawl = TRUE
	/// Projectiles can go past
	var/pass_projectile = TRUE
	/// Throwing atoms can go past
	var/pass_throwing = TRUE
	/// Throwing/Flying non mobs can always exit the turf regardless of other flags
	var/allow_flying_outwards = TRUE

/obj/structure/fluff/railing/Initialize()
	. = ..()
	init_connect_loc_element()
	var/lay = getwlayer(dir)
	if(lay)
		layer = lay

/obj/structure/fluff/railing/proc/init_connect_loc_element()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/railing/proc/getwlayer(dirin)
	switch(dirin)
		if(NORTH)
			layer = BELOW_MOB_LAYER-0.01
		if(WEST)
			layer = BELOW_MOB_LAYER
		if(EAST)
			layer = BELOW_MOB_LAYER
		if(SOUTH)
			layer = ABOVE_MOB_LAYER
			plane = GAME_PLANE_UPPER

/obj/structure/fluff/railing/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, target) != dir)
		return TRUE
	if(pass_crawl && isliving(mover))
		var/mob/living/M = mover
		if(M.body_position == LYING_DOWN)
			return TRUE
	if(mover.movement_type & (FLOATING|FLYING))
		if(istype(mover, /obj/projectile) && !pass_projectile)
			return FALSE
		return TRUE
	if(pass_throwing && mover.throwing)
		return TRUE

/obj/structure/fluff/railing/CanAStarPass(ID, to_dir, requester)
	if(dir in CORNERDIRS)
		return TRUE
	if(ismovable(requester))
		var/atom/movable/mover = requester
		if(mover.movement_type & (FLOATING|FLYING))
			return TRUE
	if(to_dir == dir)
		return FALSE
	return TRUE

/obj/structure/fluff/railing/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER

	if(dir in CORNERDIRS)
		return

	if(isobserver(leaving))
		return

	if(get_dir(leaving.loc, new_location) != dir)
		return

	if(leaving.movement_type & (FLOATING|FLYING))
		if(istype(leaving, /obj/projectile) && (pass_projectile || allow_flying_outwards))
			return

	if(leaving.throwing)
		if(pass_throwing || (allow_flying_outwards && !ismob(leaving)))
			return

	if(pass_crawl && isliving(leaving))
		var/mob/living/M = leaving
		if(M.body_position == LYING_DOWN)
			return

	leaving.Bump(src)
	return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/railing/OnCrafted(dirin, mob/user)
	dir = dirin
	var/lay = getwlayer(dir)
	if(lay)
		layer = lay
	return ..()

/obj/structure/fluff/railing/corner
	icon_state = "railing_corner"

/obj/structure/fluff/railing/corner/init_connect_loc_element()
	return

/obj/structure/fluff/railing/wood
	icon_state = "woodrailing"
	blade_dulling = DULLING_BASHCHOP
	layer = ABOVE_MOB_LAYER

/obj/structure/fluff/railing/stonehedge
	name = "stone railing"
	icon_state = "stonehedge"
	blade_dulling = DULLING_BASHCHOP

/obj/structure/fluff/railing/border
	name = "border"
	desc = ""
	icon_state = "border"
	pass_crawl = FALSE

/obj/structure/fluff/railing/tall
	name = "wooden fence"
	desc = "A sturdy fence of wooden planks."
	icon = 'icons/roguetown/misc/tallwoodenrailing.dmi'
	icon_state = "tallwoodenrailing"
	max_integrity = 500
	pass_crawl = FALSE
	pass_throwing = FALSE
	pass_projectile = TRUE

/obj/structure/fluff/railing/tall/palisade
	name = "palisade"
	desc = "A sturdy fence of wooden stakes."
	icon = 'icons/roguetown/misc/railing.dmi'
	icon_state = "fence"
	opacity = TRUE
	climb_offset = 6
	pass_projectile = FALSE

/obj/structure/bars
	name = "bars"
	desc = "Iron bars made to keep things in or out."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "bars"
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	pass_flags_self = PASSGRILLE|LETPASSTHROW|PASSSTRUCTURE|NOTLETPASSTHROWNMOB
	max_integrity = 700
	damage_deflection = 12
	integrity_failure = 0.15
	dir = SOUTH
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")

/obj/structure/bars/CanAllowThrough(atom/movable/mover, turf/target)
	if(isobserver(mover))
		return TRUE
	. = ..()
	if(. && density && mover.throwing && isitem(mover))
		var/obj/item/I = mover
		var/chance = 100 - (I.w_class-1) * 30
		if(isliving(I.throwing.thrower))
			var/mob/living/L = I.throwing.thrower
			chance += (L.STALUC - 10) * 10
		return prob(clamp(chance, 0, 100))

/obj/structure/bars/bent
	icon_state = "barsbent"

/obj/structure/bars/chainlink
	icon_state = "chainlink"

/obj/structure/bars/alt
	icon_state = "bars_alt"
	plane = GAME_PLANE
	layer = WALL_OBJ_LAYER+0.05

/obj/structure/bars/atom_break(damage_flag)
	. = ..()
	icon_state = "[initial(icon_state)]b"
	density = FALSE

/obj/structure/bars/atom_fix()
	. = ..()
	density = initial(density)
	icon_state = initial(icon_state)

/obj/structure/bars/cemetery
	icon_state = "cemetery"

/// like bars but indestructible and you cant throw through them
/obj/structure/bars/cemetery/underworld
	pass_flags_self = PASSSTRUCTURE
	resistance_flags = INDESTRUCTIBLE
	max_integrity = 9999

/obj/structure/bars/passage
	icon_state = "passage0"
	density = TRUE
	max_integrity = 2000
	redstone_structure = TRUE

/obj/structure/bars/passage/redstone_triggered(mob/user)
	if(obj_broken)
		return
	if(density)
		icon_state = "passage1"
		density = FALSE
	else
		icon_state = "passage0"
		density = TRUE

/obj/structure/bars/passage/shutter
	icon_state = "shutter0"
	density = TRUE
	opacity = TRUE
	redstone_structure = TRUE
	pass_flags_self = PASSSTRUCTURE

/obj/structure/bars/passage/shutter/redstone_triggered(mob/user)
	if(obj_broken)
		return
	if(density)
		icon_state = "shutter1"
		density = FALSE
		opacity = FALSE
	else
		icon_state = "shutter0"
		density = TRUE
		opacity = TRUE

/obj/structure/bars/passage/shutter/open
	icon_state = "shutter1"
	density = FALSE
	opacity = FALSE

/obj/structure/bars/grille
	name = "grille"
	desc = ""
	icon_state = "floorgrille"
	density = FALSE
	layer = TABLE_LAYER
	plane = GAME_PLANE
	damage_deflection = 5
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	redstone_structure = TRUE
	var/togg = FALSE

/obj/structure/bars/grille/Initialize()
	AddComponent(/datum/component/squeak, list('sound/foley/footsteps/FTMET_A1.ogg','sound/foley/footsteps/FTMET_A2.ogg','sound/foley/footsteps/FTMET_A3.ogg','sound/foley/footsteps/FTMET_A4.ogg'), 40, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	dir = pick(GLOB.cardinals)
	return ..()

/obj/structure/bars/grille/atom_break(damage_flag)
	. = ..()
	obj_flags = CAN_BE_HIT

/obj/structure/bars/grille/redstone_triggered(mob/user)
	if(obj_broken)
		return
	togg = !togg
	playsound(src, 'sound/foley/trap_arm.ogg', 100)
	if(togg)
		icon_state = "floorgrilleopen"
		obj_flags = CAN_BE_HIT
		var/turf/T = loc
		if(istype(T))
			for(var/mob/living/M in loc)
				T.Entered(M)
	else
		icon_state = "floorgrille"
		obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP


/obj/structure/plank
	name = "plank"
	desc = ""
	icon = 'icons/turf/floors.dmi'
	icon_state = "plank2"
	density = FALSE
	layer = TABLE_LAYER
	plane = GAME_PLANE
	damage_deflection = 5
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

/obj/structure/bars/pipe
	name = "bronze pipe"
	desc = ""
	icon_state = "pipe"
	density = FALSE
	layer = TABLE_LAYER
	plane = GAME_PLANE
	damage_deflection = 5
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	smeltresult = /obj/item/ingot/bronze
	var/togg = FALSE

/obj/structure/bars/pipe/left
	name = "bronze pipe"
	desc = ""
	icon_state = "pipe2"
	dir = WEST
	SET_BASE_PIXEL(19, 0)

//===========================

/obj/structure/fluff/clock
	name = "clock"
	desc = "An intricately-carved grandfather clock. On its pendulum is engraved the sigil of clan Kharzarad, a sickle behind an hourglass."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "clock"
	density = TRUE
	anchored = FALSE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 100
	integrity_failure = 0.5
	dir = SOUTH
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	var/datum/looping_sound/clockloop/soundloop
	drag_slowdown = 3
	metalizer_result = /obj/item/gear/metal/bronze

/obj/structure/fluff/clock/Initialize()
	. = ..()
	soundloop = new(src, FALSE)
	soundloop.start()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/clock/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()

/obj/structure/fluff/clock/atom_break(damage_flag)
	. = ..()
	icon_state = "b[initial(icon_state)]"
	if(soundloop)
		soundloop.stop()
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/structure/fluff/clock/atom_fix()
	. = ..()
	icon_state = initial(icon_state)
	soundloop.start()
	attacked_sound = initial(attacked_sound)

/obj/structure/fluff/clock/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.mind && isliving(user))
		if(user.mind.special_items && user.mind.special_items.len)
			var/item = browser_input_list(user, "What will I take?", "STASH", user.mind.special_items)
			if(item)
				if(user.Adjacent(src))
					if(user.mind.special_items[item])
						var/path2item = user.mind.special_items[item]
						user.mind.special_items -= item
						var/obj/item/I = new path2item(user.loc)
						user.put_in_hands(I)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/fluff/clock/examine(mob/user)
	. = ..()
	if(!obj_broken)
		var/day = "... actually, WHAT dae is it?"
		switch(GLOB.dayspassed)
			if(1)
				day = "Moon's dae"
			if(2)
				day = "Tiw's dae"
			if(3)
				day = "Wedding's dae"
			if(4)
				day = "Thule's dae"
			if(5)
				day = "Freyja's dae"
			if(6)
				day = "Saturn's dae"
			if(7)
				day = "Sun's dae"
		. += "Oh no, it's [station_time_timestamp("hh:mm")] on a [day]."
		// . += span_info("(Round Time: [gameTimestamp("hh:mm:ss", REALTIMEOFDAY - SSticker.round_start_irl)].)")

/obj/structure/fluff/clock/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, target) == dir)
		return
	return TRUE

/obj/structure/fluff/clock/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/clock/zizoclock
	desc = "It tells the time... in morbid fashion!"
	icon_state = "zizoclock"

// Version thats dense. Should honestly be standard?
/obj/structure/fluff/clock/dense
	density = TRUE

/obj/structure/fluff/wallclock
	name = "clock"
	desc = "A wall clock with the sickle and hourglass sigil of clan Kharzarad on its crown."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "wallclock"
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 100
	integrity_failure = 0.5
	var/datum/looping_sound/clockloop/soundloop
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	SET_BASE_PIXEL(0, 32)
	metalizer_result = /obj/item/gear/metal/bronze

/obj/structure/fluff/wallclock/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	return ..()

/obj/structure/fluff/wallclock/examine(mob/user)
	. = ..()
	if(!obj_broken)
		var/day = "... actually, WHAT dae is it?"
		switch(GLOB.dayspassed)
			if(1)
				day = "Moon's dae"
			if(2)
				day = "Tiw's dae"
			if(3)
				day = "Wedding's dae"
			if(4)
				day = "Thule's dae"
			if(5)
				day = "Freyja's dae"
			if(6)
				day = "Saturn's dae"
			if(7)
				day = "Sun's dae"
		. += "Oh no, it's [station_time_timestamp("hh:mm")] on a [day]."
		// . += span_info("(Round Time: [gameTimestamp("hh:mm:ss", REALTIMEOFDAY - SSticker.round_start_irl)].)")

/obj/structure/fluff/wallclock/Initialize()
	soundloop = new(src, FALSE)
	soundloop.start()
	. = ..()

/obj/structure/fluff/wallclock/atom_break(damage_flag)
	. = ..()
	icon_state = "b[initial(icon_state)]"
	if(soundloop)
		soundloop.stop()
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/structure/fluff/wallclock/atom_fix()
	. = ..()
	icon_state = initial(icon_state)
	soundloop.start()
	attacked_sound = initial(attacked_sound)

/obj/structure/fluff/wallclock/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fluff/wallclock/r
	SET_BASE_PIXEL(32, 0)

//vampire
/obj/structure/fluff/wallclock/vampire
	name = "ancient clock"
	desc = "This appears to be a clock, but a pair of red lights blink in a recess where the face ought to be."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "wallclockvampire"
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 100
	integrity_failure = 0.5
	SET_BASE_PIXEL(0, 32)

/obj/structure/fluff/wallclock/vampire/l
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fluff/wallclock/vampire/r
	SET_BASE_PIXEL(32, 0)

/obj/structure/fluff/signage
	name = "sign"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitsign"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 500
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/obj/structure/fluff/signage/examine(mob/user)
	. = ..()
	if(!user.is_literate())
		user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
		. += "I have no idea what it says."
	else
		. += "It says something."

/obj/structure/fluff/buysign
	icon_state = "signwrote"
	name = "sign"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
/obj/structure/fluff/buysign/examine(mob/user)
	. = ..()
	if(!user.is_literate())
		user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
		. += "I have no idea what it says."
	else
		. += "It says something."

/obj/structure/fluff/sellsign
	icon_state = "signwrote"
	name = "sign"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
/obj/structure/fluff/sellsign/examine(mob/user)
	. = ..()
	if(!user.is_literate())
		user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
		. += "I have no idea what it says."
	else
		. += "It says something."


/obj/structure/fluff/customsign
	name = "sign"
	desc = ""
	icon_state = "sign"
	var/wrotesign
	max_integrity = 500
	blade_dulling = DULLING_BASHCHOP
	icon = 'icons/roguetown/misc/structure.dmi'

/obj/structure/fluff/customsign/examine(mob/user)
	. = ..()
	if(wrotesign)
		if(!user.is_literate())
			user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
			. += "I have no idea what it says."
		else
			. += "It says \"[wrotesign]\"."

/obj/structure/fluff/customsign/attackby(obj/item/W, mob/user, list/modifiers)
	if(!user.cmode)
		if(!user.is_literate())
			to_chat(user, "<span class='warning'>I don't know any verba.</span>")
			return
		if(((user.used_intent.blade_class == BCLASS_STAB) || (user.used_intent.blade_class == BCLASS_CUT)) && (W.wlength == WLENGTH_SHORT))
			if(wrotesign)
				to_chat(user, "<span class='warning'>Something is already carved here.</span>")
			else
				var/inputty = stripped_input(user, "What would you like to carve here?", "", null, 200)
				if(inputty && !wrotesign)
					wrotesign = inputty
					icon_state = "signwrote"
			return
	..()

/obj/structure/fluff/statue
	name = "statue"
	desc = ""
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "bstatue"
	density = TRUE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	max_integrity = 300
	dir = SOUTH

/obj/structure/fluff/statue/Initialize()
	. = ..()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/statue/bullet_act(obj/projectile/P)
	. = ..()
	if(. != BULLET_ACT_FORCE_PIERCE)
		P.handle_drop()
		return BULLET_ACT_HIT

/obj/structure/fluff/statue/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.mind && isliving(user))
		if(user.mind.special_items && user.mind.special_items.len)
			var/item = browser_input_list(user, "What will I take?", "STASH", user.mind.special_items)
			if(item)
				if(user.Adjacent(src))
					if(user.mind.special_items[item])
						var/path2item = user.mind.special_items[item]
						user.mind.special_items -= item
						var/obj/item/I = new path2item(user.loc)
						user.put_in_hands(I)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/fluff/statue/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, target) == dir)
		return
	return TRUE

/obj/structure/fluff/statue/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/statue/gargoyle
	icon_state = "gargoyle"

/obj/structure/fluff/statue/gargoyle/candles
	icon_state = "gargoyle_candles"

/obj/structure/fluff/statue/gargoyle/moss
	icon_state = "mgargoyle"

/obj/structure/fluff/statue/gargoyle/moss/candles
	icon_state = "mgargoyle_candles"

/obj/structure/fluff/statue/knight
	icon_state = "knightstatue_l"

/obj/structure/fluff/statue/OnCrafted(dirin, mob/user)
	. = ..()
	for(var/obj/structure/fluff/statue/carving_block in contents)
		dir = carving_block.dir
		qdel(carving_block)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/fluff/statue/astrata
	name = "statue of Astrata"
	desc = "Astrata, the Sun Queen, reigns over light, order, and conquest. She is worshipped and feared in equal measure."
	icon = 'icons/roguetown/misc/tallandwide.dmi'
	icon_state = "astrata"
	max_integrity = 100 // You wanted descructible statues, you'll get them.
	deconstructible = FALSE
	density = TRUE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(-16, 0)

/obj/structure/fluff/statue/astrata/bling
	icon_state = "astrata_bling"

/obj/structure/fluff/statue/knight/r
	icon_state = "knightstatue_r"

/obj/structure/fluff/statue/knight/interior
	icon_state = "oknightstatue_l"

/obj/structure/fluff/statue/knight/interior/r
	icon_state = "oknightstatue_r"

/obj/structure/fluff/statue/knightalt
	icon_state = "knightstatue2_l"

/obj/structure/fluff/statue/knightalt/r
	icon_state = "knightstatue2_r"


/obj/structure/fluff/statue/myth
	icon_state = "myth"
	density = TRUE

/obj/structure/fluff/statue/psy
	icon_state = "psy"
	icon = 'icons/roguetown/misc/96x96.dmi'
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fluff/statue/small
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "elfs"

/obj/structure/fluff/statue/pillar
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pillar"

/obj/structure/fluff/statue/femalestatue
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "1"
	SET_BASE_PIXEL(-32, -16)

/obj/structure/fluff/statue/femalestatue/clean
	icon_state = "12"

/obj/structure/fluff/statue/femalestatue/alt
	icon_state = "2"

/obj/structure/fluff/statue/femalestatue/dancer
	icon_state = "4"

/obj/structure/fluff/statue/femalestatue/lying
	icon_state = "5"

/obj/structure/fluff/statue/femalestatue/cleanlying
	icon_state = "52"

/obj/structure/fluff/statue/musician
	icon = 'icons/roguetown/misc/ay.dmi'
	icon_state = "3"
	SET_BASE_PIXEL(-32, 0)

/obj/structure/fluff/statue/zizo
	name = "statue of Zizo"
	desc = "The Dark Lady. Even in stone, you feel unsettled looking at it."
	icon = 'icons/roguetown/misc/64x128.dmi'
	icon_state = "zizo"
	max_integrity = 100
	deconstructible = FALSE
	density = TRUE
	blade_dulling = DULLING_BASH
	bound_width = 64

/obj/structure/fluff/statue/zizo/Initialize()
	. = ..()
	set_light(1, 1, 1, l_color = COLOR_PURPLE)

/obj/structure/fluff/statue/musician/OnCrafted(dirin, mob/user)
	. = ..()
	if(prob(20))
		icon_state = "xylix"

/obj/structure/fluff/telescope
	name = "telescope"
	desc = "A mysterious telescope pointing towards the stars."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "telescope"
	density = TRUE
	anchored = FALSE

/obj/structure/fluff/telescope/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	to_chat(H,  span_notice("I look through the telescope, hoping to glimpse something beyond."))
	if(!do_after(H, 3 SECONDS, target = src))
		return

	var/random_message = rand(1,5)
	switch(random_message)
		if(1)
			to_chat(H,  span_notice("You can see Noc rotating."))
			if(do_after(H, 1 SECONDS, target = src))
				to_chat(H, span_good("Noc's glow seems to help clear your thoughts."))
				H.apply_status_effect(/datum/status_effect/buff/nocblessing)
				H.playsound_local(H, 'sound/misc/notice (2).ogg', 100, FALSE)
		if(2)
			to_chat(H, span_warning("Looking at Astrata blinds you"))
			if(do_after(H, 1 SECONDS, src)) // QUICK LOOK AWAY !!
				var/obj/item/bodypart/affecting = H.get_bodypart("head")
				to_chat(H, span_userdanger("The blinding light causes you intense pain!"))
				H.emote("scream", forced=TRUE)
				if(affecting && affecting.receive_damage(0, 10))
					H.update_damage_overlays()
		if(3)
			to_chat(H, span_notice("The stars smile at you."))
		if(4)
			to_chat(H, span_notice("Blessed yellow strife."))
		if(5)
			to_chat(H, span_notice("You see a star!"))

/obj/structure/fluff/stonecoffin
	name = "stone coffin"
	desc = "A damaged stone coffin..."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "stonecoffin"
	density = TRUE
	anchored = TRUE

/obj/structure/fluff/globe
	name = "globe"
	desc = "A model representing the known world of Psydonia."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "globe"
	density = TRUE
	anchored = FALSE

/obj/structure/fluff/globe/attack_hand(mob/user)
	if(!ishuman(user))
		return

	flick("globe1", src)
	var/mob/living/carbon/human/H = user
	var/random_message = pick(
	"You spin the globe!",
	"You land on Rockhill!",
	"You land on Vanderlin!",
	"You land on Heartfelt!",
	"You land on Zaladin!",
	"You land on Grenzelhoft!",
	"You land on Valoria!",
	"You land on Rosewood!",
	"You land on Wintermare!",
	"You land on Deshret!",
	"You land on Kingsfield",
	"You land on Amber Hollow!",
	"You land on the lands of Z!",
	"You land on the Fog Islands!")
	to_chat(H, "<span class='notice'>[random_message]</span>")

/obj/structure/fluff/statue/femalestatue/Initialize()
	. = ..()
	var/matrix/M = new
	M.Scale(0.7,0.7)
	src.transform = M

/obj/structure/fluff/statue/scare
	name = "scarecrow"
	desc = "An effigy made to drive away zad and other pesky birds from a farm."
	icon_state = "td"

/obj/structure/fluff/statue/tdummy
	name = "practice dummy"
	desc = "A wood and cloth dummy, made for squires to train with their armaments."
	icon_state = "p_dummy"
	icon = 'icons/roguetown/misc/structure.dmi'

/obj/structure/fluff/statue/tdummy/attackby(obj/item/W, mob/user, list/modifiers)
	if(!user.cmode)
		if(W.istrainable) // Prevents using dumb shit to train with. With temporary exceptions...
			if(W.associated_skill)
				if(user.mind && isliving(user))
					var/mob/living/L = user
					var/probby = (L.STALUC / 10) * 100
					probby = min(probby, 99)
					user.changeNext_move(CLICK_CD_MELEE)
					if(W.max_blade_int)
						W.remove_bintegrity(5, user)
					if(!L.adjust_stamina(rand(4,6)))
						if(ishuman(L))
							var/mob/living/carbon/human/H = L
							if(H.tiredness >= 50)
								H.apply_status_effect(/datum/status_effect/debuff/trainsleep)
						probby = 0
					if(L.body_position == LYING_DOWN)
						probby = 0
					if(L.STAINT < 3)
						probby = 0
					if(prob(probby) && !L.has_status_effect(/datum/status_effect/debuff/trainsleep) && !user.buckled)
						user.visible_message("<span class='info'>[user] trains on [src]!</span>")
						var/boon = user.get_learning_boon(W.associated_skill)
						var/amt2raise = L.STAINT/2
						if(user.get_skill_level(W.associated_skill) >= 2)
							if(!HAS_TRAIT(user, TRAIT_INTRAINING))
								to_chat(user, "<span class='warning'>I've learned all I can from doing this, it's time for the real thing.</span>")
								amt2raise = 0
							else
								if(user.get_skill_level(W.associated_skill) >= 3)
									to_chat(user, "<span class='warning'>I've learned all I can from doing this, it's time for the real thing.</span>")
									amt2raise = 0
						if(amt2raise > 0)
							user.adjust_experience(W.associated_skill, amt2raise * boon, FALSE)
						playsound(src,pick('sound/combat/hits/onwood/education1.ogg','sound/combat/hits/onwood/education2.ogg','sound/combat/hits/onwood/education3.ogg'), rand(50,100), FALSE)
					else
						user.visible_message("<span class='danger'>[user] trains on [src], but [src] ripostes!</span>")
						L.AdjustKnockdown(1)
						L.throw_at(get_step(L, get_dir(src,L)), 2, 2, L, spin = FALSE)
						playsound(src, 'sound/combat/hits/kick/stomp.ogg', 100, TRUE, -1)
					flick(pick("p_dummy_smashed","p_dummy_smashedalt"),src)
					return
			else //sanity
				to_chat(user, "<span class='warning'>This thing doesn't have a skill associated with it.</span>")
				return
		else // u dun goofed
			var/mob/living/goof = user
			user.visible_message("<span class='danger'>[user] awkwardly tries to hit \the [src] with \the [W], but \the [src] ripostes!</span>")
			goof.AdjustKnockdown(1)
			goof.throw_at(get_step(goof, get_dir(src,goof)), 2, 2, goof, spin = FALSE)
			playsound(src, 'sound/combat/hits/kick/stomp.ogg', 100, TRUE, -1)
			flick(pick("p_dummy_smashed","p_dummy_smashedalt"),src)
			return
	..()

//..................................................................................................................................
/*-------------------\
|  Shrines & Crosses |
\-------------------*/

/obj/structure/fluff/statue/spider
	name = "arachnid idol"
	desc = "A stone idol of a spider with the head of a smirking elven woman. Her eyes seem to follow you."
	icon_state = "spidercore"
	var/goal = 5
	var/current = 0
	var/objective = /obj/item/organ/ears

/obj/structure/fluff/statue/spider/examine(mob/user)
	. = ..()
	if(isdarkelf(user))
		say("BRING ME [goal - current] EARS. I HUNGER.",language = /datum/language/elvish)

/obj/structure/fluff/statue/spider/attackby(obj/item/W, mob/user, list/modifiers)
	if(istype(W, objective))
		if(user.mind)
			if(isdarkelf(user))
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				current += 1
				SSmapping.retainer.delf_ears += 1
				if(current >= goal)
					say("YOU HAVE DONE WELL, MY CHILD.",language = /datum/language/elvish)
					user.adjust_triumphs(1, reason = "Pleased the dark lady")

					qdel(src)
					// TODO : add crumbling message and sound
				else
					say("BRING ME [current - goal] MORE EARS. I HUNGER.",language = /datum/language/elvish)
				qdel(W)
				return TRUE
	..()

/obj/structure/fluff/statue/evil
	name = "idol"
	desc = "A statue built to the robber-god, Matthios. The visage resembles nobody in particular. It is said that he grants the wishes of those pagan bandits (free folk) who feed him money."
	icon_state = "evilidol"
	icon = 'icons/roguetown/misc/structure.dmi'

/obj/structure/fluff/statue/evil/attackby(obj/item/W, mob/user, list/modifiers)
	if(user.mind)
		var/datum/antagonist/bandit/B = user.mind.has_antag_datum(/datum/antagonist/bandit)
		if(B)
			if(B.tri_amt >= 8)
				to_chat(user, span_warning("The idol had collected enough tribute from you."))
				return
			if(istype(W, /obj/item/reagent_containers/lux))
				B.contrib += 120
				record_round_statistic(STATS_SHRINE_VALUE, 120)
			else if(istype(W, /obj/item/coin) || istype(W, /obj/item/gem) || istype(W, /obj/item/reagent_containers/glass/cup/silver) || istype(W, /obj/item/reagent_containers/glass/cup/golden) || istype(W, /obj/item/reagent_containers/glass/carafe) || istype(W, /obj/item/clothing/ring) || istype(W, /obj/item/clothing/head/crown/circlet) || istype(W, /obj/item/statue))
				if(!istype(W, /obj/item/coin))
					B.contrib += (W.get_real_price() / 2) // sell jewelry and other fineries, though at a lesser price compared to fencing them first
					record_round_statistic(STATS_SHRINE_VALUE, (W.get_real_price() / 2))
				else
					B.contrib += W.get_real_price()
					record_round_statistic(STATS_SHRINE_VALUE, W.get_real_price())
			else
				to_chat(user, span_warning("The idol doesn't want your garbage."))
				return
			if(B.contrib >= 80)
				give_rewards(B, user)
			else
				playsound(src,'sound/items/matidol1.ogg', 50, TRUE)
			playsound(src,'sound/misc/eat.ogg', rand(30, 60), TRUE)
			qdel(W)
			return

	return ..()

/obj/structure/fluff/statue/evil/proc/give_rewards(datum/antagonist/bandit/offering_bandit, mob/user)
	offering_bandit.tri_amt++
	user.mind.adjust_triumphs(1)
	offering_bandit.contrib -= 80

	var/obj/item/I
	switch(offering_bandit.tri_amt)
		if(1)
			I = new /obj/item/reagent_containers/glass/bottle/healthpot(user.loc)
		if(2)
			if(HAS_TRAIT(user, TRAIT_MEDIUMARMOR))
				I = new /obj/item/clothing/armor/medium/scale(user.loc)
			else
				I = new /obj/item/clothing/armor/chainmail/iron(user.loc)
		if(4)
			I = new /obj/item/clothing/head/helmet/horned(user.loc)
		if(6)
			if(user.get_skill_level(/datum/skill/combat/polearms) > 2)
				I = new /obj/item/weapon/polearm/spear/billhook(user.loc)
			else if(user.get_skill_level(/datum/skill/combat/bows) > 2)
				I = new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long(user.loc)
			else if(user.get_skill_level(/datum/skill/combat/swords) > 2)
				I = new /obj/item/weapon/sword/long(user.loc)
			else
				I = new /obj/item/weapon/mace/steel(user.loc)
		if(8)
			I = new /obj/item/clothing/pants/chainlegs(user.loc)
	if(I)
		I.sellprice = 0

	if(offering_bandit.contrib >= 100 && offering_bandit.tri_amt < 8)
		give_rewards(offering_bandit, user)
	else
		playsound(src,'sound/items/matidol2.ogg', 50, TRUE)

/obj/structure/fluff/psycross
	name = "pantheon cross"
	desc = "A towering monument to the Ten. Marriages are performed under its shadow."
	icon_state = "psycross"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	break_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	layer = BELOW_MOB_LAYER
	max_integrity = 100
	sellprice = 40
	buckleverb = "crucifie"
	can_buckle = 1
	buckle_lying = 0
	breakoutextra = 10 MINUTES
	dir = NORTH
	buckle_requires_restraints = 1
	buckle_prevents_pull = 1
	var/divine = TRUE

/obj/structure/fluff/psycross/Initialize()
	. = ..()
	become_hearing_sensitive()
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/fluff/psycross/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/structure/fluff/psycross/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 2)
	M.setDir(SOUTH)

/obj/structure/fluff/psycross/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

/obj/structure/fluff/psycross/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(get_dir(loc, mover) == dir)
		return
	return TRUE

/obj/structure/fluff/psycross/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/fluff/psycross/copper	// the big nice on in the Temple, destroying it triggers Omens. Not so for the craftable ones.
	name = "pantheon cross"
	icon_state = "psycrosschurch"
	break_sound = null
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")

/obj/structure/fluff/psycross/astrata
	name = "astratan cross"
	icon_state = "astratancross"
	desc = "A towering monument to Astrata. Those who stand beneath it feel the warmth of her light."
	break_sound = null
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")

/obj/structure/fluff/psycross/astrata/gold
	name = "astratan cross"
	icon_state = "astratancross_g"
	break_sound = null
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")

/obj/structure/fluff/psycross/zizocross
	name = "inverted cross"
	desc = "An unholy symbol. Blasphemy for most, reverence for few."
	icon_state = "zizoinvertedcross"
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	divine = FALSE

/obj/structure/fluff/psycross/crafted
	name = "wooden pantheon cross"
	icon_state = "psycrosscrafted"

/obj/structure/fluff/psycross/crafted/shrine
	plane = GAME_PLANE_UPPER
	layer = ABOVE_MOB_LAYER
	can_buckle = FALSE
	density = TRUE
	dir = SOUTH

/obj/structure/fluff/psycross/crafted/shrine/dendor_volf
	name = "devouring shrine to Dendor"
	desc = "The life force of a Volf has consecrated this holy place. \n First present two blood baits to craft a red sacrifice. \n Then offer an egg and two feathers to craft a crimson sacrifice."
	icon_state = "shrine_dendor_volf"

/obj/structure/fluff/psycross/crafted/shrine/dendor_saiga
	name = "stinging shrine to Dendor"
	desc = "The life force of a Saiga has consecrated this holy place. \n First present a jacksberry, westleach leaf, and eel to craft a yellow sacrifice. \n Then offer a jacksberry, calendula flower, and fiber to craft a citrine sacrifice."
	icon_state = "shrine_dendor_saiga"

/obj/structure/fluff/psycross/crafted/shrine/dendor_gote
	name = "growing shrine to Dendor"
	desc = "The life force of a Gote has consecrated this holy place. \n First present a poppy flower, swampweed leaf, and silk grub to craft a green sacrifice. \n Then offer a euphorbia flower, swampweed leaf, and two thorns to craft a viridian sacrifice."
	icon_state = "shrine_dendor_gote"

/obj/structure/fluff/psycross/crafted/shrine/dendor_troll
	name = "lording shrine to Dendor"
	desc = "The life force of a Troll has consecrated this holy place. \n First present two troll horns to craft a purple sacrifice. \n Then offer a piece of strange meat and two sinews to craft an indigo sacrifice."
	icon_state = "shrine_dendor_troll"

/obj/structure/fluff/psycross/psycrucifix
	name = "wooden psydonic crucifix"
	desc = "A rarely seen symbol of absolute and devoted certainty, more common in Grenzelhoft: HE yet lives. HE yet breathes."
	icon_state = "psycruci"
	max_integrity = 80

/obj/structure/fluff/psycross/psycrucifix/stone
	name = "stone psydonic crucifix"
	desc = "Formed of stone, this great Psycross symbolises that HE is forever ENDURING. Considered a rare sight upon the Peaks."
	icon_state = "psycruci_r"
	max_integrity = 120

/obj/structure/fluff/psycross/psycrucifix/silver
	name = "silver psydonic crucifix"
	icon_state = "psycruci_s"
	desc = "Constructed of Blessed Silver, this crucifix symbolises absolute faith in the ONE - For PSYDON WEEPS, for all mortal ilk. PSYDON WEEPS, for all who walk upon the soil. PSYDON WEEPS..."
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	max_integrity = 450

/obj/structure/fluff/psycross/attackby(obj/item/W, mob/living/carbon/human/user, list/modifiers)
	if(!user.mind)
		return ..()

	var/is_priest = is_priest_job(user.mind.assigned_role)
	var/is_eoran_acolyte = is_monk_job(user.mind.assigned_role) && (user.patron.type == /datum/patron/divine/eora)
	if(!is_priest && !is_eoran_acolyte && !HAS_TRAIT(user, TRAIT_SECRET_OFFICIANT))
		return ..()

	if(!istype(W, /obj/item/reagent_containers/food/snacks/produce/fruit/apple))
		return ..()

	var/obj/item/reagent_containers/food/snacks/produce/fruit/apple/apple = W
	if(length(apple.bitten_names) != 2)
		to_chat(user, span_warning("Apple must be bitten once by two different people to conduct a wedding ceremony!"))
		return FALSE

	var/in_church = istype(get_area(user), /area/indoors/town/church/chapel)
	var/secret_marriage = !in_church && HAS_TRAIT(user, TRAIT_SECRET_OFFICIANT)

	if(!in_church && !secret_marriage)
		to_chat(user, span_warning("I can conduct wedding ceremony only inside the chapel!"))
		return FALSE

	var/mob/living/carbon/human/groom
	var/mob/living/carbon/human/bride

	for(var/mob/living/carbon/human/candidate in range(5, src))
		if(groom && bride)
			break

		var/name_position = 1
		for(var/name in apple.bitten_names)
			if(candidate.real_name == name)
				switch(name_position)
					if(1)
						if(!groom)
							groom = candidate
					if(2)
						if(!bride)
							bride = candidate
			name_position++

	if(!groom || !bride)
		to_chat(user, span_warning("Either one or both soon to be wed are outside of the holy shrine's gaze!"))
		return FALSE
	if(user == groom || user == bride)
		to_chat(user, span_warning("You cannot conduct your own marriage ceremony!"))
		return FALSE

	// Groom checks
	if(groom.age == AGE_CHILD)
		to_chat(user, span_warning("[groom.real_name] is a child!"))
		return FALSE
	if(groom.stat == DEAD)
		to_chat(user, span_warning("[groom.real_name] is dead!"))
		return FALSE
	if(!groom.client)
		to_chat(user, span_warning("[groom.real_name] absent in spirit!"))
		return FALSE
	if(groom.IsWedded())
		to_chat(user, span_warning("[groom.real_name] is already married!"))
		return FALSE

	// Bride checks
	if(bride.age == AGE_CHILD)
		to_chat(user, span_warning("[bride.real_name] is a child!"))
		return FALSE
	if(bride.stat == DEAD)
		to_chat(user, span_warning("[bride.real_name] is dead!"))
		return FALSE
	if(!bride.client)
		to_chat(user, span_warning("[bride.real_name] absent in spirit!"))
		return FALSE
	if(bride.IsWedded())
		to_chat(user, span_warning("[bride.real_name] is already married!"))
		return FALSE

	groom.original_name = groom.real_name
	bride.original_name = bride.real_name

	var/surname
	var/groom_name_index = findlasttext(groom.real_name, " ")

	if(!groom_name_index)
		surname = " " + groom.dna.species.random_surname()
	else
		var/last_word = copytext(groom.real_name, groom_name_index + 1)
		var/second_last_index = findlasttext(groom.real_name, " ", 1, groom_name_index - 1)

		var/is_title = FALSE
		if(second_last_index)
			var/second_last_word = copytext(groom.real_name, second_last_index + 1, groom_name_index)
			if((lowertext(second_last_word) == "the" || lowertext(second_last_word) == "of") && last_word)
				is_title = TRUE

		if(is_title)
			var/surname_index = findlasttext(groom.real_name, " ", 1, second_last_index - 1)
			if(!surname_index)
				surname = " " + copytext(groom.real_name, 1, second_last_index)
				groom.change_name("")
			else
				surname = copytext(groom.real_name, surname_index, second_last_index)
				groom.change_name(copytext(groom.real_name, 1, surname_index))
		else if(findtext(groom.real_name, " the ") || findtext(groom.real_name, " of "))
			surname = " " + groom.dna.species.random_surname()
		else
			surname = copytext(groom.real_name, groom_name_index)
			groom.change_name(copytext(groom.real_name, 1, groom_name_index))

	var/bride_name_index = findlasttext(bride.real_name, " ")
	var/bride_first_name = bride.real_name

	if(bride_name_index)
		var/last_word_bride = copytext(bride.real_name, bride_name_index + 1)
		var/second_last_index_bride = findlasttext(bride.real_name, " ", 1, bride_name_index - 1)

		var/is_title_bride = FALSE
		if(second_last_index_bride)
			var/second_last_word_bride = copytext(bride.real_name, second_last_index_bride + 1, bride_name_index)
			if((lowertext(second_last_word_bride) == "the" || lowertext(second_last_word_bride) == "of") && last_word_bride)
				is_title_bride = TRUE

		if(!is_title_bride && !findtext(bride.real_name, " the ") && !findtext(bride.real_name, " of "))
			bride.change_name(copytext(bride.real_name, 1, bride_name_index))

		bride_first_name = bride.real_name

	groom.change_name(groom.real_name + surname)
	bride.change_name(bride.real_name + surname)

	groom.MarryTo(bride)
	groom.adjust_triumphs(1)
	bride.adjust_triumphs(1)

	if(!secret_marriage)
		var/announcement_message = "Eora [groom.gender == bride.gender ? "begrudgingly accepts" : "proudly embraces"] the marriage between [groom.real_name] and [bride_first_name]!"
		priority_announce(announcement_message, title = "Holy Union!", sound = 'sound/misc/bell.ogg')

	SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_MARRIAGE, groom, bride)
	record_round_statistic(STATS_MARRIAGES)
	qdel(apple)
	return TRUE

/obj/structure/fluff/psycross/copper/Destroy()
	addomen("psycross")
	return ..()

/obj/structure/fluff/psycross/proc/AOE_flash(mob/user, range = 15, power = 5, targeted = FALSE)
	var/list/mob/targets = get_flash_targets(get_turf(src), range, FALSE)
	for(var/mob/living/carbon/C in targets)
		flash_carbon(C, user, power, targeted, TRUE)
	return TRUE

/obj/structure/fluff/psycross/proc/get_flash_targets(atom/target_loc, range = 15)
	if(!target_loc)
		target_loc = loc
	if(isturf(target_loc) || (ismob(target_loc) && isturf(target_loc.loc)))
		return viewers(range, get_turf(target_loc))
	else
		return typecache_filter_list(target_loc.GetAllContents(), GLOB.typecache_living)

/obj/structure/fluff/psycross/proc/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "flashed(targeted)" : "flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "flashed(targeted)" : "flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, span_danger("[src] emits a blinding light!"))
	if(M.flash_act())
		M.set_confusion_if_lower(power SECONDS)

/obj/structure/fluff/psycross/psydon
	name = "psydonian cross"
	desc = "A wooden monument to Psydon. Let His name be naught but forgot'n."
	icon_state = "psydon_wooden_cross"
	icon = 'icons/roguetown/misc/psydon_cross.dmi'
	divine = FALSE //this variable to my understanding is only used to prevent zizo prayers. He's dead, so he can't do anything.

/obj/structure/fluff/psycross/psydon/metal
	desc = "A metal monument to Psydon. Let His name be naught but forgot'n."
	icon_state = "psydon_metal_cross"

//this one is meant to be uncraftable
/obj/structure/fluff/psycross/psydon/abandoned
	name = "overgrown psydonian cross"
	desc = "A decrepit monument to a dead god. Looking at it fills you with profound sadness."
	icon_state = "psydon_abandoned_cross"

/obj/structure/fluff/psycross/psydon/abandoned/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	if(istype(living_user.patron, /datum/patron/psydon))
		living_user.add_stress(/datum/stress_event/painful_reminder)
		. += " Never forget those we have lost."

/obj/structure/fluff/statue/shisha
	name = "shisha pipe"
	desc = "A traditional shisha pipe, this one is broken."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "zbuski"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	max_integrity = 300

//..................................................................................................................................
/*------------------------------------------------------------------------------------------------------------------------------------\
|  Gaffer shit, yes I'm making my own place here just for that and maaan its cozy, in this gated community for myself and no one else |
\------------------------------------------------------------------------------------------------------------------------------------*/

/obj/structure/fluff/statue/gaffer
	name = "Subdued Statue"
	icon_state = "subduedstatue"
	anchored = TRUE
	density = FALSE
	opacity = 0
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 999999
	deconstructible = FALSE
	var/ring_destroyed = FALSE

/obj/structure/fluff/statue/gaffer/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GAFFER_RING_DESTROYED, PROC_REF(ringdied))

/obj/structure/fluff/statue/gaffer/proc/ringdied(datum/source)
	SIGNAL_HANDLER
	if(ring_destroyed == FALSE)
		ring_destroyed = TRUE
		update_appearance(UPDATE_ICON_STATE)

/obj/structure/fluff/statue/gaffer/update_icon_state()
	. = ..()
	if(ring_destroyed == TRUE)
		icon_state = "subduedstatue_hasring"
	if(ring_destroyed == FALSE)
		icon_state = "subduedstatue"

/obj/structure/fluff/statue/gaffer/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_BURDEN))
		. += "slumped and tortured, broken body pertrified and in pain, its chest rose and fell in synch with mine banishing any doubt left, it is me! my own visage glares back at me!"
		user.add_stress(/datum/stress_event/ring_madness)
		return
	if(ring_destroyed == TRUE)
		. += "a statue depicting a decapitated man writhing in chains on the ground, it holds its hands out, pleading, in its palms is a glowing ring..."
		return
	. += "a statue depicting a decapitated man writhing in chains on the ground, it holds its hands out, pleading"

/obj/structure/fluff/statue/gaffer/attack_hand(mob/living/user)
	. = ..()
	if(!user.mind)
		return
	if(!ring_destroyed)
		return
	if(is_gaffer_assistant_job(user.mind?.assigned_role))
		to_chat(user, span_danger("It is not mine to have..."))
		return
	to_chat(user, span_danger("As you extend your hand over to the glowing ring, you feel a shiver go up your spine, as if unseen eyes turned to glare at you..."))
	var/gaffed = alert(user, "Will you bear the burden? (Be the next Gaffer)", "YOUR DESTINY", "Yes", "No")

	if(gaffed == "No" && ring_destroyed == TRUE)
		to_chat(user, span_danger("yes...best to leave it alone."))
		return

	if((gaffed == "Yes") && Adjacent(user) && ring_destroyed == TRUE)
		var/obj/item/ring = new /obj/item/clothing/ring/gold/burden(loc)
		ADD_TRAIT(user, TRAIT_BURDEN, type)
		user.put_in_hands(ring)
		user.equip_to_slot_if_possible(ring, ITEM_SLOT_RING, FALSE, FALSE, TRUE, TRUE)
		to_chat(user, span_danger("Once your hand is close enough to the ring, it jumps upwards and burrows itself onto your palm"))
		ring_destroyed = FALSE
		update_appearance(UPDATE_ICON_STATE)

/obj/structure/fluff/statue/knight/interior/gen/update_icon_state()
	if(dir == EAST)
		icon_state = "oknightstatue_l"
	else if(dir == WEST)
		icon_state = "oknightstatue_r"
	else
		icon_state = pick("oknightstatue_l", "oknightstatue_r")
	return ..()

/obj/structure/fluff/statue/knightalt/gen/update_icon_state()
	if(dir == EAST)
		icon_state = "knightstatue2_l"
	else if(dir == WEST)
		icon_state = "knightstatue2_r"
	else
		icon_state = pick("knightstatue2_l", "knightstatue2_r")
	return ..()

/obj/structure/fluff/statue/carving_block
	name = "carving block"
	desc = "Ready for sculpting."
	icon_state = "block"
	density = TRUE
	anchored = FALSE
	max_integrity = 100
	debris = list(/obj/item/natural/stoneblock = 1)
	drag_slowdown = 3

/obj/structure/fluff/statue/carving_block/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/structure/fluff/steamvent
	name = "steam vent"
	desc = "An underground heating pipe outlet."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "steam_vent"
	density = FALSE
	anchored = TRUE
	max_integrity = 300
	layer = 2.1

/obj/structure/fluff/steamvent/Initialize()
	. = ..()
	var/obj/effect/abstract/shared_particle_holder/steamvent_particle = add_shared_particles(/particles/smoke/cig/big, "steam_vent", pool_size = 4)
	steamvent_particle.particles.position = generator(GEN_BOX, list(-14, -14), list(14, 14))
