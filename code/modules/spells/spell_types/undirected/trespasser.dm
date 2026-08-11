/datum/action/cooldown/spell/undirected/trespasser
	name = "Trespass"
	desc = "Interlope through a transparent object."
	button_icon_state = "jaunt"
	sound = 'sound/magic/turntoflies2.ogg'

	cooldown_time = 45 SECONDS
	has_visual_effects = FALSE
	spell_cost = 15
	spell_type = SPELL_STAMINA
	charge_required = FALSE

/datum/action/cooldown/spell/undirected/trespasser/cast(atom/cast_on)
	. = ..()
	var/mob/usermob = usr
	if(!usermob) return
	// --
	var/blink_dir = usr.dir
	// Find Our Spot
	var/turf/blink_loc = get_turf(usr)
	var/steps = 2 // how many TILES in the dir we are looking, we are going to TRY and move.
	while(steps > 0)
		var/turf/temp_loc = get_step(blink_loc, blink_dir)
		var/valid = TRUE
		// -/turf
		if(temp_loc.density==TRUE & temp_loc.opacity==TRUE)
			valid = FALSE
			steps = 0
			break
		// -/obj/structure
		for(var/obj/structure/structure in temp_loc)
			if(structure.density==TRUE & structure.opacity==TRUE)
				valid = FALSE
				steps = 0
				break
		// -
		if(valid)
			blink_loc = temp_loc
			// A few sparks per turf- so you can tell WHICH way they went.
			var/datum/effect_system/spark_spread/t_sparks = new()
			t_sparks.set_up(2, 1, temp_loc)
			t_sparks.start()
			steps--
	// --
	usermob.forceMove(blink_loc)
	return
