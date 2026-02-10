/* Tables and Racks
 * Contains:
 *		Tables
 *		Glass Tables
 *		Wooden Tables
 *		Reinforced Tables
 *		Racks
 *		Rack Parts
 */

/*
 * Tables
 */

/obj/structure/table
	name = "table"
	desc = ""
	//icon = 'icons/obj/smooth_structures/table.dmi'
	icon_state = "table"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	climbable = TRUE
	pass_flags_self = LETPASSTHROW|PASSTABLE
	var/frame
	var/framestack
	var/buildstack
	var/busy = FALSE
	var/buildstackamount = 1
	var/framestackamount = 2
	var/deconstruction_ready = 1
	max_integrity = 100
	integrity_failure = 0.33
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	blade_dulling = DULLING_BASHCHOP

/obj/structure/table/Initialize()
	. = ..()
	AddElement(/datum/element/footstep_override, priority = STEP_SOUND_TABLE_PRIORITY)

/obj/structure/table/update_icon()
	. = ..()
	if(smoothing_flags & SMOOTH_BITMASK)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/structure/table/narsie_act()
	var/atom/A = loc
	qdel(src)
	new /obj/structure/table/wood(A)

/obj/structure/table/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/table/attack_hand(mob/living/user)
	if(Adjacent(user) && user.pulling)
		if(isliving(user.pulling))
			var/mob/living/pushed_mob = user.pulling
			if(pushed_mob.buckled)
				to_chat(user, "<span class='warning'>[pushed_mob] is on [pushed_mob.buckled]!</span>")
				return
			if(user.used_intent.type == INTENT_GRAB)
				if(user.grab_state < GRAB_AGGRESSIVE)
					to_chat(user, "<span class='warning'>I need a better grip to do that!</span>")
					return
				if(user.grab_state >= GRAB_NECK)
					tableheadsmash(user, pushed_mob)
				else
					tablepush(user, pushed_mob)
			if(user.used_intent.type == INTENT_HELP)
				pushed_mob.visible_message("<span class='notice'>[user] begins to place [pushed_mob] onto [src]...</span>", \
									"<span class='danger'>[user] begins to place [pushed_mob] onto [src]...</span>")
				if(do_after(user, 3.5 SECONDS, pushed_mob))
					tableplace(user, pushed_mob)
				else
					return
			user.stop_pulling()
		else if(user.pulling.pass_flags & PASSTABLE)
			user.Move_Pulled(src)
			if (user.pulling.loc == loc)
				user.visible_message("<span class='notice'>[user] places [user.pulling] onto [src].</span>",
					"<span class='notice'>I place [user.pulling] onto [src].</span>")
				user.stop_pulling()
	return ..()

/obj/structure/table/proc/after_added_effects(obj/item/item, mob/user)

/obj/structure/table/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(.)
		return
	if(mover.throwing)
		return TRUE
	if(locate(/obj/structure/table) in get_turf(mover))
		return TRUE

/obj/structure/table/CanAStarPass(ID, dir, requester)
	. = !density
	if(ismovableatom(requester))
		var/atom/movable/mover = requester
		. = . || (mover.pass_flags & PASSTABLE)

/obj/structure/table/proc/tableplace(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(loc)
	pushed_mob.set_resting(TRUE, TRUE)
	pushed_mob.visible_message("<span class='notice'>[user] places [pushed_mob] onto [src].</span>", \
								"<span class='notice'>[user] places [pushed_mob] onto [src].</span>")
	log_combat(user, pushed_mob, "places", null, "onto [src]")

/obj/structure/table/proc/tablepush(mob/living/user, mob/living/pushed_mob)
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, "<span class='danger'>Throwing [pushed_mob] onto the table might hurt them!</span>")
		return
	var/added_passtable = FALSE
	if(!(pushed_mob.pass_flags & PASSTABLE))
		added_passtable = TRUE
		pushed_mob.pass_flags |= PASSTABLE
	pushed_mob.Move(src.loc)
	if(added_passtable)
		pushed_mob.pass_flags &= ~PASSTABLE
	if(pushed_mob.loc != loc) //Something prevented the tabling
		return
	pushed_mob.Knockdown(30)
	pushed_mob.apply_damage(10, BRUTE)
	pushed_mob.apply_damage(40, STAMINA)
	if(user.mind?.martial_art.smashes_tables && user.mind?.martial_art.can_use(user))
		deconstruct(FALSE)
	playsound(pushed_mob, "sound/effects/tableslam.ogg", 90, TRUE)
	pushed_mob.visible_message("<span class='danger'>[user] slams [pushed_mob] onto \the [src]!</span>", \
								"<span class='danger'>[user] slams you onto \the [src]!</span>")
	log_combat(user, pushed_mob, "tabled", null, "onto [src]")

/obj/structure/table/proc/tableheadsmash(mob/living/user, mob/living/pushed_mob)
	pushed_mob.Knockdown(30)
	pushed_mob.apply_damage(40, BRUTE, BODY_ZONE_HEAD)
	pushed_mob.apply_damage(60, STAMINA)
	take_damage(50)
	if(user.mind?.martial_art.smashes_tables && user.mind?.martial_art.can_use(user))
		deconstruct(FALSE)
	playsound(pushed_mob, "sound/effects/tableheadsmash.ogg", 90, TRUE)
	pushed_mob.visible_message("<span class='danger'>[user] smashes [pushed_mob]'s head against \the [src]!</span>",
								"<span class='danger'>[user] smashes your head against \the [src]</span>")
	log_combat(user, pushed_mob, "head slammed", null, "against [src]")
	pushed_mob.add_stress(/datum/stress_event/table_headsmash)

/obj/structure/table/attackby(obj/item/I, mob/user, list/modifiers)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(I.tool_behaviour == TOOL_SCREWDRIVER && deconstruction_ready)
			to_chat(user, "<span class='notice'>I start disassembling [src]...</span>")
			if(I.use_tool(src, user, 20, volume=50))
				deconstruct(TRUE)
			return

		if(I.tool_behaviour == TOOL_WRENCH && deconstruction_ready)
			to_chat(user, "<span class='notice'>I start deconstructing [src]...</span>")
			if(I.use_tool(src, user, 40, volume=50))
				playsound(src, 'sound/blank.ogg', 50, TRUE)
				deconstruct(TRUE, 1)
			return

	if(!user.cmode)
		if(!(I.item_flags & ABSTRACT))
			if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
				var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
				var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
				//Center the icon where the user clicked.
				if(!icon_x || !icon_y)
					return
				//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
				I.pixel_x = I.base_pixel_x + CLAMP(icon_x - 16, -(world.icon_size/2), world.icon_size/2)
				I.pixel_y = I.base_pixel_y + CLAMP(icon_y - 16, -(world.icon_size/2), world.icon_size/2)
				after_added_effects(I, user)
				return TRUE

	return ..()

/obj/structure/table/deconstruct(disassembled = TRUE, wrench_disassembly = 0)
	if(disassembled)
		if(!(flags_1 & NODECONSTRUCT_1))
			var/turf/T = get_turf(src)
			if(buildstack)
				new buildstack(T, buildstackamount)
			if(!wrench_disassembly)
				new frame(T)
			else
				new framestack(T, framestackamount)
	qdel(src)

/*
 * Wooden tables
 */

/obj/structure/table/wood
	name = "wooden table"
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "tablewood"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	debris = list(/obj/item/grown/log/tree/small = 1)
	climb_offset = 10

/obj/structure/table/wood/bar
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_1 = NODECONSTRUCT_1
	max_integrity = 1000

/obj/structure/table/wood/crafted
	icon_state = "tablewood1"

/obj/structure/table/church
	name = "stone table"
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "churchtable"
	max_integrity = 300
	climb_offset = 10
	debris = list(/obj/item/natural/stone = 1)

/obj/structure/table/church/m
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "churchtable_mid"

/obj/structure/table/stone_small
	name = "stone table"
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "stonetable_small"
	max_integrity = 300
	climb_offset = 10
	debris = list(/obj/item/natural/stone = 1)

/obj/structure/table/vtable
	name = "ancient wooden table"
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "vtable"
	max_integrity = 300
	climb_offset = 10
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/table/vtable/v2
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "vtable2"
	debris = list(/obj/item/grown/log/tree/small = 1)

/obj/structure/table/wood/counter
	name = "counter"
	icon_state = "longtable_mid"

/obj/structure/table/wood/counter/end
	icon_state = "longtable"

/obj/structure/table/wood/plain
	icon_state = "tablewood1"

/obj/structure/table/wood/plain/alt
	icon_state = "tablewood2"

/obj/structure/table/wood/plain/alto
	icon_state = "tablewood3"

/obj/structure/table/wood/reinforced
	name = "reinforced table"
	icon_state = "tablewood"

/obj/structure/table/wood/reinforced_alt
	icon_state = "tablewood_alt2"

/obj/structure/table/wood/large
	icon_state = "largetable_mid"

/obj/structure/table/wood/large/corner
	icon_state = "largetable"

/obj/structure/table/wood/large_alt
	icon_state = "largetable_mid_alt"

/obj/structure/table/wood/large/corner_alt
	icon_state = "largetable_alt"

/obj/structure/table/wood/large_blue
	icon_state = "largetable_mid_alt2"

/obj/structure/table/wood/large/corner_blue
	icon_state = "largetable_alt2"

/obj/structure/table/map
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "map_blank"
	desc = "A table which probably should have a map covering it."

/obj/structure/table/map/enigma
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "map_enigma"
	desc = "A table displaying a map of Enigma."

/obj/structure/table/map/vanderlin
	icon_state = "map_vanderlin"
	desc = "A table displaying a map of Vanderlin and Daftmarsh."

/obj/structure/table/map/rosewood
	icon_state = "map_rosewood"
	desc = "A table displaying a map of Rosewood and White Palace Pass."

/obj/structure/table/map/deshret
	icon_state = "map_deshret"
	desc = "A table displaying a map of Deshret and surrounding deserts."

/obj/structure/table/map/amber
	icon_state = "map_amber"
	desc = "A table displaying a map of Amber Hollow. Regardless of serene appearance, the threat of Zizo's Claw underneath never lessens."

/obj/structure/table/map/kingsfield
	icon_state = "map_kingsfield"
	desc = "A table displaying a map of the capital of Kingsfield."

/obj/structure/table/map/baotha
	icon_state = "map_baotha"
	desc = "A table displaying the lands surrounding the fallen kingdom of Azuria, doomed to ash."

/obj/structure/table/wood/fine
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "tablefine"
	resistance_flags = FLAMMABLE
	max_integrity = 40
	debris = list(/obj/item/grown/log/tree/small = 2)
	climb_offset = 10

/obj/structure/table/wood/nice
	icon = 'icons/roguetown/misc/tables.dmi'
	icon_state = "tablefine2"

/obj/structure/table/wood/fancy
	name = "fancy table"
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ

/obj/structure/table/wood/fancy/black
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_black.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_black"

/obj/structure/table/wood/fancy/blue
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_blue.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_blue"

/obj/structure/table/wood/fancy/cyan
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_cyan.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_cyan"

/obj/structure/table/wood/fancy/green
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_green.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_green"

/obj/structure/table/wood/fancy/orange
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_orange.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_orange"

/obj/structure/table/wood/fancy/purple
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_purple.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_purple"

/obj/structure/table/wood/fancy/red
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_red.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_red"

/obj/structure/table/wood/fancy/royalblack
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_royalblack.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_royalblack"

/obj/structure/table/wood/fancy/royalblue
	icon = MAP_SWITCH('icons/obj/smooth_structures/fancy_table_royalblue.dmi', 'icons/obj/structures.dmi')
	icon_state = "fancy_table_royalblue"

/*	..................   More tables   ................... */
/obj/structure/table/wood/reinf_long
	icon_state = "tablewood_reinf"

/obj/structure/table/wood/plain_alt
	icon_state = "tablewood_plain"

/obj/structure/table/wood/large_new
	icon_state = "alt_largetable_mid"
/obj/structure/table/wood/large/corner_new
	icon_state = "alt_largetable"

/obj/structure/table/wood/reinforced_alter
	icon_state = "tablewood_alt"

/obj/structure/table/wood/nice/decorated
	icon_state = "tablefine_alt"

/obj/structure/table/wood/nice/decorated_alt
	icon_state = "tablefine_alt2"

/*
 * Racks
 */

/obj/structure/rack
	name = "rack"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "rack"
	climbable = TRUE
	climb_offset = 10
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	pass_flags_self = LETPASSTHROW|PASSTABLE
	max_integrity = 40
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	blade_dulling = DULLING_BASHCHOP

/obj/structure/rack/CanAStarPass(ID, dir, requester)
	. = !density
	if(ismovableatom(requester))
		var/atom/movable/mover = requester
		. = . || (mover.pass_flags & PASSTABLE)

/obj/structure/rack/MouseDrop_T(obj/O, mob/user)
	. = ..()
	if ((!( istype(O, /obj/item) ) || user.get_active_held_item() != O))
		return
	if(!user.dropItemToGround(O))
		return
	if(O.loc != src.loc)
		step(O, get_dir(O, src))

/obj/structure/rack/attackby(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if (I.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1) && user.used_intent.type != INTENT_HELP)
		I.play_tool_sound(src)
		deconstruct(TRUE)
		return

	if(!user.cmode)
		if(!(I.item_flags & ABSTRACT))
			if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
				var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
				var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
				//Center the icon where the user clicked.
				if(!icon_x || !icon_y)
					return
				//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
				I.pixel_x = I.base_pixel_x + CLAMP(icon_x - 16, -(world.icon_size/2), world.icon_size/2)
				I.pixel_y = I.base_pixel_y + CLAMP(icon_y - 16, -(world.icon_size/2), world.icon_size/2)
				return 1

/obj/structure/rack/attack_paw(mob/living/user)
	attack_hand(user)


/obj/structure/rack/deconstruct(disassembled = TRUE)
	qdel(src)

/obj/structure/rack/underworld
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "rack_underworld"
	climbable = TRUE
	climb_offset = 10

/obj/structure/rack/shelf
	name = "shelf"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shelf"
	climbable = FALSE
	density = FALSE
	climb_offset = 0
	SET_BASE_PIXEL(0, 32)

/obj/structure/rack/shelf/big
	icon_state = "shelf_big"
	SET_BASE_PIXEL(0, 16)

/obj/structure/rack/shelf/biggest
	icon_state = "shelf_biggest"
	//this one is big enough it takes up the space of an entire tile, it should be dense
	climbable = TRUE
	density = TRUE
	SET_BASE_PIXEL(0, 0)

// Shelves have been made nondense. The only functional difference this has now is a lower pixel_y
/obj/structure/rack/shelf/notdense
	density = FALSE
	SET_BASE_PIXEL(0, 24)

// Necessary to avoid a critical bug with disappearing weapons.
/obj/structure/rack/attackby(obj/item/I, mob/user, list/modifiers)
	if(!user.cmode)
		if(!(I.item_flags & ABSTRACT))
			if(user.transferItemToLoc(I, drop_location(), silent = FALSE))
				var/icon_x = text2num(LAZYACCESS(modifiers, ICON_X))
				var/icon_y = text2num(LAZYACCESS(modifiers, ICON_Y))
				//Center the icon where the user clicked.
				if(!icon_x || !icon_y)
					return
				//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
				I.pixel_x = I.base_pixel_x + CLAMP(icon_x - 16, -(world.icon_size/2), world.icon_size/2)
				I.pixel_y = I.base_pixel_y + CLAMP(icon_y - 16, -(world.icon_size/2), world.icon_size/2)
				return 1
	else
		. = ..()


/obj/structure/table/optable
	name = "operating table"
	desc = ""
	icon = 'icons/obj/surgery.dmi'
	icon_state = "optable"
	can_buckle = 1
	buckle_lying = NO_BUCKLE_LYING
	buckle_requires_restraints = 1
	var/mob/living/carbon/human/patient = null

/obj/structure/table/optable/Initialize()
	. = ..()

/obj/structure/table/optable/tablepush(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(loc)
	pushed_mob.set_resting(TRUE, TRUE)
	visible_message("<span class='notice'>[user] has laid [pushed_mob] on [src].</span>")
	check_patient()

/obj/structure/table/optable/proc/check_patient()
	var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, loc)
	if(M)
		if(M.resting)
			patient = M
			return TRUE
	else
		patient = null
		return FALSE
