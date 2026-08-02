SUBSYSTEM_DEF(communications)
	name = "Communications"
	flags = SS_NO_INIT | SS_NO_FIRE

	var/message_cooldown

/datum/controller/subsystem/communications/proc/can_announce(mob/living/user)
	if(message_cooldown > world.time)
		. = FALSE
	else
		. = TRUE

/datum/controller/subsystem/communications/proc/make_announcement(mob/living/user, decree = FALSE, input)
	var/used_title
	if(user.job)
		var/datum/job/job = SSjob.GetJob(user.job)
		used_title = job ? "The [job.get_informed_title(user)]" : "Someone"

	if(decree)
		priority_announce(html_decode(user.treat_message(input)), "[user.real_name], [used_title] Decrees", 'sound/misc/alert.ogg', "Captain")
		message_cooldown = world.time + 5 SECONDS
	else
		priority_announce(html_decode(user.treat_message(input)), "[user.real_name], [used_title] Speaks", 'sound/misc/alert.ogg', "Captain")
		message_cooldown = world.time + 5 SECONDS

	user.log_talk(input, LOG_SAY, tag="priority announcement")
	message_admins("[ADMIN_LOOKUPFLW(user)] has made a priority announcement.")
