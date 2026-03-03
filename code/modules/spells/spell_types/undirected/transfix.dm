/datum/action/cooldown/spell/undirected/transfix
	name = "Transfix"
	button_icon_state = "transfix"
	has_visual_effects = FALSE

	associated_skill = /datum/skill/magic/blood

	spell_type = SPELL_BLOOD

	charge_required = FALSE
	cooldown_time = 15 SECONDS
	spell_cost = 100

	/// Ignore crosses and give a different message
	var/powerful = FALSE
	/// Willpower divisor from INT
	var/int_divisor = 3.3
	/// Faces of blood die
	var/blood_dice = 9
	/// Faces of will die
	var/will_dice = 6

	var/message

/datum/action/cooldown/spell/undirected/transfix/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	message = browser_input_text(owner, "Soothe them. Dominate them. Speak and they will succumb.", "Transfix", multiline = TRUE)
	if(QDELETED(src) || QDELETED(owner) || !can_cast_spell())
		return

	if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	if(length(message) < 10)
		to_chat(owner, span_userdanger("This not enough to ensnare their mind!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/transfix/proc/get_targets()
	var/list/selection = list()
	for(var/mob/living/carbon/human/target in viewers(6, owner))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			continue
		selection += target

	return selection

/datum/action/cooldown/spell/undirected/transfix/cast(atom/cast_on)
	. = ..()
	var/list/targets = get_targets()
	if(!length(targets))
		to_chat(owner, span_warning("There are no mortals nearby..."))
		return
	if(!powerful)
		var/mob/selected = browser_input_list(owner, "Ensnare the mind of which mortal?", "Transfix", targets)
		if(QDELETED(src) || QDELETED(owner) || QDELETED(selected) || !can_cast_spell())
			return
		targets = list(selected)

	var/bloodskill = owner.get_skill_level(/datum/skill/magic/blood)
	var/bloodroll = roll(bloodskill, blood_dice)
	owner.say(message, forced = "spell ([name])")
	if(powerful)
		owner.visible_message("<font color='red'>[owner]'s eyes glow a ghastly red as they project their will outwards!</font>")

	for(var/mob/living/carbon/human/target as anything in targets)
		if(target.cmode)
			will_dice++
		var/willpower = round(target.STAINT / int_divisor, 1)
		var/willroll = roll(willpower, will_dice)

		// If the vampire failed badly
		var/knowledgable = (willroll - bloodroll) >= 3

		if(!powerful)
			var/static/list/silver_items = list(
				/obj/item/clothing/neck/psycross/silver,
				/obj/item/clothing/neck/silveramulet
			)
			if(is_type_in_list(target.wear_wrists, silver_items) || is_type_in_list(target.wear_neck, silver_items))
				var/extra = "!"
				if(knowledgable)
					extra = ", I sense the caster was [owner]!"
				to_chat(target, "<font color='white'>The silver psycross shines and protect me from unholy magic[extra]</font>")
				to_chat(owner, span_userdanger("[target] has my BANE! It causes me to fail to ensnare their mind!"))
				return

		if(bloodroll >= willroll)
			target.adjust_drowsiness_up_to(100 SECONDS, 300 SECONDS)
			var/datum/status_effect/drowsiness/drowsy = target.get_status_effect(/datum/status_effect/drowsiness)
			switch(drowsy.duration)
				if(0 to 100 SECONDS)
					to_chat(target, "You feel like a curtain is coming over your mind.")
					to_chat(owner, "The mind of [target] gives way slightly.")
					target.Slowdown(20)
					log_combat(owner, target, "weakly transfixed")
				if(101 SECONDS to 180 SECONDS)
					to_chat(target, "Your eyelids force themselves shut as you feel intense lethargy.")
					to_chat(owner, "[target] will not be able to resist much more.")
					target.set_eyes_closed(TRUE)
					target.Slowdown(50)
					log_combat(owner, target, "transfixed")
				if(180 SECONDS to INFINITY)
					to_chat(target, span_userdanger("You can't take it anymore. Your legs give out as you fall into the dreamworld."))
					to_chat(owner, "[target] is mine now.")
					target.set_eyes_closed(TRUE)
					target.Slowdown(50)
					log_combat(owner, target, "strongly transfixed")
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, Sleeping), 1 MINUTES), 5 SECONDS)
			continue

		if(!powerful)
			var/holypower = target.get_skill_level(/datum/skill/magic/holy)
			var/magicpower = round(target.get_skill_level(/datum/skill/magic/arcane) * 0.6, 1)
			var/roll = roll(1 + holypower + magicpower, 5)
			if(roll > bloodroll)
				to_chat(target, "I feel like the unholy magic came from [owner]. I should use my magic or miracles on them.")

		to_chat(owner, span_userdanger("I fail to ensnare the mind of [target]!"))
		to_chat(target, span_userdanger("Something is wrong in this place."))

/datum/action/cooldown/spell/undirected/transfix/master
	name = "Subjugate"
	button_icon_state = "transfixmaster"

	spell_cost = 150

	powerful = TRUE
