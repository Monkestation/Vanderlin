/datum/class_select_handler
	var/client/linked_client //the ss will link it!

	/**
	 *	This list is organized like so
	 *	class_cat_alloc_attempts = list(CTAG_PILGRIM = 5, CTAG_ADVENTURER = 3, etc)
	 *	Wherein you will have this datum attempt to roll you up 5 pilgrim category classes, and 3 adventurer class categories
	 *	This only counts towards non rare classes with roll_chance of 100 and classes with bypass_class_cat_limits = FALSE.
	 */
	var/list/class_cat_alloc_attempts

	/// Whether we bypass reqs on class cat alloc attempts
	var/class_cat_alloc_bypass_reqs = FALSE

	/**
	 *	This list is organized exactly like the class_cat_alloc_attempts the numbers dictate how many plusboosts we give to the category
	 *	class_cat_alloc_attempts = list(CTAG_PILGRIM = 3, CTAG_ADVENTURER = 2, etc)
	 *	If you put a number in, it will attempt to allocate it to the cat
	 */
	var/list/class_cat_plusboost_attempts

	/**
	 *	This list is organized like so
	 *	forced_class_additions = list(datum/job/advclass/filled_class)
	 *	Wherein the class will just be forced onto the list to be displayed
	 */
	var/list/forced_class_additions

	/// Whether we bypass reqs on these forced classes
	var/forced_class_bypass_reqs = TRUE

	/// If this has a number above 0 we will plusboost this many guys
	var/forced_class_plusboost = 0

	// Working Vars - aka we are using these to just do work

	/// Special session queue classes - aka a connector to the special_session_queue
	var/list/special_session_queue

	/// Local cache of sorted shit
	var/list/local_total_sorted_class_cache = list()

	/// Current class we lookin at
	var/datum/job/advclass/cur_picked_class

	/// If this is set to true we don't run some other menu updating shit in the off-chance we max out our stupid shit
	var/special_selected = FALSE

	/// If this is set to true we display all the challenge classes
	var/showing_combat_classes = FALSE

	/// classes we rolled, basically you get a datum followed by a number in here on how many times you rerolled it.
	var/list/rolled_classes = list()

/datum/class_select_handler/Destroy()
	if(linked_client)
		ForceCloseMenus()
		SSrole_class_handler.class_select_handlers -= linked_client.ckey
	linked_client = null
	cur_picked_class = null
	class_cat_alloc_attempts = null
	forced_class_additions = null
	return ..()

// The normal route for first use of this list.
/datum/class_select_handler/proc/initial_setup()
	assemble_the_CLASSES()
	second_step()

// The second step, aka we just want to make sure the resources are there and that the menu is being displayed
/datum/class_select_handler/proc/second_step()
	var/datum/asset/thicc_assets = get_asset_datum(/datum/asset/simple/stonekeep_class_menu_slop_layout)
	thicc_assets.send(linked_client)

	browser_slop()

// I hope to god you have a client before you call this, cause the checks on the SS
/datum/class_select_handler/proc/assemble_the_CLASSES()
	var/mob/living/carbon/human/human_mob = linked_client.mob

	//Pick any class override
	if(SSrole_class_handler.special_session_queue && SSrole_class_handler.special_session_queue[human_mob.ckey])
		var/list/player_queue = SSrole_class_handler.special_session_queue[human_mob.ckey]
		if(TRIUMPH_BUY_ANY_CLASS in player_queue)
			var/datum/job/advclass/pick_everything/picker = player_queue[TRIUMPH_BUY_ANY_CLASS]

			rolled_classes = list(picker = 0)
			local_total_sorted_class_cache = list(CTAG_ALLCLASS = list(picker))
			showing_combat_classes = FALSE

			browser_slop()
			return

	// Time to sort and find our viable classes depending on what conditions we gotta deal w
	if(length(class_cat_alloc_attempts))
		for(var/SORT_CAT_KEY in class_cat_alloc_attempts)
			var/list/subsystem_ctag_list = SSrole_class_handler.sorted_class_categories[SORT_CAT_KEY]
			var/list/local_insert_sortlist = list()
			var/list/local_bypass_limit_insert_sortlist = list() // This is not affected by the class_cat_alloc_attempts
			var/list/local_total_insert_sortlist = list()

			for(var/datum/job/advclass/CUR_AZZ in subsystem_ctag_list)
				if(rolled_classes[CUR_AZZ])
					continue
				if(is_advclass_banned(human_mob.ckey, CUR_AZZ.title))
					continue
				if(class_cat_alloc_bypass_reqs || CUR_AZZ.check_requirements(human_mob))
					local_total_insert_sortlist += CUR_AZZ
					if(CUR_AZZ.roll_chance < 100 || CUR_AZZ.bypass_class_cat_limits)
						local_bypass_limit_insert_sortlist += CUR_AZZ
					else
						local_insert_sortlist += CUR_AZZ

			// Time to do some picking, make sure we got things in the list we dealin with
			if(length(local_total_insert_sortlist))
				// Make sure we aren't going to attempt to pick more than what we even have avail
				var/job_rolls = min(class_cat_alloc_attempts[SORT_CAT_KEY], length(local_insert_sortlist))

				var/bypass_limit_rolls = length(local_bypass_limit_insert_sortlist)

				local_insert_sortlist = shuffle(local_insert_sortlist) // Shuffles to prevent the same classes every time
				for(var/i in 1 to job_rolls)
					rolled_classes[local_insert_sortlist[i]] = 0

				if(bypass_limit_rolls)
					for(var/i in 1 to bypass_limit_rolls)
						rolled_classes[local_bypass_limit_insert_sortlist[i]] = 0

				// We are plusboosting too
				if(class_cat_plusboost_attempts && (SORT_CAT_KEY in class_cat_plusboost_attempts))
					if(class_cat_plusboost_attempts[SORT_CAT_KEY])
						for(var/i in 1 to class_cat_plusboost_attempts[SORT_CAT_KEY])
							var/datum/job/advclass/boostclass = pick(local_total_insert_sortlist)
							if(boostclass in rolled_classes)
								rolled_classes[boostclass] += 1

				local_total_sorted_class_cache[SORT_CAT_KEY] = local_total_insert_sortlist

	// If we got forced class additions
	if(length(forced_class_additions))
		for(var/uninstanced_azz_types in forced_class_additions)
			var/datum/job/advclass/forced_class = SSjob.GetJobType(uninstanced_azz_types)
			if(rolled_classes[forced_class])
				continue
			if(class_cat_alloc_bypass_reqs || forced_class.check_requirements(human_mob))
				rolled_classes[forced_class] = 0

		if(forced_class_plusboost)
			for(var/i in 1 to forced_class_plusboost)
				var/datum/job/advclass/boostclass = pick(rolled_classes)
				if(boostclass.type in forced_class_additions)
					rolled_classes[boostclass] += 1

	if(!length(rolled_classes))
		linked_client.mob.returntolobby()
		message_admins("[linked_client.ckey] had 0 classes to select options, returned them to lobby. Please ask what class they were rolling and tell coders.")

// Something is calling to tell this datum a class it rolled is currently maxed out.
// More shitcode!
/datum/class_select_handler/proc/rolled_class_is_full(datum/job/advclass/filled_class)
	// Fun fact, if you don't remove the class that is maxed they just get new choices infinitely
	// Also all the checks are done causing this to be called anyways
	rolled_classes -= filled_class

	var/list/possible_list = list()
	for(var/CTAG_CAT in filled_class.category_tags)
		for(var/datum/job/advclass/new_age_datum in local_total_sorted_class_cache[CTAG_CAT])
			if(new_age_datum in rolled_classes)
				continue
			if(new_age_datum in possible_list) // In the offchance we got the datum in two cats, we don't want to cuck them by doubling up the chance to get it
				continue
			possible_list += new_age_datum

	if(possible_list.len)
		rolled_classes[pick(possible_list)] = 0

	if(cur_picked_class == filled_class)
		if(special_session_queue && (cur_picked_class in special_session_queue))
			special_selected = FALSE
		cur_picked_class = null

		if(linked_client) // In the current state we will still auto-adjust cached datums with no linked client
			linked_client << browse(null, "window=class_select_yea")

	if(linked_client) // So make sure we don't go further than this without one I guess
		browser_slop()

/datum/class_select_handler/proc/browser_slop()
	if(!linked_client)
		return
	SSassets.transport.send_assets(linked_client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	//Opening tags and empty head
	var/data = {"
	<!DOCTYPE html>
	<html lang='en'>
	<head>
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Tangerine:wght@400;700&display=swap');
			@import url('https://fonts.googleapis.com/css2?family=UnifrakturMaguntia&display=swap');
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('[SSassets.transport.get_asset_url("try4.png")]');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
		</style>
		<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url("slop_menustyle2.css")]'>
	</head>
	<body>
		<div id='top_handwriting'> The stars align... </div>
		<div id='class_select_box_div'>
	"}

	var/mob/living/carbon/human/H = linked_client.mob
	if(!H.job)
		return

	if(!showing_combat_classes)
		for(var/datum/job/advclass/datums in rolled_classes)
			var/plus_str = ""
			data += {"
			<div class='class_bar_div'>
				<a class='vagrant' href='byond://?src=\ref[src];class_selected=1;selected_class=\ref[datums];'>
					<img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32>
					[datums.title]
					<span id='green_plussa'>[plus_str]</span>
					<img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32>
				</a>
			</div>
	"}

	if(special_session_queue && special_session_queue.len)
		for(var/datum/job/advclass/datums in special_session_queue)
			data += {"
			<div class='class_bar_div'>
				<a class='vagrant' href='byond://?src=\ref[src];special_selected=1;selected_special=\ref[datums];'>
					<img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32>
					[datums.title]
					<img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32>
				</a>
			</div>
	"}

	if(showing_combat_classes)
		for(var/datum/job/advclass/datums in rolled_classes)
			if(!(CTAG_PILGRIM in datums.category_tags))
				continue
			var/plus_str = ""
			data += {"
			<div class='class_bar_div'>
				<a class='vagrant' href='byond://?src=\ref[src];class_selected=1;selected_class=\ref[datums];'>
					<img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32>
					[datums.title]
					<span id='green_plussa'>[plus_str]</span>
					<img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32>
				</a>
			</div>
	"}

	data += {"
		</div> <!-- end of class_select_box_div -->
	</body>
	</html>
	"}


	linked_client << browse(data, "window=class_handler_main;size=330x430;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0;border=0")

/datum/class_select_handler/proc/class_select_slop()
	SSassets.transport.send_assets(linked_client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	var/data = {"
	<!DOCTYPE html> <!-- Add doctype to ensure proper rendering -->
	<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta title="viewport" content="width=device-width, initial-scale=1.0">
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Tangerine:wght@400;700&display=swap');
			@import url('https://fonts.googleapis.com/css2?family=UnifrakturMaguntia&display=swap');
			@import url('https://fonts.googleapis.com/css2?family=Charm&display=swap');
			body {
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('[SSassets.transport.get_asset_url("try4.png")]');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
		</style>
		<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url("slop_menustyle2.css")]'>
	</head>
	<body>
		<div id="button_div">
			<span class="title_shit">Class Name:</span>
			<span class="post_title_shit">[cur_picked_class.title]</span><br>
			<span class="title_shit">Description:</span>
			<span class="post_title_shit">[cur_picked_class.tutorial]</span>
		</div>

		<div id='button_div'>
			<a class='class_desc_YES_LINK' href='byond://?src=\ref[src];yes_to_class_select=1;special_class=0;'>This is my background</a><br>
			<a class='bottom_buttons' href='byond://?src=\ref[src];no_to_class_select=1'>I reject this background</a>
		</div>
	</body>
	</html>

	"}

	linked_client << browse(data, "window=class_select_yea;size=610x300;can_close=0;can_minimize=0;can_maximize=0;can_resize=0;titlebar=0;border=0")

/datum/class_select_handler/Topic(href, href_list)
	. = ..()
	if(href_list["class_selected"])
		var/selected_class = href_list["selected_class"]
		var/locvar_check = locate(selected_class)

		// shiiiiiiiiiiiiiiiiet
		if(locvar_check in SSrole_class_handler.sorted_class_categories[CTAG_CHALLENGE])
			cur_picked_class = locvar_check
			class_select_slop()
			return

		// Safety check. Make sure the thing that got rammed into the href is actually in the rolled list
		// Unless its a challenge class then everyone can jus see it via a click of the button anyways
		if(locvar_check in rolled_classes)
			cur_picked_class = locvar_check
			class_select_slop()
		return

	if(href_list["yes_to_class_select"]) // Send the data over and wrap it up.
		SSrole_class_handler.finish_class_handler(linked_client.mob, cur_picked_class, src, special_selected)
		return

	if(href_list["no_to_class_select"]) // Close the selector window
		cur_picked_class = null
		linked_client << browse(null, "window=class_select_yea")
		return

	if(href_list["special_selected"])
		var/special_class = href_list["selected_special"]
		var/locvar_check = locate(special_class)

		if(locvar_check in special_session_queue)
			cur_picked_class = locvar_check
			special_selected = TRUE
			class_select_slop()
		return

	if(href_list["show_combat_class"])
		showing_combat_classes = !showing_combat_classes
		browser_slop()
		return

/datum/class_select_handler/proc/ForceCloseMenus()
	if(linked_client)
		linked_client << browse(null, "window=class_handler_main")
		linked_client << browse(null, "window=class_select_yea")
