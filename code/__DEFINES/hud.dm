//HUD styles.  Index order defines how they are cycled in F12.
/// Standard hud
#define HUD_STYLE_STANDARD 1
/// Reduced hud (just hands and intent switcher)
#define HUD_STYLE_REDUCED 2
/// No hud (for screenshots)
#define HUD_STYLE_NOHUD 3

/// Used in show_hud(); Please ensure this is the same as the maximum index.
#define HUD_VERSIONS 3

// Consider these images/atoms as part of the UI/HUD
#define APPEARANCE_UI_IGNORE_ALPHA (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|RESET_ALPHA|PIXEL_SCALE)
#define APPEARANCE_UI (RESET_COLOR|RESET_TRANSFORM|NO_CLIENT_COLOR|PIXEL_SCALE)

// Defines relating to action button positions

/// Whatever the base action datum thinks is best
#define SCRN_OBJ_DEFAULT "default"
/// Floating somewhere on the hud, not in any predefined place
#define SCRN_OBJ_FLOATING "floating"
/// In the list of buttons stored at the bottom of the screen
#define SCRN_OBJ_IN_LIST "list"
/// In the collapseable palette
#define SCRN_OBJ_IN_PALETTE "palette"
///Inserted first in the list
#define SCRN_OBJ_INSERT_FIRST "first"

/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.
	The short version:
	Everything is encoded as strings because apparently that's how Byond rolls.
	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.
	In addition, the keywords NORTH, SOUTH, EAST, WEST and CENTER can be used to represent their respective
	screen borders. NORTH-1, for example, is the row just below the upper edge. Useful if you want your
	UI to scale with screen size.
	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

/proc/ui_hand_position(i)
	var/x_off = i % 2 ? 1 : 0
	return "WEST-[2+x_off]:-16,SOUTH+7"

/proc/ui_equip_position(mob/M)
	var/y_off = round((M.held_items.len-1) / 2) //values based on old equip ui position (CENTER: +/-16,SOUTH+1:5)
	return "CENTER:-16,SOUTH+[y_off+1]:5"

/proc/ui_swaphand_position(mob/M, which = 1) //values based on old swaphand ui positions (CENTER: +/-16,SOUTH+1:5)
	var/x_off = which == 1 ? -1 : 0
	var/y_off = round((M.held_items.len-1) / 2)
	return "CENTER+[x_off]:16,SOUTH+[y_off+1]:5"

//Lower center, persistent menu
#define ui_id "CENTER-4:12,SOUTH:5"
#define ui_belt "CENTER-3:14,SOUTH:5"

//Lower right, persistent menu
#define ui_drop_throw "EAST-1:28,SOUTH+1:7"
#define ui_above_movement "EAST-2:26,SOUTH+1:7"
#define ui_above_intent "EAST-3:24, SOUTH+1:7"
#define ui_movi "EAST-2:26,SOUTH:5"
#define ui_acti "EAST-3:24,SOUTH:5"
#define ui_combat_toggle "EAST-3:24,SOUTH:5"
#define ui_zonesel "EAST-1:28,SOUTH:5"
#define ui_acti_alt "EAST-1:28,SOUTH:5" //alternative intent switcher for when the interface is hidden (F12)
#define ui_crafting "EAST-4:22,SOUTH:5"
#define ui_building "EAST-4:22,SOUTH:21"
#define ui_language_menu "EAST-4:6,SOUTH:21"
#define ui_skill_menu "EAST-4:22,SOUTH:5"

//Upper left (action buttons)
#define ui_action_palette "WEST+0:23,SOUTH+1:16"
#define ui_action_palette_offset(north_offset) ("WEST+0:23,SOUTH+[1+north_offset]:16")

#define ui_palette_scroll "WEST+1:8,SOUTH+5:8"
#define ui_palette_scroll_offset(north_offset) ("WEST+1:8,SOUTH+[5+north_offset]:8")

#define ui_storage1 "CENTER+1:18,SOUTH:5"
#define ui_storage2 "CENTER+2:20,SOUTH:5"

#define ui_borg_sensor "CENTER-3:16, SOUTH:5"		//borgs
#define ui_borg_lamp "CENTER-4:16, SOUTH:5"			//borgs
#define ui_borg_thrusters "CENTER-5:16, SOUTH:5"	//borgs
#define ui_inv1 "CENTER-2:16,SOUTH:5"				//borgs
#define ui_inv2 "CENTER-1  :16,SOUTH:5"				//borgs
#define ui_inv3 "CENTER  :16,SOUTH:5"				//borgs
#define ui_borg_module "CENTER+1:16,SOUTH:5"		//borgs
#define ui_borg_store "CENTER+2:16,SOUTH:5"			//borgs
#define ui_borg_camera "CENTER+3:21,SOUTH:5"		//borgs
#define ui_borg_album "CENTER+4:21,SOUTH:5"			//borgs
#define ui_borg_language_menu "CENTER+4:21,SOUTH+1:5"	//borgs

#define ui_monkey_head "CENTER-5:13,SOUTH:5"	//monkey
#define ui_monkey_mask "CENTER-4:14,SOUTH:5"	//monkey
#define ui_monkey_neck "CENTER-3:15,SOUTH:5"	//monkey
#define ui_monkey_back "CENTER-2:16,SOUTH:5"	//monkey

#define ui_drone_drop "CENTER+1:18,SOUTH:5"     //maintenance drones
#define ui_drone_pull "CENTER+2:2,SOUTH:5"      //maintenance drones
#define ui_drone_storage "CENTER-2:14,SOUTH:5"  //maintenance drones
#define ui_drone_head "CENTER-3:14,SOUTH:5"     //maintenance drones

#define ui_borg_pull "EAST-2:26,SOUTH+1:7"
#define ui_borg_radio "EAST-1:28,SOUTH+1:7"
#define ui_borg_intents "EAST-2:26,SOUTH:5"

//Upper-middle right (alerts)
#define ui_alert1 "EAST+0:-14,CENTER-7:16"
#define ui_alert2 "EAST+0:-34,CENTER-7:16"
#define ui_alert3 "EAST+0:-54,CENTER-7:16"
#define ui_alert4 "EAST+0:-74,CENTER-7:16"
#define ui_alert5 "EAST+0:-94,CENTER-7:16"
#define ui_alert6 "EAST+0:-114,CENTER-7:16"
#define ui_alert7 "EAST+0:-134,CENTER-7:16"
#define ui_alert8 "EAST+0:-154,CENTER-7:16"
#define ui_alert9 "EAST+0:-174,CENTER-7:16"
#define ui_alert10 "EAST+0:-194,CENTER-7:16"

#define ui_balert1 "EAST+0:-14,CENTER+7:-16"
#define ui_balert2 "EAST+0:-34,CENTER+7:-16"
#define ui_balert3 "EAST+0:-54,CENTER+7:-16"
#define ui_balert4 "EAST+0:-74,CENTER+7:-16"
#define ui_balert5 "EAST+0:-94,CENTER+7:-16"
#define ui_balert6 "EAST+0:-114,CENTER+7:-16"
#define ui_balert7 "EAST+0:-134,CENTER+7:-16"
#define ui_balert8 "EAST+0:-154,CENTER+7:-16"
#define ui_balert9 "EAST+0:-174,CENTER+7:-16"
#define ui_balert10 "EAST+0:-194,CENTER+7:-16"

#define ui_dalert1 "WEST+0:14,CENTER+7:-16"
#define ui_dalert2 "WEST+0:34,CENTER+7:-16"
#define ui_dalert3 "WEST+0:54,CENTER+7:-16"
#define ui_dalert4 "WEST+0:74,CENTER+7:-16"
#define ui_dalert5 "WEST+0:94,CENTER+7:-16"
#define ui_dalert6 "WEST+0:114,CENTER+7:-16"
#define ui_dalert7 "WEST+0:134,CENTER+7:-16"
#define ui_dalert8 "WEST+0:154,CENTER+7:-16"
#define ui_dalert9 "WEST+0:174,CENTER+7:-16"
#define ui_dalert10 "WEST+0:194,CENTER+7:-16"


//Middle right (status indicators)
#define ui_healthdoll "EAST-1:28,CENTER-2:13"
#define ui_health "EAST-1:28,CENTER-1:15"
#define ui_internal "EAST-1:28,CENTER:17"
#define ui_mood "EAST-1:28,CENTER-3:10"

//Backhud
#define ui_backhudr "EAST-2:0,SOUTH:0"
#define ui_backhudl "WEST-5:0,SOUTH:0"

//Rogue UI
#define rogueui_righthand "WEST-2:-16,SOUTH+7:8"
#define rogueui_lefthand "WEST-3:-16,SOUTH+7:8"

#define rogueui_ringr "WEST-4,SOUTH+3"
#define rogueui_wrists "WEST-2,SOUTH+4"
#define rogueui_mask "WEST-4,SOUTH+6"
#define rogueui_neck "WEST-4,SOUTH+4"
#define rogueui_backl "WEST-2,SOUTH+5"
#define rogueui_backr "WEST-4,SOUTH+5"
#define rogueui_gloves "WEST-2,SOUTH+3"
#define rogueui_head "WEST-3,SOUTH+6"
#define rogueui_shoes "WEST-3:16,SOUTH+1"
#define rogueui_beltr "WEST-4,SOUTH+2"
#define rogueui_beltl "WEST-2,SOUTH+2"
#define rogueui_belt "WEST-3,SOUTH+2"
#define rogueui_shirt "WEST-3,SOUTH+3"
#define rogueui_pants "WEST-4:16,SOUTH+1"
#define rogueui_armor "WEST-3,SOUTH+4"
#define rogueui_cloak "WEST-3,SOUTH+5"
#define rogueui_mouth "WEST-2,SOUTH+6"

#define rogueui_drop "WEST-1:-16,SOUTH+7"
#define rogueui_throw "WEST-1:-16,SOUTH+7"
#define rogueui_stance "WEST-4,CENTER+2"
#define rogueui_resist "WEST-3,CENTER+3"
#define rogueui_moves "WEST-3,CENTER+2"
#define rogueui_movec "WEST-2,CENTER+2"
#define rogueui_moveq "WEST-1,CENTER+2"
#define rogueui_eye "WEST-2,CENTER+3"
#define rogueui_advsetup "CENTER-1,CENTER-1:16"
#define rogueui_craft "WEST-4,CENTER+3"
#define rogueui_skills "WEST-4,CENTER+3"
#define rogueui_targetdoll "WEST-3:-16,CENTER+4:6"
#define rogueui_quad "WEST-4:-16,SOUTH+7"
#define rogueui_give "WEST-1:-16,SOUTH+7"
#define rogueui_aim "WEST-4:9,CENTER+4"

#define rogueui_clock "WEST-3:-16,CENTER+6:1"

#define rogueui_intents "WEST-5:-16,SOUTH+8"
#define rogueui_stress "WEST-3,CENTER+3"
#define rogueui_spells "WEST-4:2,SOUTH+8"

#define mana_loc "WEST-5,CENTER+2"
#define stamina_loc "WEST-1,CENTER+2"
#define energy_loc "WEST-1:0,CENTER+4"
#define rogueui_blood "WEST-1:6,CENTER+4:17"
#define rogueui_vitae "WEST-5:-8,CENTER+2"

#define rogueui_cmode "WEST-1:-16,CENTER+1"
#define rogueui_def "WEST-2,NORTH-5"

#define rogueui_rmbintents "WEST-4:-16,CENTER+1"

//borgs
#define ui_borg_health "EAST-1:28,CENTER-1:15"		//borgs have the health display where humans have the pressure damage indicator.

#define ui_construct_pull "EAST,CENTER-2:15"
#define ui_construct_health "EAST,CENTER:15"  //same as borgs and humans

//Pop-up inventory
#define ui_shoes "WEST+1:8,SOUTH:5"

#define ui_iclothing "WEST:6,SOUTH+1:7"
#define ui_oclothing "WEST+1:8,SOUTH+1:7"
#define ui_gloves "WEST+2:10,SOUTH+1:7"

#define ui_glasses "WEST:6,SOUTH+3:11"
#define ui_mask "WEST+1:8,SOUTH+2:9"
#define ui_ears "WEST+2:10,SOUTH+2:9"
#define ui_neck "WEST:6,SOUTH+2:9"
#define ui_head "WEST+1:8,SOUTH+3:11"

//Ghosts
#define ui_ghost_jumptomob "SOUTH:6,CENTER-2:24"
#define ui_ghost_orbit "SOUTH:6,CENTER-1:24"
#define ui_ghost_reenter_corpse "SOUTH:6,CENTER:24"
#define ui_ghost_teleport "SOUTH:6,CENTER+1:24"
#define ui_ghost_pai "SOUTH: 6, CENTER+2:24"

#define UI_BOXCRAFT "EAST-4:22,SOUTH+1:6"
#define UI_BOXAREA "EAST-4:6,SOUTH+1:6"
#define UI_BOXLANG "EAST-5:22,SOUTH+1:6"
#define ALERT_STATUS 0
#define ALERT_DEBUFF 1
#define ALERT_BUFF 2
