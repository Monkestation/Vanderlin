/datum/component/bloodpool_regen
	///how fast we regen
	var/regen_rate = 1

/datum/component/bloodpool_regen/Initialize(_regen_rate = 1)
	. = ..()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	regen_rate = _regen_rate
	START_PROCESSING(SSobj, src)

/datum/component/bloodpool_regen/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/datum/component/bloodpool_regen/process(delta_time)
	. = ..()
	var/mob/living/carbon/human/human = parent
	if(human.bloodpool < human.maxbloodpool)
		human.adjust_bloodpool(regen_rate)
