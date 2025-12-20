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
	var/list/spontaneous_manifest_types
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
	incompatible_traits = list(/datum/fish_trait/carnivore, /datum/fish_trait/predator, /datum/fish_trait/necrophage)

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


/datum/fish_trait/necrophage
	name = "Necrophage"
	catalog_description = "This fish will eat carcasses of dead fish when hungry."
	incompatible_traits = list(/datum/fish_trait/vegan)

/datum/fish_trait/necrophage/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_LIFE, PROC_REF(eat_dead_fishes))

/datum/fish_trait/necrophage/proc/eat_dead_fishes(obj/item/reagent_containers/food/snacks/fish/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(source.get_hunger() > 0.75 || !source.loc)
		return
	for(var/obj/item/reagent_containers/food/snacks/fish/victim in source.loc)
		if(victim.status != FISH_DEAD || victim == source || HAS_TRAIT(victim, TRAIT_YUCKY_FISH))
			continue
		eat_fish(source, victim)
		return

/datum/fish_trait/parthenogenesis
	name = "Parthenogenesis"
	catalog_description = "This fish can reproduce asexually, without the need of a mate."
	inheritability = 40

/datum/fish_trait/parthenogenesis/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_FISH_SELF_REPRODUCE, FISH_TRAIT_DATUM)

/**
 * Useful for those species with the parthenogenesis trait if you don't want them to mate with each other,
 * or for similar shenanigans, I don't know.
 * Otherwise you could just set the stable_population to 1.
 */
/datum/fish_trait/no_mating
	name = "Mateless"
	catalog_description = "This fish cannot reproduce with other fishes."
	incompatible_traits = list(/datum/fish_trait/crossbreeder)

/datum/fish_trait/no_mating/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_FISH_NO_MATING, FISH_TRAIT_DATUM)

///Prevent offsprings of fish with this trait from being of the same type (unless self-mating or the partner also has the trait)
/datum/fish_trait/recessive
	name = "Recessive"
	catalog_description = "If crossbred, offsprings will always be of the mate species, unless it also possess the trait."
	inheritability = 0

/datum/fish_trait/no_mating/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_FISH_RECESSIVE, FISH_TRAIT_DATUM)

/datum/fish_trait/revival
	name = "Self-Revival"
	catalog_description = "This fish shows a peculiar ability of reviving itself a minute or two after death."

/datum/fish_trait/revival/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_STATUS_CHANGED, PROC_REF(check_status))

/datum/fish_trait/revival/proc/check_status(obj/item/reagent_containers/food/snacks/fish/source)
	SIGNAL_HANDLER
	if(source.status == FISH_DEAD)
		addtimer(CALLBACK(src, PROC_REF(revive), WEAKREF(source)), rand(1 MINUTES, 2 MINUTES))

/datum/fish_trait/revival/proc/revive(datum/weakref/fish_ref)
	var/obj/item/reagent_containers/food/snacks/fish/source = fish_ref.resolve()
	if(QDELETED(source) || source.status != FISH_DEAD)
		return
	source.set_status(FISH_ALIVE)
	var/message = span_nicegreen("[source] twitches. It's alive!")
	source.visible_message(message)

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

/datum/fish_trait/toxin_immunity
	name = "Toxin Immunity"
	catalog_description = "This fish has developed an ample-spected immunity to toxins."

/datum/fish_trait/toxin_immunity/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_FISH_TOXIN_IMMUNE, FISH_TRAIT_DATUM)

/datum/fish_trait/crossbreeder
	name = "Crossbreeder"
	catalog_description = "This fish's adaptive genetics allows it to crossbreed with other fish species."
	inheritability = 40
	incompatible_traits = list(/datum/fish_trait/no_mating)

/datum/fish_trait/crossbreeder/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_FISH_CROSSBREEDER, FISH_TRAIT_DATUM)

/datum/fish_trait/territorial
	name = "Territorial"
	catalog_description = "This fish will start attacking other fish if the aquarium has five or more."

/datum/fish_trait/territorial/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_LIFE, PROC_REF(try_attack_fish))

/datum/fish_trait/territorial/proc/try_attack_fish(obj/item/reagent_containers/food/snacks/fish/source, seconds_per_tick)
	SIGNAL_HANDLER
	if(!source.loc || !SPT_PROB(1, seconds_per_tick))
		return
	var/list/fishes = source.get_aquarium_fishes(TRUE, source)
	if(length(fishes) < 5)
		return
	for(var/obj/item/reagent_containers/food/snacks/fish/victim as anything in source.get_aquarium_fishes(TRUE, source))
		if(victim.status != FISH_ALIVE)
			continue
		source.loc.visible_message(span_warning("[source] violently [pick("whips", "bites", "attacks", "slams")] [victim]"))
		var/damage = round(rand(4, 20) * (source.size / victim.size)) //smaller fishes take extra damage.
		victim.damage_fish(damage)
		return

/datum/fish_trait/lubed
	name = "Slippery"
	catalog_description = "This fish exudes a viscous, slippery lubrificant. It's recommended not to step on it."
	added_difficulty = 5

/datum/fish_trait/lubed/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	fish.AddComponent(/datum/component/slippery, 8 SECONDS, SLIDE|GALOSHES_DONT_HELP)


/datum/fish_trait/lubed/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.reeling_velocity *= 1.4
	minigame.gravity_velocity *= 1.4

/datum/fish_trait/amphibious
	name = "Amphibious"
	catalog_description = "This fish has developed a primitive adaptation to life on both land and water."

/datum/fish_trait/amphibious/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_FISH_AMPHIBIOUS, FISH_TRAIT_DATUM)
	if(fish.required_fluid_type == FISH_FLUID_AIR)
		fish.required_fluid_type = FISH_FLUID_FRESHWATER

/datum/fish_trait/mixotroph
	name = "Mixotroph"
	catalog_description = "This fish is capable of subsisting itself by producing its own sources of energy (food)."
	incompatible_traits = list(/datum/fish_trait/predator, /datum/fish_trait/necrophage)

/datum/fish_trait/mixotroph/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	ADD_TRAIT(fish, TRAIT_FISH_NO_HUNGER, FISH_TRAIT_DATUM)

/datum/fish_trait/antigrav
	name = "Anti-Gravity"
	catalog_description = "This fish will invert the gravity of the bait at random. May fall upward outside after being caught."
	added_difficulty = 20

/datum/fish_trait/antigrav/minigame_mod(obj/item/fishingrod/rod, mob/fisherman, datum/fishing_challenge/minigame)
	minigame.special_effects |= FISHING_MINIGAME_RULE_ANTIGRAV



///Anxiety means the fish will die if in a location with more than 3 fish (including itself)
///This is just barely enough to crossbreed out of anxiety, but it severely limits the potential of
/datum/fish_trait/anxiety
	name = "Anxiety"
	catalog_description = "This fish tends to die of stress when forced to be around too many other fish."

/datum/fish_trait/anxiety/difficulty_mod(obj/item/fishingrod/rod, mob/fisherman)
	. = ..()
	// Anxious fish are easier with a cloaked line.
	if(rod.line && (rod.line.fishing_line_traits & FISHING_LINE_CLOAKED))
		.[ADDITIVE_FISHING_MOD] -= FISH_TRAIT_MINOR_DIFFICULTY_BOOST

/datum/fish_trait/anxiety/apply_to_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	. = ..()
	RegisterSignal(fish, COMSIG_FISH_LIFE, PROC_REF(on_fish_life))

///signal sent when the anxiety fish is fed, killing it if sharing contents with too many fish.
/datum/fish_trait/anxiety/proc/on_fish_life(obj/item/reagent_containers/food/snacks/fish/fish, seconds_per_tick)
	SIGNAL_HANDLER
	var/fish_tolerance = 3
	if(!fish.loc || fish.status == FISH_DEAD)
		return
	for(var/obj/item/reagent_containers/food/snacks/fish/other_fish in fish.loc.contents)
		if(fish_tolerance <= 0)
			fish.loc.visible_message(span_warning("[fish] seems to freak out for a moment, then it stops moving..."))
			fish.set_status(FISH_DEAD)
			return
		fish_tolerance -= 1


/datum/fish_trait/camouflage
	name = "Camouflage"
	catalog_description = "This fish possess the ability to blend with its surroundings."
	added_difficulty = 5

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
	source.alpha = max(source.alpha - 10 * seconds_per_tick, 10)

/datum/fish_trait/camouflage/proc/reset_alpha(obj/item/reagent_containers/food/snacks/fish/source)
	SIGNAL_HANDLER
	if(QDELETED(source))
		return
	var/init_alpha = initial(source.alpha)
	if(init_alpha != source.alpha)
		animate(source, alpha = init_alpha, time = 1.2 SECONDS, easing = CIRCULAR_EASING|EASE_OUT)
