// Bardic Inspo time - Datum/definition setup

GLOBAL_LIST_INIT(inspiration_songs, list(\
	BARD_T1_KEY = (list(/datum/action/cooldown/spell/undirected/song/dirge_fortune,\
		/datum/action/cooldown/spell/undirected/song/furtive_fortissimo,\
		/datum/action/cooldown/spell/undirected/song/intellectual_interval)), \
	BARD_T2_KEY = (list(/datum/action/cooldown/spell/undirected/song/recovery_song,\
		/datum/action/cooldown/spell/undirected/song/fervor_song,\
		/datum/action/cooldown/spell/undirected/song/pestilent_piedpiper)), \
	BARD_T3_KEY = (list(/datum/action/cooldown/spell/undirected/song/rejuvenation_song,\
		/datum/action/cooldown/spell/undirected/song/suffocating_seliloquy,\
		/datum/action/cooldown/spell/undirected/song/accelakathist))
))

/datum/inspiration
	var/mob/living/carbon/human/holder
	var/current_tier = 0
	var/maxaudience = 0
	/// List of weakrefs to name (not real name)
	var/list/audience_weakrefs
	var/list/available_song_tiers

/datum/inspiration/New(mob/living/carbon/human/holder, bard_tier_override)
	. = ..()
	src.holder = holder
	RegisterSignal(holder, COMSIG_PARENT_QDELETING, PROC_REF(on_holder_qdel))
	RegisterSignal(holder, COMSIG_SKILL_RANK_CHANGE, PROC_REF(on_skill_change))
	add_verb(holder, list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience))
	set_inspiration_tier(bard_tier_override)

/datum/inspiration/Destroy(force)
	if(ishuman(holder))
		holder.inspiration = null
	remove_verb(holder, list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs))
	holder.remove_spells(source = src)
	UnregisterSignal(holder, list(COMSIG_PARENT_QDELETING, COMSIG_SKILL_RANK_CHANGE))
	holder = null
	. = ..()

///Called when holder is qdeleted for us to clean ourselves as not to leave any unlawful references.
/datum/inspiration/proc/on_holder_qdel(atom/source, force)
	SIGNAL_HANDLER
	qdel(src)

/datum/inspiration/proc/on_skill_change(datum/source, datum/skill/skill_ref, new_level, old_level)
	SIGNAL_HANDLER

	if(!istype(skill_ref, /datum/skill/misc/music))
		return
	if(new_level <= old_level)
		return

	set_inspiration_tier()

/datum/inspiration/proc/check_in_audience(mob/possible_attendee)
	LAZYINITLIST(audience_weakrefs)
	for(var/datum/weakref/mob_ref as anything in audience_weakrefs)
		if(mob_ref.resolve() == possible_attendee)
			return TRUE
	return FALSE

/// If tier_override is not set, uses holder's music skill to set the new tier. Based on the new tier, songs will be made available.
/datum/inspiration/proc/set_inspiration_tier(tier_override)
	var/old_inspire_tier = current_tier
	var/target_tier
	if(tier_override)
		target_tier = tier_override
	else
		switch(holder.get_skill_level(/datum/skill/misc/music))
			if(SKILL_LEVEL_EXPERT)
				target_tier = 1
			if(SKILL_LEVEL_MASTER)
				target_tier = 2
			if(SKILL_LEVEL_LEGENDARY)
				target_tier = 3

	LAZYINITLIST(available_song_tiers)
	while(old_inspire_tier < target_tier)
		old_inspire_tier++
		switch(old_inspire_tier)
			if(BARD_T1_VALUE)
				available_song_tiers += BARD_T1_KEY
			if(BARD_T2_VALUE)
				available_song_tiers += BARD_T2_KEY
			if(BARD_T3_VALUE)
				available_song_tiers += BARD_T3_KEY

	current_tier = target_tier
	maxaudience = 2 * current_tier
	if(length(available_song_tiers))
		add_verb(holder, /mob/living/carbon/human/proc/picksongs)

/**
 * MOB VERBS FOR INSPIRATION
 */

/mob/living/carbon/human/proc/setaudience()
	set name = "Audience Choice"
	set category = "RoleUnique.Bard"

	if(!inspiration)
		return
	if(length(inspiration.audience_weakrefs) >= inspiration.maxaudience)
		to_chat(src, "I cannot maintain an audience larger than [inspiration.maxaudience]!")
		return
	var/list/folksnearby = list()
	for(var/mob/living/carbon/human/folk in view(7, src))
		if(!inspiration.check_in_audience(folk))
			folksnearby += folk

	if(!length(folksnearby))
		return
	var/mob/target = browser_input_list(src, "Who will you perform for?", "Audience Choice", folksnearby)
	if(!target)
		return

	inspiration.audience_weakrefs[WEAKREF(target)] = target.name
	to_chat(src, "You add [target] to your audience.")

/mob/living/carbon/human/proc/clearaudience()
	set name = "Clear Audience"
	set category = "RoleUnique.Bard"
	if(!inspiration)
		return
	if(has_status_effect(/datum/status_effect/stacking/playing_inspiration)) // cant clear while playing
		to_chat(src, span_warning("You can't clear your audience while preparing a tune!"))
		return
	inspiration.audience_weakrefs = list()
	to_chat(src, "You clear your audience list.")

/mob/living/carbon/human/proc/checkaudience()
	set name = "Check Audience"
	set category = "RoleUnique.Bard"

	if(!inspiration)
		return
	var/list/text = list()
	for(var/datum/weakref/mob_ref as anything in inspiration.audience_weakrefs)
		if(mob_ref.resolve())
			text += inspiration.audience_weakrefs[mob_ref]
	if(!length(text))
		return
	to_chat(src, "My audience members are: [text.Join(", ")].")

/mob/living/carbon/human/proc/picksongs()
	set name = "Fill Songbook"
	set category = "RoleUnique.Bard"

	if(!inspiration)
		return
	if(!length(inspiration.available_song_tiers))
		return

	var/chosensongtier = browser_input_list(src, "Choose a tier of song to add to your songbook", "SERENADE", inspiration.available_song_tiers)

	if(!chosensongtier)
		return

	var/list/possible_songs = GLOB.inspiration_songs[chosensongtier]
	if(!possible_songs)
		return

	var/list/song_choices = list()
	for(var/i = 1, i <= possible_songs.len, i++)
		var/datum/action/cooldown/spell/undirected/song/spell_item = possible_songs[i]
		song_choices["[spell_item.name]"] = spell_item

	var/choice = input("Choose a song") as anything in song_choices
	if(!choice) // user canceled;
		return

	var/datum/action/cooldown/spell/undirected/song/item = song_choices[choice]
	if(get_spell(item , TRUE))
		to_chat(src, span_warning("You already know this song!"))
		return
	if(alert(src, "[item.desc]", "[item.name]", "Learn", "Cancel") == "Cancel") //gives a preview of the spell's description to let people know what a spell does
		return

	add_spell(item, source = inspiration)
	inspiration.available_song_tiers -= chosensongtier
	if(!length(inspiration.available_song_tiers))
		add_verb(src, /mob/living/carbon/human/proc/picksongs)
