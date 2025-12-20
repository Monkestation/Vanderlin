/atom/movable/screen/human

/atom/movable/screen/human/toggle
	name = "toggle"
	icon_state = "toggle"

/atom/movable/screen/human/toggle/Click()

	var/mob/targetmob = usr

	if(isobserver(usr))
		if(ishuman(usr.client.eye) && (usr.client.eye != usr))
			var/mob/M = usr.client.eye
			targetmob = M

	if(usr.hud_used.inventory_shown && targetmob.hud_used)
		usr.hud_used.inventory_shown = FALSE
		usr.client.screen -= targetmob.hud_used.toggleable_inventory
	else
		usr.hud_used.inventory_shown = TRUE
		usr.client.screen += targetmob.hud_used.toggleable_inventory

	targetmob.hud_used.hidden_inventory_update(usr)

/atom/movable/screen/human/equip
	name = "equip"
	icon_state = "act_equip"

/atom/movable/screen/human/equip/Click()
	var/mob/living/carbon/human/H = usr
	H.quick_equip()

/datum/hud/human/New(mob/living/carbon/human/owner)

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
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

	action_intent = new /atom/movable/screen/act_intent/rogintent(null, src)
	action_intent.screen_loc = rogueui_intents
	static_inventory += action_intent

	stressies = new /atom/movable/screen/stress(null, src)
	stressies.screen_loc = rogueui_stress
	static_inventory += stressies
	stressies.update_appearance(UPDATE_OVERLAYS)

	rmb_intent = new /atom/movable/screen/rmbintent(null, src)
	rmb_intent.screen_loc = rogueui_rmbintents
	static_inventory += rmb_intent
	rmb_intent.update_appearance(UPDATE_OVERLAYS)

	bloods = new /atom/movable/screen/healths/blood(null, src)
	bloods.screen_loc = rogueui_blood
	static_inventory += bloods

	quad_intents = new /atom/movable/screen/quad_intents(null, src)
	static_inventory += quad_intents

	def_intent = new /atom/movable/screen/def_intent(null, src)
	static_inventory += def_intent

	cmode_button = new /atom/movable/screen/cmode(null, src)
	static_inventory += cmode_button

	give_intent = new /atom/movable/screen/give_intent(null, src)
	static_inventory += give_intent

	backhudl =  new /atom/movable/screen/backhudl(null, src)
	static_inventory += backhudl

	hsover =  new /atom/movable/screen/heatstamover(null, src)
	static_inventory += hsover

	mana_over =  new /atom/movable/screen/mana_over(null, src)
	static_inventory += mana_over

	fov = new /atom/movable/screen/fov(null, src)
	static_inventory += fov

	fov_blocker = new /atom/movable/screen/fov_blocker(null, src)
	static_inventory += fov_blocker

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
	using.update_appearance(UPDATE_OVERLAYS)

	set_advclass()

	zone_select =  new /atom/movable/screen/zone_sel(null, src)
	zone_select.icon = 'icons/mob/roguehud64.dmi'
	zone_select.screen_loc = rogueui_targetdoll
	zone_select.update_appearance(UPDATE_OVERLAYS)
	static_inventory += zone_select

	stamina = new /atom/movable/screen/stamina()
	infodisplay += stamina

	energy = new /atom/movable/screen/energy()
	infodisplay += energy

	mana = new /atom/movable/screen/mana()
	infodisplay += mana


	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_appearance(UPDATE_ICON_STATE)

	update_locked_slots()
	mymob.update_a_intents()

/datum/hud/human/update_locked_slots()
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob
	if(!istype(H) || !H.dna)
		return
	var/datum/species/S = H.dna.species
	if(!S)
		return
	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			if(inv.slot_id in S.no_equip)
				inv.alpha = 128
			else
				inv.alpha = initial(inv.alpha)

/datum/hud/human/hidden_inventory_update(mob/viewer)
	if(!mymob)
		return
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used.inventory_shown && screenmob.hud_used.hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = rogueui_shoes
			screenmob.client.screen += H.shoes
		if(H.gloves)
			H.gloves.screen_loc = rogueui_gloves
			screenmob.client.screen += H.gloves
		if(H.wear_mask)
			H.wear_mask.screen_loc = rogueui_mask
			screenmob.client.screen += H.wear_mask
		if(H.mouth)
			H.mouth.screen_loc = rogueui_mouth
			screenmob.client.screen += H.mouth
		if(H.wear_neck)
			H.wear_neck.screen_loc = rogueui_neck
			screenmob.client.screen += H.wear_neck
		if(H.cloak)
			H.cloak.screen_loc = rogueui_cloak
			screenmob.client.screen += H.cloak
		if(H.wear_armor)
			H.wear_armor.screen_loc = rogueui_armor
			screenmob.client.screen += H.wear_armor
		if(H.wear_pants)
			H.wear_pants.screen_loc = rogueui_pants
			screenmob.client.screen += H.wear_pants
		if(H.wear_shirt)
			H.wear_shirt.screen_loc = rogueui_shirt
			screenmob.client.screen += H.wear_shirt
		if(H.wear_ring)
			H.wear_ring.screen_loc = rogueui_ringr
			screenmob.client.screen += H.wear_ring
		if(H.wear_wrists)
			H.wear_wrists.screen_loc = rogueui_wrists
			screenmob.client.screen += H.wear_wrists
		if(H.backr)
			H.backr.screen_loc = rogueui_backr
			screenmob.client.screen += H.backr
		if(H.backl)
			H.backl.screen_loc = rogueui_backl
			screenmob.client.screen += H.backl
		if(H.beltr)
			H.beltr.screen_loc = rogueui_beltr
			screenmob.client.screen += H.beltr
		if(H.belt)
			H.belt.screen_loc = rogueui_belt
			screenmob.client.screen += H.belt
		if(H.beltl)
			H.beltl.screen_loc = rogueui_beltl
			screenmob.client.screen += H.beltl
		if(H.head)
			H.head.screen_loc = rogueui_head
			screenmob.client.screen += H.head
	else
		return



/datum/hud/human/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return
	..()
	var/mob/living/carbon/human/H = mymob

	var/mob/screenmob = viewer || H

	if(screenmob.hud_used)
		if(screenmob.hud_used.hud_shown)
			if(H.wear_ring)
				H.wear_ring.screen_loc = ui_id
				screenmob.client.screen += H.wear_ring
			if(H.belt)
				H.belt.screen_loc = ui_belt
				screenmob.client.screen += H.belt
		else
			if(H.wear_ring)
				screenmob.client.screen -= H.wear_ring
			if(H.belt)
				screenmob.client.screen -= H.belt

	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in H.held_items)
			I.screen_loc = ui_hand_position(H.get_held_index_of_item(I))
			screenmob.client.screen += I
	else
		for(var/obj/item/I in H.held_items)
			I.screen_loc = null
			screenmob.client.screen -= I


/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = ""
	set hidden = 1
	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = FALSE
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = TRUE

/datum/hud/proc/set_advclass()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/advsetup(null, src)
	using.screen_loc = rogueui_advsetup
	static_inventory += using
