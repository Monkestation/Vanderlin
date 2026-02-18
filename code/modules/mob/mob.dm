GLOBAL_VAR_INIT(mobids, 1)

/**
 * Delete a mob
 *
 * Removes mob from the following global lists
 * * GLOB.mob_list
 * * GLOB.dead_mob_list
 * * GLOB.alive_mob_list
 * * GLOB.all_clockwork_mobs
 * * GLOB.mob_directory
 *
 * Unsets the focus var
 *
 * Clears alerts for this mob
 *
 * Resets all the observers perspectives to the tile this mob is on
 *
 * qdels any client colours in place on this mob
 *
 * Ghostizes the client attached to this mob
 *
 * Parent call
 *
 * Returns QDEL_HINT_HARDDEL (don't change this)
 */
/mob/Destroy()//This makes sure that mobs with clients/keys are not just deleted from the game.
	GLOB.mob_list -= src
	GLOB.dead_mob_list -= src
	GLOB.alive_mob_list -= src
	GLOB.mob_directory -= tag
	focus = null

	for (var/alert in alerts)
		clear_alert(alert, TRUE)
	if(observers && observers.len)
		for(var/mob/dead/observe as anything in observers)
			observe.reset_perspective(null)
	qdel(hud_used)
	for(var/cc in client_colours)
		qdel(cc)
	client_colours = null
	ghostize(drawskip=TRUE)
	..()
	return QDEL_HINT_HARDDEL

/// Assigns a (c)key to this mob.
/mob/proc/PossessByPlayer(ckey)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(isnull(ckey))
		return

	if(!istext(ckey))
		CRASH("Tried to assign a mob a non-text ckey, wtf?!")

	src.ckey = ckey(ckey)

/**
 * Intialize a mob
 *
 * Sends global signal COMSIG_GLOB_MOB_CREATED
 *
 * Adds to global lists
 * * GLOB.mob_list
 * * GLOB.mob_directory (by tag)
 * * GLOB.dead_mob_list - if mob is dead
 * * GLOB.alive_mob_list - if the mob is alive
 *
 * Other stuff:
 * * Sets the mob focus to itself
 * * Generates huds
 * * If there are any global alternate apperances apply them to this mob
 * * set a random nutrition level
 * * Intialize the movespeed of the mob
 */
/mob/Initialize()
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_CREATED, src)
	GLOB.mob_list += src
	GLOB.mob_directory[tag] = src
	mobid = "mob[GLOB.mobids]"
	GLOB.mobids++
	if(stat == DEAD)
		GLOB.dead_mob_list += src
	else
		GLOB.alive_mob_list += src
	set_focus(src)
	prepare_huds()
	for(var/v in GLOB.active_alternate_appearances)
		if(!v)
			continue
		var/datum/atom_hud/alternate_appearance/AA = v
		AA.onNewMob(src)
	set_nutrition(rand(NUTRITION_LEVEL_START_MIN, NUTRITION_LEVEL_START_MAX))
	set_hydration(rand(HYDRATION_LEVEL_START_MIN, HYDRATION_LEVEL_START_MAX))
	. = ..()
	update_config_movespeed()
	update_movespeed(TRUE)
	become_hearing_sensitive()

/**
 * Generate the tag for this mob
 *
 * This is simply "mob_"+ a global incrementing counter that goes up for every mob
 */
/mob/GenerateTag()
	tag = "mob_[next_mob_id++]"

/**
 * Prepare the huds for this atom
 *
 * Goes through hud_possible list and adds the images to the hud_list variable (if not already
 * cached)
 */
/atom/proc/prepare_huds()
	hud_list = list()
	for(var/hud in hud_possible)
		var/hint = hud_possible[hud]
		switch(hint)
			if(HUD_LIST_LIST)
				hud_list[hud] = list()
			else
				var/image/I = image('icons/mob/hud.dmi', src, "")
				I.appearance_flags = RESET_COLOR|RESET_TRANSFORM
				hud_list[hud] = I

/**
 * Show a message to this mob (visual or audible)
 */
/mob/proc/show_message(msg, type, alt_msg, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	if(!client)
		return

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if(type)
		if(type & MSG_VISUAL && is_blind() )//Vision related
			if(!alt_msg)
				return
			else
				msg = alt_msg
				type = alt_type

		if(type & MSG_AUDIBLE && !can_hear())//Hearing related
			if(!alt_msg)
				return
			else
				msg = alt_msg
				type = alt_type
				if(type & MSG_VISUAL && is_blind())
					return
	to_chat(src, msg)

/**
 * Generate a visible message from this atom
 *
 * Show a message to all player mobs who sees this atom
 *
 * Show a message to the src mob (if the src is a mob)
 *
 * Use for atoms performing visible actions
 *
 * message is output to anyone who can see, e.g. "The [src] does something!"
 *
 * Vars:
 * * self_message (optional) is what the src mob sees e.g. "You do something!"
 * * blind_message (optional) is what blind people will hear e.g. "You hear something!"
 * * vision_distance (optional) define how many tiles away the message can be seen.
 * * ignored_mob (optional) doesn't show any message to a given mob if TRUE.
 */
/atom/proc/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, runechat_message = null, log_seen = NONE, log_seen_msg = null)
	var/turf/T = get_turf(src)
	if(!T)
		return
	if(!islist(ignored_mobs))
		ignored_mobs = list(ignored_mobs)
	var/list/hearers = get_hearers_in_view(vision_distance, src) //caches the hearers and then removes ignored mobs.
	hearers -= ignored_mobs
	if(self_message)
		hearers -= src
	for(var/mob/M in hearers)
		if(!M.client)
			continue
		//This entire if/else chain could be in two lines but isn't for readibilties sake.
		var/msg = message
		if(M.see_invisible < invisibility)//if src is invisible to M
			msg = blind_message
		if(!msg)
			continue
		if(M != src && !M.is_blind())
			M.log_message("saw [key_name(src)] emote: [message]", LOG_EMOTE, log_globally = FALSE)
		M.show_message(msg, MSG_VISUAL, blind_message, MSG_AUDIBLE)
		if(runechat_message && M.can_hear())
			M.create_chat_message(src, raw_message = runechat_message, spans = list("emote"))

///Adds the functionality to self_message.
/mob/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, runechat_message = null, log_seen = NONE, log_seen_msg = null)
	. = ..()
	if(self_message)
		show_message(self_message, MSG_VISUAL, blind_message, MSG_AUDIBLE)

/**
 * Show a message to all mobs in earshot of this atom
 *
 * Use for objects performing audible actions
 *
 * vars:
 * * message is the message output to anyone who can hear.
 * * deaf_message (optional) is what deaf people will see.
 * * hearing_distance (optional) is the range, how many tiles away the message can be heard.
 */
/atom/proc/audible_message(message, deaf_message, hearing_distance = DEFAULT_MESSAGE_RANGE, self_message, runechat_message = null)
	var/list/hearers = get_hearers_in_view(hearing_distance, src)
	if(self_message)
		hearers -= src
	for(var/mob/M in hearers)
		if(M != src && M.client)
			if(M.can_hear())
				M.log_message("heard [key_name(src)] emote: [message]", LOG_EMOTE, log_globally = FALSE)
		M.show_message(message, MSG_AUDIBLE, deaf_message, MSG_VISUAL)
		if(runechat_message && M.can_see_runechat(src) && M.can_hear())
			M.create_chat_message(src, raw_message = runechat_message, spans = list("emote"))

/**
 * Show a message to all mobs in earshot of this one
 *
 * This would be for audible actions by the src mob
 *
 * vars:
 * * message is the message output to anyone who can hear.
 * * self_message (optional) is what the src mob hears.
 * * deaf_message (optional) is what deaf people will see.
 * * hearing_distance (optional) is the range, how many tiles away the message can be heard.
 */
/mob/audible_message(message, deaf_message, hearing_distance = DEFAULT_MESSAGE_RANGE, self_message, runechat_message = null)
	. = ..()
	if(self_message)
		show_message(self_message, MSG_AUDIBLE, deaf_message, MSG_VISUAL)

///Get the item on the mob in the storage slot identified by the id passed in
/mob/proc/get_item_by_slot(slot_id)
	return null

/**
 * Gets what slot the item on the mob is held in.
 * Returns null if the item isn't in any slots on our mob.
 * Does not check if the passed item is null, which may result in unexpected outcoms.
*/
/mob/proc/get_slot_by_item(obj/item/looking_for)
	if(looking_for in held_items)
		return ITEM_SLOT_HANDS

	return null

///Is the mob incapacitated
/mob/proc/incapacitated(flags)
	return

/**
 * This proc is called whenever someone clicks an inventory ui slot.
 *
 * Mostly tries to put the item into the slot if possible, or call attack hand
 * on the item in the slot if the users active hand is empty
 */
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_held_item()

	if(istype(W))
		if(equip_to_slot_if_possible(W, slot,0,0,0))
			return 1

	if(!W)
		// Activate the item
		var/obj/item/I = get_item_by_slot(slot)
		if(istype(I))
			I.attack_hand(src)

	return 0

/**
 * Try to equip an item to a slot on the mob
 *
 * This is a SAFE proc. Use this instead of equip_to_slot()!
 *
 * set qdel_on_fail to have it delete W if it fails to equip
 *
 * set disable_warning to disable the 'you are unable to equip that' warning.
 *
 * unset redraw_mob to prevent the mob icons from being redrawn at the end.
 *
 * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 */
/mob/proc/equip_to_slot_if_possible(obj/item/W, slot, qdel_on_fail = FALSE, disable_warning = FALSE, redraw_mob = TRUE, bypass_equip_delay_self = FALSE, initial)
	if(!istype(W) || QDELETED(W)) //This qdeleted is to prevent stupid behavior with things that qdel during init, like say stacks
		return FALSE
	if(!W.mob_can_equip(src, null, slot, disable_warning, bypass_equip_delay_self))
		if(qdel_on_fail)
			qdel(W)
		else if(!disable_warning)
			to_chat(src, span_warning("I can't equip that!"))
		return FALSE
	equip_to_slot(W, slot, initial, redraw_mob) //This proc should not ever fail.
	update_a_intents()
	return TRUE

/**
 * Actually equips an item to a slot (UNSAFE)
 *
 * This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on
 * whether you can or can't equip need to be done before! Use mob_can_equip() for that task.
 *
 *In most cases you will want to use equip_to_slot_if_possible()
 */
/mob/proc/equip_to_slot(obj/item/equipping, slot, initial = FALSE, redraw_mob = FALSE)
	return

/**
 * Equip an item to the slot or delete
 *
 * This is just a commonly used configuration for the equip_to_slot_if_possible() proc, used to
 * equip people when the round starts and when events happen and such.
 *
 * Also bypasses equip delay checks, since the mob isn't actually putting it on.
 * Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
 */
/mob/proc/equip_to_slot_or_del(obj/item/W, slot, initial)
	return equip_to_slot_if_possible(W, slot, TRUE, TRUE, FALSE, TRUE, initial)

/**
 * Auto equip the passed in item the appropriate slot based on equipment priority
 *
 * puts the item "W" into an appropriate slot in a human's inventory
 *
 * returns 0 if it cannot, 1 if successful
 */
/mob/proc/equip_to_appropriate_slot(obj/item/equipping, delete_on_fail = FALSE, initial = FALSE)
	if(!istype(equipping))
		return FALSE

	var/slot_priority = equipping.slot_equipment_priority

	if(!slot_priority)
		slot_priority = DEFAULT_SLOT_PRIORITY

	for(var/slot as anything in slot_priority)
		if(equip_to_slot_if_possible(equipping, slot, FALSE, TRUE, TRUE, initial = initial)) //qdel_on_fail = 0; disable_warning = 1; redraw_mob = 1
			return TRUE

	if(delete_on_fail)
		qdel(equipping)
	return FALSE
/**
 * Reset the attached clients perspective (viewpoint)
 *
 * reset_perspective() set eye to common default : mob on turf, loc otherwise
 * reset_perspective(thing) set the eye to the thing (if it's equal to current default reset to mob perspective)
 */
/mob/proc/reset_perspective(atom/new_perspective)
	if(!client)
		return

	if(!new_perspective)
		if(isturf(loc))
			client.eye = client.mob
			client.perspective = MOB_PERSPECTIVE
		else
			client.perspective = EYE_PERSPECTIVE
			client.eye = loc
		return

	if(ismovableatom(new_perspective))
		//Set the thing unless it's us
		if(new_perspective != src)
			client.perspective = EYE_PERSPECTIVE
			client.eye = new_perspective
		else
			client.eye = client.mob
			client.perspective = MOB_PERSPECTIVE
		return

	if(isturf(new_perspective))
		//Set to the turf unless it's our current turf
		if(new_perspective != loc)
			client.perspective = EYE_PERSPECTIVE
			client.eye = new_perspective
		else
			client.eye = client.mob
			client.perspective = MOB_PERSPECTIVE

/// Show the mob's inventory to another mob
/mob/proc/show_inv(mob/user)
	return

/**
 * Examine a mob
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/examine()
 */
/mob/verb/examinate(atom/examinify as mob|obj|turf in view()) //It used to be oview(12), but I can't really say why
	set name = "Examine"
	set category = "IC"

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(run_examinate), examinify))

/mob/proc/run_examinate(atom/examinify)
	if(QDELETED(examinify)) // since this can run async we might have had the atom get qdeleted already
		return

	if(isturf(examinify) && !(sight & SEE_TURFS) && !(examinify in view(client ? client.view : world.view, src)))
		// shift-click catcher may issue examinate() calls for out-of-sight turfs
		return

	if(is_blind())
		to_chat(src, span_warning("Something is there but I can't see it!"))
		return

	if(isturf(examinify.loc) && isliving(src) && stat == CONSCIOUS)
		face_atom(examinify)
		if(m_intent != MOVE_INTENT_SNEAK)
			visible_message(span_emote("[src] looks at [examinify]."), span_emote("I look at [examinify]"))
		else if(isliving(examinify))
			var/mob/living/examaniee = examinify
			if(examaniee.peek_examine_check(src))
				to_chat(src, span_info("My peeking went unnoticed.."))
			else
				to_chat(src, span_warning("[examaniee] noticed me peeking!"))

				if(examaniee.client) // only if they have a client to see it
					to_chat(examaniee, span_warning("[src] peeks at you!"))
					found_ping(get_turf(src), examaniee.client, "hidden")

	var/list/result = examinify.examine(src)
	if(LAZYLEN(result))
		for(var/i in 1 to (length(result) - 1))
			result[i] += "\n"
		to_chat(src, examine_block("<span class='infoplain'>[result.Join()]</span>"))

	SEND_SIGNAL(src, COMSIG_MOB_EXAMINATE, examinify)

// Check if we notice an observer
/mob/living/proc/peek_examine_check(mob/living/observer)
	if(!istype(observer))
		return FALSE

	if(is_blind() || stat < CONSCIOUS)
		return FALSE

	var/observer_skill = observer.get_skill_level(/datum/skill/misc/sneaking)
	if(observer_skill <= 0)
		observer_skill = 1
	if(observer.rogue_sneaking)
		observer_skill += 1

	var/multiplier = 5

	var/our_per = STAPER
	if(our_per < 5)
		multiplier = 4
	else if(our_per >= 5 && our_per < 10)
		multiplier = 5
	else if(our_per >= 10 && our_per < 15)
		multiplier = 6
	else if(our_per >= 15 && our_per <= 20)
		multiplier = 7

	// calculate probability to fail
	var/probby = (our_per * multiplier) - (observer_skill * 10)

	return prob(clamp(probby, 5, 95))

///Can this mob resist (default FALSE)
/mob/proc/can_resist()
	return FALSE		//overridden in living.dm

///Spin this mob around it's central axis
/mob/proc/spin(spintime, speed)
	set waitfor = 0
	var/D = dir
	if((spintime < 1)||(speed < 1)||!spintime||!speed)
		return

	flags_1 |= IS_SPINNING_1
	while(spintime >= speed)
		sleep(speed)
		switch(D)
			if(NORTH)
				D = EAST
			if(SOUTH)
				D = WEST
			if(EAST)
				D = SOUTH
			if(WEST)
				D = NORTH
		setDir(D)
		spintime -= speed
	flags_1 &= ~IS_SPINNING_1

///Update the pulling hud icon
/mob/proc/update_pull_hud_icon()
	hud_used?.pull_icon?.update_appearance()

///Update the resting hud icon
/mob/proc/update_rest_hud_icon()
	hud_used?.rest_icon?.update_appearance()

/**
 * Verb to activate the object in your held hand
 *
 * Calls attack self on the item and updates the inventory hud for hands
 */
/mob/verb/mode()
	set name = "Activate Held Object"
	set hidden = 1
	set src = usr

	if(incapacitated(IGNORE_GRAB))
		return

	var/obj/item/I = get_active_held_item()
	if(I)
		I.attack_self(src)
		update_inv_hands()

/**
 * Get the notes of this mob
 *
 * This actually gets the mind datums notes
 */
/mob/verb/memory()
	set name = "Memories"
	set category = "IC"
	set desc = ""
	if(mind)
		mind.show_memory(src)
//	else
//		to_chat(src, "You don't have a mind datum for some reason, so you can't look at your notes, if you had any.")

/**
 * Add a note to the mind datum
 */
/mob/verb/add_memory(msg as message)
	set name = "Add Memory"
	set category = "IC"
	if(mind)
		if (world.time < memory_throttle_time)
			return
		memory_throttle_time = world.time + 5 SECONDS
		msg = copytext(msg, 1, MAX_MESSAGE_LEN)
		msg = sanitize(msg)

		mind.store_memory(msg)
//	else
//		to_chat(src, "You don't have a mind datum for some reason, so you can't add a note to it.")

/**
 * Allows you to respawn, abandoning your current mob
 *
 * This sends you back to the lobby creating a new dead mob
 *
 * Only works if flag/norespawn is allowed in config
 */

// Removed for the moment
/*
/mob/verb/abandon_mob()
	set name = "{RETURN TO LOBBY}"
	set category = "Preferences.Admin"
	set hidden = 1
	if(!check_rights(R_ADMIN))
		return
	if (CONFIG_GET(flag/norespawn))
		return
	if ((stat != DEAD || !( SSticker )))
		to_chat(usr, "<span class='boldnotice'>I must be dead to use this!</span>")
		return

	log_game("[key_name(usr)] used abandon mob.")

	to_chat(src, "<span class='info'>Returned to lobby successfully.</span>")

	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return
	client.screen.Cut()
	client.screen += client.void
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		return

	var/mob/dead/new_player/M = new /mob/dead/new_player()
	if(!client)
		log_game("[key_name(usr)] AM failed due to disconnect.")
		qdel(M)
		return

	M.key = key
//	M.Login()	//wat
	return
*/


/**
 * Sometimes helps if the user is stuck in another perspective or camera
 */
/mob/verb/cancel_camera()
	set name = "{RESET CAMERA}"
	set hidden = TRUE
	set category = null
	reset_perspective(null)
	unset_machine()

//suppress the .click/dblclick macros so people can't use them to identify the location of items or aimbot
/mob/verb/DisClick(argu = null as anything, sec = "" as text, number1 = 0 as num  , number2 = 0 as num)
	set name = ".click"
	set hidden = TRUE
	set category = null
	return

/mob/verb/DisDblClick(argu = null as anything, sec = "" as text, number1 = 0 as num  , number2 = 0 as num)
	set name = ".dblclick"
	set hidden = TRUE
	set category = null
	return
/**
 * Topic call back for any mob
 *
 * * Unset machines if "mach_close" sent
 * * refresh the inventory of machines in range if "refresh" sent
 * * handles the strip panel equip and unequip as well if "item" sent
 */
/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["refresh"])
		if(machine && in_range(src, usr))
			show_inv(machine)

	if(href_list["item"] && usr.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		var/slot = text2num(href_list["item"])
		var/hand_index = text2num(href_list["hand_index"])
		var/obj/item/what
		if(hand_index)
			what = get_item_for_held_index(hand_index)
			slot = list(slot,hand_index)
		else
			what = get_item_by_slot(slot)
		if(what)
			if(!(what.item_flags & ABSTRACT))
				usr.stripPanelUnequip(what,src,slot)
		else
			usr.stripPanelEquip(what,src,slot)

	if(usr.machine == src)
		if(Adjacent(usr))
			show_inv(usr)
		else
			usr << browse(null,"window=mob[REF(src)]")

// The src mob is trying to strip an item from someone
// Defined in living.dm
/mob/proc/stripPanelUnequip(obj/item/what, mob/who)
	return

// The src mob is trying to place an item on someone
// Defined in living.dm
/mob/proc/stripPanelEquip(obj/item/what, mob/who)
	return

/**
 * Controls if a mouse drop succeeds (return null if it doesnt)
 */
/mob/MouseDrop(mob/M)
	. = ..()
	if(M != usr)
		return
	if(usr == src)
		return
	if(!Adjacent(usr))
		return
/**
 * Handle the result of a click drag onto this mob
 *
 * For mobs this just shows the inventory
 */
/mob/MouseDrop_T(atom/dropping, atom/user)
	. = ..()
	if(ismob(dropping) && dropping != user && src == user)
		var/mob/M = dropping
		M.show_inv(user)
		return TRUE

///Is the mob muzzled (default false)
/mob/proc/is_muzzled()
	return 0


#define MOB_FACE_DIRECTION_DELAY 1

// facing verbs
/**
 * Returns true if a mob can turn to face things
 *
 * Conditions:
 * * client.last_turn > world.time
 * * not dead or unconcious
 * * not anchored
 * * no transform not set
 * * we are not restrained
 */
/mob/proc/canface(atom/A)
	if(client)
		if(world.time < client.last_turn)
			return FALSE
	if(stat == DEAD || stat == UNCONSCIOUS)
		return FALSE
	if(anchored)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		return FALSE
	if( buckled || stat != CONSCIOUS)
		return FALSE
	return TRUE

///Checks mobility move as well as parent checks
/mob/living/canface(atom/A)
	if(HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return FALSE
	if(world.time < last_dir_change + 5)
		return
	if(A && pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE) //the reason this isn't a mobility_flags check is because you want them to be able to change dir if you're passively grabbing them
		// get_cardinal_dir is inconsistent, reuse face_atom code
		var/dx = A.x - src.x
		var/dy = A.y - src.y
		var/dir
		if(!dx && !dy) // Wall items are graphically shifted but on the floor
			if(A.pixel_y > 16)
				dir = NORTH
			else if(A.pixel_y < -16)
				dir = SOUTH
			else if(A.pixel_x > 16)
				dir = EAST
			else if(A.pixel_x < -16)
				dir = WEST
		else
			if(abs(dx) < abs(dy))
				if(dy > 0)
					dir = NORTH
				else
					dir = SOUTH
			else
				if(dx > 0)
					dir = EAST
				else
					dir = WEST
		if(dir == pulledby.dir) // can never face away from the person grabbing you
			return FALSE
		for(var/obj/item/grabbing/G in grabbedby) // only chokeholds prevent turning
			if(G.chokehold)
				return FALSE
	if(IsImmobilized())
		return FALSE
	return ..()

/mob/dead/observer/canface()
	return TRUE

///Hidden verb to turn east
/mob/verb/eastface()
	set hidden = TRUE
	if(!canface(get_step(src, EAST)))
		return FALSE
	setDir(EAST)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

///Hidden verb to turn west
/mob/verb/westface()
	set hidden = TRUE
	if(!canface(get_step(src, WEST)))
		return FALSE
	setDir(WEST)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

///Hidden verb to turn north
/mob/verb/northface()
	set hidden = TRUE
	if(!canface(get_step(src, NORTH)))
		return FALSE
	setDir(NORTH)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

///Hidden verb to turn south
/mob/verb/southface()
	set hidden = TRUE
	if(!canface(get_step(src, SOUTH)))
		return FALSE
	setDir(SOUTH)
	client.last_turn = world.time + MOB_FACE_DIRECTION_DELAY
	return TRUE

#undef MOB_FACE_DIRECTION_DELAY

///This might need a rename but it should replace the can this mob use things check
/mob/proc/IsAdvancedToolUser()
	return FALSE

/mob/proc/swap_hand()
	return

/mob/proc/activate_hand(selhand)
	return

///Get the ghost of this mob (from the mind)
/mob/proc/get_ghost(even_if_they_cant_reenter, ghosts_with_clients)
	if(mind)
		return mind.get_ghost(even_if_they_cant_reenter, ghosts_with_clients)

///Force get the ghost from the mind
/mob/proc/grab_ghost(force, grab_spirit)
	if(grab_spirit)
		var/mob/living/carbon/spirit/underworld_spirit = get_spirit()
		if(underworld_spirit)
			underworld_spirit.mind?.transfer_to(src, TRUE)
			qdel(underworld_spirit)
	if(mind)
		return mind.grab_ghost(force = force)

///Notify a ghost that it's body is being cloned
/mob/proc/notify_ghost_cloning(message = "Someone is trying to revive you. Re-enter your corpse if you want to be revived!", sound = 'sound/blank.ogg', atom/source = null, flashwindow)
	var/mob/dead/observer/ghost = get_ghost()
	if(ghost)
		ghost.notify_cloning(message, sound, source, flashwindow)
		return ghost

/**
 * Checks to see if the mob can cast normal magic spells.
 *
 * args:
 * * magic_flags (optional) A bitfield with the type of magic being cast (see flags at: /datum/component/anti_magic)
**/
/mob/proc/can_cast_magic(magic_flags = MAGIC_RESISTANCE)
	if(magic_flags == NONE) // magic with the NONE flag can always be cast
		return TRUE

	var/restrict_magic_flags = SEND_SIGNAL(src, COMSIG_MOB_RESTRICT_MAGIC, magic_flags)
	return restrict_magic_flags == NONE

/**
 * Checks to see if the mob can block magic
 *
 * args:
 * * casted_magic_flags (optional) A bitfield with the types of magic resistance being checked (see flags at: /datum/component/anti_magic)
 * * charge_cost (optional) The cost of charge to block a spell that will be subtracted from the protection used
**/
/mob/proc/can_block_magic(casted_magic_flags = MAGIC_RESISTANCE, charge_cost = 1)
	if(casted_magic_flags == NONE) // magic with the NONE flag is immune to blocking
		return FALSE

	var/list/protection_was_used = list() // this is a janky way of interrupting signals using lists
	var/is_magic_blocked = SEND_SIGNAL(src, COMSIG_MOB_RECEIVE_MAGIC, casted_magic_flags, charge_cost, protection_was_used) & COMPONENT_MAGIC_BLOCKED

	if(casted_magic_flags && HAS_TRAIT(src, TRAIT_ANTIMAGIC))
		is_magic_blocked = TRUE
	if((casted_magic_flags & MAGIC_RESISTANCE_HOLY) && HAS_TRAIT(src, TRAIT_HOLY))
		is_magic_blocked = TRUE

	return is_magic_blocked


/**
 * Buckle to another mob
 *
 * You can buckle on mobs if you're next to them since most are dense
 *
 * Turns you to face the other mob too
 */
/mob/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(M.buckled)
		return 0
	var/turf/T = get_turf(src)
	if(M.loc != T)
		var/old_density = density
		density = FALSE
		var/can_step = step_towards(M, T)
		density = old_density
		if(!can_step)
			return 0
	return ..()

///Call back post buckle to a mob to offset your visual height
/mob/post_buckle_mob(mob/living/M)
	var/height = M.get_mob_buckling_height(src)
	M.pixel_y = M.base_pixel_y + height
	if(M.layer < layer)
		M.layer = layer + 0.1
///Call back post unbuckle from a mob, (reset your visual height here)
/mob/post_unbuckle_mob(mob/living/M)
	M.layer = initial(M.layer)
	M.pixel_y = M.base_pixel_y

///returns the height in pixel the mob should have when buckled to another mob.
/mob/proc/get_mob_buckling_height(mob/seat)
	if(isliving(seat))
		var/mob/living/L = seat
		if(L.mob_size <= MOB_SIZE_SMALL) //being on top of a small mob doesn't put you very high.
			return 0
	return 9

///can the mob be buckled to something by default?
/mob/proc/can_buckle()
	return 1

///can the mob be unbuckled from something by default?
/mob/proc/can_unbuckle()
	return 1

///Can the mob interact() with an atom?
/mob/proc/can_interact_with(atom/A)
	return IsAdminGhost(src) || Adjacent(A)

/**
 * Checks whether a mob can perform an action to interact with an object
 *
 * The default behavior checks if the mob is:
 * * Directly adjacent (1-tile radius)
 * * Standing up (not resting)
 * * Allows telekinesis to be used to skip adjacent checks (if they have DNA mutation)
 * *
 * action_bitflags: (see code/__DEFINES/mobs.dm)
 * * NEED_LITERACY - If reading is required to perform action (can't read a book if you are illiterate)
 * * NEED_LIGHT - If lighting must be present to perform action (can't heal someone in the dark)
 * * NEED_DEXTERITY - If other mobs (monkeys, aliens, etc) can perform action (can't use computers if you are a monkey)
 * * NEED_HANDS - If hands are required to perform action (can't pickup items if you are a cyborg)
 * * FORBID_TELEKINESIS_REACH - If telekinesis is forbidden to perform action from a distance (ex. canisters are blacklisted from telekinesis manipulation)
 * * ALLOW_RESTING - If resting on the floor is allowed to perform action ()
**/
/mob/proc/can_perform_action(atom/movable/target, action_bitflags)
	return

///Can this mob use storage
/mob/proc/canUseStorage()
	return FALSE
/**
 * Check if the other mob has any factions the same as us
 *
 * If exact match is set, then all our factions must match exactly
 */
/atom/movable/proc/faction_check_mob(mob/target, exact_match)

/mob/faction_check_mob(mob/target, exact_match)
	if(exact_match) //if we need an exact match, we need to do some bullfuckery.
		var/list/faction_src = faction.Copy()
		var/list/faction_target = target.faction.Copy()
		if(!("[REF(src)]" in faction_target)) //if they don't have our ref faction, remove it from our factions list.
			faction_src -= "[REF(src)]" //if we don't do this, we'll never have an exact match.
		if(!("[REF(target)]" in faction_src))
			faction_target -= "[REF(target)]" //same thing here.
		return faction_check(faction_src, faction_target, TRUE)
	var/list/faction2use = target.faction.Copy()
	faction2use += target.name
	return faction_check(faction, faction2use, FALSE)
/*
 * Compare two lists of factions, returning true if any match
 *
 * If exact match is passed through we only return true if both faction lists match equally
 */
/proc/faction_check(list/faction_A, list/faction_B, exact_match)
	var/list/match_list
	if(exact_match)
		match_list = faction_A&faction_B //only items in both lists
		var/length = LAZYLEN(match_list)
		if(length)
			return (length == LAZYLEN(faction_A)) //if they're not the same len(gth) or we don't have a len, then this isn't an exact match.
	else
		match_list = faction_A&faction_B
		return LAZYLEN(match_list)
	return FALSE


/**
 * Fully update the name of a mob
 *
 * This will update a mob's name, real_name, mind.name, GLOB.data_core records, pda, id and traitor text
 *
 * Calling this proc without an oldname will only update the mob and skip updating the pda, id and records ~Carn
 */
/mob/proc/fully_replace_character_name(oldname, newname)
	log_message("[src] name changed from [oldname] to [newname]", LOG_OWNERSHIP)
	if(!newname)
		return FALSE

	log_played_names(ckey,newname)

	GLOB.chosen_names += newname
	real_name = newname
	name = newname
	if(mind)
		mind.name = newname
		if(mind.key)
			log_played_names(mind.key,newname) //Just in case the mind is unsynced at the moment.

	GLOB.character_ckey_list[real_name] = ckey

	if(oldname)
		GLOB.chosen_names -= oldname
		//update the datacore records! This is going to be a bit costly.
		replace_records_name(oldname,newname)
		if(GLOB.character_ckey_list[oldname])
			GLOB.character_ckey_list -= oldname

		for(var/datum/mind/T in SSticker.minds)
			for(var/datum/objective/obj in T.get_all_objectives())
				// Only update if this player is a target
				if(obj.target?.current?.real_name == name)
					obj.update_explanation_text()
	return TRUE

///Updates GLOB.data_core records with new name , see mob/living/carbon/human
/mob/proc/replace_records_name(oldname,newname)
	return

/mob/proc/update_stat()
	return

/mob/proc/update_health_hud()
	return

/mob/proc/update_tod_hud()
	return

/mob/proc/update_spd()
	return

///Update the lighting plane and sight of this mob (sends COMSIG_MOB_UPDATE_SIGHT)
/mob/proc/update_sight()
	SEND_SIGNAL(src, COMSIG_MOB_UPDATE_SIGHT)
	sync_lighting_plane_alpha()

///Set the lighting plane hud alpha to the mobs lighting_alpha var
/mob/proc/sync_lighting_plane_alpha()
	if(hud_used)
		var/atom/movable/screen/plane_master/lighting/L = hud_used.plane_masters["[LIGHTING_PLANE]"]
		if (L)
			L.alpha = lighting_alpha

///Update the mouse pointer of the attached client in this mob
/mob/proc/update_mouse_pointer()
	if(!client)
		return
	if(client.mouse_pointer_icon != initial(client.mouse_pointer_icon))//only send changes to the client if theyre needed
		client.mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'
	if(!client.charging && !atkswinging)
		if(examine_cursor_icon && client.keys_held["Shift"]) //mouse shit is hardcoded, make this non hard-coded once we make mouse modifiers bindable
			client.mouse_pointer_icon = examine_cursor_icon
	if(client.mouse_override_icon)
		client.mouse_pointer_icon = client.mouse_override_icon

/**
 * Can this mob see in the dark
 *
 * This checks all traits, glasses, and robotic eyeball implants to see if the mob can see in the dark
 * this does NOT check if the mob is missing it's eyeballs. Also see_in_dark is a BYOND mob var (that defaults to 2)
**/
/mob/proc/has_nightvision()
	return see_in_dark >= 6

///This mob is abile to read books
/mob/proc/is_literate()
	return FALSE

/**
 * Checks if there is enough light where the mob is located
 *
 * Args:
 *  light_amount (optional) - A decimal amount between 1.0 through 0.0 (default is 0.2)
**/
/mob/proc/has_light_nearby(light_amount = LIGHTING_TILE_IS_DARK)
	var/turf/mob_location = get_turf(src)
	var/area/mob_area = get_area(src)

	if(mob_location?.get_lumcount() > light_amount)
		return TRUE
	else if(mob_area?.dynamic_lighting == DYNAMIC_LIGHTING_DISABLED)
		return TRUE

	return FALSE

///Can this mob read (is literate and not blind)
/mob/proc/can_read(obj/O, silent = FALSE)
	if(isobserver(src))
		return TRUE
	if(is_blind() || has_status_effect(/datum/status_effect/eye_blur))
		if(!silent)
			to_chat(src, span_warning("I'm too blind to read."))
		return
	if(!is_literate())
		if(!silent)
			to_chat(src, span_warning("I can't make sense of these verbs."))
		return
	return TRUE

///Can this mob hold items
/mob/proc/can_hold_items()
	return length(held_items)

///Get the id card on this mob
/mob/proc/get_idcard(hand_first)
	return

/mob/proc/get_id_in_hand()
	return

/**
 * Get the mob VV dropdown extras
 */
/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_GIB, "Gib")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_SPELL, "Give Spell")
	VV_DROPDOWN_OPTION(VV_HK_REMOVE_SPELL, "Remove Spell")
	VV_DROPDOWN_OPTION(VV_HK_GODMODE, "Toggle Godmode")
	VV_DROPDOWN_OPTION(VV_HK_DROP_ALL, "Drop Everything")
	VV_DROPDOWN_OPTION(VV_HK_REGEN_ICONS, "Regenerate Icons")
	VV_DROPDOWN_OPTION(VV_HK_PLAYER_PANEL, "Show player panel")
	VV_DROPDOWN_OPTION(VV_HK_DIRECT_CONTROL, "Assume Direct Control")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_CONTROL_TO_PLAYER, "Give Control To Player")
	VV_DROPDOWN_OPTION(VV_HK_OFFER_GHOSTS, "Offer Control to Ghosts")

/mob/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_REGEN_ICONS])
		if(!check_rights(NONE))
			return
		regenerate_icons()
	if(href_list[VV_HK_PLAYER_PANEL])
		if(!check_rights(NONE))
			return
		usr.client.holder.show_player_panel(src)
	if(href_list[VV_HK_GODMODE])
		if(!check_rights(R_ADMIN,0))
			return
		usr.client.cmd_admin_godmode(src)
	if(href_list[VV_HK_GIVE_SPELL])
		if(!check_rights(NONE))
			return
		usr.client.give_spell(src)
	if(href_list[VV_HK_REMOVE_SPELL])
		if(!check_rights(NONE))
			return
		usr.client.remove_spell(src)
	if(href_list[VV_HK_GIB])
		if(!check_rights(R_FUN))
			return
		usr.client.cmd_admin_gib(src)
	if(href_list[VV_HK_DROP_ALL])
		if(!check_rights(NONE))
			return
		usr.client.cmd_admin_drop_everything(src)
	if(href_list[VV_HK_DIRECT_CONTROL])
		if(!check_rights(NONE))
			return
		usr.client.cmd_assume_direct_control(src)
	if(href_list[VV_HK_GIVE_CONTROL_TO_PLAYER])
		if(!check_rights(NONE))
			return
		usr.client.cmd_give_control_to_player(src, input(usr, "Choose player.", "Player:") as anything in GLOB.clients)
	if(href_list[VV_HK_OFFER_GHOSTS])
		if(!check_rights(NONE))
			return
		offer_control(src)

/**
 * extra var handling for the logging var
 */
/mob/vv_get_var(var_name)
	switch(var_name)
		if("logging")
			return debug_variable(var_name, logging, 0, src, FALSE)
	. = ..()

/mob/vv_auto_rename(new_name)
	//Do not do parent's actions, as we *usually* do this differently.
	fully_replace_character_name(real_name, new_name)

///Show the language menu for this mob
/mob/verb/open_language_menu()
	set name = "Open Language Menu"
	set category = "IC"
	set hidden = 1

	var/datum/language_holder/H = get_language_holder()
	H.open_language_menu(usr)

///Adjust the nutrition of a mob
/mob/proc/adjust_nutrition(change) //Honestly FUCK the oldcoders for putting nutrition on /mob someone else can move it up because holy hell I'd have to fix SO many typechecks
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		nutrition = NUTRITION_LEVEL_FULL
	nutrition = max(0, nutrition + change)
	if(nutrition > NUTRITION_LEVEL_FULL)
		nutrition = NUTRITION_LEVEL_FULL

///Force set the mob nutrition
/mob/proc/set_nutrition(change) //Seriously fuck you oldcoders.
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		nutrition = NUTRITION_LEVEL_FULL
	nutrition = max(0, change)
	if(nutrition > NUTRITION_LEVEL_FULL)
		nutrition = NUTRITION_LEVEL_FULL

/mob/proc/adjust_hydration(change)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		hydration = HYDRATION_LEVEL_FULL
	hydration = max(0, hydration + change)
	if(hydration > HYDRATION_LEVEL_FULL)
		hydration = HYDRATION_LEVEL_FULL

/mob/proc/set_hydration(change)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		hydration = HYDRATION_LEVEL_FULL
	hydration = max(0, change)
	if(hydration > HYDRATION_LEVEL_FULL)
		hydration = HYDRATION_LEVEL_FULL

/mob/proc/update_equipment_speed_mods()
	var/speedies = equipped_speed_mods()
	if(!speedies)
		remove_movespeed_modifier(MOVESPEED_ID_MOB_EQUIPMENT, update=TRUE)
	else
		add_movespeed_modifier(MOVESPEED_ID_MOB_EQUIPMENT, update=TRUE, priority=100, override=TRUE, multiplicative_slowdown=speedies, blacklisted_movetypes=FLOATING)

/// Gets the combined speed modification of all worn items
/// Except base mob type doesnt really wear items
/mob/proc/equipped_speed_mods()
	for(var/obj/item/I in held_items)
		if(I.item_flags & SLOWS_WHILE_IN_HAND)
			. += I.slowdown

/mob/proc/set_stat(new_stat)
	if(new_stat == stat)
		return
	. = stat
	stat = new_stat
	SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, new_stat, .)

/mob/say_mod(input, list/message_mods = list())
	var/customsayverb = findtext(input, "*")
	if(customsayverb)
		return lowertext(copytext(input, 1, customsayverb))
	. = ..()

/atom/movable/proc/attach_spans(input, list/spans)
	var/customsayverb = findtext(input, "*")
	if(customsayverb)
		input = capitalize(copytext(input, customsayverb+1))
	return "[message_spans_start(spans)][input]</span>"

/mob/living/proc/can_smell()
	if(HAS_TRAIT(src, TRAIT_MISSING_NOSE))
		return FALSE
	return TRUE

/// Send a menu that allows for the selection of an item. Randomly selects one after time_limit. selection_list should be an associative list of string and typepath
/mob/living/proc/select_equippable(user_client, list/selection_list, time_limit = 20 SECONDS, message = "", title = "")
	if(!LAZYLEN(selection_list))
		return

	var/to_send = user_client ? user_client : src

	var/choice = browser_input_list(to_send, message, title, selection_list, timeout = time_limit)
	if(QDELETED(src))
		return

	if(!choice)
		choice = pick(selection_list)

	var/spawn_items = LAZYACCESS(selection_list, choice)
	if(isnull(spawn_items))
		return

	if(!islist(spawn_items))
		spawn_items = list(spawn_items)
	if(!length(spawn_items))
		return choice

	for(var/obj/item/spawn_item as anything in spawn_items)
		equip_to_appropriate_slot(new spawn_item(), TRUE)

	return choice

/mob/proc/nobles_seen_servant_work()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!is_servant_job(H.mind.assigned_role))
			return
	else
		return

	var/list/nobles = list()
	for(var/mob/living/carbon/human/target as anything in viewers(6, src))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(!HAS_TRAIT(target, TRAIT_NOBLE))
			continue
		nobles += target
	if(length(nobles))
		for(var/mob/living/carbon/human/target as anything in nobles)
			if(!target.has_stress_type(/datum/stress_event/noble_seen_servant_work))
				target.add_stress(/datum/stress_event/noble_seen_servant_work)

/// Adds this list to the output to the stat browser
/mob/proc/get_status_tab_items()
	. = list("") //we want to offset unique stuff from standard stuff
	SEND_SIGNAL(src, COMSIG_MOB_GET_STATUS_TAB_ITEMS, .)
	return .
