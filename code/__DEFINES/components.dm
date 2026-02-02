// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument



//////////////////////////////////////////////////////////////////

// /datum signals
/// when a component is added to a datum: (/datum/component)
#define COMSIG_COMPONENT_ADDED "component_added"
/// before a component is removed from a datum because of RemoveComponent: (/datum/component)
#define COMSIG_COMPONENT_REMOVING "component_removing"
/// before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PARENT_PREQDELETED "parent_preqdeleted"
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_PARENT_QDELETING "parent_qdeleting"
/// generic topic handler (usr, href_list)
#define COMSIG_TOPIC "handle_topic"
#define COMSIG_PARENT_TRAP_TRIGGERED "trap_triggered_parent"
#define COMSIG_LOOT_SPAWNER_EMPTY "loot_spawner_empty"
/// Add to inspect topic descriptions
#define COMSIG_TOPIC_INSPECT "handle_topic_inspect"
// /atom signals
#define COMSIG_ATOM_REMOVE_TRAIT "atom_remove_trait"
#define COMSIG_ATOM_ADD_TRAIT "atom_add_trait"

//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZE "atom_init_success"
//from SSatoms InitAtom - Only if the  atom was not deleted or failed initialization and has a loc
#define COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON "atom_init_success_on"
#define COMSIG_PARENT_EXAMINE "atom_examine"                    //from base of atom/examine(): (/mob)
#define COMSIG_ATOM_GET_EXAMINE_NAME "atom_examine_name"		//from base of atom/get_examine_name(): (/mob, list/overrides)
	//Positions for overrides list
	#define EXAMINE_POSITION_ARTICLE 1
	#define EXAMINE_POSITION_BEFORE 2
	//End positions
	#define COMPONENT_EXNAME_CHANGED 1
#define COMSIG_ATOM_SMOOTHED_ICON "atom_smooth_icon"
#define COMSIG_ATOM_ENTERED "atom_entered"                      //from base of atom/Entered(): (atom/movable/entering, /atom)
#define COMSIG_ATOM_EXIT "atom_exit"							//from base of atom/Exit(): (/atom/movable/exiting, /atom/newloc)
	#define COMPONENT_ATOM_BLOCK_EXIT 1
#define COMSIG_ATOM_EXITED "atom_exited"						//from base of atom/Exited(): (atom/movable/exiting, atom/newloc)
#define COMSIG_ATOM_BUMPED "atom_bumped"						//from base of atom/Bumped(): (/atom/movable)
#define COMSIG_ATOM_EX_ACT "atom_ex_act"						//from base of atom/ex_act(): (severity, target)
#define COMSIG_ATOM_FIRE_ACT "atom_fire_act"					//from base of atom/fire_act(): (added, maxstacks)
#define COMSIG_ATOM_BULLET_ACT "atom_bullet_act"				//from base of atom/bullet_act(): (/obj/projectile, def_zone)
#define COMSIG_ATOM_BLOB_ACT "atom_blob_act"					//from base of atom/blob_act(): (/obj/structure/blob)
#define COMSIG_ATOM_ACID_ACT "atom_acid_act"					//from base of atom/acid_act(): (acidpwr, acid_volume)
#define COMSIG_ATOM_EMAG_ACT "atom_emag_act"					//from base of atom/emag_act(): (/mob/user)
#define COMSIG_ATOM_NARSIE_ACT "atom_narsie_act"				//from base of atom/narsie_act(): ()
#define COMSIG_ATOM_BSA_BEAM "atom_bsa_beam_pass"				//from obj/machinery/bsa/full/proc/fire(): ()
	#define COMSIG_ATOM_BLOCKS_BSA_BEAM 1
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"				//from base of atom/setDir(): (old_dir, new_dir)
#define COMSIG_ATOM_CONTENTS_DEL "atom_contents_del"			//from base of atom/handle_atom_del(): (atom/deleted)
#define COMSIG_ATOM_CANREACH "atom_can_reach"					//from internal loop in atom/movable/proc/CanReach(): (list/next)
	#define COMPONENT_BLOCK_REACH 1
#define COMSIG_ATOM_SCREWDRIVER_ACT "atom_screwdriver_act"		//from base of atom/screwdriver_act(): (mob/living/user, obj/item/I)
#define COMSIG_ATOM_WRENCH_ACT "atom_wrench_act"				//from base of atom/wrench_act(): (mob/living/user, obj/item/I)
#define COMSIG_ATOM_MULTITOOL_ACT "atom_multitool_act"			//from base of atom/multitool_act(): (mob/living/user, obj/item/I)
#define COMSIG_ATOM_WELDER_ACT "atom_welder_act"				//from base of atom/welder_act(): (mob/living/user, obj/item/I)
#define COMSIG_ATOM_WIRECUTTER_ACT "atom_wirecutter_act"		//from base of atom/wirecutter_act(): (mob/living/user, obj/item/I)
#define COMSIG_ATOM_CROWBAR_ACT "atom_crowbar_act"				//from base of atom/crowbar_act(): (mob/living/user, obj/item/I)
#define COMSIG_ATOM_ANALYSER_ACT "atom_analyser_act"			//from base of atom/analyser_act(): (mob/living/user, obj/item/I)
	#define COMPONENT_BLOCK_TOOL_ATTACK 1
#define COMSIG_ATOM_INTERCEPT_TELEPORT "intercept_teleport"		//called when teleporting into a protected turf: (channel, turf/origin)
	#define COMPONENT_BLOCK_TELEPORT 1
#define COMSIG_ATOM_ORBIT_BEGIN "atom_orbit_begin"           //called when an atom starts orbiting another atom: (atom)
#define COMSIG_ATOM_ORBIT_STOP "atom_orbit_stop"           //called when an atom stops orbiting another atom: (atom)
/////////////////
//This signal return value bitflags can be found in __DEFINES/misc.dm
#define COMSIG_ATOM_INTERCEPT_Z_FALL "movable_intercept_z_impact"	//called for each movable in a turf contents on /turf/zImpact(): (atom/movable/A, levels)
#define COMSIG_ATOM_FALL_INTERACT "atom_fall_interact"
#define COMSIG_MOB_FALL_IMPACT	"mob_fall_impact"

/////////////////

#define COMSIG_ENTER_AREA "enter_area" 						//from base of area/Entered(): (/area)
#define COMSIG_EXIT_AREA "exit_area" 							//from base of area/Exited(): (/area)

// /area signals
#define COMSIG_AREA_ENTERED "area_entered" 						//from base of area/Entered(): (atom/movable/M)
#define COMSIG_AREA_EXITED "area_exited" 							//from base of area/Exited(): (atom/movable/M)

// /turf signals
#define COMSIG_TURF_CHANGE "turf_change"						//from base of turf/ChangeTurf(): (path, list/new_baseturfs, flags, list/transferring_comps)
#define COMSIG_TURF_HAS_GRAVITY "turf_has_gravity"				//from base of atom/has_gravity(): (atom/asker, list/forced_gravities)
#define COMSIG_TURF_MULTIZ_DEL "turf_multiz_del"				//from base of turf/multiz_turf_del(): (turf/source, direction)
#define COMSIG_TURF_MULTIZ_NEW "turf_multiz_new"				//from base of turf/multiz_turf_new: (turf/source, direction)

// /mob signals
#define COMSIG_MOB_BREAK_SNEAK "mob_break_sneak"
#define COMSIG_MOB_DEATH "mob_death"							//from base of mob/death(): (gibbed)

#define COMSIG_MOB_CREATED_CALLOUT "mob_created_callout"

#define COMSIG_MOB_CLICKON "mob_clickon"						//from base of mob/clickon(): (atom/A, params)
#define COMSIG_ATOM_CLICKEDON "atom_clickedon"
#define COMSIG_MOB_MIDDLECLICKON "mob_middleclickon"			//from base of mob/MiddleClickOn(): (atom/A)
#define COMSIG_MOB_ALTCLICKON "mob_altclickon"				//from base of mob/AltClickOn(): (atom/A)
	#define COMSIG_MOB_CANCEL_CLICKON 1

#define COMSIG_MOB_ALLOWED "mob_allowed"						//from base of obj/allowed(mob/M): (/obj) returns bool, if TRUE the mob has id access to the obj
#define COMSIG_MOB_HUD_CREATED "mob_hud_created"				//from base of mob/create_mob_hud(): ()
#define COMSIG_MOB_ATTACK_HAND "mob_attack_hand"				//from base of
#define COMSIG_MOB_ITEM_ATTACK "mob_item_attack"				//from base of /obj/item/attack(): (mob/M, mob/user)
	#define COMPONENT_ITEM_NO_ATTACK 1
#define COMSIG_MOB_APPLY_DAMGE	"mob_apply_damage"				//from base of /mob/living/proc/apply_damage(): (damage, damagetype, def_zone)
#define COMSIG_MOB_ITEM_AFTERATTACK "mob_item_afterattack"		//from base of obj/item/afterattack(): (atom/target, mob/user, proximity_flag, click_parameters)
#define COMSIG_MOB_ITEM_ATTACK_QDELETED "mob_item_attack_qdeleted"	//from base of obj/item/attack_qdeleted(): (atom/target, mob/user, proxiumity_flag, click_parameters)
#define COMSIG_MOB_ATTACK_RANGED "mob_attack_ranged"			//from base of mob/RangedAttack(): (atom/A, params)
#define COMSIG_MOB_POSTATTACK_RANGED "mob_postattack_ranged"
#define COMSIG_MOB_THROW "mob_throw"							//from base of /mob/throw_item(): (atom/target)
#define COMSIG_MOB_EXAMINATE "mob_examinate"					//from base of /mob/verb/examinate(): (atom/target)
#define COMSIG_MOB_UPDATE_SIGHT "mob_update_sight"				//from base of /mob/update_sight(): ()
#define COMSIG_MOB_SAY "mob_say" // from /mob/living/say(): ()
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
#define COMSIG_MOB_DEADSAY "mob_deadsay" // from /mob/say_dead(): (mob/speaker, message)
	#define MOB_DEADSAY_SIGNAL_INTERCEPT 1
///from base of /mob/verb/pointed: (atom/A)
#define COMSIG_MOB_POINTED "mob_pointed"

#define COMSIG_MOB_ADD_STRESS "mob_add_stress"
#define COMSIG_MOB_APPLIED_STATUS_EFFECT "mob_applied_status_effect"

// /mob/living/carbon signals
#define COMSIG_CARBON_REAGENT_ADD "carbon_reagent_add"
#define COMSIG_CARBON_SOUNDBANG "carbon_soundbang"					//from base of mob/living/carbon/soundbang_act(): (list(intensity))
#define COMSIG_CARBON_ON_HANDLE_BLOOD "human_on_handle_blood"
	#define HANDLE_BLOOD_HANDLED (1<<0)
	#define HANDLE_BLOOD_NO_NUTRITION_DRAIN (1<<1)
	#define HANDLE_BLOOD_NO_EFFECTS (1<<2)

// /mob/living/simple_animal/hostile signals
#define COMSIG_HOSTILE_ATTACKINGTARGET "hostile_attackingtarget"
	#define COMPONENT_HOSTILE_NO_ATTACK 1
///before attackingtarget has happened, source is the attacker and target is the attacked
#define COMSIG_HOSTILE_PRE_ATTACKINGTARGET "hostile_pre_attackingtarget"
	#define COMPONENT_HOSTILE_NO_PREATTACK (1<<0) //cancel the attack, only works before attack happens

// /obj signals
#define COMSIG_OBJ_DECONSTRUCT "obj_deconstruct"				//from base of obj/deconstruct(): (disassembled)
#define COMSIG_OBJ_SETANCHORED "obj_setanchored"				//called in /obj/structure/setAnchored(): (value)
#define COMSIG_OBJ_DEFAULT_UNFASTEN_WRENCH "obj_default_unfasten_wrench"	//from base of code/game/machinery
/// From /obj/item/multitool/remove_buffer(): (buffer)
#define COMSIG_MULTITOOL_REMOVE_BUFFER "multitool_remove_buffer"

/// from /obj/proc/unfreeze()
#define COMSIG_OBJ_UNFREEZE "obj_unfreeze"


// /obj/machinery signals
#define COMSIG_MACHINERY_BROKEN "machinery_broken"				//from /obj/machinery/obj_break(damage_flag): (damage_flag)
#define COMSIG_MACHINERY_POWER_LOST "machinery_power_lost"			//from base power_change() when power is lost
#define COMSIG_MACHINERY_POWER_RESTORED "machinery_power_restored"	//from base power_change() when power is restored


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

///signal for gaffer ring destroyed, if you dont like my location send me rod directly into my ; this sucks.
#define COMSIG_GAFFER_RING_DESTROYED "gaffer_ring_destroyed"

// /obj/item/clothing signals
#define COMSIG_CLOTHING_STEP_ACTION "clothing_step_action"			//from base of obj/item/clothing/shoes/proc/step_action(): ()

// /obj/item/pda signals
#define COMSIG_PDA_CHANGE_RINGTONE "pda_change_ringtone"		//called on pda when the user changes the ringtone: (mob/living/user, new_ringtone)
	#define COMPONENT_STOP_RINGTONE_CHANGE 1
#define COMSIG_PDA_CHECK_DETONATE "pda_check_detonate"
	#define COMPONENT_PDA_NO_DETONATE 1

// /obj/item/radio signals
#define COMSIG_RADIO_NEW_FREQUENCY "radio_new_frequency"		//called from base of /obj/item/radio/proc/set_frequency(): (list/args)

// /obj/item/pen signals
#define COMSIG_PEN_ROTATED "pen_rotated"						//called after rotation in /obj/item/pen/attack_self(): (rotation, mob/living/carbon/user)

// /obj/projectile signals (sent to the firer)
#define COMSIG_PROJECTILE_ON_HIT "projectile_on_hit"			// from base of /obj/projectile/proc/on_hit(): (atom/movable/firer, atom/target, Angle)
#define COMSIG_PROJECTILE_BEFORE_FIRE "projectile_before_fire" 			// from base of /obj/projectile/proc/fire(): (obj/projectile, atom/original_target)
#define COMSIG_PROJECTILE_PREHIT "com_proj_prehit"				// sent to targets during the process_hit proc of projectiles
#define COMSIG_PROJECTILE_SELF_ON_HIT "projectile_self_on_hit"

// /obj/mecha signals
#define COMSIG_MECHA_ACTION_ACTIVATE "mecha_action_activate"	//sent from mecha action buttons to the mecha they're linked to

// /mob/living/carbon/human signals
#define COMSIG_HUMAN_EARLY_UNARMED_ATTACK "human_early_unarmed_attack"			//from mob/living/carbon/human/UnarmedAttack(): (atom/target, proximity)
#define COMSIG_HUMAN_MELEE_UNARMED_ATTACK "human_melee_unarmed_attack"			//from mob/living/carbon/human/UnarmedAttack(): (atom/target, proximity)
#define COMSIG_HUMAN_MELEE_UNARMED_ATTACKBY "human_melee_unarmed_attackby"		//from mob/living/carbon/human/UnarmedAttack(): (mob/living/carbon/human/attacker)
#define COMSIG_HUMAN_DISARM_HIT	"human_disarm_hit"	//Hit by successful disarm attack (mob/living/carbon/human/attacker,zone_targeted)
#define COMSIG_JOB_RECEIVED "job_received"										//Whenever EquipRanked is called, called after job is set
#define COMSIG_HUMAN_LIFE "human_life"

// /datum/species signals
#define COMSIG_SPECIES_GAIN "species_gain"						//from datum/species/on_species_gain(): (datum/species/new_species, datum/species/old_species)
#define COMSIG_SPECIES_LOSS "species_loss"						//from datum/species/on_species_loss(): (datum/species/lost_species)

/*******Component Specific Signals*******/
//Janitor
#define COMSIG_TURF_IS_WET "check_turf_wet"							//(): Returns bitflags of wet values.
#define COMSIG_TURF_MAKE_DRY "make_turf_try"						//(max_strength, immediate, duration_decrease = INFINITY): Returns bool.
#define COMSIG_COMPONENT_CLEAN_ACT "clean_act"					//called on an object to clean it of cleanables. Usualy with soap: (num/strength)

//Creamed
#define COMSIG_COMPONENT_CLEAN_FACE_ACT "clean_face_act"		//called when you wash your face at a sink: (num/strength)

//Food
#define COMSIG_FOOD_EATEN "food_eaten"		//from base of obj/item/reagent_containers/food/snacks/attack(): (mob/living/eater, mob/feeder)

//Gibs
#define COMSIG_GIBS_STREAK "gibs_streak"						// from base of /obj/effect/decal/cleanable/blood/gibs/streak(): (list/directions, list/diseases)

//NTnet
#define COMSIG_COMPONENT_NTNET_RECEIVE "ntnet_receive"			//called on an object by its NTNET connection component on receive. (sending_id(number), sending_netname(text), data(datum/netdata))

//Nanites
#define COMSIG_HAS_NANITES "has_nanites"						//() returns TRUE if nanites are found
#define COMSIG_NANITE_IS_STEALTHY "nanite_is_stealthy"			//() returns TRUE if nanites have stealth
#define COMSIG_NANITE_DELETE "nanite_delete"					//() deletes the nanite component
#define COMSIG_NANITE_GET_PROGRAMS	"nanite_get_programs"		//(list/nanite_programs) - makes the input list a copy the nanites' program list
#define COMSIG_NANITE_GET_VOLUME "nanite_get_volume"			//(amount) Returns nanite amount
#define COMSIG_NANITE_SET_VOLUME "nanite_set_volume"			//(amount) Sets current nanite volume to the given amount
#define COMSIG_NANITE_ADJUST_VOLUME "nanite_adjust"				//(amount) Adjusts nanite volume by the given amount
#define COMSIG_NANITE_SET_MAX_VOLUME "nanite_set_max_volume"	//(amount) Sets maximum nanite volume to the given amount
#define COMSIG_NANITE_SET_CLOUD "nanite_set_cloud"				//(amount(0-100)) Sets cloud ID to the given amount
#define COMSIG_NANITE_SET_CLOUD_SYNC "nanite_set_cloud_sync"	//(method) Modify cloud sync status. Method can be toggle, enable or disable
#define COMSIG_NANITE_SET_SAFETY "nanite_set_safety"			//(amount) Sets safety threshold to the given amount
#define COMSIG_NANITE_SET_REGEN "nanite_set_regen"				//(amount) Sets regeneration rate to the given amount
#define COMSIG_NANITE_SIGNAL "nanite_signal"					//(code(1-9999)) Called when sending a nanite signal to a mob.
#define COMSIG_NANITE_COMM_SIGNAL "nanite_comm_signal"			//(comm_code(1-9999), comm_message) Called when sending a nanite comm signal to a mob.
#define COMSIG_NANITE_SCAN "nanite_scan"						//(mob/user, full_scan) - sends to chat a scan of the nanites to the user, returns TRUE if nanites are detected
#define COMSIG_NANITE_UI_DATA "nanite_ui_data"					//(list/data, scan_level) - adds nanite data to the given data list - made for ui_data procs
#define COMSIG_NANITE_ADD_PROGRAM "nanite_add_program"			//(datum/nanite_program/new_program, datum/nanite_program/source_program) Called when adding a program to a nanite component
	#define COMPONENT_PROGRAM_INSTALLED		1					//Installation successful
	#define COMPONENT_PROGRAM_NOT_INSTALLED		2				//Installation failed, but there are still nanites
#define COMSIG_NANITE_SYNC "nanite_sync"						//(datum/component/nanites, full_overwrite, copy_activation) Called to sync the target's nanites to a given nanite component

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

//Redirection component init flags
#define REDIRECT_TRANSFER_WITH_TURF 1

//Arch
#define ARCH_PROB "probability"					//Probability for each item
#define ARCH_MAXDROP "max_drop_amount"				//each item's max drop amount

//Ouch my toes!
#define CALTROP_BYPASS_SHOES 1
#define CALTROP_IGNORE_WALKERS 2

//Xenobio hotkeys
#define COMSIG_XENO_SLIME_CLICK_CTRL "xeno_slime_click_ctrl"				//from slime CtrlClickOn(): (/mob)
#define COMSIG_XENO_SLIME_CLICK_ALT "xeno_slime_click_alt"					//from slime AltClickOn(): (/mob)
#define COMSIG_XENO_SLIME_CLICK_SHIFT "xeno_slime_click_shift"				//from slime ShiftClickOn(): (/mob)
#define COMSIG_XENO_TURF_CLICK_SHIFT "xeno_turf_click_shift"				//from turf ShiftClickOn(): (/mob)
#define COMSIG_XENO_TURF_CLICK_CTRL "xeno_turf_click_alt"					//from turf AltClickOn(): (/mob)
#define COMSIG_XENO_MONKEY_CLICK_CTRL "xeno_monkey_click_ctrl"				//from monkey CtrlClickOn(): (/mob)

#define COMSIG_PARENT_IMPREGNATE "comsig_mob_impregnate"

#define COMSIG_CANCEL_TURF_BREAK "cancel_turf_break_comsig"
#define COMSIG_MOUSE_ENTERED "comsig_mouse_entered"
/// signal sent when a mouse is hovering over us, sent by atom/proc/on_mouse_entered
#define COMSIG_ATOM_MOUSE_ENTERED "mouse_entered"
#define COMSIG_USER_MOUSE_ENTERED "user_mouse_entered"

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

#define COMPONENT_AUGMENT_SUCCESS (1<<0)
#define COMPONENT_AUGMENT_FAILED (1<<1)
