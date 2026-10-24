#define WAYSTONE_ENTRY_WINDOW (30 SECONDS)
#define WAYSTONE_EXIT_WINDOW (60 SECONDS)

GLOBAL_LIST_EMPTY(surface_waystones)

/obj/structure/waystone
	name = "waystone"
	desc = "A standing stone humming with quiet power. Touch it and it will carry you into the depths."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "waystone"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE

	/// How long the stone stays open after being activated (set per type below)
	var/open_duration = WAYSTONE_ENTRY_WINDOW
	/// world.time at which the gate closes. 0 = closed.
	var/open_until = 0
	/// The stone people who follow through the open gate will arrive at
	var/obj/structure/waystone/open_destination
	/// Delay before the activating user is carried away
	var/activation_time = 2 SECONDS

/obj/structure/waystone/Initialize(mapload)
	. = ..()
	register_waystone()

/obj/structure/waystone/Destroy()
	unregister_waystone()
	open_destination = null
	return ..()

/obj/structure/waystone/proc/register_waystone()
	GLOB.surface_waystones |= src

/obj/structure/waystone/proc/unregister_waystone()
	GLOB.surface_waystones -= src

/obj/structure/waystone/proc/is_open()
	if(!open_until)
		return FALSE
	if(world.time >= open_until || QDELETED(open_destination))
		close_gate()
		return FALSE
	return TRUE

/obj/structure/waystone/proc/open_gate(obj/structure/waystone/destination)
	open_destination = destination
	open_until = world.time + open_duration
	icon_state = "waystone-open"
	set_light(3, 1, l_color = "#8fd3ff")
	visible_message(span_notice("[src] flares to life, a shimmering gate hanging in the air before it."))
	addtimer(CALLBACK(src, PROC_REF(check_close)), open_duration + 1)

/obj/structure/waystone/proc/check_close()
	if(open_until && world.time >= open_until)
		close_gate()

/obj/structure/waystone/proc/close_gate()
	if(!open_until && !open_destination)
		return
	open_until = 0
	open_destination = null
	icon_state = initial(icon_state)
	set_light(0)
	visible_message(span_notice("The gate above [src] fades and the stone falls quiet."))

/// Where a fresh activation sends the user. Null = can't activate.
/obj/structure/waystone/proc/pick_destination()
	return SSdungeon_generator.get_random_dungeon_waystone()

/obj/structure/waystone/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!isliving(user))
		return
	// Someone already opened the gate: just follow them.
	if(is_open())
		travel(user, open_destination)
		return TRUE
	activate(user)
	return TRUE

/obj/structure/waystone/proc/activate(mob/living/user)
	var/obj/structure/waystone/destination = pick_destination()
	if(!destination)
		to_chat(user, span_warning("The stone is silent. There is nowhere for it to lead."))
		return
	to_chat(user, span_notice("You lay your hand on [src]..."))
	if(!do_after(user, activation_time, target = src))
		return
	// Someone may have opened it while we were channeling
	if(is_open())
		travel(user, open_destination)
		return
	destination = pick_destination() // re-roll in case it was deleted mid-channel
	if(!destination)
		return
	open_gate(destination)
	travel(user, destination)

/obj/structure/waystone/proc/travel(mob/living/user, obj/structure/waystone/destination)
	if(QDELETED(destination))
		to_chat(user, span_warning("The gate sputters and collapses."))
		return
	var/turf/arrival = destination.find_arrival_turf()
	if(!arrival)
		to_chat(user, span_warning("The way is blocked."))
		return
	to_chat(user, span_notice("The world folds around you."))
	var/obj/item/grabbing/grab = user.get_active_held_item()
	if(!istype(grab))
		grab = user.get_inactive_held_item()
	if(istype(grab))
		var/atom/movable/movable = grab.grabbed
		movable.forceMove(arrival)
	user.forceMove(arrival)
	playsound(arrival, 'sound/magic/blink.ogg', 50, TRUE)

/// A free turf next to this stone
/obj/structure/waystone/proc/find_arrival_turf()
	var/list/options = list()
	for(var/turf/T in orange(1, src))
		if(T.density)
			continue
		var/blocked = FALSE
		for(var/atom/A in T)
			if(A.density)
				blocked = TRUE
				break
		if(!blocked)
			options += T
	if(!length(options))
		return null
	return pick(options)

/obj/structure/waystone/dungeon
	name = "dungeon waystone"
	desc = "A waystone half-swallowed by the dark. It's dormant; it would need a warpstone to carry anyone out."
	open_duration = WAYSTONE_EXIT_WINDOW
	/// Room depth, filled in by SSdungeon_generator when the room is placed
	var/depth = 0

/obj/structure/waystone/dungeon/register_waystone()
	SSdungeon_generator.dungeon_waystones |= src

/obj/structure/waystone/dungeon/unregister_waystone()
	SSdungeon_generator.dungeon_waystones -= src

/obj/structure/waystone/dungeon/pick_destination()
	return pick_n_take_surface()

/obj/structure/waystone/dungeon/proc/pick_n_take_surface()
	var/list/valid = list()
	for(var/obj/structure/waystone/stone as anything in GLOB.surface_waystones)
		if(!QDELETED(stone))
			valid += stone
	if(!length(valid))
		return null
	return pick(valid)

/// 0..1, how far out this stone is
/obj/structure/waystone/dungeon/proc/get_depth_factor()
	return SSdungeon_generator.get_depth_factor(depth, z)

/obj/structure/waystone/dungeon/attack_hand(mob/living/user, list/modifiers)
	if(isliving(user) && is_open())
		travel(user, open_destination)
		return TRUE
	if(isliving(user))
		to_chat(user, span_warning("The stone is dormant. It needs a warpstone to open the way out."))
		return TRUE
	return ..()

/obj/structure/waystone/dungeon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/warpstone) && isliving(user))
		var/obj/item/warpstone/W = I
		W.charge_at(src, user)
		return TRUE
	return ..()

/obj/item/warpstone
	name = "warpstone"
	desc = "A palm-sized stone that hums when held near a waystone. Use it on a dungeon waystone to open the way out. The deeper you are, the longer it takes to charge."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "warpstone"
	w_class = WEIGHT_CLASS_SMALL
	/// Charge time at the dungeon entrance
	var/min_charge_time = 5 SECONDS
	/// Charge time at the deepest point
	var/max_charge_time = 25 SECONDS
	var/charging = FALSE

/obj/item/warpstone/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "warpstone_emissive")

/obj/item/warpstone/proc/get_charge_time(obj/structure/waystone/dungeon/stone)
	return round(LERP(min_charge_time, max_charge_time, stone.get_depth_factor()))

/obj/item/warpstone/proc/charge_at(obj/structure/waystone/dungeon/stone, mob/living/user)
	if(charging)
		return
	if(stone.is_open())
		to_chat(user, span_notice("The way is already open. Just step through."))
		return
	var/obj/structure/waystone/destination = stone.pick_destination()
	if(!destination)
		to_chat(user, span_warning("The stone finds nothing to lead back to."))
		return
	var/charge_time = get_charge_time(stone)
	charging = TRUE
	to_chat(user, span_notice("You press [src] to [stone]. The stone begins to draw power... ([charge_time / 10]s)"))
	stone.visible_message(span_notice("[stone] begins to glow as [user] charges it with [src]."))
	if(!do_after(user, charge_time, target = stone))
		charging = FALSE
		return
	charging = FALSE
	if(QDELETED(stone) || QDELETED(src))
		return
	if(stone.is_open())
		stone.travel(user, stone.open_destination)
		return
	destination = stone.pick_destination()
	if(!destination)
		return
	stone.open_gate(destination)
	to_chat(user, span_notice("[src] crumbles to dust as the gate tears open."))
	qdel(src)
	stone.travel(user, destination)

#undef WAYSTONE_ENTRY_WINDOW
#undef WAYSTONE_EXIT_WINDOW
