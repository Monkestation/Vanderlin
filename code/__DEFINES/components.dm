// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

//////////////////////////////////////////////////////////////////

// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"

#define COMSIG_TRAP_TRIGGERED "trap_triggered_parent"
#define COMSIG_LOOT_SPAWNER_EMPTY "loot_spawner_empty"

/*******Component Specific Signals*******/
//Janitor
#define COMSIG_TURF_IS_WET "check_turf_wet"							//(): Returns bitflags of wet values.
#define COMSIG_TURF_MAKE_DRY "make_turf_try"						//(max_strength, immediate, duration_decrease = INFINITY): Returns bool.
#define COMSIG_COMPONENT_CLEAN_ACT "clean_act"					//called on an object to clean it of cleanables. Usualy with soap: (num/strength)

//Creamed
#define COMSIG_COMPONENT_CLEAN_FACE_ACT "clean_face_act"		//called when you wash your face at a sink: (num/strength)

//Gibs
#define COMSIG_GIBS_STREAK "gibs_streak"						// from base of /obj/effect/decal/cleanable/blood/gibs/streak(): (list/directions, list/diseases)

#define COMSIG_CONTAINER_CRAFT_COMPLETE "container_craft_complete"
// /datum/component/storage signals
#define COMSIG_CONTAINS_STORAGE "is_storage"							//() - returns bool.
#define COMSIG_TRY_STORAGE_INSERT "storage_try_insert"					//(obj/item/inserting, mob/user, silent, force) - returns bool
#define COMSIG_TRY_STORAGE_SHOW "storage_show_to"						//(mob/show_to, force) - returns bool.
#define COMSIG_TRY_STORAGE_HIDE_FROM "storage_hide_from"				//(mob/hide_from) - returns bool
#define COMSIG_TRY_STORAGE_HIDE_ALL "storage_hide_all"					//returns bool
#define COMSIG_TRY_STORAGE_SET_LOCKSTATE "storage_lock_set_state"		//(newstate)
#define COMSIG_IS_STORAGE_LOCKED "storage_get_lockstate"				//() - returns bool. MUST CHECK IF STORAGE IS THERE FIRST!
#define COMSIG_TRY_STORAGE_TAKE_TYPE "storage_take_type"				//(type, atom/destination, amount = INFINITY, check_adjacent, force, mob/user, list/inserted) - returns bool - type can be a list of types.
#define COMSIG_TRY_STORAGE_FILL_TYPE "storage_fill_type"				//(type, amount = INFINITY, force = FALSE)			//don't fuck this up. Force will ignore max_items, and amount is normally clamped to max_items.
#define COMSIG_TRY_STORAGE_TAKE "storage_take_obj"						//(obj, new_loc, force = FALSE) - returns bool
#define COMSIG_TRY_STORAGE_QUICK_EMPTY "storage_quick_empty"			//(loc) - returns bool - if loc is null it will dump at parent location.
#define COMSIG_TRY_STORAGE_RETURN_INVENTORY "storage_return_inventory"	//(list/list_to_inject_results_into, recursively_search_inside_storages = TRUE)
#define COMSIG_TRY_STORAGE_CAN_INSERT "storage_can_equip"				//(obj/item/insertion_candidate, mob/user, silent) - returns bool
#define COMSIG_STORAGE_CLOSED "storage_close"
#define COMSIG_STORAGE_REMOVED "storage_item_removed"
#define COMSIG_STORAGE_ADDED "storage_item_added"

// ~storage component
///from base of datum/component/storage/can_user_take(): (mob/user)
#define COMSIG_STORAGE_BLOCK_USER_TAKE "storage_block_user_take"

/*******Non-Signal Component Related Defines*******/

//Ouch my toes!
#define CALTROP_BYPASS_SHOES (1 << 0)
#define CALTROP_IGNORE_WALKERS (1 << 1)
#define CALTROP_SILENT (1 << 2)
#define CALTROP_NOSTUN (1 << 3)
#define CALTROP_NOCRAWL (1 << 4)

#define COMSIG_IMPREGNATE "comsig_mob_impregnate"

#define COMSIG_CANCEL_TURF_BREAK "cancel_turf_break_comsig"

#define COMSIG_HABITABLE_HOME "comsig_habitable_home"

#define COMSIG_COMBAT_TARGET_SET "comsig_combat_target_set"

#define COMSIG_DISGUISE_STATUS "comsig_disguise_status"
#define COMSIG_OBSERVABLE_CHANGE "comsig_observable_change"
///sent to targets during the process_hit proc of projectiles
#define COMSIG_PELLET_CLOUD_INIT "pellet_cloud_init"
///called in /obj/item/gun/process_fire (user, target, modifiers, zone_override)
#define COMSIG_GRENADE_DETONATE "grenade_prime"
//called from many places in grenade code (armed_by, nade, det_time, delayoverride)
#define COMSIG_MOB_GRENADE_ARMED "grenade_mob_armed"
///called in /obj/item/gun/process_fire (user, target, modifiers, zone_override)
#define COMSIG_GRENADE_ARMED "grenade_armed"

#define COMSIG_MOB_HEALTHHUD_UPDATE "update_healthhud"

#define COMSIG_ITEM_ATTACK_EFFECT "item_attack_effect"
#define COMSIG_ITEM_ATTACK_EFFECT_SELF "item_attack_effect_self"
#define COMSIG_DOOR_OPENED "door_open"

/// send this signal to add /datum/component/vis_radius to a list of mobs or one mob: (mob/mob_or_mobs)
#define COMSIG_SHOW_RADIUS "show_radius"
/// send this signal to remove /datum/component/vis_radius to a mobs: ()
#define COMSIG_HIDE_RADIUS "hide_radius"
/// send this signal to remove a list of tip ids(use tip_names as tip ids): (/list/tip_ids_to_remove)
#define COMSIG_TIPS_REMOVE "comsig_tip_remove"
///used incase we care about a tracker dying
#define COMSIG_LIVING_TRACKER_REMOVED "tracker_removed"
///used when a command is issued to someone, if they have the correct component acts on this
#define COMSIG_PARENT_COMMAND_RECEIVED	"command_received"

#define COMSIG_AUGMENT_INSTALL "augment_install"
#define COMSIG_AUGMENT_REMOVE "augment_remove"
#define COMSIG_AUGMENT_REPAIR "augment_repair"
#define COMSIG_AUGMENT_GET_STABILITY "augment_get_stability"
#define COMSIG_AUGMENT_GET_INSTALLED "augment_get_installed"

#define COMPONENT_AUGMENT_SUCCESS (1<<0)
#define COMPONENT_AUGMENT_FAILED (1<<1)
#define COMPONENT_AUGMENT_CONFLICT (1<<2)

#define COMSIG_SHARE_APPRENTICE_XP "comsig_share_xp"
#define COMSIG_SKILL_LEVEL_CHANGE "comsig_level_changed"
