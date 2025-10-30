#define GET_AI_BEHAVIOR(behavior_type) SSai_behaviors.ai_behaviors[behavior_type]
#define HAS_AI_CONTROLLER_TYPE(thing, type) istype(thing?.ai_controller, type)
#define AI_STATUS_ON		"ai_on"
#define AI_STATUS_OFF		"ai_off"
#define AI_STATUS_IDLE      "ai_idle"

///Carbon checks
#define SHOULD_RESIST(source) (source.on_fire || source.buckled || HAS_TRAIT(source, TRAIT_RESTRAINED) || (source.pulledby && (source.pulledby != source) && source.pulledby.grab_state > GRAB_PASSIVE))
#define SHOULD_STAND(source) (source.resting)
#define IS_DEAD_OR_INCAP(source) (source.incapacitated(IGNORE_GRAB) || source.stat)


// How far should we, by default, be looking for interesting things to de-idle?
#define AI_DEFAULT_INTERESTING_DIST 10

///Max pathing attempts before auto-fail
#define MAX_PATHING_ATTEMPTS 30
///Flags for ai_behavior new()
#define AI_CONTROLLER_INCOMPATIBLE (1<<0)

///Does this task require movement from the AI before it can be performed?
#define AI_BEHAVIOR_REQUIRE_MOVEMENT (1<<0)
///Does this require the current_movement_target to be adjacent and in reach?
#define AI_BEHAVIOR_REQUIRE_REACH (1<<1)
///Does this task let you perform the action while you move closer? (Things like moving and shooting)
#define AI_BEHAVIOR_MOVE_AND_PERFORM (1<<2)
///Does finishing this task not null the current movement target?
#define AI_BEHAVIOR_KEEP_MOVE_TARGET_ON_FINISH (1<<3)
///Does finishing this task make the AI stop moving towards the target?
#define AI_BEHAVIOR_KEEP_MOVING_TOWARDS_TARGET_ON_FINISH (1<<4)
///Does this behavior NOT block planning?
#define AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION (1<<5)

///Cooldown on planning if planning failed last time
#define AI_FAILED_PLANNING_COOLDOWN 1.5 SECONDS

///Subtree defines
///This subtree should cancel any further planning, (Including from other subtrees)
#define SUBTREE_RETURN_FINISH_PLANNING 1

///AI flags
#define STOP_MOVING_WHEN_PULLED (1<<0)

//Generic BB keys
#define BB_CURRENT_MIN_MOVE_DISTANCE "min_move_distance"

/// Signal sent when a blackboard key is set to a new value
#define COMSIG_AI_BLACKBOARD_KEY_SET(blackboard_key) "ai_blackboard_key_set_[blackboard_key]"
#define COMSIG_AI_BLACKBOARD_KEY_CLEARED(blackboard_key) "ai_blackboard_key_clear_[blackboard_key]"

///sent from ai controllers when they pick behaviors: (list/datum/ai_behavior/old_behaviors, list/datum/ai_behavior/new_behaviors)
#define COMSIG_AI_CONTROLLER_PICKED_BEHAVIORS "ai_controller_picked_behaviors"
///sent from ai controllers when a behavior is inserted into the queue: (list/new_arguments)
#define AI_CONTROLLER_BEHAVIOR_QUEUED(type) "ai_controller_behavior_queued_[type]"

///Targetting keys for something to run away from, if you need to store this separately from current target
#define BB_BASIC_MOB_FLEE_TARGET "BB_basic_flee_target"
#define BB_BASIC_MOB_FLEE_TARGET_HIDING_LOCATION "BB_basic_flee_target_hiding_location"
#define BB_FLEE_TARGETTING_DATUM "flee_targetting_datum"


///time until we should next eat, set by the generic hunger subtree
#define BB_NEXT_HUNGRY "BB_NEXT_HUNGRY"
///what we're going to eat next
#define BB_FOOD_TARGET "bb_food_target"

#define BB_MINIONS_TO_SPAWN "fishboss_minions_to_spawn"
#define BB_NEXT_SUMMON "fishboss_next_summon"
#define BB_SPAWNED_MOBS "fishboss_spawned_mobs"
#define BB_RANGED_COOLDOWN "ranged_cooldown"
#define BB_RAGE_PHASE "fishboss_rage_phase"
#define BB_FISHBOSS_SPECIAL_COOLDOWN "fishboss_special_cooldown"
#define BB_FISHBOSS_TIDAL_WAVE_COOLDOWN "fishboss_tidal_wave_cooldown"
#define BB_FISHBOSS_WHIRLPOOL_COOLDOWN "fishboss_whirlpool_cooldown"
#define BB_FISHBOSS_DEEP_CALL_COOLDOWN "fishboss_deep_call_cooldown"


#define BB_KRAKEN_SUMMON "bb_kraken_summon"
#define BB_KRAKEN_INK "bb_kraken_ink"
#define BB_KRAKEN_WHIRLPOOL "bb_kraken_whirlpool"

///Baby-making blackboard
///Types of animal we can make babies with.
#define BB_BABIES_PARTNER_TYPES "BB_babies_partner"
///Types of animal that we make as a baby.
#define BB_BABIES_CHILD_TYPES "BB_babies_child"
///Current partner target
#define BB_BABIES_TARGET "BB_babies_target"

///Finding adult mob
///key holds the adult we found
#define BB_FOUND_MOM "BB_found_mom"
///key for our nest
#define BB_NESTBOX "BB_nestbox"
///list of types of mobs we will look for
#define BB_FIND_MOM_TYPES "BB_find_mom_types"
///list of types of mobs we must ignore
#define BB_IGNORE_MOM_TYPES "BB_ignore_mom_types"
F
///are we ready to breed?
#define BB_BREED_READY "BB_breed_ready"
///maximum kids we can have
#define BB_MAX_CHILDREN "BB_max_children"

#define BB_MOB_EQUIP_TARGET "BB_equip_target"

#define BB_WANDER_POINT "BB_wander_point"

#define BB_NEST_LIST "BB_nestlist"
#define BB_NEST_IGNORE_LIST "BB_nest_ignore"
#define BB_NEST_MATERIAL_LIST "BB_nest_material_list"

///the bee hive we live inside
#define BB_CURRENT_HOME "BB_current_home"
#define BB_HOME_PATH "BB_home_path"
#define BB_WEAPON_TYPE "BB_weapon_type"
#define BB_ARMOR_CLASS "BB_armorclass"
/// Converts a probability/second chance to probability/seconds_per_tick chance
/// For example, if you want an event to happen with a 10% per second chance, but your proc only runs every 5 seconds, do `if(prob(100*SPT_PROB_RATE(0.1, 5)))`
#define SPT_PROB_RATE(prob_per_second, seconds_per_tick) (1 - (1 - (prob_per_second)) ** (seconds_per_tick))

/// Like SPT_PROB_RATE but easier to use, simply put `if(SPT_PROB(10, 5))`
#define SPT_PROB(prob_per_second_percent, seconds_per_tick) (prob(100*SPT_PROB_RATE((prob_per_second_percent)/100, (seconds_per_tick))))
// )

///our fishing target
#define BB_FISHING_TARGET "BB_fishing_target"

///key holding the list of things we are able to fish from
#define BB_FISHABLE_LIST "BB_fishable_list"

///key holding our cooldown between fishing attempts
#define BB_FISHING_COOLDOWN "BB_fishing_cooldown"

///key that holds the next time we will start fishing
#define BB_FISHING_TIMER "BB_fishing_timer"

///are we ONLY allowed to fish when we're hungry?
#define BB_ONLY_FISH_WHILE_HUNGRY "BB_only_fish_while_hungry"

#define BB_RESISTING "BB_resisting"
#define BB_FUTURE_MOVEMENT_PATH "BB_future_path"

#define BB_MOB_AGGRO_TABLE "aggro_table" // Associative list of [mob] -> threat_level
#define BB_AGGRO_DECAY_TIMER "aggro_decay_timer"
#define BB_HIGHEST_THREAT_MOB "highest_threat_mob"
#define BB_THREAT_THRESHOLD "threat_threshold" // Minimum threat to be considered hostile
#define BB_AGGRO_RANGE "aggro_range" // Range at which mobs can detect and add threats
#define BB_AGGRO_MAINTAIN_RANGE "aggro_maintain_range" // Range at which target is dropped if exceeded
#define BB_HEALING_SOURCE "healing_source" // Who last healed the mob
#define BB_SNEAKING "bb_sneaking"
#define BB_SNEAK_COOLDOWN "bb_sneak_cooldown"

///key holds the world timer for swimming
#define BB_KEY_SWIM_TIME "key_swim_time"
///key holds the water or land target turf
#define BB_SWIM_ALTERNATE_TURF "swim_alternate_turf"
///key holds our state of swimming
#define BB_CURRENTLY_SWIMMING "currently_swimming"
///key holds how long we will be swimming for
#define BB_KEY_SWIMMER_COOLDOWN "key_swimmer_cooldown"

#define BB_LEYLINE_SOURCE "leyline_source"
#define BB_TELEPORT_COOLDOWN "teleport_cooldown"
#define BB_ENERGY_SURGE_COOLDOWN "energy_surge_cooldown"
#define BB_LEYLINE_ENERGY "leyline_energy"
#define BB_SHOCKWAVE_COOLDOWN "shockwave_cooldown"
#define BB_MAX_LEYLINE_ENERGY "max_leyline_energy"
#define BB_ENERGY_REGEN_RATE "energy_regen"
#define BB_BASIC_MOB_STOP_FLEEING "bb_stop_fleeing"

#define BB_DRAGGER_HUNTING_COOLDOWN "dragger_hunting_cooldown"
#define BB_DRAGGER_TELEPORT_COOLDOWN "dragger_teleport_cooldown"
#define BB_DRAGGER_DRAG_COOLDOWN "dragger_drag_cooldown"
#define BB_DRAGGER_DARKNESS_TARGET "dragger_darkness_target"
#define BB_DRAGGER_VICTIM "dragger_victim"
#define BB_DARKNESS_THRESHOLD "darkness_threshold"
#define BB_DRAGGER_DUNGEONEER "dragger_dungeon"

#define BB_HELLHOUND_FIRE "hellhound_fire"

#define BB_FIEND_FLAME_CD "fiend_flame_cd"
#define BB_FIEND_SUMMON_CD "fiend_summon_cd"
#define BB_MINION_COUNT "minion_count"
#define BB_MAX_MINIONS "max_minions"
#define BB_SHROOM_COOLDOWN "shroom_cd"
#define BB_DRUG_COOLDOWN "drug_cd"

#define BB_AGRIOPYLON_BLESS_COOLDOWN "agriopylon_bless_cooldown"

#define BB_QUAKE_COOLDOWN "quake_cooldown"
#define BB_EARTHQUAKE_COOLDOWN "earthquake_cooldown"

#define BB_CAT_REST_CHANCE "cat_rest"
#define BB_CAT_SIT_CHANCE  "cat_sit"
#define BB_CAT_GET_UP_CHANCE "cat_getup"
#define BB_CAT_GROOM_CHANCE "cat_groom"
#define BB_CAT_RACISM  "cat_racist"

/// key that holds the target we will battle over our turf
#define BB_TRESSPASSER_TARGET "tresspasser_target"
/// key that holds angry meows
#define BB_HOSTILE_MEOWS "hostile_meows"
/// key that holds the mouse target
#define BB_MOUSE_TARGET "mouse_target"
/// key that holds our dinner target
#define BB_CAT_FOOD_TARGET "cat_food_target"
/// key that holds the food we must deliver
#define BB_FOOD_TO_DELIVER "food_to_deliver"
/// key that holds things we can hunt
#define BB_HUNTABLE_PREY "huntable_prey"
/// key that holds target kitten to feed
#define BB_KITTEN_TO_FEED "kitten_to_feed"
/// key that holds our hungry meows
#define BB_HUNGRY_MEOW "hungry_meows"
/// key that holds maximum distance food is to us so we can pursue it
#define BB_MAX_DISTANCE_TO_FOOD "max_distance_to_food"
/// key that holds the stove we must turn off
#define BB_STOVE_TARGET "stove_target"
/// key that holds the donut we will decorate
#define BB_DONUT_TARGET "donut_target"
/// key that holds our home...
#define BB_CAT_HOME "cat_home"
/// key that holds the human we will beg
#define BB_HUMAN_BEG_TARGET "human_beg_target"
#define BB_BEGGING_FOOD_ITEM "item_beg_target"

#define BB_CAT_KITTEN_TARGET "BB_cat_kitten_target"
#define BB_CAT_HOLDING_FOOD "BB_cat_holding_food"
#define BB_KITTEN_FOOD_TARGET "BB_kitten_food_target"

#define BB_MINOTAUR_RAGE_METER "minotaur_rage"
#define BB_MINOTAUR_SLAM_COOLDOWN "minotaur_slam"
#define BB_MINOTAUR_PHASE "minotaur_phase"
#define BB_MINOTAUR_CHARGE_COOLDOWN "minotaur_charge"
#define BB_MINOTAUR_FURY_COOLDOWN "minotaur_fury"
#define BB_MINOTAUR_LAST_SPECIAL_ATTACK "minotaur_last_special"
#define BB_MINOTAUR_ENRAGE_BONUS "minotaur_enrage"

#define BB_FLESH_IS_REGENERATING "flesh_regenerating"
#define BB_FLESH_FRENZY_ACTIVE "flesh_frenzy"
#define BB_FLESH_HUNGER "flesh_hunger"
#define BB_FLESH_LAST_HEALTH "flesh_last_health"
#define BB_FLESH_AMBUSH_TARGET "flesh_ambush_target"
#define BB_TEMP_FOOD_TARGET "temp_food_target"
#define BB_FLESH_FRENZY_COOLDOWN "frenzy_cooldown"
#define BB_FLESH_CONSUMED_BODIES "flesh_consumed_bodies"

#define BB_GNOME_WAYPOINT_A "bb_gnome_waypoint_a"
#define BB_GNOME_WAYPOINT_B "bb_gnome_waypoint_b"
#define BB_GNOME_TARGET_ITEM "bb_gnome_target_item"
#define BB_GNOME_HOME_TURF "bb_gnome_home_turf"
#define BB_GNOME_TRANSPORT_MODE "bb_gnome_transport_mode"
#define BB_DROP_ITEM_TARGET "bb_drop_item_target"
#define BB_GNOME_FETCH_TARGET "bb_gnome_fetch_target"
#define BB_GNOME_FETCH_DELIVERY "bb_gnome_fetch_delivery"
#define BB_CURRENT_PET_FRIEND "bb_current_pet_friend"
#define BB_GNOME_FOUND_ITEM "bb_gnome_found_item"
#define BB_GNOME_TRANSPORT_SOURCE "bb_gnome_source"
#define BB_GNOME_TRANSPORT_DEST "bb_gnome_dest"
#define BB_GNOME_SPLITTER_MODE "gnome_splitter_mode"
#define BB_GNOME_TARGET_SPLITTER "gnome_target_splitter"
#define BB_GNOME_CROP_MODE "bb_gnome_crop_mode"
#define BB_GNOME_WATER_SOURCE "gnome_water_source"
#define BB_GNOME_COMPOST_SOURCE "gnome_compost_source"
#define BB_GNOME_SEED_SOURCE "gnome_seed_source"
#define BB_GNOME_SEARCH_RANGE "gnome_search_range"
#define BB_ACTION_STATE_MANAGER "action_state_manager"

#define BB_GNOME_ALCHEMY_MODE "alch_mode"
#define BB_GNOME_TARGET_CAULDRON "target_cauldron"
#define BB_GNOME_TARGET_WELL "well_target"
#define BB_GNOME_CURRENT_RECIPE "current_potion"
#define BB_GNOME_ALCHEMY_STATE "alch_state"
#define BB_GNOME_ESSENCE_STORAGE "essence_storage"
#define BB_GNOME_BOTTLE_STORAGE "bottle_storage"

#define ALCHEMY_STATE_IDLE "idle"
#define ALCHEMY_STATE_NEED_WATER "need_water"
#define ALCHEMY_STATE_FETCH_WATER "fetch_water"
#define ALCHEMY_STATE_ADD_WATER "add_water"
#define ALCHEMY_STATE_NEED_ESSENCES "need_essences"
#define ALCHEMY_STATE_FETCH_ESSENCES "fetch_essences"
#define ALCHEMY_STATE_ADD_ESSENCES "add_essences"
#define ALCHEMY_STATE_WAITING_BREW "waiting_brew"
#define ALCHEMY_STATE_NEED_BOTTLES "need_bottles"
#define ALCHEMY_STATE_FETCH_BOTTLES "fetch_bottles"
#define ALCHEMY_STATE_BOTTLE_PRODUCT "bottle_product"
#define ALCHEMY_STATE_RETURN_BOTTLE "return_bottle"
#define ALCHEMY_STATE_RETURN_WATER_CONTAINER "return_container"
#define ALCHEMY_STATE_RETURN_ESSENCE_VIAL "return_vial"

// Keys used by one and only one behavior
// Used to hold state without making bigass lists
/// For /datum/ai_behavior/find_potential_targets, what if any field are we using currently
#define BB_FIND_TARGETS_FIELD(type) "bb_find_targets_field_[type]"

#define ACTION_STATE_CONTINUE 1
#define ACTION_STATE_COMPLETE 2
#define ACTION_STATE_FAILED 3
