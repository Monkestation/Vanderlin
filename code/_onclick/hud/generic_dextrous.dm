//Used for normal mobs that have hands.
/datum/hud/dextrous/New(mob/living/owner)

	..()
	owner.overlay_fullscreen("see_through_darkness", /atom/movable/screen/fullscreen/see_through_darkness)
/*
	var/widescreen_layout = FALSE
	if(owner.client?.prefs?.widescreenpref)
		widescreen_layout = FALSE
*/
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	ui_style = ui_style

	//Rogue Slots /////////////////////////////////

	scannies = new /atom/movable/screen/scannies(null, src)
	static_inventory += scannies

	action_intent = new /atom/movable/screen/act_intent/rogintent(null, src)
	action_intent.screen_loc = rogueui_intents
	static_inventory += action_intent

	bloods = new /atom/movable/screen/healths/blood(null, src)
	bloods.screen_loc = rogueui_blood
	static_inventory += bloods

	quad_intents = new /atom/movable/screen/quad_intents(null, src)
	static_inventory += quad_intents

	def_intent = new /atom/movable/screen/def_intent(null, src)
	static_inventory += def_intent

	give_intent = new /atom/movable/screen/give_intent(null, src)
	static_inventory += give_intent

	backhudl =  new /atom/movable/screen/backhudl(null, src)
	static_inventory += backhudl

	hsover =  new /atom/movable/screen/heatstamover(null, src)
	static_inventory += hsover

	fov = new /atom/movable/screen/fov(null, src)
	static_inventory += fov

	cdleft = new /atom/movable/screen/action_bar/clickdelay/left(null, src)
	cdleft.screen_loc = "WEST-3:-16,SOUTH+7"
	static_inventory += cdleft

	cdright = new /atom/movable/screen/action_bar/clickdelay/right(null, src)
	cdright.screen_loc = "WEST-2:-16,SOUTH+7"
	static_inventory += cdright

	cdmid = new /atom/movable/screen/action_bar/clickdelay(null, src)
	cdmid.screen_loc = "WEST-3:0,SOUTH+7"
	static_inventory += cdmid

	build_hand_slots()

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "ring"
	inv_box.icon = ui_style
	inv_box.icon_state = "ring"
	inv_box.screen_loc = rogueui_ringr
	inv_box.slot_id = ITEM_SLOT_RING
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "wrists"
	inv_box.icon = ui_style
	inv_box.icon_state = "wrist"
	inv_box.screen_loc = rogueui_wrists
	inv_box.slot_id = ITEM_SLOT_WRISTS
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "mask"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
	inv_box.screen_loc = rogueui_mask
	inv_box.slot_id = ITEM_SLOT_MASK
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "neck"
	inv_box.icon = ui_style
	inv_box.icon_state = "neck"
	inv_box.screen_loc = rogueui_neck
	inv_box.slot_id = ITEM_SLOT_NECK
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "backl"
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
	inv_box.screen_loc = rogueui_backl
	inv_box.slot_id = ITEM_SLOT_BACK_L
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "backr"
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
	inv_box.screen_loc = rogueui_backr
	inv_box.slot_id = ITEM_SLOT_BACK_R
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "gloves"
	inv_box.icon = ui_style
	inv_box.icon_state = "gloves"
	inv_box.screen_loc = rogueui_gloves
	inv_box.slot_id = ITEM_SLOT_GLOVES
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "head"
	inv_box.icon = ui_style
	inv_box.icon_state = "head"
	inv_box.screen_loc = rogueui_head
	inv_box.slot_id = ITEM_SLOT_HEAD
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "shoes"
	inv_box.icon = ui_style
	inv_box.icon_state = "shoes"
	inv_box.screen_loc = rogueui_shoes
	inv_box.slot_id = ITEM_SLOT_SHOES
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "belt"
	inv_box.icon = ui_style
	inv_box.icon_state = "belt"
	inv_box.screen_loc = rogueui_belt
	inv_box.slot_id = ITEM_SLOT_BELT
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "hip r"
	inv_box.icon = ui_style
	inv_box.icon_state = "hip"
	inv_box.screen_loc = rogueui_beltr
	inv_box.slot_id = ITEM_SLOT_BELT_R
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "hip l"
	inv_box.icon = ui_style
	inv_box.icon_state = "hip"
	inv_box.screen_loc = rogueui_beltl
	inv_box.slot_id = ITEM_SLOT_BELT_L
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "shirt"
	inv_box.icon = ui_style
	inv_box.icon_state = "shirt"
	inv_box.screen_loc = rogueui_shirt
	inv_box.slot_id = ITEM_SLOT_SHIRT
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "trou"
	inv_box.icon = ui_style
	inv_box.icon_state = "pants"
	inv_box.screen_loc = rogueui_pants
	inv_box.slot_id = ITEM_SLOT_PANTS
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "armor"
	inv_box.icon = ui_style
	inv_box.icon_state = "armor"
	inv_box.screen_loc = rogueui_armor
	inv_box.slot_id = ITEM_SLOT_ARMOR
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "cloak"
	inv_box.icon = ui_style
	inv_box.icon_state = "cloak"
	inv_box.screen_loc = rogueui_cloak
	inv_box.slot_id = ITEM_SLOT_CLOAK
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(null, src)
	inv_box.name = "mouth"
	inv_box.icon = ui_style
	inv_box.icon_state = "mouth"
	inv_box.screen_loc = rogueui_mouth
	inv_box.slot_id = ITEM_SLOT_MOUTH
	static_inventory += inv_box

	using = new /atom/movable/screen/drop(null, src)
	using.icon = ui_style
	using.screen_loc = rogueui_drop
	static_inventory += using

	throw_icon = new /atom/movable/screen/throw_catch(null, src)
	throw_icon.icon = ui_style
	throw_icon.screen_loc = rogueui_throw
	hotkeybuttons += throw_icon

	using = new /atom/movable/screen/restup(null, src)
	using.icon = ui_style
	using.screen_loc = rogueui_stance
	static_inventory += using

	using = new /atom/movable/screen/restdown(null, src)
	using.icon = ui_style
	using.screen_loc = rogueui_stance
	static_inventory += using

	using = new/atom/movable/screen/skills(null, src)
	using.icon = ui_style
	using.screen_loc = rogueui_skills
	static_inventory += using

	using = new/atom/movable/screen/craft(null, src)
	using.icon = ui_style
	using.screen_loc = rogueui_craft
	static_inventory += using


	using = new /atom/movable/screen/rogmove(null, src)
	using.screen_loc = rogueui_moves
	static_inventory += using
	using.update_appearance(UPDATE_ICON_STATE)

	using = new /atom/movable/screen/rogmove/sprint(null, src)
	using.screen_loc = rogueui_moves
	static_inventory += using
	using.update_appearance(UPDATE_ICON_STATE)

	using = new /atom/movable/screen/eye_intent(null, src)
	using.icon = ui_style
	using.icon_state = "eye"
	using.screen_loc = rogueui_eye
	static_inventory += using

	zone_select =  new /atom/movable/screen/zone_sel(null, src)
	zone_select.icon = 'icons/mob/roguehud64.dmi'
	zone_select.screen_loc = rogueui_targetdoll
	zone_select.update_appearance(UPDATE_OVERLAYS)
	static_inventory += zone_select

	zone_select.update_appearance(UPDATE_OVERLAYS)

	stamina = new /atom/movable/screen/stamina(null, src)
	infodisplay += stamina

	energy = new /atom/movable/screen/energy(null, src)
	infodisplay += energy

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_appearance(UPDATE_ICON_STATE)

	update_locked_slots()
	mymob.update_a_intents()

/datum/hud/dextrous/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/D = mymob
	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in D.held_items)
			I.screen_loc = ui_hand_position(D.get_held_index_of_item(I))
			D.client.screen += I
	else
		for(var/obj/item/I in D.held_items)
			I.screen_loc = null
			D.client.screen -= I


//Dextrous simple mobs can use hands!
/mob/living/simple_animal/create_mob_hud()
	if(dextrous)
		hud_type = dextrous_hud_type
	return ..()
