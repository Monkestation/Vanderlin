
/datum/quirk/vice/hunted
	name = "Hunted"
	desc = "Something in your past has made you a target. You're always looking over your shoulder. THIS IS A DIFFICULT QUIRK - You will be hunted and have assassination attempts made against you without any escalation. EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."
	point_value = 5
	customization_type = QUIRK_TEXT
	customization_label = "Why are you being hunted?"
	customization_placeholder = "Fleeing prison."
	var/logged = FALSE


/datum/quirk/vice/hunted/get_desc(datum/preferences/prefs)
	var/reason = prefs?.quirk_customizations[type]
	if(!reason)
		reason = customization_value
	if(reason && reason != "")
		return "[desc]<br><br><b>Reason:</b> [reason]"
	return "[desc]<br><br><b>Reason:</b> Unknown - a mystery from your past."

/datum/quirk/vice/hunted/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!logged && H.name)
		log_hunted("[H.ckey] playing as [H.name] has the hunted quirk.")
		logged = TRUE

/datum/quirk/vice/luxless
	name = "Lux-less"
	desc = "Through some grand misfortune, or heroic sacrifice - you have given up your link to Psydon, and with it - your soul. A putrid, horrid thing, you consign yourself to an eternity of nil after death. EXPECT A DIFFICULT, MECHANICALLY UNFAIR EXPERIENCE. (Rakshari, Hollowkin and Kobolds cannot take this - they already have no lux.)"
	point_value = 5
	random_exempt = TRUE
	blocked_species = list(
		/datum/species/kobold,
		/datum/species/demihuman,
		/datum/species/rakshari,
		/datum/species/rousman,
		/datum/species/goblin,
		/datum/species/orc,
	)

/datum/quirk/vice/luxless/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.apply_status_effect(/datum/status_effect/debuff/flaw_lux_taken)

/datum/quirk/vice/pacifist
	name = "Pacifist"
	desc = "I don't want to harm other living beings!"
	point_value = 8

/datum/quirk/vice/pacifist/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	// Check if player is an antagonist
	if(H.mind && ((H.mind in GLOB.pre_setup_antags) || H.mind.has_antag_datum(/datum/antagonist)))
		to_chat(H, span_warning("As an antagonist, you cannot be a pacifist. This quirk has been removed."))
		return

	ADD_TRAIT(owner, TRAIT_PACIFISM, "[type]")

/datum/quirk/vice/pacifist/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_PACIFISM, "[type]")

/datum/quirk/vice/chronic_migraine
	name = "Chronic Migraines"
	desc = "You suffer from frequent, debilitating headaches that can strike without warning."
	point_value = 3

/datum/quirk/vice/chronic_migraine/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.body_zone == BODY_ZONE_HEAD)
			BP.chronic_pain = rand(17.5, 27.5)
			BP.chronic_pain_type = CHRONIC_NERVE_DAMAGE
			break
	to_chat(H, span_warning("You feel the familiar pressure building behind your eyes."))

/datum/quirk/vice/chronic_migraine/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(prob(2))
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_HEAD)
				BP.lingering_pain += rand(25, 40)
				break

		if(prob(30))
			H.set_eye_blur_if_lower(rand(6 SECONDS, 12 SECONDS))
			to_chat(H, span_boldwarning("A severe migraine strikes! Your vision blurs and your head pounds!"))
		else
			to_chat(H, span_warning("A migraine headache begins to build."))

	if(prob(1))
		var/obj/item/bodypart/head = null
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_HEAD)
				head = BP
				break

		if(head && head.lingering_pain > 20 && H.loc && H.loc.luminosity > 2)
			head.lingering_pain += rand(5, 10)
			to_chat(H, span_warning("The flickering flames make your migraine worse!"))


/datum/quirk/vice/skill_issue
	name = "Skill Issue"
	desc = "You were never the best at anything, and it shows. Lose 1 point to all starting skills."
	point_value = 5

/datum/quirk/vice/skill_issue/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	for(var/datum/skill/skill in SSskills.all_skills)
		if(H.get_skill_level(skill) > SKILL_LEVEL_NONE)
			H.adjust_skillrank(skill, -1, TRUE)

/datum/quirk/vice/deaf
	name = "Hard of Hearing"
	desc = "You can barely hear. Words said outside of a 2 tile radius become jumbled or unreadable unless screamed."
	point_value = 3

/datum/quirk/vice/deaf/on_spawn()
	if(!ishuman(owner))
		return
	ADD_TRAIT(owner, TRAIT_PARTIAL_DEAF, "[type]")

/datum/quirk/vice/deaf/on_remove()
	if(!ishuman(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_PARTIAL_DEAF, "[type]")

/datum/quirk/vice/traumatized
	name = "Traumatized"
	desc = "You were an adventurer once, till you took something to the knee. Choose something to be afraid of."
	point_value = 3
	customization_label = "Choose Fear"
	customization_options = list(
		/datum/species/goblin,
		/datum/species/werewolf,
		/datum/species/orc,
		/datum/species/halforc,
		/datum/species/halfling,
		/datum/species/demihuman,
		/datum/species/dwarf,
		/datum/species/elf,
		/datum/species/triton,
		/datum/species/rakshari,
		/datum/species/kobold,
		/datum/oratorium,
		"Nobles",
	)

	var/fear_type
	var/next_scream_time = 0

/datum/quirk/vice/traumatized/on_spawn()
	if(!ishuman(owner))
		return
	if(!customization_value)
		customization_value = /datum/species/goblin
	fear_type = customization_value

/datum/quirk/vice/traumatized/on_life(mob/living/user)
	if(world.time < next_scream_time)
		return
	if(ispath(fear_type, /datum/species))
		for(var/mob/living/carbon/human/human in view(5, user))
			if(human == user)
				continue
			if(is_species(human, fear_type))
				var/mob/living/carbon/human/H = user
				H.emote("scream")
				H.Immobilize(1.5 SECONDS)
				H.add_stress(/datum/stress_event/traumatized)
				to_chat(H, span_userdanger("You see [human] and freeze in terror!"))
				next_scream_time = world.time + 25 SECONDS
				return
	else if(fear_type == "Nobles")
		for(var/mob/living/carbon/human/human in view(5, user))
			if(human == user)
				continue
			if(human.is_noble())
				var/mob/living/carbon/human/H = user
				H.emote("scream")
				H.Immobilize(1.5 SECONDS)
				H.add_stress(/datum/stress_event/traumatized)
				to_chat(H, span_userdanger("You see [human] and freeze in terror!"))
				next_scream_time = world.time + 25 SECONDS
				return
	else
		for(var/mob/living/carbon/human/human in view(5, user))
			if(human == user)
				continue
			if(HAS_TRAIT(human, TRAIT_INQUISITION))
				var/mob/living/carbon/human/H = user
				H.emote("scream")
				H.Immobilize(1.5 SECONDS)
				H.add_stress(/datum/stress_event/traumatized)
				to_chat(H, span_userdanger("You see [human] and freeze in terror!"))
				next_scream_time = world.time + 25 SECONDS
				return


/datum/stress_event/traumatized
	desc = "<span class='danger'>I saw one of THOSE things again!</span>\n"
	stress_change = 5
	timer = 5 MINUTES

/datum/quirk/vice/tortured
	name = "Tortured"
	desc = "You were once tortured by bandits, Drow raiders, or your own kingdom. You fear it happening again and always answer truthfully when tortured."
	point_value = 2

/datum/quirk/vice/tortured/on_spawn()
	if(!ishuman(owner))
		return
	ADD_TRAIT(owner, TRAIT_TORTURED, "[type]")

/datum/quirk/vice/tortured/on_remove()
	if(!ishuman(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_TORTURED, "[type]")

/datum/stress_event/tortured
	desc = "<span class='danger'>The pain... it brings back memories.</span>\n"
	stress_change = 4
	timer = 5 MINUTES

/datum/quirk/vice/hardcore
	name = "Hardcore"
	desc = "ONE CHANCE. When you die, you have no place in the underworld. You will be reincarnated as a rat, unable to do anything."
	point_value = 3
	random_exempt = TRUE
	var/turning = FALSE

/datum/quirk/vice/hardcore/on_spawn()
	if(!ishuman(owner))
		return
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(owner, COMSIG_LIVING_TRY_ENTER_AFTERLIFE, PROC_REF(on_death))
	to_chat(owner, span_boldwarning("You have chosen HARDCORE mode. If you die, you will become a rat. There are no second chances."))

/datum/quirk/vice/hardcore/on_remove()
	if(!ishuman(owner))
		return
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)
	UnregisterSignal(owner, COMSIG_LIVING_TRY_ENTER_AFTERLIFE)

/datum/quirk/vice/hardcore/proc/on_death(mob/living/source)
	if(turning)
		return TRUE
	if(!ishuman(source))
		return

	addtimer(CALLBACK(src, PROC_REF(transform_to_rat), source), 3 SECONDS)
	turning = TRUE
	return TRUE

/datum/quirk/vice/hardcore/proc/transform_to_rat(mob/living/carbon/human/H)
	turning = FALSE

	if(!H.mind)
		return

	var/turf/T
	if(!H || QDELETED(H))
		T = get_turf(pick(SSjob.latejoin_trackers))
	else
		T = get_turf(H)
	if(!T)
		return

	var/mob/living/simple_animal/hostile/retaliate/smallrat/new_rat = new(T)

	if(H.mind)
		H.mind.transfer_to(new_rat)

	to_chat(new_rat, span_userdanger("You have been reincarnated as a rat. Your adventure ends here."))

	// Make the rat unable to do much
	ADD_TRAIT(new_rat, TRAIT_PACIFISM, QUIRK_TRAIT)
	ADD_TRAIT(new_rat, TRAIT_MUTE, QUIRK_TRAIT)
	new_rat.melee_damage_lower = 0
	new_rat.melee_damage_upper = 0
	new_rat.obj_damage = 0
	new_rat.status_flags |= GODMODE
	ADD_TRAIT(new_rat, TRAIT_NOFIRE, QUIRK_TRAIT)

/datum/quirk/vice/weak_heart
	name = "Weak Heart"
	desc = "You were born with a weak heart. You can't handle stressful situations for fear of your heart giving out (Half threshold for heart attacks and heart attack from being overly stressed)."
	point_value = 6
	incompatible_quirks = list(
		/datum/quirk/boon/iron_will
	)

/datum/quirk/vice/weak_heart/on_spawn()
	if(!ishuman(owner))
		return
	ADD_TRAIT(owner, TRAIT_WEAK_HEART, "[type]")

/datum/quirk/vice/weak_heart/on_remove()
	if(!ishuman(owner))
		return
	REMOVE_TRAIT(owner, TRAIT_WEAK_HEART, "[type]")

/datum/quirk/vice/tremors
	name = "Tremors"
	desc = "Your body tremors periodically, causing you to drop what's in your hands and lose your grip for a short time. High stress makes the tremors worse."
	point_value = 4
	var/next_tremor_time = 0
	var/base_tremor_interval = 5 MINUTES
	var/stress_tremor_interval = 2 MINUTES

/datum/quirk/vice/tremors/on_spawn()
	if(!owner)
		return
	schedule_next_tremor()

/datum/quirk/vice/tremors/on_life()
	if(!owner)
		return

	if(world.time >= next_tremor_time)
		trigger_tremor()
		schedule_next_tremor()

/datum/quirk/vice/tremors/proc/schedule_next_tremor()
	if(!owner)
		return

	var/mob/living/carbon/human/H = owner
	var/tremor_interval = base_tremor_interval

	if(H.stress >= 6)
		tremor_interval = stress_tremor_interval
	else if(H.stress >= 4) // Medium stress
		tremor_interval = (base_tremor_interval + stress_tremor_interval) / 2

	// Add some randomness so it's not perfectly predictable
	tremor_interval = tremor_interval + rand(-30 SECONDS, 30 SECONDS)
	next_tremor_time = world.time + tremor_interval

/datum/quirk/vice/tremors/proc/trigger_tremor()
	if(!owner)
		return

	var/mob/living/carbon/human/H = owner

	// Visual and audio feedback
	to_chat(H, span_warning("Your hands begin to shake uncontrollably!"))
	H.visible_message(span_warning("[H]'s hands begin trembling!"))

	// Drop everything in hands
	for(var/obj/item/I in H.held_items)
		if(I)
			H.dropItemToGround(I)
			to_chat(H, span_warning("You drop [I] as your hands shake!"))

	// Apply temporary inability to grip
	H.apply_status_effect(/datum/status_effect/tremor_grip_loss)

	// Shake the screen slightly for immersion
	if(H.client)
		animate(H.client, pixel_x = rand(-2, 2), pixel_y = rand(-2, 2), time = 2)
		addtimer(CALLBACK(src, PROC_REF(reset_screen_shake), H), 2)

/datum/quirk/vice/tremors/proc/reset_screen_shake(mob/living/carbon/human/H)
	if(H?.client)
		animate(H.client, pixel_x = 0, pixel_y = 0, time = 2)

/datum/status_effect/tremor_grip_loss
	id = "tremor_grip_loss"
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/tremor_grip_loss

/datum/status_effect/tremor_grip_loss/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = owner
	to_chat(H, span_warning("Your hands are shaking too much to grip anything!"))

	// Periodic shaking during the effect
	addtimer(CALLBACK(src, PROC_REF(shake_hands)), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(shake_hands)), 4 SECONDS)

	return TRUE

/datum/status_effect/tremor_grip_loss/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	to_chat(H, span_notice("Your hands steady themselves."))

/datum/status_effect/tremor_grip_loss/proc/shake_hands()
	if(!owner)
		return
	var/mob/living/carbon/human/H = owner
	H.visible_message(span_warning("[H]'s hands continue to tremble."), \
					  span_warning("Your hands continue to shake..."))

/atom/movable/screen/alert/status_effect/tremor_grip_loss
	name = "Trembling Hands"
	desc = "My hands are shaking uncontrollably! I can't grip anything!"

/datum/quirk/vice/heretic_outlaw
	name = "Heretic or Outlaw"
	desc = "You begin your journey marked as either a heretic or an outlaw, despised by society."
	point_value = 2
	customization_type = QUIRK_SELECT
	customization_label = "Choose your mark"
	customization_options = list("Heretic", "Outlaw")
	preview_render = FALSE

/datum/quirk/vice/heretic_outlaw/on_spawn()
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	if(!customization_value)
		customization_value = pick(customization_options)

	if(customization_value == "Heretic")
		GLOB.excommunicated_players += H.real_name
		to_chat(H, span_boldwarning("I've been denounced by the church for either reasons legitimate or not!"))
	else // Outlaw
		GLOB.outlawed_players |= H.real_name
		to_chat(H, span_boldwarning("Whether for crimes I did or was accused of, I have been declared an outlaw!"))
