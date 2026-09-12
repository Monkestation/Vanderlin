SUBSYSTEM_DEF(relations)
	name = "Relations"
	flags = SS_NO_FIRE // Purely event-driven; no periodic processing needed.
	wait = 0

	/// All minds participating in relation matching this round.
	var/list/participating_minds = list()

/datum/controller/subsystem/relations/proc/all_minds()
	return participating_minds

/datum/controller/subsystem/relations/proc/spread_gossip()
	var/list/all_minds = list()
	for(var/mob/M in GLOB.player_list)
		if(M.mind)
			all_minds += M.mind

	var/list/pool = list()
	for(var/datum/mind/M in all_minds)
		if(!M.current?.client?.prefs)
			continue
		if(!ishuman(M.current))
			continue

		var/list/rumors = M.current.client.prefs.read_preference(/datum/preference/list_type/rumors)
		for(var/rumor_text in rumors)
			if(!length(rumor_text))
				continue
			pool += list(list("mind" = M, "text" = rumor_text, "is_noble" = FALSE))

		var/list/ng = M.current.client.prefs.read_preference(/datum/preference/list_type/noble_gossip)
		for(var/ng_text in ng)
			if(!length(ng_text))
				continue
			pool += list(list("mind" = M, "text" = ng_text, "is_noble" = TRUE))

	if(!pool.len)
		return

	// How many listeners each gossip entry reaches.
	// Scales down as pool grows so total assignments stay reasonableish
	var/total_listeners = all_minds.len
	var/spread = clamp(round(total_listeners / max(pool.len, 1)), 2, 5)

	for(var/list/entry in pool)
		var/datum/mind/subject = entry["mind"]
		var/is_noble_gossip = entry["is_noble"]

		var/list/eligible = list()
		for(var/datum/mind/listener in all_minds)
			if(listener == subject)
				continue
			if(!listener.current || !ishuman(listener.current))
				continue
			if(is_noble_gossip)
				var/mob/living/carbon/human/H = listener.current
				if(!HAS_TRAIT(H, TRAIT_NOBLE_BLOOD) && !HAS_TRAIT(H, TRAIT_NOBLE_POWER))
					continue
			eligible += listener

		shuffle_inplace(eligible)
		var/count = min(spread, eligible.len)
		for(var/i in 1 to count)
			var/datum/mind/listener = eligible[i]
			var/datum/relation/R = get_or_create_gossip_relation(listener, subject)
			if(!R)
				continue
			var/datum/history/gossip/G
			if(is_noble_gossip)
				G = new /datum/history/gossip/noble()
			else
				G = new /datum/history/gossip/rumor()
			G.heard_text = entry["text"]
			R.add_history(G)

/datum/controller/subsystem/relations/proc/get_or_create_gossip_relation(datum/mind/listener, datum/mind/subject)
	for(var/datum/relation/R in listener.relations)
		if(R.other == subject)
			// Ensure snapshot has at minimum a name
			if(!R.snapshot)
				if(subject.current && ishuman(subject.current))
					R.snapshot_name_only(subject.current)
			return R

	var/datum/relation/R = new /datum/relation/acquaintance()
	R.holder = listener
	R.other = subject
	R.symmetric = FALSE // listener knows of subject, not necessarily vice versa

	if(subject.current && ishuman(subject.current))
		R.snapshot_name_only(subject.current)

	LAZYADD(listener.relations, R)
	R.on_created()
	return R

/// Called from SSticker after DivideOccupations and create_characters().
/// Assigns rival relations based on each player's rival_count preference.
/datum/controller/subsystem/relations/proc/run_rival_matchmaking()
	participating_minds = list()

	build_grudge_pools()

	// Collect all living human minds that have a client and have rivals set greater than 0E
	for(var/datum/mind/M in SSticker.minds)
		if(!M.current || !ishuman(M.current))
			continue
		if(!M.key)
			continue
		if(!M.current.client?.prefs?.read_preference(/datum/preference/numeric/rival_count))
			continue
		participating_minds += M

	assign_rivals(participating_minds)

///attempts to fill rival slots for every mind in the pool.
/datum/controller/subsystem/relations/proc/assign_rivals(list/pool)
	// Build a shuffle so we don't always favour minds early in the list.
	var/list/shuffled = shuffle(pool.Copy())

	for(var/datum/mind/M in shuffled)
		if(!M.current?.client?.prefs)
			continue
		var/wanted = M.current.client.prefs.read_preference(/datum/preference/numeric/rival_count)
		if(!isnum(wanted) || wanted <= 0)
			continue
		var/current_rivals = count_rivals(M)
		if(current_rivals >= wanted)
			continue

		var/needed = wanted - current_rivals
		var/list/candidates = get_rival_candidates(M, pool)
		for(var/i in 1 to needed)
			if(!length(candidates))
				break
			var/datum/mind/pick = pick_n_take(candidates)
			//only pair if pick also has room.
			var/pick_wanted = 0
			if(pick.current?.client?.prefs)
				pick_wanted = pick.current.client.prefs.read_preference(/datum/preference/numeric/rival_count)
			var/pick_has = count_rivals(pick)
			if(!isnum(pick_wanted) || pick_wanted <= 0 || pick_has >= pick_wanted)
				continue
			var/datum/relation/R = M.add_relation(pick, /datum/relation/rival)
			if(R)
				seed_rival_grudge(M, pick, R)

/// Count how many rival relations a mind currently holds.
/datum/controller/subsystem/relations/proc/count_rivals(datum/mind/M)
	var/count = 0
	for(var/datum/relation/R in M.relations)
		if(istype(R, /datum/relation/rival))
			count++
	return count

/// Returns candidate minds for rivalry as a weighted-shuffled list.
/// Same job title gets highest weight, same department medium, cross-department lowest.
/// Excludes self, already-rivals, and those who want 0 rivals.
/datum/controller/subsystem/relations/proc/get_rival_candidates(datum/mind/M, list/pool)
	var/list/weighted = list()
	var/datum/job/my_job = M.assigned_role

	for(var/datum/mind/C in pool)
		if(C == M)
			continue
		if(M.knows_as(C, /datum/relation/rival))
			continue
		if(C.current?.client?.prefs)
			var/their_want = C.current.client.prefs.read_preference(/datum/preference/numeric/rival_count)
			if(!isnum(their_want) || their_want <= 0)
				continue

		var/datum/job/their_job = C.assigned_role
		var/weight = 1
		if(my_job && their_job)
			if(their_job.title == my_job.title)
				weight = 10
			else if(their_job.department_flag & my_job.department_flag)
				weight = 4

		for(var/i in 1 to weight)
			weighted += C

	return shuffle(weighted)

/// Late-join hook. Tries to match one rival for the joiner if they want one
/// and a same-class partner with an open slot exists. Silently skips otherwise.
/datum/controller/subsystem/relations/proc/try_late_join_rival(datum/mind/joiner)
	if(!joiner?.current?.client?.prefs)
		return
	var/wanted = joiner.current.client.prefs.read_preference(/datum/preference/numeric/rival_count)
	if(!isnum(wanted) || wanted <= 0)
		return

	participating_minds |= joiner // Register them.

	var/list/candidates = get_rival_candidates(joiner, participating_minds)

	if(!length(candidates))
		return // no suitable partner found.

	var/datum/mind/pick = pick(candidates)
	var/pick_wanted = 0
	if(pick.current?.client?.prefs)
		pick_wanted = pick.current.client.prefs.read_preference(/datum/preference/numeric/rival_count)
	var/pick_has = count_rivals(pick)
	if(!isnum(pick_wanted) || pick_wanted <= 0 || pick_has >= pick_wanted)
		return

	var/datum/relation/R = joiner.add_relation(pick, /datum/relation/rival)
	if(R)
		seed_rival_grudge(joiner, pick, R)

/// Pick and attach a grudge to a newly formed rival pair.
/datum/controller/subsystem/relations/proc/seed_rival_grudge(datum/mind/A, datum/mind/B, datum/relation/R)
	var/list/pool = pick_grudge_pool(A, B)
	if(!length(pool))
		return
	var/chosen_type = pick(pool)
	var/datum/grudge_type/G = new chosen_type()

	var/datum/job/job_a = A.assigned_role
	var/datum/job/job_b = B.assigned_role
	var/datum/mind/aggressor = A
	var/datum/mind/victim = B
	if(job_a && job_b) //I hate this
		var/key_ba = "[job_b.title]>[job_a.title]"
		if(GLOB.grudge_pool_by_job[key_ba])
			aggressor = B
			victim = A

	var/datum/history/history = new /datum/history(G.grudge_name, G.aggressor_text, G.victim_text, aggressor, victim)
	var/datum/relation/R_other = B.get_relation(A, /datum/relation/rival)
	LAZYADD(R.relation_history, history)
	if(R_other && R_other != R)
		LAZYADD(R_other.relation_history, history)
	qdel(G)

/datum/controller/subsystem/relations/proc/pick_grudge_pool(datum/mind/A, datum/mind/B)
	var/datum/job/job_a = A.assigned_role
	var/datum/job/job_b = B.assigned_role

	//try A-aggresses-B then B-aggresses-A.
	if(job_a && job_b)
		var/key_ab = "[job_a.title]>[job_b.title]"
		var/key_ba = "[job_b.title]>[job_a.title]"
		var/list/job_pool = GLOB.grudge_pool_by_job[key_ab] || GLOB.grudge_pool_by_job[key_ba]
		if(length(job_pool))
			return job_pool

	// Department overlap.
	if(job_a && job_b && (job_a.department_flag & job_b.department_flag))
		var/dept_key = dept_flag_to_key(job_a.department_flag & job_b.department_flag)
		if(dept_key)
			var/list/dept_pool = GLOB.grudge_pool_by_dept[dept_key]
			if(length(dept_pool))
				return dept_pool

	return GLOB.grudge_pool_generic
