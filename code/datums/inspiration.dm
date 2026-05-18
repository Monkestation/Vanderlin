/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 3
	var/list/audience = list()
	var/maxsongs = 2
	var/songsbought = 0
	var/datum/rhythm_tracker/rhythm_tracker = null
	var/list/selected_buffs = list()

/datum/inspiration/New(mob/living/carbon/human/holder)
	. = ..()
	src.holder = holder
	holder?.inspiration = src

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
	QDEL_NULL(rhythm_tracker)
	STOP_PROCESSING(SSobj, src)

/datum/inspiration/proc/grant_inspiration(mob/living/carbon/human/H, bard_tier)
	if(!H || !H.mind)
		return
	level = bard_tier
	switch(bard_tier)
		if(BARD_T1)
			maxaudience = 4
			maxsongs = 2
		if(BARD_T2)
			maxaudience = 6
			maxsongs = 4
	audience |= H // Bard is always in their own audience
	H.verbs += list(/mob/living/carbon/human/proc/explain_bard, /mob/living/carbon/human/proc/clear_audience)

/mob/living/carbon/human/proc/in_audience(mob/living/carbon/human/audiencee)
	if(!src.inspiration)
		return FALSE
	if(audiencee in src.inspiration.audience)
		return TRUE
	return FALSE

/datum/inspiration/proc/check_in_audience(mob/possible_attendee)
	return (possible_attendee in audience)

/mob/living/carbon/human/proc/clear_audience()
	set name = "Clear Audience"
	set category = "Inspiration"
	if(!inspiration)
		return FALSE
	if(src.has_status_effect(/datum/status_effect/buff/playing_melody) || src.has_status_effect(/datum/status_effect/buff/playing_dirge))
		return
	inspiration.audience = list(src)

	return TRUE

/mob/living/carbon/human/proc/toggleaudience(mob/living/carbon/human/target)
	if(!inspiration)
		return FALSE
	if(src.has_status_effect(/datum/status_effect/buff/playing_melody) || src.has_status_effect(/datum/status_effect/buff/playing_dirge))
		to_chat(src, span_warning("I cannot change my audience while performing!"))
		return FALSE
	if(!target || target == src)
		return FALSE
	if(inspiration.check_in_audience(target))
		inspiration.audience -= target
		to_chat(src, span_notice("[target.real_name] is no longer in my audience."))
	else
		var/audience_count = inspiration.audience.len - 1
		if(audience_count >= inspiration.maxaudience)
			to_chat(src, span_warning("I cannot maintain an audience larger than [inspiration.maxaudience]!"))
			return FALSE
		inspiration.audience |= target
		to_chat(src, span_notice("[target.real_name] is now in my audience."))
	return TRUE

/mob/living/carbon/human/proc/checkaudience()
	set name = "Check Audience"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	var/text = ""
	for(var/mob/living/carbon/human/folks in inspiration.audience)
		text += "[folks.real_name], "
	if(!text)
		return
	to_chat(src, "My audience members are: [text]")
	return TRUE

/mob/living/carbon/human/proc/explain_bard()
	set name = "Explain Bardic Inspiration"
	set category = "Inspiration"
	if(!inspiration)
		return FALSE
	var/tier_name = inspiration.level == BARD_T2 ? "Full Bard" : "Lesser Bard"
	to_chat(src, span_info("Bardic Inspiration allows you to inspire your allies with music. \
	Set your audience using the 'Audience Choice' verb, then open your Songbook from the action bar to learn songs and rhythms. \
	To activate a song, hold an instrument in one hand and toggle the song from your action bar. \
	Songs are mutually exclusive - activating a new song replaces the current one."))
	to_chat(src, span_info("Rhythm: Activate a rhythm, then strike within 8 seconds to trigger its effect. \
	All rhythms share a cooldown. Full Bards can build toward a Crescendo - a powerful blast after 3 rhythm procs."))
	to_chat(src, span_smallnotice("You're a [tier_name] and can have up to [inspiration.maxaudience] audience members and know [inspiration.maxsongs] songs."))

	return TRUE
