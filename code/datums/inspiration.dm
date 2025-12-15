// Bardic Inspo time - Datum/definition setup

GLOBAL_LIST_INIT(learnable_songst1, (list(/datum/action/cooldown/spell/undirected/song/dirge_fortune,
		/datum/action/cooldown/spell/undirected/song/furtive_fortissimo,
		/datum/action/cooldown/spell/undirected/song/intellectual_interval,
		)
))


GLOBAL_LIST_INIT(learnable_songst2, (list(/datum/action/cooldown/spell/undirected/song/recovery_song,
		/datum/action/cooldown/spell/undirected/song/fervor_song,
		/datum/action/cooldown/spell/undirected/song/pestilent_piedpiper
		)
))


GLOBAL_LIST_INIT(learnable_songst3, (list(/datum/action/cooldown/spell/undirected/song/rejuvenation_song,
		/datum/action/cooldown/spell/undirected/song/suffocating_seliloquy,
		/datum/action/cooldown/spell/undirected/song/accelakathist,
		)
))


/datum/inspiration
	var/mob/living/carbon/human/holder
	var/level = BARD_T1
	var/maxaudience = 2
	var/list/audience = list()
	var/maxsongs = BARD_T1
	var/songsbought = 0
	var/tier1acquired = FALSE
	var/tier2acquired = FALSE
	var/tier3acquired = FALSE

/datum/inspiration/Destroy(force)
	. = ..()
	holder?.inspiration = null
	holder = null
	STOP_PROCESSING(SSobj, src)



/mob/living/carbon/human/proc/in_audience(var/mob/living/carbon/human/audiencee)
	if(!src.mind)
		return FALSE
	if(!src.inspiration)
		return FALSE

	if(audiencee in src.inspiration.audience)
		return TRUE
	else
		return FALSE


/datum/inspiration/proc/grant_inspiration(mob/living/carbon/human/H, bard_tier)
	if(!H || !H.mind)
		return
	level = bard_tier
	maxaudience = 2*bard_tier
	maxsongs = bard_tier
	H.verbs += list(/mob/living/carbon/human/proc/setaudience, /mob/living/carbon/human/proc/clearaudience, /mob/living/carbon/human/proc/checkaudience, /mob/living/carbon/human/proc/picksongs)

/mob/living/carbon/human/proc/setaudience()
	set name = "Audience Choice"
	set category = "Inspiration"

	if(!inspiration)
		return FALSE
	if(inspiration.audience.len >= inspiration.maxaudience)
		to_chat(src, "I cannot maintain an audience larger than [inspiration.maxaudience]!")
		return FALSE
	var/list/folksnearby = list()
	for(var/mob/living/carbon/human/folks in view(7, loc))
		if(!src.in_audience(folks))
			folksnearby += folks

	if(!folksnearby)
		return
	var/target = browser_input_list(src, "Who will you perform for?", "Audience Choice", folksnearby)
	if(target)
		inspiration.audience |= target


	return TRUE


/mob/living/carbon/human/proc/clearaudience()
	set name = "Clear Audience"
	set category = "Inspiration"
	if(!inspiration)
		return FALSE
	if(src.has_status_effect(/datum/status_effect/buff/playing_music)) // cant clear while playing
		return
	inspiration.audience = list()

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


/datum/inspiration/New(mob/living/carbon/human/holder)
	. = ..()
	src.holder = holder
	holder?.inspiration = src
	ADD_TRAIT(holder, INSPIRING_MUSICIAN, "inspiration")


/mob/living/carbon/human/proc/picksongs()
	set name = "Fill Songbook"
	set category = "Inspiration"


	if(!mind)
		return
	var/list/songs = GLOB.learnable_songst1
	var/list/choices = list()
	var/choosablesongtiers = list()

	switch(inspiration.level)
		if(1)
			choosablesongtiers += ("TIER1")
		if(2)
			choosablesongtiers += ("TIER1")
			choosablesongtiers += ("TIER2")
		if(3)
			choosablesongtiers += ("TIER1")
			choosablesongtiers += ("TIER2")
			choosablesongtiers += ("TIER3")

	if(inspiration.tier1acquired)
		choosablesongtiers -= ("TIER1")
	if(inspiration.tier2acquired)
		choosablesongtiers -= ("TIER2")
	if(inspiration.tier3acquired)
		choosablesongtiers -= ("TIER3")

	var/chosensongtier = browser_input_list(src, "Choose a tier of song to add to your songbook", "SERENADE", choosablesongtiers)

	if(!chosensongtier)
		return

	switch(chosensongtier)
		if("TIER1")
			songs = GLOB.learnable_songst1
		if("TIER2")
			songs = GLOB.learnable_songst2
		if("TIER3")
			songs = GLOB.learnable_songst3

	for(var/i = 1, i <= songs.len, i++)
		var/datum/action/cooldown/spell/undirected/song/spell_item = songs[i]
		choices["[spell_item.name]"] = spell_item

	var/choice = input("Choose a song") as anything in choices
	var/datum/action/cooldown/spell/undirected/song/item = choices[choice]

	if(!item)
		return     // user canceled;
	if(alert(src, "[item.desc]", "[item.name]", "Learn", "Cancel") == "Cancel") //gives a preview of the spell's description to let people know what a spell does
		return

	for(var/datum/action/cooldown/spell/undirected/song/knownsong as anything in actions)
		if(knownsong.type == item.type)
			to_chat(src, span_warning("You already know this one!"))
			return
	var/datum/action/cooldown/spell/undirected/song/new_song = new item
	add_spell(new_song)
	inspiration.songsbought += 1
	switch(item.song_tier)
		if(1)
			inspiration.tier1acquired = TRUE
		if(2)
			inspiration.tier2acquired = TRUE
		if(3)
			inspiration.tier3acquired = TRUE
	if(inspiration.songsbought >= inspiration.level)
		verbs -= /mob/living/carbon/human/proc/picksongs
