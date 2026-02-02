/obj/item/fishing/hook
	attachtype = "hook"
	/// A bitfield of traits that this fishing hook has, checked by fish traits and the minigame
	var/fishing_hook_traits
	/// icon state added to main rod icon when this hook is equipped
	var/rod_overlay_icon_state = "hook_overlay"


/**
 * Simple getter proc for hooks to implement special hook bonuses for
 * certain `fish_type` (or FISHING_DUD), additive. Is applied after
 * `get_hook_bonus_multiplicative()`.
 */
/obj/item/fishing/hook/proc/get_hook_bonus_additive(fish_type)
	return FISHING_DEFAULT_HOOK_BONUS_ADDITIVE


/**
 * Simple getter proc for hooks to implement special hook bonuses for
 * certain `fish_type` (or FISHING_DUD), multiplicative. Is applied before
 * `get_hook_bonus_additive()`.
 */
/obj/item/fishing/hook/proc/get_hook_bonus_multiplicative(fish_type)
	return FISHING_DEFAULT_HOOK_BONUS_MULTIPLICATIVE

///Check if tha target can be caught by the hook
/obj/item/fishing/hook/proc/can_be_hooked(atom/target)
	if(ishuman(target))
		return istriton(target)
	return isitem(target)

///Any special effect when hooking a target that's not managed by the fishing rod.
/obj/item/fishing/hook/proc/hook_attached(atom/target, obj/item/fishingrod/rod)
	return

/**
 * Is there a reason why this hook couldn't fish in target_fish_source?
 * If so, return the denial reason as a string, otherwise return `null`.
 *
 * Arguments:
 * * target_fish_source - The /datum/fish_source we're trying to fish in.
 */
/obj/item/fishing/hook/proc/reason_we_cant_fish(datum/fish_source/target_fish_source)
	return null

/**
 * Helper proc to get the size ratio of a fish compared to its average
 * Returns a value like 0.8 (80% of average), 1.0 (average), 1.5 (150% of average)
 */
/obj/item/fishing/hook/proc/get_fish_size_ratio(fish_type_or_instance)
	if(!isfish(fish_type_or_instance))
		return 1.0

	var/obj/item/reagent_containers/food/snacks/fish/fish = fish_type_or_instance
	var/average = fish.average_size

	if(average <= 0)
		return 1.0

	return fish.size / average


/obj/item/fishing/hook/wooden
	name = "wooden fishing hook"
	desc = "A fishing hook consisting of a small piece of wood, carved to points on both ends. More likely to fall out. Struggles with larger specimens."
	icon_state = "gorgehook"
	rod_overlay_icon_state = "hook_wooden_overlay"

/obj/item/fishing/hook/wooden/get_hook_bonus_additive(fish_type)
	return -1 // hookmod = -1

/obj/item/fishing/hook/wooden/get_hook_bonus_multiplicative(fish_type)
	var/multiplier = ..()

	if(!isfish(fish_type))
		return multiplier

	var/size_ratio = get_fish_size_ratio(fish_type)

	// Penalties for larger-than-average fish
	// 100-130% of average: 0.75x
	// 130%+ of average: 0.5x
	if(size_ratio >= 1.3)
		multiplier *= 0.5
	else if(size_ratio >= 1.0)
		multiplier *= 0.75

	return multiplier

/obj/item/fishing/hook/thorn
	name = "thorn fishing hook"
	desc = "A fishing hook carved out of a thorn. Effective, but fragile, the barbs kill the fish, but prevent it from ever getting away."
	icon_state = "thornhook"
	rod_overlay_icon_state = "hook_thorn_overlay"
	fishing_hook_traits = FISHING_HOOK_NO_ESCAPE|FISHING_HOOK_KILL

/obj/item/fishing/hook/iron
	name = "iron fishing hook"
	desc = "An iron fishing hook. Reliable."
	icon_state = "ironhook"
	fishing_hook_traits = FISHING_HOOK_WEIGHTED
	rod_overlay_icon_state = "hook_weighted_overlay"

/obj/item/fishing/hook/deluxe
	name = "wooden lure"
	desc = "A small wooden lure, painted to look like a small fish. Scares off smaller specimens but attracts larger ones."
	icon_state = "deluxehook"
	fishing_hook_traits = FISHING_HOOK_BIDIRECTIONAL
	rod_overlay_icon_state = "hook_deluxe_overlay"

/obj/item/fishing/hook/deluxe/get_hook_bonus_multiplicative(fish_type)
	var/multiplier = ..()

	if(!isfish(fish_type))
		return multiplier

	var/size_ratio = get_fish_size_ratio(fish_type)

	// Penalties for smaller-than-average, bonuses for larger
	// <60% of average: 0.25x (severe penalty for runts)
	// 60-80% of average: 0.5x (penalty for small)
	// 80-100% of average: 0.75x (mild penalty for below average)
	// 100-130% of average: 1.0x (neutral)
	// 130%+ of average: 1.5x (bonus for big specimens)

	if(size_ratio < 0.6)
		multiplier *= 0.25
	else if(size_ratio < 0.8)
		multiplier *= 0.5
	else if(size_ratio < 1.0)
		multiplier *= 0.75
	else if(size_ratio >= 1.3)
		multiplier *= 1.5

	return multiplier
