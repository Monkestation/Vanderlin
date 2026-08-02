/datum/component/art
	var/impressiveness = 0

/datum/component/art/Initialize(impress)
	impressiveness = impress
	if(isobj(parent))
		RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_obj_examine))
	else
		RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_other_examine))
	if(isstructure(parent))
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(apply_moodlet))

/datum/component/art/proc/apply_moodlet(mob/M, impress)
	M.visible_message("<span class='notice'>[M] stops and looks intently at [parent].</span>", \
						"<span class='notice'>I stop to take in [parent].</span>")
	switch(impress)
		if (0 to BAD_ART)
			M.add_stress(/datum/stress_event/artbad)
		if (BAD_ART to GOOD_ART)
			M.add_stress(/datum/stress_event/artok)
		if (GOOD_ART to GREAT_ART)
			M.add_stress(/datum/stress_event/artgood)
		if(GREAT_ART to INFINITY)
			M.add_stress(/datum/stress_event/artgreat)


/datum/component/art/proc/on_other_examine(datum/source, mob/M)
	apply_moodlet(M, impressiveness)

/datum/component/art/proc/on_obj_examine(datum/source, mob/M)
	var/obj/O = parent
	apply_moodlet(M, impressiveness *(O.get_integrity()/O.max_integrity))

/datum/component/art/proc/on_attack_hand(datum/source, mob/M)
	to_chat(M, "<span class='notice'>I start examining [parent]...</span>")
	if(!do_after(M, 2 SECONDS, parent))
		return
	on_obj_examine(source, M)

/datum/component/art/rev

/datum/component/art/rev/apply_moodlet(mob/M, impress)
	M.visible_message("<span class='notice'>[M] stops to inspect [parent].</span>", \
						"<span class='notice'>I take in [parent], inspecting the fine craftsmanship of the proletariat.</span>")

	M.add_stress(/datum/stress_event/artbad)
