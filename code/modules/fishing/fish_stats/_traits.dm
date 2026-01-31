///A global list of singleton fish traits by their paths
GLOBAL_LIST_INIT(fish_traits, init_subtypes_w_path_keys(/datum/fish_trait, list()))

/**
 * A nested list of fish types and traits that they can spontaneously manifest with associated probabilities
 * e.g. list(/obj/item/fish = list(/datum/fish_trait = 100), etc...)
 */
GLOBAL_LIST_INIT(spontaneous_fish_traits, populate_spontaneous_fish_traits())

/proc/populate_spontaneous_fish_traits()
	var/list/list = list()
	for(var/trait_path in GLOB.fish_traits)
		var/datum/fish_trait/trait = GLOB.fish_traits[trait_path]
		if(isnull(trait.spontaneous_manifest_types))
			continue
		var/list/trait_typecache = zebra_typecacheof(trait.spontaneous_manifest_types) - /obj/item/reagent_containers/food/snacks/fish
		for(var/fish_type in trait_typecache)
			var/trait_prob = trait_typecache[fish_type]
			if(!trait_prob)
				continue
			LAZYSET(list[fish_type], trait_path, trait_typecache[fish_type])
	return list

/datum/fish_trait
	var/name = "Unnamed Trait"
	/// Description of the trait in the fishing catalog and scanner
	var/catalog_description = "Uh uh, someone has forgotten to set description to this trait. Yikes!"
	///A list of traits fish cannot have in conjunction with this trait.
	var/list/incompatible_traits
	/// The probability this trait can be inherited by offsprings when both mates have it
	var/inheritability = 50
	/// A list of fish types and traits that they can spontaneously manifest with associated probabilities
	var/list/spontaneous_manifest_types = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 3,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 3,
		/obj/item/reagent_containers/food/snacks/fish/angler = 3,
		/obj/item/reagent_containers/food/snacks/fish/eel = 3,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 3,
		/obj/item/reagent_containers/food/snacks/fish/swordfish = 3,
	)
	/// An optional whitelist of fish that can get this trait
	var/list/fish_whitelist
	/// Depending on the value, fish with trait will be reported as more or less difficult in the catalog.
	var/added_difficulty = 0
	/// Reagents to add to the fish whenever the COMSIG_GENERATE_REAGENTS_TO_ADD signal is sent. Their values will be multiplied later.
	var/list/reagents_to_add

/// Difficulty modifier from this mod, needs to return a list with two values
/datum/fish_trait/proc/difficulty_mod(obj/item/fishingrod/rod, mob/fisherman)
	SHOULD_CALL_PARENT(TRUE) //Technically it doesn't but this makes it saner without custom unit test
	return list(ADDITIVE_FISHING_MOD = 0, MULTIPLICATIVE_FISHING_MOD = 1)

/// Catch weight table modifier from this mod, needs to return a list with two values
/datum/fish_trait/proc/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	SHOULD_CALL_PARENT(TRUE)
	return list(ADDITIVE_FISHING_MOD = 0, MULTIPLICATIVE_FISHING_MOD = 1)

/// Returns special minigame rules and effects applied by this trait
/datum/fish_trait/proc/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	return

/// Applies some special qualities to the fish that has been spawned
/datum/fish_trait/proc/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	SHOULD_CALL_PARENT(TRUE)
	if(length(reagents_to_add))
		RegisterSignal(fish, COMSIG_GENERATE_REAGENTS_TO_ADD, PROC_REF(add_reagents))

/// Proc used by both the predator and necrophage traits.
/datum/fish_trait/proc/eat_fish(obj/item/reagent_containers/food/snacks/fish/predator, obj/item/reagent_containers/food/snacks/fish/prey)
	var/message = prey.status == FISH_DEAD ? "[predator] eats [prey]'s carcass." : "[predator] hunts down and eats [prey]."
	predator.loc.visible_message(span_warning(message))
	SEND_SIGNAL(prey, COMSIG_FISH_EATEN_BY_OTHER_FISH, predator)
	qdel(prey)
	predator.sate_hunger()


/**
 * Signal sent when we need to generate an abstract holder containing
 * reagents to be transfered, usually as a result of the fish being eaten by someone
 */
/datum/fish_trait/proc/add_reagents(obj/item/reagent_containers/food/snacks/fish/fish, list/reagents)
	SIGNAL_HANDLER
	for(var/reagent in reagents_to_add)
		reagents[reagent] += reagents_to_add[reagent]

/datum/fish_trait/wary
	name = "Wary"
	catalog_description = "This fish will avoid visible fish lines, cloaked line recommended."

/datum/fish_trait/wary/difficulty_mod(obj/item/fishingrod/rod, mob/fisherman)
	. = ..()
	// Wary fish require transparent line or they're harder
	if(!rod.line || !(rod.line.fishing_line_traits & FISHING_LINE_CLOAKED))
		.[ADDITIVE_FISHING_MOD] += FISH_TRAIT_MINOR_DIFFICULTY_BOOST

/datum/fish_trait/shiny_lover
	name = "Shiny Lover"
	catalog_description = "This fish loves shiny things and money, shiny lure recommended."

/datum/fish_trait/shiny_lover/difficulty_mod(obj/item/fishingrod/rod, mob/fisherman)
	. = ..()
	// These fish are easier to catch with shiny hook
	if(HAS_TRAIT(rod, TRAIT_ROD_ATTRACT_SHINY_LOVERS) || (rod.baited?.sellprice >= 10))
		.[ADDITIVE_FISHING_MOD] -= FISH_TRAIT_MINOR_DIFFICULTY_BOOST

/datum/fish_trait/shiny_lover/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman)
	. = ..()
	// These fish are harder to find without a shiny hook
	if(!HAS_TRAIT(rod, TRAIT_ROD_ATTRACT_SHINY_LOVERS))
		.[MULTIPLICATIVE_FISHING_MOD] = 0.5

/datum/fish_trait/picky_eater
	name = "Picky Eater"
	catalog_description = "This fish is very picky and will ignore low quality bait (unless it's amongst its favorites)."

/datum/fish_trait/picky_eater/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	var/list/fav_baits = SSfishing.fish_properties[fish_type][FISH_PROPERTIES_FAV_BAIT]
	for(var/list/identifier in fav_baits)
		if(identifier[FISH_BAIT_TYPE] != FISH_BAIT_FOODTYPE)
			continue
		if(is_matching_bait(rod, identifier)) //Bait or no bait, it's a yummy rod.
			return
	if(!rod.baited)
		.[MULTIPLICATIVE_FISHING_MOD] = 0
		return
	if(HAS_TRAIT(rod.baited, TRAIT_OMNI_BAIT))
		return

	for(var/identifier in fav_baits)
		if(is_matching_bait(rod.baited, identifier)) //we like this bait anyway
			return

	var/list/bad_baits = SSfishing.fish_properties[fish_type][FISH_PROPERTIES_BAD_BAIT]
	for(var/identifier in bad_baits)
		if(is_matching_bait(rod.baited, identifier)) //we hate this bait.
			.[MULTIPLICATIVE_FISHING_MOD] = 0
			return

	if(!HAS_TRAIT(rod.baited, TRAIT_GOOD_QUALITY_BAIT) && !HAS_TRAIT(rod.baited, TRAIT_GREAT_QUALITY_BAIT))
		.[MULTIPLICATIVE_FISHING_MOD] = 0

/datum/fish_trait/nocturnal
	name = "Nocturnal"
	catalog_description = "This fish avoids bright lights, fishing and storing in darkness recommended."

/datum/fish_trait/nocturnal/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(HAS_TRAIT(rod, TRAIT_ROD_IGNORE_ENVIRONMENT))
		return
	var/turf/turf = get_turf(location)
	var/light_amount = turf?.get_lumcount()
	if(light_amount > SHADOW_SPECIES_LIGHT_THRESHOLD)
		.[MULTIPLICATIVE_FISHING_MOD] = 0

/datum/fish_trait/nocturnal/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_LIFE, PROC_REF(check_light))

/datum/fish_trait/nocturnal/proc/check_light(obj/item/reagent_containers/food/snacks/fish/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(!source.loc || (!isturf(source.loc)))
		return
	var/turf/turf = get_turf(source)
	var/light_amount = turf.get_lumcount()
	if(light_amount > SHADOW_SPECIES_LIGHT_THRESHOLD)
		source.damage_fish(0.5 * seconds_per_tick)

/datum/fish_trait/heavy
	name = "Demersal"
	catalog_description = "This fish tends to stay near the waterbed."

/datum/fish_trait/heavy/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.mover.fish_idle_velocity -= 10

/datum/fish_trait/carnivore
	name = "Carnivore"
	catalog_description = "This fish can only be baited with meat."
	incompatible_traits = list(/datum/fish_trait/vegan)

/datum/fish_trait/carnivore/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(!rod.baited)
		.[MULTIPLICATIVE_FISHING_MOD] = 0
		return
	if(HAS_TRAIT(rod.baited, TRAIT_OMNI_BAIT))
		return
	var/list/bait_identifier = list(
		FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
		FISH_BAIT_VALUE = MEAT,
	)
	if(!is_matching_bait(rod.baited, bait_identifier))
		.[MULTIPLICATIVE_FISHING_MOD] = 0

/datum/fish_trait/vegan
	name = "Herbivore"
	catalog_description = "This fish can only be baited with fresh produce."
	incompatible_traits = list(/datum/fish_trait/carnivore, /datum/fish_trait/predator)

/datum/fish_trait/vegan/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(!rod.baited)
		.[MULTIPLICATIVE_FISHING_MOD] = 0
		return
	if(HAS_TRAIT(rod.baited, TRAIT_OMNI_BAIT))
		return
	if(istype(rod.baited, /obj/item/reagent_containers/food/snacks/grown))
		return
	var/list/bait_liked_identifier = list(
		FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
		FISH_BAIT_VALUE = VEGETABLES|FRUIT,
	)
	var/list/bait_hated_identifier = list(
		FISH_BAIT_TYPE = FISH_BAIT_FOODTYPE,
		FISH_BAIT_VALUE = MEAT|DAIRY,
	)
	if(!is_matching_bait(rod.baited, bait_liked_identifier) || is_matching_bait(rod.baited, bait_hated_identifier))
		.[MULTIPLICATIVE_FISHING_MOD] = 0

/datum/fish_trait/predator
	name = "Predator"
	catalog_description = "It's a predatory fish. It'll hunt down and eat live fishes of smaller size when hungry."
	incompatible_traits = list(/datum/fish_trait/vegan)

/datum/fish_trait/predator/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(isfish(rod.baited))
		.[MULTIPLICATIVE_FISHING_MOD] *= 2

/datum/fish_trait/predator/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_LIFE, PROC_REF(eat_fishes))

/datum/fish_trait/predator/proc/eat_fishes(obj/item/reagent_containers/food/snacks/fish/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(source.get_hunger() > 0.75 || !source.loc)
		return
	for(var/obj/item/reagent_containers/food/snacks/fish/victim as anything in source.get_aquarium_fishes(TRUE, source))
		if(victim.size < source.size * 0.7) // It's a big fish eat small fish world
			continue
		if(victim.status != FISH_ALIVE || victim == source || HAS_TRAIT(victim, TRAIT_YUCKY_FISH) || SPT_PROB(80, seconds_per_tick))
			continue
		eat_fish(source, victim)
		return

/datum/fish_trait/yucky
	name = "Yucky"
	catalog_description = "This fish tastes so repulsive, other fishes won't try to eat it."
	reagents_to_add = list(/datum/reagent/yuck = 1.2)

/datum/fish_trait/yucky/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_YUCKY_FISH, FISH_TRAIT_DATUM)

/datum/fish_trait/lubed
	name = "Slippery"
	catalog_description = "This fish exudes a viscous, slippery lubrificant. It's recommended not to step on it."
	added_difficulty = 5

/datum/fish_trait/lubed/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	fish.AddComponent(/datum/component/slippery, 1 SECONDS, SLIDE|GALOSHES_DONT_HELP)

/datum/fish_trait/lubed/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.reeling_velocity *= 1.4
	minigame.gravity_velocity *= 1.4

/datum/fish_trait/antigrav
	name = "Anti-Gravity"
	catalog_description = "This fish will invert the gravity of the bait at random. May fall upward outside after being caught."
	added_difficulty = 20

/datum/fish_trait/antigrav/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.special_effects |= FISHING_MINIGAME_RULE_ANTIGRAV


/datum/fish_trait/camouflage
	name = "Camouflage"
	catalog_description = "This fish possess the ability to blend with its surroundings."
	added_difficulty = 5
	spontaneous_manifest_types = list(
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 15,
		/obj/item/reagent_containers/food/snacks/fish/eel = 8,
	)

/datum/fish_trait/camouflage/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.special_effects |= FISHING_MINIGAME_RULE_CAMO

/datum/fish_trait/camouflage/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_LIFE, PROC_REF(fade_out))
	RegisterSignals(fish, list(COMSIG_MOVABLE_MOVED, COMSIG_FISH_STATUS_CHANGED), PROC_REF(reset_alpha))

/datum/fish_trait/camouflage/proc/fade_out(obj/item/reagent_containers/food/snacks/fish/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(source.status == FISH_DEAD || source.last_move + 5 SECONDS >= world.time)
		return
	source.alpha = max(source.alpha - 10 * seconds_per_tick, 60)

/datum/fish_trait/camouflage/proc/reset_alpha(obj/item/reagent_containers/food/snacks/fish/source)
	SIGNAL_HANDLER
	if(QDELETED(source))
		return
	var/init_alpha = initial(source.alpha)
	if(init_alpha != source.alpha)
		animate(source, alpha = init_alpha, time = 1.2 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)

/datum/fish_trait/prehistoric
	name = "Living Fossil"
	catalog_description = "An ancient species thought extinct. Extremely rare and valuable."
	inheritability = 60
	added_difficulty = 25

/datum/fish_trait/prehistoric/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	fish.sellprice *= 5
	ADD_TRAIT(fish, TRAIT_FISH_RECESSIVE, FISH_TRAIT_DATUM)

/datum/fish_trait/deep_dweller
	name = "Deep Dweller"
	catalog_description = "This fish lives in the deepest waters and suffers in shallow light."

/datum/fish_trait/deep_dweller/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	var/turf/targeted = location
	if(!targeted.can_see_sky()) // Covered/deep water
		.[MULTIPLICATIVE_FISHING_MOD] *= 2
	else
		.[MULTIPLICATIVE_FISHING_MOD] *= 0.2

/datum/fish_trait/deep_dweller/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_LIFE, PROC_REF(check_depth))

/datum/fish_trait/deep_dweller/proc/check_depth(obj/item/reagent_containers/food/snacks/fish/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(!source.loc || !isturf(source.loc))
		return
	var/turf/turf = get_turf(source)
	if(turf.can_see_sky()) // Shallow water = damage
		source.damage_fish(1 * seconds_per_tick)

/datum/fish_trait/venomous
	name = "Venomous"
	catalog_description = "This fish secretes toxins. Can poison other fish and handlers."
	incompatible_traits = list(/datum/fish_trait/yucky)
	reagents_to_add = list(/datum/reagent/toxin = 2)
	added_difficulty = 10

/datum/fish_trait/treasure_hunter
	name = "Treasure Hunter"
	catalog_description = "This fish collects shiny objects. May have valuables in its stomach when caught."
	incompatible_traits = list(/datum/fish_trait/vegan)

/datum/fish_trait/treasure_hunter/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	// When the fish is butchered/killed, small chance to drop coins or gems
	RegisterSignal(fish, COMSIG_FISH_STATUS_CHANGED, PROC_REF(drop_treasure))

/datum/fish_trait/treasure_hunter/proc/drop_treasure(obj/item/reagent_containers/food/snacks/fish/source)
	SIGNAL_HANDLER
	if(source.status != FISH_DEAD || !prob(15))
		return
	var/treasure_type = pick(/obj/item/coin/copper, /obj/item/coin/silver, /obj/item/coin/gold)
	new treasure_type(get_turf(source))
	source.visible_message(span_notice("Something shiny falls out of [source]!"))

/datum/fish_trait/bioluminescent
	name = "Bioluminescent"
	catalog_description = "This fish emits a natural glow in dark waters. Easier to spot at night."
	incompatible_traits = list(/datum/fish_trait/nocturnal, /datum/fish_trait/camouflage)
	added_difficulty = -3

/datum/fish_trait/bioluminescent/catch_weight_mod(obj/item/fishingrod/rod, mob/fisherman, atom/location, obj/item/reagent_containers/food/snacks/fish/fish_type)
	. = ..()
	if(HAS_TRAIT(rod, TRAIT_ROD_IGNORE_ENVIRONMENT))
		return
	var/turf/turf = get_turf(location)
	var/light_amount = turf?.get_lumcount()
	// Easier to find in darkness
	if(light_amount < SHADOW_SPECIES_LIGHT_THRESHOLD)
		.[MULTIPLICATIVE_FISHING_MOD] *= 1.5

/datum/fish_trait/bioluminescent/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	fish.set_light_range(2)
	fish.set_light_color(COLOR_CYAN)
