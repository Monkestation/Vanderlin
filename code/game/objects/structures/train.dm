//AKA cryosleep.

/obj/structure/train //Shamelessly jury-rigged from the way Fallout13 handles this and shamelessly borrowed from AzurePeak's further iteraiton of this system
	name = "train"
	desc = "Your heart yearns to wander.\n(Drag your sprite onto this to exit the round!)"
	icon = 'icons/roguetown/items/train.dmi'
	icon_state = "train"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/in_use = FALSE
	var/static/list/uncryoable = list(
		/datum/job/lord,
		/datum/job/hand,
		/datum/job/prince,
		/datum/job/consort,
		/datum/job/priest,
		/datum/job/captain,//Rest of these roles cannot cryo, as they must ahelp first before leaving the round.
		/datum/job/gaffer //opening up the slot will break the gaffer ring code
	)

/obj/structure/train/MouseDrop_T(atom/dropping, mob/user)
	if(!isliving(user) || user.incapacitated(IGNORE_GRAB))
		return //No ghosts or incapacitated folk allowed to do this.
	if(!ishuman(dropping))
		return //Only humans have job slots to be freed.
	if(in_use) // Someone's already going in.
		return
	var/mob/living/carbon/human/departing_mob = dropping
	if(departing_mob != user && departing_mob.client)
		to_chat(user, span_warning("This one retains their free will. It's their choice if they want to leave for [SSmapping.config.immigrant_origin] or not."))
		return //prevents people from forceghosting others
	if(departing_mob.stat == DEAD)
		say("The dead cannot leave for [SSmapping.config.immigrant_origin], ensure they get a proper burial in [SSmapping.config.map_name].")
		return
	if(is_type_in_list(departing_mob.mind?.assigned_role, uncryoable))
		var/title = departing_mob.gender == FEMALE ? "lady" : "lord"
		say("Surely you jest, my [title], you have a kingdom to rule over!")
		return //prevents noble roles from cryoing as per request of Aberra
	if(alert("Are you sure you want to [departing_mob == user ? "leave for [SSmapping.config.immigrant_origin] (you" : "send this person to [SSmapping.config.immigrant_origin] (they"] will be removed from the current round, the job slot freed)?", "Departing", "Confirm", "Cancel") != "Confirm")
		return //doublechecks that people actually want to leave the round
	if(user.incapacitated(IGNORE_GRAB) || QDELETED(departing_mob) || (departing_mob != user && departing_mob.client) || get_dist(src, dropping) > 2 || get_dist(src, user) > 2)
		return //Things have changed since the alert happened.
	say("[user] [departing_mob == user ? "is departing for [SSmapping.config.immigrant_origin]" : "is sending [departing_mob] to [SSmapping.config.immigrant_origin]!"]")
	in_use = TRUE //Just sends a simple message to chat that some-one is leaving
	if(!do_after(user, 5 SECONDS, src))
		in_use = FALSE
		return
	in_use = FALSE
	//the section below handles roles and admin logging
	var/dat = "[key_name(user)] has despawned [departing_mob == user ? "themselves" : departing_mob], job [departing_mob.job], at [AREACOORD(src)]. Contents despawned along:"
	if(!length(departing_mob.contents))
		dat += " none."
	else
		var/atom/movable/content = departing_mob.contents[1]
		dat += " [content.name]"
		for(var/i in 2 to length(departing_mob.contents))
			content = departing_mob.contents[i]
			dat += ", [content.name]"
		dat += "."
	message_admins(dat)
	log_admin(dat)
	say(span_notice("[departing_mob == user ? "Out of their own volition, " : "Ushered by [user], "][departing_mob] is departing from [SSmapping.config.map_name]."))
	cryo_mob(departing_mob)

/proc/cryo_mob(mob/departing_mob, admin = FALSE)
	if(QDELETED(departing_mob))
		return "Tried to cryo a deleted mob!"
	GLOB.actors_list -= departing_mob.mobid // mob cryod - get him outta here.
	var/mob/dead/new_player/newguy = new()
	newguy.ckey = departing_mob.ckey
	var/mob_name = departing_mob.real_name
	var/datum/job/J = SSjob.GetJob(departing_mob.job)
	if(!ishuman(departing_mob))
		log_game("Cannot cryo [mob_name] ([departing_mob.type]): must be human. Deleting early.")
		qdel(departing_mob)
		return "Cannot cryo [mob_name] ([departing_mob.type]): must be human. Deleting early."
	if(!J || (J == /datum/job/unassigned))
		log_game("Cannot cryo [mob_name]: no assigned job. Deleting early.")
		qdel(departing_mob)
		return "Cannot cryo [mob_name]: no assigned job. Deleting early."
	log_game("Cryo successful for [mob_name], adjusting job [J.title].")
	if(J.parent_job)
		J.parent_job.adjust_current_positions(-1)
	else
		J.adjust_current_positions(-1)
	qdel(departing_mob)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_HUMAN_ENTER_CRYO, departing_mob, admin)
	return "[mob_name] successfully cryo'd!"

/obj/structure/train/carriage //A temporary subform of the train that is just a carriage	name = "train"
	desc = "A train carriage."
	icon = 'icons/roguetown/items/train.dmi'
	icon_state = "train2"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/train/carriage/not_train
	name = "carriage"
	desc = "A wooden carriage to carry passengers across land without the blessings of Heartfeltian underground train infrastructure."
	icon = 'icons/roguetown/underworld/enigma_carriage.dmi'
	icon_state = "carriage_normal"
