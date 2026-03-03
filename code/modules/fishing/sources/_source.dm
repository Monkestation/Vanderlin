GLOBAL_LIST_INIT_TYPED(preset_fish_sources, /datum/fish_source, init_subtypes_w_path_keys(/datum/fish_source, list()))

/**
 * When adding new fishable rewards to a table/counts, you can specify an icon to show in place of the
 * generic fish icon in the minigame UI should the user have the TRAIT_REVEAL_FISH trait, by adding it to
 * this list.
 *
 * A lot of the icons here may be a tad inaccurate, but since we're limited to the free font awesome icons we
 * have access to, we got to make do.
 */
GLOBAL_LIST_INIT(specific_fish_icons, generate_specific_fish_icons())

/proc/generate_specific_fish_icons()
	var/list/return_list = zebra_typecacheof(list(
		/obj/effect/decal/remains = FISH_ICON_BONE,
		/obj/item/coin = FISH_ICON_COIN,
		/obj/item/reagent_containers/food/snacks/fish = FISH_ICON_DEF,
	))

	return_list[FISHING_RANDOM_SEED] = FISH_ICON_SEED
	return_list[FISHING_RANDOM_ORGAN] = FISH_ICON_ORGAN
	return_list[FISHING_VENDING_CHUCK] = FISH_ICON_COIN
	return return_list

/**
 * Where the fish actually come from - every fishing spot has one assigned but multiple fishing holes
 * can share single source, ie single shared one for ocean/lavaland river
 */
/datum/fish_source
	/**
	 * Fish catch weight table - these are relative weights
	 * Keys are fish type paths, values are base weights
	 */
	var/list/fish_table = list()
	/// If a key from fish_table is present here, that fish is availible in limited quantity and is reduced by one on successful fishing
	var/list/fish_counts = list()
	/// Any limited quantity stuff in this list will be readded to the counts after a while
	var/list/fish_count_regen = list()
	/// A list of stuff that's currently waiting to be readded to fish_counts
	var/list/currently_on_regen
	/// Text shown as baloon alert when you roll a dud in the table
	var/duds = list("it was nothing", "the hook is empty")
	/// Baseline difficulty for fishing in this spot. THIS IS ADDED TO THE DEFAULT DIFFICULTY OF THE MINIGAME (15)
	var/fishing_difficulty = FISHING_DEFAULT_DIFFICULTY
	/// How the spot type is described in fish catalog section about fish sources, will be skipped if null
	var/catalog_description
	/// Background image name from /datum/asset/simple/fishing_minigame
	var/background = "background_default"
	var/fish_source_flags = NONE
	/// If FISH_SOURCE_FLAG_EXPLOSIVE_MALUS is set, this will track of how much we're "exhausting" the system by bombing it repeatedly.
	var/explosive_fishing_score = 0
	///When linked to a fishing portal, this will be the icon_state of this option in the radial menu
	var/radial_state = "default"
	///When selected by the fishing portal, this will be the icon_state of the overlay shown on the machine.
	var/overlay_state = "portal_aquarium"
	///If set, this overrides the upper and lower bounds of how long you should wait during the waiting phase of the minigame.
	var/list/wait_time_range

	/// Mindless mobs that can fish will never pull up items on this list
	var/static/list/profound_fisher_blacklist = list()

	///List of multipliers used to make fishes more common compared to everything else depending on bait quality, indexed from best to worst.
	var/static/weight_result_multiplier = list(
		TRAIT_GREAT_QUALITY_BAIT = 9,
		TRAIT_GOOD_QUALITY_BAIT = 3.5,
		TRAIT_BASIC_QUALITY_BAIT = 2,
	)
	///List of exponents used to level out the table weight differences between fish depending on bait quality.
	var/static/weight_leveling_exponents = list(
		TRAIT_GREAT_QUALITY_BAIT = 0.7,
		TRAIT_GOOD_QUALITY_BAIT = 0.55,
		TRAIT_BASIC_QUALITY_BAIT = 0.4,
	)

	//If set, fish types native to this source won't die if left on these turfs.
	var/list/associated_safe_turfs
	//list of subtypes of associated safe turfs that are NOT safe
	var/list/safe_turfs_blacklist

	/// Pool of generated fish instances for this roll (fish instance -> original path)
	var/list/obj/item/reagent_containers/food/snacks/fish/generated_fish_pool

/datum/fish_source/New()
	if(!SSfishing.initialized && associated_safe_turfs) //This is only needed during world init
		associated_safe_turfs = typecacheof(associated_safe_turfs)
		if(safe_turfs_blacklist)
			associated_safe_turfs -= typecacheof(safe_turfs_blacklist)
	for(var/path in fish_counts)
		if(!(path in fish_table))
			stack_trace("path [path] found in the 'fish_counts' list but not in the 'fish_table'")
	if(wait_time_range && length(wait_time_range) != 2)
		stack_trace("wait_time_range for [type] is set but has length different than two")
	for(var/path in fish_counts) //we give anything unique an auto 30 min regen, that way if the round is extended you still get content.
		if (!(path in fish_count_regen))
			fish_count_regen[path] = 30 MINUTES

/datum/fish_source/Destroy()
	if(explosive_fishing_score)
		STOP_PROCESSING(SSprocessing, src)
	cleanup_generated_fish()
	return ..()

/// Cleans up any generated fish instances from the pool
/datum/fish_source/proc/cleanup_generated_fish()
	if(!generated_fish_pool)
		return
	for(var/obj/item/reagent_containers/food/snacks/fish/fish in generated_fish_pool)
		if(!QDELETED(fish))
			qdel(fish)
	generated_fish_pool = null

/// Generates a randomized fish instance from a path for filtering/checking
/datum/fish_source/proc/generate_fish_instance(fish_path)
	if(!ispath(fish_path, /obj/item/reagent_containers/food/snacks/fish))
		return null

	var/obj/item/reagent_containers/food/snacks/fish/fish = new fish_path()
	fish.randomize_size_and_weight()

	// Store in pool for cleanup and tracking
	if(!generated_fish_pool)
		generated_fish_pool = list()
	generated_fish_pool[fish] = fish_path

	return fish

/// Gets the original path of a generated fish instance
/datum/fish_source/proc/get_fish_path(atom/fish_or_path)
	if(isfish(fish_or_path))
		// Check if it's one of our generated instances
		if(generated_fish_pool?[fish_or_path])
			return generated_fish_pool[fish_or_path]
		return fish_or_path.type
	return fish_or_path

///Called when src is set as the fish source of a fishing spot component
/datum/fish_source/proc/on_fishing_spot_init(datum/component/fishing_spot/spot)
	return

///Called whenever a fishing spot with this fish source attached is deleted
/datum/fish_source/proc/on_fishing_spot_del(datum/component/fishing_spot/spot)

/// Can we fish in this spot at all. Returns DENIAL_REASON or null if we're good to go
/datum/fish_source/proc/reason_we_cant_fish(obj/item/fishingrod/rod, mob/fisherman, atom/parent)
	return rod.reason_we_cant_fish(src)

/// Called below above proc, in case the fishing source has anything to do that isn't denial
/datum/fish_source/proc/on_start_fishing(obj/item/fishingrod/rod, mob/fisherman, atom/parent)
	return

///Comsig proc from the fishing minigame for 'calculate_difficulty'
/datum/fish_source/proc/calculate_difficulty_minigame(datum/fishing_challenge/challenge, reward_path, obj/item/fishingrod/rod, mob/fisherman, list/difficulty_holder)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	difficulty_holder[1] += calculate_difficulty(reward_path, rod, fisherman)

	// Difficulty modifier added by the fisher's skill level
	if(!(challenge.special_effects & FISHING_MINIGAME_RULE_NO_EXP))
		var/skill_level = fisherman.get_skill_level(/datum/skill/labor/fishing)

		switch(skill_level)
			if(0)
				difficulty_holder[1] += 1
			if(1)
				difficulty_holder[1] += 0
			if(2)
				difficulty_holder[1] += -1
			if(3)
				difficulty_holder[1] += -3
			if(4)
				difficulty_holder[1] += -5
			if(5)
				difficulty_holder[1] += -7
			if(6)
				difficulty_holder[1] += -10

	if(challenge.special_effects & FISHING_MINIGAME_RULE_KILL)
		challenge.RegisterSignal(src, COMSIG_FISH_SOURCE_REWARD_DISPENSED, TYPE_PROC_REF(/datum/fishing_challenge, hurt_fish))

/**
 * Calculates the difficulty of the minigame:
 *
 * This includes the source's fishing difficulty, that of the fish, the rod,
 * favorite and disliked baits, fish traits and the fisherman skill.
 *
 * For non-fish, it's just the source's fishing difficulty minus the fisherman skill.
 */
/datum/fish_source/proc/calculate_difficulty(result, obj/item/fishingrod/rod, mob/fisherman)
	. = fishing_difficulty

	// Difficulty modifier added by having the Settler quirk
	if(HAS_TRAIT(fisherman, TRAIT_EXPERT_FISHER))
		. += EXPERT_FISHER_DIFFICULTY_MOD

	// Difficulty modifier added by the rod
	. += rod.difficulty_modifier

	// If it's a fish instance from our pool, use it directly
	var/obj/item/reagent_containers/food/snacks/fish/caught_fish
	if(isfish(result) && generated_fish_pool?[result])
		caught_fish = result
	else if(!ispath(result, /obj/item/reagent_containers/food/snacks/fish))
		// In the future non-fish rewards can have variable difficulty calculated here
		return
	else
		// Generate a temporary instance for difficulty calculation
		caught_fish = generate_fish_instance(result)
		if(!caught_fish)
			return

	var/result_path = get_fish_path(result)

	// Baseline fish difficulty
	. += caught_fish.fishing_difficulty_modifier

	var/list/fish_properties = SSfishing.fish_properties[result_path]
	if(rod.baited)
		var/obj/item/bait = rod.baited
		//Fav bait makes it easier
		var/list/fav_bait = fish_properties[FISH_PROPERTIES_FAV_BAIT]
		for(var/bait_identifer in fav_bait)
			if(is_matching_bait(bait, bait_identifer))
				. += FAV_BAIT_DIFFICULTY_MOD
		//Disliked bait makes it harder
		var/list/disliked_bait = fish_properties[FISH_PROPERTIES_BAD_BAIT]
		for(var/bait_identifer in disliked_bait)
			if(is_matching_bait(bait, bait_identifer))
				. += DISLIKED_BAIT_DIFFICULTY_MOD

	// Matching/not matching fish traits and equipment
	var/list/fish_traits = caught_fish.fish_traits

	var/additive_mod = 0
	var/multiplicative_mod = 1
	for(var/fish_trait in fish_traits)
		var/datum/fish_trait/trait = GLOB.fish_traits[fish_trait]
		var/list/mod = trait.difficulty_mod(rod, fisherman)
		additive_mod += mod[ADDITIVE_FISHING_MOD]
		multiplicative_mod *= mod[MULTIPLICATIVE_FISHING_MOD]

	. += additive_mod
	. *= multiplicative_mod


///Comsig proc from the fishing minigame for 'roll_reward'
/datum/fish_source/proc/roll_reward_minigame(datum/source, obj/item/fishingrod/rod, mob/fisherman, atom/location, list/rewards)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	rewards += roll_reward(rod, fisherman, location)

/// Returns a fish instance or another special value which we use for dispensing a reward later.
/datum/fish_source/proc/roll_reward(obj/item/fishingrod/rod, mob/fisherman, atom/location)
	return pickweight(get_modified_fish_table(rod, fisherman, location)) || FISHING_DUD

/// Version of roll_reward() that blacklists objects that shouldn't be caught by ai-controlled mobs.
/datum/fish_source/proc/roll_mindless_reward(obj/item/fishingrod/rod, mob/fisherman, atom/location)
	var/list/final_table = get_modified_fish_table(rod, fisherman, location)
	final_table -= profound_fisher_blacklist
	return pickweight(final_table) || FISHING_DUD

/**
 * Used to register signals or add traits and the such right after conditions have been cleared
 * and before the minigame starts.
 */
/datum/fish_source/proc/pre_challenge_started(obj/item/fishingrod/rod, mob/user, datum/fishing_challenge/challenge)
	return

///Proc called when the challenge is interrupted within the fish source code.
/datum/fish_source/proc/interrupt_challenge(reason)
	SEND_SIGNAL(src, COMSIG_FISHING_SOURCE_INTERRUPT_CHALLENGE, reason)

/**
 * Proc called when the COMSIG_MOB_COMPLETE_FISHING signal is sent.
 * Check if we've succeeded. If so, write into memory and dispense the reward.
 */
/datum/fish_source/proc/on_challenge_completed(mob/user, datum/fishing_challenge/challenge, success)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(user, COMSIG_MOB_COMPLETE_FISHING)
	if(!success)
		cleanup_generated_fish() // Clean up fish pool on failure
		return
	var/atom/movable/reward = dispense_reward(challenge.reward_path, user, challenge.location, challenge.used_rod)
	SEND_SIGNAL(challenge.used_rod, COMSIG_FISHING_ROD_CAUGHT_FISH, reward, user)
	challenge.used_rod.on_reward_caught(reward, user)
	cleanup_generated_fish() // Clean up remaining fish pool after dispensing

/// Gives out the reward if possible
/datum/fish_source/proc/dispense_reward(reward_path, mob/fisherman, atom/fishing_spot, obj/item/fishingrod/rod)
	var/atom/movable/reward = simple_dispense_reward(reward_path, get_turf(fisherman), fishing_spot)
	if(!reward) //balloon alert instead
		fisherman.balloon_alert(fisherman, pick(duds))
		return
	if(isitem(reward)) //Try to put it in hand
		INVOKE_ASYNC(fisherman, TYPE_PROC_REF(/mob, put_in_hands), reward)
	else if(istype(reward, /obj/effect/spawner)) // Do not attempt to forceMove() a spawner. It will break things, and the spawned item should already be at the mob's turf by now.
		fisherman.balloon_alert(fisherman, "caught something!")
		return
	fisherman.balloon_alert(fisherman, "caught [reward]!")
	return reward

///Simplified version of dispense_reward that doesn't need a fisherman.
/datum/fish_source/proc/simple_dispense_reward(reward_path, atom/spawn_location, atom/fishing_spot)
	if(isnull(reward_path))
		return null

	var/count_key = get_fish_path(reward_path)

	if(!isnull(fish_counts[count_key])) // This is limited count result
		//Somehow, we're trying to spawn an expended reward.
		if(fish_counts[count_key] <= 0)
			return null
		fish_counts[count_key] -= 1
		var/regen_time = fish_count_regen?[count_key]
		if(regen_time)
			LAZYADDASSOC(currently_on_regen, count_key, 1)
			if(currently_on_regen[count_key] == 1)
				addtimer(CALLBACK(src, PROC_REF(regen_count), count_key), regen_time)

	var/atom/movable/reward = spawn_reward(reward_path, spawn_location, fishing_spot)
	SEND_SIGNAL(src, COMSIG_FISH_SOURCE_REWARD_DISPENSED, reward)
	return reward

/datum/fish_source/proc/regen_count(reward_path)
	if(!LAZYACCESS(currently_on_regen, reward_path))
		return
	fish_counts[reward_path] += 1
	currently_on_regen[reward_path] -= 1
	if(currently_on_regen[reward_path] <= 0)
		LAZYREMOVE(currently_on_regen, reward_path)
		return
	var/regen_time = fish_count_regen[reward_path]
	addtimer(CALLBACK(src, PROC_REF(regen_count), reward_path), regen_time)

/// Spawns a reward from a fish instance or path right where the fisherman is. Part of the dispense_reward() logic.
/datum/fish_source/proc/spawn_reward(reward_path, atom/spawn_location, atom/fishing_spot)
	if(reward_path == FISHING_DUD)
		return

	// If it's one of our generated fish instances, move it to the world
	if(isfish(reward_path) && generated_fish_pool?[reward_path])
		var/obj/item/reagent_containers/food/snacks/fish/fish = reward_path
		// Remove from pool so it doesn't get cleaned up
		generated_fish_pool -= fish
		fish.forceMove(spawn_location)
		return fish

	if(ismovable(reward_path))
		var/atom/movable/reward = reward_path
		reward.forceMove(spawn_location)
		return reward
	if(!ispath(reward_path, /atom/movable))
		CRASH("Unsupported /datum path [reward_path] passed to fish_source/proc/spawn_reward()")
	var/atom/movable/reward = new reward_path(spawn_location)
	if(isfish(reward))
		var/obj/item/reagent_containers/food/snacks/fish/caught_fish = reward
		caught_fish.randomize_size_and_weight()
	return reward

/// Returns the fish table, with the unavailable items from fish_counts removed.
/datum/fish_source/proc/get_fish_table(atom/location, from_explosion = FALSE)
	var/list/table = fish_table.Copy()
	for(var/result in table)
		if(!isnull(fish_counts[result]) && fish_counts[result] <= 0)
			table -= result
	return table

/// Builds a fish weights table modified by bait/rod/user properties
/datum/fish_source/proc/get_modified_fish_table(obj/item/fishingrod/rod, mob/fisherman, atom/location)
	// Clean up any previous fish pool
	cleanup_generated_fish()

	var/obj/item/bait = rod.baited
	///An exponent used to level out the table weight differences between fish depending on bait quality.
	var/leveling_exponent = 0
	///Multiplier used to make fishes more common compared to everything else.
	var/result_multiplier = 1

	var/list/base_table = get_fish_table(location)
	var/list/final_table = list()

	if(bait)
		for(var/trait in weight_result_multiplier)
			if(HAS_TRAIT(bait, trait))
				result_multiplier = weight_result_multiplier[trait]
				leveling_exponent = weight_leveling_exponents[trait]
				break

	if(HAS_TRAIT(rod, TRAIT_ROD_REMOVE_FISHING_DUD))
		base_table -= FISHING_DUD

	// Generate fish instances and build the weighted table
	for(var/result in base_table)
		var/weight = base_table[result]

		// Apply hook bonuses first
		weight *= rod.hook.get_hook_bonus_multiplicative(result)
		weight += rod.hook.get_hook_bonus_additive(result)

		// Handle living mobs
		if(ispath(result, /mob/living) && bait && (HAS_TRAIT(bait, TRAIT_GOOD_QUALITY_BAIT) || HAS_TRAIT(bait, TRAIT_GREAT_QUALITY_BAIT)))
			weight = round(weight * result_multiplier, 1)
			if(weight > 0)
				final_table[result] = weight
			continue

		// Handle fish - generate instance for property-based filtering
		if(ispath(result, /obj/item/reagent_containers/food/snacks/fish))
			var/obj/item/reagent_containers/food/snacks/fish/fish = generate_fish_instance(result)
			if(!fish)
				continue

			if(bait)
				weight = round(weight * result_multiplier, 1)
				var/mult = bait.check_bait(fish)
				weight = round(weight * mult, 1)
				if(mult > 1 && HAS_TRAIT(bait, TRAIT_BAIT_ALLOW_FISHING_DUD))
					final_table -= FISHING_DUD
			else
				weight = round(weight * FISH_WEIGHT_MULT_WITHOUT_BAIT, 1) //Fishing without bait is not going to be easy

			// Apply fish trait modifiers using the actual fish instance
			weight = get_fish_trait_catch_mods(weight, fish, rod, fisherman, location)

			if(weight > 0)
				// Use the fish instance as the key instead of the path
				final_table[fish] = weight
		else
			// Non-fish items
			if(weight > 0)
				final_table[result] = weight

	if(leveling_exponent)
		level_out_fish(final_table, leveling_exponent)

	return final_table

///A proc that levels out the weights of various fish, leading to rarer fishes being more common.
/datum/fish_source/proc/level_out_fish(list/table, exponent)
	var/highest_fish_weight
	var/list/collected_fish_weights = list()
	for(var/fishable in table)
		if(!isfish(fishable))
			continue
		var/fish_weight = table[fishable]
		collected_fish_weights[fishable] = fish_weight
		if(fish_weight > highest_fish_weight)
			highest_fish_weight = fish_weight

	for(var/fish in collected_fish_weights)
		var/difference = highest_fish_weight - collected_fish_weights[fish]
		if(!difference)
			continue
		table[fish] += round(difference**exponent, 1)

/datum/fish_source/proc/get_fish_trait_catch_mods(weight, obj/item/reagent_containers/food/snacks/fish/fish, obj/item/fishingrod/rod, mob/user, atom/location)
	if(!fish)
		return weight

	var/multiplier = 1
	var/list/fish_traits = fish.fish_traits
	var/result_path = get_fish_path(fish)

	for(var/fish_trait in fish_traits)
		var/datum/fish_trait/trait = GLOB.fish_traits[fish_trait]
		var/list/mod = trait.catch_weight_mod(rod, user, location, result_path)
		weight += mod[ADDITIVE_FISHING_MOD]
		multiplier *= mod[MULTIPLICATIVE_FISHING_MOD]

	return round(weight * multiplier, 1)

///returns true if this fishing spot has fish that are shown in the catalog.
/datum/fish_source/proc/has_known_fishes(atom/location)
	var/show_anyway = fish_source_flags & FISH_SOURCE_FLAG_IGNORE_HIDDEN_ON_CATALOG
	for(var/reward in get_fish_table(location))
		if(!ispath(reward, /obj/item/reagent_containers/food/snacks/fish))
			continue
		var/obj/item/reagent_containers/food/snacks/fish/prototype = reward
		if(!show_anyway && initial(prototype.fish_flags) & FISH_FLAG_SHOW_IN_CATALOG)
			return TRUE
	return FALSE

///Add a string with the names of catchable fishes to the examine text.
/datum/fish_source/proc/get_catchable_fish_names(mob/user, atom/location, list/examine_text)
	var/list/known_fishes = list()
	var/show_anyway = fish_source_flags & FISH_SOURCE_FLAG_IGNORE_HIDDEN_ON_CATALOG

	var/obj/item/fishingrod/rod = user.get_active_held_item()
	var/list/final_table
	if(!istype(rod) || !rod.hook)
		rod = null
	else
		final_table = get_modified_fish_table(rod, user, location)

	var/total_weight = 0
	var/list/rodless_weights = list()
	var/total_rod_weight = 0
	var/list/rod_weights = list()
	var/list/table = get_fish_table(location)
	for(var/reward in table)
		var/weight = table[reward]
		if(!ispath(reward, /obj/item/reagent_containers/food/snacks/fish))
			continue

		var/obj/item/reagent_containers/food/snacks/fish/prototype = reward
		if(!show_anyway && !(initial(prototype.fish_flags) & FISH_FLAG_SHOW_IN_CATALOG))
			continue

		if(rod)
			// Find the matching fish instance in the final table
			var/final_weight = 0
			for(var/fish_instance in final_table)
				if(isfish(fish_instance) && get_fish_path(fish_instance) == reward)
					final_weight = final_table[fish_instance]
					break

			total_weight += weight
			total_rod_weight += final_weight
			rodless_weights[reward] = weight
			rod_weights[reward] = final_weight
		else
			known_fishes += initial(prototype.name)

	if(rod)
		for(var/reward in rodless_weights)
			var/percent_weight = rodless_weights[reward] / total_weight
			var/percent_rod_weight = rod_weights[reward] / total_rod_weight
			var/obj/item/reagent_containers/food/snacks/fish/prototype = reward
			var/init_name = initial(prototype.name)
			var/ratio = percent_rod_weight ? percent_weight/percent_rod_weight : INFINITY
			if(ratio < 0.9)
				init_name = span_bold(init_name)
				if(ratio < 0.3)
					init_name = "<u>[init_name]</u>"
			else if(ratio > 1.1)
				init_name = span_small(init_name)
			known_fishes += init_name

		// Clean up the fish pool after examination
		cleanup_generated_fish()

	if(!length(known_fishes))
		return

	var/info = "You can catch the following fish here"

	if(rod)
		info = span_tooltip("In bold are fish you're more likely to catch with the current setup. The opposite is true for the smaller font", info)
	examine_text += span_info("[info]: [english_list(known_fishes)].")

///How much the explosive_fishing_score impacts explosive fishing. The higher the value, the stronger the malus for repeated calls
#define EXPLOSIVE_FISHING_MALUS_EXPONENT 0.55
///How much the explosive_fishing_score is reduced each second.
#define EXPLOSIVE_FISHING_RECOVERY_RATE 0.18

/datum/fish_source/proc/spawn_reward_from_explosion(atom/location, severity)
	SIGNAL_HANDLER
	if(fish_source_flags & FISH_SOURCE_FLAG_EXPLOSIVE_NONE)
		return
	var/multiplier = 1
	if(fish_source_flags & FISH_SOURCE_FLAG_EXPLOSIVE_MALUS)
		if(explosive_fishing_score <= 0)
			explosive_fishing_score = 1
			START_PROCESSING(SSprocessing, src)
		else
			explosive_fishing_score++
			multiplier = explosive_fishing_score**-EXPLOSIVE_FISHING_MALUS_EXPONENT
	for(var/i in 1 to (severity + 2))
		if(!prob((100 + 100 * severity)/i * multiplier))
			continue
		var/reward_loot = pickweight(get_fish_table(location, from_explosion = TRUE))
		var/atom/spawn_location = isturf(location) ? location : location.drop_location()
		var/atom/movable/reward = simple_dispense_reward(reward_loot, spawn_location, location)
		if(isnull(reward))
			continue
		if(isfish(reward))
			var/obj/item/reagent_containers/food/snacks/fish/fish = reward
			fish.set_status(FISH_DEAD, silent = TRUE)
		if(isitem(reward))
			reward.pixel_x = rand(-9, 9)
			reward.pixel_y = rand(-9, 9)
		if(severity >= EXPLODE_DEVASTATE)
			reward.ex_act(EXPLODE_LIGHT)

/datum/fish_source/process(seconds_per_tick)
	explosive_fishing_score -= EXPLOSIVE_FISHING_RECOVERY_RATE * seconds_per_tick
	if(explosive_fishing_score <= 0)
		STOP_PROCESSING(SSprocessing, src)
		explosive_fishing_score = 0

#undef EXPLOSIVE_FISHING_MALUS_EXPONENT
#undef EXPLOSIVE_FISHING_RECOVERY_RATE

///Called when releasing a fish in a fishing spot with the TRAIT_CATCH_AND_RELEASE trait.
/datum/fish_source/proc/readd_fish(atom/location, obj/item/reagent_containers/food/snacks/fish/fish, mob/living/releaser)
	var/fish_path = fish.type
	//don't do anything if the fish is dead, not native to this fish source or has no limited amount.
	if(fish.status == FISH_DEAD || isnull(fish_table[fish_path]) || isnull(fish_counts[fish_path]))
		return
	//If this fish population isn't recovering from recent losses, we just increase it.
	if(!LAZYACCESS(currently_on_regen, fish_path))
		fish_counts[fish_path] += 1
	else
		regen_count(fish_path)
