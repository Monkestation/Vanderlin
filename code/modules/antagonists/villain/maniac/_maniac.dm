/datum/objective/maniac
	name = "WAKE UP"
	explanation_text = "FOLLOWING my HEART shall be the WHOLE of the law."
	flavor = "Dream"

/datum/antagonist/maniac
	name = "Maniac"
	roundend_category = "Maniacs"
	antagpanel_category = "Maniac"
	antag_memory = "<b>Recently I've been visited by a lot of VISIONS. They're all about another WORLD, ANOTHER life. I will do EVERYTHING to know the TRUTH, and return to the REAL world.</b>"
	job_rank = ROLE_MANIAC
	antag_hud_type = ANTAG_HUD_MANIAC
	antag_hud_name = "generic_villain"
	confess_lines = list(
		"I gave them no time to squeal.",
		"I shant quit ripping them.",
		"They deserve to be put at my blade.",
		"Do what thou wilt shall be the whole of the law.",
	)
	/// Traits we apply to the owner
	innate_traits = list(
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_DEADNOSE,
		TRAIT_EMPATH,
		TRAIT_STEELHEARTED,
		TRAIT_NOMOOD,
		TRAIT_SCHIZO_AMBIENCE,
		TRAIT_DARKVISION,
		TRAIT_NOPAINSTUN,
		TRAIT_NOENERGY,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_STRONG_GRABBER,
	)
	/// Traits that only get applied in the final sequence
	var/static/list/final_traits = list(
		TRAIT_MANIAC_AWOKEN,
		TRAIT_SCREENSHAKE,
	)
	/// Weapons we can give to the dreamer
	var/static/list/possible_weapons = list(
		/obj/item/weapon/knife/cleaver,
		/obj/item/weapon/knife/cleaver/combat,
		/obj/item/weapon/knife/dagger/steel/special,
	)
	/// Wonder recipes
	var/static/list/recipe_progression = list(
		/datum/blueprint_recipe/structure/wonder/first,
		/datum/blueprint_recipe/structure/wonder/second,
		/datum/blueprint_recipe/structure/wonder/third,
		/datum/blueprint_recipe/structure/wonder/fourth,
	)
	/// Key number > Key text
	var/list/num_keys = list()
	/// Key text > key number
	var/list/key_nums = list()
	/// Every heart inscryption we have seen
	var/list/hearts_seen = list()
	/// Sum of the numbers of every key
	var/sum_keys = 0
	/// Keeps track of which wonder we are gonna make next
	var/current_wonder = 1
	/// Set to TRUE when we are on the last wonder (waking up)
	var/waking_up = FALSE
	/// Set to true when we WIN and are on the ending sequence
	var/triumphed = FALSE
	/// Wonders we have made
	var/list/wonders_made = list()
	/// Hallucinations screen object
	var/atom/movable/screen/fullscreen/maniac/hallucinations
	/// Whether the combat music is enabled
	var/music_enabled = FALSE
	var/custom_music_track = null
	var/last_music_change = 0
	var/datum/looping_sound/maniac_theme_song/combat_music_loop
	var/curthemefile = 'sound/music/cmode/antag/combat_maniac.ogg'
	var/old_cm = null //Cheffie's Req, Cache the old combat music and given back upon removal.

GLOBAL_VAR_INIT(maniac_highlander, 0) // THERE CAN ONLY BE ONE!

/datum/antagonist/maniac/New()
	set_keys()
	load_strings_file("maniac.json")
	return ..()

/datum/antagonist/maniac/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/antagonist/maniac/on_gain()
	. = ..()
	SSfake_world.should_bother = TRUE
	owner.special_role = ROLE_MANIAC
	owner.special_items["Maniac"] = pick(possible_weapons)
	owner.special_items["Surgical Kit"] = /obj/item/storage/backpack/satchel/surgbag
	if(owner.current)
		if(ishuman(owner.current))
			var/mob/living/carbon/human/dreamer = owner.current
			var/datum/physiology/phy = dreamer.physiology
			dreamer.set_patron(/datum/patron/inhumen/graggar_zizo)
			old_cm = dreamer.cmode_music
			dreamer.cmode_music = 'sound/music/cmode/antag/combat_maniac.ogg'
			dreamer.adjust_skillrank(/datum/skill/combat/knives, 6, TRUE)
			dreamer.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
			dreamer.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
			dreamer.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
			dreamer.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
			dreamer.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
			phy.bleed_mod *= 0.5
			for(var/datum/status_effect/effect in dreamer.status_effects) //necessary to prevent exploits
				dreamer.remove_status_effect(effect)
			dreamer.modifier_set_stat_to("[type]", STATKEY_STR, 16)
			dreamer.modifier_set_stat_to("[type]", STATKEY_CON, 16)
			dreamer.modifier_set_stat_to("[type]", STATKEY_END, 16)
			combat_music_loop = new /datum/looping_sound/maniac_theme_song(dreamer, FALSE)
			dreamer.verbs += /mob/living/carbon/human/proc/toggle_maniac_music
			dreamer.verbs += /mob/living/carbon/human/proc/set_custom_music
			var/obj/item/organ/heart/heart = dreamer.getorganslot(ORGAN_SLOT_HEART)
			dreamer.remove_stat_modifier(STATMOD_AGE)
			if(heart) // clear any inscryptions, in case of being made maniac midround
				heart.inscryptions = list()
				heart.inscryption_keys = list()
				heart.maniacs2wonder_ids = list()
				heart.maniacs = list()
			dreamer.remove_stress(/datum/stress_event/saw_wonder)
			dreamer.remove_curse(/datum/curse/zizo)
			RegisterSignal(dreamer, COMSIG_LIVING_DEATH, PROC_REF(on_death))
		//	dreamer.remove_client_colour(/datum/client_colour/maniac_marked)
		owner.current.refresh_looping_ambience()
		hallucinations = owner.current.overlay_fullscreen("maniac", /atom/movable/screen/fullscreen/maniac)
	LAZYINITLIST(owner.learned_recipes)
	owner.learned_recipes |= recipe_progression[1]
	forge_villain_objectives()
	if(length(objectives))
		SEND_SOUND(owner.current, 'sound/villain/dreamer_warning.ogg')
		to_chat(owner.current, span_danger("[antag_memory]"))
		owner.announce_objectives()
	START_PROCESSING(SSobj, src)

/datum/antagonist/maniac/on_removal()
	STOP_PROCESSING(SSobj, src)
	if(owner.current)
		if(!silent)
			to_chat(owner.current,span_danger("I am no longer a MANIAC!"))
		if(ishuman(owner.current))
			var/mob/living/carbon/human/dreamer = owner.current
			var/datum/physiology/phy = dreamer.physiology
			dreamer.set_patron(/datum/patron/inhumen/zizo)
			dreamer.cmode_music = old_cm
			dreamer.remove_stat_modifier("[type]")
			phy.bleed_mod *= 2
			UnregisterSignal(dreamer, COMSIG_LIVING_DEATH)
			var/client/client = dreamer?.client
			if(client) //clear screenshake animation
				animate(client, dreamer.pixel_y)
		for(var/trait in final_traits)
			REMOVE_TRAIT(owner.current, trait, "[type]")
		owner.current.clear_fullscreen("maniac")
		owner.current.verbs -= /mob/living/carbon/human/proc/toggle_maniac_music
		owner.current.verbs -= /mob/living/carbon/human/proc/set_custom_music
	QDEL_LIST(wonders_made)
	wonders_made = null
	owner.learned_recipes -= recipe_progression
	owner.special_role = null
	hallucinations = null
	return ..()

/datum/antagonist/maniac/proc/set_keys()
	key_nums = list()
	num_keys = list()
	//We need 4 numbers and four keys
	for(var/i in 1 to 4)
		//Make the number first
		var/randumb
		while(!randumb || (randumb in num_keys))
			randumb = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
		//Make the key second
		var/rantelligent
		while(!rantelligent || (rantelligent in key_nums))
			rantelligent = uppertext("[pick(GLOB.alphabet)][pick(GLOB.alphabet)][pick(GLOB.alphabet)][pick(GLOB.alphabet)]")

		//Stick then in the lists, continue the loop
		num_keys[randumb] = rantelligent
		key_nums[rantelligent] = randumb

	sum_keys = 0
	for(var/i in num_keys)
		sum_keys += text2num(i)

/datum/antagonist/maniac/proc/forge_villain_objectives()
	var/datum/objective/maniac/wakeup = new()
	objectives += wakeup

/datum/antagonist/maniac/proc/agony(mob/living/carbon/dreamer)
	var/sound/im_sick = sound('sound/villain/imsick.ogg', TRUE, FALSE, CHANNEL_IMSICK, 100)
	SEND_SOUND(dreamer, im_sick)
	dreamer.overlay_fullscreen("dream", /atom/movable/screen/fullscreen/dreaming)
	dreamer.overlay_fullscreen("wakeup", /atom/movable/screen/fullscreen/dreaming/waking_up)
	for(var/trait in final_traits)
		ADD_TRAIT(dreamer, trait, "[type]")
	waking_up = TRUE
	sleep(10 SECONDS)
	dreamer.clear_fullscreen("wakeup")

/datum/antagonist/maniac/proc/spawn_trey_liam()
	var/turf/spawnturf
	var/obj/effect/landmark/treyliam/trey = locate(/obj/effect/landmark/treyliam) in GLOB.landmarks_list
	if(trey)
		spawnturf = get_turf(trey)
	if(spawnturf)
		var/mob/living/carbon/human/trey_liam = new /mob/living/carbon/human/species/human/space(spawnturf)
		trey_liam.fully_replace_character_name(trey_liam.name, "Trey Liam")
		trey_liam.gender = MALE
		trey_liam.skin_tone = "ffe0d1"

		trey_liam.set_hair_color("#999999", FALSE)
		trey_liam.set_facial_hair_color("#999999", FALSE)
		trey_liam.set_hair_style(/datum/sprite_accessory/hair/head/thickcurly, FALSE)
		trey_liam.set_facial_hair_style(/datum/sprite_accessory/hair/facial/know, FALSE)
		trey_liam.age = AGE_OLD
		trey_liam.equipOutfit(/datum/outfit/treyliam)
		trey_liam.regenerate_icons()
		trey_liam.update_body_parts()
		for(var/obj/structure/chair/chair in spawnturf)
			chair.buckle_mob(trey_liam)
			break
		return trey_liam
	return

/datum/antagonist/maniac/proc/wake_up()
	if(GLOB.maniac_highlander) // another Maniac has TRIUMPHED before we could
		if(src.owner && src.owner.current)
			var/straggler = src.owner.current
			to_chat(straggler, span_danger("IT'S NO USE! I CAN'T WAKE UP!"))
		return
	GLOB.maniac_highlander = 1
	STOP_PROCESSING(SSobj, src)
	triumphed = TRUE
	waking_up = FALSE
	var/mob/living/carbon/dreamer = owner.current
	dreamer.log_message("prayed their sum ([sum_keys]), beginning the Maniac TRIUMPH sequence.", LOG_GAME)
	message_admins("[ADMIN_LOOKUPFLW(dreamer)] as Maniac TRIUMPHED[sum_keys ? " with sum [sum_keys]" : ""].")
	// var/client/dreamer_client = dreamer.client // Trust me, we need it later
	to_chat(dreamer, "...It couldn't be.")
	dreamer.clear_fullscreen("dream")
	var/client/client = dreamer?.client
	if(client) //clear screenshake animation
		animate(client, dreamer.pixel_y)
	for(var/datum/objective/objective in objectives)
		objective.completed = TRUE
	// for(var/mob/connected_player in GLOB.player_list)
	// 	if(!connected_player.client)
	// 		continue
	// 	SEND_SOUND(connected_player, sound(null))
	// 	SEND_SOUND(connected_player, 'sound/villain/dreamer_win.ogg')
	var/mob/living/carbon/human/trey_liam = spawn_trey_liam()
	if(trey_liam)
		owner.adjust_triumphs(4) // Adjust triumphs here instead of at roundend
		owner.transfer_to(trey_liam)
		//Explodie all our wonders
		for(var/obj/structure/wonder/wondie as anything in wonders_made)
			if(istype(wondie))
				explosion(wondie, 8, 16, 32, 64)
		var/obj/item/organ/brain/brain = dreamer.getorganslot(ORGAN_SLOT_BRAIN)
		var/obj/item/bodypart/head/head = dreamer.get_bodypart(BODY_ZONE_HEAD)
		if(head)
			head.dismember(BURN)
			if(!QDELETED(head))
				qdel(head)
		if(brain)
			qdel(brain)
		cull_competitors(trey_liam)
		SEND_SOUND(trey_liam, 'sound/villain/dreamer_win.ogg')
		trey_liam.SetSleeping(25 SECONDS)
		trey_liam.add_stress(/datum/stress_event/maniac_woke_up)
		sleep(1.5 SECONDS)
		to_chat(trey_liam, span_deadsay("<span class='reallybig'>... WHERE AM I? ...</span>"))
		sleep(1.5 SECONDS)
		var/static/list/slop_lore = list(
			span_deadsay("... Rockhill? Vanderlin? No ... They don't exist ..."),
			span_deadsay("... My name is Trey. Trey Liam, Scientific Overseer ..."),
			span_deadsay("... I'm on the Aeon, a self sustaining ship, used to preserve what remains of humanity ..."),
			span_deadsay("... Launched into the stars, preserving their memories ... Their personalities ..."),
			span_deadsay("... Keeps them alive in vessels, oblivious to the catastrophe ..."),
			span_deadsay("... There is no hope left. Only the program lets me live through the avatars ..."),
			span_deadsay("... What have I done?! ..."),
		)
		for(var/slop in slop_lore)
			to_chat(trey_liam, slop)
			sleep(3 SECONDS)
		to_chat(trey_liam, span_big(span_deadsay("I have to go back, I have to go back, I have to go back to Vanderlin.")))
	else
		INVOKE_ASYNC(src, GLOBAL_PROC_REF(cant_wake_up), dreamer)
		cull_competitors(dreamer)
	// sleep(15 SECONDS)
	// to_chat(world, span_deadsay("<span class='reallybig'>The Maniac has TRIUMPHED!</span>"))
	// SSticker.declare_completion()

/proc/cant_wake_up(mob/living/target)
	if(!iscarbon(target))
		return
	ADD_TRAIT(target, TRAIT_SHAKY_SPEECH, TRAIT_GENERIC)
	target.Knockdown(10 SECONDS)
	to_chat(target, span_deadsay("<span class='reallybig'>I CAN'T WAKE UP.</span>"))
	target.say("I CAN'T WAKE UP!", spans = list("reallybig"), ignore_spam = TRUE)
	sleep(2 SECONDS)
	for(var/i in 1 to 10)
		to_chat(target, span_deadsay("<span class='reallybig'>ICANTWAKEUP</span>"))
		target.say("ICANTWAKEUP!!", spans = list("reallybig"), ignore_spam = TRUE)
		sleep(0.5 SECONDS)
	var/obj/item/organ/brain/brain = target.getorganslot(ORGAN_SLOT_BRAIN)
	var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head.dismember(BURN)
		if(!QDELETED(head))
			qdel(head)
	if(brain)
		qdel(brain)
	target.gib()

// Culls any living maniacs in the world apart from the victor.
/datum/antagonist/maniac/proc/cull_competitors(mob/living/carbon/victor)
	for(var/mob/living/carbon/C in GLOB.carbon_list - victor)
		var/datum/antagonist/maniac/competitor = C.mind?.has_antag_datum(/datum/antagonist/maniac)
		if(competitor)
			STOP_PROCESSING(SSobj, competitor)
			competitor.waking_up = FALSE
			C.clear_fullscreen("dream")
			C.clear_fullscreen("wakeup")
			//clear screenshake animation. traits need to be removed in case the guy ghosts in cmode
			var/client/cnc = C?.client
			if(cnc)
				animate(cnc, C.pixel_y)
			REMOVE_TRAIT(C, TRAIT_SCREENSHAKE, "/datum/antagonist/maniac")
			REMOVE_TRAIT(C, TRAIT_SCHIZO_AMBIENCE, "/datum/antagonist/maniac")
			C.log_message("was culled by the TRIUMPH of Maniac [key_name(victor)].", LOG_GAME)
			sleep(1 SECONDS)
			to_chat(C, span_userdanger("What?! No, no, this can't be!"))
			sleep(2 SECONDS)
			to_chat(C, span_userdanger("How can I be TOO LATE-"))
			sleep(1 SECONDS)
			INVOKE_ASYNC(src, GLOBAL_PROC_REF(cant_wake_up), C)
			QDEL_LIST(competitor.wonders_made)
			competitor.wonders_made = null

//TODO Collate
/datum/antagonist/roundend_report()
	var/traitorwin = TRUE

	to_chat(world, printplayer(owner))

	var/count = 0
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(objective.check_completion())
				to_chat(world, "<B>[objective.flavor] #[count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
			else
				to_chat(world, "<B>[objective.flavor] #[count]</B>: [objective.explanation_text] <span class='redtext'>Failure.</span>")
				traitorwin = FALSE
			count += objective.triumph_count

	var/special_role_text = lowertext(name)
	// if(!considered_alive(owner))
	// 	traitorwin = FALSE

	if(traitorwin)
		// if(count)
		// 	if(owner)
		// 		owner.adjust_triumphs(count)
		to_chat(world, span_greentext("The [special_role_text] has TRIUMPHED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, span_redtext("The [special_role_text] has FAILED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

/obj/structure/maniac_return_machine
	name = "Vanderlin Program"
	desc = "The Vanderlin Program was created by ██████████ in the year ████, allowing humans to explore hostile worlds and environments through remote-controlled bodies without danger to the user's life."
	icon_state = "pylon"
	icon = 'icons/roguetown/misc/mana_pylon.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	plane = GAME_PLANE_UPPER
	layer = ABOVE_MOB_LAYER
	light_outer_range = MINIMUM_USEFUL_LIGHT_RANGE
	light_color = COLOR_CYAN
	density = TRUE

/obj/structure/maniac_return_machine/attack_hand(mob/user)
	if(user.mind?.has_antag_datum(/datum/antagonist/maniac))
		to_chat(user, span_notice("I begin plugging myself back into [src]."))
		if(do_after(user, 10 SECONDS, src))
			SEND_SOUND(user, sound(null))
			var/mob/living/carbon/spirit/O = new /mob/living/carbon/spirit(get_turf(src))
			O.ckey = user.ckey
			O.returntolobby()
			user.status_flags |= GODMODE // To prevent Trey Liam from dying
		return TRUE
	. = ..()


/mob/living/carbon/human/proc/toggle_maniac_music() //BRO.
	set name = "Toggle Theme Music"
	set category = "MANIAC"

	var/datum/antagonist/maniac/dreamer = src.mind.has_antag_datum(/datum/antagonist/maniac)
	if(!dreamer)
		return
	dreamer.music_enabled = !dreamer.music_enabled
	if(dreamer.music_enabled)
		dreamer.combat_music_loop.start()
		to_chat(src, span_notice("Theme Song Active"))
	else
		dreamer.combat_music_loop.stop()
		to_chat(src, span_notice("Theme Song disabled."))

/mob/living/carbon/human/proc/set_custom_music()
	set name = "Set Custom Theme Music"
	set category = "MANIAC"

	var/datum/antagonist/maniac/dreamer = src.mind.has_antag_datum(/datum/antagonist/maniac)
	if(!dreamer)
		return

	if(dreamer.music_enabled)
		to_chat(src, span_warning("theme song active, can't set a new one."))
		return

	if(dreamer.last_music_change)
		if(world.time < dreamer.last_music_change + 3 MINUTES)
			to_chat(src, span_warning("Can't set a new theme song yet."))
			return

	var/infile = input(src, "Choose a custom OGG file for your theme song", src) as null|file
	if(!infile)
		return

	var/filename = SANITIZE_FILENAME("[infile]")
	var/file_ext = lowertext(copytext(filename, -4))
	var/file_size = length(infile)

	if(file_ext != ".ogg")
		to_chat(src, span_warning("The file must be an OGG."))
		return
	if(file_size > 6485760) // 6MB limit
		to_chat(src, span_warning("The file is too large. Maximum size is 6 MB."))
		return

	fcopy(infile, "data/jukeboxUploads/[src.ckey]/[filename]")
	dreamer.custom_music_track = file("data/jukeboxUploads/[src.ckey]/[filename]")

	dreamer.last_music_change = world.time
	dreamer.curthemefile = dreamer.custom_music_track
	dreamer.combat_music_loop.mid_sounds = list(dreamer.custom_music_track)
	dreamer.combat_music_loop.cursound = null
	src.cmode_music = dreamer.custom_music_track

	to_chat(src, span_notice("Done, check your combat mode music and/or theme song."))

/datum/looping_sound/maniac_theme_song
	mid_sounds = list()
	mid_length = 240 SECONDS
	volume = 100
	falloff_exponent = 5
	extra_range = 6
	channel = CHANNEL_IMSICK
	persistent_loop = TRUE

/datum/antagonist/maniac/proc/on_death(mob/living/source) //Upon death, this should basically stop the music.
	SIGNAL_HANDLER

	if(combat_music_loop)
		combat_music_loop.stop()
	music_enabled = FALSE
