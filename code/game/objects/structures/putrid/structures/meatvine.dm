/obj/structure/meatvine/floor
	icon_state = "tile_1"
	is_full = TRUE

/obj/structure/meatvine/floor/Initialize()
	. = ..()

	icon_state = pick(list("tile_1", "tile_2", "tile_3", "tile_4"))

/obj/structure/meatvine/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir)
	. = ..()
	if(damage_type != BURN)
		transfer_feromones(3)

/obj/structure/meatvine/heavy
	icon = 'icons/obj/cellular/meat_wall.dmi'
	icon_state = "box"
	density = TRUE
	opacity = TRUE
	pass_flags = null

	smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ


	max_integrity = 50
	resistance_flags = CAN_BE_HIT
	is_full = TRUE


/obj/structure/meatvine/heavy/CanPass(atom/movable/mover, turf/target)
	. = ..()
	return FALSE

/obj/structure/meatvine/heavy/CanAStarPass(ID, to_dir, requester)
	return FALSE


/obj/structure/meatvine/lair
	icon_state = "lair_1"
	density = FALSE
	opacity = FALSE
	pass_flags = null
	is_full = TRUE

	max_integrity = 30
	resistance_flags = CAN_BE_HIT

	var/mob/living/simple_animal/hostile/retaliate/meatvine/Mob
	var/mob_death_registered = FALSE

/obj/structure/meatvine/lair/Initialize()
	. = ..()
	icon_state = pick(list("lair_1", "lair_2", "lair_3"))

	set_light(2, 2, 1, l_color = "#ff6533")

/obj/structure/meatvine/lair/Destroy()
	puff_gas(TRUE)
	if(Mob && !QDELETED(Mob))
		UnregisterSignal(Mob, COMSIG_LIVING_DEATH)
	if(master)
		master.lair_destroyed(src)

	return ..()

/obj/structure/meatvine/heavy/grow()
	if(!master)
		return
	if(master.isdying)
		return

	var/turf/T = get_turf(src)
	if(!isfloorturf(T))
		rot()
		return

	return

/obj/structure/meatvine/lair/grow()
	if(!master)
		return

	if(master.isdying)
		return

	var/turf/T = get_turf(src)
	if(!isfloorturf(T))
		rot()
		return

	if(!Mob)
		var/mobtype = pick(/mob/living/simple_animal/hostile/retaliate/meatvine, /mob/living/simple_animal/hostile/retaliate/meatvine/range)
		Mob = new mobtype(loc)
		register_spawned_mob(Mob)
		puff_gas()
		return

	Mob.adjustBruteLoss(-10)
	Mob.adjustToxLoss(-5)
	Mob.adjustOxyLoss(-5)

	puff_gas()

/obj/structure/meatvine/lair/proc/register_spawned_mob(mob/living/M)
	if(!M || QDELETED(M))
		return

	Mob = M
	Mob.master = master
	Mob.generate_monitor()
	mob_death_registered = TRUE
	RegisterSignal(M, COMSIG_LIVING_DEATH, PROC_REF(on_mob_death))
	var/datum/hud/putrid/hud = M.hud_used
	hud?.setup_mob()

/obj/structure/meatvine/lair/proc/on_mob_death(mob/living/source)
	SIGNAL_HANDLER

	// Convert lair back to regular floor
	var/turf/T = get_turf(src)
	if(T && master)
		// Remove from master's lists
		master.lairs -= src
		master.vines -= src

		// Store master reference before deletion
		var/obj/effect/meatvine_controller/saved_master = master

		// Delete the lair
		master = null
		qdel(src)

		// Spawn regular floor in its place
		saved_master.spawn_spacevine_piece(T, /obj/structure/meatvine/floor)

/obj/structure/meatvine/lair/rot()
	. = ..()
	Mob = null

/obj/projectile/meatbullet
	icon_state = "meat"
	damage = 20
	damage_type = BRUTE
