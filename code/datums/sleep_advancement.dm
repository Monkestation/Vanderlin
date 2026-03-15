#define RESTED_XP_MULTIPLIER   1.0   // full XP when rested
#define RESTED_XP_TIRED_RATE   0.5   // XP rate when pool is empty / no multiplier
#define RESTED_XP_BASE_GRANT   2000   // starting pool and per-sleep grant
#define RESTED_XP_INITIAL      500   // granted on datum creation so new chars aren't penalized

/datum/sleep_adv
	var/sleep_adv_cycle = 0
	var/sleep_adv_points = 0
	var/stress_amount = 0
	var/stress_cycles = 0
	var/rolled_specials = 0
	var/retained_dust = 0
	var/datum/mind/mind = null

	/// Flat pool of rested XP, shared across all skills, drains 1:1 as bonus XP
	var/rested_xp_pool = 0
	/// Assoc list: skill typepath -> TRUE if 1.5x rested multiplier is active until next sleep
	var/list/rested_skill_multipliers = list()

	var/list/available_modes = list("one_truth", "one_lie", "two_truths", "two_lies", "truth_lie")
	var/list/remaining_modes = list()

/datum/sleep_adv/New(datum/mind/passed_mind)
	. = ..()
	mind = passed_mind
	rested_xp_pool = RESTED_XP_INITIAL

/datum/sleep_adv/Destroy(force)
	mind = null
	. = ..()

/datum/sleep_adv/proc/add_stress_cycle(add_amount)
	add_amount = clamp(add_amount, -15, 15)
	stress_amount += add_amount
	stress_cycles++
	process_sleep()

/**
 * Primary XP entry point for sleep-sourced gains.
 * No pool:                    20% XP (tired rate)
 * Pool available:            100% XP, pool drained by the 80% difference
 * Pool + dreamed multiplier: 150% XP, pool drained by the 130% difference
 */
/datum/sleep_adv/proc/adjust_sleep_xp(skill_type, amount, silent = FALSE)
	if(!mind?.current)
		return
	var/final_amount
	if(rested_xp_pool > 0)
		var/target_multiplier = rested_skill_multipliers[skill_type] ? 1.5 : RESTED_XP_MULTIPLIER
		var/deficit = FLOOR(amount * (target_multiplier - RESTED_XP_TIRED_RATE), 1)
		var/covered = min(deficit, rested_xp_pool)
		rested_xp_pool -= covered
		final_amount = FLOOR(amount * RESTED_XP_TIRED_RATE + covered, 1)
	else
		final_amount = FLOOR(amount * RESTED_XP_TIRED_RATE, 1)
	mind.current.adjust_experience(skill_type, final_amount, silent)

/datum/sleep_adv/proc/advance_cycle()
	if(!mind.current)
		return
	if(prob(0)) // TODO SLEEP ADV SPECIALS
		rolled_specials++

	to_chat(mind.current, span_notice("My consciousness slips and I start dreaming..."))
	var/dreamwatcher = HAS_TRAIT(mind.current, TRAIT_DREAM_WATCHER)

	if(dreamwatcher)
		to_chat(mind.current, span_notice(pick(
			"You feel the gaze of Noc before all else..",
			"A silver thread weaves through your thoughts..",
			"You step into a dream that feels... familiar.",
			"Noc whispers, not in words, but in meaning.",
		)))

	var/dream_dust = retained_dust
	dream_dust += BASE_DREAM_DUST
	if(HAS_TRAIT(mind.current, TRAIT_TUTELAGE))
		dream_dust += BASE_DREAM_DUST / 2

	var/intel = nulltozero(GET_MOB_ATTRIBUTE_VALUE(mind.current, STAT_INTELLIGENCE))
	if(dreamwatcher)
		intel += 2

	dream_dust += intel * DREAM_DUST_PER_INT

	if(dreamwatcher)
		to_chat(mind.current, span_notice("I can feel Noc's presence... symbols shift, forgotten places stir, and ancient beings whisper through the veil."))
	else if(intel < 10)
		to_chat(mind.current, span_boldwarning("My shallow imagination makes them dull..."))
	else if(intel > 10)
		to_chat(mind.current, span_notice("My creative thinking enhances them..."))

	var/stress_median = stress_cycles ? (stress_amount / stress_cycles) : 0

	// Determine rested pool grant for this cycle
	var/rested_grant = RESTED_XP_BASE_GRANT
	if(dreamwatcher)
		to_chat(mind.current, span_notice("Noc opens the dreamworld before me, a realm of impossible beauty and boundless thought."))
		dream_dust += 100
		rested_grant += RESTED_XP_BASE_GRANT
	else if(stress_median <= STRESS_THRESHOLD_NICE)
		to_chat(mind.current, span_notice("With no stresses throughout the day I dream vividly..."))
		dream_dust += 100
		rested_grant += RESTED_XP_BASE_GRANT / 2
	else if(stress_median >= STRESS_THRESHOLD_FREAKING_OUT)
		to_chat(mind.current, span_boldwarning("Bothered by the stresses of the day my dreams are short..."))
		dream_dust -= 100
		rested_grant = FLOOR(rested_grant / 2, 1)

	rested_xp_pool += rested_grant

	// Clear multipliers from last sleep cycle
	rested_skill_multipliers = list()

	if(dreamwatcher)
		var/list/intro_lines = list(
			span_boldwarning("Noc stirs beneath the surface of your dreams... the world around you distorts, familiar faces blur, and the stars themselves tremble in disquiet."),
			span_boldwarning("The dreamscape writhes, pulling at the edges of reality... fleeting images dance across your vision, too tangled to grasp, too distant to recall."),
			span_boldwarning("A shadow stretches across the stars, swallowing all that once was... whispers echo, but the words slip from your grasp like smoke."),
			span_boldwarning("Noc's touch lingers in the space between thoughts... your mind flickers like a dying ember, lost in the endless night."),
			span_boldwarning("The fabric of dreams unravels around you... shapes and voices blur, an eternal puzzle without an answer."),
			span_boldwarning("A ripple of thought trembles through the dreamworld... each shift a new question, each answer a fleeting illusion.")
		)
		to_chat(mind.current, pick(intro_lines))

	var/datum/storyteller/most_influential = SSgamemode.get_most_influential()
	if(dreamwatcher)
		var/list/dreams = SSgamemode.god_dreams[most_influential.name]
		if(!dreams)
			dreams = SSgamemode.god_dreams["Unknown"]
		to_chat(mind.current, span_notice(pick(dreams)))
		to_chat(mind.current, span_notice(generate_symbolic_dream()))

	stress_amount = 0
	stress_cycles = 0

	var/dream_points = FLOOR(dream_dust / 100, 1)
	retained_dust = dream_dust % 100
	sleep_adv_points += max(dream_points, 1)
	sleep_adv_cycle++

	show_ui(mind.current)

/datum/sleep_adv/proc/show_ui(mob/living/user)
	var/list/dat = list()
	SSassets.transport.send_assets(user.client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	dat += {"
		<!DOCTYPE html>
		<html lang='en'>
		<head>
			<meta charset='UTF-8'>
			<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
			<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
			<style>
				@import url('https://fonts.googleapis.com/css2?family=Tangerine:wght@400;700&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=UnifrakturMaguntia&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
				body {
					background-color: rgb(31, 20, 24);
					background:
						url('[SSassets.transport.get_asset_url("try4_border.png")]'),
						url('[SSassets.transport.get_asset_url("try4.png")]');
					background-repeat: no-repeat;
					background-attachment: fixed;
					background-size: 100% 100%;
				}
			</style>
			<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url("slop_menustyle2.css")]'>
		</head>
		"}
	dat += "<body>"
	dat += "<div id='top_handwriting'><center>Cycle \Roman[sleep_adv_cycle]</center></div>"
	dat += "<div id='class_select_box_div'>"
	dat += "<br><center>Dream, for those who dream may reach higher heights</center><br>"
	dat += "<center>\Roman[sleep_adv_points] dream points</center>"
	dat += "<br><center><small>Rested pool: [rested_xp_pool] XP</small></center><br>"
	var/list/dream_skills = get_dream_skill_candidates()
	for(var/skill_type in dream_skills)
		var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
		var/already_active = rested_skill_multipliers[skill_type]
		var/current_level = nulltozero(GET_MOB_SKILL_VALUE(mind.current, skill_type))
		var/level_name = skill.description_from_level(current_level)
		if(already_active)
			dat += "<div class='class_bar_div'><span class='vagrant'>[skill.name] ([level_name]) - <b>1.5x active</b></span></div>"
		else
			dat += "<div class='class_bar_div'><a class='vagrant' href='byond://?src=[REF(src)];task=buy_skill;skill_type=[skill_type]'>[skill.name] ([level_name]) <img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32> \Roman[get_skill_cost(skill_type)] <img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32></a></div>"

	dat += "<br>"
	if(rolled_specials > 0)
		var/can_buy_spec = can_buy_special()
		dat += "<div class='class_bar_div'><a class='vagrant' [can_buy_spec ? "" : "class='linkOff'"] href='byond://?src=[REF(src)];task=buy_special'>Dream something <b>special</b> <img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32> \Roman[get_special_cost()] <img class='ninetysskull' src='[SSassets.transport.get_asset_url("gragstar.gif")]' width=32 height=32></a></div>"
		dat += "<br>Specials can have negative or positive effects"
	dat += "<div class='footer'>"
	dat += "<br><br><center>Your points will be retained<br><a href='byond://?src=[REF(src)];task=continue'>Continue</a></center>"
	dat += {"
			</body>
		</html>
	"}
	var/datum/browser/popup = new(user, "dreams", "<center>Dreams</center>", 350, 450, src)
	popup.set_window_options(can_close = FALSE)
	popup.set_content(dat.Join())
	popup.open(TRUE)

/datum/sleep_adv/proc/close_ui()
	if(!mind.current)
		return
	mind.current << browse(null, "window=dreams")

/datum/sleep_adv/proc/process_sleep()
	if(is_considered_sleeping())
		return
	close_ui()

/datum/sleep_adv/proc/is_considered_sleeping()
	if(!mind.current)
		return FALSE
	if(HAS_TRAIT(mind.current, TRAIT_VAMP_DREAMS))
		return TRUE
	return mind.current.IsSleeping()

/datum/sleep_adv/proc/can_buy_skill(skill_type)
	return (sleep_adv_points >= get_skill_cost(skill_type))

/datum/sleep_adv/proc/can_buy_special()
	return (sleep_adv_points >= get_special_cost())

/datum/sleep_adv/proc/get_next_level_for_skill(skill_type)
	if(!mind.current)
		return 0
	return nulltozero(GET_MOB_SKILL_VALUE(mind.current, skill_type)) + 1

/datum/sleep_adv/proc/get_skill_cost(skill_type)
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	var/next_level = get_next_level_for_skill(skill_type)
	return skill.get_dream_cost_for_level(next_level)

/datum/sleep_adv/proc/get_special_cost()
	return 3

/**
 * Buying a skill sets a 1.5x rested XP multiplier on it until next sleep.
 * The bonus XP is drawn from the rested pool in adjust_sleep_xp().
 */
/datum/sleep_adv/proc/buy_skill(skill_type)
	if(!can_buy_skill(skill_type))
		return
	if(rested_skill_multipliers[skill_type])
		return // already active
	var/datum/attribute/skill/skill = GET_ATTRIBUTE_DATUM(skill_type)
	var/dream_text = skill.get_random_dream()
	if(dream_text)
		to_chat(mind.current, span_notice(dream_text))
	sleep_adv_points -= get_skill_cost(skill_type)
	rested_skill_multipliers[skill_type] = TRUE
	to_chat(mind.current, span_nicegreen("You feel driven to practice [lowertext(skill.name)]... your efforts will be rewarded while you remain rested."))
	record_round_statistic(STATS_SKILLS_DREAMED)

/datum/sleep_adv/proc/get_dream_skill_candidates(max_count = 6)
	var/list/weighted = list()

	for(var/skill_type in GLOB.all_skills)
		var/already_active = rested_skill_multipliers[skill_type]
		var/can_buy = !already_active && can_buy_skill(skill_type)
		if(!already_active && !can_buy)
			continue
		// Already active skills always show
		if(already_active)
			weighted[skill_type] = -1 // sentinel: always include
			continue
		var/current_level = nulltozero(GET_MOB_SKILL_VALUE(mind.current, skill_type))
		// Weight: untrained = 1, each level adds 3 more weight
		weighted[skill_type] = max(1, 1 + current_level * 3)

	var/list/result = list()

	// Always include already-active skills first
	for(var/skill_type in weighted)
		if(weighted[skill_type] == -1)
			result += skill_type

	// Weighted random pick from the rest to fill up to max_count
	var/list/candidates = list()
	for(var/skill_type in weighted)
		if(weighted[skill_type] != -1)
			candidates[skill_type] = weighted[skill_type]

	var/slots = max(0, max_count - result.len)
	while(slots > 0 && candidates.len > 0)
		var/skill_type = pickweight(candidates)
		result += skill_type
		candidates -= skill_type
		slots--

	return result

/datum/sleep_adv/proc/buy_special()
	if(!can_buy_special())
		return
	// TODO SLEEP ADV SPECIALS
	sleep_adv_points -= get_special_cost()

/datum/sleep_adv/proc/finish()
	if(!mind.current)
		return
	if(mind.has_studied)
		mind.has_studied = FALSE
		to_chat(mind.current, span_smallnotice("I feel like I can study my tome again..."))
	SEND_SIGNAL(mind.current, COMSIG_LIVING_DREAM_END)
	to_chat(mind.current, span_notice("...and that's all I dreamt of."))
	close_ui()

/datum/sleep_adv/Topic(href, list/href_list)
	. = ..()
	if(!mind.current)
		close_ui()
		return
	if(!is_considered_sleeping())
		close_ui()
		return
	if(href == "close=1")
		finish()
		return
	switch(href_list["task"])
		if("buy_skill")
			var/skill_type = text2path(href_list["skill_type"])
			if(!skill_type)
				return
			buy_skill(skill_type)
		if("buy_special")
			buy_special()
		if("continue")
			finish()
			return
	show_ui(mind.current)

/proc/can_train_combat_skill(mob/living/user, skill_type, target_skill_level)
	if(!user.mind)
		return FALSE
	var/user_skill_level = nulltozero(GET_MOB_SKILL_VALUE(user, skill_type))
	var/level_diff = target_skill_level - user_skill_level
	if(level_diff <= 0)
		return FALSE
	return TRUE

// ── Dream watcher procs ───────────────────────────────────────────────────────

/datum/sleep_adv/proc/generate_symbolic_dream()
	var/list/truths = get_current_real_antags()
	var/list/lies = get_possible_fake_antags_excluding(truths)
	if(!remaining_modes.len)
		remaining_modes = available_modes.Copy()
	var/mode = pick(remaining_modes)
	remaining_modes -= mode
	var/list/picked = list()
	switch(mode)
		if("one_truth")
			picked += pick(truths)
		if("one_lie")
			picked += pick(lies)
		if("two_truths")
			if(truths.len >= 2)
				shuffle(truths)
				picked += truths[1]
				picked += truths[2]
			else
				picked += truths
		if("two_lies")
			if(lies.len >= 2)
				shuffle(lies)
				picked += lies[1]
				picked += lies[2]
			else
				picked += lies
		if("truth_lie")
			picked += pick(truths)
			picked += pick(lies)
	return assemble_symbolic_dream(picked)

/datum/sleep_adv/proc/assemble_symbolic_dream(list/antags)
	var/emotion = pick("dread", "anticipation", "sorrow", "awe", "rage", "longing", "confusion", "ecstasy", "emptiness", "yearning")
	var/scene = ""
	switch(emotion)
		if("dread")        scene += "...the air is thick... shadows coil at the edges of your vision"
		if("anticipation") scene += "...footsteps echo ahead... something waits, unseen"
		if("sorrow")       scene += "...you stand beneath a dying tree... it weeps silently"
		if("awe")          scene += "...the sky fractures with light... you kneel, unknowingly"
		if("rage")         scene += "...flames lick the ground... a scream builds in your chest"
		if("longing")      scene += "...you reach through mist... fingers graze something lost"
		if("confusion")    scene += "...the world tilts sideways... nothing is where it should be"
		if("ecstasy")      scene += "...a chorus sings behind your eyes... joy too bright to bear"
		if("emptiness")    scene += "...you float above yourself... hollow... watching"
		if("yearning")     scene += "...you reach for something in the dark... it slips through your fingers"
	for(var/antag_type in antags)
		scene += generate_symbol_for_antag(antag_type)
	var/list/suffixes = list(
		"... then, silence...",
		"... you awake with the taste of ash...",
		"... a bell tolls, but no one hears it...",
		"... you are not sure if you were watching... or being watched...",
		"... the feeling lingers, heavy as dusk...",
		"... your hands won't stop trembling...",
		"... you wake with your mouth full of names...",
		"... the light behind your eyes is gone...",
		"... you try to remember, but something remembers you instead...",
		"... you are not alone in your skin...",
		"... you wake gripping nothing... yet your hands ache...",
		"... your pillow is damp with tears you didn't cry...",
		"... the shadows no longer flee the dawn...",
		"... you remember less than you did before...",
		"... someone else's name rests on your lips...",
		"... the dream fades... but something remains behind..."
	)
	scene += pick(suffixes)
	return scene

/datum/sleep_adv/proc/generate_symbol_for_antag(datum/antagonist/antag)
	var/list/antag_dreams = SSgamemode.antag_dreams
	if(antag_dreams[antag.type])
		return pick(antag_dreams[antag.type])
	return pick(antag_dreams["Unknown"])

/datum/sleep_adv/proc/get_current_real_antags()
	var/list/truths = list()
	for(var/datum/antagonist/A in GLOB.antagonists)
		if(A.owner && A.owner.current.client)
			truths += A
	return truths

/datum/sleep_adv/proc/get_possible_fake_antags_excluding(list/truths)
	var/list/all_possible = list(
		/datum/antagonist/vampire/lord,
		/datum/antagonist/vampire,
		/datum/antagonist/vampire/lords_spawn,
		/datum/antagonist/lich,
		/datum/antagonist/werewolf,
		/datum/antagonist/werewolf/lesser,
		/datum/antagonist/zizocultist,
		/datum/antagonist/zizocultist/leader,
		/datum/antagonist/prebel,
		/datum/antagonist/prebel/head,
		/datum/antagonist/aspirant,
		/datum/antagonist/bandit,
		/datum/antagonist/assassin,
		/datum/antagonist/maniac,
	)
	for(var/datum/antagonist/T in truths)
		all_possible -= T.type
	var/list/lies = list()
	for(var/antag_type in all_possible)
		lies += new antag_type()
	return lies

#undef RESTED_XP_MULTIPLIER
#undef RESTED_XP_BASE_GRANT
#undef RESTED_XP_TIRED_RATE
#undef RESTED_XP_INITIAL
