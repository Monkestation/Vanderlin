/datum/action/innate/embrace_death
	name = "Embrace Death"
	button_icon_state = "necra"

/datum/action/innate/embrace_death/Activate()
	. = ..()
	if(!isliving(owner) || !owner.mind)
		return

	var/confirm = browser_alert(owner, "Are you ready to embrace death? You will not be able to be revived.", "Embrace Death", DEFAULT_INPUT_CHOICES)
	if(QDELETED(src) || QDELETED(owner))
		return

	if(confirm != CHOICE_CONFIRM)
		return

	owner.say("NECRA, I AM READY!", forced = "necra_ritual")

	owner.visible_message(
		span_warning("[owner] begins chanting Necra's last rites!"), \
		span_warning("You feel Necra's presence as you start the ritual...")
	)

	if(!do_after(owner, 10 SECONDS, owner))
		to_chat(owner, span_warning("The ritual was interrupted!"))
		return

	if(QDELETED(src) || QDELETED(owner))
		return

	owner.say("NECRA, EMBRACE ME!", forced = "necra_ritual")
	playsound(owner, 'sound/magic/churn.ogg', 80)
	ADD_TRAIT(owner, TRAIT_NECRA_CURSE, "necra_ritual")
	ADD_TRAIT(owner, TRAIT_BURIED_COIN_GIVEN, "necra_ritual")
	owner.death()

	var/datum/objective/personal/embrace_death/objective = target
	if(!QDELETED(objective) && !objective.completed)
		objective.complete_objective()

	qdel(src)
