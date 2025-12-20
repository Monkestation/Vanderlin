/datum/action/cooldown/spell/undirected/seek_rival
	name = "Seek Rival's Heart"
	desc = "Find the distance between you and your rival's heart."
	sound = null

	spell_type = NONE
	charge_required = FALSE
	has_visual_effects = FALSE
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/undirected/seek_rival/cast(atom/cast_on)
	. = ..()

	var/datum/culling_duel/current_duel
	for(var/datum/culling_duel/D in GLOB.graggar_cullings)
		var/mob/living/carbon/human/challenger = D.challenger?.resolve()
		var/mob/living/carbon/human/target = D.target?.resolve()

		if(challenger == owner || target == owner)
			current_duel = D
			break

	if(!current_duel)
		to_chat(owner, span_red("You don't have a rival in Graggar's culling!"))
		return

	var/obj/item/organ/heart/rival_heart
	var/mob/living/carbon/human/challenger = current_duel.challenger?.resolve()
	var/mob/living/carbon/human/target = current_duel.target?.resolve()

	if(owner == challenger)
		rival_heart = current_duel.target_heart?.resolve()
	else if(owner == target)
		rival_heart = current_duel.challenger_heart?.resolve()

	if(QDELETED(rival_heart))
		to_chat(owner, span_red("Your rival's heart has been destroyed..."))
		return

	to_chat(owner, span_notice("Your rival's heart is [where_heart(rival_heart)]"))

/datum/action/cooldown/spell/undirected/seek_rival/proc/where_heart(obj/item/organ/heart/tracked_heart)
	if(!owner || !tracked_heart)
		return "nowhere to be found"

	var/atom/heart_location = tracked_heart.owner ? tracked_heart.owner : tracked_heart
	var/our_z = owner.z
	var/their_z = heart_location.z
	var/dist = get_dist(owner, heart_location)
	var/dir = get_dir(owner, heart_location)
	var/dir_text = dir2text(dir)
	var/distance_text

	switch(dist)
		if(0 to 7)
			distance_text = "very close"
		if(8 to 15)
			distance_text = "close"
		if(16 to 35)
			distance_text = "near"
		if(36 to 49)
			distance_text = "somewhat near"
		if(50 to 70)
			distance_text = "slightly far"
		if(71 to 98)
			distance_text = "somewhat far"
		if(99 to 127)
			distance_text = "far"
		else
			distance_text = "very far"

	var/z_text = ""
	if(our_z != their_z)
		z_text = ", [our_z > their_z ? "below you" : "above you"]"

	var/location_context = ""
	if(tracked_heart.owner)
		if(tracked_heart.owner == owner)
			location_context = "It's in YOUR chest!"
		else if(istype(tracked_heart.owner, /mob/living/carbon/human))
			var/mob/living/carbon/human/heart_owner = tracked_heart.owner
			location_context = "It's beating in [heart_owner.real_name]'s chest."
		else
			location_context = "It's inside some living being."
	else
		location_context = "It's exposed and vulnerable!"

	return "[distance_text]... and to the [dir_text][z_text]. [location_context]"
