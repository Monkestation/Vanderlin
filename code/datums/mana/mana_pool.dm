/// An abstract representation of collections of mana, as it's impossible to represent each individual mana unit
/datum/mana_pool
	var/atom/movable/parent = null

	// In vols
	/// The absolute maximum [amount] we can hold. Under no circumstances should [amount] ever exceed this value.
	var/maximum_mana_capacity = BASE_MANA_CAPACITY
	/// The abstract representation of how many "Vols" this mana pool currently contains.
	/// Capped at [maximum_mana_capacity], begins decaying exponentially when above [softcap].
	var/amount = 100 // placeholder. This should be replaced during process.
	/// The threshold at which mana begins decaying exponentially.
	// TODO: convert to some kind of list for multiple softcaps?
	var/softcap = BASE_MANA_SOFTCAP
	/// The divisor used in exponential decay when [amount] surpasses [softcap]. Lower = A steeper decay curve.
	var/exponential_decay_divisor = BASE_MANA_EXPONENTIAL_DIVISOR

	/// The maximum mana we can transfer per second. [donation_budget_per_tick] is set to this, times seconds_per_tick, every process tick.
	var/max_donation_rate_per_second = BASE_MANA_DONATION_RATE
	/// The maximum mana we can transfer for this tick. Is used to cap our mana output per tick. Calculated with [max_donation_rate_per_second] * seconds_per_tick.
	VAR_PROTECTED/donation_budget_this_tick = 149 // same with amount. this gets replaced on process.

	/// List of (mana_pool -> transfer rate)
	var/list/datum/mana_pool/transfer_rates = list()
	/// List of (mana_pool -> max mana we will give)
	var/list/datum/mana_pool/transfer_caps = list()
	/// List of (mana_pool -> mana_pool_process_bitflags). Holds pools we are transferring to.
	var/list/datum/mana_pool/transferring_to = list()
	/// List of mana_pools transferring to us
	var/list/datum/mana_pool/transferring_from = list()
	/// The priority method we will use to transfer mana to all that we are trying to transfer into. Uses defines from magic_charge_bitflags.dm
	var/transfer_method = MANA_SEQUENTIAL

	/// If true, if no cap is specified, we only go up to the softcap of the target when transferring
	var/transfer_default_softcap = TRUE

	/// The natural regen rate, detached from transferrals. Mana generated via this comes from nothing.
	var/ethereal_recharge_rate = 0

	/// The mana pool types we will try to discharge excess mana (from exponential decay) into. Uses defines from magic_charge_bitflags.dm.
	var/discharge_destinations = MANA_ALL_LEYLINES | MANA_ALL_PYLONS
	/// The priority method we will use to transfer mana to [discharge_destination] mana pools. Any given type does not guarantee all destinations will receive mana if they are full.
	/// Uses defines from magic_charge_bitflags.dm.
	var/discharge_method = MANA_SEQUENTIAL

	/// The intrinsic sources of mana we will constantly try to draw from. Uses defines from magic_charge_bitflags.dm.
	var/intrinsic_recharge_sources = NONE

	var/draws_beams = FALSE

	var/list/maptext_info = list("Last Generated" = 0, "Total Mana" = 0)

	var/list/decay_prevention

	var/datum/attunement/network_attunement

	var/next_message = 0

	VAR_PRIVATE/is_processing = FALSE

	/// Tracks this mana pool owner's technique/form investment, unspent points, and unlocked spells.
	/// Lazily created - use get_mastery() rather than referencing this directly.
	var/datum/spell_mastery/mastery

/datum/mana_pool/New(atom/parent = null)
	. = ..()
	donation_budget_this_tick = max_donation_rate_per_second
	set_parent(parent)

	update_intrinsic_recharge()

	START_PROCESSING(SSmagic, src)

/datum/mana_pool/Destroy(force)
	transfer_rates = null
	transfer_caps = null
	transferring_to = null
	transferring_from = null

	STOP_PROCESSING(SSmagic, src)

	if(parent && ismob(parent))
		var/mob/holder = parent
		var/datum/hud/human/hud_used = holder.hud_used
		if(hud_used?.mana)
			hud_used.mana.icon_state = initial(hud_used.mana.icon_state)

	if (parent.mana_pool != src)
		stack_trace("[parent].mana_pool was not [src] when src had parent registered!")
	else
		parent.mana_pool = null
	parent = null

	return ..()

/datum/mana_pool/proc/needs_processing()
	if(ethereal_recharge_rate != 0 && amount < get_safe_softcap())
		return TRUE
	if(intrinsic_recharge_sources && amount < get_softcap())
		return TRUE
	if(length(transferring_to))
		return TRUE
	if(amount > get_softcap())
		return TRUE
	return FALSE

/datum/mana_pool/proc/get_mastery()
	RETURN_TYPE(/datum/spell_mastery)
	if(!mastery)
		mastery = new(src)
		if(isliving(parent))
			add_verb(parent, list(/mob/living/proc/open_spellbook))
			ADD_TRAIT(parent, TRAIT_HASMAGIC, INNATE_TRAIT)
	return mastery

/datum/mana_pool/proc/update_processing_state()
	var/should_process = needs_processing()
	if(should_process && !is_processing)
		is_processing = TRUE
		START_PROCESSING(SSmagic, src)
	else if(!should_process && is_processing)
		is_processing = FALSE
		STOP_PROCESSING(SSmagic, src)

/datum/mana_pool/proc/set_parent(atom/parent)
	src.parent = parent
	if(parent && ismob(parent))
		var/mob/holder = parent
		var/datum/hud/human/hud_used = holder.hud_used
		if(hud_used?.mana)
			var/filled = round((src.amount / get_softcap()) * 100, 10)
			filled = min(filled, 120)
			hud_used.mana.icon_state = "mana[filled]"

/datum/mana_pool/proc/mana_status_report(datum/source, list/status_tab)
	SIGNAL_HANDLER

	var/general_amount_estimate
	var/sc_very_low = (get_softcap() * 0.1)
	var/sc_low = (get_softcap() * 0.3)
	var/sc_medium = (get_softcap() * 0.6)
	var/sc_high = (get_softcap() * 0.8)

	//determines what the status displays, it'll be a generic/non-obvious value as a design choice
	if(amount)
		if (amount < sc_very_low)
			general_amount_estimate = "VERY LOW"
		else if (amount > sc_very_low && amount < sc_low)
			general_amount_estimate = "LOW"
		else if (amount > sc_low && amount < sc_medium)
			general_amount_estimate = "MEDIUM"
		else if (amount > sc_medium && amount < sc_high)
			general_amount_estimate = "HIGH"
		else if (amount > sc_high && amount <= get_softcap())
			general_amount_estimate = "VERY HIGH"
		else if (amount > get_softcap())
			general_amount_estimate = "OVERLOADED"
	else
		general_amount_estimate = "ERROR"

	status_tab += "Mana Count: [general_amount_estimate]"

// order of operations is as follows:
// 1. we recharge
// 2. we transfer mana
// 3. we discharge excess mana
/datum/mana_pool/process()

	donation_budget_this_tick = (max_donation_rate_per_second)

	if (ethereal_recharge_rate != 0 && (amount < get_safe_softcap()))
		adjust_mana(ethereal_recharge_rate)
	if((intrinsic_recharge_sources & MANA_ALL_LEYLINES) && amount < get_softcap())
		var/list/leylines = list()
		for(var/obj/effect/ebeam/beam in range(3, get_turf(parent)))
			if(!beam.owner.mana_pool)
				continue
			if(beam.owner.mana_pool in leylines)
				if(leylines[beam.owner.mana_pool] > get_dist(get_turf(parent), beam))
					leylines[beam.owner.mana_pool] = get_dist(parent, beam)
			else
				leylines |= beam.owner.mana_pool
				leylines[beam.owner.mana_pool] = get_dist(parent, beam)

		if(length(leylines))
			for(var/datum/mana_pool/leyline/leyline as anything in leylines)
				var/sane_distance = leylines[leyline] + 1
				leyline.transfer_specific_mana(src, (leyline.get_transfer_rate_for(src) / sane_distance) * 0.1, safe = TRUE)

	if((intrinsic_recharge_sources & MANA_ALL_PYLONS) && amount < get_softcap())
		var/list/pylons = list()
		for(var/obj/structure/mana_pylon/pylon in range(3, get_turf(parent)))
			if(pylon.mana_pool.network_attunement && (network_attunement != pylon.mana_pool.network_attunement))
				continue
			var/sane_distance = get_dist(get_turf(parent), pylon) + 1
			pylon.mana_pool.transfer_specific_mana(src, (pylon.mana_pool.get_transfer_rate_for(src) / sane_distance))
			pylons += pylon
		if(draws_beams)
			parent.draw_mana_beams_from_list(pylons, 4)

	if (length(transferring_to) > 0)
		switch (transfer_method)
			if (MANA_SEQUENTIAL)
				for (var/datum/mana_pool/iterated_pool as anything in transferring_to)
					if (amount <= 0 || donation_budget_this_tick <= 0)
						break
					if (transferring_to[iterated_pool] & MANA_POOL_SKIP_NEXT_TRANSFER)
						transferring_to[iterated_pool] &= ~MANA_POOL_SKIP_NEXT_TRANSFER
						continue

					transfer_mana_to(iterated_pool)

			if (MANA_DISPERSE_EVENLY)
				var/mana_to_disperse = (SAFE_DIVIDE(donation_budget_this_tick, length(transferring_to)))

				for (var/datum/mana_pool/iterated_pool as anything in transferring_to)
					if (transferring_to[iterated_pool] & MANA_POOL_SKIP_NEXT_TRANSFER)
						transferring_to[iterated_pool] &= ~MANA_POOL_SKIP_NEXT_TRANSFER
						continue

					transfer_specific_mana(iterated_pool, mana_to_disperse)
			// ...

	if (parent)
		if (amount > parent.mana_overload_threshold)
			var/effect_mult = (((amount / (parent.mana_overload_threshold * 0.05)) - 1) * parent.mana_overload_coefficient)
			parent.process_mana_overload(effect_mult)
		else if (parent.mana_overloaded)
			parent.stop_mana_overload()

	if (amount > get_softcap() && !length(decay_prevention)) // why was this amount < softcap
	// exponential decay
	// exponentially decays amount when amount surpasses softcap, with [exponential_decay_divisor] being the (inverse) decay factor
	// can only decay however much amount we are over softcap
	// imperfect as of now (need to test)
		var/exponential_decay = (max(-((((NUM_E**((amount - get_softcap())/exponential_decay_divisor)) + 1))), (get_softcap() - amount)))
		// in desmos: f\left(x\right)=\max\left(\left(\left(-\left(e\right)^{\left(\frac{\left(x-t\right)}{c}\right)}\right)+1\right),\ \left(t-x\right)\right)\ \left\{x\ge t\right\}
		// t=50
		// c=150
		if (discharge_destinations)
			var/list/datum/mana_pool/pools_to_discharge_into = list()
			if (discharge_destinations & MANA_ALL_LEYLINES)
				var/list/leylines = list()
				for(var/obj/effect/ebeam/beam in range(3, get_turf(parent)))
					if(!beam.owner.mana_pool)
						continue
					leylines |= beam.owner.mana_pool

				pools_to_discharge_into += leylines

			if (discharge_destinations & MANA_ALL_PYLONS)
				var/list/pylons = list()
				for(var/obj/structure/mana_pylon/pylon in range(3, get_turf(parent)))
					pylons |= pylon.mana_pool

				pools_to_discharge_into += pylons

			if(!length(pools_to_discharge_into))
				return

			switch (discharge_method)
				if (MANA_DISPERSE_EVENLY)
					var/mana_to_disperse = (exponential_decay / length(pools_to_discharge_into))

					for (var/datum/mana_pool/iterated_pool as anything in pools_to_discharge_into)
						transfer_specific_mana(iterated_pool, -mana_to_disperse, FALSE)

				if (MANA_SEQUENTIAL)
					for (var/datum/mana_pool/iterated_pool as anything in pools_to_discharge_into)
						exponential_decay -= transfer_specific_mana(iterated_pool, -exponential_decay, FALSE)
						if (exponential_decay <= 0)
							break

		adjust_mana(exponential_decay) //just to be safe, in case we have any left over or didnt have a discharge destination
		if(amount > (get_safe_softcap()-30))
			if(world.time > next_message)
				next_message = world.time + 1.5 MINUTES
				to_chat(parent, span_boldwarning("I am feeling tingly all over."))

/// Perform a "natural" transfer where we use the default transfer rate, capped by the usual math
/datum/mana_pool/proc/transfer_mana_to(datum/mana_pool/target_pool)
	. = transfer_specific_mana(target_pool, get_transfer_rate_for(target_pool))
	update_processing_state()
	return .

/// Returns the amount of mana we want to give in a given tick
/datum/mana_pool/proc/get_transfer_rate_for(datum/mana_pool/target_pool)
	var/cached_rate = transfer_rates[target_pool]
	return min((cached_rate ? min(cached_rate, donation_budget_this_tick) : donation_budget_this_tick), get_maximum_transfer_for(target_pool))

/datum/mana_pool/proc/get_maximum_transfer_for(datum/mana_pool/target_pool)
	var/cached_cap = transfer_caps[target_pool]
	return (cached_cap || (transfer_default_softcap ? target_pool.get_softcap() : target_pool.maximum_mana_capacity))

/datum/mana_pool/proc/transfer_specific_mana(datum/mana_pool/other_pool, amount_to_transfer, decrement_budget = TRUE, safe = FALSE)
	// ensure we dont give more than we hold and dont give more than they CAN hold
	var/adjusted_amount = min(amount_to_transfer, amount, other_pool.maximum_mana_capacity - other_pool.amount)

	if(safe && !length(other_pool.decay_prevention))
		var/safe_ceiling = min(other_pool.get_softcap(), other_pool.parent?.mana_overload_threshold - 50)
		var/headroom = safe_ceiling - other_pool.amount
		adjusted_amount = max(0, min(adjusted_amount, headroom))

	if(decrement_budget)
		donation_budget_this_tick -= amount_to_transfer

	adjust_mana(-adjusted_amount)
	return other_pool.adjust_mana(adjusted_amount)

/datum/mana_pool/proc/start_transfer(datum/mana_pool/target_pool, force_process = FALSE)

	if (target_pool == src)
		stack_trace("start_transfer called where target_pool was src!")
		return MANA_POOL_CANNOT_TRANSFER

	if (!can_transfer(target_pool))
		return MANA_POOL_CANNOT_TRANSFER

	if (target_pool in transferring_to)
		return MANA_POOL_ALREADY_TRANSFERRING

	target_pool.incoming_transfer_start(src)

	RegisterSignal(target_pool, COMSIG_QDELETING, PROC_REF(stop_transfer), override = TRUE)

	if (force_process)
		transferring_to[target_pool] |= MANA_POOL_SKIP_NEXT_TRANSFER
		transfer_mana_to(target_pool) // you can potentially get all you need instantly

	return MANA_POOL_TRANSFER_START

/datum/mana_pool/proc/stop_transfer(datum/mana_pool/target_pool, forced = FALSE)
	SIGNAL_HANDLER

	if (!forced && !QDELETED(target_pool) && (transferring_to[target_pool] & MANA_POOL_SKIP_NEXT_TRANSFER))
		return MANA_POOL_TRANSFER_SKIP_ACTIVE // nope!

	transferring_to -= target_pool
	target_pool.incoming_transfer_end(src)

	UnregisterSignal(target_pool, COMSIG_QDELETING)

	update_processing_state()
	return MANA_POOL_TRANSFER_STOP

/datum/mana_pool/proc/incoming_transfer_start(datum/mana_pool/donator)
	transferring_from += donator

/datum/mana_pool/proc/incoming_transfer_end(datum/mana_pool/donator)
	transferring_from -= donator

/// The proc used to modify the mana composition of a mana pool.
/// Returns how much of "amount" was used.
/datum/mana_pool/proc/adjust_mana(amount, safe = FALSE)
	if (amount == 0)
		return amount

	var/result = 0
	if(!safe)
		result = clamp(src.amount + amount, 0, maximum_mana_capacity)
	else
		result = clamp(src.amount + amount, 0, get_safe_softcap())

	. = result - src.amount // Return the amount that was used
	src.amount = result
	if(parent && ismob(parent))
		var/mob/holder = parent
		SEND_SIGNAL(holder, COMSIG_LIVING_MANA_CHANGED, amount)
		var/datum/hud/human/hud_used = holder.hud_used
		if(hud_used?.mana)
			var/filled = round((src.amount / get_softcap()) * 100, 10)
			if(filled < 10)
				return
			filled = clamp(filled, 0, 120)
			hud_used.mana.icon_state = "mana[filled]"
	if(parent)
		SEND_SIGNAL(parent, COMSIG_MANA_POOL_ADJUSTED, result - src.amount)
	update_processing_state()

///this takes a string and adds it to our halters creates the list if it doesn't exist
/datum/mana_pool/proc/halt_mana_disperse(string)
	if(!decay_prevention)
		decay_prevention = list()
	decay_prevention |= string

///this takes a string and removes it from our halters returns early if empty
/datum/mana_pool/proc/restore_mana_disperse(string)
	if(!decay_prevention)
		return
	decay_prevention -= string

/datum/mana_pool/proc/can_transfer(datum/mana_pool/target_pool)
	SHOULD_BE_PURE(TRUE)

	return TRUE

/datum/mana_pool/proc/set_intrinsic_recharge(new_bitflags)
	var/old_flags = intrinsic_recharge_sources
	intrinsic_recharge_sources |= new_bitflags
	update_intrinsic_recharge(old_flags)
	update_processing_state()

/datum/mana_pool/proc/update_intrinsic_recharge(previous_recharge_sources = NONE)
	if (intrinsic_recharge_sources & MANA_ALL_LEYLINES)
		for (var/datum/mana_pool/leyline/entry as anything in (get_accessable_leylines() - src))

			if (entry.start_transfer(src) & MANA_POOL_ALREADY_TRANSFERRING)
				continue

			transferring_from[entry] |= MANA_POOL_INTRINSIC

	else if (previous_recharge_sources & MANA_ALL_LEYLINES)
		for (var/datum/mana_pool/leyline/entry in transferring_from)

			if (!(transferring_from[entry] & MANA_POOL_INTRINSIC))
				continue

			entry.stop_transfer(src)

	SEND_SIGNAL(src, COMSIG_MANA_POOL_INTRINSIC_RECHARGE_UPDATE, previous_recharge_sources)

/datum/mana_pool/proc/set_natural_recharge(new_value)
	ethereal_recharge_rate = new_value
	update_processing_state()

/datum/mana_pool/proc/set_max_mana(new_max, change_amount = FALSE, change_softcap = TRUE)
	var/percent = get_percent_to_max() //originally this was a duplicate redefinition- see change_amount
	var/softcap_increase = new_max - maximum_mana_capacity

	if (change_softcap)
		softcap += softcap_increase

	if (change_amount)
		percent = get_percent_to_max() // this used to be var/percent. why?
		amount = new_max * (percent / 100)

	maximum_mana_capacity = new_max

	if(parent && ismob(parent))
		var/mob/holder = parent
		var/datum/hud/human/hud_used = holder.hud_used
		if(hud_used?.mana)
			var/filled = round((src.amount / get_softcap()) * 100, 10)
			if(filled < 10)
				return
			filled = clamp(filled, 0, 120)
			hud_used.mana.icon_state = "mana[filled]"
		holder.mana_overload_threshold = maximum_mana_capacity * 0.9
	update_processing_state()

/datum/mana_pool/proc/get_percent_to_max()
	SHOULD_BE_PURE(TRUE)

	return (amount / maximum_mana_capacity) * 100

/datum/mana_pool/proc/get_percent_to_softcap()
	return (amount / get_softcap()) * 100

/datum/mana_pool/proc/get_percent_of_softcap_to_max()
	return (get_softcap() / maximum_mana_capacity) * 100

/datum/mana_pool/proc/get_softcap()
	var/mob/living/L = parent
	if(!istype(L) || !L.mind)
		return softcap

	var/skill_level = max(1, GET_MOB_SKILL_VALUE_OLD(L, /datum/attribute/skill/magic/arcane))
	return softcap + (skill_level * 100)

/datum/mana_pool/proc/get_safe_softcap()
	var/softcap = get_softcap()
	if(ismob(parent))
		var/mob/holder = parent
		return min(softcap, holder.mana_overload_threshold-50)
	else
		return softcap

///this is how a mana pool responds to backlash for most pools this is just taking damage
/datum/mana_pool/proc/mana_backlash(backlash_intensity)
	if(!backlash_intensity)
		return
	if(ismob(parent))
		switch(backlash_intensity)
			if(1 to 10)
				to_chat(parent, span_warning("I feel woozy after casting that spell."))
			if(10 to 30)
				to_chat(parent, span_danger("I feel sharp pains coursing through my body!"))
				parent:adjust_blood_volume(-backlash_intensity)
			if(30 to 50)
				parent.visible_message(span_danger("[parent] collapses as they vomit blood from the recoil."), span_danger("I feel my organs being ripped apart!"))
				parent:vomit(1, blood = TRUE, stun = FALSE)
		parent:apply_damage(backlash_intensity, BRUTE, BODY_ZONE_CHEST)
