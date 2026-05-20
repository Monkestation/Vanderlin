///Hostile AI controller blackboard keys
#define BB_HOSTILE_ORDER_MODE "BB_HOSTILE_ORDER_MODE"
#define BB_HOSTILE_FRIEND "BB_HOSTILE_FRIEND"
#define BB_HOSTILE_ATTACK_WORD "BB_HOSTILE_ATTACK_WORD"
#define BB_FOLLOW_TARGET "BB_FOLLOW_TARGET"
#define BB_ATTACK_TARGET "BB_ATTACK_TARGET"
#define BB_VISION_RANGE "BB_VISION_RANGE"

/// Basically, what is our vision/hearing range.
#define BB_HOSTILE_VISION_RANGE 10
/// After either being given a verbal order or a pointing order, ignore further of each for this duration
#define AI_HOSTILE_COMMAND_COOLDOWN (2 SECONDS)

// hostile command modes (what pointing at something/someone does depending on the last order the carp heard)
/// Don't do anything (will still react to stuff around them though)
#define HOSTILE_COMMAND_NONE 0
/// Will attack a target.
#define HOSTILE_COMMAND_ATTACK 1
/// Will follow a target.
#define HOSTILE_COMMAND_FOLLOW 2

#define COMMAND_FOLLOW "Follow"
#define COMMAND_STOP "Stop"
#define COMMAND_ATTACK "Attack"


//Hunting defines
#define SUCCESFUL_HUNT_COOLDOWN 5 SECONDS

///Hunting BB keys
#define BB_CURRENT_HUNTING_TARGET "BB_current_hunting_target"
#define BB_HUNTING_COOLDOWN "BB_HUNTING_COOLDOWN"

///Basic Mob Keys

///Tipped blackboards
///Bool that means a basic mob will start reacting to being tipped in it's planning
#define BB_BASIC_MOB_TIP_REACTING "BB_basic_tip_reacting"
///the motherfucker who tipped us
#define BB_BASIC_MOB_TIPPER "BB_basic_tip_tipper"

///Targetting subtrees
#define BB_TARGETED_ACTION "BB_targeted_action"
#define BB_BASIC_MOB_PRIORITY_TARGETS "BB_basic_priority_targets"
#define BB_BASIC_MOB_CURRENT_TARGET "BB_basic_current_target"
#define BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION "BB_basic_current_target_hiding_location"
#define BB_TARGETTING_DATUM "targetting_datum"
#define BB_BASIC_MOB_FOOD_TARGET "BB_basic_food_target"
#define BB_TARGETTING_DATUM_EQUIPMENT "equip_targetting_datum"
#define BB_BASIC_MOB_RUN_WITH_ITEM "BB_run_with_item"
#define BB_BASIC_MOB_EQUIPMENT_TARGET "BB_equipment_target"
#define BB_BASIC_MOB_NEED_EQUIP "BB_needs_to_equip"
#define BB_BASIC_MOB_UNEQUIPPED_WEAPON "BB_unequipped_weapon"
/// Key for the minimum status at which we want to target mobs (does not need to be specified if CONSCIOUS)
#define BB_TARGET_MINIMUM_STAT "BB_target_minimum_stat"
/// Flag for whether to target only wounded mobs
#define BB_TARGET_WOUNDED_ONLY "BB_target_wounded_only"
/// What typepath the holding object targeting strategy should look for
#define BB_TARGET_HELD_ITEM "BB_target_held_item"

///list of foods this mob likes
#define BB_BASIC_FOODS "BB_basic_foods"
///What creature we want to cocoon
#define BB_BASIC_MOB_COCOON_TARGET "BB_basic_mob_cocoon_target"

/// Flag to set on or off if you want your mob to prioritise running away
#define BB_BASIC_MOB_FLEEING "BB_basic_fleeing"
#define BB_BASIC_MOB_NEXT_FLEEING "BB_nex_flee"

///List of mobs who have damaged us
#define BB_BASIC_MOB_RETALIATE_LIST "BB_basic_mob_shitlist"

#define BB_GATOR_IN_WATER "BB_gator_in_water"
#define BB_GATOR_AMBUSH_COOLDOWN "BB_gator_ambush_cooldown"
#define BB_GATOR_DEATH_ROLL_COOLDOWN "BB_gator_death_roll_cooldown"
#define BB_GATOR_PREFERRED_TERRITORY "BB_gator_preferred_territory"

#define BB_DRAGON_ENRAGED "dragon_enraged"
#define BB_DRAGON_SWOOPING "dragon_swooping"
#define BB_DRAGON_RECOVERY_TIME "dragon_recovery_time"
#define BB_DRAGON_ANGER_MODIFIER "dragon_anger_modifier"
#define BB_DRAGON_ATTACK_TYPE "dragon_attack_type"
#define BB_DRAGON_HEALTH_PERCENTAGE "dragon_health_percentage"
#define BB_DRAGON_CL_COOLDOWN "dragon_cl_cooldown"
#define BB_DRAGON_LIGHTNING_COOLDOWN "dragon_lightning_cooldown"
#define BB_DRAGON_SUMMON_COOLDOWN "dragon_summon_cooldown"
#define BB_DRAGON_SLAM_COOLDOWN "dragon_slam_cooldown"
#define BB_DRAGON_SPECIAL_COOLDOWN "dragon_special_cooldown"
#define BB_DRAGON_VOID_COOLDOWN "dragon_void_cooldown"
#define BB_DRAGON_CLONE_COOLDOWN "dragon_clone_cooldown"
#define BB_DRAGON_WING_COOLDOWN "dragon_wing_cooldown"
#define BB_DRAGON_EXPLOSION_COOLDOWN "dragon_explosion_cooldown"
#define BB_DRAGON_PHASE_COOLDOWN "dragon_ohase_cooldown"

#define BB_IS_BEING_RIDDEN "bb_is_ridden"
#define BB_BASIC_MOB_SCARED_ITEM "scared_item"
