
///fish traits
#define TRAIT_FISH_STASIS "fish_stasis"
#define TRAIT_FISH_FLOPPING "fish_flopping"
#define TRAIT_RESIST_PSYCHIC "resist_psychic"
#define TRAIT_RESIST_EMULSIFY "resist_emulsify"
#define TRAIT_FISH_SELF_REPRODUCE "fish_self_reproduce"
#define TRAIT_FISH_NO_MATING "fish_no_mating"
#define TRAIT_YUCKY_FISH "yucky_fish"
#define TRAIT_FISH_TOXIN_IMMUNE "fish_toxin_immune"
#define TRAIT_FISH_CROSSBREEDER "fish_crossbreeder"
#define TRAIT_FISH_AMPHIBIOUS "fish_amphibious"
///Trait needed for the lubefish evolution
#define TRAIT_FISH_FED_LUBE "fish_fed_lube"
#define TRAIT_FISH_WELL_COOKED "fish_well_cooked"
#define TRAIT_FISH_NO_HUNGER "fish_no_hunger"
///Fish with this trait only sell for 1/20 of the original price when exported. For fish cases and trophy mounts.
#define TRAIT_FISH_LOW_PRICE "fish_from_case"
///Fish will also occasionally fire weak tesla zaps
#define TRAIT_FISH_ELECTROGENESIS "fish_electrogenesis"
///Offsprings from this fish will never be of its same type (unless it's self-reproducing).
#define TRAIT_FISH_RECESSIVE "fish_recessive"
///This fish comes equipped with a stinger (increased damage and potentially venomous if also toxic)
#define TRAIT_FISH_STINGER "fish_stinger"
///This fish is currently on cooldown and cannot splash ink unto people's faces
#define TRAIT_FISH_INK_ON_COOLDOWN "fish_ink_on_cooldown"
///This fish requires two hands to carry even if smaller than FISH_SIZE_TWO_HANDS_REQUIRED, as long as it's bulky-sized.
#define TRAIT_FISH_SHOULD_TWOHANDED "fish_should_twohanded"
///This fish won't be killed when cooked.
#define TRAIT_FISH_SURVIVE_COOKING "fish_survive_cooking"
///This fish is healed by milk and hurt by bone hurting juice
#define TRAIT_FISH_MADE_OF_BONE "fish_made_of_bone"
/**
 * This fish has been fed teslium without the electrogenesis having trait.
 * Gives the electrogenesis, but at halved output, and it hurts the fish over time.
 */
#define TRAIT_FISH_ON_TESLIUM "fish_on_teslium"
/// This fish has been fed growth serum or something and will grow 5 times faster, up to 50% weight and size gain when fed.
#define TRAIT_FISH_QUICK_GROWTH "fish_quick_growth"
/// This fish has been fed mutagen or something. Evolutions will have more than twice the probability
#define TRAIT_FISH_MUTAGENIC "fish_mutagenic"

/// Use in fish tables to denote miss chance.
#define FISHING_DUD "dud"
///Used in the hydro tray fishing spot to define a random seed reward
#define FISHING_RANDOM_SEED "Random seed"
///Used in the surgery fishing spot to define a random organ reward
#define FISHING_RANDOM_ORGAN "Random organ"
///Used in the dimensional rift fishing spot to define influence gain
#define FISHING_INFLUENCE "Influence"
///Used in the dimensional rift fishing spot to define arm procurement
#define FISHING_RANDOM_ARM "arm"

///Represents the chance of getting squashed by the vending machine from the vending machine fish source
#define FISHING_VENDING_CHUCK "thinkfastchucklenuts"

// Baseline fishing difficulty levels
#define FISHING_DEFAULT_DIFFICULTY 15
#define FISHING_EASY_DIFFICULTY 10
/**
 * The minimum value of the difficulty of the minigame (unless it reaches 0 than it's auto-win)
 * Any lower than this and the fish will be way too lethargic for the minigame to be engaging in the slightest.
 */
#define FISHING_MINIMUM_DIFFICULTY 6

/// Difficulty modifier when bait is fish's favorite
#define FAV_BAIT_DIFFICULTY_MOD -5
/// Difficulty modifier when bait is fish's disliked
#define DISLIKED_BAIT_DIFFICULTY_MOD 15
/// Difficulty modifier when our fisherman has the trait TRAIT_EXPERT_FISHER
#define EXPERT_FISHER_DIFFICULTY_MOD -5

#define FISH_TRAIT_MINOR_DIFFICULTY_BOOST 5

///Slot defines for the fishing rod and its equipment
#define ROD_SLOT_BAIT "bait"
#define ROD_SLOT_LINE "line"
#define ROD_SLOT_HOOK "hook"

#define ADDITIVE_FISHING_MOD "additive"
#define MULTIPLICATIVE_FISHING_MOD "multiplicative"

// These defines are intended for use to interact with fishing hooks when going
// through the fishing rod, and not the hook itself. They could probably be
// handled differently, but for now that's how they work. It's grounds for
// a future refactor, however.
/// Fishing hook trait that lessens the bounce from hitting the edges of the minigame bar.
#define FISHING_HOOK_WEIGHTED (1 << 0)
///See FISHING_MINIGAME_RULE_BIDIRECTIONAL
#define FISHING_HOOK_BIDIRECTIONAL (1 << 1)
///Prevents the user from losing the game by letting the fish get away.
#define FISHING_HOOK_NO_ESCAPE (1 << 2)
///Limits the completion loss of the minigame when the fsh is not on the bait area.
#define FISHING_HOOK_ENSNARE (1 << 3)
///Automatically kills the fish after a while, at the cost of killing it.
#define FISHING_HOOK_KILL (1 << 4)

///Reduces the difficulty of the minigame
#define FISHING_LINE_CLOAKED (1 << 0)
/// Much like FISHING_HOOK_ENSNARE but for the fishing line.
#define FISHING_LINE_BOUNCY (1 << 1)
/// The sorta opposite of FISHING_LINE_BOUNCY. It makes it slower to gain completion and faster to lose it.
#define FISHING_LINE_STIFF (1 << 2)
///Skip the biting phase and go straight to the fishing phase.
#define FISHING_LINE_AUTOREEL (1 << 3)
///if fishing in "deep water" gives a bonus
#define FISHING_LINE_SINKER (1 << 4)
///if fishing in "shallow water" gives a bonus
#define FISHING_LINE_BOBBER (1 << 5)

///Keeps the bait from falling from gravity, instead allowing the player to move the bait down with right click.
#define FISHING_MINIGAME_RULE_BIDIRECTIONAL (1 << 0)
///Prevents the player from losing the minigame when the completion reaches 0
#define FISHING_MINIGAME_RULE_NO_ESCAPE (1 << 1)
///Automatically kills the fish after a while, at the cost of killing it
#define FISHING_MINIGAME_RULE_KILL (1 << 2)
///Prevents the fishing skill from having an effect on the minigame and experience from being awarded
#define FISHING_MINIGAME_RULE_NO_EXP (1 << 3)
///If enabled, the minigame will occasionally screw around and invert the velocity of the bait
#define FISHING_MINIGAME_RULE_ANTIGRAV (1 << 4)
///Will filp the minigame hud for the duration of the effect
#define FISHING_MINIGAME_RULE_FLIP (1 << 5)
///Skip the biting phase and go straight to the minigame, avoiding the penalty for having slow reflexes.
#define FISHING_MINIGAME_AUTOREEL (1 << 6)
///The fish will fade in and out at intervals
#define FISHING_MINIGAME_RULE_CAMO (1 << 7)

///all the effects that are active and will last for a few seconds before triggering a cooldown
#define FISHING_MINIGAME_ACTIVE_EFFECTS (FISHING_MINIGAME_RULE_ANTIGRAV|FISHING_MINIGAME_RULE_FLIP|FISHING_MINIGAME_RULE_CAMO)

/// The default additive value for fishing hook catch weight modifiers.
#define FISHING_DEFAULT_HOOK_BONUS_ADDITIVE 0
/// The default multiplicative value for fishing hook catch weight modifiers.
#define FISHING_DEFAULT_HOOK_BONUS_MULTIPLICATIVE 1

//Fish icon defines, used by fishing minigame
#define FISH_ICON_DEF "fish"
#define FISH_ICON_HOSTILE "hostile"
#define FISH_ICON_STAR "star"
#define FISH_ICON_CHUNKY "chunky"
#define FISH_ICON_SLIME "slime"
#define FISH_ICON_COIN "coin"
#define FISH_ICON_GEM "gem"
#define FISH_ICON_CRAB "crab"
#define FISH_ICON_JELLYFISH "jellyfish"
#define FISH_ICON_BOTTLE "bottle"
#define FISH_ICON_BONE "bone"
#define FISH_ICON_ELECTRIC "electric"
#define FISH_ICON_WEAPON "weapon"
#define FISH_ICON_CRITTER "critter"
#define FISH_ICON_SEED "seed"
#define FISH_ICON_ORGAN "organ"

#define AQUARIUM_ANIMATION_FISH_SWIM "fish"
#define AQUARIUM_ANIMATION_FISH_DEAD "dead"

//standard layer defines for aquariums

///The distance that should separate each layer of the aquarium
#define AQUARIUM_LAYER_STEP 0.01
/// Aquarium content layer offsets
#define AQUARIUM_MIN_OFFSET 0.02
#define AQUARIUM_MAX_OFFSET 1
/// The layer of the glass overlay
#define AQUARIUM_GLASS_LAYER 0.02
/// The layer of the aquarium pane borders
#define AQUARIUM_BORDERS_LAYER AQUARIUM_MAX_OFFSET + AQUARIUM_LAYER_STEP
/// Layer for stuff rendered below the glass overlay
#define AQUARIUM_BELOW_GLASS_LAYER 0.01

#define AQUARIUM_LAYER_MODE_BOTTOM "bottom"
#define AQUARIUM_LAYER_MODE_TOP "top"
#define AQUARIUM_LAYER_MODE_AUTO "auto"
#define AQUARIUM_LAYER_MODE_BEHIND_GLASS "behind_glass"

#define FISH_ALIVE "alive"
#define FISH_DEAD "dead"

///Fish size thresholds for w_class.
#define FISH_SIZE_TINY_MAX 30
#define FISH_SIZE_SMALL_MAX 50
#define FISH_SIZE_NORMAL_MAX 80
#define FISH_SIZE_BULKY_MAX 120
///size threshold for requiring two-handed carry
#define FISH_SIZE_TWO_HANDS_REQUIRED 135
#define FISH_SIZE_HUGE_MAX 165

///The coefficient for maximum weight/size divergence relative to the averages.
#define MAX_FISH_DEVIATION_COEFF 2.5

/**
 * Base multiplier of the difference between current size and weight and their maximum value
 * used to calculate how much fish grow each time they're fed, alongside with the current hunger,
 * and the current size and weight, meaning bigger fish naturally tend to grow way slowier
 */
#define FISH_GROWTH_MULT 0.38
/// Growth peaks at 45% hunger but very rapidly wanes past that.
#define FISH_GROWTH_PEAK 0.45
/// Used as part of the divisor to slow down growth of bigger fish
#define FISH_SIZE_WEIGHT_GROWTH_MALUS 0.5

///The volume of the grind results is multiplied by the fish' weight and divided by this.
#define FISH_GRIND_RESULTS_WEIGHT_DIVISOR 500
///The number of fillets is multiplied by the fish' size and divided by this.
#define FISH_FILLET_NUMBER_SIZE_DIVISOR 30

///The slowdown of the fish when carried begins at this value
#define FISH_WEIGHT_SLOWDOWN 2100
///The value of the slowdown equals to the weight divided by this (and then at the power of a sub-1 exponent)
#define FISH_WEIGHT_SLOWDOWN_DIVISOR 500
///The sub-one exponent that results in the final slowdown of the fish item
#define FISH_WEIGHT_SLOWDOWN_EXPONENT 0.54
///Used to calculate the force of the fish by comparing (1 + log(weight/this_define)) and the w_class of the item.
#define FISH_WEIGHT_FORCE_DIVISOR 250
///The multiplier used in the FISH_WEIGHT_BITE_DIVISOR define
#define FISH_WEIGHT_GRIND_TO_BITE_MULT 0.4
///Used to calculate how many bites a fish can take and therefore the amount of reagents it has.
#define FISH_WEIGHT_BITE_DIVISOR (FISH_GRIND_RESULTS_WEIGHT_DIVISOR * FISH_WEIGHT_GRIND_TO_BITE_MULT)

///Set of operations that calculate the slowdown of fish based on weight
#define GET_FISH_SLOWDOWN(weighty) round(((weighty/FISH_WEIGHT_SLOWDOWN_DIVISOR)**FISH_WEIGHT_SLOWDOWN_EXPONENT)-1.3, 0.1)

/**
 * Gets a "rank" for fish weight to determine the force of the fish (or fish tank)
 * basically, a gross estimate based on how weight generaly scales up (250, 500, 1000, 2000, 4000 etc...)
 * for most fish
 */
#define GET_FISH_WEIGHT_RANK(weighty) max(round(1 + log(2, max(weighty/FISH_WEIGHT_FORCE_DIVISOR, 1)), 1), 1)

///The breeding timeout for newly instantiated fish is multiplied by this.
#define NEW_FISH_BREEDING_TIMEOUT_MULT 2
///The last feeding timestamp of newly instantiated fish is multiplied by this: ergo, they spawn 50% hungry.
#define NEW_FISH_LAST_FEEDING_MULT 0.33

///If get_hunger is above this value, the fish is considered to be starving and will slowly lose health because of it
#define FISH_STARVING_THRESHOLD 1

//IF YOU ADD ANY NEW FLAG, ADD IT TO THE RESPECTIVE BITFIELD in _globalvars/bitfields.dm TOO!

///This fish is shown in the catalog and on the wiki (this only matters as an initial, compile-time value)
#define FISH_FLAG_SHOW_IN_CATALOG (1<<0)
///This fish has a flopping animation done through matrices
#define FISH_DO_FLOP_ANIM (1<<1)
///This fish has been petted in the last 30 seconds
#define FISH_FLAG_PETTED (1<<2)
///It lets us know that fish/update_size_and_weight() is currently running.
#define FISH_FLAG_UPDATING_SIZE_AND_WEIGHT (1<<3)
///Flag added when the population of this fish type exceeeds the stable population inside the aquarium
#define FISH_FLAG_OVERPOPULATED (1<<4)
///Flag added when in an aquarium which temperature is within its safe limits
#define FISH_FLAG_SAFE_TEMPERATURE (1<<5)
///Flag added when in an aquarium with the right fluid type.
#define FISH_FLAG_SAFE_FLUID (1<<6)

#define MIN_AQUARIUM_TEMP 0
#define MAX_AQUARIUM_TEMP 30
#define DEFAULT_AQUARIUM_TEMP 10

///How likely one's to find a given fish from random fish cases.
#define FISH_RARITY_BASIC 1000
#define FISH_RARITY_RARE 400
#define FISH_RARITY_VERY_RARE 200
#define FISH_RARITY_GOOD_LUCK_FINDING_THIS 50
#define FISH_RARITY_NOPE 0

///Aquarium fluid variables. The fish' required fluid has to match this, or it'll slowly die.
#define FISH_FLUID_FRESHWATER "Freshwater"
#define FISH_FLUID_SALTWATER "Saltwater"
#define FISH_FLUID_SULPHWATEVER "Sulfuric Water"
#define FISH_FLUID_AIR "Air"
#define FISH_FLUID_ANADROMOUS "Anadromous"
#define FISH_FLUID_ANY_WATER "Any Fluid"

///Fluff. The name of the aquarium company shown in the fish catalog
#define AQUARIUM_COMPANY "Aquatech Ltd."

///aquarium mode where you've to manage food, fluid type and temperature to keep fish alive
#define AQUARIUM_MODE_MANUAL "Manual"
///Aquarium mode where the code tries to determine what fluid type and temperature to use. Default.
#define AQUARIUM_MODE_AUTO "Assisted"
///Prevents fish from dying because of temp/fluid settings and starvation but stops growth.
#define AQUARIUM_MODE_SAFE "Stasis"

/// how long between electrogenesis zaps
#define ELECTROGENESIS_DURATION 40 SECONDS
/// a random range the electrogenesis cooldown varies by
#define ELECTROGENESIS_VARIANCE (rand(-10 SECONDS, 10 SECONDS))

#define FISH_BEAUTY_DISGUSTING -500
#define FISH_BEAUTY_UGLY -300
#define FISH_BEAUTY_BAD -200
#define FISH_BEAUTY_NULL 0
#define FISH_BEAUTY_GENERIC 250
#define FISH_BEAUTY_GOOD 450
#define FISH_BEAUTY_GREAT 600
#define FISH_BEAUTY_EXCELLENT 700

//Fish breeding stops if fish count exceeds this.
#define AQUARIUM_MAX_BREEDING_POPULATION 20

//Minigame defines
/// The height of the minigame slider. Not in pixels, but minigame units.
#define FISHING_MINIGAME_AREA 1000

///The fish needs to be cooked for at least this long so that it can be safely eaten
#define FISH_SAFE_COOKING_DURATION 30 SECONDS

///Defines for fish properties from the collect_fish_properties proc
#define FISH_PROPERTIES_FAV_BAIT "fav_bait"
#define FISH_PROPERTIES_BAD_BAIT "bad_bait"
#define FISH_PROPERTIES_TRAITS "fish_traits"
#define FISH_PROPERTIES_BEAUTY_SCORE "beauty_score"
#define FISH_PROPERTIES_EVOLUTIONS "evolutions"

///Define for favorite and disliked baits that aren't just item typepaths.
#define FISH_BAIT_TYPE "Type"
#define FISH_BAIT_FOODTYPE "Foodtype"
#define FISH_BAIT_REAGENT "Reagent"
#define FISH_BAIT_VALUE "Value"
#define FISH_BAIT_AMOUNT "Amount"


///We multiply the weight of fish inside the loot table by this value if we are goofy enough to fish without a bait.
#define FISH_WEIGHT_MULT_WITHOUT_BAIT 0.15


/**
 * Flag for fish sources. It makes large explosions less efficient at spawning fish.
 * Meant for lazy fishing spots that cover multiple turfs (rivers, oceans etc.)
 */
#define FISH_SOURCE_FLAG_EXPLOSIVE_MALUS (1<<0)
/// The fish source is not elegible for random rewards from bluespace fishing rods
#define FISH_SOURCE_FLAG_NO_BLUESPACE_ROD (1<<1)
/// When examined by someone with enough fishing skill, this will also display fish that doesn't have FISH_FLAG_SHOW_IN_CATALOG
#define FISH_SOURCE_FLAG_IGNORE_HIDDEN_ON_CATALOG (1<<2)
/// This fish source will not spawn fish on explosions
#define FISH_SOURCE_FLAG_EXPLOSIVE_NONE (1<<3)

/**
 * A macro to ensure the wikimedia filenames of fish icons are unique, especially since there're a couple fish that have
 * quite ambiguous names/icon_states like "checkered" or "pike"
 */
#define FISH_AUTOWIKI_FILENAME(fish) SANITIZE_FILENAME("[initial(fish.icon_state)]_wiki_fish")

///The list keys for the autowiki for fish sources
#define FISH_SOURCE_AUTOWIKI_NAME "name"
#define FISH_SOURCE_AUTOWIKI_ICON "icon"
#define FISH_SOURCE_AUTOWIKI_WEIGHT "weight"
#define FISH_SOURCE_AUTOWIKI_WEIGHT_SUFFIX "weight_suffix"
#define FISH_SOURCE_AUTOWIKI_NOTES "notes"

///Special value for the name key that always comes first when the data is sorted, regardless of weight.
#define FISH_SOURCE_AUTOWIKI_DUD "Nothing"
///Special value for the name key that always comes last
#define FISH_SOURCE_AUTOWIKI_OTHER "Other Stuff"
///The filename for the icon for "other stuff" which we don't articulate about on the autowiki
#define FISH_SOURCE_AUTOWIKI_QUESTIONMARK "questionmark"

/// You won't catch duds while fishing with this rod.
#define TRAIT_ROD_REMOVE_FISHING_DUD "rod_remove_fishing_dud"
/// This rod ignores environmental conditions for fishing (like low light for nocturnal fish)
#define TRAIT_ROD_IGNORE_ENVIRONMENT "rod_ignore_environment"
/// This rod attracts fish with the shiny lover fish trait
#define TRAIT_ROD_ATTRACT_SHINY_LOVERS "rod_attract_shiny_lovers"
/// This rod can be used to fish on lava
#define TRAIT_ROD_LAVA_USABLE "rod_lava_usable"
/// Stuff that can go inside fish cases and aquariums
#define TRAIT_AQUARIUM_CONTENT "aquarium_content"
/// If the item can be used as a bit.
#define TRAIT_FISHING_BAIT "fishing_bait"
/// This bait will kill any fish that doesn't have it on its favorite_bait list
#define TRAIT_POISONOUS_BAIT "poisonous_bait"
/// The quality of the bait. It influences odds of catching fish
#define TRAIT_BASIC_QUALITY_BAIT "baic_quality_bait"
#define TRAIT_GOOD_QUALITY_BAIT "good_quality_bait"
#define TRAIT_GREAT_QUALITY_BAIT "great_quality_bait"
/// Baits with this trait will ignore bait preferences and related fish traits.
#define TRAIT_OMNI_BAIT "omni_bait"
/// The bait won't be consumed when used
#define TRAIT_BAIT_UNCONSUMABLE "bait_unconsumable"
/**
 * This bait won't apply TRAIT_ROD_REMOVE_FISHING_DUD to the rod it's attached on,
 * instead, it'll allow the fishing dud to be there unless there's at least one fish that likes the bait
 */
#define TRAIT_BAIT_ALLOW_FISHING_DUD "bait_dont_affect_fishing_dud"
/**
 * This location has the aquarium component. Not much different than a GetComponent()
 * disguised as an 'is_x' macro, but I don't have to hide anything here.
 * I just don't want a confusing 'is_aquarium(A)' macro which people think it's interchangable with
 * an 'istype(A, /obj/structure/aquarium)' when it's the component what truly matters.
 */
/// For locations that prevent fish flopping animation, namely aquariums
#define TRAIT_STOP_FISH_FLOPPING "stop_fish_flopping"
///Trait given to turfs or objects that can be fished from
#define TRAIT_FISHING_SPOT "fishing_spot"
///This trait gets you a list of fishes that can be caught when examining a fishing spot.
#define TRAIT_EXAMINE_FISHING_SPOT "examine_fishing_spot"

///coming from a fish trait datum.
#define FISH_TRAIT_DATUM "fish_trait_datum"
#define TRAIT_EXPERT_FISHER "Expert Fisherman"

// Aquarium related signals

// Fish signals
#define COMSIG_FISH_STATUS_CHANGED "fish_status_changed"
///From /obj/item/fish/process: (seconds_per_tick)
#define COMSIG_FISH_LIFE "fish_life"
///From /datum/fish_trait/eat_fish: (predator)
#define COMSIG_FISH_EATEN_BY_OTHER_FISH "fish_eaten_by_other_fish"
///From /obj/item/fish/generate_reagents_to_add, which returns a holder when the fish is eaten or composted for example: (list/reagents)
#define COMSIG_GENERATE_REAGENTS_TO_ADD "generate_reagents_to_add"
///From /obj/item/fish/update_size_and_weight: (new_size, new_weight)
#define COMSIG_FISH_UPDATE_SIZE_AND_WEIGHT "fish_update_size_and_weight"
///From /obj/item/fish/update_fish_force: (weight_rank, bonus_malus)
#define COMSIG_FISH_FORCE_UPDATED "fish_force_updated"

///From /obj/item/fish/interact_with_atom_secondary, sent to the target: (fish)
#define COMSIG_FISH_RELEASED_INTO "fish_released_into"

///From /datum/fishing_challenge/New: (datum/fishing_challenge/challenge)
#define COMSIG_ROD_BEGIN_FISHING "rod_begin_fishing"
///From /datum/fishing_challenge/New: (datum/fishing_challenge/challenge)
#define COMSIG_MOB_BEGIN_FISHING "mob_begin_fishing"
///From /datum/fishing_challenge/start_minigame_phase: (datum/fishing_challenge/challenge)
#define COMSIG_MOB_BEGIN_FISHING_MINIGAME "mob_begin_fishing_minigame"
///From /datum/fishing_challenge/completed: (datum/fishing_challenge/challenge, win)
#define COMSIG_MOB_COMPLETE_FISHING "mob_complete_fishing"

/// Rolling a reward path for a fishing challenge
#define COMSIG_FISHING_CHALLENGE_ROLL_REWARD "fishing_roll_reward"
/// Adjusting the difficulty of a rishing challenge, often based on the reward path
#define COMSIG_FISHING_CHALLENGE_GET_DIFFICULTY "fishing_get_difficulty"
/// From /datum/fishing_challenge/start_minigame_phase, called after the fish movement datum is spawned: (datum/fish_movement/mover)
#define COMSIG_FISHING_CHALLENGE_MOVER_INITIALIZED "fishing_mover_initialized"
/// Fishing challenge completed
/// Sent to the fisherman when the reward is dispensed: (reward)
#define COMSIG_FISH_SOURCE_REWARD_DISPENSED "fish_source_reward_dispensed"

/// Called when an ai-controlled mob interacts with the fishing spot
#define COMSIG_NPC_FISHING "npc_fishing"
	#define NPC_FISHING_SPOT 1

/// Sent by the target of the fishing rod cast
#define COMSIG_FISHING_ROD_CAST "fishing_rod_cast"
	#define FISHING_ROD_CAST_HANDLED (1 << 0)

/// From /datum/fish_source/proc/dispense_reward(), not set if the reward is a dud: (reward, user)
#define COMSIG_FISHING_ROD_CAUGHT_FISH "fishing_rod_caught_fish"
/// From /obj/item/fishing_rod/proc/hook_item(): (reward, user)
#define COMSIG_FISHING_ROD_HOOKED_ITEM "fishing_rod_hooked_item"

/// From /obj/item/fishing_rod/set_slot: (obj/item/fishing_rod/rod, slot)
#define COMSIG_ITEM_FISHING_ROD_SLOTTED "item_fishing_rod_slotted"
/// From /obj/item/fishing_rod/Exited: (obj/item/fishing_rod/rod, slot)
#define COMSIG_ITEM_FISHING_ROD_UNSLOTTED "item_fishing_rod_unslotted"

/// Sent when the challenge is to be interrupted: (reason)
#define COMSIG_FISHING_SOURCE_INTERRUPT_CHALLENGE "fishing_spot_interrupt_challenge"

/// From /obj/item/fish_analyzer/proc/analyze_status: (fish, user)
#define COMSIG_FISH_ANALYZER_ANALYZE_STATUS "fish_analyzer_analyze_status"

/// From /datum/component/fish_growth/on_fish_life: (seconds_per_tick)
#define COMSIG_FISH_BEFORE_GROWING "fish_before_growing"
	#define COMPONENT_DONT_GROW (1 << 0)
/// From /datum/component/fish_growth/finish_growing: (result)
#define COMSIG_FISH_FINISH_GROWING "fish_finish_growing"

#define COMSIG_ATOM_TEMPORARY_ANIMATION_START "atom_temp_animation"
