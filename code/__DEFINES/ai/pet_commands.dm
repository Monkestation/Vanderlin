/// Blackboard field for the most recent command the pet was given
#define BB_ACTIVE_PET_COMMAND "BB_active_pet_command"
/// Blackboard field for what we actually want the pet to target
#define BB_CURRENT_PET_TARGET "BB_current_pet_target"
/// Blackboard field for how we target things, as usually we want to be more permissive than normal
#define BB_PET_TARGETING_DATUM "BB_pet_targeting"
/// Typecache of strong refs to mobs this mob is friends with, will follow their instructions and won't attack them
#define BB_FRIENDS_LIST "BB_friends_list"
/// List of strings we might say to encourage someone to make better choices.
#define BB_OWNER_SELF_HARM_RESPONSES "BB_self_harm_responses"
/// After this long without having fetched something, we clear our ignore list
#define AI_FETCH_IGNORE_DURATION (30 SECONDS)
/// Blackboard key for a held item
#define BB_SIMPLE_CARRY_ITEM "BB_SIMPLE_CARRY_ITEM"
#define BB_FETCH_IGNORE_LIST "BB_FETCH_IGNORE_LISTlist"
#define BB_FETCH_DELIVER_TO "BB_FETCH_DELIVER_TO"
