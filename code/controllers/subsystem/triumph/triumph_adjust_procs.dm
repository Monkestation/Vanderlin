/proc/adjust_triumphs(datum/key_holder, amount, counted = TRUE, reason, silent = FALSE, override_bonus = FALSE)
	if(!key_holder)
		return

	if(!amount)
		return

	var/key
	var/ckey

	if(!ismob(key_holder) && !ismind(key_holder) && !isclient(key_holder))
		var/possible_ckey = key_holder
		if(!(possible_ckey in GLOB.keys_by_ckey))
			return
		else
			ckey = key_holder // in the case that a ckey is passed (ie in triumphs refund)
	else
		key = key_holder:key

	// patreon triumph increase
	if((key_is_donator(key) || ckey_is_donator(ckey)) && !override_bonus && (amount > 0))
		amount *= 1.5

	ckey = ckey ? ckey : ckey(key)

	if(!ckey)
		return

	SStriumphs.triumph_adjust(amount, ckey)
	SStriumphs.adjust_leaderboard(GLOB.keys_by_ckey[ckey])

	var/adjustment_verb
	if(amount > 0)
		adjustment_verb = "awarded"
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_AWARDED, amount)
	else
		adjustment_verb = "lost"
		if(counted)
			record_round_statistic(STATS_TRIUMPHS_STOLEN, amount)

	var/final_text = "[abs(amount)] TRIUMPH\s [adjustment_verb]."
	if(reason)
		final_text += " REASON: [reason]"

	if(!silent)
		to_chat(key_holder, span_purple("[final_text]"))

/datum/mind/proc/adjust_triumphs(amt, counted = TRUE, reason, silent = FALSE, override_bonus = FALSE)
	if(!key)
		return
	global.adjust_triumphs(src, amt, counted, reason, silent, override_bonus)

/client/proc/adjust_triumphs(amt, counted = TRUE, reason, silent = FALSE, override_bonus = FALSE)
	global.adjust_triumphs(src, amt, counted, reason, silent, override_bonus)

/mob/proc/adjust_triumphs(amt, counted = TRUE, reason, silent = FALSE, override_bonus = FALSE)
	if(!key)
		return
	global.adjust_triumphs(src, amt, counted, reason, silent, override_bonus)
