/// From base of [obj/item/attack_self()]: (/mob)
#define COMSIG_ITEM_ATTACK_SELF "item_attack_self"
/// From base of obj/item/attack_self_secondary(): (/mob)
#define COMSIG_ITEM_ATTACK_SELF_SECONDARY "item_attack_self_secondary"

///from base of obj/item/pre_attack(): (atom/target, mob/user, list/modifiers)
#define COMSIG_ITEM_PRE_ATTACK "item_pre_attack"
	#define COMPONENT_NO_ATTACK 1
/// From base of [/obj/item/proc/pre_attack_secondary()]: (atom/target, mob/user, list/modifiers)
#define COMSIG_ITEM_PRE_ATTACK_SECONDARY "item_pre_attack_secondary"
	#define COMPONENT_SECONDARY_CANCEL_ATTACK_CHAIN (1<<0)
	#define COMPONENT_SECONDARY_CONTINUE_ATTACK_CHAIN (1<<1)

/// From base of [obj/item/attack()]: (/mob/living/target, /mob/living/user, list/modifiers)
#define COMSIG_ITEM_ATTACK "item_attack"
/// From base of [/obj/item/proc/attack_secondary()]: (atom/target, mob/user, list/modifiers)
#define COMSIG_ITEM_ATTACK_SECONDARY "item_attack_secondary"
/// From base of obj/item/attack_obj(): (/obj, /mob)
#define COMSIG_ITEM_ATTACK_OBJ "item_attack_obj"

/// From base of [obj/item/afterattack()]: (atom/target, mob/user, proximity_flag, list/modifiers)
#define COMSIG_ITEM_AFTERATTACK "item_afterattack"
/// From base of [obj/item/afterattack_secondary()]: (atom/target, mob/user, list/modifiers)
#define COMSIG_ITEM_AFTERATTACK_SECONDARY "item_afterattack_secondary"

/// From base of obj/item/attack_qdeleted(): (atom/target, mob/user, list/modifiers)
#define COMSIG_ITEM_ATTACK_QDELETED "item_attack_qdeleted"
/// From base of datum/species/proc/spec_attacked_by: (atom/target, mob/user, list/modifiers)
#define COMSIG_ITEM_SPEC_ATTACKEDBY "item_spec_attackedby"

#define COMSIG_ITEM_EQUIPPED "item_equip"						//from base of obj/item/equipped(): (/mob/equipper, slot)

#define COMSIG_QUALITY_ADD_MATERIAL "quality_add_material"
#define COMSIG_QUALITY_MODIFY "quality_modify"
#define COMSIG_QUALITY_GET "quality_get"
#define COMSIG_QUALITY_DECAY "quality_decay"
#define COMSIG_QUALITY_LOCK "quality_lock"
#define COMSIG_QUALITY_RESET "quality_reset"

// /obj/item/gun signals

///called in /obj/item/gun/try_fire_gun (user, src, target, flag, params)
#define COMSIG_MOB_TRYING_TO_FIRE_GUN "mob_trying_to_fire_gun"
///called in /obj/item/gun/fire_gun (user, target, flag, params)
#define COMSIG_GUN_TRY_FIRE "gun_try_fire"
	#define COMPONENT_CANCEL_GUN_FIRE (1<<0) /// Also returned to cancel COMSIG_MOB_TRYING_TO_FIRE_GUN
///called in /obj/item/gun/process_fire (src, target, params, zone_override, bonus_spread_values)
#define COMSIG_MOB_FIRED_GUN "mob_fired_gun"
///called in /obj/item/gun/process_fire (user, target, params, zone_override)
#define COMSIG_GUN_FIRED "gun_fired"
///called in /obj/item/gun/after_firing (src)
#define COMSIG_GUN_CHAMBER_PROCESSED "gun_chamber_processed"
///called in /obj/item/gun/ballistic/after_firing (casing)
#define COMSIG_CASING_EJECTED "casing_ejected"

/// from base of obj/deconstruct(): (disassembled)
#define COMSIG_OBJ_DECONSTRUCT "obj_deconstruct"
/// from base of /obj/structure/setAnchored(): (value)
#define COMSIG_OBJ_SETANCHORED "obj_setanchored"
/// from base of code/game/machinery
#define COMSIG_OBJ_DEFAULT_UNFASTEN_WRENCH "obj_default_unfasten_wrench"
/// From /obj/item/multitool/remove_buffer(): (buffer)
#define COMSIG_MULTITOOL_REMOVE_BUFFER "multitool_remove_buffer"

/// from /obj/proc/unfreeze()
#define COMSIG_OBJ_UNFREEZE "obj_unfreeze"
/// from /obj/machinery/obj_break(damage_flag): (damage_flag)
#define COMSIG_MACHINERY_BROKEN "machinery_broken"
/// from base power_change() when power is lost
#define COMSIG_MACHINERY_POWER_LOST "machinery_power_lost"
/// from base power_change() when power is restored
#define COMSIG_MACHINERY_POWER_RESTORED "machinery_power_restored"

// /obj/item/clothing signals
/// from base of obj/item/clothing/shoes/proc/step_action(): ()
#define COMSIG_CLOTHING_STEP_ACTION "clothing_step_action"

/// from base of obj/item/reagent_containers/food/snacks/attack(): (mob/living/eater, mob/feeder)
#define COMSIG_FOOD_EATEN "food_eaten"
