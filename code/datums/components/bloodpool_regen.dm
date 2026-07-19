/datum/component/bloodpool_regen
	/// how much to regen per second
	var/regen_rate = 0.5

/datum/component/bloodpool_regen/Initialize(_regen_rate = 0.5)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	regen_rate = _regen_rate
	START_PROCESSING(SSobj, src)

/datum/component/bloodpool_regen/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/datum/component/bloodpool_regen/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/human = parent
	if(human.bloodpool < human.maxbloodpool)
		human.adjust_bloodpool(regen_rate * seconds_per_tick)
