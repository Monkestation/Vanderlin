GLOBAL_LIST_EMPTY(credits_icons)

SUBSYSTEM_DEF(crediticons)
	name = "crediticons"
	wait = 60
	flags = SS_NO_INIT
	priority = 1
	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/crediticons/fire(resumed = 0)
	if(!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/mob/living/carbon/human/thing = currentrun[length(currentrun)]
		currentrun.len--
		if(QDELETED(thing))
			processing -= thing
			if(MC_TICK_CHECK)
				return
			continue
		add_credit(thing)
		STOP_PROCESSING(SScrediticons, thing)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/crediticons/proc/add_credit(mob/living/carbon/human/actor)
	if(!actor.mind || !actor.client)
		return
	var/datum/mind/actor_mind = actor.mind
	var/client/actor_client = actor.client
	var/datum/job/job = actor_mind.assigned_role
	var/datum/preferences/preferences = actor_client.prefs
	if(!preferences)
		return

	var/thename = "[actor.real_name]"
	var/used_title = job.get_informed_title(actor)
	if(used_title)
		thename = "[thename]\nthe [used_title]"

	GLOB.credits_icons[thename] = list()
	var/icon/rendered_icon = get_flat_human_icon(null, job, preferences, DUMMY_HUMAN_SLOT_MANIFEST, list(SOUTH))
	if(rendered_icon)
		var/icon/female_s = icon("icon"='icons/mob/clothing/under/masking_helpers.dmi', "icon_state"="credits")
		rendered_icon.Blend(female_s, ICON_MULTIPLY)
		rendered_icon.Scale(96,96)
		GLOB.credits_icons[thename]["icon"] = rendered_icon
		GLOB.credits_icons[thename]["vc"] = actor.voice_color

/datum/controller/subsystem/crediticons/proc/get_credit_icon(mob/living/carbon/human/target, crop_to_upper_half = FALSE)
	if(!target || !istype(target) || !target.mind || !target.client)
		return null

	var/credit_name = "[target.real_name]"
	if(target.original_name)
		credit_name = "[target.original_name]"
	if(target.mind.assigned_role)
		var/datum/job/job = target.mind.assigned_role
		var/used_title = job.get_informed_title(target)
		if(job.parent_job)
			used_title = job.parent_job.get_informed_title(target)
		if(used_title)
			credit_name = "[credit_name]\nthe [used_title]"

	if(!GLOB.credits_icons[credit_name]?["icon"])
		return null

	var/icon/credit_icon = GLOB.credits_icons[credit_name]["icon"]

	if(crop_to_upper_half)
		var/icon/cropped_icon = icon(credit_icon)
		cropped_icon.Crop(1, 49, 96, 96)
		return cropped_icon

	return credit_icon
