/datum/triumph_buy/pick_any_class
	name = "Random Advanced Class Options"
	desc = "Get a single run of 4 random advanced classes from any job! You must join as any job that has advanced classes to begin with. WARNING: THIS CAN EASILY BREAK AND ADMINS ARE NOT OBLIGED TO FIX YOUR CHARACTER."
	triumph_buy_id = TRIUMPH_BUY_ANY_CLASS
	triumph_cost = 20
	category = TRIUMPH_CAT_CHARACTER
	visible_on_active_menu = TRUE
	manual_activation = TRUE
	allow_multiple_buys = FALSE

/datum/triumph_buy/pick_any_class/on_buy()
	. = ..()

	//if(!SSrole_class_handler.special_session_queue[ckey_of_buyer])
	//	SSrole_class_handler.special_session_queue[ckey_of_buyer] = list()
	//
	//var/datum/job/advclass/pick_everything/turbo_slop
	//if(!SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id])
	//	turbo_slop = new()
	//	turbo_slop.total_positions = 1
	//	SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id] = turbo_slop
	//else
	//	turbo_slop = SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id]
	//	turbo_slop.total_positions += 1

///datum/triumph_buy/pick_any_class/on_removal()
//	. = ..()
//	if(SSrole_class_handler.special_session_queue[ckey_of_buyer])
//		SSrole_class_handler.special_session_queue[ckey_of_buyer].Remove(triumph_buy_id)

/datum/triumph_buy/pick_any_class/all_classes
	name = "No Advanced Class Restrictions"
	desc = "Get a single run of any advanced class from ANY job! You must join as any job that has advanced classes to begin with. WARNING: THIS CAN EASILY BREAK AND ADMINS ARE NOT OBLIGED TO FIX YOUR CHARACTER."
	triumph_buy_id = TRIUMPH_BUY_ANY_CLASS_ALL
	triumph_cost = 60
	conflicts_with = list(/datum/triumph_buy/pick_any_class)

/datum/job/advclass/pick_everything
	title = "Random Classes"
	tutorial = "This will open up another menu when you spawn allowing you to pick from any class as long as it's not disabled."
	allowed_races = ALL_RACES_LIST
	var/all_classes = FALSE
	var/associated_triumph_buy = TRIUMPH_BUY_ANY_CLASS
	inherit_parent_title = TRUE

/datum/job/advclass/pick_everything/all
	title = "All Classes"
	tutorial = "This will open up another menu when you spawn allowing you to pick from any class as long as it's not disabled."
	all_classes = TRUE
	associated_triumph_buy = TRIUMPH_BUY_ANY_CLASS_ALL

/datum/job/advclass/pick_everything/greet(mob/player)
	return

/datum/job/advclass/pick_everything/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/list/possible_classes = shuffle(LAZYCOPY(SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS]))
	var/list/chosen_classes = list()
	var/max_choices = all_classes ? possible_classes.len : 4
	var/i = 0
	while(chosen_classes.len < max_choices && i < possible_classes.len)
		i++
		var/datum/job/advclass/class_check = possible_classes[i]
		if(!length(class_check.category_tags))
			continue
		if(class_check.total_positions == 0)
			continue
		if(class_check.antag_role || class_check.parent_job?.antag_role)
			continue
		if(!length(class_check.category_tags & ANY_CLASS_CTAGS))
			continue
		if(!prob(roll_chance))
			continue
		if(!class_check.check_requirements(spawned, TRUE))
			continue
		chosen_classes[class_check.title] = class_check

	if(!length(chosen_classes))
		spawned.returntolobby()
		message_admins("[player_client?.ckey] had 0 advanced class selections in the All-Class Triumph buy. They were returned to the lobby.")
		to_chat(player_client, span_danger("You had 0 advanced class selections for some reason. Admins were informed. This is likely a bug."))
		return

	var/chosen_title = browser_input_list(spawned, "What is my class?", "Adventure", chosen_classes, timeout = 45 SECONDS)
	var/datum/job/advclass/class = chosen_classes[chosen_title] || pick_assoc(chosen_classes)
	SSjob.EquipRank(spawned, class, player_client)
