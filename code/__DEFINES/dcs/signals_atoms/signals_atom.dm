///from base of atom/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
#define COMSIG_ATOM_HITBY "atom_hitby"

#define COMSIG_LOCKPICK_ONMOUSEDOWN "lockpick_onmousedown"
	#define COMPONENT_LOCKPICK_ONMOUSEDOWN_BYPASS (1<<0)

#define COMPONENT_PICKED "picked"

#define COMSIG_ATOM_PROXY_STEAM_USE "proxy_steam_usage"

#define COMSIG_ATOM_STEAM_USE "steam_usage"

#define COMSIG_ATOM_STEAM_INCREASE "steam_increase"

#define COMSIG_ATOM_WATER_USE "water_usage"

#define COMSIG_ATOM_WATER_INCREASE "water_increase"

#define COMSIG_ATOM_PROXY_WATER_USE "proxy_water_usage"

///from base of atom/attackby(): (/obj/item, /mob/living, list/modifiers)
#define COMSIG_ATOM_ATTACKBY "atom_attackby"
/// From base of [atom/proc/attacby_secondary()]: (/obj/item/weapon, /mob/user, list/modifiers)
#define COMSIG_ATOM_ATTACKBY_SECONDARY "atom_attackby_secondary"
	/// Return this in response if you don't want afterattack to be called
	#define COMPONENT_NO_AFTERATTACK 1

/// From base of atom/attack_hand(): (mob/user)
#define COMSIG_ATOM_ATTACK_HAND "atom_attack_hand"
/// From base of atom/attack_hand_secondary(): (mob/user)
#define COMSIG_ATOM_ATTACK_HAND_SECONDARY "atom_attack_hand_secondary"

/// From base of atom/attack_ghost(): (mob/dead/observer/ghost)
#define COMSIG_ATOM_ATTACK_GHOST "atom_attack_ghost"
/// From base of atom/attack_paw(): (mob/user)
#define COMSIG_ATOM_ATTACK_PAW "atom_attack_paw"
/// From base of atom/animal_attack(): (/mob/user)
#define COMSIG_ATOM_ATTACK_ANIMAL "attack_animal"
/// From relay_attackers element: (atom/attacker, attack_flags)
#define COMSIG_ATOM_WAS_ATTACKED "atom_was_attacked"

/* Attack signals. They should share the returned flags, to standardize the attack chain. */
/// tool_act -> pre_attack -> target.attackby (item.attack) -> afterattack
	///Ends the attack chain. If sent early might cause posterior attacks not to happen.
	#define COMPONENT_CANCEL_ATTACK_CHAIN (1<<0)
	///Skips the specific attack step, continuing for the next one to happen.
	#define COMPONENT_SKIP_ATTACK (1<<1)


#define COMSIG_ATOM_GET_RESISTANCE "atom_get_resistance"
#define COMSIG_ATOM_GET_MAX_RESISTANCE "atom_get_max_resistance"
#define COMSIG_ATOM_GET_STATUS_MOD "atom_get_status_mod"

/// from /atom/proc/atom_break: (damage_flag)
#define COMSIG_ATOM_BREAK "atom_break"
/// from base of [/atom/proc/atom_fix]: ()
#define COMSIG_ATOM_FIX "atom_fix"
/// from base of [/atom/proc/atom_destruction]: (damage_flag)
#define COMSIG_ATOM_DESTRUCTION "atom_destruction"
///from base of [/atom/proc/update_integrity]: (old_value, new_value)
#define COMSIG_ATOM_INTEGRITY_CHANGED "atom_integrity_changed"
///from base of [/atom/proc/take_damage]: (damage_amount, damage_type, damage_flag, sound_effect, attack_dir, aurmor_penetration)
#define COMSIG_ATOM_TAKE_DAMAGE "atom_take_damage"
	/// Return bitflags for the above signal which prevents the atom taking any damage.
	#define COMPONENT_NO_TAKE_DAMAGE (1<<0)
