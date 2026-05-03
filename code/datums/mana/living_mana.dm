/atom/movable
	var/datum/mana_pool/mana_pool
	var/has_initial_mana_pool = FALSE // not using flags since this is all modular and flags can be overridden by tg

	var/mana_overload_threshold = BASE_MANA_OVERLOAD_THRESHOLD
	var/mana_overload_coefficient = BASE_MANA_OVERLOAD_COEFFICIENT

	var/mana_overloaded = FALSE

// creates the mana pool for use.
// mostly called on atom_init.
/atom/movable/proc/initialize_mana_pool()
	RETURN_TYPE(/datum/mana_pool)

	var/datum/mana_pool/type = get_initial_mana_pool_type()

	var/datum/mana_pool/pool = new type(parent = src)
	return pool

// base proc to return what kind of mana pool this atom will have.
// meant to be overridden with whatever mana_pool subtype you want.
/atom/movable/proc/get_initial_mana_pool_type()
	RETURN_TYPE(/datum/mana_pool)

	return /datum/mana_pool

/// New_pool is nullable
/// standard setter proc. Input the pool you want to add to the atom, and it'll toss out the old
/atom/movable/proc/set_mana_pool(datum/mana_pool/new_pool)
	if (!can_have_mana_pool(new_pool))
		return FALSE

	SEND_SIGNAL(src, COMSIG_ATOM_MANA_POOL_CHANGED, mana_pool, new_pool)

	if (mana_pool)
		// do stuff like replacement
		QDEL_NULL(mana_pool)
		set_mana_pool(null) // todo: see if this is necessary
	mana_pool = new_pool

	if (isnull(mana_pool))
		if (mana_overloaded)
			stop_mana_overload()

// just retrieves mana_pool and initializes it if it doesn't have one for some reason (and is allowed to have one)
/atom/movable/proc/get_mana_pool_lazy()

	if (!can_have_mana_pool())
		return null

	initialize_mana_pool_if_possible()

	return mana_pool

// initialize the pool if it doesn't have one, and is allowed to
/atom/movable/proc/initialize_mana_pool_if_possible()
	if (isnull(mana_pool) && can_have_mana_pool())
		mana_pool = initialize_mana_pool()

// arg nullable
// override this with whatever if you want special functionality if something wants to check if it can have a mana_pool
/atom/movable/proc/can_have_mana_pool(datum/mana_pool/new_pool)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_BE_PURE(TRUE)

	return TRUE

/atom/movable/proc/after_manapool_init()
	return TRUE

/mob/living/carbon
	has_initial_mana_pool = TRUE

/mob/living/carbon/get_initial_mana_pool_type()
	return /datum/mana_pool/mob

/mob/living/carbon/proc/generate_random_attunements(amount = rand(2, 3))
	var/list/attunements = subtypesof(/datum/attunement)
	for(var/i = 1 to amount)
		var/datum/attunement/picked = pick(attunements)
		mana_pool?.adjust_attunement(picked, rand(1, 3) * 0.1)

/mob/living/carbon/after_manapool_init()
	generate_random_attunements()

/mob/living/carbon/human/dummy
	has_initial_mana_pool = FALSE

/datum/mana_pool/mob
	maximum_mana_capacity = CARBON_BASE_MANA_CAPACITY

	exponential_decay_divisor = BASE_CARBON_MANA_EXPONENTIAL_DIVISOR

// carbons have softcap mults, this adds it to the pool.
/mob/living/carbon/initialize_mana_pool()
	var/datum/mana_pool/mob/our_pool = ..()

	our_pool.softcap *= get_mana_softcap_mult(mana_pool)
	our_pool.set_intrinsic_recharge(NONE)
	return our_pool

/mob/living/carbon/proc/get_mana_softcap_mult(datum/mana_pool/pool)
	SHOULD_BE_PURE(TRUE)
	return 1

/mob/living/carbon/proc/get_max_mana_capacity_mult()
	SHOULD_BE_PURE(TRUE)

	var/mult = 1

	return mult

/mob/living/carbon/proc/safe_adjust_personal_mana(amount_to_adjust)
// proc for adjusting mana without going over the softcap
	if(mana_pool) // playing it safe, does nothing if you have no mana pool
		if(amount_to_adjust < 0) // if the amount is negative
			if(mana_pool.amount > -amount_to_adjust) // not risking negatives
				mana_pool.adjust_mana(amount_to_adjust)
		else
			if(mana_pool.amount < mana_pool.get_softcap())
				mana_pool.adjust_mana(amount_to_adjust)

/mob/living/carbon/proc/adjust_personal_mana(amount_to_adjust)
// proc for adjusting mana that CAN go over the softcap
	if(mana_pool) // playing it safe, does nothing if you have no mana pool
		if(amount_to_adjust < 0) // if the amount is negative - you *should* use the above if you know its gonna go into the negatives, though.
			if(mana_pool.amount > -amount_to_adjust) // not risking negatives
				mana_pool.adjust_mana(amount_to_adjust)
		else
			mana_pool.adjust_mana(amount_to_adjust)
