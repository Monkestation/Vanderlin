GLOBAL_LIST_EMPTY(secret_door_managers)

/// Secret door managers are used for a network of hidden doors.
/// They allow the use of verbal passwords with VIPs, adding memories for passwords, and syncing these passwords together.
/// If a hidden door grid doesn't use passwords it doesn't necessarily need this, but it is capable of working with a mix of both
/// doors that use phrases and ones that don't.
/// Usually these are created through the secret door creator effect if one doesn't already exist.
/datum/secret_door_manager
	/// ID index for GLOB list
	var/id
	/// Trait required to access
	var/accessor_trait
	/// List of VIP roles who can edit our secret doors
	var/list/vips
	/// The name the doors will be referred to by in the memory note
	var/memory_name
	/// List of doors managed by this datum
	var/list/doors = list()
	/// Phrase spoken to open the door
	/// don't set this directly unless it's part of initialization. use set_phrase()
	var/open_phrase

/datum/secret_door_manager/New(_id, _accessor_trait, list/_vips, _memory_name, _open_phrase)
	if(!_id)
		stack_trace("[src] ([type]) has no ID!")
		qdel(src)
		return
	if(GLOB.secret_door_managers[_id])
		stack_trace("[src] tried to initialize with ID [id] when it has already been added!")
		qdel(src)
		return
	RegisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN, PROC_REF(on_job_spawn))
	id = _id
	accessor_trait = _accessor_trait
	vips = _vips
	memory_name = _memory_name
	open_phrase = _open_phrase || "[open_word()] [magic_word()]"
	GLOB.secret_door_managers[id] = src

/datum/secret_door_manager/Destroy(force, ...)
	UnregisterSignal(SSdcs, COMSIG_GLOB_JOB_AFTER_SPAWN)
	for(var/obj/structure/door/secret/door in doors)
		UnregisterSignal(door, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_HEAR))
	GLOB.secret_door_managers -= id
	. = ..()

/datum/secret_door_manager/proc/on_job_spawn(source, datum/job/job, mob/living/spawned, client/player_client)
	SIGNAL_HANDLER
	if((job.type in vips) || (accessor_trait && (accessor_trait in job.mind_traits) || (accessor_trait in job.traits)))
		var/msg = "The [memory_name] secret doors answer to: '[open_phrase]'"
		spawned.mind?.store_memory(msg)

/datum/secret_door_manager/proc/add_door(obj/structure/door/secret/new_door)
	if(new_door in doors)
		return
	RegisterSignal(new_door, COMSIG_MOVABLE_HEAR, PROC_REF(door_hear))
	RegisterSignal(new_door, COMSIG_PARENT_QDELETING, PROC_REF(clear_door))
	doors |= new_door

/datum/secret_door_manager/proc/remove_door(obj/structure/door/secret/to_remove)
	var/obj/structure/door/old_door = locate(to_remove) in doors
	if(!old_door)
		return
	UnregisterSignal(old_door, list(COMSIG_PARENT_QDELETING, COMSIG_MOVABLE_HEAR))
	doors -= old_door

/datum/secret_door_manager/proc/clear_door(obj/structure/door/source)
	SIGNAL_HANDLER
	doors -= source

/datum/secret_door_manager/proc/door_hear(obj/structure/door/secret/source, list/hearing_args)
	var/mob/living/speaker = hearing_args[HEARING_SPEAKER]
	if(!istype(speaker))
		return
	if(speaker == source)
		return // in the event you have added living people to the door listener like a fucking buffoon
	if(!source.use_phrases)
		return
	if(source.obj_broken) //door is broken
		return
	if(get_dist(speaker, source) > source.speaking_distance)
		return
	var/language = hearing_args[HEARING_LANGUAGE]
	if(!(language in source.lang))
		return

	var/message2recognize = SANITIZE_HEAR_MESSAGE(hearing_args[HEARING_RAW_MESSAGE])
	if(findtext(message2recognize, open_phrase))
		if(source.door_opened)
			source.force_closed()
		else
			source.force_open()
		return

	if(length(vips) > 0) // VIP check
		var/datum/job/J = speaker.mind?.assigned_role
		while(istype(J))
			if(is_type_in_list(J, vips))
				break
			J = (J != J.parent_job ? J.parent_job : null)
		if(!istype(J))
			return

	var/say_string
	if(findtext(message2recognize, "help"))
		say_string = "'say phrase'... 'set phrase'..."
	else if(findtext(message2recognize, "say phrase"))
		say_string = "[open_phrase]..."
	else if(speaker.client && findtext(message2recognize, "set phrase"))
		var/new_pass = stripped_input(speaker, "What should the new open phrase be?", max_length = 32)
		if(!new_pass || QDELETED(speaker) || QDELETED(source) || QDELETED(src))
			return
		var/sanitized_pass = SANITIZE_HEAR_MESSAGE(new_pass)
		if(length(sanitized_pass) > 0)
			open_phrase = sanitized_pass
			say_string = "You may open us with '[open_phrase]' now..."
		else
			say_string = "A poor choice."
	if(say_string)
		source.send_speech(span_purple(say_string), source.speaking_distance, source, message_language = language, message_mods = list(WHISPER_MODE = MODE_WHISPER))

/proc/open_word()
	return pick("open", "pass", "part", "break", "reveal", "unbar", "extend", "widen", "unfold", "rise",
		"remember", "end the", "bring", "forget", "endless", "forgotten")

/proc/magic_word()
	return pick("abyss", "fire", "wind", "shadow", "nite", "oblivion", "void", "time", "dead", "decay", "endless",
		"gods", "ancient", "twisted", "corrupt", "secrets", "lore", "text", "sacrifice", "deal", "pact", "bargain", "dreams",
		"nitemare", "vision", "hunger",	"lust")


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

	/// Used for traits that automatically indicate there is a hidden door here.
	var/accessor_trait
	/// The perception DC to use this door
	var/hidden_dc = 10
	/// Does this door respond to open phrases? If so, it also needs to be on a hidden door manager.
	var/use_phrases = FALSE
	/// How far this door can be heard from, or hear someone else
	var/speaking_distance = 1
	/// What languages this door is capable of speaking if it uses phrases
	var/lang = list(/datum/language/common)

/obj/structure/door/secret/Initialize(mapload, ...)
	AddElement(/datum/element/update_icon_blocker)
	. = ..()
	become_hearing_sensitive()

/obj/structure/door/secret/Destroy(force)
	lose_hearing_sensitivity()
	return ..()

/obj/structure/door/proc/add_to_door_manager(id)
	if(!id)
		return
	var/datum/secret_door_manager/manager = GLOB.secret_door_managers[id]
	if(!manager)
		return
	manager.add_door(src)

/obj/structure/door/secret/redstone_triggered(mob/user)
	if(!door_opened)
		force_open()
	else
		force_closed()

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
	if(isobserver(user))
		. += span_purple("There's a hidden door here...")
		return
	if(isliving(user))
		var/mob/living/L = user
		if(HAS_MIND_TRAIT(user, accessor_trait))
			. += span_purple("There's a hidden door here...")
		else
			var/bonuses = (HAS_TRAIT(user, TRAIT_THIEVESGUILD) || HAS_TRAIT(user, TRAIT_ASSASSIN)) ? 2 : 0
			if(L.STAPER + bonuses >= hidden_dc)
				. += span_purple("Something isn't right about this wall...")

/obj/structure/door/secret/Open(silent = FALSE)
	switching_states = TRUE
	if(!silent)
		playsound(src, open_sound, 90)
	if(!windowed)
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
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
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
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

/obj/structure/door/secret/on_magic_unlock(datum/source, datum/action/cooldown/spell/aoe/knock, mob/living/caster)
	if(!(knock.antimagic_flags & MAGIC_RESISTANCE))
		return ..()

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
		mouse_opacity = MOUSE_OPACITY_ICON
		set_opacity(TRUE)
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	air_update_turf(TRUE)
	switching_states = FALSE
	lock()

/obj/structure/door/secret/force_closed()
	switching_states = TRUE
	if(!windowed)
		mouse_opacity = MOUSE_OPACITY_ICON
		set_opacity(TRUE)
	animate(src, pixel_x = 0, alpha = 255, time = animate_time)
	sleep(animate_time)
	density = TRUE
	door_opened = FALSE
	layer = CLOSED_DOOR_LAYER
	air_update_turf(TRUE)
	switching_states = FALSE



///// MAPPERS /////
/obj/effect/mapping_helpers/secret_door_creator
	name = "Secret Door Creator"
	icon = 'icons/effects/hidden_door.dmi'
	icon_state = "hidden_door"

	var/redstone_id
	var/override_floor = TRUE //Will only use the below as the floor tile if true. Source turf have at least 1 baseturf to use false
	var/turf/open/floor_turf = /turf/open/floor/blocks
	var/hidden_dc = 10
	var/use_phrases = FALSE
	var/list/lang = list(/datum/language/common)

	/// this information is all for the door manager
	var/manager_id
	/// this is used by both the door manager and a nonlinked door
	var/accessor_trait
	var/list/vips = list()
	var/memory_name
	/// optional preset open phrase for a door manager
	var/open_phrase

/obj/effect/mapping_helpers/secret_door_creator/Initialize()
	if(!isclosedturf(get_turf(src)))
		return ..()
	var/turf/closed/source_turf = get_turf(src)
	var/obj/structure/door/secret/new_door = new(source_turf)

	new_door.accessor_trait = accessor_trait
	new_door.hidden_dc = hidden_dc
	new_door.use_phrases = use_phrases
	new_door.lang = lang

	if(manager_id)
		var/datum/secret_door_manager/manager = GLOB.secret_door_managers[manager_id]
		if(!manager)
			manager = new /datum/secret_door_manager(manager_id, accessor_trait, vips, memory_name, open_phrase)
		manager.add_door(new_door)

	new_door.name = source_turf.name
	new_door.desc = source_turf.desc
	new_door.icon = source_turf.icon
	new_door.icon_state = source_turf.icon_state
	new_door.dir = source_turf.dir
	new_door.color = source_turf.color

	new_door.uses_integrity = source_turf.uses_integrity
	if(new_door.uses_integrity)
		new_door.max_integrity = source_turf.max_integrity
		new_door.update_integrity(new_door.max_integrity, FALSE)
		new_door.integrity_failure = source_turf.integrity_failure
	new_door.damage_deflection = source_turf.damage_deflection
	new_door.explosion_block = source_turf.explosion_block
	new_door.blade_dulling = source_turf.blade_dulling
	new_door.attacked_sound = source_turf.attacked_sound
	new_door.break_sound = source_turf.break_sound
	new_door.resistance_flags = source_turf.resistance_flags

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
	color = "#792BD0"
	override_floor = FALSE
	hidden_dc = 14
	use_phrases = TRUE
	lang = list(/datum/language/common)

	manager_id = "keep"
	accessor_trait = TRAIT_KNOW_KEEP_DOORS
	memory_name = "keep's"
	vips = list(/datum/job/lord, /datum/job/consort, /datum/job/prince, /datum/job/hand, /datum/job/butler, /datum/job/archivist)

/obj/effect/mapping_helpers/secret_door_creator/keep/Initialize()
	if(SSmapping.config.map_name == "Rosewood")
		lang = list(/datum/language/common, /datum/language/elvish)
	. = ..()


/obj/effect/mapping_helpers/secret_door_creator/inquisition
	name = "Inquisition Secret Door Creator"
	color = "#d02b2b"
	override_floor = FALSE
	hidden_dc = 14
	use_phrases = TRUE
	lang = list(/datum/language/oldpsydonic)

	manager_id = "inquisition"
	accessor_trait = TRAIT_KNOW_INQUISITION_DOORS
	memory_name = "Oratorium's"
	vips = list(/datum/job/inquisitor)

/obj/effect/mapping_helpers/secret_door_creator/inquisition/Initialize()
	if(SSmapping.config.map_name == "Rosewood")
		memory_name = "Order's"
		lang = list(/datum/language/elvish)
	. = ..()


/obj/effect/mapping_helpers/secret_door_creator/thieves_guild
	name = "Thieves' Guild Secret Door Creator"
	color = "#3ed02b"
	override_floor = FALSE
	hidden_dc = 13
	use_phrases = TRUE
	lang = list(/datum/language/thievescant, /datum/language/common)

	manager_id = "thief"
	accessor_trait = TRAIT_KNOW_THIEF_DOORS
	memory_name = "thieves' guild's"
	vips = list(/datum/job/matron)
