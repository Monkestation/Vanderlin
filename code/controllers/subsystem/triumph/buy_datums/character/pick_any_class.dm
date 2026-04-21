/datum/triumph_buy/pick_any_class
	name = "No Advanced Class Restrictions"
	desc = "Get a single run of any advanced class from any job! You must join as any job that has advanced classes to begin with. WARNING: THIS CAN EASILY BREAK AND ADMINS ARE NOT OBLIGED TO FIX YOUR CHARACTER."
	triumph_buy_id = TRIUMPH_BUY_ANY_CLASS
	triumph_cost = 20
	category = TRIUMPH_CAT_CHARACTER
	visible_on_active_menu = TRUE
	manual_activation = TRUE
	allow_multiple_buys = FALSE

/datum/job/advclass/pick_everything
	title = "Triumph Classes"
	tutorial = "This will open up another menu when you spawn allowing you to pick from any class as long as it's not disabled."
	allowed_races = ALL_RACES_LIST
	total_positions = -1
	var/list/invalid_ctags = list(
		CTAG_WRETCH,
		CTAG_INQUISITION,
		CTAG_PURITAN,
		CTAG_ARCHIVIST,
		CTAG_BANDIT,
		CTAG_HAND,
		CTAG_HEIR,
		CTAG_CONSORT,
		CTAG_TOWN_ELDER,
		CTAG_ROYALKNIGHT,
	)

/datum/job/advclass/pick_everything/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/list/possible_classes = list()
	for(var/datum/job/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
		if(!length(CHECKS.category_tags))
			continue
		if(length(invalid_ctags & CHECKS.category_tags) && !length(parent_job?.advclass_cat_rolls & CHECKS.category_tags))
			continue
		if(!CHECKS.check_requirements(spawned))
			continue
		possible_classes += CHECKS

	if(!length(possible_classes))
		spawned.returntolobby()
		message_admins("[player_client?.ckey] had 0 advanced class selections in the All-Class Triumph buy. They were returned to the lobby.")
		to_chat(player_client, span_danger("You had 0 advanced class selections for some reason. Admins were informed. This is likely a bug."))
		return

	var/list/class_titles = list()
	for(var/datum/job/advclass/C in possible_classes)
		class_titles[C.title] = C

	var/chosen_title = tgui_input_list(spawned, "What is my class?", "Adventure", class_titles)
	if(!chosen_title)
		chosen_title = pick(class_titles)
	var/datum/job/advclass/class = class_titles[chosen_title]

	SSjob.EquipRank(spawned, class, player_client)
