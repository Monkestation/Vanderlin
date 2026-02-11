//! Defines for subsystems and overlays
//!
//! Lots of important stuff in here, make sure you have your brain switched on
//! when editing this file

//! ## DB defines
/**
 * DB major schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MAJOR_VERSION 6

/**
 * DB minor schema version
 *
 * Update this whenever the db schema changes
 *
 * make sure you add an update to the schema_version stable in the db changelog
 */
#define DB_MINOR_VERSION 0


//! ## Timing subsystem
/**
 * Don't run if there is an identical unique timer active
 *
 * if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer,
 * and returns the id of the existing timer
 */
#define TIMER_UNIQUE			(1<<0)

///For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE			(1<<1)

/**
 * Timing should be based on how timing progresses on clients, not the server.
 *
 * Tracking this is more expensive,
 * should only be used in conjuction with things that have to progress client side, such as
 * animate() or sound()
 */
#define TIMER_CLIENT_TIME (1<<2)

///Timer can be stopped using deltimer()
#define TIMER_STOPPABLE (1<<3)

///prevents distinguishing identical timers with the wait variable
///
///To be used with TIMER_UNIQUE
#define TIMER_NO_HASH_WAIT (1<<4)

///Loops the timer repeatedly until qdeleted
///
///In most cases you want a subsystem instead, so don't use this unless you have a good reason
#define TIMER_LOOP (1<<5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME (1<<6)

///Empty ID define
#define TIMER_ID_NULL -1

//! ## Initialization subsystem

///New should not call Initialize
#define INITIALIZATION_INSSATOMS 0
///New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_MAPLOAD 2
///New should call Initialize(FALSE)
#define INITIALIZATION_INNEW_REGULAR 1

//! ### Initialization hints

///Nothing happens
#define INITIALIZE_HINT_NORMAL 0
/**
 * call LateInitialize at the end of all atom Initalization
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initalization of subsystems is complete and calls LateInitalize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

///Call qdel on the atom after intialization
#define INITIALIZE_HINT_QDEL 2

///type and all subtypes should always immediately call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(flags_1 & INITIALIZED_1)) {\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, args);\
	}\
}

// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.
#define INIT_ORDER_ASSETS 101
#define INIT_ORDER_TITLE 100
#define INIT_ORDER_GARBAGE 99
#define INIT_ORDER_DBCORE 95
#define INIT_ORDER_PLEXORA  93
#define INIT_ORDER_BLACKBOX 91
#define INIT_ORDER_SERVER_MAINT 90
#define INIT_ORDER_INPUT 85
#define INIT_ORDER_GREYSCALE 81
#define INIT_ORDER_VIS 80
#define INIT_ORDER_SOUNDS 79
#define INIT_ORDER_ACHIEVEMENTS	77
#define INIT_ORDER_MATERIALS 76
#define INIT_ORDER_RESEARCH	75
#define INIT_ORDER_EVENTS 70
#define INIT_ORDER_GAMEMODE 69
#define INIT_ORDER_JOBS	65
#define INIT_ORDER_ROLE_CLASS_HANDLER 66
#define INIT_ORDER_TRIUMPHS	67
#define INIT_ORDER_AI_MOVEMENT 56 //We need the movement setup
#define INIT_ORDER_AI_CONTROLLERS 55 //So the controller can get the ref
#define INIT_ORDER_TICKER 54
#define INIT_ORDER_MAPPING 52
#define INIT_ORDER_EARLY_ASSETS 51
#define INIT_ORDER_AI_IDLE_CONTROLLERS 50
#define INIT_ORDER_TERRAIN 49
#define INIT_ORDER_DUNGEON 48
#define INIT_ORDER_NETWORKS 45
#define INIT_ORDER_SPATIAL_GRID 43
#define INIT_ORDER_ECONOMY 40
#define INIT_ORDER_OUTPUTS 35
#define INIT_ORDER_HOUSING 32
#define INIT_ORDER_SKILLS 31
#define INIT_ORDER_ATOMS 30
#define INIT_ORDER_TREASURY 29
#define INIT_ORDER_LANGUAGE	25
#define INIT_ORDER_MACHINES	20
#define INIT_ORDER_RANDOM_TILES	7
#define INIT_ORDER_TIMER 1
#define INIT_ORDER_DEFAULT 0
#define INIT_ORDER_AIR -1
#define INIT_ORDER_ICON_SMOOTHING -5
#define INIT_ORDER_OVERLAY -6
#define INIT_ORDER_XKEYSCORE -10
#define INIT_ORDER_LIGHTING -20
#define INIT_ORDER_OUTDOOR_EFFECTS -21
#define INIT_ORDER_MINOR_MAPPING -40
#define INIT_ORDER_PATH -50
#define INIT_ORDER_OW -55
#define INIT_ORDER_PERSISTENCE -95
#define INIT_ORDER_BAN_CACHE -98
#define INIT_ORDER_STATPANEL -99
#define INIT_ORDER_CHAT -100 // Should be last to ensure chat remains smooth during init.

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)
#define FIRE_PRIORITY_IDLE_NPC 5
#define FIRE_PRIORITY_SLOW_OBJECTS 5
#define FIRE_PRIORITY_ENCHANTMENT 10
#define FIRE_PRIORITY_ROLE_CLASS_HANDLER 10
#define FIRE_PRIORITY_PING 10
#define FIRE_PRIORITY_WET_FLOORS 10
#define FIRE_PRIORITY_WATER_LEVEL 10
#define FIRE_PRIORITY_SERVER_MAINT 10
#define FIRE_PRIORITY_RESEARCH 10
#define FIRE_PRIORITY_VIS 10
#define FIRE_PRIORITY_AMBIENCE 10
#define FIRE_PRIORITY_GARBAGE 15
#define FIRE_PRIORITY_INCONE 19
#define FIRE_PRIORITY_MOUSECHARGE 20
#define FIRE_PRIORITY_AIR 20
#define FIRE_PRIORITY_NPC 20
#define FIRE_PRIORITY_NPC_MOVEMENT 21
#define FIRE_PRIORITY_NPC_ACTIONS 22
#define FIRE_PRIORITY_PROCESS 25
#define FIRE_PRIORITY_THROWING 25
#define FIRE_PRIORITY_SPACEDRIFT 30
#define FIRE_PRIORITY_SMOOTHING	35
#define FIRE_PRIORITY_HUDS 40
#define FIRE_PRIORITY_NETWORKS 40
#define FIRE_PRIORITY_CELLULAR 40
#define FIRE_PRIORITY_OBJ 40
#define FIRE_PRIORITY_ACID 40
#define FIRE_PRIORITY_BURNING 40
#define FIRE_PRIORITY_DEFAULT 50
#define FIRE_PRIORITY_PARALLAX 65
#define FIRE_PRIORITY_MOBS 100
#define FIRE_PRIORITY_ASSETS 105
#define FIRE_PRIORITY_TGUI 110
#define FIRE_PRIORITY_TICKER 120
#define FIRE_PRIORITY_ATMOS_ADJACENCY 130
#define FIRE_PRIORITY_STATPANEL 135
#define FIRE_PRIORITY_CHAT 140
#define FIRE_PRIORITY_RUNECHAT 150
#define FIRE_PRIORITY_MOUSE_ENTERED 160
#define FIRE_PRIORITY_TIMER	170
#define FIRE_PRIORITY_DELAYED_VERBS 180
#define FIRE_PRIORITY_INPUT	190 // This must always always be the max highest priority. Player input must never be lost.

// SS runlevels

#define RUNLEVEL_INIT 0
#define RUNLEVEL_LOBBY 1
#define RUNLEVEL_SETUP 2
#define RUNLEVEL_GAME 4
#define RUNLEVEL_POSTGAME 8

#define RUNLEVELS_DEFAULT (RUNLEVEL_SETUP | RUNLEVEL_GAME | RUNLEVEL_POSTGAME)

//! ## Overlays subsystem
// A reasonable number of maximum overlays an object needs
// If you think you need more, rethink it
#define MAX_ATOM_OVERLAYS 200

///Compile all the overlays for an atom from the cache lists
#define POST_OVERLAY_CHANGE(changed_on) \
	if(length(changed_on.overlays) >= MAX_ATOM_OVERLAYS) { \
		var/text_lays = overlays2text(changed_on.overlays); \
		stack_trace("Too many overlays on [changed_on.type] - [length(changed_on.overlays)], refusing to update and cutting.\
			\n What follows is a printout of all existing overlays at the time of the overflow \n[text_lays]"); \
		changed_on.overlays.Cut(); \
		changed_on.add_overlay(mutable_appearance('icons/testing/greyscale_error.dmi')); \
	} \
	if(alternate_appearances) { \
		for(var/I in changed_on.alternate_appearances){\
			var/datum/atom_hud/alternate_appearance/AA = changed_on.alternate_appearances[I];\
			if(AA.transfer_overlays){\
				AA.copy_overlays(changed_on, TRUE);\
			}\
		} \
	}

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)
