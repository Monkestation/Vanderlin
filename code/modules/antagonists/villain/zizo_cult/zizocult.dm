/datum/antagonist/zizocultist
	name = "Zizoid Lackey"
	roundend_category = "Zizoid Cultists"
	antagpanel_category = "Zizoid Cult"
	job_rank = ROLE_ZIZOIDCULTIST
	antag_hud_type = ANTAG_HUD_ZIZOID
	antag_hud_name = "zizoid_lackey"
	confess_lines = list(
		"DEATH TO THE TEN!",
		"PRAISE ZIZO!",
		"I AM THE FUTURE!",
		"NO GODS! ONLY MASTERS!",
	)
	var/islesser = TRUE
	var/change_stats = TRUE

	innate_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_VILLAIN,
		TRAIT_CABAL,
	)

/datum/antagonist/zizocultist/zizo_knight
	change_stats = FALSE

/datum/antagonist/zizocultist/leader
	name = "Zizoid Cultist"
	antag_hud_type = ANTAG_HUD_ZIZOID
	antag_hud_name = "zizoid"
	islesser = FALSE
	innate_traits = list(
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_STEELHEARTED,
		TRAIT_NOMOOD,
		TRAIT_VILLAIN,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_CABAL,
	)

/datum/antagonist/zizocultist/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/zizocultist/leader))
		return span_boldnotice("OUR LEADER!")
	if(istype(examined_datum, /datum/antagonist/zizocultist))
		return span_boldnotice("A lackey for the future.")
	if(istype(examined_datum, /datum/antagonist/assassin))
		return span_boldnotice("A GRAGGAROID! A CULTIST OF GRAGGAR!")

/datum/antagonist/zizocultist/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	SSmapping.retainer.cultists |= owner
	H.set_patron(/datum/patron/inhumen/zizo)

	owner.special_role = "Zizoid Lackey"
	H.cmode_music = 'sound/music/cmode/antag/combat_cult.ogg'
	H.playsound_local(get_turf(H), 'sound/music/maniac.ogg', 80, FALSE, pressure_affected = FALSE)
	add_verb(H, /mob/living/carbon/human/proc/communicate)

	if(change_stats)
		H.change_stat(STATKEY_STR, 2)
		H.clamped_adjust_skillrank(/datum/skill/misc/reading, 3, 3, TRUE)

	if(islesser)
		add_objective(/datum/objective/zizoserve)
		if(!change_stats)
			return
		H.clamped_adjust_skillrank(/datum/skill/combat/knives, 2, 3, TRUE)
		H.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 3, TRUE)
		H.clamped_adjust_skillrank(/datum/skill/combat/polearms, 2, 3, TRUE)
		H.change_stat(STATKEY_INT, -2)
		H.grant_language(/datum/language/undead)
		return

	add_objective(/datum/objective/zizo)
	owner.special_role = ROLE_ZIZOIDCULTIST
	add_verb(H, /mob/living/carbon/human/proc/release_minion)
	if(!change_stats)
		return
	H.clamped_adjust_skillrank(/datum/skill/combat/knives, 4, 4, TRUE)
	H.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
	H.clamped_adjust_skillrank(/datum/skill/combat/wrestling, 5, 5, TRUE)
	H.clamped_adjust_skillrank(/datum/skill/misc/athletics, 4, 4, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 3)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_SPD, 4)
	H.change_stat(STATKEY_INT, 5)
	H.grant_language(/datum/language/undead)

/datum/antagonist/zizocultist/greet()
	to_chat(owner, span_danger("I'm a lackey to the LEADER. A new future begins."))
	owner.announce_objectives()

/datum/antagonist/zizocultist/leader/greet()
	to_chat(owner, span_danger("I'm a cultist to the ALMIGHTY. They call it the UNSPEAKABLE. I require LACKEYS to make my RITUALS easier. I SHALL ASCEND."))
	owner.announce_objectives()

/datum/antagonist/zizocultist/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.current == SSticker.rulermob)
			return FALSE
		if(new_owner.assigned_role.title in GLOB.church_positions)
			return FALSE
		if(new_owner.assigned_role.title in GLOB.inquisition_positions)
			return FALSE
		if(new_owner.unconvertable)
			return FALSE
		if(new_owner.current && HAS_TRAIT(new_owner.current, TRAIT_MINDSHIELD))
			return FALSE

/datum/antagonist/zizocultist/proc/add_cultist(datum/mind/cult_mind)
	cult_mind.add_antag_datum(/datum/antagonist/zizocultist)
	return TRUE

/datum/objective/zizo
	name = "ASCEND"
	explanation_text = "Ensure that I ascend."
	team_explanation_text = "Ensure that I ascend."
	triumph_count = 5

/datum/objective/zizo/check_completion()
	if(SSmapping.retainer.cult_ascended)
		return TRUE

/datum/objective/zizoserve
	name = "Serve your Leader"
	explanation_text = "Serve your leader and ensure that they ascend."
	team_explanation_text = "Serve your leader and ensure that they ascend."
	triumph_count = 3

/datum/objective/zizoserve/check_completion()
	if(SSmapping.retainer.cult_ascended)
		return TRUE

/datum/antagonist/zizocultist/proc/add_objective(datum/objective/O)
	var/datum/objective/V = new O
	objectives += V

/datum/antagonist/zizocultist/proc/remove_objective(datum/objective/O)
	objectives -= O

/datum/antagonist/zizocultist/roundend_report()
	var/traitorwin = TRUE

	to_chat(world, printplayer(owner))

	var/count = 0
	if(islesser) // don't need to spam up the chat with all spawn
		if(objectives.len)//If the traitor had no objectives, don't need to process this.
			for(var/datum/objective/objective in objectives)
				objective.update_explanation_text()
				if(objective.check_completion())
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				else
					to_chat(owner, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='redtext'>Failure.</span>")
					traitorwin = FALSE
				count += objective.triumph_count
	else
		if(objectives.len)//If the traitor had no objectives, don't need to process this.
			for(var/datum/objective/objective in objectives)
				objective.update_explanation_text()
				if(objective.check_completion())
					to_chat(world, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
				else
					to_chat(world, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='redtext'>Failure.</span>")
					traitorwin = FALSE
				count += objective.triumph_count

	var/special_role_text = lowertext(name)
	if(traitorwin)
		if(count)
			if(owner)
				owner.adjust_triumphs(count)
		to_chat(world, span_greentext(">The [special_role_text] has TRIUMPHED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, span_redtext("The [special_role_text] has FAILED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)

// VERBS

/mob/living/carbon/human/proc/praise()
	set name = "Praise the Dark Lady!"
	set category = "RoleUnique.Zizo"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	record_round_statistic(STATS_ZIZO_PRAISED)
	audible_message("\The [src] praises <span class='bold'>Zizo</span>!")
	playsound(src, 'sound/vo/cult/praise.ogg', 45, 1)
	log_say("[src] has praised zizo! (zizo cultist verb)")

/mob/living/carbon/human/proc/communicate()
	set name = "Communicate with Cult"
	set category = "RoleUnique.Zizo"

	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return

	var/mob/living/carbon/human/H = src
	var/speak = input("What do you speak of?", "ZIZO") as text|null
	if(!speak)
		return
	whisper("O schlet'a ty'schkotot ty'skvoro...")
	sleep(5)
	if(stat >= UNCONSCIOUS || !can_speak_vocal())
		return
	whisper("[speak]")

	for(var/datum/mind/V in SSmapping.retainer.cultists)
		to_chat(V, "<span style = \"font-size:110%; font-weight:bold\"><span style = 'color:#8a13bd'>A message from </span><span style = 'color:#[H.voice_color]'>[src.real_name]</span>: [speak]</span>")
		playsound_local(V.current, 'sound/vo/cult/skvor.ogg', 100)

	log_telepathy("[key_name(src)] used cultist telepathy to say: [speak]")

/obj/effect/decal/cleanable/sigil
	name = "sigils"
	desc = "Strange runics. They hurt your eyes."
	icon_state = "center"
	icon = 'icons/obj/sigils.dmi'
	clean_type = CLEAN_TYPE_LIGHT_DECAL //the sigils are made out of blood, they should be cleanable with a rag, they are also very easily spammed
	var/sigil_type

/obj/effect/decal/cleanable/sigil/examine(mob/user)
	. = ..()
	if(!sigil_type)
		return

	if(isliving(user))
		var/mob/living/living_user = user
		if(istype(living_user, /datum/patron/inhumen/zizo))
			to_chat(user, "It is of the [sigil_type] circle.")

/obj/effect/decal/cleanable/sigil/proc/consume_ingredients(datum/ritual/R)

	for(var/atom/A in get_step(src, NORTH))
		if(istype(A, R.n_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, SOUTH))
		if(istype(A, R.s_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, EAST))
		if(istype(A, R.e_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in get_step(src, WEST))
		if(istype(A, R.w_req) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

	for(var/atom/A in loc.contents)
		if(istype(A, R.center_requirement) && !ishuman(A))
			playsound(src, 'sound/foley/flesh_rem2.ogg', 30)
			qdel(A)

/obj/effect/decal/cleanable/sigil/attack_hand(mob/living/user)
	. = ..()
	if(icon_state != "center") // fucking awful but it has to be this way
		return
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return
	var/list/rituals_pre = list()
	switch(sigil_type)
		if("Transmutation")
			rituals_pre = subtypesof(/datum/ritual/transmutation)
		if("Fleshcrafting")
			rituals_pre = subtypesof(/datum/ritual/fleshcrafting)
		if("Servantry")
			rituals_pre = subtypesof(/datum/ritual/servantry)
	if(!length(rituals_pre))
		return
	var/list/rituals = list()
	for(var/datum/ritual/ritual as anything in rituals_pre)
		if(IS_ABSTRACT(ritual))
			continue
		if(initial(ritual.is_cultist_ritual) && !(is_zizocultist(user.mind) || is_zizolackey(user.mind))) // some rituals are cultist exclusive
			continue
		rituals += initial(ritual.name)

	var/ritualnameinput = browser_input_list(user, "Rituals", "ZIZO", rituals)
	if(!ritualnameinput)
		return

	var/datum/ritual/pickritual = LAZYACCESS(GLOB.ritualslist, ritualnameinput)
	if(!pickritual)
		return

	var/cardinal_success = FALSE
	var/center_success = FALSE
	var/dews = 0

	if(pickritual.e_req)
		for(var/atom/A in get_step(src, EAST))
			if(istype(A, pickritual.e_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(pickritual.s_req)
		for(var/atom/A in get_step(src, SOUTH))
			if(istype(A, pickritual.s_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(pickritual.w_req)
		for(var/atom/A in get_step(src, WEST))
			if(istype(A, pickritual.w_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(pickritual.n_req)
		for(var/atom/A in get_step(src, NORTH))
			if(istype(A, pickritual.n_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(dews >= 4)
		cardinal_success = TRUE

	for(var/atom/A in loc.contents)
		if(!istype(A, pickritual.center_requirement))
			continue
		else
			center_success = TRUE
			break

	var/badritualpunishment = FALSE
	if(cardinal_success != TRUE)
		if(badritualpunishment)
			return
		to_chat(user, span_danger("That's not how you do it, fool."))
		user.electrocute_act(10, src)
		return

	if(center_success != TRUE)
		if(badritualpunishment)
			return
		to_chat(user, span_danger("That's not how you do it, fool."))
		user.electrocute_act(10, src)
		return

	consume_ingredients(pickritual)
	user.playsound_local(user, 'sound/vo/cult/tesa.ogg', 25)
	user.whisper("O'vena tesa...")
	pickritual.invoke(user, loc)

/obj/effect/decal/cleanable/sigil/N
	icon_state = "N"

/obj/effect/decal/cleanable/sigil/NE
	icon_state = "NE"

/obj/effect/decal/cleanable/sigil/E
	icon_state = "E"

/obj/effect/decal/cleanable/sigil/SE
	icon_state = "SE"

/obj/effect/decal/cleanable/sigil/S
	icon_state = "S"

/obj/effect/decal/cleanable/sigil/SW
	icon_state = "SW"

/obj/effect/decal/cleanable/sigil/W
	icon_state = "W"

/obj/effect/decal/cleanable/sigil/NW
	icon_state = "NW"

/turf/open/floor/proc/generateSigils(mob/M, input)
	var/turf/T = get_turf(M.loc)
	for(var/obj/A in T)
		if(istype(A, /obj/effect/decal/cleanable/sigil))
			to_chat(M, span_warning("There is already a sigil here."))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(M, span_warning("There is already something here."))
			return
	if(do_after(M, 5 SECONDS))
		M.bloody_hands--
		M.update_inv_gloves()
		var/obj/effect/decal/cleanable/sigil/C = new(src)
		C.sigil_type = input
		playsound(M, 'sound/items/write.ogg', 100)
		var/list/sigilsPath = list(
			/obj/effect/decal/cleanable/sigil/N,
			/obj/effect/decal/cleanable/sigil/S,
			/obj/effect/decal/cleanable/sigil/E,
			/obj/effect/decal/cleanable/sigil/W,
			/obj/effect/decal/cleanable/sigil/NE,
			/obj/effect/decal/cleanable/sigil/NW,
			/obj/effect/decal/cleanable/sigil/SE,
			/obj/effect/decal/cleanable/sigil/SW
		)

		for(var/i = 1; i <= GLOB.alldirs.len; i++)
			var/turf/floor = get_step(src, GLOB.alldirs[i])
			var/sigil = sigilsPath[i]

			new sigil(floor)

/mob/living/carbon/human/proc/draw_sigil()
	set name = "Draw Sigil"
	set category = "RoleUnique.Zizo"
	if(incapacitated(IGNORE_GRAB) || stat >= UNCONSCIOUS)
		return

	var/list/runes = list("Servantry", "Transmutation", "Fleshcrafting")

	if(!bloody_hands)
		to_chat(src, span_danger("My hands aren't bloody enough."))
		return

	var/input = input("Sigil Type", "ZIZO") as null|anything in runes
	if(!input)
		return

	var/turf/open/floor/T = get_turf(src)
	if(istype(T))
		T.generateSigils(src, input)

/mob/living/carbon/human/proc/release_minion()
	set name = "Release Lackey"
	set category = "RoleUnique.Zizo"

	var/list/mob/living/carbon/human/possible = list()
	for(var/datum/mind/V in SSmapping.retainer.cultists)
		if(V.special_role == "Zizoid Lackey")
			possible |= V.current

	var/mob/living/carbon/human/choice = input(src, "Whom do you no longer have use for?", "VANDERLIN") as null|anything in possible
	if(choice)
		var/alert = alert(src, "Are you sure?", "VANDERLIN", "Yes", "Cancel")
		if(alert == "Yes")
			visible_message(span_danger("[src] reaches out, ripping up [choice]'s soul!</span>"))
			to_chat(choice, span_danger("I HAVE FAILED MY LEADER! I HAVE FAILED ZIZO! NOTHING ELSE BUT DEATH REMAINS FOR ME NOW!"))
			sleep(20)
			choice.gib() // Cooler than dusting.
			SSmapping.retainer.cultists -= choice.mind
