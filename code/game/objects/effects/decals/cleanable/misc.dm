/obj/effect/decal/cleanable/generic
	name = "clutter"
	desc = ""
	icon = 'icons/obj/objects.dmi'
	icon_state = "shards"
	beauty = -50

/obj/effect/decal/cleanable/ash
	name = "ashes"
	desc = ""
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"
	mergeable_decal = FALSE
	beauty = -50

/obj/effect/decal/cleanable/ash/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ash, 30)
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/effect/decal/cleanable/ash/crematorium
//crematoriums need their own ash cause default ash deletes itself if created in an obj
	turf_loc_check = FALSE

/obj/effect/decal/cleanable/ash/large
	name = "large pile of ashes"
	icon_state = "big_ash"
	beauty = -100

/obj/effect/decal/cleanable/ash/large/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ash, 30) //double the amount of ash.

// For Stonekeep Undead Alchemy
/obj/effect/decal/cleanable/undeadash
	name = "glimmering ashes"
	desc = ""
	icon = 'icons/obj/objects.dmi'
	icon_state = "special_ash"
	mergeable_decal = FALSE

/obj/effect/decal/cleanable/undeadash/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/undeadash, 20)

/obj/effect/decal/cleanable/dirt
	name = "dirt"
	desc = ""
	icon_state = "dirt"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -75

/obj/effect/decal/cleanable/dirt/Destroy()
	return ..()

/obj/effect/decal/cleanable/dirt/dust
	name = "dust"
	desc = ""

/obj/effect/decal/cleanable/greenglow
	name = "glowing goo"
	desc = ""
	icon_state = "greenglow"
	light_power = 3
	light_outer_range =  2
	light_color = LIGHT_COLOR_GREEN
	beauty = -300

/obj/effect/decal/cleanable/greenglow/ex_act()
	return

/obj/effect/decal/cleanable/dirt/cobweb
	name = "cobweb"
	desc = ""
	icon = 'icons/roguetown/misc/webbing.dmi'
	icon_state = "cobweb1"
	gender = NEUTER
	layer = WALL_OBJ_LAYER
	plane = -1
	resistance_flags = FLAMMABLE
	beauty = -100
	alpha = 200

/obj/effect/decal/cleanable/dirt/cobweb/cobweb2
	icon_state = "cobweb2"

/obj/effect/decal/cleanable/molten_object
	name = "gooey grey mass"
	desc = ""
	gender = NEUTER
	icon = 'icons/effects/effects.dmi'
	icon_state = "molten"
	mergeable_decal = FALSE
	beauty = -150

/obj/effect/decal/cleanable/molten_object/large
	name = "big gooey grey mass"
	icon_state = "big_molten"
	beauty = -300

//Vomit (sorry)
/obj/effect/decal/cleanable/vomit
	name = "vomit"
	desc = ""
	icon = 'icons/effects/blood.dmi'
	icon_state = "vomit_1"
	random_icon_states = list("vomit_1", "vomit_2", "vomit_3", "vomit_4")
	beauty = -150
	alpha = 160
	clean_type = CLEAN_TYPE_LIGHT_DECAL

/obj/effect/decal/cleanable/vomit/old
	name = "dried vomit"
	desc = ""
	clean_type = CLEAN_TYPE_HARD_DECAL

/obj/effect/decal/cleanable/vomit/old/Initialize(mapload)
	. = ..()
	icon_state += "-old"

/obj/effect/decal/cleanable/chem_pile
	name = "chemical pile"
	desc = ""
	gender = NEUTER
	icon = 'icons/obj/objects.dmi'
	icon_state = "ash"

/obj/effect/decal/cleanable/shreds
	name = "shreds"
	desc = ""
	icon_state = "shreds"
	gender = PLURAL
	mergeable_decal = FALSE

/obj/effect/decal/cleanable/shreds/ex_act(severity, target)
	if(severity == 1) //so shreds created during an explosion aren't deleted by the explosion.
		qdel(src)

/obj/effect/decal/cleanable/shreds/Initialize(mapload, oldname)
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
	if(!isnull(oldname))
		desc = ""
	. = ..()

/obj/effect/decal/cleanable/shreds/clay
	color = "#916258"

/obj/effect/decal/cleanable/glitter
	name = "generic glitter pile"
	desc = ""
	icon = 'icons/effects/atmospherics.dmi'
	icon_state = "plasma_old"
	gender = NEUTER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/cleanable/glitter/pink
	name = "pink glitter"
	icon_state = "plasma"

/obj/effect/decal/cleanable/glitter/white
	name = "white glitter"
	icon_state = "nitrous_oxide"

/obj/effect/decal/cleanable/glitter/blue
	name = "blue glitter"
	icon_state = "freon"

/obj/effect/decal/cleanable/plasma
	name = "stabilized plasma"
	desc = ""
	icon_state = "flour"
	icon = 'icons/effects/tomatodecal.dmi'
	color = "#2D2D2D"

/obj/effect/decal/cleanable/insectguts
	name = "insect guts"
	desc = ""
	icon = 'icons/effects/blood.dmi'
	icon_state = "xfloor1"
	random_icon_states = list("xfloor1", "xfloor2", "xfloor3", "xfloor4", "xfloor5", "xfloor6", "xfloor7")
	clean_type = CLEAN_TYPE_BLOOD

/*	.................   Dye spill   ................... */
/obj/effect/decal/cleanable/dyes
	name = "spilled dyes"
	icon = 'icons/effects/tomatodecal.dmi'
	icon_state = "flour"
	random_icon_states = list("flour", "smashed_plant")
	beauty = -100
	clean_type = CLEAN_TYPE_LIGHT_DECAL
/obj/effect/decal/cleanable/dyes/Initialize()
	color = pick(CLOTHING_ROYAL_TEAL, CLOTHING_BOG_GREEN, CLOTHING_ROYAL_PURPLE	)
	..()

//................	Debris decals (result from crafting or destroying items thats just visual)	............... //
/obj/effect/decal/cleanable/debris
	name = ""
	desc = ""
	icon = 'icons/obj/objects.dmi'
	beauty = -20

/obj/effect/decal/cleanable/debris/Initialize()
	. = ..()
	setDir(pick(GLOB.cardinals))

/obj/effect/decal/cleanable/debris/glass
	name = "glass shards"
	icon = 'icons/obj/shards.dmi'
	icon_state = "tiny"
	beauty = -100

/obj/effect/decal/cleanable/debris/glass/Crossed(mob/living/L)
	. = ..()
	playsound(loc,'sound/foley/glass_step.ogg', 50, FALSE)

/obj/effect/decal/cleanable/debris/stone
	name = "stone chippings"
	icon_state = "pebbly"

/obj/effect/decal/cleanable/debris/wood	// sawdust gets cleared by weather
	name = "sawdust"
	icon_state = "woody"

/obj/effect/decal/cleanable/debris/wood/Initialize()
	. = ..()
	GLOB.weather_act_upon_list += src

/obj/effect/decal/cleanable/debris/wood/Destroy()
	. = ..()
	GLOB.weather_act_upon_list -= src

/obj/effect/decal/cleanable/debris/wood/weather_act_on(weather_trait, severity)
	qdel(src)
