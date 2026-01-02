/datum/action/cooldown/spell/undirected/list_target/ultimate_sacrifice
	name = "Ultimate Sacrifice"
	button_icon_state = "revive"
	sound = null
	has_visual_effects = FALSE
	cast_range = 1

	antimagic_flags = NONE

	charge_required = FALSE
	invocation = "RAVOX, HEAR MY PLEA!"
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/undirected/list_target/ultimate_sacrifice/get_list_targets(atom/center, target_radius = 7)
	var/list/things = list()
	if(target_radius)
		for(var/mob/living/carbon/human/H in oview(target_radius, center))
			if(H.stat != DEAD)
				continue
			things += H

	return things

/datum/action/cooldown/spell/undirected/list_target/ultimate_sacrifice/cast(mob/living/carbon/human/cast_on)
	. = ..()

	if(HAS_TRAIT(cast_on, TRAIT_NECRA_CURSE))
		to_chat(owner, span_warning("Necra holds tight to this one."))
		return

	var/confirm = browser_alert(owner, "Your life will be sacrificed to revive [cast_on.real_name]. You CANNOT be revived after this. Are you absolutely sure?", "Ultimate Sacrifice", list("Sacrifice Myself", "Cancel"))
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return

	if(confirm != "Sacrifice Myself")
		return

	owner.visible_message(
		span_userdanger("[owner] begins chanting Ravox's sacrificial rites!"),
		span_userdanger("You feel Ravox's presence around you as you prepare to give your life..."),
	)

	if(!do_after(owner, 10 SECONDS, owner))
		to_chat(owner, span_warning("The ritual was interrupted!"))
		return

	if(cast_on.stat != DEAD || QDELETED(cast_on))
		return

	owner.say("RAVOX, I GIVE MY LIFE FOR THEIRS!", forced = "ravox_ritual")
	owner.emote("rage", forced = TRUE)

	if(!cast_on.ckey)
		var/mob/living/carbon/spirit/underworld_spirit = cast_on.get_spirit()
		if(underworld_spirit)
			var/mob/dead/observer/ghost = underworld_spirit.ghostize()
			qdel(underworld_spirit)
			ghost.mind.transfer_to(cast_on, TRUE)
		cast_on.grab_ghost(force = TRUE)

	cast_on.revive(full_heal = TRUE, admin_revive = FALSE)

	playsound(owner, 'sound/magic/churn.ogg', 80)
	ADD_TRAIT(owner, TRAIT_NECRA_CURSE, "ravox_ritual")
	owner.death()

	if(owner.mind)
		var/datum/objective/personal/ultimate_sacrifice/objective = target
		if(objective && !objective.completed)
			objective.complete_objective()

	qdel(src)
