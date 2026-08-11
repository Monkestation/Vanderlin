/datum/action/cooldown/spell/status/phantasm
	name = "Phantasm"
	desc = "Infest their dreams."
	button_icon_state = "dreamthisman2"
	self_cast_possible = TRUE
	sound = 'sound/magic/whiteflame.ogg'
	charge_sound = 'sound/magic/dreamchannel.ogg'

	invocation_type = INVOCATION_NONE
	spell_flags = SPELL_STAMINA
	charge_time = 2 SECONDS
	cooldown_time = 60 SECONDS
	spell_cost = 20
	status_effect = /datum/status_effect/debuff/phantasm

/datum/status_effect/debuff/phantasm
	id = "phantasm"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/phantasm
	duration = 60 SECONDS
	effectedstats = list(STAT_FORTUNE = -1)

/datum/status_effect/debuff/phantasm/on_apply()
	. = ..()
	var/mob/living/target = owner
	owner.add_stress(/datum/stress_event/phantasm)
	to_chat(owner, span_danger("I've seen that one before. In my dreams."))
	target.adjust_jitter(30 SECONDS)
	ADD_TRAIT(owner, TRAIT_DREAMWEAVERPHANTASM, "[type]")
	//target.adjust_drowsiness(10 SECONDS)
	// Slap a number that goes up here. Display it to the Dreamweaver. They want the number to go up because it's cool.

/datum/status_effect/debuff/phantasm/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_DREAMWEAVERPHANTASM, "[type]")
	//C.remove_stress(/datum/stress_event/phantasm)

/datum/status_effect/debuff/phantasm/tick()
	var/static/list/messages = list(
		"That face... Where have I seen that face?!",
		"It's real... My dream was real.",
		"It's coming to get me.",
		"It wants pain to be inflicted on others.",
		"It has no catharsis. It's punishment eludes itself.",
		"It's just an illusion! A moment's confusion - It MUST be! It has to be!",
		"There's an idea of folklore, some kind of abstraction. But there's no real monster. It can't be real.",
		"It wants to stab me to death and play around in my blood.",
		"It wants me dead. I can't escape it.",
		"I've seen that one before. In my dreams.",
		"This is a nightmare I can't wake from.",
		"It doesn't eat or drink anymore.",
		"It doesn't think. The lights are on but nobody's home.",
		"It's a monster. It's only a mask...",
		"I see it even when I close my eyes.",
		"<span class='smallnotice'>Where is here?</span>",
		"<span class='smallnotice'>What was that noise?</span>",
		"<span class='smallnotice'>I taste metal in my mouth.</span>",
		"<span class='smallnotice'>What time is it?</span>",
		"<span class='smallnotice'>Eyes in the dark...</span>",
		"<span class='bold notice'>Noc, just take it away. Please.</span>",
		"<span class='bold notice'>I thought this was a dream.</span>",
		"<span class='bold notice'>I promised myself I'd remember to forget. I forgot to remember to forget.</span>",
		"<span class='bold notice'>I saw it. Last nite. At the foot of my bed.</span>",
		"<span class='bold notice'>That smile... That smile...</span>",
		"<span class='redtextbig'>IT'S JUST A FAIRYTALE, MADE TO SCARE THE YOUNG.</span>",
		"<span class='redtextbig'>It's going to follow me, until it bores of me, and slits my throat open.</span>",
		"<span class='boldwarning'>I'm going to die.</span>",
		"<span class='boldwarning'>I can feel my heart lurching out of my chest.</span>",
		"<span class='boldwarning'>IT'S HERE. IT'S HERE.</span>",
		"<span class='boldwarning'>The blood of the innocent shall flow for a thousand years.</span>",
		"<span class='boldwarning'>I'M NOT READY. I'M NOT READY TO GO.'</span>",
		"<span class='boldwarning'>Not even my dreams are sacred.</span>",
		"<span class='boldwarning'>I feel sick. I'm nauseous. I need to see a physicker.</span>",
		"<span class='boldwarning'>That's not a Jacket. That's it's hide. Oh, Gods...</span>",
		"<span class='boldwarning'>It's here to take me away.</span>",
		"<span class='boldwarning'>Can't sleep. It's waiting for me. Can't sleep. It's waiting for me.</span>",
	)
	var/mob/living/L = owner

	L.adjustToxLoss(0.2)
	//if(prob(10))
	//	L.adjustBruteLoss(1, damage_type = BCLASS_BITE)

	if(prob(5) && iscarbon(L))
		var/mob/living/carbon/C = L
		C.add_nausea(rand(7,10))

	if(prob(5) && iscarbon(L))
		var/mob/living/carbon/C = L
		to_chat(C, span_warning(pick(messages)))

//	if(prob(1) && iscarbon(L))
//		var/mob/living/carbon/C = L
//		C.emote("whimper", forced = TRUE)
// Apparently due to the nature of forced emotes, THIS COULD CAUSE A CRASH IF THEY SLEEP. Shame, this is huge flaire. Disabling for now.

/atom/movable/screen/alert/status_effect/debuff/phantasm
	name = "Phantasm"
	desc = "Every night, all over the town, dozens of people see this man in their dreams. If this man appears in your dreams too, or you have any \
	information that can help us identify him, please caocttn su ta hte eknBro Oegr vteran yb hte .kscdo.."
	icon_state = "blackeye"

/datum/stress_event/phantasm
	desc = "<span class='boldwarning'>I feel like something bad is going to happen to me. I feel like something bad has happened. My reckoning won't be postponed indefinitely.</span>\n"
	stress_change = -2
	timer = 2 MINUTES

//=====	This spell is heavily tied into dreamweaverscreens
