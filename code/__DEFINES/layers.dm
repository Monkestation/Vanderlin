//Defines for atom layers and planes
//KEEP THESE IN A NICE ACSCENDING ORDER, PLEASE

//---------- LAYERS -------------
//#define FLOAT_LAYER -1 // byond record keeping
//#define DEFAULT_LAYER 0 // byond record keeping
#define LOWER_LEYLINE_LAYER 1
#define SPACE_LAYER 1.8
//#define TURF_LAYER 2 //For easy recordkeeping; this is a byond define
#define UPPER_LEYLINE_LAYER 2
#define MID_TURF_LAYER 2.02
#define HIGH_TURF_LAYER 2.03
#define TURF_PLATING_DECAL_LAYER 2.031
#define CULT_OVERLAY_LAYER 2.01
#define TURF_DECAL_LAYER 2.039 //! Makes turf decals appear in DM how they will look inworld.
#define ABOVE_OPEN_TURF_LAYER 2.04
#define CLOSED_TURF_LAYER 2.05
#define BULLET_HOLE_LAYER 2.06
#define ABOVE_NORMAL_TURF_LAYER 2.08
#define LATTICE_LAYER 2.2
#define DISPOSAL_PIPE_LAYER 2.3
#define GAS_PIPE_HIDDEN_LAYER 2.35
#define WIRE_LAYER 2.4
#define WIRE_BRIDGE_LAYER 2.44
#define WIRE_TERMINAL_LAYER 2.45
#define GAS_SCRUBBER_LAYER 2.46
#define GAS_PIPE_VISIBLE_LAYER 2.47
#define GAS_FILTER_LAYER 2.48
#define GAS_PUMP_LAYER 2.49
#define LOW_OBJ_LAYER 2.5
#define LOW_SIGIL_LAYER 2.52
#define SIGIL_LAYER 2.54
#define HIGH_SIGIL_LAYER 2.56

#define BELOW_OPEN_DOOR_LAYER 2.6
#define BLASTDOOR_LAYER 2.65
#define OPEN_DOOR_LAYER 2.7
#define DOOR_HELPER_LAYER 2.71 //! keep this above OPEN_DOOR_LAYER
#define PROJECTILE_HIT_THRESHHOLD_LAYER 2.75 //! projectiles won't hit objects at or below this layer if possible
#define TABLE_LAYER 2.8
#define BELOW_OBJ_LAYER 2.9
#define LOW_ITEM_LAYER 2.95
//#define OBJ_LAYER 3 //For easy recordkeeping; this is a byond define
#define CLOSED_BLASTDOOR_LAYER 3.05
#define CLOSED_DOOR_LAYER 3.1
#define CLOSED_FIREDOOR_LAYER 3.11
#define SHUTTER_LAYER 3.12 // HERE BE DRAGONS
#define ABOVE_OBJ_LAYER 3.2
#define ABOVE_WINDOW_LAYER 3.3
#define SIGN_LAYER 3.4
#define NOT_HIGH_OBJ_LAYER 3.5
#define HIGH_OBJ_LAYER 3.6

#define BELOW_MOB_LAYER 3.7
#define LYING_MOB_LAYER 3.8
//#define MOB_LAYER 4 //For easy recordkeeping; this is a byond define
#define ABOVE_MOB_LAYER 4.1
#define WALL_OBJ_LAYER 4.25
#define EDGED_TURF_LAYER 4.3
#define ON_EDGED_TURF_LAYER 4.35
#define LARGE_MOB_LAYER 4.4
#define ABOVE_ALL_MOB_LAYER 4.5

#define SPACEVINE_LAYER 4.8
#define FLORA_LAYER 4.81
#define SPACEVINE_MOB_LAYER 4.9
//#define FLY_LAYER 5 //For easy recordkeeping; this is a byond define
#define GASFIRE_LAYER 5.05
#define RIPPLE_LAYER 5.1
#define GOD_HAND_LAYER 10
#define AREA_LAYER	12

#define OPENSPACE_LAYER 600 //! Openspace layer over all

///1000 is an unimportant number, it's just to normalize copied layers
#define RADIAL_LAYER 1000
#define RADIAL_BACKGROUND_LAYER 0
#define RADIAL_CONTENT_LAYER 1

//---------- PLANES -------------
/// NEVER HAVE ANYTHING BELOW THIS PLANE ADJUST IF YOU NEED MORE SPACE
#define LOWEST_EVER_PLANE -200

#define FIELD_OF_VISION_BLOCKER_PLANE -199
#define FIELD_OF_VISION_BLOCKER_RENDER_TARGET "*FOV_RENDER_TARGET"

#define CLICKCATCHER_PLANE -99

#define SPACE_PLANE -95

#define SPACE_PLANE_PARALLAX -90

#define WEATHER_OVERLAY_PLANE -80
#define WEATHER_RENDER_TARGET "*WEATHER_RENDER_TARGET"

#define OPENSPACE_PLANE -13 //! Openspace plane below all turfs
#define OPENSPACE_BACKDROP_PLANE -12 //! Black square just over openspace plane to guaranteed cover all in openspace turf

#define TRANSPARENT_FLOOR_PLANE -11

#define FLOOR_PLANE -10
#define FLOOR_PLANE_RENDER_TARGET "FLOOR_PLANE_RENDER_TARGET"
#define REFLECTION_PLANE -9

#define GAME_PLANE -8
#define GAME_PLANE_RENDER_TARGET "GAME_PLANE_RENDER_TARGET"
#define GAME_PLANE_FOV_HIDDEN -7
#define GAME_PLANE_UPPER -6

#define SEETHROUGH_PLANE -5

#define WEATHER_EFFECT_PLANE -4
#define STRATEGY_PLANE -3
#define LEYLINE_PLANE -2
//#define FLOAT_PLANE -1 // byond record keeping

#define BLACKNESS_PLANE 0 //To keep from conflicts with SEE_BLACKNESS internals
#define BLACKNESS_PLANE_RENDER_TARGET "BLACKNESS_RENDER_TARGET"

#define LANDMARK_PLANE 50
#define LOW_LANDMARK_LAYER 1
#define MID_LANDMARK_LAYER 2
#define HIGH_LANDMARK_LAYER 3

#define AREA_PLANE 60
#define MASSIVE_OBJ_PLANE 70
#define GHOST_PLANE 80
#define POINT_PLANE 90

#define WEATHER_PLANE 100
#define INDOOR_PLANE 110

//---------- LIGHTING -------------
/// Displays reflections
#define REFLECTIVE_DISPLACEMENT_PLANE 120
#define REFLECTIVE_DISPLACEMENT_PLANE_RENDER_TARGET "*REFLECTIVE_DISPLACEMENT_RENDER_TARGET"

/// Fog weather rendering
#define PLANE_FOG_CUTTER 130
#define FOG_RENDER_TARGET "FOG_RENDER_TARGET"

/// Sunlight effect
#define SUNLIGHTING_PLANE 140
#define SUNLIGHTING_RENDER_TARGET "*SUNLIGHT_RENDER_TARGET"

///Normal 1 per turf dynamic lighting objects
#define LIGHTING_PLANE 150
#define LIGHTING_RENDER_TARGET "LIGHT_RENDER_TARGET"

///Lighting objects that are "free floating"
#define O_LIGHTING_VISUAL_PLANE 160
#define O_LIGHTING_VISUAL_RENDER_TARGET "O_LIGHT_VISUAL_RENDER_TARGET"

///Things that should render ignoring lighting
#define ABOVE_LIGHTING_PLANE 170
#define ABOVE_LIGHTING_RENDER_TARGET "ABOVE_LIGHTING_RENDER_TARGET"

///visibility + hiding of things outside of light source range
#define BYOND_LIGHTING_PLANE 180
#define BYOND_LIGHTING_RENDER_TARGET "BYOND_LIGHTING_RENDER_TARGET"

//---------- EMISSIVES -------------
//Layering order of these is not particularly meaningful.
//Important part is the seperation of the planes for control via plane_master

///This plane masks out lighting to create an "emissive" effect, ie for glowing lights in otherwise dark areas
#define EMISSIVE_PLANE 190
/// The render target used by the emissive layer.
#define EMISSIVE_RENDER_TARGET "*EMISSIVE_RENDER_TARGET"
/// The layer you should use if you _really_ don't want an emissive overlay to be blocked.
#define EMISSIVE_LAYER_UNBLOCKABLE 9999

//---------------- MISC -----------------------
///AI Camera Static
#define CAMERA_STATIC_PLANE 200
#define CAMERA_STATIC_RENDER_TARGET "CAMERA_STATIC_RENDER_TARGET"

// Floating chat messages
#define RUNECHAT_PLANE 250

/// Plane for balloon text (text that fades up)
#define BALLOON_CHAT_PLANE 251

///--------------- FULLSCREEN IMAGES ------------
#define FULLSCREEN_PLANE 500
#define FULLSCREEN_RENDER_TARGET "FULLSCREEN_RENDER_TARGET"
#define FLASH_LAYER 1
#define FULLSCREEN_LAYER 2
#define UI_DAMAGE_LAYER 3
#define BLIND_LAYER 4
#define CRIT_LAYER 5
#define CURSE_LAYER 6
#define ECHO_LAYER 7
#define BACKHUD_LAYER 8

//-------------------- HUD ---------------------
//HUD layer defines
#define HUD_PLANE 1000
#define HUD_RENDER_TARGET "HUD_RENDER_TARGETE"

#define ABOVE_HUD_PLANE 1100
#define ABOVE_HUD_RENDER_TARGET "ABOVE_HUD_RENDER_TARGET"

#define LOBBY_MENU_PLANE 5000
#define LOBBY_MENU_RENDER_TARGET "LOBBY_MENU_RENDER_TARGET"

///Layer for lobby menu collapse button
#define LOBBY_BELOW_MENU_LAYER 2
/// Layer for background
#define LOBBY_BACKGROUND_LAYER 3
///Layer for main buttons (Join/Ready, Observe, Character Prefs)
#define LOBBY_MENU_LAYER 4
///Layer for lobby menu shutter, which covers up the menu to collapse/expand it
#define LOBBY_SHUTTER_LAYER 5
///Layer for lobby menu buttons that are hanging away from and lower than the main panel
#define LOBBY_BOTTOM_BUTTON_LAYER 6

///Plane of the "splash" icon used that shows on the lobby screen. Nothing should ever be above this.
#define SPLASHSCREEN_PLANE 9999
#define SPLASHSCREEN_RENDER_TARGET "SPLASHSCREEN_RENDER_TARGET"

///Plane master controller keys
#define PLANE_MASTERS_GAME "plane_masters_game"
