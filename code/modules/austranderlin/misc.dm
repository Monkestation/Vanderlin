
/// spongebob - please for the love of fuck do not use this for any actual mapping purposes
/obj/item/painting/the_bob
	icon_state = "spongebob"
	desc = "The servant of the month for the past 30 consecutive months. It is a priceless work of art."
	sellprice = 808 //BOB
	deployed_structure = /obj/structure/fluff/walldeco/painting/the_bob

/obj/structure/fluff/walldeco/painting/the_bob
	desc = "The servant of the month for the past 30 consecutive months. It is a priceless work of art."
	icon_state = "spongebob_deployed"
	stolen_painting = /obj/item/painting/the_bob


/// tiles that zip you to the top z level of vanderlin
/turf/open/dungeon_trap/australia
	name = "deep abyss"
	desc = "It's a long way up..."
	icon_state = "undervoid2"
	color = null
	smoothing_flags = NONE
	smoothing_groups = NONE
	smoothing_list = null
	neighborlay_self = null
	dynamic_lighting = FALSE

/turf/open/dungeon_trap/australia/can_zFall(atom/movable/A, levels = 1, turf/target)
	return zPassOut(A, DOWN, target) && target.zPassIn(A, DOWN, src)

/turf/open/dungeon_trap/australia/zFall(atom/movable/A, levels = 1, force = FALSE)
	if(!isobj(A) && !ismob(A))
		return FALSE
	var/turf/target = get_australia_tile()
	if(!target)
		return FALSE
	levels += 5
	if(!force && (!can_zFall(A, levels, target) || !A.can_zFall(src, levels, target, DOWN)))
		return FALSE
	A.atom_flags |= Z_FALLING
	A.forceMove(target)
	A.atom_flags &= ~Z_FALLING
	target.zImpact(A, levels, src)
	return TRUE

/proc/get_australia_tile()
	var/list/levels = SSmapping.levels_by_trait(ZTRAIT_TOWN)
	if(!length(levels))
		return
	var/list/australia_turfs = Z_TURFS(levels[length(levels)])
	var/turf/open/chosen_turf
	while(!chosen_turf && length(australia_turfs))
		var/turf/T = pick_n_take(australia_turfs)
		if(isopenturf(T))
			chosen_turf = T
		// no chosen_turf this step so don't bother with the parts after this
		if(isclosedturf(chosen_turf) || isopenspace(chosen_turf)) // don't put us in walls or falls
			continue
		// check if our chosen_turf actually works
		for(var/obj/structure/struct in chosen_turf)
			if(struct.density && !struct.climbable) // keeps you from landing inside bars or something
				chosen_turf = null // ineligible
				break
	return chosen_turf


/// Piss
/turf/open/water/river/sewer
	desc = "Piss-laden water! Flowing swiftly along the river."
	icon_state = MAP_SWITCH("paving", "rivermovealt-dir")
	base_icon_state = "paving"
	water_reagent = /datum/reagent/water/gross/sewer
	cleanliness_factor = -5
	slowdown = 5
	water_height = WATER_HEIGHT_ANKLE
	//water_level = 2
	slowdown = 5
	flow_speed = 1 SECONDS

/turf/open/water/river/sewer/roofflow
	icon_state = MAP_SWITCH("roof", "rivermovealt-dir")
	base_icon_state = "roof"

/turf/open/water/river/sewer/floorflow
	icon_state = MAP_SWITCH("wooden_floort", "rivermovealt-dir")
	base_icon_state = "wooden_floort"


///random placed items
/obj/item/clothing/shirt/robe/colored/sundweller
	color = CLOTHING_MUSTARD_YELLOW

/obj/item/clothing/head/roguehood/colored/sundweller
	color = CLOTHING_MUSTARD_YELLOW

/obj/item/clothing/cloak/heartfelt/shit
	name = "shitstained cloak"
	desc = "You are the lord of this shithouse."
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/priesthat/sunlord
	name = "piss-soaked hat"
	desc = "The sacred headpiece of the Sunlord."

/obj/item/carvedgem/amber/duck/sunduck
	name = "sunduck"
	sellprice = 0
	desc = "Quack! Quack!"


/obj/structure/kybraxor/smol
	pixel_x = -32
	pixel_y = -32
	vol = 20

/obj/structure/kybraxor/smol/Initialize()
	. = ..()
	transform = transform.Scale(1 / 3)
