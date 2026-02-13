#define UPDATE_STRENGTH(...) STASTR = clamp(base_strength + modified_strength, 1, 20)
#define UPDATE_PERCEPTION(...) STAPER = clamp(base_perception + modified_perception, 1, 20)
#define UPDATE_ENDURANCE(...) STAEND = clamp(base_endurance + modified_endurance, 1, 20)
#define UPDATE_CONSTITUTION(...) STACON = clamp(base_constitution + modified_constitution, 1, 20)
#define UPDATE_INTELLIGENCE(...) STAINT = clamp(base_intelligence + modified_intelligence, 1, 20)
#define UPDATE_SPEED(...) STASPD = clamp(base_speed + modified_speed, 1, 20)
#define UPDATE_FORTUNE(...) STALUC = clamp(base_fortune + modified_fortune, 1, 20)

/mob/living
	var/datum/patron/patron = null

	/* Base stat values */
	var/base_strength = 10
	var/base_perception = 10
	var/base_endurance = 10
	var/base_constitution = 10
	var/base_intelligence = 10
	var/base_speed = 10
	var/base_fortune = 10

	/* Cached modifier values, calculated when needed */
	VAR_PRIVATE/final/modified_strength
	VAR_PRIVATE/final/modified_perception
	VAR_PRIVATE/final/modified_endurance
	VAR_PRIVATE/final/modified_constitution
	VAR_PRIVATE/final/modified_intelligence
	VAR_PRIVATE/final/modified_speed
	VAR_PRIVATE/final/modified_fortune
	/// Lazy-list of stat modifiers keyed with sources.
	var/list/stat_modifiers = null

	/* Calculated stat values, these are what you want to use. */
	var/final/STASTR = 10
	var/final/STAPER = 10
	var/final/STAEND = 10
	var/final/STACON = 10
	var/final/STAINT = 10
	var/final/STASPD = 10
	var/final/STALUC = 10

	var/has_rolled_for_stats = FALSE

/mob/living/proc/init_faith()
	patron = GLOB.patron_list[/datum/patron/godless/godless]

/mob/living/proc/set_patron(datum/patron/new_patron, check_antag = FALSE)
	if(!new_patron)
		return FALSE
	if(check_antag && mind?.special_role)
		return FALSE
	if(ispath(new_patron))
		new_patron = GLOB.patron_list[new_patron]
	if(!istype(new_patron))
		return FALSE
	if(patron && !ispath(patron))
		patron.on_remove(src)
		mana_pool?.remove_attunements(patron)
	patron = new_patron
	patron.on_gain(src)
	mana_pool?.set_attunements(patron)
	return TRUE

///Rolls random stats base 10, +-1, for SPECIAL, and applies species stats and age stats.
/mob/living/proc/roll_mob_stats()
	if(has_rolled_for_stats)
		return FALSE

	base_strength += (prob(33) && pick(-1, 1))
	base_perception += (prob(33) && pick(-1, 1))
	base_endurance += (prob(33) && pick(-1, 1))
	base_constitution += (prob(33) && pick(-1, 1))
	base_intelligence += (prob(33) && pick(-1, 1))
	base_speed += (prob(33) && pick(-1, 1))
	base_fortune += (prob(33) && pick(-1, 1))

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.dna?.species)
			var/datum/species/species = H.dna.species
			var/list/specstat_list = (gender == FEMALE) ? species.specstats_f : species.specstats_m
			for(var/stat in specstat_list)
				set_stat_modifier(STATMOD_SEX, stat, specstat_list[stat])

		switch(H.age)
			if(AGE_CHILD)
				set_stat_modifier(STATMOD_AGE, STATKEY_STR, -2)
				set_stat_modifier(STATMOD_AGE, STATKEY_CON, -2)
				set_stat_modifier(STATMOD_AGE, STATKEY_PER, 1)
				set_stat_modifier(STATMOD_AGE, STATKEY_END, 1)
				set_stat_modifier(STATMOD_AGE, STATKEY_SPD, round(rand(1,2)))
			// nothing for adults/immortals,
			if(AGE_MIDDLEAGED)
				set_stat_modifier(STATMOD_AGE, STATKEY_END, 1)
				set_stat_modifier(STATMOD_AGE, STATKEY_SPD, -1)
			if(AGE_OLD)
				set_stat_modifier(STATMOD_AGE, STATKEY_STR, -2)
				set_stat_modifier(STATMOD_AGE, STATKEY_PER, 2)
				set_stat_modifier(STATMOD_AGE, STATKEY_END, -1)
				set_stat_modifier(STATMOD_AGE, STATKEY_CON, -1)
				set_stat_modifier(STATMOD_AGE, STATKEY_INT, 2)
				set_stat_modifier(STATMOD_AGE, STATKEY_SPD, -1)
				set_stat_modifier(STATMOD_AGE, STATKEY_LCK, 1)

		if(HAS_TRAIT(src, TRAIT_PUNISHMENT_CURSE))
			change_stat(STATKEY_STR, -3)
			change_stat(STATKEY_SPD, -3)
			change_stat(STATKEY_END, -3)
			change_stat(STATKEY_CON, -3)
			change_stat(STATKEY_INT, -3)
			change_stat(STATKEY_LCK, -3)
			H.voice_color = "c71d76"
			set_eye_color(H, "#c71d76", "#c71d76")

		if(HAS_TRAIT(src, TRAIT_BEAUTIFUL))
			change_stat(STATKEY_LCK, 1)

		if(HAS_TRAIT(src, TRAIT_UGLY))
			change_stat(STATKEY_LCK, -1)

	has_rolled_for_stats = TRUE
	return TRUE

/mob/living/proc/set_stat_modifier(source, stat_key, amount)
	if(!source || !(stat_key in MOBSTATS) || !isnum(amount))
		return

	var/list/source_list = LAZYACCESS(stat_modifiers, source)

	if(LAZYACCESS(source_list, stat_key) != amount)
		if(!amount)
			LAZYREMOVE(source_list, stat_key)
		else
			LAZYSET(source_list, stat_key, amount)

		if(!LAZYLEN(source_list))
			LAZYREMOVE(source_list, stat_key)
		else
			LAZYSET(stat_modifiers, source, source_list)

		var/new_total = 0
		for(var/existing_sources in stat_modifiers)
			new_total += LAZYACCESS(stat_modifiers[existing_sources], stat_key)

		switch(stat_key) //I am sorry for this
			if(STATKEY_STR)
				modified_strength = new_total
				UPDATE_STRENGTH()
			if(STATKEY_PER)
				modified_perception = new_total
				UPDATE_PERCEPTION()
			if(STATKEY_END)
				modified_endurance = new_total
				UPDATE_ENDURANCE()
			if(STATKEY_CON)
				modified_constitution = new_total
				UPDATE_CONSTITUTION()
			if(STATKEY_INT)
				modified_intelligence = new_total
				UPDATE_INTELLIGENCE()
			if(STATKEY_SPD)
				modified_speed = new_total
				UPDATE_SPEED()
			if(STATKEY_LCK)
				modified_fortune = new_total
				UPDATE_FORTUNE()

/mob/living/proc/set_stat_modifier_list(source, stat_keys_values)
	if(!source || !length(stat_keys_values))
		return
	for(var/stat_key in stat_keys_values)
		if(!(stat_key in MOBSTATS))
			continue
		var/amount = stat_keys_values[stat_key]
		if(!amount)
			continue
		set_stat_modifier(source, stat_key, amount)

/**
 * Set a stat key to value via a modifier at that moment
 * * source - Stringed source key
 * * stat_key - Stat to adjust
 * * value - Value to adjust to
 */
/mob/living/proc/modifier_set_stat_to(source, stat_key, value)
	if(!source || !stat_key || !value)
		return
	var/current = get_stat(stat_key)
	if(!current)
		return
	set_stat_modifier(source, stat_key, value - current)

/mob/living/proc/adjust_stat_modifier(source, stat_key, amount)
	if(!source || !(stat_key in MOBSTATS) || !amount)
		return

	var/list/source_list = LAZYACCESS(stat_modifiers, source)
	LAZYADDASSOC(source_list, stat_key, amount)
	LAZYSET(stat_modifiers, source, source_list)

	var/new_total = 0
	for(var/existing_sources in stat_modifiers)
		new_total += LAZYACCESS(stat_modifiers[existing_sources], stat_key)

	switch(stat_key) //I am sorry for this
		if(STATKEY_STR)
			modified_strength = new_total
			UPDATE_STRENGTH()
		if(STATKEY_PER)
			modified_perception = new_total
			UPDATE_PERCEPTION()
		if(STATKEY_END)
			modified_endurance = new_total
			UPDATE_ENDURANCE()
		if(STATKEY_CON)
			modified_constitution = new_total
			UPDATE_CONSTITUTION()
		if(STATKEY_INT)
			modified_intelligence = new_total
			UPDATE_INTELLIGENCE()
		if(STATKEY_SPD)
			modified_speed = new_total
			UPDATE_SPEED()
		if(STATKEY_LCK)
			modified_fortune = new_total
			UPDATE_FORTUNE()

/mob/living/proc/adjust_stat_modifier_list(source, stat_keys_values)
	if(!source || !length(stat_keys_values))
		return
	for(var/stat_key in stat_keys_values)
		if(!(stat_key in MOBSTATS))
			continue
		var/amount = stat_keys_values[stat_key]
		if(!amount)
			continue
		adjust_stat_modifier(source, stat_key, amount)

/mob/living/proc/remove_stat_modifier(source)
	if(!source)
		return

	var/list/old_modifications = LAZYACCESS(stat_modifiers, source)
	LAZYREMOVE(stat_modifiers, source)

	for(var/stat_key in old_modifications)
		var/adjustment = old_modifications[stat_key]

		switch(stat_key) //I am sorry for this
			if(STATKEY_STR)
				modified_strength -= adjustment
				UPDATE_STRENGTH()
			if(STATKEY_PER)
				modified_perception -= adjustment
				UPDATE_PERCEPTION()
			if(STATKEY_END)
				modified_endurance -= adjustment
				UPDATE_ENDURANCE()
			if(STATKEY_CON)
				modified_constitution -= adjustment
				UPDATE_CONSTITUTION()
			if(STATKEY_INT)
				modified_intelligence -= adjustment
				UPDATE_INTELLIGENCE()
			if(STATKEY_SPD)
				modified_speed -= adjustment
				UPDATE_SPEED()
			if(STATKEY_LCK)
				modified_fortune -= adjustment
				UPDATE_FORTUNE()

///Returns the mob's stats in an associated list
/mob/living/proc/get_all_stats() as /list
	RETURN_TYPE(/list)

	return list(
		(STATKEY_STR) = STASTR,
		(STATKEY_PER) = STAPER,
		(STATKEY_END) = STAEND,
		(STATKEY_CON) = STACON,
		(STATKEY_INT) = STAINT,
		(STATKEY_SPD) = STASPD,
		(STATKEY_LCK) = STALUC,
	)

/// Return mob's stat value by stat_key
/mob/living/proc/get_stat(stat_key)
	if(!stat_key)
		return

	return LAZYACCESS(get_all_stats(), stat_key)

///Returns: the difference in value between the opponents stat key and ours.
///EG: Our endurace - opp endurance.
/mob/living/proc/stat_difference_to(mob/living/opponent,stat_key)
	if(!opponent || !stat_key)
		return
	switch(stat_key)
		if(STATKEY_STR)
			return STASTR - opponent.STASTR
		if(STATKEY_PER)
			return STAPER - opponent.STAPER
		if(STATKEY_END)
			return STAEND - opponent.STAEND
		if(STATKEY_CON)
			return STACON - opponent.STACON
		if(STATKEY_INT)
			return STAINT - opponent.STAINT
		if(STATKEY_SPD)
			return STASPD - opponent.STASPD
		if(STATKEY_LCK)
			return STALUC - opponent.STALUC
	return
///Returns: Difference betwen our_stat and opponents opp_stat.
///EG: Our STR - opp CON
/mob/living/proc/stat_compare(mob/living/opponent, our_stat_key, opp_stat_key)
	if(!opponent || !opp_stat_key || !our_stat_key)
		return
	var/our_stat = get_stat_level(our_stat_key)
	var/opponent_stat = opponent.get_stat_level(opp_stat_key)

	return our_stat - opponent_stat

///Effectively rolls a d20, with each point in the stat being a chance_per_point% chance to succeed per point in the stat. If no stat is provided, just returns 0.
///dee_cee is a difficulty mod, a positive value makes the check harder, a negative value makes it easier.
///invert_dc changes it from stat - dc to dc - stat, for inverted checks.
///EG: A person with 10 luck and a dc of -10 effectively has a 100% chance of success. Or an inverted DC with 10 means 0% chance of success.
/mob/living/proc/stat_roll(stat_key,chance_per_point = 5, dee_cee = null, invert_dc = FALSE)
	if(!stat_key)
		return FALSE
	var/tocheck
	switch(stat_key)
		if(STATKEY_STR)
			tocheck = STASTR
		if(STATKEY_PER)
			tocheck = STAPER
		if(STATKEY_END)
			tocheck = STAEND
		if(STATKEY_CON)
			tocheck = STACON
		if(STATKEY_INT)
			tocheck = STAINT
		if(STATKEY_SPD)
			tocheck = STASPD
		if(STATKEY_LCK)
			tocheck = STALUC
	if(invert_dc)
		return isnull(dee_cee) ? prob(tocheck * chance_per_point) : prob(clamp((dee_cee - tocheck) * chance_per_point,0,100))
	else
		return isnull(dee_cee) ? prob(tocheck * chance_per_point) : prob(clamp((tocheck - dee_cee) * chance_per_point,0,100))

/mob/living/proc/get_stat_level(stat_key)
	switch(stat_key)
		if(STATKEY_STR)
			return STASTR
		if(STATKEY_PER)
			return STAPER
		if(STATKEY_END)
			return STAEND
		if(STATKEY_CON)
			return STACON
		if(STATKEY_INT)
			return STAINT
		if(STATKEY_SPD)
			return STASPD
		if(STATKEY_LCK)
			return STALUC

/mob/living/proc/badluck(multi = 3)
	if(STALUC < 10)
		return prob((10 - STALUC) * multi)

/mob/living/proc/goodluck(multi = 3)
	if(STALUC > 10)
		return prob((STALUC - 10) * multi)

#define LEGACY_SOURCE "do not fucking edit or remove this admins i swear to god"

/// ~~Adjusts stat values of mobs. set_stat == true to set directly.~~
/mob/living/proc/change_stat(stat_key, adjust_amount)
	//! DEPRECATED PROC
	if(!stat_key || !adjust_amount)
		return

	adjust_stat_modifier(LEGACY_SOURCE, stat_key, adjust_amount)

#undef LEGACY_SOURCE

/// Recalculates all of a mob's stats and stat modifiers. Don't use this more than you **need** to.
/mob/living/proc/recalculate_stats(including_modifiers = TRUE)
	if(including_modifiers)
		// we discard all of our mods and compile them again
		modified_strength = 0
		modified_perception = 0
		modified_endurance = 0
		modified_constitution = 0
		modified_intelligence = 0
		modified_speed = 0
		modified_fortune = 0

		for(var/source in stat_modifiers)
			var/sourced_modifiers = LAZYACCESS(stat_modifiers, source)
			for(var/stat_key in sourced_modifiers)
				var/adjustment = LAZYACCESS(sourced_modifiers, stat_key)
				switch(stat_key) //I am sorry for this
					if(STATKEY_STR)
						modified_strength += adjustment
					if(STATKEY_PER)
						modified_perception += adjustment
					if(STATKEY_END)
						modified_endurance += adjustment
					if(STATKEY_CON)
						modified_constitution += adjustment
					if(STATKEY_INT)
						modified_intelligence += adjustment
					if(STATKEY_SPD)
						modified_speed += adjustment
					if(STATKEY_LCK)
						modified_fortune += adjustment

	UPDATE_STRENGTH()
	UPDATE_PERCEPTION()
	UPDATE_ENDURANCE()
	UPDATE_CONSTITUTION()
	UPDATE_INTELLIGENCE()
	UPDATE_SPEED()
	UPDATE_FORTUNE()

/mob/living/proc/reset_and_reroll_stats()
	//Reset base stats to defaults
	base_strength = 10
	base_perception = 10
	base_endurance = 10
	base_constitution = 10
	base_intelligence = 10
	base_speed = 10
	base_fortune = 10

	//Clear all cached modifiers
	modified_strength = 0
	modified_perception = 0
	modified_endurance = 0
	modified_constitution = 0
	modified_intelligence = 0
	modified_speed = 0
	modified_fortune = 0
	stat_modifiers = list()

	//Reset stat roll var so roll_mob_stats() will work
	has_rolled_for_stats = FALSE

	//Reroll mob stats
	roll_mob_stats()

	//recalc all modifiers to ensure final stats are up to date
	recalculate_stats()

#undef UPDATE_STRENGTH
#undef UPDATE_PERCEPTION
#undef UPDATE_ENDURANCE
#undef UPDATE_CONSTITUTION
#undef UPDATE_INTELLIGENCE
#undef UPDATE_SPEED
#undef UPDATE_FORTUNE
