#define VAMPCOST_ONE 5000
#define VAMPCOST_TWO 6000
#define VAMPCOST_THREE 7500
#define VAMPCOST_FOUR 10000

/obj/structure/vampire/bloodpool
	name = "Crimson Crucible"
	icon_state = "vat"
	var/maximum = 8000
	var/current = 8000
	var/datum/clan/owner_clan

	var/list/active_projects = list()
	var/list/available_project_types = list(
		/datum/vampire_project/power_growth,
		/datum/vampire_project/amulet_crafting,
		/datum/vampire_project/armor_crafting
	)

/obj/structure/vampire/bloodpool/Initialize()
	. = ..()
	set_light(3, 3, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)

/obj/structure/vampire/bloodpool/examine(mob/user)
	. = ..()
	to_chat(user, span_boldnotice("Blood level: [current]"))

	// Show active projects
	if(active_projects.len)
		to_chat(user, span_notice("Active Projects:"))
		for(var/project_key in active_projects)
			var/datum/vampire_project/project = active_projects[project_key]
			var/progress_percent = round((project.paid_amount / project.total_cost) * 100, 1)
			to_chat(user, span_notice("- [project.display_name]: [project.paid_amount]/[project.total_cost] ([progress_percent]%)"))

/obj/structure/vampire/bloodpool/attack_hand(mob/living/user)
	var/datum/antagonist/vampire/lord/lord = user.mind.has_antag_datum(/datum/antagonist/vampire/lord)
	if(!(user.clan_position?.can_assign_positions))
		return


	var/list/available_options_lord = list()
	var/list/available_options_contributor = list()

	// Add available project types that aren't already active
	for(var/project_type in available_project_types)
		var/datum/vampire_project/temp_project = new project_type()
		if(temp_project.can_start(user, src) && !(project_type in active_projects))
			available_options_lord[temp_project.display_name] = project_type
		qdel(temp_project)

	// Add option to contribute to existing projects
	if(active_projects.len)
		available_options_lord["Contribute to Project"] = "contribute"
		available_options_contributor["Contribute to Project"] = "contribute"
	// Add option to view/cancel projects
	if(active_projects.len)
		available_options_lord["Manage Projects"] = "manage"

	var/choice = browser_input_list(user, "What to do?", "VANDERLIN", available_options_lord)
	if(!choice)
		return

	var/action_lord = available_options_lord[choice]
	var/action_contributor = available_options_contributor[choice]

	if(lord)
		switch(action_lord)
			if("contribute")
				handle_project_contribution(user)
			if("manage")
				handle_project_management(user)
			else
				// It's a project type
				start_new_project(action_lord, user)
	else
		switch(action_contributor)
			if("contribute")
				handle_project_contribution(user)

/obj/structure/vampire/bloodpool/proc/start_new_project(project_type, mob/living/user)
	var/datum/vampire_project/project = new project_type()

	if(!project.can_start(user, src))
		to_chat(user, span_warning(project.start_failure_message))
		qdel(project)
		return

	if(!project.confirm_start(user))
		qdel(project)
		return

	project.bloodpool = src
	project.initiator = user
	project.on_start(user)

	active_projects[project_type] = project

	to_chat(user, span_greentext("Started project: [project.display_name]. Begin contributing vitae to progress."))

/obj/structure/vampire/bloodpool/proc/handle_project_contribution(mob/living/user)
	if(!active_projects.len)
		to_chat(user, span_warning("No active projects to contribute to."))
		return

	var/list/project_choices = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/remaining = project.total_cost - project.paid_amount
		project_choices["[project.display_name] (Remaining: [remaining])"] = project_type

	var/choice = browser_input_list(user, "Select project to contribute to:", "CONTRIBUTION", project_choices)
	if(!choice)
		return

	var/project_type = project_choices[choice]
	var/datum/vampire_project/project = active_projects[project_type]

	project.handle_contribution(user)

/obj/structure/vampire/bloodpool/proc/handle_project_management(mob/living/user)
	if(!active_projects.len)
		to_chat(user, span_warning("No active projects to manage."))
		return

	var/list/project_options = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/progress_percent = round((project.paid_amount / project.total_cost) * 100, 1)
		project_options["[project.display_name] ([progress_percent]%)"] = project_type

	var/choice = browser_input_list(user, "Select project to manage:", "PROJECT MANAGEMENT", project_options)
	if(!choice)
		return

	var/project_type = project_options[choice]
	var/datum/vampire_project/project = active_projects[project_type]

	var/action = browser_input_list(user, "What would you like to do?", "MANAGEMENT", list("View Details", "Cancel Project"))

	switch(action)
		if("View Details")
			project.show_details(user)
		if("Cancel Project")
			if(browser_alert(user, "Cancel [project.display_name]?<BR>All invested vitae will be refunded.", "CANCELLATION", list("Yes", "No")) == "Yes")
				cancel_project(project_type)

/obj/structure/vampire/bloodpool/proc/complete_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]

	// Notify all contributors
	for(var/mob/living/contributor in project.contributors)
		to_chat(contributor, span_boldannounce("[project.display_name] has been completed!"))
		contributor.playsound_local(get_turf(src), project.completion_sound, 100, FALSE, pressure_affected = FALSE)

	// Execute project completion
	project.on_complete(src)

	active_projects.Remove(project_type)
	qdel(project)

/obj/structure/vampire/bloodpool/proc/cancel_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]

	project.on_cancel()

	active_projects.Remove(project_type)
	qdel(project)

/obj/structure/vampire/bloodpool/proc/update_pool(change)
	if(!change)
		return
	if(owner_clan)
		owner_clan.adjust_bloodpool_size(change)
	current = clamp(current + change, 0, maximum)

/obj/structure/vampire/bloodpool/proc/check_withdraw(change)
	if(change < 0)
		if(abs(change) > current)
			return FALSE
		return TRUE

/datum/vampire_project
	var/display_name = "Unknown Project"
	var/description = "A mysterious undertaking."
	var/total_cost = 1000
	var/paid_amount = 0
	var/list/contributors = list()
	var/obj/structure/vampire/bloodpool/bloodpool
	var/mob/living/initiator
	var/start_failure_message = "This project cannot be started."
	var/completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/proc/can_start(mob/living/user, obj/structure/vampire/bloodpool/pool)
	return TRUE

/datum/vampire_project/proc/confirm_start(mob/living/user)
	return browser_alert(user, "Begin [display_name]?<BR>[description]<BR>Total Cost: [total_cost]<BR>You can contribute vitae over time.", "PROJECT START", list("Yes", "No")) == "Yes"

/datum/vampire_project/proc/on_start(mob/living/user)
	return

/datum/vampire_project/proc/handle_contribution(mob/living/user)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	var/max_contribution = min(user.bloodpool, total_cost - paid_amount)
	if(!lord)
		if(display_name != "Wicked Plate" || display_name != "World Anchor")
			max_contribution = min(user.bloodpool, (total_cost - paid_amount) - 100)

	var/contribution = input(user, "How much vitae to contribute? (Max: [max_contribution])", "CONTRIBUTION") as num|null

	if(!contribution || contribution <= 0)
		return

	contribution = clamp(contribution, 1, max_contribution)

	if(user.bloodpool < contribution)
		to_chat(user, span_warning("I do not have enough vitae."))
		return

	user.adjust_bloodpool(-contribution)
	paid_amount += contribution

	if(!(user in contributors))
		contributors += user

	to_chat(user, span_greentext("Contributed [contribution] vitae to [display_name]. ([paid_amount]/[total_cost])"))
	make_tracker_effects(user.loc, bloodpool, 1, "soul", 3, /obj/effect/tracker/drain, 1)

	if(paid_amount >= total_cost)
		bloodpool.complete_project(type)

/datum/vampire_project/proc/show_details(mob/living/user)
	to_chat(user, span_notice("Project: [display_name]"))
	to_chat(user, span_notice("Description: [description]"))
	to_chat(user, span_notice("Progress: [paid_amount]/[total_cost]"))
	to_chat(user, span_notice("Contributors: [english_list(contributors)]"))

/datum/vampire_project/proc/on_complete()
	return

/datum/vampire_project/proc/on_cancel()
	// Refund vitae to contributors proportionally
	var/total_refund = paid_amount
	for(var/mob/living/contributor in contributors)
		// For simplicity, equal refund to all contributors
		// You could track individual contributions if needed
		var/refund_amount = total_refund / contributors.len
		contributor.adjust_bloodpool(refund_amount)
		to_chat(contributor, span_notice("Received [refund_amount] vitae refund from cancelled project: [display_name]"))

// Specific project types
/datum/vampire_project/power_growth
	display_name = "Rite of Stirring"
	description = "The ancient blood stirs once more. Forgotten whispers echo through the marrow of the land."
	total_cost = VAMPCOST_ONE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth/can_start(mob/living/user, obj/structure/vampire/bloodpool/pool)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	return lord && !lord.ascended

/datum/vampire_project/power_growth/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.maxbloodpool += 1000
			bloodpool.available_project_types -= /datum/vampire_project/power_growth
			bloodpool.available_project_types += /datum/vampire_project/power_growth_2
			break

/datum/vampire_project/power_growth_2
	display_name = "Rite of Reclamation"
	description = "Strength long sealed returns. The soil, the stone, and the shadows bend again to their rightful master."
	total_cost = VAMPCOST_TWO
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_2/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.maxbloodpool += 1000
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_2
			bloodpool.available_project_types += /datum/vampire_project/power_growth_3
			break

/datum/vampire_project/power_growth_3
	display_name = "Rite of Dominion"
	description = "The veil of time shreds. The Elder's will pours forth, binding trespassers within the grasp of the Land."
	total_cost = VAMPCOST_THREE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_3/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.maxbloodpool += 1000
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_3
			bloodpool.available_project_types += /datum/vampire_project/power_growth_4
			break

/datum/vampire_project/power_growth_4
	display_name = "Rite of Sovereignty"
	description = "The Lord is whole. Ancient power saturates every stone and vein, for the Land and its master are one."
	total_cost = VAMPCOST_FOUR
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_4/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.maxbloodpool += 1000
			to_chat(user, span_danger("I AM ANCIENT, I AM THE LAND. EVEN THE SUN BOWS TO ME."))
			lord.ascended = TRUE
			var/list/all_subordinates = user.clan_position.get_all_subordinates()
			for(var/mob/living/carbon/human/subordinate_body  in all_subordinates)
				subordinate_body.maxbloodpool += 1000
				for(var/S in MOBSTATS)
					subordinate_body.change_stat(S, 2)

			bloodpool.available_project_types -= /datum/vampire_project/power_growth_4
			break
/datum/vampire_project/amulet_crafting
	display_name = "World Anchor"
	description = "Forge a mystical amulet to bind souls across realms."
	total_cost = 500
	completion_sound = 'sound/misc/vcraft.ogg'
	var/amulet_name

/datum/vampire_project/amulet_crafting/confirm_start(mob/living/user)
	if(..())
		amulet_name = browser_input_text(user, "Select a name for the amulet", max_length = MAX_NAME_LEN)
		return TRUE
	return FALSE

/datum/vampire_project/amulet_crafting/on_complete(atom/movable/creation_point)
	var/obj/item/clothing/neck/portalamulet/P = new(bloodpool.loc)
	if(amulet_name)
		P.name = amulet_name
	creation_point.visible_message(span_notice("An amulet materializes from the crimson crucible."))

/datum/vampire_project/armor_crafting
	display_name = "Wicked Plate"
	description = "Craft a complete set of vampiric armor from crystallized blood."
	total_cost = 5000
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/armor_crafting/on_complete(atom/movable/creation_point)
	new /obj/item/clothing/pants/platelegs/vampire (bloodpool.loc)
	new /obj/item/clothing/gloves/chain/vampire (bloodpool.loc)
	new /obj/item/clothing/armor/chainmail/hauberk/vampire (bloodpool.loc)
	new /obj/item/clothing/armor/plate/vampire (bloodpool.loc)
	new /obj/item/clothing/shoes/boots/armor/vampire (bloodpool.loc)
	new /obj/item/clothing/head/helmet/heavy/vampire (bloodpool.loc)
	creation_point.visible_message(span_notice("A complete set of armor materializes from the crimson crucible."))

#undef VAMPCOST_ONE
#undef VAMPCOST_TWO
#undef VAMPCOST_THREE
#undef VAMPCOST_FOUR
