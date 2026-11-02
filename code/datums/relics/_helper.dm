/atom/proc/make_relic(datum/relic_trigger/trigger, datum/relic_effect/effect, datum/relic_information/info)
	if(!trigger || !effect)
		return FALSE
	AddComponent(/datum/component/relic, new trigger, new effect, new info)
	return TRUE
