/// Checks if the bait is liked by the fish type or not. Returns a multiplier that affects the chance of catching it.
/obj/item/proc/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	if(HAS_TRAIT(src, TRAIT_OMNI_BAIT))
		return 1
	var/catch_multiplier = 1

	var/list/properties = SSfishing.fish_properties[isfish(fish) ? fish.type : fish]
	//Bait matching likes doubles the chance
	var/list/fav_bait = properties[FISH_PROPERTIES_FAV_BAIT]
	for(var/bait_identifer in fav_bait)
		if(is_matching_bait(src, bait_identifer))
			catch_multiplier *= 2
	//Bait matching dislikes
	var/list/disliked_bait = properties[FISH_PROPERTIES_BAD_BAIT]
	for(var/bait_identifer in disliked_bait)
		if(is_matching_bait(src, bait_identifer))
			catch_multiplier *= 0.5
	return catch_multiplier

/obj/effect/spawner/map_spawner/random_lure
	lootmin = 3
	lootmax = 5

/obj/effect/spawner/map_spawner/random_lure/Initialize(mapload)
	spawned = subtypesof(/obj/item/fishing/lure)
	for(var/path in spawned)
		spawned[path] = 1
	. = ..()

/obj/item/fishing/lure
	name = "fishing lure"
	desc = "It's just that, a plastic piece of fishing equipment, yet fish yearn with every last molecule of their bodies to take a bite of it."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "minnow"
	w_class = WEIGHT_CLASS_SMALL
	/**
	 * A list with two keys delimiting the spinning interval in which a mouse click has to be pressed while fishing.
	 * This is passed down to the fishing rod, and then to the lure during the minigame.
	 */
	var/spin_frequency = list(2 SECONDS, 3 SECONDS)
	var/consumable = FALSE

/obj/item/fishing/lure/Initialize(mapload)
	. = ..()
	add_traits(list(TRAIT_FISHING_BAIT, TRAIT_BAIT_ALLOW_FISHING_DUD, TRAIT_OMNI_BAIT), INNATE_TRAIT)
	if(!consumable)
		ADD_TRAIT(src, TRAIT_BAIT_UNCONSUMABLE, INNATE_TRAIT)
	RegisterSignal(src, COMSIG_ITEM_FISHING_ROD_SLOTTED, PROC_REF(on_fishingrod_slotted))
	RegisterSignal(src, COMSIG_ITEM_FISHING_ROD_UNSLOTTED, PROC_REF(on_fishingrod_unslotted))

/obj/item/fishing/lure/proc/on_fishingrod_slotted(datum/source, obj/item/fishingrod/rod, slot)
	SIGNAL_HANDLER
	rod.spin_frequency = spin_frequency

/obj/item/fishing/lure/proc/on_fishingrod_unslotted(datum/source, obj/item/fishingrod/rod, slot)
	SIGNAL_HANDLER
	rod.spin_frequency = null

///Called for every fish subtype by the fishing subsystem when initializing, to populate the list of fish that can be catched with this lure.
/obj/item/fishing/lure/proc/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	return TRUE

/obj/item/fishing/lure/examine(mob/user)
	. = ..()
	. += span_info("It has to be spun with a frequency of [spin_frequency[1] * 0.1] to [spin_frequency[2] * 0.1] seconds while fishing.")
	if(HAS_MIND_TRAIT(user, TRAIT_EXAMINE_FISHING_SPOT))
		. += span_tinynotice("Thanks to your experience, you can examine it again to get a list of fish you can catch with it.")

///Check if the fish is in the list of catchable fish for this fishing lure. Return value is a multiplier.
/obj/item/fishing/lure/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = 0
	var/is_instance = istype(fish)
	var/list/fish_properties = SSfishing.fish_properties[is_instance ? fish.type : fish]
	if(is_type_in_list(/obj/item/fishing/lure, fish_properties[FISH_PROPERTIES_FAV_BAIT]))
		multiplier += 2
	if(is_instance)
		if(is_catchable_fish(fish, fish_properties))
			multiplier += 10
	else if(fish in SSfishing.lure_catchables[type])
		multiplier += 10
	return multiplier

/obj/item/fishing/lure/minnow
	name = "artificial minnow"
	desc = "A fishing lure that may attract small fish. Too tiny, too large, or too picky prey won't be interested in it, though."
	icon_state = "minnow"

/obj/item/fishing/lure/minnow/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Bonus for small fish (preferred target)
	if(fish.size <= fish.average_size * 0.8)
		multiplier *= 1.5

	// Slight penalty for picky/vegan but still catchable
	if(length(list(/datum/fish_trait/vegan, /datum/fish_trait/picky_eater) & fish.fish_traits))
		multiplier *= 0.7

	return multiplier

/obj/item/fishing/lure/plug
	name = "artificial plug lure"
	desc = "A bigger fishing lure that may attract larger fish. Tiny or picky prey will remain uninterested."
	icon_state = "plug"

/obj/item/fishing/lure/plug/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Base catchable: anything not tiny
	if(fish.size < fish.average_size * 0.75)
		return FALSE
	// Exclude only extreme specialists
	if(/datum/fish_trait/heavy in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/lure/plug/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Bonus for large fish (preferred target)
	if(fish.size > FISH_SIZE_SMALL_MAX)
		multiplier *= 1.5

	// Slight penalty for picky/vegan but still catchable
	if(length(list(/datum/fish_trait/vegan, /datum/fish_trait/picky_eater) & fish.fish_traits))
		multiplier *= 0.7

	return multiplier

/obj/item/fishing/lure/spoon
	name = "\improper Indy spoon lure"
	desc = "A lustrous piece of metal mimicking the scales of a fish. It specializes in catching small-to-medium-sized fish that live in freshwater."
	icon_state = "spoon"
	spin_frequency = list(1.25 SECONDS, 2.25 SECONDS)

/obj/item/fishing/lure/spoon/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Can catch anything that's not extreme
	if(fish.size < fish.average_size * 0.5 || fish.size > fish.average_size * 1.7)
		return FALSE
	if(/datum/fish_trait/heavy in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/lure/spoon/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Bonus for freshwater fish (preferred target)
	var/fluid_type = fish.required_fluid_type
	if(fluid_type == FISH_FLUID_FRESHWATER || fluid_type == FISH_FLUID_ANADROMOUS || fluid_type == FISH_FLUID_ANY_WATER)
		multiplier *= 1.5

	// Slight penalty for picky/vegan/nocturnal but still catchable
	if(length(list(/datum/fish_trait/vegan, /datum/fish_trait/picky_eater, /datum/fish_trait/nocturnal) & fish.fish_traits))
		multiplier *= 0.8

	return multiplier

/obj/item/fishing/lure/artificial_fly
	name = "\improper Silkbuzz artificial fly"
	desc = "A fishing lure resembling a large wooly fly. Unlike most other lures, it's fancy enough to catch the interest of picky fish, but only those."
	icon_state = "artificial_fly"
	spin_frequency = list(1.1 SECONDS, 2 SECONDS)

/obj/item/fishing/lure/artificial_fly/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Can catch most fish, excluding extremes
	if(fish.size > fish.average_size * 1.6)
		return FALSE
	if(/datum/fish_trait/heavy in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/lure/artificial_fly/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Big bonus for picky eaters (main target)
	if(/datum/fish_trait/picky_eater in fish.fish_traits)
		multiplier *= 2
	else
		// Mild penalty for non-picky fish
		multiplier *= 0.6

	return multiplier

/obj/item/fishing/lure/led
	name = "\improper glowing fishing lure"
	desc = "A heavy, waterproof and fish-looking magical stick, specialized to catch only nocturnal and deep-dwelling fish."
	icon_state = "led"
	spin_frequency = list(3 SECONDS, 3.8 SECONDS)

/obj/item/fishing/lure/led/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/fishing/lure/led/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "led_emissive", src)

/obj/item/fishing/lure/led/on_fishingrod_slotted(obj/item/fishingrod/rod, slot)
	. = ..()
	ADD_TRAIT(rod, TRAIT_ROD_IGNORE_ENVIRONMENT, type)

/obj/item/fishing/lure/led/on_fishingrod_unslotted(obj/item/fishingrod/rod, slot)
	. = ..()
	REMOVE_TRAIT(rod, TRAIT_ROD_IGNORE_ENVIRONMENT, type)

/obj/item/fishing/lure/led/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	return TRUE

/obj/item/fishing/lure/led/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	if(length(list(/datum/fish_trait/nocturnal, /datum/fish_trait/heavy) & fish.fish_traits))
		multiplier *= 1.8
	else
		multiplier *= 0.7

	return multiplier

/obj/item/fishing/lure/lucky_coin
	name = "\improper Maneki-Coin lure"
	desc = "A faux-gold lure. Catches the attention of fishies that love shinies. Not nearly tasty-looking enough for anything else."
	icon_state = "lucky_coin"
	spin_frequency = list(1.5 SECONDS, 2.7 SECONDS)

/obj/item/fishing/lure/lucky_coin/on_fishingrod_slotted(obj/item/fishingrod/rod, slot)
	. = ..()
	ADD_TRAIT(rod, TRAIT_ROD_ATTRACT_SHINY_LOVERS, REF(src))

/obj/item/fishing/lure/lucky_coin/on_fishingrod_unslotted(obj/item/fishingrod/rod, slot)
	. = ..()
	REMOVE_TRAIT(rod, TRAIT_ROD_ATTRACT_SHINY_LOVERS, REF(src))

/obj/item/fishing/lure/lucky_coin/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Can catch most fish
	if(fish.size > fish.average_size * 1.7)
		return FALSE
	return TRUE

/obj/item/fishing/lure/lucky_coin/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Big bonus for shiny lovers (main target)
	if(/datum/fish_trait/shiny_lover in fish.fish_traits)
		multiplier *= 2
	else
		// Penalty for non-shiny lovers
		multiplier *= 0.5

	return multiplier

/obj/item/fishing/lure/algae
	name = "algae lure"
	desc = "A soft clump of fake algae. Herbivores love it. Nothing else does, not even omnivores."
	icon_state = "algae"
	spin_frequency = list(3 SECONDS, 5 SECONDS)

/obj/item/fishing/lure/algae/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Can catch most fish, excluding extreme predators
	if(/datum/fish_trait/predator in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/lure/algae/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Big bonus for vegans (main target)
	if(/datum/fish_trait/vegan in fish.fish_traits)
		multiplier *= 2
	else
		// Lower success for non-vegans but still possible
		multiplier *= 0.4
	return multiplier


/obj/item/fishing/lure/grub
	name = "\improper Twister Worm lure"
	desc = "A soft artifical lure with the body of a grub and a twisting tail. Great for small fish, works on medium ones too."
	icon_state = "grub"
	spin_frequency = list(1 SECONDS, 2.7 SECONDS)

/obj/item/fishing/lure/grub/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Can catch anything not huge
	if(fish.size > fish.average_size * 1.1)
		return FALSE
	return TRUE

/obj/item/fishing/lure/grub/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Bonus for small fish (preferred target)
	if(fish.size < fish.average_size * 0.75)
		multiplier *= 1.5

	// Penalty for vegans/picky but still catchable
	if(length(list(/datum/fish_trait/vegan, /datum/fish_trait/picky_eater) & fish.fish_traits))
		multiplier *= 0.6

	return multiplier

/obj/item/fishing/lure/buzzbait
	name = "\improper Electric-Buzz lure"
	desc = "A metallic, colored clanker attached to a series of cables that somehow attract shock-worthy fish."
	icon_state = "buzzbait"
	spin_frequency = list(0.8 SECONDS, 1.7 SECONDS)

/obj/item/fishing/lure/buzzbait/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Can catch anything not extreme
	if(fish.size > fish.average_size * 1.7)
		return FALSE
	return TRUE

/obj/item/fishing/lure/buzzbait/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Big bonus for electric fish (main target)
	if(HAS_TRAIT(fish, TRAIT_FISH_ELECTROGENESIS))
		multiplier *= 2
	else
		// Still decent for others due to vibrations
		multiplier *= 0.7
	return multiplier

/obj/item/fishing/lure/spinnerbait
	name = "spinnerbait lure"
	desc = "A spinny, vulnerable lure, great for attracting freshwater predators, though omnivores won't be interested in it."
	icon_state = "spinnerbait"
	spin_frequency = list(2 SECONDS, 4 SECONDS)

/obj/item/fishing/lure/spinnerbait/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	if(fish.size > fish.average_size * 1.75)
		return FALSE
	return TRUE

/obj/item/fishing/lure/spinnerbait/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	var/is_predator = (/datum/fish_trait/predator in fish.fish_traits)
	var/fluid_type = fish.required_fluid_type
	var/is_freshwater = (fluid_type == FISH_FLUID_FRESHWATER || fluid_type == FISH_FLUID_ANADROMOUS || fluid_type == FISH_FLUID_ANY_WATER)

	if(is_predator && is_freshwater)
		multiplier *= 1.8
	else if(is_predator || is_freshwater)
		multiplier *= 1.2
	else
		multiplier *= 0.6

	return multiplier

/obj/item/fishing/lure/daisy_chain
	name = "daisy chain lure"
	desc = "A lure resembling a small school of fish. Best for saltwater predators, works on others."
	icon_state = "daisy_chain"
	spin_frequency = list(2 SECONDS, 4 SECONDS)

/obj/item/fishing/lure/daisy_chain/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	if(fish.size > fish.average_size * 1.75)
		return FALSE
	return TRUE

/obj/item/fishing/lure/daisy_chain/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Big bonus for saltwater predators (main target)
	var/is_predator = (/datum/fish_trait/predator in fish.fish_traits)
	var/fluid_type = fish.required_fluid_type
	var/is_saltwater = (fluid_type == FISH_FLUID_SALTWATER || fluid_type == FISH_FLUID_ANADROMOUS || fluid_type == FISH_FLUID_ANY_WATER)

	if(is_predator && is_saltwater)
		multiplier *= 1.8
	else if(is_predator || is_saltwater)
		multiplier *= 1.2
	else
		multiplier *= 0.6

	return multiplier

/obj/item/fishing/lure/meat
	name = "red bait"
	desc = "A small amount of meat, rolled into a ball. Tends to attract eels."
	icon_state = "meatbait"
	icon = 'icons/roguetown/items/fishing.dmi'
	spin_frequency = list(2 SECONDS, 3 SECONDS)
	consumable = TRUE
	bait_flag = MEAT

/obj/item/fishing/lure/meat/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	if(/datum/fish_trait/vegan in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/lure/meat/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/eel))
		multiplier *= 1.5

	if(/datum/fish_trait/predator in fish.fish_traits)
		multiplier *= 1.3

	return multiplier

/obj/item/fishing/lure/dough
	name = "doughy bait"
	desc = "A small amount of dough, rolled into a ball. Tends to attract carps."
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "doughslice"
	icon = 'icons/roguetown/items/food.dmi'
	spin_frequency = list(2 SECONDS, 3 SECONDS)
	consumable = TRUE
	bait_flag = GRAIN

/obj/item/fishing/lure/dough/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	if(/datum/fish_trait/predator in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/lure/dough/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Big bonus for carps and shrimp
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/carp))
		multiplier *= 1.5
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/shrimp))
		multiplier *= 1.4

	// Bonus for vegans
	if(/datum/fish_trait/vegan in fish.fish_traits)
		multiplier *= 1.3

	return multiplier

/obj/item/fishing/lure/gray
	name = "gray bait"
	desc = "A small amount of dough and meat, rolled into a ball. Attracts a little bit of everything."
	icon_state = "mixedbait"
	icon = 'icons/roguetown/items/fishing.dmi'
	spin_frequency = list(2 SECONDS, 3 SECONDS)
	consumable = TRUE
	bait_flag = GRAIN | MEAT

/obj/item/fishing/lure/gray/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return 1

	// Good bonus for common fish
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/carp))
		multiplier *= 1.3
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/eel))
		multiplier *= 1.3
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/shrimp))
		multiplier *= 1.3

	return multiplier

/obj/item/fishing/lure/speckled
	name = "speckled bait"
	desc = "A complex blend of meat, flour, and berries rolled into a ball. Its smell scares off smaller fish."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "speckledbait"
	spin_frequency = list(2.5 SECONDS, 3.5 SECONDS)
	consumable = TRUE
	bait_flag = GRAIN | MEAT | FRUIT

/obj/item/fishing/lure/speckled/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Catches most things, excluding tiny fish
	if(fish.size < fish.average_size * 0.5)
		return FALSE
	return TRUE

/obj/item/fishing/lure/speckled/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	// Big bonus for specialty fish
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/angler))
		multiplier *= 1.6
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/clownfish))
		multiplier *= 1.6

	// Good bonus for carps and eels
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/carp))
		multiplier *= 1.4
	if(istype(fish, /obj/item/reagent_containers/food/snacks/fish/eel))
		multiplier *= 1.4

	// Penalty for very small fish
	if(fish.size < fish.average_size * 0.9)
		multiplier *= 0.7

	return multiplier

/obj/item/fishing/lure/deluxe
	name = "enchanted bait"
	desc = "A ball of unknown ingredients, formulated by Abyssorian priests. Rarely catches something truly special."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "deluxebait"
	spin_frequency = list(2 SECONDS, 3.5 SECONDS)
	consumable = TRUE
	/// Chance to catch a special variant fish
	var/special_catch_chance = 20

/obj/item/fishing/lure/deluxe/on_fishingrod_slotted(datum/source, obj/item/fishingrod/rod, slot)
	. = ..()
	ADD_TRAIT(rod, TRAIT_ROD_IGNORE_ENVIRONMENT, type)
	rod.spin_frequency = spin_frequency

/obj/item/fishing/lure/deluxe/on_fishingrod_unslotted(datum/source, obj/item/fishingrod/rod, slot)
	. = ..()
	REMOVE_TRAIT(rod, TRAIT_ROD_IGNORE_ENVIRONMENT, type)
	rod.spin_frequency = null

/obj/item/fishing/lure/deluxe/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	return TRUE

/obj/item/fishing/lure/deluxe/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()

	if(prob(special_catch_chance))
		multiplier *= 1.5

	return multiplier
