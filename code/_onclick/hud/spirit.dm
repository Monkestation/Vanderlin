/datum/hud/spirit/New(mob/living/carbon/monkey/owner)
	..()
	var/atom/movable/screen/using

	action_intent = new /atom/movable/screen/act_intent/rogintent(null, src)
	action_intent.icon = ui_style
	action_intent.icon_state = mymob.used_intent.name
	action_intent.screen_loc = ui_acti
	static_inventory += action_intent

	using = new /atom/movable/screen/mov_intent(null, src)
	using.icon = ui_style
	using.icon_state = (mymob.m_intent == MOVE_INTENT_RUN ? "running" : "walking")
	using.screen_loc = ui_movi
	static_inventory += using

	build_hand_slots()

	using = new /atom/movable/screen/swap_hand(null, src)
	using.icon = ui_style
	using.icon_state = "swap_1_m"	//extra wide!
	using.screen_loc = ui_swaphand_position(owner,1)
	static_inventory += using

	using = new /atom/movable/screen/swap_hand(null, src)
	using.icon = ui_style
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(owner, 2)
	static_inventory += using

	mymob.client.screen = list()

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_appearance(UPDATE_ICON_STATE)

/datum/hud/spirit/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/carbon/monkey/M = mymob

	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in M.held_items)
			I.screen_loc = ui_hand_position(M.get_held_index_of_item(I))
			M.client.screen += I
	else
		for(var/obj/item/I in M.held_items)
			I.screen_loc = null
			M.client.screen -= I
