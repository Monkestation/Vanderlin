GLOBAL_LIST_EMPTY(vampire_objects)

/datum/antagonist/vampire
	name = "Vampire"
	roundend_category = "Vampires"
	antagpanel_category = "Vampire"
	job_rank = ROLE_VAMPIRE
	antag_hud_type = ANTAG_HUD_VAMPIRE
	antag_hud_name = "vamp"
	confess_lines = list(
		"I WANT YOUR BLOOD!",
		"DRINK THE BLOOD!",
		"CHILD OF KAIN!",
	)
	var/datum/clan/default_clan = /datum/clan/nosferatu
	// New variables for clan selection
	var/clan_selected = FALSE
	var/custom_clan_name = ""
	var/list/selected_covens = list()
	var/forced = FALSE
	var/datum/clan/forcing_clan

/datum/antagonist/vampire/New(datum/clan/incoming_clan = /datum/clan/nosferatu, forced_clan = FALSE)
	. = ..()
	if(forced_clan)
		if(!istype(incoming_clan))
			incoming_clan = new incoming_clan()
		forced = forced_clan
		forcing_clan = incoming_clan
	else
		default_clan = incoming_clan

/datum/antagonist/vampire/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire/lord))
		return span_boldnotice("Kaine's firstborn!")
	if(istype(examined_datum, /datum/antagonist/vampire))
		return span_boldnotice("A child of Kaine.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite.")

/datum/antagonist/vampire/on_gain()
	SSmapping.retainer.vampires |= owner
	move_to_spawnpoint()
	owner.special_role = name
	owner.current.adjust_bloodpool()

	if(ishuman(owner.current))
		var/mob/living/carbon/human/vampdude = owner.current
		vampdude.adv_hugboxing_cancel()
		vampdude.hud_used?.shutdown_bloodpool()
		vampdude.hud_used?.initialize_bloodpool()
		vampdude.hud_used?.bloodpool.set_fill_color("#510000")

		if(!forced)
			// Show clan selection interface
			if(!clan_selected)
				show_clan_selection(vampdude)
			else
				// Apply the selected clan
				vampdude.set_clan(default_clan)
		else
			vampdude.set_clan_direct(forcing_clan)
			forcing_clan = null

	// The clan system now handles most of the setup, but we can still do antagonist-specific things
	after_gain()
	. = ..()
	equip()

/datum/antagonist/vampire/proc/show_clan_selection(mob/living/carbon/human/vampdude)
	var/list/clan_options = list()
	var/list/available_clans = list()

	for(var/clan_type in subtypesof(/datum/clan))
		var/datum/clan/temp_clan = new clan_type
		if(temp_clan.selectable_by_vampires)
			available_clans += clan_type
			clan_options[temp_clan.name] = clan_type
		qdel(temp_clan)

	clan_options["Create Custom Clan"] = "custom"

	var/choice = input(vampdude, "Choose your vampire clan:", "Clan Selection") as null|anything in clan_options

	if(!choice)
		// Default to nosferatu if no choice made
		default_clan = /datum/clan/nosferatu
		vampdude.set_clan(default_clan)
		clan_selected = TRUE
		return

	if(clan_options[choice] == "custom")
		create_custom_clan(vampdude)
	else
		default_clan = clan_options[choice]
		vampdude.set_clan(default_clan)
		clan_selected = TRUE

/datum/antagonist/vampire/proc/create_custom_clan(mob/living/carbon/human/vampdude)
	// Get custom clan name
	custom_clan_name = browser_input_text(vampdude, "Enter your custom clan name", max_length = MAX_NAME_LEN)
	if(!custom_clan_name)
		custom_clan_name = "Custom Clan"

	// Show coven selection
	show_coven_selection(vampdude)

/datum/antagonist/vampire/proc/show_coven_selection(mob/living/carbon/human/vampdude)
	var/list/coven_options = list()
	var/list/available_covens = list()

	// Get all available covens
	for(var/coven_type in subtypesof(/datum/coven))
		var/datum/coven/temp_coven = new coven_type
		// Only show covens that aren't clan-restricted or can be used by custom clans
		if(!temp_coven.clan_restricted)
			available_covens += coven_type
			coven_options[temp_coven.name] = coven_type
		qdel(temp_coven)

	if(!length(coven_options))
		to_chat(vampdude, span_warning("No covens available for selection."))
		finalize_custom_clan(vampdude)
		return

	// Select first coven
	var/first_choice = input(vampdude, "Choose your first coven:", "Coven Selection") as null|anything in coven_options
	if(first_choice)
		selected_covens += coven_options[first_choice]
		coven_options -= first_choice

	// Select second coven
	if(length(coven_options))
		var/second_choice = input(vampdude, "Choose your second coven:", "Coven Selection") as null|anything in coven_options
		if(second_choice)
			selected_covens += coven_options[second_choice]
			coven_options -= second_choice

	if(length(coven_options))
		var/third_choice = input(vampdude, "Choose your third coven:", "Coven Selection") as null|anything in coven_options
		if(third_choice)
			selected_covens += coven_options[third_choice]
			coven_options -= third_choice

	finalize_custom_clan(vampdude)

/datum/antagonist/vampire/proc/finalize_custom_clan(mob/living/carbon/human/vampdude)
	// Create a custom clan instance
	var/datum/clan/custom/new_clan = new /datum/clan/custom()
	new_clan.name = custom_clan_name
	new_clan.clane_covens = selected_covens.Copy()

	// Apply the custom clan
	vampdude.set_clan_direct(new_clan)
	clan_selected = TRUE

	to_chat(vampdude, span_notice("You are now a member of the [custom_clan_name] clan with [length(selected_covens)] coven(s)."))

/datum/antagonist/vampire/proc/after_gain()
	return

/datum/antagonist/vampire/on_removal()
	if(ishuman(owner.current))
		var/mob/living/carbon/human/vampdude = owner.current
		// Remove the clan when losing antagonist status
		vampdude.set_clan(null)
	if(!silent && owner.current)
		to_chat(owner.current, span_danger("I am no longer a [job_rank]!"))
	owner.special_role = null
	return ..()

/datum/antagonist/vampire/proc/equip()
	return

// Custom clan datum for player-created clans
/datum/clan/custom
	name = "Custom Clan"
	selectable_by_vampires = FALSE

/obj/structure/vampire
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	density = TRUE

/obj/structure/vampire/Initialize()
	GLOB.vampire_objects |= src
	. = ..()

/obj/structure/vampire/Destroy()
	GLOB.vampire_objects -= src
	return ..()

// LANDMARKS
/obj/effect/landmark/start/vampirelord
	name = "Vampire Lord"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vampirelord/Initialize()
	. = ..()
	GLOB.vlord_starts += loc

/obj/effect/landmark/start/vampirespawn
	name = "Vampire Spawn"
	icon_state = "arrow"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/vampirespawn/Initialize()
	. = ..()
	GLOB.vspawn_starts += loc

/obj/effect/landmark/start/vampireknight
	name = "Death Knight"
	icon_state = "arrow"
	jobspawn_override = list("Death Knight")
	delete_after_roundstart = FALSE

/obj/effect/landmark/vteleport
	name = "Teleport Destination"
	icon_state = "x2"

/obj/effect/landmark/vteleportsending
	name = "Teleport Sending"
	icon_state = "x2"

/obj/effect/landmark/vteleportdestination
	name = "Return Destination"
	icon_state = "x2"
	var/amuletname

/obj/effect/landmark/vteleportsenddest
	name = "Sending Destination"
	icon_state = "x2"
