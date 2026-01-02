/datum/mob_affix/interconnected
	name = "Interconnected"
	description = "Mobs are connected via a frozen beam"
	color = "#00aeff"
	var/connected_mobs = 2
	var/connect_timer
	var/list/beams = list()
	var/list/hit_targets
	var/mob/living/owner

/datum/mob_affix/interconnected/apply_affix(mob/living/simple_animal/hostile/retaliate/target)
	owner = target
	for(var/mob/mob in view(5, owner))
		if(connected_mobs <= 0)
			return
		if((mob in SSmatthios_mobs.matthios_mobs) || faction_check(target.faction, mob.faction))
			connect(target, mob)
			connected_mobs--
	connect_timer = addtimer(CALLBACK(src, PROC_REF(try_connect), target), 3 SECONDS, TIMER_STOPPABLE)

/datum/mob_affix/interconnected/proc/try_connect(mob/living/simple_animal/hostile/retaliate/target)
	for(var/mob/mob in view(5, owner))
		if(connected_mobs <= 0)
			return
		if((mob in SSmatthios_mobs.matthios_mobs) || faction_check(target.faction, mob.faction))
			connect(target, mob)
			connected_mobs--
	connect_timer = addtimer(CALLBACK(src, PROC_REF(try_connect), target), 3 SECONDS, TIMER_STOPPABLE)

/datum/mob_affix/interconnected/proc/connect(mob/living/simple_animal/hostile/retaliate/target, mob/living/mob)
	var/datum/beam/beam = target.Beam(
		mob,
		"medbeam",
		'icons/effects/beam.dmi',
		INFINITY,
		20,
		/obj/effect/ebeam/reacting,
		TRUE,
		ABOVE_ALL_MOB_LAYER,
		GAME_PLANE_UPPER,
	)
	RegisterSignal(beam, COMSIG_BEAM_ENTERED, PROC_REF(beam_entered))

	beams |= beam


/datum/mob_affix/interconnected/proc/beam_entered(datum/beam/source, obj/effect/ebeam/hit, mob/living/entered)
	if(!isliving(entered))
		return
	if((entered in SSmatthios_mobs.matthios_mobs) || faction_check(owner.faction, entered.faction))
		return
	if(entered == owner)
		return
	var/mob/living/frozen_guy = entered
	do_freeze(frozen_guy)

/datum/mob_affix/interconnected/proc/do_freeze(mob/living/victim, extra_modifer = 1)
	if(LAZYACCESS(hit_targets, victim))
		return

	LAZYSET(hit_targets, victim, TRUE)

	if(victim.can_block_magic(MAGIC_RESISTANCE))
		victim.visible_message(
			span_warning("The frost ray fizzles on contact with [victim]!"),
			span_warning("The frost ray fizzles on contact with me!"),
		)
		playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
		return

	victim.adjustFireLoss(round(20))
	victim.apply_status_effect(/datum/status_effect/debuff/frostbite, null, 1)

	new /obj/effect/temp_visual/snap_freeze(get_turf(victim))

	playsound(get_turf(victim), 'sound/items/stonestone.ogg', 100)
	victim.visible_message(
		span_danger("[victim] is struck by the ray of frost!"),
		span_userdanger("I'm struck by the ray of frost!"),)
	addtimer(CALLBACK(src, PROC_REF(remove_hit), victim))

/datum/mob_affix/interconnected/proc/remove_hit(mob/living/victim)
	LAZYSET(hit_targets, victim, FALSE)
