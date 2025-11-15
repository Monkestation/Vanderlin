GLOBAL_LIST_EMPTY(keep_doors)
GLOBAL_LIST_EMPTY(thieves_guild_doors)

/obj/structure/door/secret
	name = "wall"
	icon = 'icons/turf/smooth/walls/stone_brick.dmi'
	icon_state = MAP_SWITCH("stone_brick", "stone_brick-0")
	hover_color = "#607d65"
	resistance_flags = NONE
	max_integrity = 9999
	damage_deflection = 30
	layer = ABOVE_MOB_LAYER

	lock = /datum/lock/locked

	smoothing_flags = NONE
	smoothing_groups = SMOOTH_GROUP_DOOR_SECRET
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET +  SMOOTH_GROUP_CLOSED_WALL

	can_add_lock = FALSE
	can_knock = FALSE
	redstone_structure = TRUE

	repair_thresholds = null
	broken_repair = null
	repair_skill = null
	metalizer_result = null

	//the perception DC to use this door
	var/hidden_dc = 10

	var/open_phrase = "open sesame"

	var/speaking_distance = 1
	var/lang = /datum/language/common
	var/list/vip
	var/vipmessage

/obj/structure/door/secret/Initialize(mapload, ...)
	AddElement(/datum/element/update_icon_blocker)
	. = ..()
	become_hearing_sensitive()
	open_phrase = open_word() + " " + magic_word()

/obj/structure/door/secret/Destroy(force)
	lose_hearing_sensitivity()
	return ..()

/obj/structure/door/secret/redstone_triggered(mob/user)
	if(!door_opened)
		force_open()
	else
		force_closed()

///// DOOR TYPES //////
/obj/structure/door/secret/vault
	vip = list(
	/datum/job/lord,
	/datum/job/consort,
	/datum/job/steward,
	/datum/job/hand,
	)

/obj/structure/door/secret/merchant
	vip = list(
		/datum/job/merchant,
	)

/obj/structure/door/secret/wizard //for wizard tower
	vip = list(
		/datum/job/magician,
		/datum/job/mageapprentice,
		/datum/job/archivist,
	)
	//make me look like an arcane door

/obj/structure/door/secret/rattle()
	return

/obj/structure/door/secret/attack_hand(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_notice("I start feeling around [src]"))
	if(!do_after(user, 1.5 SECONDS, src))
		return

//can't kick it open, but you can kick it closed
/obj/structure/door/secret/onkick(mob/user)
	if(locked())
		return
	..()

/obj/structure/door/secret/examine(mob/user)
	. = ..()
	if(isliving(user))
		var/mob/living/L = user
		// they're trained at this
		var/bonuses = (HAS_TRAIT(user, TRAIT_THIEVESGUILD) || HAS_TRAIT(user, TRAIT_ASSASSIN)) ? 2 : 0
		if(L.stat_roll(STATKEY_PER, 25, hidden_dc - bonuses - 1))
			. += span_purple("Something's not right about this wall...")

/obj/structure/door/secret/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), original_message)
	var/mob/living/carbon/human/H = speaker
	if(speaker == src) //door speaking to itself
		return FALSE
	var/distance = get_dist(speaker, src)
	if(distance > speaking_distance)
		return FALSE
	if(obj_broken) //door is broken
		return FALSE
	if(!ishuman(speaker))
		return FALSE

	var/message2recognize = SANITIZE_HEAR_MESSAGE(original_message)

	if(is_type_in_list(H.mind?.assigned_role, vip)) //are they a VIP?
		var/list/mods = list(WHISPER_MODE = MODE_WHISPER)
		if(findtext(message2recognize, "help"))
			send_speech(span_purple("'say phrase'... 'set phrase'..."), speaking_distance, src, message_language = lang, message_mods = mods)
			return TRUE
		if(findtext(message2recognize, "say phrase"))
			send_speech(span_purple("[open_phrase]..."), speaking_distance, src, message_language = lang, message_mods = mods)
			return TRUE
		if(findtext(message2recognize, "set phrase"))
			var/new_pass = stripped_input(H, "What should the new close phrase be?")
			open_phrase = new_pass
			send_speech(span_purple("It is done, [flavor_name()]..."), speaking_distance, src, message_language = lang, message_mods = mods)
			return TRUE

	if(findtext(message2recognize, open_phrase))
		if(!door_opened)
			force_open()
		else
			force_closed()
		return TRUE

/obj/structure/door/secret/Open(silent = FALSE)
	switching_states = TRUE
	if(!silent)
		playsound(src, open_sound, 90)
	if(!windowed)
		set_opacity(FALSE)
	animate(src, pixel_x = -22, alpha = 50, time = animate_time)
	sleep(animate_time)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(TRUE)
	switching_states = FALSE

	if(close_delay > 0)
		addtimer(CALLBACK(src, PROC_REF(Close), silent), close_delay)

/obj/structure/door/secret/force_open()
	switching_states = TRUE
	if(!windowed)
		set_opacity(FALSE)
	animate(src, pixel_x = -22, alpha = 50, time = animate_time)
	sleep(animate_time)
	density = FALSE
	door_opened = TRUE
	layer = OPEN_DOOR_LAYER
	air_update_turf(TRUE)
	switching_states = FALSE

	if(close_delay > 0)
		addtimer(CALLBACK(src, PROC_REF(Close)), close_delay)

/obj/structure/door/secret/Close(silent = FALSE)
	if(switching_states || !door_opened)
		return
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		return
	switching_states = TRUE
	if(!silent)
		playsound(src, close_sound, 90)
	animate(src, pixel_x = 0, alpha = 255, time = animate_time)
	sleep(animate_time)
	density = TRUE
	if(!windowed)
		set_opacity(TRUE)
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	air_update_turf(TRUE)
	switching_states = FALSE
	lock()

/obj/structure/door/secret/force_closed()
	switching_states = TRUE
	if(!windowed)
		set_opacity(TRUE)
	animate(src, pixel_x = 0, alpha = 255, time = animate_time)
	sleep(animate_time)
	density = TRUE
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	air_update_turf(TRUE)
	switching_states = FALSE

/proc/open_word()
	var/list/open_word = list(
		"open",
		"pass",
		"part",
		"break",
		"reveal",
		"unbar",
		"gape", //You wanted this.
		"extend",
		"widen",
		"unfold",
		"rise"
		)
	return pick(open_word)

/proc/close_word()
	var/list/close_word = list(
		"close",
		"seal",
		"still",
		"fade",
		"retreat",
		"consume",
		"envelope",
		"hide",
		"halt",
		"cease",
		"vanish",
		"end"
		)
	return pick(close_word)


/proc/magic_word()
	var/list/magic_word = list(
		"sesame",
		"abyss",
		"fire",
		"wind",
		"earth",
		"shadow",
		"nite",
		"oblivion",
		"void",
		"time",
		"dead",
		"decay",
		"gods",
		"ancient",
		"twisted",
		"corrupt",
		"secrets",
		"lore",
		"text",
		"ritual",
		"sacrifice",
		"deal",
		"pact",
		"bargain",
		"ritual",
		"dream",
		"nitemare",
		"vision",
		"hunger",
		"lust",
		"necra",
		"noc",
		"psydon"
		)
	return pick(magic_word)

/proc/flavor_name()
	var/list/flavor_name = list(
		"my friend",
		"love",
		"my love",
		"honey",
		"darling",
		"stranger",
		"companion",
		"mate",
		"you harlot",
		"comrade",
		"fellow",
		"chum",
		"bafoon"
		)
	return pick(flavor_name)

/obj/structure/door/secret/proc/set_phrase(new_phrase)
	open_phrase = new_phrase

///// KEEP DOORS /////
/obj/structure/door/secret/keep
	hidden_dc = 14
	vip = list(
		/datum/job/lord,
		/datum/job/consort,
		/datum/job/prince,
		/datum/job/hand,
		/datum/job/butler,
	)

/obj/structure/door/secret/keep/Initialize()
	. = ..()
	if(length(GLOB.keep_doors) > 0)
		var/obj/structure/door/secret/D = GLOB.keep_doors[1]
		open_phrase = D.open_phrase
	GLOB.keep_doors |= src

/obj/structure/door/secret/keep/Destroy()
	GLOB.keep_doors -= src
	return ..()

/obj/structure/door/secret/keep/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = speaker

	var/message2recognize = SANITIZE_HEAR_MESSAGE(raw_message)
	if(is_type_in_list(H.mind?.assigned_role, vip) && findtext(message2recognize, "set phrase"))
		for(var/obj/structure/door/secret/D in GLOB.keep_doors)
			D.set_phrase(open_phrase)
	return TRUE

/obj/structure/door/secret/keep/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_KNOWKEEPPLANS))
		. += span_purple("There's a hidden door here...")

/obj/structure/lever/hidden/keep
	hidden_dc = 14

/obj/structure/lever/hidden/keep/feel_button(mob/living/user, ignore_dc = FALSE)
	// they're trained at this
	var/bonuses = (HAS_TRAIT(user, TRAIT_THIEVESGUILD) || HAS_TRAIT(user, TRAIT_ASSASSIN)) ? 2 : 0
	if(HAS_TRAIT(user, TRAIT_KNOWKEEPPLANS) || (user.STAPER + bonuses) >= hidden_dc || ignore_dc)
		..(user, ignore_dc = TRUE)// passes onto parent dc check, otherwise someone who knows the keep plans would still need perception

/proc/know_keep_door_password(mob/living/carbon/human/H)
	var/obj/structure/door/secret/D = GLOB.keep_doors[1]
	var/msg = "The keep's secret doors answer to: '[D.open_phrase]'"
	to_chat(H, span_notice(msg))
	H.mind?.store_memory(msg)

///// THIEVES GUILD DOORS /////
/obj/structure/door/secret/thieves_guild
	vip = list(
		/datum/job/matron,
	)
	lang = /datum/language/thievescant

/obj/structure/door/secret/thieves_guild/Initialize()
	. = ..()
	if(length(GLOB.thieves_guild_doors))
		var/obj/structure/door/secret/D = GLOB.thieves_guild_doors[1]
		open_phrase = D.open_phrase
	GLOB.thieves_guild_doors |= src

/obj/structure/door/secret/thieves_guild/Destroy()
	GLOB.thieves_guild_doors -= src
	return ..()

/obj/structure/door/secret/thieves_guild/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = speaker

	var/message2recognize = SANITIZE_HEAR_MESSAGE(raw_message)
	if((is_type_in_list(H.mind?.assigned_role, vip)) && findtext(message2recognize, "set phrase"))
		for(var/obj/structure/door/secret/D in GLOB.keep_doors)
			D.set_phrase(open_phrase)
	return TRUE


///// MAPPERS /////
/obj/effect/mapping_helpers/secret_door_creator
	name = "Secret door creator: Turns the given wall into a hidden door with a random password."
	icon = 'icons/effects/hidden_door.dmi'
	icon_state = "hidden_door"

	var/redstone_id

	var/obj/structure/door/secret/door_type = /obj/structure/door/secret
	var/datum/language/given_lang = /datum/language/thievescant //DEPRECATED
	var/list/vips = list("Thief", "Matron") //DEPRECATED
	var/vip_message = "Thief and Matron" //DEPRECATED

	var/override_floor = TRUE //Will only use the below as the floor tile if true. Source turf have at least 1 baseturf to use false
	var/turf/open/floor_turf = /turf/open/floor/blocks

/obj/effect/mapping_helpers/secret_door_creator/Initialize()
	if(!isclosedturf(get_turf(src)))
		return ..()
	var/turf/closed/source_turf = get_turf(src)
	var/obj/structure/door/secret/new_door = new door_type(source_turf)

	new_door.name = source_turf.name
	new_door.desc = source_turf.desc
	new_door.icon = source_turf.icon
	new_door.icon_state = source_turf.icon_state

	var/smooth = source_turf.smoothing_flags & ~SMOOTH_QUEUED
	if(smooth)
		new_door.smoothing_flags |= smooth
		new_door.smoothing_icon = initial(source_turf.icon_state)
		QUEUE_SMOOTH(new_door)
		QUEUE_SMOOTH_NEIGHBORS(new_door)

	if(redstone_id)
		new_door.redstone_id = redstone_id
		GLOB.redstone_objs += new_door
		new_door.LateInitialize()

	if(override_floor || length(source_turf.baseturfs) < 1)
		source_turf.ChangeTurf(floor_turf)
	else
		source_turf.ChangeTurf(source_turf.baseturfs[1])

	. = ..()

/obj/effect/mapping_helpers/secret_door_creator/keep
	name = "Keep Secret Door Creator"
	door_type = /obj/structure/door/secret/keep
	override_floor = FALSE
