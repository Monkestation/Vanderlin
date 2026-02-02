/mob/living/carbon/human/proc/choose_name_popup(input)
	if(QDELETED(src))
		return
	var/old_name = real_name
	var/new_name = old_name
	MOBTIMER_SET(src, MT_MIRRORTIME)
	do //This is so I can exit early if conditions aren't met
		if(stat > CONSCIOUS)
			break

		var/possible_new_name = browser_input_text(src, "What should your [input] name be?", null, max_length = MAX_NAME_LEN, timeout = 60 SECONDS)
		if(!possible_new_name)
			break
		possible_new_name = reject_bad_name(possible_new_name)
		if(!possible_new_name)
			to_chat(src, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
			break

		possible_new_name = capitalize(possible_new_name)
		if(possible_new_name in GLOB.chosen_names)
			to_chat(src, span_warning("That name is taken."))
			break
		original_name = old_name
		new_name = possible_new_name
	while(FALSE)

	if(mind.has_antag_datum(/datum/antagonist/bandit))
		GLOB.outlawed_players |= new_name

	fully_replace_character_name(old_name, new_name)
	var/fakekey = get_display_ckey(ckey)
	GLOB.character_list[mobid] = "[fakekey] was [new_name] ([input])<BR>"
