/obj/effect/abstract/property_noop
	invisibility = INVISIBILITY_ABSTRACT
	var/property_id

/obj/effect/landmark/house_spot
	var/property_id = "" // Unique identifier for this specific property location
	var/save_id = "" // Template type identifier (multiple properties can share same save_id)
	var/owner_ckey = null
	var/owner_property_slot = null // Which slot/ID the owner is using for this property

	var/template_x = 0
	var/template_y = 0
	var/template_z = 1

	var/datum/map_template/default_template

	/// If set, only players currently assigned one of these job titles can claim this property. Null/empty = no restriction.
	var/list/required_jobs = null

/obj/effect/landmark/house_spot/Initialize(mapload)
	. = ..()
	SShousing.register_property(src)

/obj/effect/landmark/house_spot/Destroy(force)
	default_template = null
	return ..()

/obj/effect/landmark/house_spot/proc/check_job_requirement(mob/user)
	if(!length(required_jobs))
		return TRUE
	if(!user?.mind?.assigned_role)
		return FALSE
	if(is_type_in_list(SSjob.GetJob(user.job), required_jobs))
		return TRUE
	return FALSE

/obj/effect/landmark/house_spot/proc/get_required_jobs_string()
	if(!length(required_jobs))
		return ""
	var/list/titles = list()
	for(var/datum/job/job as anything in required_jobs)
		titles += initial(job.title)
	return jointext(titles, ", ")

/obj/effect/landmark/house_spot/proc/on_claim(mob/user)
	return

/obj/effect/landmark/house_spot/noble
	required_jobs = list(/datum/job/minor_noble)
	var/datum/noble_faction/faction_type

/obj/effect/landmark/house_spot/noble/Destroy(force)
	. = ..()
	LAZYREMOVE(GLOB.noble_points, src)

/obj/effect/landmark/house_spot/noble/Initialize(mapload)
	. = ..()
	if(!ispath(faction_type) && !isnull(faction_type))
		faction_type = text2path(faction_type) //someone map editting
	LAZYADD(GLOB.noble_points, src)

/obj/effect/landmark/house_spot/noble/on_claim(mob/user)
	user.create_new_faction(faction_type)
	LAZYREMOVE(GLOB.noble_points, src)

/mob/proc/create_new_faction(datum/noble_faction/faction_type)
	new faction_type(src)
