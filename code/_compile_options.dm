//#define TESTING				//By using the testing("message") proc you can create debug-feedback for people with this
								//uncommented, but not visible in the release version)

//#define DATUMVAR_DEBUGGING_MODE	//Enables the ability to cache datum vars and retrieve later for debugging which vars changed.

//#define TESTSERVER
#define ALLOWPLAY

#define RESPAWNTIME 0
//0 test
//12 minutes norma
//#define ROUNDTIMERBOAT (300 MINUTES)
#define INITIAL_ROUND_TIMER (99 MINUTES)
#define ROUND_EXTENSION_TIME (30 MINUTES)
#define ROUND_END_TIME (15 MINUTES)
#define ROUND_END_TIME_VERBAL "15 minutes"
//180 norma
//60 test

#define MODE_RESTART
//comment out if you want to restart the server instead of shutting down

#define DEBUG 1
// Comment this out if you are debugging problems that might be obscured by custom error handling in world/Error
#ifdef DEBUG
#define USE_CUSTOM_ERROR_HANDLER
#endif

#ifdef TESTING
#define DATUMVAR_DEBUGGING_MODE

///Used to find the sources of harddels, quite laggy, don't be surpised if it freezes your client for a good while
//#define REFERENCE_TRACKING
#ifdef REFERENCE_TRACKING

///Should we be logging our findings or not
#define REFERENCE_TRACKING_LOG

///Used for doing dry runs of the reference finder, to test for feature completeness
//#define REFERENCE_TRACKING_DEBUG

//#define GC_FAILURE_HARD_LOOKUP
#ifdef GC_FAILURE_HARD_LOOKUP
#define FIND_REF_NO_CHECK_TICK
#endif //ifdef GC_FAILURE_HARD_LOOKUP

#endif //ifdef REFERENCE_TRACKING

//#define VISUALIZE_ACTIVE_TURFS	//Highlights atmos active turfs in green
#endif //ifdef TESTING

/// If this is uncommented, we set up the ref tracker to be used in a live environment
/// And to log events to [log_dir]/harddels.log
//#define REFERENCE_DOING_IT_LIVE
#ifdef REFERENCE_DOING_IT_LIVE
// compile the backend
#define REFERENCE_TRACKING
// actually look for refs
#define GC_FAILURE_HARD_LOOKUP
#endif // REFERENCE_DOING_IT_LIVE


// If defined, we will NOT defer asset generation till later in the game, and will instead do it all at once, during initiialize
//#define DO_NOT_DEFER_ASSETS
// If defined, we do a single run though of the game setup and tear down process with unit tests in between
//#define UNIT_TESTS

// If this is uncommented, will attempt to load and initialize prof.dll/libprof.so by default.
// Even if it's not defined, you can pass "tracy" via -params in order to try to load it.
// We do not ship byond-tracy. Build it yourself here: https://github.com/mafemergency/byond-tracy/
// #define USE_BYOND_TRACY

// 0 to allow using external resources or on-demand behaviour;
// 1 to use the default behaviour;
// 2 for preloading absolutely everything;
#ifndef PRELOAD_RSC
#define PRELOAD_RSC 0
#endif

#ifdef UNIT_TESTS
#define DEPLOY_TEST
#endif

//#define FORCE_RANDOM_WORLD_GEN

//#define LOWMEMORYMODE //uncomment this to load centcom and roguetest and thats it.

//#define NO_DUNGEON //comment this to load dungeons.

//#define ABSOLUTE_MINIMUM_MODE //uncomment this to skip as many resource intensive ops as possible to load in for testing the fastest while preserving most gameplay features.

#define USES_PQ

#ifdef LOWMEMORYMODE
#ifdef ABSOLUTE_MINIMUM_MODE
#define FORCE_MAP "minimal_test"
#define FORCE_MAP_DIRECTORY "_maps"
#else
#define FORCE_MAP "roguetest"
#define FORCE_MAP_DIRECTORY "_maps"
#endif
#endif

#ifdef TESTING
#warn compiling in TESTING mode. testing() debug messages will be visible.
#endif

#if defined(CIBUILDING) && !defined(OPENDREAM)
#define UNIT_TESTS
#endif

#ifdef CITESTING
#define TESTING
#endif

#if defined(UNIT_TESTS)
//Hard del testing defines
#define REFERENCE_TRACKING
#define REFERENCE_TRACKING_DEBUG
#define FIND_REF_NO_CHECK_TICK
#define GC_FAILURE_HARD_LOOKUP
//Ensures all early assets can actually load early
#define DO_NOT_DEFER_ASSETS
//Test at full capacity, the extra cost doesn't matter
#define TIMER_DEBUG
///this saves like alot of time
#define NO_DUNGEON
#endif

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_VERSION 515
#if DM_VERSION < MIN_COMPILER_VERSION
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 515 or higher
#endif

//Update this whenever you need to take advantage of more recent byond features
#define MIN_COMPILER_MINOR_VERSION 1643
#ifndef SPACEMAN_DMM
#if DM_BUILD < MIN_COMPILER_MINOR_VERSION
//Don't forget to update this part
#error Your version of BYOND is too out-of-date to compile this project. Go to https://secure.byond.com/download and update.
#error You need version 515.1643 or higher
#endif
#endif

//#define KALYPSO_PROJECT
#if defined(KALYPSO_PROJECT)
#define NO_DUNGEON
#define FORCE_MAP "projectkalypso"
#define FORCE_MAP_DIRECTORY "_maps"
#endif
