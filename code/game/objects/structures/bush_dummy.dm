/obj/effect/dummy/bush_disguise
	density = FALSE
	var/can_move = 1
	var/destroying = FALSE
	var/obj/master
	var/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/spell_ref = null
	voicecolor_override = null
	var/original_name = ""
	var/original_real_name = ""
	var/speaking = TRUE

/obj/effect/dummy/bush_disguise/proc/activate(mob/M, saved_appearance, datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/S, saved_name)
	src.name = saved_name
	src.appearance = saved_appearance
	src.master = M
	src.spell_ref = S
	AddElement(/datum/element/relay_attackers)
	RegisterSignal(src, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked))

	if(M.buckled)
		var/datum/component/riding/ride = M.buckled.GetComponent(/datum/component/riding)
		if(ride)
			ride.force_dismount(M)
		else
			M.buckled.unbuckle_mob(M, force = TRUE)

	M.forceMove(src)
	src.original_name = M.name
	src.original_real_name = M.real_name
	M.name = M.real_name = saved_name

/obj/effect/dummy/bush_disguise/proc/deactivate(mob/M)
	if(M)
		M.name = src.original_name
		M.real_name = src.original_real_name
		M.reset_perspective(null)
		M.cancel_camera()

/obj/effect/dummy/bush_disguise/relaymove(mob/user, direction)
	if(!direction)
		return
	var/turf/T = get_step(src, direction)
	if(istype(T, /turf/open/openspace))
		return
	if(world.time < can_move)
		return
	can_move = world.time + 5
	setDir(direction)
	var/old_y = pixel_y
	var/matrix/T1 = matrix()
	T1.Turn(10)
	var/matrix/T2 = matrix()
	T2.Turn(-10)

	animate(src, pixel_y = old_y + 3, transform = T1, time = 1)
	animate(pixel_y = old_y - 3, transform = T2, time = 1)
	animate(pixel_y = old_y, transform = null, time = 1)

	step(src, direction)
	return 1

/obj/effect/dummy/bush_disguise/proc/on_attacked(atom/attacker, damage)
	_check_break_stealth()

/obj/effect/dummy/bush_disguise/bullet_act(obj/projectile/P)
	_check_break_stealth()
	take_damage(P.damage, P.damage_type, P.flag, 1, turn(P.dir, 180), P.armor_penetration)
	return

/obj/effect/dummy/bush_disguise/fire_act(added, maxstacks)
	_check_break_stealth()
	if(added)
		take_damage(CLAMP(0.02 * added, 0, 20), BURN, "fire", 0)
	return 1

/obj/effect/dummy/bush_disguise/attack_hand(mob/living/user)
	_check_break_stealth()
	return

/obj/effect/dummy/bush_disguise/proc/_check_break_stealth()
	if(spell_ref && master && !QDELETED(src))
		spell_ref.end_jaunt(master)

/obj/effect/dummy/bush_disguise/Destroy()
	if(destroying)
		return ..()
	destroying = TRUE

	UnregisterSignal(src, COMSIG_ATOM_WAS_ATTACKED)

	if(spell_ref && master && !QDELETED(master))
		spell_ref.end_jaunt(master)
	return ..()

