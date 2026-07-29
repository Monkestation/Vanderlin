/particles/hotspring_steam
	icon = 'icons/effects/particles/smoke.dmi'

	color = "#FFFFFF8A"
	count = 5
	spawning = 0.3
	lifespan = 3 SECONDS
	fade = 1.2 SECONDS
	fadein = 0.4 SECONDS
	position = generator(GEN_BOX, list(-17,-15,0), list(24,15,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	drift = generator(GEN_SPHERE, list(-0.01,0), list(0.01,0.01), UNIFORM_RAND)
	spin = generator(GEN_NUM, list(-2,2), NORMAL_RAND)
	gravity = list(0.05, 0.28)
	friction = 0.3
	grow = 0.037

/turf/open/water/hotspring
	name = "hot spring"
	desc = "Relaxing, hot water. What could be better?"
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring"
	gender = NEUTER
	turf_flags = TURF_NO_LIQUID_SPREAD
	shine = SHINE_MATTE
	no_over_text = TRUE

	smoothing_flags = NONE
	smoothing_groups = NONE
	smoothing_list = NONE

	bottle_spawner = FALSE
	uses_greyscale = FALSE

/turf/open/water/hotspring/Initialize(mapload)
	. = ..()
	var/obj/effect/abstract/shared_particle_holder/hotspring_steam = add_shared_particles(/particles/hotspring_steam, "hotspring", pool_size = 4)
	hotspring_steam.vis_flags &= ~VIS_INHERIT_PLANE

///these were unfortunately requested to not be smoothed. I will likely create a smooth helper version aswell though
///the issue is they would need at least a 2x2 to smooth proper.
/obj/structure/hotspring
	abstract_type = /obj/structure/hotspring
	name = /turf/open/water/hotspring::name
	desc = /turf/open/water/hotspring::desc
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring"
	plane = FLOOR_PLANE
	obj_flags = NONE
	resistance_flags = FIRE_PROOF|INDESTRUCTIBLE
	no_over_text = TRUE

	object_slowdown = 5

/obj/structure/hotspring/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/drinkable)

/obj/structure/hotspring/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!tool.reagents)
		return NONE

	if(!istype(user.used_intent, /datum/intent/fill))
		return NONE

	if(tool.reagents.holder_full())
		balloon_alert(user, "full!")
		return ITEM_INTERACT_BLOCKING

	if(!do_after(user, 8 DECISECONDS, src))
		return ITEM_INTERACT_BLOCKING

	user.changeNext_move(CLICK_CD_MELEE)
	playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
	tool.reagents.add_reagent(/datum/reagent/water, 100)
	balloon_alert(user, "[name] filled!")

	return ITEM_INTERACT_SUCCESS

/obj/structure/hotspring/border
	icon_state = "hotspring_border_1"

/obj/structure/hotspring/border/two
	icon_state = "hotspring_border_2"

/obj/structure/hotspring/border/three
	icon_state = "hotspring_border_3"
	object_slowdown = 0

/obj/structure/hotspring/border/four
	icon_state = "hotspring_border_4"

/obj/structure/hotspring/border/five
	icon_state = "hotspring_border_5"

/obj/structure/hotspring/border/six
	icon_state = "hotspring_border_6"

/obj/structure/hotspring/border/seven
	icon_state = "hotspring_border_7"

/obj/structure/hotspring/border/eight
	icon_state = "hotspring_border_8"

/obj/structure/hotspring/border/nine
	icon_state = "hotspring_border_9"

/obj/structure/hotspring/border/ten
	icon_state = "hotspring_border_10"

/obj/structure/hotspring/border/eleven
	icon_state = "hotspring_border_11"

/obj/structure/hotspring/border/twelve
	icon_state = "hotspring_border_12"

/obj/structure/hotspring/border/thirteen
	icon_state = "hotspring_border_13"
	object_slowdown = 0

/obj/structure/hotspring/border/fourteen
	icon_state = "hotspring_border_14"
	object_slowdown = 0

/obj/structure/flora/hotspring_rocks
	name = "large rock"
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "bigrock"
	obj_flags = CAN_BE_HIT | IGNORE_SINK
	density = TRUE

/obj/structure/flora/hotspring_rocks/grassy
	name = "grassy large rock"
	icon_state = "bigrock_grass"

/obj/structure/flora/hotspring_rocks/small
	name = "small rock"
	icon_state = "stones_1"
	density = FALSE

/obj/structure/flora/hotspring_rocks/small/two
	icon_state = "stones_2"

/obj/structure/flora/hotspring_rocks/small/three
	icon_state = "stones_3"

/obj/structure/flora/hotspring_rocks/small/four
	icon_state = "stones_4"

/obj/structure/flora/hotspring_rocks/small/five
	icon_state = "stones_5"

/obj/machinery/light/fueled/torchholder/hotspring
	name = "stone lantern"
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "stonelantern1"
	base_state = "stonelantern"
	shows_empty = FALSE

/obj/machinery/light/fueled/torchholder/hotspring/standing
	name = "standing stone lantern"
	icon_state = "stonelantern_standing1"
	base_state = "stonelantern_standing"

/obj/effect/lily_petal
	name = "lily petals"
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "lilypetals1"

/obj/effect/lily_petal/two
	icon_state = "lilypetals2"

/obj/effect/lily_petal/three
	icon_state = "lilypetals3"

/obj/structure/chair/hotspring_bench
	name = "park bench"
	icon_state = "parkbench_sofamiddle"
	icon = 'icons/obj/structures/hotspring.dmi'
	buildstackamount = 1
	item_chair = null
	anchored = TRUE

/obj/structure/chair/hotspring_bench/left
	icon_state = "parkbench_sofaend_left"

/obj/structure/chair/hotspring_bench/right
	icon_state = "parkbench_sofaend_right"

/obj/structure/chair/hotspring_bench/corner
	icon_state = "parkbench_corner"

/obj/structure/flora/sakura
	icon = 'icons/obj/structures/sakura_tree.dmi'
	icon_state = "sakura_tree"
	obj_flags = CAN_BE_HIT | IGNORE_SINK

	bound_height = 128
	bound_width = 128
