// Global signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice
/// from base of datum/controller/subsystem/mapping/proc/add_new_zlevel(): (list/args)
#define COMSIG_GLOB_NEW_Z "!new_z"
/// sent after world.maxx and/or world.maxy are expanded: (has_exapnded_world_maxx, has_expanded_world_maxy)
#define COMSIG_GLOB_EXPANDED_WORLD_BOUNDS "!expanded_world_bounds"
/// called after a successful var edit somewhere in the world: (list/args)
#define COMSIG_GLOB_VAR_EDIT "!var_edit"
/// mob was created somewhere : (mob)
#define COMSIG_GLOB_MOB_CREATED "!mob_created"
/// mob died somewhere : (mob , gibbed)
#define COMSIG_GLOB_MOB_DEATH "!mob_death"
/// global living say plug - use sparingly: (mob/speaker , message)
#define COMSIG_GLOB_LIVING_SAY_SPECIAL "!say_special"
/// a human has entered cryo : (mob/living/carbon/human , admin)
#define COMSIG_GLOB_HUMAN_ENTER_CRYO "!human_enter_cryo"
/// job subsystem has spawned and equipped a new mob
#define COMSIG_GLOB_JOB_AFTER_SPAWN "!job_after_spawn"
/// job datum has been called to deal with the aftermath of a latejoin spawn
#define COMSIG_GLOB_JOB_AFTER_LATEJOIN_SPAWN "!job_after_latejoin_spawn"

/// a sound was played : (sound_player, sound_file)
#define COMSIG_GLOB_SOUND_PLAYED "!sound_played"

/// The monarch set lord colors, update all things that use it (primary, secondary)
#define COMSIG_LORD_COLORS_SET "mob_set_lord"
