/obj/machinery/light/fueled/firebowl
	name = "brazier"
	icon = 'icons/roguetown/misc/lighting.dmi'
	icon_state = "stonefire1"
	density = TRUE
	base_state = "stonefire"
	climbable = TRUE
	pass_flags_self = LETPASSTHROW
	cookonme = TRUE
	dir = SOUTH
	crossfire = TRUE
	fueluse = 0

/obj/machinery/light/fueled/firebowl/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(on)
		var/mob/living/carbon/human/H = user

		if(istype(H))
			H.visible_message("<span class='info'>[H] warms \his hand over the fire.</span>")

			if(do_after(H, 1.5 SECONDS, src))
				// var/obj/item/bodypart/affecting = H.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
				// to_chat(H, "<span class='warning'>HOT!</span>")
				// if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
				// 	H.update_damage_overlays()
				H.adjust_bodytemperature(10)
		return TRUE //fires that are on always have this interaction with lmb unless its a torch

	else
		if(icon_state == "[base_state]over")
			user.visible_message("<span class='notice'>[user] starts to pick up [src]...</span>", \
				"<span class='notice'>I start to pick up [src]...</span>")
			if(do_after(user, 3 SECONDS, src))
				icon_state = "[base_state]0"
			return

/obj/machinery/light/fueled/firebowl/firebowlb
	icon_state = "stonefireb1"
	base_state = "stonefireb"
	bulb_colour = "#6cfdff"

/obj/machinery/light/fueled/firebowl/stump
	icon_state = "stumpfire1"
	base_state = "stumpfire"

/obj/machinery/light/fueled/firebowl/stumpb
	icon_state = "stumpfireb1"
	base_state = "stumpfireb"
	bulb_colour = "#6cfdff"

/obj/machinery/light/fueled/firebowl/stumpg
	icon_state = "stumpfireg1"
	base_state = "stumpfireg"
	bulb_colour = "#23b25a"

/obj/machinery/light/fueled/firebowl/blackfire
	desc = "A fire, black as death."
	icon_state = "blackfire1"
	base_state = "blackfire"
	bulb_colour = "#8468ff"

/obj/machinery/light/fueled/firebowl/church
	icon_state = "churchfire1"
	base_state = "churchfire"

/obj/machinery/light/fueled/firebowl/church/magic
	name = "magical bonfire"
	color = "#6ab2ee"
	bulb_colour = "#6ab2ee"
	max_integrity = 30

/obj/machinery/light/fueled/firebowl/church/unholyfire
	desc = "This fire burns yet it is cold..."
	icon_state = "unholyfire1"
	base_state = "unholyfire"
	bulb_colour = "#8468ff"

/obj/machinery/light/fueled/firebowl/standing
	name = "standing fire"
	icon_state = "standing1"
	base_state = "standing"
	bulb_colour = "#ff9e54"
	cookonme = FALSE
	crossfire = FALSE


/obj/machinery/light/fueled/firebowl/standing/blue
	bulb_colour = "#8468ff"
	icon_state = "standingb1"
	base_state = "standingb"

/obj/machinery/light/fueled/firebowl/standing/proc/knock_over() //use this later for jump impacts and shit
	icon_state = "[base_state]over"

/obj/machinery/light/fueled/firebowl/standing/fire_act(added, maxstacks)
	if(icon_state != "[base_state]over")
		..()

/obj/machinery/light/fueled/firebowl/standing/onkick(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(icon_state == "[base_state]over")
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks [src]!</span>", \
				"<span class='warning'>I kick [src]!</span>")
			return
		if(prob(L.STASTR * 8))
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks over [src]!</span>", \
				"<span class='warning'>I kick over [src]!</span>")
			burn_out()
			knock_over()
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks [src]!</span>", \
				"<span class='warning'>I kick [src]!</span>")

/obj/machinery/light/fueled/wallfire
	name = "fireplace"
	icon_state = "wallfire1"
	base_state = "wallfire"
	density = FALSE
	fueluse = 0
	crossfire = FALSE
	cookonme = TRUE
	temperature_change = 30

/obj/machinery/light/fueled/wallfire/candle
	name = "candles"
	icon_state = "wallcandle1"
	base_state = "wallcandle"
	bulb_colour = "#ffa35c"
	crossfire = FALSE
	cookonme = FALSE
	SET_BASE_PIXEL(0, 32)
	soundloop = null
	temperature_change = 0

/obj/machinery/light/fueled/wallfire/candle/OnCrafted(dirin, mob/user)
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
	switch(dirin)
		if(NORTH)
			pixel_y += 32
		if(SOUTH)
			pixel_y -= 32
		if(EAST)
			pixel_x += 32
		if(WEST)
			pixel_x -= 32
	return ..()

/obj/machinery/light/fueled/wallfire/candle/attack_hand(mob/user)
	if(isliving(user) && on)
		user.visible_message("<span class='warning'>[user] snuffs [src].</span>")
		burn_out()
		return TRUE //fires that are on always have this interaction with lmb unless its a torch
	. = ..()

/obj/machinery/light/fueled/wallfire/candle/r
	SET_BASE_PIXEL(32, 0)

/obj/machinery/light/fueled/wallfire/candle/l
	SET_BASE_PIXEL(-32, 0)

/obj/machinery/light/fueled/wallfire/candle/blue
	bulb_colour = "#8d73ff"
	icon_state = "wallcandleb1"
	base_state = "wallcandleb"

/obj/machinery/light/fueled/wallfire/candle/blue/extinguish()
	return FALSE

/obj/machinery/light/fueled/wallfire/candle/blue/burn_out()
	return FALSE

/obj/machinery/light/fueled/wallfire/candle/blue/r
	SET_BASE_PIXEL(32, 0)

/obj/machinery/light/fueled/wallfire/candle/blue/l
	SET_BASE_PIXEL(-32, 0)

/obj/machinery/light/fueled/wallfire/candle/skull
	bulb_colour = "#8d73ff"
	icon_state = "skullwallcandle1"
	base_state = "skullwallcandle"

/obj/machinery/light/fueled/wallfire/candle/skull/extinguish()
	return FALSE

/obj/machinery/light/fueled/wallfire/candle/skull/burn_out()
	return FALSE

/obj/machinery/light/fueled/wallfire/candle/skull/r
	SET_BASE_PIXEL(32, 0)

/obj/machinery/light/fueled/wallfire/candle/skull/l
	SET_BASE_PIXEL(-32, 0)

/obj/machinery/light/fueled/wallfire/candle/weak
	light_power = 0.9
	light_outer_range =  6

/obj/machinery/light/fueled/wallfire/candle/weak/l
	SET_BASE_PIXEL(-32, 0)

/obj/machinery/light/fueled/wallfire/candle/weak/r
	SET_BASE_PIXEL(32, 0)

/*	.............   Candle lamp   ................ */
/obj/machinery/light/fueled/wallfire/candle/lamp // cant get them to start unlit but they work as is
	name = "candle lamp"
	icon_state = "candle"
	base_state = "candle"
	layer = WALL_OBJ_LAYER+0.1
	light_power = 0.9
	light_outer_range =  6

/obj/machinery/light/fueled/torchholder
	name = "sconce"
	icon_state = "torchwall1"
	base_state = "torchwall"
	brightness = 5
	density = FALSE
	var/obj/item/flashlight/flare/torch/torchy = /obj/item/flashlight/flare/torch
	fueluse = FALSE //we use the torch's fuel
	soundloop = null
	crossfire = FALSE
	plane = GAME_PLANE_UPPER
	cookonme = FALSE
	temperature_change = 0
	fog_parter_effect = null
	var/shows_empty = TRUE

/obj/machinery/light/fueled/torchholder/c
	SET_BASE_PIXEL(0, 32)

/obj/machinery/light/fueled/torchholder/r
	dir = WEST

/obj/machinery/light/fueled/torchholder/l
	dir = EAST

/obj/machinery/light/fueled/torchholder/update_icon_state()
	. = ..()
	if(!shows_empty)
		return
	if(torchy)
		return
	icon_state = base_state

/obj/machinery/light/fueled/torchholder/seton(s)
	. = ..()
	if(!torchy || torchy.fuel <= 0)
		on = FALSE
		set_light_on(on)

/obj/machinery/light/fueled/torchholder/fire_act(added, maxstacks)
	if(torchy)
		if(!on)
			if(torchy.fuel > 0)
				torchy.spark_act()
				playsound(src, 'sound/items/firelight.ogg', 100)
				on = TRUE
				update()
				update_appearance(UPDATE_ICON_STATE)
				if(soundloop)
					soundloop.start()
				return TRUE

/obj/machinery/light/fueled/torchholder/Initialize()
	if(torchy)
		torchy = new torchy(src)
		torchy.spark_act()
	. = ..()

/obj/machinery/light/fueled/torchholder/Destroy()
	if(torchy)
		QDEL_NULL(torchy)
	return ..()

/obj/machinery/light/fueled/torchholder/OnCrafted(dirin, user)
	if(dir == SOUTH)
		pixel_y = base_pixel_y + 32
	QDEL_NULL(torchy)
	. = ..()

/obj/machinery/light/fueled/torchholder/process()
	if(on)
		if(torchy)
			if(torchy.fuel <= 0)
				burn_out()
			if(!torchy.on)
				burn_out()
		else
			return PROCESS_KILL

/obj/machinery/light/fueled/torchholder/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(torchy)
		if(!istype(user) || !Adjacent(user) || !user.put_in_active_hand(torchy))
			torchy.forceMove(loc)
		torchy = null
		on = FALSE
		update()
		update_appearance(UPDATE_ICON_STATE)
		playsound(src, 'sound/foley/torchfixturetake.ogg', 70)

/obj/machinery/light/fueled/torchholder/burn_out()
	if(torchy && torchy.on)
		torchy.turn_off()
	..()

/obj/machinery/light/fueled/torchholder/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(istype(W, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = W
		if(torchy)
			if(LR.on && !on)
				if(torchy.fuel <= 0)
					to_chat(user, "<span class='warning'>The mounted torch is burned out.</span>")
					return
				else
					torchy.spark_act()
					user.visible_message("<span class='info'>[user] lights [src].</span>")
					playsound(src, 'sound/items/firelight.ogg', 100)
					on = TRUE
					update()
					update_appearance(UPDATE_ICON_STATE)
					return
			if(!LR.on && on)
				if(LR.fuel > 0)
					LR.spark_act()
					user.visible_message("<span class='info'>[user] lights [LR] in [src].</span>")
					user.update_inv_hands()
		else
			if(LR.on)
				if(!user.transferItemToLoc(LR, src))
					return
				torchy = LR
				on = TRUE
				update()
				update_appearance(UPDATE_ICON_STATE)
			else
				if(!user.transferItemToLoc(LR, src))
					return
				torchy = LR
				update_appearance(UPDATE_ICON_STATE)
			playsound(src, 'sound/foley/torchfixtureput.ogg', 70)
		return
	. = ..()

/obj/machinery/light/fueled/torchholder/metal_torch
	torchy = /obj/item/flashlight/flare/torch/metal

/obj/machinery/light/fueled/torchholder/metal_torch/west
	dir = WEST

/obj/machinery/light/fueled/torchholder/metal_torch/east
	dir = EAST

/obj/machinery/light/fueled/torchholder/metal_torch/north
	dir = NORTH

/obj/machinery/light/fueled/chand
	name = "chandelier"
	icon_state = "chand1"
	base_state = "chand"
	icon = 'icons/roguetown/misc/tallwide.dmi'
	density = FALSE
	brightness = 10
	SET_BASE_PIXEL(-10, -10)
	layer = 2.0
	fueluse = 0
	soundloop = null
	crossfire = FALSE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP
	temperature_change = 5

/obj/machinery/light/fueled/chand/attack_hand(mob/user)
	if(isliving(user) && on)
		user.visible_message("<span class='warning'>[user] snuffs [src].</span>")
		burn_out()
		return TRUE //fires that are on always have this interaction with lmb unless its a torch
	. = ..()


/obj/machinery/light/fueled/hearth
	name = "hearth"
	icon_state = "hearth1"
	base_state = "hearth"
	density = TRUE
	anchored = TRUE
	climbable = TRUE
	climb_time = 3 SECONDS
	layer = TABLE_LAYER
	climb_offset = 14
	on = FALSE
	cookonme = TRUE
	soundloop = /datum/looping_sound/fireloop
	// temperature_change = 40
	var/heat_time = 100
	var/obj/item/attachment = null
	var/obj/item/reagent_containers/food/snacks/food = null
	var/rawegg = FALSE

/obj/machinery/light/fueled/hearth/Initialize()
	. = ..()

/obj/machinery/light/fueled/hearth/Destroy()
	. = ..()

/obj/machinery/light/fueled/hearth/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(!attachment)
		if(istype(W, /obj/item/cooking/pan) || istype(W, /obj/item/reagent_containers/glass/bucket/pot) || istype(W, /obj/item/reagent_containers/glass/carafe/teapot))
			playsound(user, 'sound/foley/dropsound/shovel_drop.ogg', 40, TRUE, -1)

			if(user.transferItemToLoc(W, src, silent = TRUE))
				attachment = W
				update_appearance(UPDATE_ICON_STATE | UPDATE_OVERLAYS)
			return

	else
		. = attachment.attackby(W, user, modifiers)
		if(.)
			return
	. = ..()

/obj/machinery/light/fueled/hearth/MouseDrop(mob/over, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(!istype(over))
		return

	if(attachment && over == usr && over.CanReach(src))
		SEND_SIGNAL(attachment, COMSIG_TRY_STORAGE_SHOW, over, TRUE)

//////////////////////////////////

/obj/machinery/light/fueled/hearth/fire_act(added, maxstacks)
	. = ..()
	if(food)
		playsound(src, 'sound/misc/frying.ogg', 80, FALSE, extrarange = 2)

/obj/machinery/light/fueled/hearth/update_overlays()
	. = ..()
	if(!attachment)
		return
	if(istype(attachment, /obj/item/cooking/pan) || istype(attachment, /obj/item/reagent_containers/glass/bucket/pot) || istype(attachment, /obj/item/reagent_containers/glass/carafe/teapot))
		var/obj/item/I = attachment
		I.pixel_x = I.base_pixel_x
		I.pixel_y = I.base_pixel_y
		. += new /mutable_appearance(I)
		if(!food)
			return
		I = food
		I.pixel_x = I.pixel_x
		I.pixel_y = I.pixel_y
		. += new /mutable_appearance(I)

/obj/machinery/light/fueled/hearth/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(attachment)
		if(!user.put_in_active_hand(attachment))
			attachment.forceMove(user.loc)
		attachment = null
		update_appearance(UPDATE_ICON_STATE | UPDATE_OVERLAYS)
	else
		if(on)
			var/mob/living/carbon/human/H = user
			if(istype(H))
				H.visible_message("<span class='info'>[H] warms \his hand over the embers.</span>")
				if(do_after(H, 5 SECONDS, src))
					H.adjust_bodytemperature(10)
			return TRUE


/obj/machinery/light/fueled/hearth/process()
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()
	if(on)
		if(initial(fueluse) > 0)
			if(fueluse > 0)
				fueluse = max(fueluse - 10, 0)
			if(fueluse == 0)
				burn_out()
		if(attachment?.reagents)
			attachment.reagents.expose_temperature(400, 0.04)
		update_appearance(UPDATE_OVERLAYS)

/obj/machinery/light/fueled/hearth/onkick(mob/user)
	if(isliving(user) && on)
		user.visible_message("<span class='warning'>[user] snuffs [src].</span>")
		burn_out()

/obj/machinery/light/fueled/campfire
	name = "campfire"
	icon_state = "badfire1"
	base_state = "badfire"
	density = FALSE
	layer = 2.8
	brightness = 5
	on = FALSE
	fueluse = 15 MINUTES
	bulb_colour = "#da5e21"
	cookonme = TRUE
	max_integrity = 30
	soundloop = /datum/looping_sound/fireloop

	temperature_change = 25

/obj/machinery/light/fueled/campfire/process()
	..()
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(IS_WET_OPEN_TURF(O))
			extinguish()

/obj/machinery/light/fueled/campfire/onkick(mob/user)
	if(isliving(user) && on)
		var/mob/living/L = user
		L.visible_message("<span class='info'>[L] snuffs [src].</span>")
		burn_out()

/obj/machinery/light/fueled/campfire/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(on)
		var/mob/living/carbon/human/H = user

		if(istype(H))
			H.visible_message("<span class='info'>[H] warms \his hand near the fire.</span>")

			if(do_after(H, 10 SECONDS, src))
				// var/obj/item/bodypart/affecting = H.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
				// to_chat(H, "<span class='warning'>HOT!</span>")
				// if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
				// 	H.update_damage_overlays()
				H.adjust_bodytemperature(10)
		return TRUE //fires that are on always have this interaction with lmb unless its a torch

/obj/machinery/light/fueled/campfire/densefire
	icon_state = "densefire1"
	base_state = "densefire"
	density = TRUE
	layer = 2.8
	brightness = 5
	climbable = TRUE
	on = FALSE
	fueluse = 30 MINUTES
	pass_flags_self = LETPASSTHROW
	bulb_colour = "#eea96a"
	max_integrity = 60

/obj/machinery/light/fueled/campfire/pyre
	name = "pyre"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "pyre1"
	base_state = "pyre"
	brightness = 10
	fueluse = 30 MINUTES
	layer = BELOW_MOB_LAYER
	buckleverb = "crucifie"
	can_buckle = 1
	buckle_lying = 0
	dir = NORTH
	buckle_requires_restraints = 1
	buckle_prevents_pull = 1


/obj/machinery/light/fueled/campfire/pyre/post_buckle_mob(mob/living/M)
	..()
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 10)
	M.setDir(SOUTH)

/obj/machinery/light/fueled/campfire/pyre/post_unbuckle_mob(mob/living/M)
	..()
	M.reset_offsets("bed_buckle")

/obj/machinery/light/fueled/campfire/longlived
	fueluse = 180 MINUTES
