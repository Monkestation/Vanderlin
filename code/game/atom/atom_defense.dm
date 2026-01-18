
/// The essential proc to call when an atom must receive damage of any kind.
/atom/proc/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armour_penetration = 0)
	if(!uses_integrity)
		CRASH("[src] had /atom/proc/take_damage() called on it without it being a type that has uses_integrity = TRUE!")
	if(QDELETED(src))
		CRASH("[src] taking damage after deletion")
	if(atom_integrity < 0)
		CRASH("[src] taking damage while having < 0 integrity")
	if(sound_effect)
		play_attack_sound(damage_amount, damage_type, damage_flag)
	if(resistance_flags & INDESTRUCTIBLE)
		return
	damage_amount = run_atom_armor(damage_amount, damage_type, damage_flag, attack_dir, armour_penetration)
	if(damage_amount < DAMAGE_PRECISION)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_TAKE_DAMAGE, damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armour_penetration) & COMPONENT_NO_TAKE_DAMAGE)
		return

	. = damage_amount

	var/old_integrity = atom_integrity
	update_integrity(atom_integrity - damage_amount, FALSE, damage_flag)

	//BREAKING FIRST
	if(integrity_failure && atom_integrity <= integrity_failure * max_integrity)
		var/silent = !(old_integrity > integrity_failure * max_integrity)
		atom_break(damage_flag, silent)

	//DESTROYING SECOND
	if(atom_integrity <= 0)
		atom_destruction(damage_flag)

/// Proc for recovering atom_integrity. Returns the amount repaired by
/atom/proc/repair_damage(amount)
	if(amount <= 0) // We only recover here
		return
	var/new_integrity = min(max_integrity, atom_integrity + amount)
	. = new_integrity - atom_integrity

	update_integrity(new_integrity, FALSE)

	if(integrity_failure && (atom_integrity > integrity_failure * max_integrity))
		atom_fix()

/// Handles the integrity of an atom changing. This must be called instead of changing integrity directly.
/atom/proc/update_integrity(new_value, update_atom = TRUE, damage_flag)
	if(!uses_integrity)
		CRASH("/atom/proc/update_integrity() was called on [src] when it doesn't use integrity!")
	var/old_value = atom_integrity
	new_value = max(0, new_value)
	if(atom_integrity == new_value)
		return
	atom_integrity = new_value

	if(update_atom)
		if(new_value > old_value)
			if(integrity_failure && (atom_integrity > integrity_failure * max_integrity))
				atom_fix()
		else
			//BREAKING FIRST
			if(integrity_failure && atom_integrity <= integrity_failure * max_integrity)
				var/silent = !(old_value > integrity_failure * max_integrity)
				atom_break(damage_flag, silent)

			//DESTROYING SECOND
			if(atom_integrity <= 0)
				atom_destruction(damage_flag)

	SEND_SIGNAL(src, COMSIG_ATOM_INTEGRITY_CHANGED, old_value, new_value)

/obj/item/update_integrity(new_value, update_atom = TRUE, damage_flag)
	if(!uses_integrity)
		CRASH("/atom/proc/update_integrity() was called on [src] when it doesn't use integrity!")
	var/old_value = atom_integrity
	new_value = max(0, new_value)
	if(atom_integrity == new_value)
		return
	atom_integrity = new_value

	if(update_atom)
		if(new_value > old_value)
			if(integrity_failure && (atom_integrity > integrity_failure * max_integrity))
				atom_fix()
		else
			//BREAKING FIRST
			if(integrity_failure && atom_integrity <= integrity_failure * max_integrity)
				var/silent = !(old_value > integrity_failure * max_integrity)
				atom_break(damage_flag, silent)

			//DESTROYING SECOND
			if(atom_integrity <= 0)
				if(item_flags & ITEM_ONLY_BREAK)
					atom_integrity = 1
					return
				atom_destruction(damage_flag)

	SEND_SIGNAL(src, COMSIG_ATOM_INTEGRITY_CHANGED, old_value, new_value)


/// This mostly exists to keep atom_integrity private. Might be useful in the future.
/atom/proc/get_integrity()
	SHOULD_BE_PURE(TRUE)
	return atom_integrity

/// Similar to get_integrity, but returns the percentage as [0-1] instead.
/atom/proc/get_integrity_percentage()
	SHOULD_BE_PURE(TRUE)
	return round(atom_integrity / max_integrity, 0.01)

///returns the damage value of the attack after processing the atom's various armor protections
/atom/proc/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir, armour_penetration = 0, armour_ignorance = 0)
	if(!uses_integrity)
		CRASH("/atom/proc/run_atom_armor was called on [src] without being implemented as a type that uses integrity!")
	if((damage_flag in MELEE_TYPES) && damage_amount < damage_deflection)
		return 0
	if(damage_type != BRUTE && damage_type != BURN)
		return 0
	var/armor_protection = 0
	if(damage_flag)
		armor_protection = armor?.getRating(damage_flag)
	if(armor_protection) //Only apply weak-against-armor/hollowpoint effects if there actually IS armor.
		armor_protection = clamp(round((armor_protection * ((100 - armour_penetration) * 0.01)), 1) - armour_ignorance, min(armor_protection, 0), 100) //Armor penetration is now a percent reduction - I.E. 20 AP = armor is 20% *less* effective
	return round(damage_amount * (100 - armor_protection) * 0.01, DAMAGE_PRECISION)

///the sound played when the atom is damaged.
/atom/proc/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(!attacked_sound)
		return

	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				if(islist(attacked_sound))
					playsound(src, pick(attacked_sound), 100, FALSE, -1)
				else
					playsound(src, attacked_sound, 100, FALSE, -1)
			else
				playsound(src, "nodmg", 100, FALSE, -1)
		if(BURN)
			playsound(src, "burn", 100, FALSE, -1)

///Called to get the damage that hulks will deal to the atom.
/atom/proc/hulk_damage()
	return 150 //the damage hulks do on punches to this atom, is affected by melee armor

/atom/proc/attack_generic(mob/user, damage_amount = 0, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, armor_penetration = 0) //used by attack_alien, attack_animal, and attack_slime
	if(!uses_integrity)
		CRASH("unimplemented /atom/proc/attack_generic()!")
	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	return take_damage(damage_amount, damage_type, damage_flag, sound_effect, get_dir(src, user), armor_penetration)

/// Called after the atom takes damage and integrity is below integrity_failure level
/atom/proc/atom_break(damage_flag, silent)
	SHOULD_CALL_PARENT(TRUE)

	if(!silent)
		if(break_sound)
			playsound(src, break_sound, 100, TRUE)
		if(break_message)
			visible_message(break_message)
	SEND_SIGNAL(src, COMSIG_ATOM_BREAK, damage_flag)

/// Called when integrity is repaired above the breaking point having been broken before
/atom/proc/atom_fix()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_FIX)

///what happens when the atom's integrity reaches zero.
/atom/proc/atom_destruction(damage_flag)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_DESTRUCTION, damage_flag)

///changes max_integrity while retaining current health percentage, returns TRUE if the atom got broken.
/atom/proc/modify_max_integrity(new_max, can_break = TRUE, damage_type = BRUTE)
	if(!uses_integrity)
		CRASH("/atom/proc/modify_max_integrity() was called on [src] when it doesn't use integrity!")
	var/current_integrity = atom_integrity
	var/current_max = max_integrity

	if(current_integrity != 0 && current_max != 0)
		var/percentage = current_integrity / current_max
		current_integrity = max(1, round(percentage * new_max)) //don't destroy it as a result
		atom_integrity = current_integrity

	max_integrity = new_max

	if(can_break && integrity_failure && current_integrity <= integrity_failure * max_integrity)
		atom_break(damage_type)
		return TRUE
	return FALSE
