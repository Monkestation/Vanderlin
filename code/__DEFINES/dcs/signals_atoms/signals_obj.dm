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
///called in /obj/item/gun/process_fire (src, target, list/modifiers, zone_override)
#define COMSIG_MOB_FIRED_GUN "mob_fired_gun"
///called in /obj/item/gun/process_fire (user, target, list/modifiers, zone_override)
#define COMSIG_GUN_FIRED "gun_fired"
