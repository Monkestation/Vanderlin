/datum/triumph_buy/pick_any_class
	name = "No Advanced Class Restrictions"
	desc = "Get a single run of any advanced class from any job! You must join as any job that has advanced classes to begin with. WARNING: THIS CAN EASILY BREAK AND ADMINS ARE NOT OBLIGED TO FIX YOUR CHARACTER."
	triumph_buy_id = TRIUMPH_BUY_ANY_CLASS
	triumph_cost = 20
	category = TRIUMPH_CAT_CHARACTER
	visible_on_active_menu = TRUE
	manual_activation = TRUE

/datum/triumph_buy/pick_any_class/on_buy()
	. = ..()

	if(!SSrole_class_handler.special_session_queue[ckey_of_buyer])
		SSrole_class_handler.special_session_queue[ckey_of_buyer] = list()

	var/datum/job/advclass/pick_everything/turbo_slop
	if(!SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id])
		turbo_slop = new()
		turbo_slop.total_positions = 1
		SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id] = turbo_slop
	else
		turbo_slop = SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id]
		turbo_slop.total_positions += 1

/datum/triumph_buy/pick_any_class/on_removal()
	. = ..()
	if(SSrole_class_handler.special_session_queue[ckey_of_buyer])
		SSrole_class_handler.special_session_queue[ckey_of_buyer].Remove(triumph_buy_id)

/datum/job/advclass/pick_everything
	title = "Pick-Classes"
	tutorial = "This will open up another menu when you spawn allowing you to pick from any class as long as it's not disabled."
	allowed_races = ALL_RACES_LIST
	total_positions = 0

/datum/job/advclass/pick_everything/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/list/possible_classes = list()
	for(var/datum/job/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
		if(!length(CHECKS.category_tags))
			continue
		if(CTAG_WRETCH in CHECKS.category_tags)
			continue
		if(CTAG_INQUISITION in CHECKS.category_tags)
			continue
		if(CTAG_PURITAN in CHECKS.category_tags)
			continue
		possible_classes += CHECKS

	var/list/class_titles = list()
	for(var/datum/job/advclass/C in possible_classes)
		class_titles += C.title

	var/chosen_title = browser_input_list(spawned, "What is my class?", "Adventure", class_titles)

	var/datum/job/advclass/class
	if(chosen_title)
		for(var/datum/job/advclass/C in possible_classes)
			if(C.title == chosen_title)
				class = C
				break
	else
		class = pick(possible_classes)

	SSjob.EquipRank(spawned, class, player_client)
	SSrole_class_handler.special_session_queue[spawned.ckey].Remove(TRIUMPH_BUY_ANY_CLASS)
