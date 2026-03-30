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

///these were unfortunately requested to not be smoothed. I will likely create a smooth helper version aswell though
///the issue is they would need at least a 2x2 to smooth proper.
/obj/structure/hotspring
	abstract_type = /obj/structure/hotspring
	name = "hot spring"
	icon = 'icons/obj/structures/hotspring.dmi'
	icon_state = "hotspring"
	no_over_text = TRUE
	plane = FLOOR_PLANE
	object_slowdown = 5

	var/edge = FALSE

/obj/structure/hotspring/Initialize()
	. = ..()
	var/obj/effect/abstract/shared_particle_holder/hotspring_steam = add_shared_particles(/particles/hotspring_steam, "hotspring", pool_size = 4)
	//render the steam over mobs and objects on the game plane
	hotspring_steam.vis_flags &= ~VIS_INHERIT_PLANE

	var/turf/turf = get_turf(src)
	turf.turf_flags |= TURF_NO_LIQUID_SPREAD
	if(!edge)
		turf.path_weight += 100
		AddElement(/datum/element/mob_overlay_effect, 2, -2, 100)

/obj/structure/hotspring/attackby(obj/item/C, mob/user, list/modifiers) //This is all just taken from /turf/open/water, because it's meant to work basically the same way.
	if(user.used_intent.type == /datum/intent/fill)
		if(C.reagents)
			if(C.reagents.holder_full())
				to_chat(user, "<span class='warning'>[C] is full.</span>")
				return
			if(do_after(user, 8 DECISECONDS, src))
				user.changeNext_move(CLICK_CD_MELEE)
				playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
				C.reagents.add_reagent(/datum/reagent/water, 100)
				to_chat(user, "<span class='notice'>I fill [C] from [src].</span>")
			return
	. = ..()

/obj/structure/hotspring/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
	if(isliving(user))
		var/mob/living/L = user
		user.visible_message("<span class='info'>[user] starts to wash in [src].</span>")
		if(do_after(L, 3 SECONDS, src))
			user.wash(CLEAN_WASH)
			var/datum/reagents/reagents = new()
			reagents.add_reagent(/datum/reagent/water, 4)
			reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = TOUCH)
			playsound(user, pick(wash), 100, FALSE)
			user.add_stress(/datum/stress_event/bathwater)
			L.ExtinguishMob()
			//handle hygiene and clean off alcohol
			var/list/equipped_items = L.get_equipped_items()
			if(length(equipped_items) > 0)
				to_chat(user, span_notice("I could probably clean myself faster if I weren't wearing clothes..."))
				L.adjust_hygiene(HYGIENE_GAIN_CLOTHED * 5) //5 is the bonus you get for washing in baths. So this works the same, basically.
				L.adjust_fire_stacks(-4)
			else
				L.adjust_hygiene(HYGIENE_GAIN_UNCLOTHED * 5)
				L.adjust_fire_stacks(-2)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/hotspring/attackby_secondary(obj/item/item2wash, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.cmode)
		return
	var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
	playsound(user, pick_n_take(wash), 100, FALSE)
	user.visible_message("<span class='info'>[user] starts to wash [item2wash] in [src].</span>")
	if(do_after(user, 3 SECONDS, src))
		item2wash.wash(CLEAN_WASH)
		if(istype(item2wash, /obj/item/clothing))
			var/obj/item/clothing/item2wash_cloth = item2wash
			if(item2wash_cloth && item2wash_cloth.wetable)
				item2wash_cloth.wet.add_water(20, dirty = FALSE, washed_properly = TRUE)
		user.nobles_seen_servant_work()
		playsound(user, pick(wash), 100, FALSE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/hotspring/onbite(mob/living/user)
	. = ..()
	if(.)
		return
	playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
	user.visible_message(span_info("[user] starts to drink from [src]."))
	if(!do_after(user, 2.5 SECONDS, src))
		return TRUE
	var/datum/reagents/reagents = new()
	reagents.add_reagent(/datum/reagent/water, 2)
	reagents.trans_to(user, reagents.total_volume, transfered_by = user, method = INGEST)
	playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
	return TRUE

/obj/structure/hotspring/Destroy()
	var/turf/turf = get_turf(src)
	turf.turf_flags &= ~TURF_NO_LIQUID_SPREAD
	if(!edge)
		turf.path_weight -= 100
	. = ..()


/obj/structure/hotspring/Crossed(atom/movable/AM)
	. = ..()
	for(var/obj/structure/S in get_turf(src))
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return

	if(!edge)
		playsound(AM, pick('sound/foley/watermove (1).ogg','sound/foley/watermove (2).ogg'), 40, FALSE)

/obj/structure/hotspring/border
	icon_state = "hotspring_border_1"
	object_slowdown = 0
	edge = TRUE

/obj/structure/hotspring/border/two
	icon_state = "hotspring_border_2"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/three
	icon_state = "hotspring_border_3"
	object_slowdown = 0
	edge = TRUE

/obj/structure/hotspring/border/four
	icon_state = "hotspring_border_4"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/five
	icon_state = "hotspring_border_5"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/six
	icon_state = "hotspring_border_6"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/seven
	icon_state = "hotspring_border_7"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/eight
	icon_state = "hotspring_border_8"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/nine
	icon_state = "hotspring_border_9"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/ten
	icon_state = "hotspring_border_10"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/eleven
	icon_state = "hotspring_border_11"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/twelve
	icon_state = "hotspring_border_12"
	object_slowdown = 5
	edge = FALSE

/obj/structure/hotspring/border/thirteen
	icon_state = "hotspring_border_13"
	object_slowdown = 0
	edge = TRUE

/obj/structure/hotspring/border/fourteen
	icon_state = "hotspring_border_14"
	object_slowdown = 0
	edge = TRUE

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
	density = FALSE
	icon_state = "stones_1"

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
