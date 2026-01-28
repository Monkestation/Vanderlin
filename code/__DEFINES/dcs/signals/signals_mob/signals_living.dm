///From post-can inject check of syringe after attack (mob/user)
#define COMSIG_LIVING_TRY_SYRINGE "living_try_syringe"

#define COMSIG_KB_LIVING_ITEM_PIXEL_SHIFT_DOWN	"keybinding_living_item_pixelshift_down"
#define COMSIG_KB_LIVING_ITEM_PIXEL_SHIFT_UP	"keybinding_living_item_pixelshift_up"
#define COMSIG_KB_LIVING_PIXELSHIFT				"keybinding_living_pixelshift"
#define COMSIG_KB_LIVING_PIXEL_SHIFT_DOWN		"keybinding_living_pixelshift_down"
#define COMSIG_KB_LIVING_PIXEL_SHIFT_UP			"keybinding_living_pixelshift_up"

///from base of mob/living/set_buckled(): (new_buckled)
#define COMSIG_LIVING_SET_BUCKLED "living_set_buckled"

///Signal sent when a keybind is deactivated
#define DEACTIVATE_KEYBIND(A) "[A]_DEACTIVATED"
#define COMSIG_KB_LIVING_VIEW_PET_COMMANDS "keybinding_living_view_pet_commands"

// /mob/living signals
#define COMSIG_LIVING_SET_RESTING "comsig_set_resting"
#define COMSIG_LIVING_RESIST "living_resist"					//from base of mob/living/resist() (/mob/living)
#define COMSIG_LIVING_RESIST_GRAB "living_resist_grab"			//from base of mob/living/resist_grab() (/mob/living)
#define COMSIG_LIVING_IGNITED "living_ignite"					//from base of mob/living/IgniteMob() (/mob/living)
#define COMSIG_LIVING_EXTINGUISHED "living_extinguished"		//from base of mob/living/ExtinguishMob() (/mob/living)
#define COMSIG_LIVING_ELECTROCUTE_ACT "living_electrocute_act"	//from base of mob/living/electrocute_act(): (shock_damage, source, siemens_coeff, flags)
#define COMSIG_LIVING_MINOR_SHOCK "living_minor_shock"			//sent by stuff like stunbatons and tasers: ()
#define COMSIG_LIVING_REVIVE "living_revive"					//from base of mob/living/revive() (full_heal, admin_revive)
#define COMSIG_PROCESS_BORGCHARGER_OCCUPANT "living_charge"		//sent from borg recharge stations: (amount, repairs)
#define COMSIG_BORG_SAFE_DECONSTRUCT "borg_safe_decon"			//sent from borg mobs to itself, for tools to catch an upcoming destroy() due to safe decon (rather than detonation)
#define COMSIG_MOB_ACTIVE_PERCEPTION "comsig_mob_active_perception"	//sent from mob/living/proc/look_around(): (mob/living/source)
#define COMSIG_LIVING_WOUND_GAINED "wound_gained"

// Client
/// sent when a mob/login() finishes: (client)
#define COMSIG_MOB_CLIENT_LOGIN "comsig_mob_client_login"
/// from base of client/MouseDown(): (/client, object, location, control, params)
#define COMSIG_CLIENT_MOUSEDOWN "client_mousedown"
/// from base of client/MouseUp(): (/client, object, location, control, params)
#define COMSIG_CLIENT_MOUSEUP "client_mouseup"
	#define COMPONENT_CLIENT_MOUSEUP_INTERCEPT (1<<0)
/// from base of client/MouseUp(): (/client, object, location, control, params)
#define COMSIG_CLIENT_MOUSEDRAG "client_mousedrag"

//ALL OF THESE DO NOT TAKE INTO ACCOUNT WHETHER AMOUNT IS 0 OR LOWER AND ARE SENT REGARDLESS!
///from base of mob/living/OffBalance() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_OFFBALANCED "living_offbalanced"
///from base of mob/living/Stun() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_STUN "living_stun"
///from base of mob/living/Knockdown() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_KNOCKDOWN "living_knockdown"
///from base of mob/living/Paralyze() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_PARALYZE "living_paralyze"
///from base of mob/living/Immobilize() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_IMMOBILIZE "living_immobilize"
///from base of mob/living/Immobilize() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_UNCONSCIOUS "living_unconscious"
/// from base of mob/living/updatehealth(amount)
#define COMSIG_LIVING_HEALTH_UPDATE "living_health_update"
///from base of mob/living/Sleeping() (amount, ignore_canstun)
#define COMSIG_LIVING_STATUS_SLEEP "living_sleeping"
	#define COMPONENT_NO_STUN 1			//For all of them
///from end of fully_heal(): (heal_flags)
#define COMSIG_LIVING_POST_FULLY_HEAL "living_post_fully_heal"
///from base of /mob/living/can_track(): (mob/user)
#define COMSIG_LIVING_CAN_TRACK "mob_cantrack"
	#define COMPONENT_CANT_TRACK 1
///from base of mob/living/death(): (gibbed)
#define COMSIG_LIVING_DEATH "living_death"
#define COMSIG_LIVING_TRY_ENTER_AFTERLIFE "try_enter_afterlife"
/// From /mob/living/befriend() : (mob/living/new_friend)
#define COMSIG_LIVING_BEFRIENDED "living_befriended"
/// From /mob/living/unfriend() : (mob/living/old_friend)
#define COMSIG_LIVING_UNFRIENDED "living_unfriended"

///from base of mob/living/set_body_position(): (new_position, old_position)
#define COMSIG_LIVING_SET_BODY_POSITION  "living_set_body_position"

/// from base of [datum/mana_pool/adjust_mana()]
#define COMSIG_LIVING_MANA_CHANGED "living_mana_changed"
/// from base of [datum/devotion/cleric_holder/update_devotion()]
#define COMSIG_LIVING_DEVOTION_CHANGED "living_devotion_changed"

///from base of
#define COMSIG_LIVING_DREAM_END  "living_sleep_advancement_end"

///called on /living when attempting to pick up an item, from base of /mob/living/put_in_hand_check(): (obj/item/I)
#define COMSIG_LIVING_TRY_PUT_IN_HAND "living_try_put_in_hand"
	/// Can't pick up
	#define COMPONENT_LIVING_CANT_PUT_IN_HAND (1<<0)

///From mob/living/proc/wabbajack(): (randomize_type)
#define COMSIG_LIVING_PRE_WABBAJACKED "living_mob_wabbajacked"
	/// Return to stop the rest of the wabbajack from triggering.
	#define STOP_WABBAJACK (1<<0)
///From mob/living/proc/on_wabbajack(): (mob/living/new_mob)
#define COMSIG_LIVING_ON_WABBAJACKED "living_wabbajacked"

/// From /datum/status_effect/shapechange_mob/on_apply(): (mob/living/shape)
#define COMSIG_LIVING_SHAPESHIFTED "living_shapeshifted"
/// From /datum/status_effect/shapechange_mob/after_unchange(): (mob/living/caster)
#define COMSIG_LIVING_UNSHAPESHIFTED "living_unshapeshifted"

/// Kind of jank, refactor at a later day when I can think of a better solution.
/// Just be sure to call update_limbless_locomotion() after applying / removal
#define TRAIT_NO_LEG_AID "no_leg_aid"

/// Updating a mob's movespeed when lacking limbs. (list/modifiers)
#define COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE "living_get_movespeed_modifiers"
///From living/Life(). (deltatime, times_fired)
#define COMSIG_LIVING_LIFE "living_life"
	/// Block the Life() proc from proceeding... this should really only be done in some really wacky situations.
	#define COMPONENT_LIVING_CANCEL_LIFE_PROCESSING (1<<0)

#define COMSIG_LIVING_ADJUSTED "living_damage_adjusted"

#define COMSIG_LIVING_PREBITE_SELF  "living_prebite"
#define COMSIG_LIVING_POSTBITE_SELF "living_postbite"
