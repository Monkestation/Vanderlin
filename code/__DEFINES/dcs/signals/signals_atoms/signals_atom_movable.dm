
#define COMSIG_MOVABLE_IMPACT "movable_impact"					//from base of atom/movable/throw_impact(): (/atom/hit_atom, /datum/thrownthing/throwingdatum)
#define COMSIG_MOVABLE_IMPACT_ZONE "item_impact_zone"			//from base of mob/living/hitby(): (mob/living/target, hit_zone)
#define COMSIG_MOVABLE_PRE_THROW "movable_pre_throw"			//from base of atom/movable/throw_at(): (list/args)
	#define COMPONENT_CANCEL_THROW 1
#define COMSIG_MOVABLE_POST_THROW "movable_post_throw"			//from base of atom/movable/throw_at(): (datum/thrownthing, spin)
///from base of datum/thrownthing/finalize(): (obj/thrown_object, datum/thrownthing) used for when a throw is finished
#define COMSIG_MOVABLE_THROW_LANDED "movable_throw_landed"
#define COMSIG_MOVABLE_Z_CHANGED "movable_ztransit" 			//from base of atom/movable/onTransitZ(): (old_z, new_z)
/// from /atom/movable/can_z_move(): (turf/start, turf/destination)
#define COMSIG_CAN_Z_MOVE "movable_can_z_move"
	/// Return to block z movement
	#define COMPONENT_CANT_Z_MOVE (1<<0)
#define COMSIG_MOVABLE_SECLUDED_LOCATION "movable_secluded" 	//called when the movable is placed in an unaccessible area, used for stationloving: ()
/// from base of atom/movable/Hear(): (proc args list(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list()))
#define COMSIG_MOVABLE_HEAR "movable_hear"
	#define HEARING_MESSAGE 1
	#define HEARING_SPEAKER 2
	#define HEARING_LANGUAGE 3
	#define HEARING_RAW_MESSAGE 4

#define COMSIG_MOVABLE_DISPOSING "movable_disposing"			//called when the movable is added to a disposal holder object for disposal movement: (obj/structure/disposalholder/holder, obj/machinery/disposal/source)
#define COMSIG_MOVABLE_UPDATE_GLIDE_SIZE "movable_glide_size"	//Called when the movable's glide size is updated: (new_glide_size)

/// From base of area/Exited(): (area/left, direction)
#define COMSIG_MOVABLE_EXITED_AREA "movable_exited_area"

/// Called when something is pushed by a living mob bumping it: (mob/living/pusher, push force)
#define COMSIG_MOVABLE_BUMP_PUSHED "movable_bump_pushed"
	/// Stop it from moving
	#define COMPONENT_NO_PUSH (1<<0)

///called when the movable successfully has its anchored var changed, from base atom/movable/set_anchored(): (value)
#define COMSIG_MOVABLE_SET_ANCHORED "movable_set_anchored"
///from base of atom/movable/setGrabState(): (newstate)
#define COMSIG_MOVABLE_SET_GRAB_STATE "living_set_grab_state"

///from base of atom/movable/buckle_mob(): (mob, force)
#define COMSIG_MOVABLE_BUCKLE "buckle"
///from base of atom/movable/unbuckle_mob(): (mob, force)
#define COMSIG_MOVABLE_UNBUCKLE "unbuckle"

///from /atom/movable/proc/buckle_mob(): (mob/living/M, force, check_loc, buckle_mob_flags)
#define COMSIG_MOVABLE_PREBUCKLE "prebuckle" // this is the last chance to interrupt and block a buckle before it finishes
	#define COMPONENT_BLOCK_BUCKLE (1<<0)

///from /atom/movable/proc/buckle_mob(): (buckled_movable)
#define COMSIG_MOB_BUCKLED "mob_buckle"
///from /atom/movable/proc/unbuckle_mob(): (buckled_movable)
#define COMSIG_MOB_UNBUCKLED "mob_unbuckle"

///from /obj/vehicle/proc/driver_move, caught by the riding component to check and execute the driver trying to drive the vehicle
#define COMSIG_RIDDEN_DRIVER_MOVE "driver_move"
	#define COMPONENT_DRIVER_BLOCK_MOVE (1<<0)


#define COMSIG_MOB_OVERLAY_FORCE_REMOVE "mob_overlay_force_remove"
#define COMSIG_MOB_OVERLAY_FORCE_UPDATE "mob_overlay_force_update"

// /datum/element/movetype_handler signals
/// Called when the floating anim has to be temporarily stopped and restarted later: (timer)
#define COMSIG_PAUSE_FLOATING_ANIM "pause_floating_anim"
/// From base of datum/element/movetype_handler/on_movement_type_trait_gain: (flag, old_movement_type)
#define COMSIG_MOVETYPE_FLAG_ENABLED "movetype_flag_enabled"
/// From base of datum/element/movetype_handler/on_movement_type_trait_loss: (flag, old_movement_type)
#define COMSIG_MOVETYPE_FLAG_DISABLED "movetype_flag_disabled"

/// From base of /turf/Entered: (atom/movable/arrived, atom/old_loc, list/atom/old_locs)
#define COMSIG_MOVABLE_TURF_ENTERED "movable_turf_entered"
/// From base of /turf/Exited: (atom/movable/gone, atom/new_loc)
#define COMSIG_MOVABLE_TURF_EXITED "movable_turf_exited"

/// from /mob/living/can_z_move, sent to whatever the mob is buckled to. Only ridable movables should be ridden up or down btw.
#define COMSIG_BUCKLED_CAN_Z_MOVE "ridden_pre_can_z_move"
	#define COMPONENT_RIDDEN_STOP_Z_MOVE 1
	#define COMPONENT_RIDDEN_ALLOW_Z_MOVE 2

/// From /datum/element/immerse/proc/add_immerse_overlay(): (atom/movable/immerse_mask/effect_relay)
#define COMSIG_MOVABLE_EDIT_UNIQUE_IMMERSE_OVERLAY "movable_edit_unique_submerge_overlay"
