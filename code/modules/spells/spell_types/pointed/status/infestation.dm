/datum/action/cooldown/spell/status/infestation
	name = "Infestation"
	desc = "Causes a swarm of bugs to surround your target, bites them and causes sickness."
	button_icon_state = "infestation"
	self_cast_possible = FALSE
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1
	associated_skill = /datum/skill/magic/druidic
	attunements = list(
		/datum/attunement/dark = 0.3,
		/datum/attunement/death = 0.3,
	)

	invocation = "Rot, take them!"
	invocation_type = INVOCATION_SHOUT
	spell_flags = SPELL_RITUOS
	charge_time = 2 SECONDS
	cooldown_time = 60 SECONDS
	spell_cost = 20
	duration_scaling = TRUE
	duration_modification = 5 SECONDS
	status_effect = /datum/status_effect/debuff/infestation

/datum/status_effect/debuff/infestation
	id = "infestation"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/infestation
	duration = 10 SECONDS
	effectedstats = list(STATKEY_CON = -2)
	var/static/mutable_appearance/rotten = mutable_appearance('icons/roguetown/mob/rotten.dmi', "rotten")

/datum/status_effect/debuff/infestation/on_apply()
	. = ..()
	var/mob/living/target = owner
	to_chat(owner, span_danger("I am suddenly surrounded by a cloud of bugs!"))
	target.adjust_jitter(20 SECONDS)
	target.add_overlay(rotten)
	RegisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(wash_off))

/datum/status_effect/debuff/infestation/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT)
	owner.cut_overlay(rotten)

/datum/status_effect/debuff/infestation/proc/wash_off()
	qdel(src)

/datum/status_effect/debuff/infestation/tick()
	var/static/list/messages = list(
		"Ticks on my skin start to engorge with blood!",
		"Flies are laying eggs in my open wounds!",
		"Something crawled in my ear!",
		"There are too many bugs to count!",
		"They're trying to get under my skin!",
		"Make it stop!",
		"Millipede legs tickle the back of my ear!",
		"Fire ants bite at my feet!",
		"A wasp sting right on the nose!",
		"Cockroaches scurry across my neck!",
		"Maggots slimily wriggle along my body!",
		"Beetles crawl over my mouth!",
		"Fleas bite my ankles!",
		"Gnats buzz around my face!",
		"Lice suck my blood!",
		"Crickets chirp in my ears!",
		"Earwigs crawl into my ears!",
	)
	var/mob/living/L = owner

	L.adjustToxLoss(2)
	L.adjustBruteLoss(1)

	if(prob(33) && iscarbon(L))
		var/mob/living/carbon/C = L
		C.add_nausea(rand(10,20))
		to_chat(C, span_warning(pick(messages)))

/atom/movable/screen/alert/status_effect/debuff/infestation
	name = "Infestation"
	desc = "Pestilent vermin bite and chew at my skin."
	icon_state = "debuff"
