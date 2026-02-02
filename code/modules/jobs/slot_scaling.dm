/proc/get_total_town_members()
	var/count = 0
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind && H.client)
			if(H.mind.assigned_role?.faction == "Town")
				count++
	return count

/proc/job_slot_formula(town_count, factor, c, min, max)
	if(town_count <= factor)
		return min
	return floor(clamp((town_count/factor)+c, min, max))

/proc/adventurer_slot_formula(playercount)
	return job_slot_formula(playercount,7,2,3,14)
