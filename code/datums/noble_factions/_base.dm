/datum/noble_faction
	var/name = "Unnamed House"
	var/datum/weakref/head_ref
	///ref to aspirant
	var/datum/weakref/backing_aspirant_ref
	var/list/mob/living/carbon/human/members = list()
	/// One alt-appearance instance per member, keyed by member, so we can refresh the "seers" list on roster change
	var/list/mob/living/carbon/human/member_tags = list()
	var/aspirant_threshold = 14

/datum/noble_faction/New(mob/living/carbon/human/founder, faction_name)
	. = ..()
	head_ref = WEAKREF(founder)
	founder.mind?.noble_faction = src
	if(faction_name)
		name = faction_name
	add_member(founder)
	founder.add_spell(/datum/action/cooldown/offer_patronage)
	founder.AddComponent(/datum/component/hovering_information, /datum/hover_data/noble_faction_head, TRAIT_ASPIRANT_INSIGHT)
	LAZYADD(GLOB.current_noble_factions, src)

/datum/noble_faction/Destroy(force)
	for(var/mob/living/carbon/human/member as anything in member_tags)
		remove_faction_tag(member)
	members = null
	member_tags = null
	head_ref = null
	backing_aspirant_ref = null
	return ..()

/datum/noble_faction/proc/set_backing_aspirant(mob/living/carbon/human/new_aspirant)
	var/mob/living/carbon/human/old_aspirant = backing_aspirant_ref?.resolve()
	if(old_aspirant && old_aspirant != new_aspirant)
		remove_member(old_aspirant)
		to_chat(old_aspirant, span_userdanger("[name] has abandoned your cause!"))
		var/datum/antagonist/aspirant/old_datum = locate(/datum/antagonist/aspirant) in old_aspirant.mind?.antag_datums
		old_datum?.backing_faction_ref = null

	backing_aspirant_ref = WEAKREF(new_aspirant)
	add_member(new_aspirant)

/datum/noble_faction/proc/add_member(mob/living/carbon/human/new_member, aspirant = FALSE)
	if(!new_member || (new_member in members))
		return FALSE
	members += new_member
	apply_faction_tag(new_member)
	refresh_all_tags() // everyone's seer list needs the new guy added
	SEND_SIGNAL(src, COMSIG_NOBLE_FACTION_SIZE_CHANGED, length(members))
	check_aspirant_threshold()
	return TRUE

/datum/noble_faction/proc/remove_member(mob/living/carbon/human/member)
	if(!(member in members))
		return FALSE
	members -= member
	remove_faction_tag(member)
	refresh_all_tags()
	SEND_SIGNAL(src, COMSIG_NOBLE_FACTION_SIZE_CHANGED, length(members))
	return TRUE

/datum/noble_faction/proc/apply_faction_tag(mob/living/carbon/human/member)
	var/image/marker = image(icon = 'icons/mob/hud.dmi', icon_state = (member == backing_aspirant_ref?.resolve()) ? "hog-red-0" : "hog-blue-2", loc = member)
	member_tags[member] = new /datum/atom_hud/alternate_appearance/basic/people(
		"nobleFaction_[REF(src)]_[REF(member)]",
		marker,
		NONE,
		members.Copy(),
	)

/datum/noble_faction/proc/remove_faction_tag(mob/living/carbon/human/member)
	var/datum/atom_hud/alternate_appearance/basic/people/tag = member_tags[member]
	if(tag)
		qdel(tag)
	member_tags -= member

/// everything is stale fuck my chud life.
/datum/noble_faction/proc/refresh_all_tags()
	for(var/mob/living/carbon/human/member as anything in member_tags)
		var/datum/atom_hud/alternate_appearance/basic/people/tag = member_tags[member]
		tag.seers = list()
		for(var/mob/living/carbon/human/seer as anything in members)
			tag.seers += WEAKREF(seer)
		for(var/mob/viewer in GLOB.player_list)
			tag.apply_to_new_mob(viewer)

/datum/noble_faction/proc/check_aspirant_threshold()
	if(length(members) >= aspirant_threshold)
		SEND_GLOBAL_SIGNAL(COMSIG_NOBLE_FACTION_ASPIRANT_ELIGIBLE, src)

/datum/noble_faction/vanderlin_red
	name = "Red Faction"

/datum/noble_faction/vanderlin_yellow
	name = "Green Faction" //the great switchup

/datum/noble_faction/vanderlin_blue
	name = "Blue Faction"
