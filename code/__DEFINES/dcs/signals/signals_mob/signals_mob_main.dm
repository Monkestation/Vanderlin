#define COMSIG_MOB_MOVESPEED_UPDATED "mob_updated_movespeed"
///from base of /mob/Login(): ()
#define COMSIG_MOB_LOGIN "mob_login"
///from base of /mob/Logout(): ()
#define COMSIG_MOB_LOGOUT "mob_logout"
/// sent when a mob/login() finishes: (client)
#define COMSIG_MOB_CLIENT_LOGIN "comsig_mob_client_login"
#define COMSIG_MOB_STATCHANGE "mob_statchange"

/// Sent from /proc/do_after if someone starts a do_after action bar.
#define COMSIG_DO_AFTER_BEGAN "mob_do_after_began"
/// Sent from /proc/do_after once a do_after action completes, whether via the bar filling or via interruption.
#define COMSIG_DO_AFTER_ENDED "mob_do_after_ended"
#define COMSIG_PHASE_CHANGE "phase_change"

///from base of mob/can_cast_magic(): (mob/user, magic_flags, charge_cost)
#define COMSIG_MOB_RESTRICT_MAGIC "mob_cast_magic"
///from base of mob/can_block_magic(): (mob/user, casted_magic_flags, charge_cost)
#define COMSIG_MOB_RECEIVE_MAGIC "mob_receive_magic"
	#define COMPONENT_MAGIC_BLOCKED (1<<0)

///from base of mob/swap_hand(): (obj/item/currently_held_item)
#define COMSIG_MOB_SWAPPING_HANDS "mob_swapping_hands"
	#define COMPONENT_BLOCK_SWAP (1<<0)

///Mob is trying to emote, from /datum/emote/proc/run_emote(): (key, params, type_override, intentional, emote)
#define COMSIG_MOB_PRE_EMOTED "mob_pre_emoted"
	#define COMPONENT_CANT_EMOTE (1<<0)
///from /mob/living/emote(): ()
#define COMSIG_MOB_EMOTE "mob_emote"
#define COMSIG_MOB_EMOTED(emote_key) "mob_emoted_[emote_key]"
///from /mob/living/check_cooldown(): ()
#define COMSIG_MOB_EMOTE_COOLDOWN_CHECK "mob_emote_cd"
	/// make a wild guess
	#define COMPONENT_EMOTE_COOLDOWN_BYPASS (1<<0)

/// from mob/get_status_tab_items(): (list/items)
#define COMSIG_MOB_GET_STATUS_TAB_ITEMS "mob_get_status_tab_items"

/// from /mob/proc/change_mob_type() : ()
#define COMSIG_PRE_MOB_CHANGED_TYPE "mob_changed_type"
	#define COMPONENT_BLOCK_MOB_CHANGE (1<<0)
/// from /mob/proc/change_mob_type_unchecked() : ()
#define COMSIG_MOB_CHANGED_TYPE "mob_changed_type"

/// from /mob/toggle_cmode(): (mob/user, new_state)
#define COMSIG_MOB_TOGGLE_CMODE "mob_toggle_cmode"

#define COMSIG_MOB_BREAK_SNEAK "mob_break_sneak"

#define COMSIG_MOB_TRY_BARK "try_bark"
#define COMSIG_MOB_MODIFY_AGGRO_LINES "comsig_mob_modify_aggro_lines"
#define COMSIG_MOB_MODIFY_DEATH_LINES "comsig_mob_modify_death_lines"

#define COMSIG_MOB_CREATED_CALLOUT "mob_created_callout"

/// from base of mob/clickon(): (atom/A, params)
#define COMSIG_MOB_CLICKON "mob_clickon"

/// from base of mob/MiddleClickOn(): (atom/A)
#define COMSIG_MOB_MIDDLECLICKON "mob_middleclickon"
/// from base of mob/AltClickOn(): (atom/A)
#define COMSIG_MOB_ALTCLICKON "mob_altclickon"
	#define COMSIG_MOB_CANCEL_CLICKON 1

/// from base of obj/allowed(mob/M): (/obj) returns bool, if TRUE the mob has id access to the obj
#define COMSIG_MOB_ALLOWED "mob_allowed"
/// from base of mob/create_mob_hud(): ()
#define COMSIG_MOB_HUD_CREATED "mob_hud_created"
/// from base of
#define COMSIG_MOB_ATTACK_HAND "mob_attack_hand"
/// from base of /obj/item/attack(): (mob/M, mob/user)
#define COMSIG_MOB_ITEM_ATTACK "mob_item_attack"
	#define COMPONENT_ITEM_NO_ATTACK 1
/// from base of /mob/living/proc/apply_damage(): (damage, damagetype, def_zone)
#define COMSIG_MOB_APPLY_DAMAGE	"mob_apply_damage"
/// from base of obj/item/afterattack(): (atom/target, mob/user, proximity_flag, click_parameters)
#define COMSIG_MOB_ITEM_AFTERATTACK "mob_item_afterattack"
/// from base of obj/item/attack_qdeleted(): (atom/target, mob/user, proxiumity_flag, click_parameters)
#define COMSIG_MOB_ITEM_ATTACK_QDELETED "mob_item_attack_qdeleted"
/// from base of mob/RangedAttack(): (atom/A, params)
#define COMSIG_MOB_ATTACK_RANGED "mob_attack_ranged"
/// from base of /datum/component/ranged_attacks/proc/async_fire_ranged_attack: (mob/living/simple_animal/firer, atom/target, list/modifiers)
#define COMSIG_MOB_POSTATTACK_RANGED "mob_postattack_ranged"
/// from base of /mob/throw_item(): (atom/target)
#define COMSIG_MOB_THROW "mob_throw"
/// from base of /mob/verb/examinate(): (atom/target)
#define COMSIG_MOB_EXAMINATE "mob_examinate"
/// from base of mob/living/carbon/examine(): (mob/user, mob/target, list/pronouns, list/examine_strings)
#define COMSIG_MOB_EXAMINATE_CARBON "mob_examinte_carbon"
/// from base of /mob/update_sight(): ()
#define COMSIG_MOB_UPDATE_SIGHT "mob_update_sight"
/// from /mob/living/say(): ()
#define COMSIG_MOB_SAY "mob_say"
	#define COMPONENT_UPPERCASE_SPEECH 1
	#define COMPONENT_SPEECH_CANCEL (1<<1)
	// used to access COMSIG_MOB_SAY argslist
	#define SPEECH_MESSAGE 1
	// #define SPEECH_BUBBLE_TYPE 2
	#define SPEECH_SPANS 3
	#define SPEECH_LANGUAGE 5
	/* #define SPEECH_SANITIZE 4

	#define SPEECH_IGNORE_SPAM 6
	#define SPEECH_FORCED 7 */

#define COMSIG_MOB_DEADSAY "mob_deadsay"
	#define MOB_DEADSAY_SIGNAL_INTERCEPT 1
///from base of /mob/verb/pointed: (atom/A)
#define COMSIG_MOB_POINTED "mob_pointed"

/// from base of /mob/living/proc/apply_status_effect: (datum/status_effect/new_effect, duration_override, ...)
#define COMSIG_MOB_APPLIED_STATUS_EFFECT "mob_applied_status_effect"

/// From base of /client/Move(): (new_loc, direction)
#define COMSIG_MOB_CLIENT_PRE_MOVE "mob_client_pre_move"
	/// Should always match COMPONENT_MOVABLE_BLOCK_PRE_MOVE as these are interchangeable and used to block movement.
	#define COMSIG_MOB_CLIENT_BLOCK_PRE_MOVE COMPONENT_MOVABLE_BLOCK_PRE_MOVE
	/// The argument of move_args which corresponds to the loc we're moving to
	#define MOVE_ARG_NEW_LOC 1
	/// The arugment of move_args which dictates our movement direction
	#define MOVE_ARG_DIRECTION 2

/// From base of /client/Move(): (direction, old_direction)
#define COMSIG_MOB_CLIENT_MOVED "mob_client_moved"

#define COMSIG_MOB_DROPITEM "mob_dropitem"
/// A mob has just equipped an item. Called on [/mob] from base of [/obj/item/equipped()]: (/obj/item/equipped_item, slot)
#define COMSIG_MOB_EQUIPPED_ITEM "mob_equipped_item"
/// A mob has just unequipped an item.
#define COMSIG_MOB_UNEQUIPPED_ITEM "mob_unequipped_item"
///called on [/obj/item] before unequip from base of [mob/proc/doUnEquip]: (force, atom/newloc, no_move, invdrop, silent)
#define COMSIG_ITEM_PRE_UNEQUIP "item_pre_unequip"
	///only the pre unequip can be cancelled
	#define COMPONENT_ITEM_BLOCK_UNEQUIP (1<<0)
///called on [/obj/item] AFTER unequip from base of [mob/proc/doUnEquip]: (force, atom/newloc, no_move, invdrop, silent)
#define COMSIG_ITEM_POST_UNEQUIP "item_post_unequip"
///from base of obj/item/dropped(): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
///from base of obj/item/pickup(): (/mob/taker)
#define COMSIG_ITEM_PICKUP "item_pickup"
///from base of obj/item/afterpickup(): (/mob/taker)
#define COMSIG_ITEM_AFTER_PICKUP "item_after_pickup"
///from base of mob/living/carbon/attacked_by(): (mob/living/carbon/target, mob/living/user, hit_zone)
#define COMSIG_ITEM_ATTACK_ZONE "item_attack_zone"
///from base of obj/item/hit_reaction(): (list/args)
#define COMSIG_ITEM_HIT_REACT "item_hit_react"
#define COMSIG_ITEM_HIT_RESPONSE "item_hit_response"
///called on item when crossed by something (): (/atom/movable, mob/living/crossed)
#define COMSIG_ITEM_WEARERCROSSED "wearer_crossed"

#define COMSIG_MOB_MOUSE_ENTERED "user_mouse_entered"
