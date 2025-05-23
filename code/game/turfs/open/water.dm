///////////// OVERLAY EFFECTS /////////////
/obj/effect/overlay/water
	icon = 'icons/turf/newwater.dmi'
	icon_state = "bottom"
	density = FALSE
	mouse_opacity = FALSE
	layer = MID_TURF_LAYER
	anchored = TRUE

/obj/effect/overlay/water/top
	icon_state = "top"
	layer = MID_TURF_LAYER

/turf/open/water
	gender = PLURAL
	name = "water"
	desc = "It's.. well, water."
	icon = 'icons/turf/newwater.dmi'
	icon_state = "together"
	baseturfs = /turf/open/water
	slowdown = 20
	turf_flags = NONE
	var/obj/effect/overlay/water/water_overlay
	var/obj/effect/overlay/water/top/water_top_overlay
	bullet_sizzle = TRUE
	bullet_bounce_sound = null //needs a splashing sound one day.
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_FLOOR_LIQUID
	smoothing_list = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_CLOSED + SMOOTH_GROUP_CLOSED_WALL
	neighborlay_self = "edge"
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null
	landsound = 'sound/foley/jumpland/waterland.wav'
	shine = SHINE_SHINY
	var/datum/reagent/water_reagent = /datum/reagent/water
	var/mapped = TRUE // infinite source of water
	var/water_volume = 100 // 100 is 1 bucket. Minimum of 10 to count as a water tile
	var/water_maximum = 10000 //this is since water is stored in the originate
	water_level = 2
	var/wash_in = TRUE
	var/swim_skill = FALSE
	nomouseover = FALSE
	var/swimdir = FALSE
	var/notake = FALSE // cant pick up with reagent containers
	var/set_relationships_on_init = TRUE
	var/list/blocked_flow_directions = list("2" = 0, "1" = 0, "8" = 0, "4" = 0)
	var/we_cut = FALSE
	var/childless = FALSE

	var/cached_use = 0

/turf/open/water/proc/set_watervolume(volume)
	water_volume = volume
	if(src in children)
		return
	update_icon()

	for(var/turf/open/water/river/water in children)
		water.set_watervolume(volume - 10)
		water.check_surrounding_water()
	check_surrounding_water()

/turf/open/water/proc/adjust_watervolume(volume)
	water_volume += volume
	update_icon()

	for(var/turf/open/water/river/water in children)
		water.adjust_watervolume(volume)
		water.check_surrounding_water()
	check_surrounding_water()

/turf/open/water/proc/adjust_originate_watervolume(volume)
	var/turf/open/water/adjuster = source_originate
	if(!adjuster)
		adjuster = src
	if(volume < 10 && mapped)
		if(adjuster.water_volume + volume < initial(adjuster.water_volume))
			return
	adjuster.water_volume += volume
	update_icon()
	if(adjuster.mapped) //means no changes downstream
		return
	for(var/turf/open/water/river/water in adjuster.children)
		water.adjust_watervolume(volume)
		water.check_surrounding_water()
	check_surrounding_water()

/turf/open/water/proc/toggle_block_state(dir, value)
	blocked_flow_directions["[dir]"] = value
	if(blocked_flow_directions["[dir]"])
		var/turf/open/water/river/water = get_step(src, dir)
		if(!istype(water))
			return
		if(water.mapped)
			return
		water.set_watervolume(0)
		water.check_surrounding_water()
		for(var/turf/open/water/child in children)
			addtimer(CALLBACK(child, PROC_REF(recursive_clear_icon)), 0.25 SECONDS)
		for(var/turf/open/water/conflict as anything in conflicting_originate_turfs)
			conflict.check_surrounding_water(TRUE)
	else
		check_surrounding_water()

/turf/open/water/proc/dryup(forced = FALSE)
	if(!forced && water_volume < 10)
		smoothing_flags = NONE
		remove_neighborlays()
		if(water_overlay)
			QDEL_NULL(water_overlay)
		if(water_top_overlay)
			QDEL_NULL(water_top_overlay)
		make_unshiny()
		var/mutable_appearance/dirty = mutable_appearance('icons/turf/floors.dmi', "dirt")
		add_overlay(dirty)
		for(var/obj/structure/waterwheel/rotator in contents)
			rotator.set_rotational_direction_and_speed(null, 0)
			rotator.set_stress_generation(0)

/turf/open/water/river/creatable
	mapped = FALSE
	river_processes = FALSE
	icon_state = "together"
	baseturfs = /turf/open/transparent/openspace

/turf/open/water/river/creatable/update_icon()
	if(water_volume < 10)
		dryup()
	else if(water_volume)
		if(!water_overlay)
			water_overlay = new(src)
		if(!water_top_overlay)
			water_top_overlay = new(src)
		if(!LAZYLEN(neighborlay_list))
			smoothing_flags = SMOOTH_EDGE
			QUEUE_SMOOTH(src)

	if(!river_processes)
		icon_state = "together"
		if(water_overlay)
			water_overlay.color = water_reagent.color
			water_overlay.icon_state = "bottom[water_level]"
		if(water_top_overlay)
			water_top_overlay.color = water_reagent.color
			water_top_overlay.icon_state = "top[water_level]"
		return
	icon_state = "rock"

	if(water_overlay)
		water_overlay.color = water_reagent.color
		water_overlay.icon_state = "riverbot"
		water_overlay.dir = dir
	if(water_top_overlay)
		water_top_overlay.color = water_reagent.color
		water_top_overlay.icon_state = "rivertop"
		water_top_overlay.dir = dir

/turf/open/water/river/creatable/Initialize()
	var/list/viable_directions = list()
	for(var/direction in GLOB.cardinals)
		var/turf/open/water/water = get_step(src, direction)
		if(!istype(water))
			continue
		viable_directions |= direction
	if(length(viable_directions) == 4 || length(viable_directions) == 0)
		return ..()
	river_processes = TRUE
	icon_state = "rock"
	var/picked_dir = pick(viable_directions)
	dir = GLOB.reverse_dir[picked_dir]
	update_icon()
	. = ..()

/turf/open/water/river/creatable/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/reagent_containers/glass/bucket/wooden) && user.used_intent.type == /datum/intent/splash)
		try_modify_water(user, C)
		return TRUE
	if(istype(C, /obj/item/weapon/shovel))
		if((user.used_intent.type == /datum/intent/shovelscoop))
			var/obj/item/weapon/shovel/shovel = C
			if(!shovel.heldclod)
				return
			user.visible_message("[user] starts filling in [src].", "I start filling in [src].")
			if(!do_after(user, 10 SECONDS * shovel.time_multiplier, src))
				return
			QDEL_NULL(shovel.heldclod)
			shovel.update_icon()
			ScrapeAway()
			return TRUE
	. = ..()

/turf/open/water/river/creatable/proc/try_modify_water(mob/user, obj/item/reagent_containers/glass/bucket/wooden/bucket)
	if(user.used_intent.type == /datum/intent/splash)
		if(bucket.reagents)
			var/datum/reagent/container_reagent = bucket.reagents.get_master_reagent()
			var/water_count = bucket.reagents.get_reagent_amount(container_reagent.type)
			user.visible_message("[user] starts to fill [src].", "You start to fill [src].")
			if(do_after(user, 3 SECONDS, src))
				if(bucket.reagents.remove_reagent(container_reagent.type, clamp(container_reagent.volume, 1, 100)))
					playsound(src, 'sound/foley/waterenter.ogg', 100, FALSE)
					adjust_originate_watervolume(water_count)

/turf/open/water/Initialize()
	. = ..()
	if(mapped)
		if(prob(0.1))
			new /obj/item/bottlemessage/ancient(src)
	else
		START_PROCESSING(SSobj, src)

	water_overlay = new(src)
	water_top_overlay = new(src)
	update_icon()
	return INITIALIZE_HINT_LATELOAD

/turf/open/water/LateInitialize()
	. = ..()
	if(!set_relationships_on_init)
		return
	check_surrounding_water()

/turf/open/water/process()
	if(cached_use)
		adjust_originate_watervolume(cached_use)
		cached_use = 0

	if(water_overlay && water_volume < 10)
		dryup()

/turf/open/water/update_icon()
	if(!water_volume || water_volume < 10)
		dryup()
		return
	if(!water_overlay)
		water_overlay = new()
	if(!water_top_overlay)
		water_top_overlay = new()
	if(!LAZYLEN(neighborlay_list))
		smoothing_flags = SMOOTH_EDGE
		QUEUE_SMOOTH(src)
	if(water_overlay)
		water_overlay.color = water_reagent.color
		water_overlay.icon_state = "bottom[water_level]"
	if(water_top_overlay)
		water_top_overlay.color = water_reagent.color
		water_top_overlay.icon_state = "top[water_level]"

/turf/open/water/add_neighborlay(dir, edgeicon, offset = FALSE)
	var/add
	var/y = 0
	var/x = 0
	switch(dir)
		if(NORTH)
			add = "[edgeicon]-n"
			y = -32
		if(SOUTH)
			add = "[edgeicon]-s"
			y = 32
		if(EAST)
			add = "[edgeicon]-e"
			x = -32
		if(WEST)
			add = "[edgeicon]-w"
			x = 32

	if(!add)
		return

	if(water_overlay)
		var/image/overlay = image(icon, water_overlay, add, ABOVE_MOB_LAYER + 0.01, pixel_x = offset ? x : 0, pixel_y = offset ? y : 0 )
		LAZYADDASSOC(water_overlay.neighborlay_list, "[dir]", overlay)
		water_overlay.add_overlay(overlay)

/turf/open/water/remove_neighborlays()
	var/list/overlays = water_overlay?.neighborlay_list
	if(!LAZYLEN(overlays))
		return
	for(var/key as anything in overlays)
		water_overlay.cut_overlay(overlays[key])
		QDEL_NULL(overlays[key])
		LAZYREMOVE(overlays, key)

/turf/open/water/Exited(atom/movable/AM, atom/newloc)
	. = ..()
	for(var/obj/structure/S in src)
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(water_overlay)
			if((get_dir(src, newloc) == SOUTH))
				water_overlay.layer = BELOW_MOB_LAYER
				water_overlay.plane = GAME_PLANE
			else
				spawn(6)
					if(!locate(/mob/living) in src)
						water_overlay.layer = BELOW_MOB_LAYER
						water_overlay.plane = GAME_PLANE
		for(var/D in GLOB.cardinals) //adjacent to a floor to hold onto
			if(istype(get_step(newloc, D), /turf/open/floor))
				return
		if(swim_skill)
			if(swimdir && newloc) //we're being pushed by water or swimming with the current, easy
				if(get_dir(src, newloc) == dir)
					return
			if(user.mind && !user.buckled)
				var/drained = max(15 - (user.get_skill_level(/datum/skill/misc/swimming) * 5), 1)
//				drained += (user.checkwornweight()*2)
				drained += user.get_encumbrance() * 50
				if(!user.adjust_stamina(drained))
					user.Immobilize(30)
					addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living, Knockdown), 30), 10)

/turf/open/water/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	..()
	playsound(src, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg','sound/foley/water_land3.ogg'), 100, FALSE)

/turf/open/water/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	for(var/obj/structure/S in src)
		if(S.obj_flags & BLOCK_Z_OUT_DOWN)
			return
	if(water_volume < 10)
		return
	if(istype(AM, /obj/item/reagent_containers/food/snacks/fish))
		var/obj/item/reagent_containers/food/snacks/fish/F = AM
		SEND_GLOBAL_SIGNAL(COMSIG_GLOBAL_FISH_RELEASED, F.type, F.rarity_rank)
		F.visible_message("<span class='warning'>[F] dives into \the [src] and disappears!</span>")
		qdel(F)
	if(isliving(AM) && !AM.throwing)
		var/mob/living/L = AM
		if(L.body_position == LYING_DOWN || water_level == 3)
			L.SoakMob(FULL_BODY)
		else
			if(water_level == 2)
				L.SoakMob(BELOW_CHEST)
		if(water_overlay)
			if(water_level > 1 && !istype(oldLoc, type))
				playsound(AM, 'sound/foley/waterenter.ogg', 100, FALSE)
			else
				playsound(AM, pick('sound/foley/watermove (1).ogg','sound/foley/watermove (2).ogg'), 100, FALSE)
			if(istype(oldLoc, type) && (get_dir(src, oldLoc) != SOUTH))
				water_overlay.layer = ABOVE_MOB_LAYER
				water_overlay.plane = GAME_PLANE_UPPER
			else
				spawn(6)
					if(AM.loc == src)
						water_overlay.layer = ABOVE_MOB_LAYER
						water_overlay.plane = GAME_PLANE_UPPER

/turf/open/water/attackby(obj/item/C, mob/user, params)
	if(user.used_intent.type == /datum/intent/fill)
		if(C.reagents)
			if(C.reagents.holder_full())
				to_chat(user, "<span class='warning'>[C] is full.</span>")
				return
			if(notake)
				return
			if(water_volume < 10)
				return
			if(do_after(user, 8 DECISECONDS, src))
				user.changeNext_move(CLICK_CD_MELEE)
				playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
				if(!mapped && C.reagents.add_reagent(water_reagent, 10))
					adjust_originate_watervolume(-10)

				else
					C.reagents.add_reagent(water_reagent, 100)
				to_chat(user, "<span class='notice'>I fill [C] from [src].</span>")
			return
	if(user.used_intent.type == /datum/intent/food)
		if(mapped)
			return
		if(C.reagents)
			if(water_volume >= water_maximum)
				to_chat(user, "<span class='warning'>\The [src] is full.</span>")
				return
			if(do_after(user, 8 DECISECONDS, src))
				user.changeNext_move(CLICK_CD_MELEE)
				playsound(user, 'sound/foley/drawwater.ogg', 100, FALSE)
				var/water_count = C.reagents.get_reagent_amount(water_reagent.type)
				if(!mapped && C.reagents.remove_reagent(water_reagent,  C.reagents.total_volume))
					set_watervolume(clamp(water_volume + water_count, 1, water_maximum))
				to_chat(user, "<span class='notice'>I pour the contents of [C] into [src].</span>")
			return
	. = ..()

/turf/open/water/attack_right(mob/user)
	if(water_volume < 10)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
		playsound(user, pick_n_take(wash), 100, FALSE)
		var/obj/item/item2wash = user.get_active_held_item()
		if(!item2wash)
			user.visible_message("<span class='info'>[user] starts to wash in [src].</span>")
			if(do_after(L, 3 SECONDS, src))
				if(wash_in)
					user.wash(CLEAN_WASH)
				var/datum/reagents/reagents = new()
				reagents.add_reagent(water_reagent, 4)
				reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = TOUCH)
				if(!mapped)
					adjust_originate_watervolume(-2)
				playsound(user, pick(wash), 100, FALSE)
		else
			user.visible_message("<span class='info'>[user] starts to wash [item2wash] in [src].</span>")
			if(do_after(L, 3 SECONDS, src))
				if(wash_in)
					item2wash.wash(CLEAN_WASH)
				playsound(user, pick(wash), 100, FALSE)
		return
	..()

/turf/open/water/onbite(mob/user)
	if(water_volume < 10)
		return
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.is_mouth_covered())
				return
		playsound(user, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		user.visible_message("<span class='info'>[user] starts to drink from [src].</span>")
		if(do_after(L, 2.5 SECONDS, src))
			var/datum/reagents/reagents = new()
			reagents.add_reagent(water_reagent, 2)
			reagents.trans_to(L, reagents.total_volume, transfered_by = user, method = INGEST)
			if(!mapped)
				adjust_originate_watervolume(-2)

			playsound(user,pick('sound/items/drink_gen (1).ogg','sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg'), 100, TRUE)
		return
	..()

/turf/open/water/Destroy()
	. = ..()
	dryup(forced = TRUE)

/turf/open/water/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	if(water_volume < 10)
		return
	if(isobj(AM))
		var/obj/O = AM
		O.extinguish()

/turf/open/water/get_slowdown(mob/user)
	if(water_volume < 10)
		return 0
	var/returned = slowdown
	if(user.mind && swim_skill)
		returned = returned - (user.get_skill_level(/datum/skill/misc/swimming))
	return returned
/*	..................   Bath & Pool   ................... */
/turf/open/water/bath
	name = "water"
	desc = "Faintly yellow colored. Suspicious."
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("bathtile", "bathtileW")
	water_level = 2
	slowdown = 15
	water_reagent = /datum/reagent/water

/turf/open/water/sewer
	name = "sewage"
	desc = "This dark water smells of dead rats."
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("paving", "pavingW")
	water_level = 1
	slowdown = 1
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/sewer
	footstep = FOOTSTEP_MUD
	barefootstep = FOOTSTEP_MUD
	heavyfootstep = FOOTSTEP_MUD

/turf/open/water/sewer/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/living = AM
		var/chance = 3
		if(living.m_intent == MOVE_INTENT_RUN)
			chance *= 2
		else if(living.m_intent == MOVE_INTENT_SNEAK)
			chance /= 2
		if(!prob(chance))
			return
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_R_LEG,BODY_ZONE_L_LEG)
			for(var/i = 1, i <= zonee.len, i++)
				var/obj/item/bodypart/BP = C.get_bodypart(pick_n_take(zonee))
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/datum/reagent/water/gross/sewer
	color = "#705a43"

/datum/reagent/water/gross/marshy
	color = "#60b17b"

/turf/open/water/swamp
	name = "murk"
	desc = "Weeds and algae cover the surface of the water."
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("dirt", "dirtW2")
	water_level = 2
	slowdown = 20
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/sewer

/turf/open/water/swamp/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/water/swamp/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/living = AM
		var/chance = 3
		if(living.m_intent == MOVE_INTENT_RUN)
			chance *= 2
		else if(living.m_intent == MOVE_INTENT_SNEAK)
			chance /= 2
		if(!prob(chance))
			return
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_R_LEG,BODY_ZONE_L_LEG)
			for(var/i = 1, i <= zonee.len, i++)
				var/obj/item/bodypart/BP = C.get_bodypart(pick_n_take(zonee))
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/swamp/deep
	name = "murk"
	desc = "Deep water with several weeds and algae on the surface."
	icon_state = MAP_SWITCH("dirt", "dirtW")
	water_level = 3
	slowdown = 20
	swim_skill = TRUE

/turf/open/water/swamp/deep/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/living = AM
		var/chance = 8
		if(living.m_intent == MOVE_INTENT_RUN)
			chance *= 2
		else if(living.m_intent == MOVE_INTENT_SNEAK)
			chance /= 2
		if(!prob(chance))
			return
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			if(C.blood_volume <= 0)
				return
			var/list/zonee = list(BODY_ZONE_CHEST,BODY_ZONE_R_LEG,BODY_ZONE_L_LEG,BODY_ZONE_R_ARM,BODY_ZONE_L_ARM)
			for(var/i = 1, i <= zonee.len, i++)
				var/obj/item/bodypart/BP = C.get_bodypart(pick_n_take(zonee))
				if(!BP)
					continue
				if(BP.skeletonized)
					continue
				var/obj/item/natural/worms/leech/I = new(C)
				BP.add_embedded_object(I, silent = TRUE)
				return .

/turf/open/water/marsh
	name = "marshwater"
	desc = "A heavy layer of weeds and algae cover the surface of the water."
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("dirt", "dirtW3")
	water_level = 2
	slowdown = 15
	wash_in = FALSE
	water_reagent = /datum/reagent/water/gross/marshy

/turf/open/water/marsh/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/water/marsh/deep
	name = "marshwater"
	desc = "A heavy layer of weeds and algae cover the surface of the deep water."
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("dirt", "dirtW4")
	water_level = 3
	slowdown = 20
	swim_skill = TRUE

/turf/open/water/cleanshallow
	name = "water"
	desc = "Clear and shallow water, what a blessing!"
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("rock", "rockw2")
	water_level = 2
	slowdown = 15
	water_reagent = /datum/reagent/water

/turf/open/water/cleanshallow/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()


/turf/open/water/cleanshallow/dirt
	name = "water"
	desc = "Clear and shallow water, mostly untainted by surrounding soil."
	icon_state = MAP_SWITCH("dirt", "dirtW5")

/turf/open/water/cleanshallow/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/water/blood
	name = "blood"
	desc = "A pool of sanguine liquid."
	icon = 'icons/turf/floors.dmi'
	icon_state = MAP_SWITCH("rock", "rockb")
	water_level = 2
	slowdown = 15
	water_reagent = /datum/reagent/blood

/turf/open/water/blood/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/water/river
	name = "water"
	desc = "Crystal clear water! Flowing swiflty along the river."
	icon_state = MAP_SWITCH("rocky", "rivermove-dir")
	icon = 'icons/turf/newwater.dmi'
	water_level = 3
	slowdown = 20
	swim_skill = TRUE
	var/river_processing
	var/river_processes = TRUE
	swimdir = TRUE
	set_relationships_on_init = FALSE

/turf/open/water/river/update_icon()
	if(water_volume < 10)
		dryup()
	else if(water_volume)
		if(!water_overlay)
			water_overlay = new(src)
		if(!water_top_overlay)
			water_top_overlay = new(src)
		if(!LAZYLEN(neighborlay_list))
			smoothing_flags = SMOOTH_EDGE
			QUEUE_SMOOTH(src)
	if(water_overlay)
		water_overlay.color = water_reagent.color
		water_overlay.icon_state = "riverbot"
		water_overlay.dir = dir
	if(water_top_overlay)
		water_top_overlay.color = water_reagent.color
		water_top_overlay.icon_state = "rivertop"
		water_top_overlay.dir = dir

/turf/open/water/river/get_heuristic_slowdown(mob/traverser, travel_dir)
	. = ..()
	if(travel_dir & dir) // downriver
		. -= 2 // faster!
	else // upriver
		. += 2 // slower

/turf/open/water/river/LateInitialize()
	. = ..()
	var/turf/open/water/river/water = get_step(src, dir)
	if(!istype(water))
		return
	if(water.parent?.water_volume > water_volume)
		return
	water.try_set_parent(src)

/turf/open/water/river/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(!river_processes)
		return
	if(isliving(AM) || isitem(AM))
		if(!river_processing)
			river_processing = addtimer(CALLBACK(src, PROC_REF(process_river)), 5, TIMER_STOPPABLE)

/turf/open/water/river/proc/process_river()
	river_processing = null
	if(water_volume < 10)
		return
	for(var/atom/movable/A in contents)
		for(var/obj/structure/S in src)
			if(S.obj_flags & BLOCK_Z_OUT_DOWN)
				return
		if((A.loc == src) && A.has_gravity())
			if(!istype(get_step(src, dir), /turf/open/water))
				var/list/viable_cardinals = list()
				var/inverse = GLOB.reverse_dir[dir]
				for(var/direction in GLOB.cardinals)
					if(direction == inverse)
						continue
					var/turf/open/water/water = get_step(src, direction)
					if(!istype(water))
						continue
					viable_cardinals |= direction
				if(length(viable_cardinals))
					A.ConveyorMove(pick(viable_cardinals))
			else
				A.ConveyorMove(dir)

/turf/open/water/river/dirt
	icon_state = MAP_SWITCH("dirty", "rivermovealt-dir")
	water_reagent = /datum/reagent/water/gross/sewer

/turf/open/water/river/blood
	icon_state = MAP_SWITCH("rocky", "rivermovealt2-dir")
	water_reagent = /datum/reagent/blood

/turf/open/water/acid // holy SHIT
	name = "acid pool"
	desc = "Well... how did THIS get here?"
	water_reagent = /datum/reagent/rogueacid

/turf/open/water/acid/mapped
	desc = "You know how this got here. You think."
	notake = TRUE
