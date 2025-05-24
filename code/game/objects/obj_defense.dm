///the essential proc to call when an obj must receive damage of any kind.
/obj/proc/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armor_penetration = 0)
	if(QDELETED(src))
		stack_trace("[src] taking damage after deletion")
		return
	if(sound_effect)
		play_attack_sound(damage_amount, damage_type, damage_flag)
	if((resistance_flags & INDESTRUCTIBLE) || !max_integrity)
		return
	damage_amount = run_obj_armor(damage_amount, damage_type, damage_flag, attack_dir, armor_penetration)
	testing("damamount [damage_amount]")
	if(damage_amount < DAMAGE_PRECISION)
		return
	. = damage_amount
	obj_integrity = max(obj_integrity - damage_amount, 0)
	if(animate_dmg)
		var/oldx = pixel_x
		animate(src, pixel_x = oldx+1, time = 0.5)
		animate(pixel_x = oldx-1, time = 0.5)
		animate(pixel_x = oldx, time = 0.5)
	if(!obj_broken && integrity_failure && obj_integrity <= integrity_failure * max_integrity)
		obj_break(damage_flag)
	if(!obj_destroyed && obj_integrity <= 0)
		obj_destruction(damage_flag)


///returns the damage value of the attack after processing the obj's various armor protections
/obj/proc/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armor_penetration = 0)
	if(damage_flag == "blunt" && damage_amount < damage_deflection)
		testing("damtest55")
		return 0
	if(damage_type != BRUTE && damage_type != BURN)
		testing("damtest66")
		return 0
	var/armor_protection = 0
	if(damage_flag)
		armor_protection = armor?.getRating(damage_flag)
	if(armor_protection)		//Only apply weak-against-armor/hollowpoint effects if there actually IS armor.
		armor_protection = CLAMP(armor_protection - armor_penetration, min(armor_protection, 0), 100)
	return round(damage_amount * (100 - armor_protection)*0.01, DAMAGE_PRECISION)

/obj
	var/attacked_sound = 'sound/blank.ogg'

///the sound played when the obj is damaged.
/obj/proc/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				if(islist(attacked_sound))
					playsound(src.loc, pick(attacked_sound), 100, FALSE, -1)
				else
					playsound(src.loc, attacked_sound, 100, FALSE, -1)
			else
				playsound(src.loc, "nodmg", 100, FALSE, -1)
		if(BURN)
			playsound(src.loc, "burn", 100, FALSE, -1)

/obj/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	..()
	if(!QDELETED(src) && AM.throwforce > 5)
		take_damage(AM.throwforce*0.1, BRUTE, damage_type, 1, get_dir(src, AM))

/obj/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	if(resistance_flags & INDESTRUCTIBLE)
		return
	..() //contents explosion
	var/ddist = devastation_range
	var/hdist = heavy_impact_range
	var/ldist = light_impact_range
	var/fdist = flame_range
	var/fodist = get_dist(src, epicenter)
	var/brute_loss = 0

	switch (severity)
		if (EXPLODE_DEVASTATE)
			brute_loss = (250 * ddist) - (250 * max((fodist - 1), 0))

		if (EXPLODE_HEAVY)
			brute_loss = (100 * hdist) - (100 * max((fodist - 1), 0))

		if(EXPLODE_LIGHT)
			brute_loss = ((25 * ldist) - (25 * fodist))

	take_damage(brute_loss, BRUTE, "blunt", 0)

	if(fdist && !QDELETED(src))
		var/stacks = ((fdist - fodist) * 2)
		fire_act(stacks)

/obj/bullet_act(obj/projectile/P)
	. = ..()
	playsound(src.loc, P.hitsound, 50, TRUE)
	visible_message("<span class='danger'>[src] is hit by \a [P]!</span>", null, null, COMBAT_MESSAGE_RANGE)
	if(!QDELETED(src)) //Bullet on_hit effect might have already destroyed this object
		take_damage(P.damage, P.damage_type, P.flag, 0, turn(P.dir, 180), P.armor_penetration)

/obj/proc/attack_generic(mob/user, damage_amount = 0, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, armor_penetration = 0) //used by attack_alien, attack_animal, and attack_slime
	user.do_attack_animation(src, used_intent = user.used_intent)
	user.changeNext_move(CLICK_CD_MELEE)
	return take_damage(damage_amount, damage_type, damage_flag, sound_effect, get_dir(src, user), armor_penetration)

/obj/attack_animal(mob/living/simple_animal/M)
	if(!M.melee_damage_upper && !M.obj_damage)
		M.emote("custom", message = "[M.friendly_verb_continuous] [src].")
		return 0
	else
		var/play_soundeffect = 1
		if(M.environment_smash)
			play_soundeffect = 0
		if(M.obj_damage)
			. = attack_generic(M, M.obj_damage, M.melee_damage_type, M.damage_type, play_soundeffect, M.armor_penetration)
		else
			. = attack_generic(M, rand(M.melee_damage_lower,M.melee_damage_upper), M.melee_damage_type, "melee", play_soundeffect, M.armor_penetration)
		if(. && !play_soundeffect)
			playsound(src, 'sound/blank.ogg', 100, TRUE)

/obj/force_pushed(atom/movable/pusher, force = MOVE_FORCE_DEFAULT, direction)
	return TRUE

/obj/move_crushed(atom/movable/pusher, force = MOVE_FORCE_DEFAULT, direction)
	collision_damage(pusher, force, direction)
	return TRUE

/obj/proc/collision_damage(atom/movable/pusher, force = MOVE_FORCE_DEFAULT, direction)
	var/amt = max(0, ((force - (move_resist * MOVE_FORCE_CRUSH_RATIO)) / (move_resist * MOVE_FORCE_CRUSH_RATIO)) * 10)
	take_damage(amt, BRUTE)

///// ACID

GLOBAL_DATUM_INIT(acid_overlay, /mutable_appearance, mutable_appearance('icons/effects/effects.dmi', "acid"))

///the obj's reaction when touched by acid
/obj/acid_act(acidpwr, acid_volume)
	if(!(resistance_flags & UNACIDABLE) && acid_volume)

		if(!acid_level)
			SSacid.processing[src] = src
			add_overlay(GLOB.acid_overlay, TRUE)
		var/acid_cap = acidpwr * 300 //so we cannot use huge amounts of weak acids to do as well as strong acids.
		if(acid_level < acid_cap)
			acid_level = min(acid_level + acidpwr * acid_volume, acid_cap)
		return 1

///the proc called by the acid subsystem to process the acid that's on the obj
/obj/proc/acid_processing()
	. = TRUE
	if(!(resistance_flags & ACID_PROOF))
		if(prob(33))
			playsound(loc, 'sound/blank.ogg', 150, TRUE)
		take_damage(min(1 + round(sqrt(acid_level)*0.3), 300), BURN, "acid", 0)

	acid_level = max(acid_level - (5 + 3*round(sqrt(acid_level))), 0)
	if(!acid_level)
		return FALSE

///called when the obj is destroyed by acid.
/obj/proc/acid_melt()
	SSacid.processing -= src
	deconstruct(FALSE)

//// FIRE

///Called when the obj is exposed to fire.
/obj/fire_act(added, maxstacks)
	if(QDELETED(src))
		return
	if(isturf(loc))
		var/turf/T = loc
		if(T.intact && level == 1) //fire can't damage things hidden below the floor.
			return
	if(added && !(resistance_flags & FIRE_PROOF))
		take_damage(CLAMP(0.02 * added, 0, 20), BURN, "fire", 0)
	if(!(resistance_flags & ON_FIRE) && (resistance_flags & FLAMMABLE) && !(resistance_flags & FIRE_PROOF))
		resistance_flags |= ON_FIRE
		SSfire_burning.processing[src] = src
		add_overlay(GLOB.fire_overlay, TRUE)
		playsound(src, 'sound/misc/enflame.ogg', 100, TRUE)
		return 1

///called when the obj is destroyed by fire
/obj/proc/burn()
	if(resistance_flags & ON_FIRE)
		SSfire_burning.processing -= src
	deconstruct(FALSE)

///Called when the obj is no longer on fire.
/obj/proc/extinguish()
	if(resistance_flags & ON_FIRE)
		resistance_flags &= ~ON_FIRE
		cut_overlay(GLOB.fire_overlay, TRUE)
		SSfire_burning.processing -= src
		if(fire_burn_start)
			fire_burn_start = null

//The surgeon general warns that being buckled to certain objects receiving powerful shocks is greatly hazardous to your health
///Only tesla coils and grounding rods currently call this because mobs are already targeted over all other objects, but this might be useful for more things later.
/obj/proc/tesla_buckle_check(strength)
	if(has_buckled_mobs())
		for(var/m in buckled_mobs)
			var/mob/living/buckled_mob = m
			buckled_mob.electrocute_act((CLAMP(round(strength/400), 10, 90) + rand(-5, 5)), src, flags = SHOCK_TESLA)

/obj/proc/reset_shocked()
	obj_flags &= ~BEING_SHOCKED

///the obj is deconstructed into pieces, whether through careful disassembly or when destroyed.
/obj/proc/deconstruct(disassembled = TRUE)
	SEND_SIGNAL(src, COMSIG_OBJ_DECONSTRUCT, disassembled)
	if(islist(debris))
		for(var/I in debris)
			var/count = debris[I] + rand(-1,1)
			if(count > 0)
				for(var/i in 1 to count)
					new I (get_turf(src))
	if(islist(static_debris))
		for(var/I in static_debris)
			for(var/i in 1 to static_debris[I])
				new I (get_turf(src))
	qdel(src)

///called after the obj takes damage and integrity is below integrity_failure level
/obj/proc/obj_break(damage_flag, silent = FALSE)
	obj_broken = TRUE
	if(!silent)
		if(break_sound)
			playsound(src, break_sound, 100, TRUE)
		if(break_message)
			visible_message(break_message)

///what happens when the obj's integrity reaches zero.
/obj/proc/obj_destruction(damage_flag)
	obj_destroyed = TRUE
	if(damage_flag == "acid")
		acid_melt()
	else if(damage_flag == "fire")
		burn()
	else
		if(destroy_sound)
			playsound(src, destroy_sound, 100, TRUE)
		if(destroy_message)
			visible_message(destroy_message)
		deconstruct(FALSE)
	return TRUE

///changes max_integrity while retaining current health percentage, returns TRUE if the obj got broken.
/obj/proc/modify_max_integrity(new_max, can_break = TRUE, damage_type = BRUTE)
	var/current_integrity = obj_integrity
	var/current_max = max_integrity

	if(current_integrity != 0 && current_max != 0)
		var/percentage = current_integrity / current_max
		current_integrity = max(1, round(percentage * new_max))	//don't destroy it as a result
		obj_integrity = current_integrity

	max_integrity = new_max

	if(can_break && integrity_failure && current_integrity <= integrity_failure * max_integrity)
		obj_break(damage_type)
		return TRUE
	return FALSE

///returns how much the object blocks an explosion. Used by subtypes.
/obj/proc/GetExplosionBlock()
	CRASH("Unimplemented GetExplosionBlock()")

/obj/proc/on_fall_impact(mob/living/impactee, fall_speed)
	SHOULD_CALL_PARENT(TRUE)
	return
