//Barricades/cover

/obj/structure/barricade
	name = "chest high wall"
	anchored = TRUE
	density = TRUE
	max_integrity = 100
	var/proj_pass_rate = 50 //How many projectiles will pass the cover. Lower means stronger cover

/obj/structure/barricade/CanAllowThrough(atom/movable/mover, turf/target)//So bullets will fly over and stuff.
	. = ..()
	if(locate(/obj/structure/barricade) in get_turf(mover))
		return TRUE
	else if(istype(mover, /obj/projectile))
		if(!anchored)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob(proj_pass_rate))
			return TRUE
		return FALSE

/////BARRICADE TYPES///////

/obj/structure/barricade/wooden
	name = "wooden barricade"
	icon = 'icons/obj/structures/barricade.dmi'
	icon_state = "barricade_wood"
	/// Amount of wood planks to drop
	var/drop_amount = 2

/obj/structure/barricade/wooden/atom_deconstruct(disassembled)
	new /obj/effect/decal/cleanable/debris/wood(loc)
	for(var/i in 1 to drop_amount)
		new /obj/item/natural/wood/plank(loc)

/obj/structure/barricade/wooden/crude
	name = "plank barricade"
	icon_state = "barricade_wood_plank"
	max_integrity = 60
	drop_amount = 1
