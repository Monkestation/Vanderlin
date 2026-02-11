#define SOUND_EXTRA_RANGE_CANNON 30

/obj/structure/cannon
	name = "cannon"
	icon = 'icons/roguetown/misc/cannon.dmi'
	icon_state = "cannon"

	density = TRUE
	max_integrity = 1200
	anchored = FALSE
	climbable = TRUE
	climb_offset = 16

	resistance_flags = FIRE_PROOF
	drag_slowdown = 3

	SET_BASE_PIXEL(-16, -16)

	var/obj/item/fuse/inserted_fuse

/obj/structure/cannon/Initialize()
	. = ..()
	reagents = new()
	reagents.flags = TRANSPARENT
	AddComponent(/datum/component/storage/concrete/grid/cannon)

/obj/structure/cannon/after_being_moved_by_pull(atom/movable/puller)
	setDir(REVERSE_DIR(puller.dir))

/obj/structure/cannon/fire_act(added, maxstacks)
	. = ..()
	try_light_fuse()

/obj/structure/cannon/proc/try_light_fuse(mob/user)
	inserted_fuse?.attempt_to_be_lit()

/obj/structure/cannon/can_be_pulled(user, grab_state, force)
	. = ..()
	if(get_dir(user, src) != dir)
		return FALSE

/obj/structure/cannon/proc/fire()

	var/blastpowder_amount = reagents.get_reagent_amount(/datum/reagent/blastpowder)
	reagents.clear_reagents()
	if(!blastpowder_amount)
		balloon_alert_to_viewers("Sizzles out!")
		return FALSE

	var/blast_range = round(blastpowder_amount / 1.5)

	var/turf/turf_in_front = get_step(src, dir)
	var/turf/turf_to_shoot_from = turf_in_front

	if(!isopenturf(turf_to_shoot_from))
		turf_to_shoot_from = get_turf(src)

	playsound(src, 'sound/foley/tinnitus.ogg', 60, FALSE, -6)
	playsound(src, 'sound/combat/Ranged/muskshoot.ogg', 60, FALSE, SOUND_EXTRA_RANGE_CANNON)
	new /obj/effect/particle_effect/smoke/chem/transparent(get_turf(src))
	var/datum/component/storage/STR = GetComponent(/datum/component/storage) // don't @ me

	for(var/mob/living/seer in view(7, src))
		shake_camera(seer, max(1, round(blastpowder_amount / 20), max(1, round(blastpowder_amount / 10))))
		seer.adjust_eye_blur_up_to((blastpowder_amount / 1.5) SECONDS, 10 SECONDS)
	for(var/mob/living/seer in view(1, src))
		seer.apply_effect(15, EFFECT_KNOCKDOWN)
		var/target_turf = get_turf(seer)
		if(get_turf(seer) == get_turf(src))
			for(var/i in 1 to rand(3, 7))
				target_turf = get_step(target_turf, pick(ALL_CARDINALS))
		else
			for(var/i in 1 to pick(1, 2))
				target_turf = get_step(target_turf, pick(ALL_CARDINALS))

		seer.throw_at(target_turf)

	for(var/atom/movable/loaded_thing as anything in contents)
		STR.remove_from_storage(loaded_thing, turf_to_shoot_from)
		var/target = get_ranged_target_turf(src, dir, blast_range)
		if(isammo(loaded_thing))
			if(blastpowder_amount < 15)
				continue
			var/obj/item/ammo_casing/loaded_ammo = loaded_thing
			loaded_ammo.fire_casing(target, fired_from = turf_to_shoot_from)
			qdel(loaded_ammo) // I think this is a bug (?) but I don't want to deal with it rn
		else
			if(ismobholder(loaded_thing))
				var/obj/item/mob_holder/curler = loaded_thing
				loaded_thing = curler.held_mob
				qdel(curler)
			loaded_thing.throw_at(target, blast_range, 3, force = MOVE_FORCE_OVERPOWERING)
			if(isliving(loaded_thing))
				var/mob/living/loaded_living = loaded_thing
				loaded_living.reset_offsets("structure_climb")

	throw_at(get_step(src, REVERSE_DIR(dir)), 1, 3, spin = FALSE)

/obj/structure/cannon/attackby(obj/item/I, mob/user, list/modifiers)
	if(isreagentcontainer(I))
		var/obj/item/reagent_containers/reagent_container = I
		if(do_after(user, 1 SECONDS, src))
			if(reagent_container.reagents.trans_to(reagents, 10, transfered_by = user))
				user.visible_message(span_notice("[user] fills the [src] with \the [I]"), span_notice("I fill the [src] with \the [I]"))
				playsound(src, 'sound/foley/gunpowder_fill.ogg', 100, FALSE)
				balloon_alert(user, "Added!")
			else
				balloon_alert(user, "None Left!")
		return TRUE

	if(isfuse(I))
		var/obj/item/fuse/fuse = I
		if(fuse.add_to_cannon(src, user))
			user.visible_message(span_notice("[user] adds \the [fuse] to \the [src]"), span_notice("I add \the [fuse] to \the [src]"))
			balloon_alert_to_viewers("Attached!")
		return TRUE

	. = ..()

/obj/effect/fuse
	icon = 'icons/roguetown/misc/cannon_fuse.dmi'
	var/obj/structure/cannon/cannon
	var/obj/item/fuse/fuse
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	glide_size = 4

/obj/effect/fuse/Initialize(mapload, obj/structure/cannon/passed_cannon, obj/item/fuse/passed_fuse)
	. = ..()
	cannon = passed_cannon
	fuse = passed_fuse
	if(!cannon || !fuse)
		stack_trace("[src] wasn't given a fuse or cannon")
		return INITIALIZE_HINT_QDEL

	sync_with_fuse()
	calculate_offsets()
	RegisterSignal(cannon, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))
	RegisterSignal(cannon, COMSIG_ATOM_DIR_CHANGE, PROC_REF(calculate_offsets))
	RegisterSignal(fuse, COMSIG_PARENT_QDELETING, PROC_REF(on_deletion))
	RegisterSignal(fuse, COMSIG_FUSE_LIT, PROC_REF(on_status_change))
	RegisterSignal(fuse, COMSIG_FUSE_EXTINGUISHED, PROC_REF(on_status_change))
	AddElement(/datum/element/no_mouse_drop)

/obj/effect/fuse/Destroy(force)
	. = ..()
	cannon = null
	fuse = null
	UnregisterSignal(cannon, COMSIG_PARENT_QDELETING)
	UnregisterSignal(cannon, COMSIG_ATOM_DIR_CHANGE)
	UnregisterSignal(fuse, COMSIG_PARENT_QDELETING)
	UnregisterSignal(fuse, COMSIG_FUSE_LIT)
	UnregisterSignal(fuse, COMSIG_FUSE_EXTINGUISHED)

/obj/effect/fuse/proc/on_deletion()
	qdel(src)

/obj/effect/fuse/proc/be_cut()
	fuse?.remove_from_cannon(cannon)
	qdel(src)

/obj/effect/fuse/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(I.sharpness == IS_SHARP)
		balloon_alert_to_viewers("Cut!")
		be_cut()

/obj/effect/fuse/fire_act(added, maxstacks)
	if(added)
		fuse.attempt_to_be_lit()

/obj/effect/fuse/proc/on_status_change()
	sync_with_fuse()
	calculate_offsets()

/obj/effect/fuse/proc/sync_with_fuse()
	if(QDELETED(fuse))
		return
	appearance = fuse.appearance
	add_filter("fuse_outline", 1, outline_filter(color = "#FFFF00"))
	transform = matrix()

/obj/effect/fuse/proc/calculate_offsets(datum/parent, current_dir, new_dir)
	SIGNAL_HANDLER
	if(QDELETED(cannon))
		return

	if(loc != cannon.loc)
		forceMove(get_turf(cannon))

	var/turf/center = src.loc
	var/turf/cannon_barrel = get_step(cannon, (new_dir || cannon.dir))

	var/matrix/new_matrix = matrix()
	transform = new_matrix
	transform = transform.Turn(180 - dir2angle(get_dir(center, cannon_barrel)))

	var/cannon_barrel_x = cannon_barrel.x
	var/center_x = center.x
	var/cannon_barrel_y = cannon_barrel.y
	var/center_y = center.y

	var/new_pixel_w = (center_x - cannon_barrel_x) * 20
	var/new_pixel_z = (center_y - cannon_barrel_y) * 20

	pixel_w = new_pixel_w
	pixel_z = new_pixel_z


/obj/item/fuse
	name = "fuse"
	abstract_type = /obj/item/fuse
	icon = 'icons/roguetown/misc/cannon_fuse.dmi'
	mouse_opacity = MOUSE_OPACITY_ICON
	layer = LOW_ITEM_LAYER
	glide_size = 4
	var/failure_chance = 50
	var/lit = FALSE
	var/obj/structure/cannon/cannon
	grid_width = 32
	grid_height = 32

/obj/item/fuse/proc/add_to_cannon(obj/structure/cannon/cannon, mob/living/user)
	if(cannon.inserted_fuse)
		return FALSE

	if(!user.dropItemToGround(src))
		return FALSE

	src.cannon = cannon
	RegisterSignal(cannon, COMSIG_PARENT_PREQDELETED, PROC_REF(remove_from_cannon))
	loc = null
	new /obj/effect/fuse (get_turf(cannon), cannon, src)
	return TRUE

/obj/item/fuse/proc/remove_from_cannon()
	UnregisterSignal(cannon, COMSIG_PARENT_PREQDELETED)
	loc = get_turf(cannon)
	cannon?.inserted_fuse = null
	cannon = null

/obj/item/fuse/Destroy()
	remove_from_cannon()
	. = ..()

/obj/item/fuse/proc/attempt_to_be_lit()
	if(lit)
		return
	if(prob(failure_chance))
		cannon.visible_message(span_danger("The fuse fails to light!"))
		return
	lit()

/obj/item/fuse/proc/lit()
	icon_state = icon_state + "_lit"
	lit = TRUE
	cannon?.balloon_alert_to_viewers("Lit!")
	addtimer(CALLBACK(src, PROC_REF(reached_end)), 5 SECONDS)
	playsound(cannon, 'sound/items/fuse.ogg', 100)
	SEND_SIGNAL(src, COMSIG_FUSE_LIT)

/obj/item/fuse/proc/extinguished()
	lit = FALSE
	icon_state = initial(icon_state)
	SEND_SIGNAL(src, COMSIG_FUSE_EXTINGUISHED)

/obj/item/fuse/proc/reached_end()
	if(!lit)
		extinguished()
		return

	cannon.fire()

	qdel(src)

/obj/item/fuse/fiber
	name = "fiber fuse"
	icon_state = "fiber_fuse"

/obj/item/fuse/parchment
	name = "parchment fuse"
	icon_state = "parchment_fuse"
	failure_chance = 10

/atom/proc/debug_turn()
	var/enter = input(usr, "How much", "Meow", 180)
	transform = transform.Turn(enter)

#undef SOUND_EXTRA_RANGE_CANNON
