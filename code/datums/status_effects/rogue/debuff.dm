/datum/status_effect/debuff
	status_type = STATUS_EFFECT_REFRESH

///////////////////////////

/datum/status_effect/debuff/hungryt1
	id = "hungryt1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt1
	effectedstats = list(STATKEY_SPD = -1, STATKEY_STR = -1, STATKEY_CON = -1, STATKEY_END = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/hungryt1
	name = "Peckish, stomach growling"
	desc = "<span class='warning'>I am getting hungry.</span>\n"
	icon_state = "hunger1"

/datum/status_effect/debuff/hungryt1/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/peckish)

/datum/status_effect/debuff/hungryt1/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/peckish)

/datum/status_effect/debuff/hungryt2
	id = "hungryt2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt2
	effectedstats = list(STATKEY_SPD = -4, STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_END = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/hungryt2
	name = "Hungry, need food"
	desc = "<span class='warning'>My stomach hurts, I need food.</span>\n"
	icon_state = "hunger2"

/datum/status_effect/debuff/hungryt2/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/hungry)

/datum/status_effect/debuff/hungryt2/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/hungry)

/datum/status_effect/debuff/hungryt3
	id = "hungryt3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt3
	effectedstats = list(STATKEY_SPD = -6, STATKEY_STR = -6, STATKEY_CON = -6, STATKEY_END = -6)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/hungryt3
	name = "STARVING"
	desc = "<span class='boldwarning'>I AM STARVING!</span>\n"
	icon_state = "hunger3"

/datum/status_effect/debuff/hungryt3/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/starving)

/datum/status_effect/debuff/hungryt3/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/starving)

/datum/status_effect/debuff/hungryt4
	id = "hungryt4"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt4
	duration = 100


//Used only when starvation damage is enabled
/atom/movable/screen/alert/status_effect/debuff/hungryt4
	name = "Dying of Starvation"
	desc = "<span class='boldwarning'>I am dying of starvation! I need to find food, quick!</span>\n"
	icon_state = "hunger4"

/datum/status_effect/debuff/hungryt4/tick()
	owner.adjustToxLoss(CONFIG_GET(number/starvation_damage_per_tick))

/datum/status_effect/debuff/hungryt4/on_apply()
	. = ..()
	to_chat(owner, "<span class='danger'>I am starving to death! I need to eat something before it's too late!</span>")

/datum/status_effect/debuff/wiz
	id = "wiz"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/wiz
	effectedstats = list(STATKEY_INT = -5)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/wiz
	name = "Fading Power"
	desc = "My magical power wanes..."
	icon_state = "hunger3"
////////////////////


/datum/status_effect/debuff/thirstyt1
	id = "thirsty1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt1
	effectedstats = list(STATKEY_END = -1, STATKEY_SPD = -1)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/thirstyt1
	name = "Getting thirsty"
	desc = "<span class='warning'>I could use a drink.</span>\n"
	icon_state = "thirst1"


/datum/status_effect/debuff/thirstyt1/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/drym)

/datum/status_effect/debuff/thirstyt1/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/drym)

/datum/status_effect/debuff/thirstyt2
	id = "thirsty2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt2
	effectedstats = list(STATKEY_SPD = -4, STATKEY_END = -4)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/thirstyt2
	name = "Extremly thirsty"
	desc = "<span class='warning'>If I don't drink something soon, my mouth will be sand.</span>\n"
	icon_state = "thirst2"

/datum/status_effect/debuff/thirstyt2/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/thirst)

/datum/status_effect/debuff/thirstyt2/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/thirst)

/datum/status_effect/debuff/thirstyt3
	id = "thirsty3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt3
	effectedstats = list(STATKEY_STR = -6, STATKEY_SPD = -6, STATKEY_END = -6)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/thirstyt3
	name = "Extreme Dehydration"
	desc = "<span class='boldwarning'>I AM DYING OF THIRST!</span>\n"
	icon_state = "thirst3"

/datum/status_effect/debuff/thirstyt3/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/parched)

/datum/status_effect/debuff/thirstyt3/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/parched)

/datum/status_effect/debuff/thirstyt4
	id = "thirstyt4"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt4
	duration = 100


//Used only when starvation damage is enabled
/atom/movable/screen/alert/status_effect/debuff/thirstyt4
	name = "Dying of Thirst"
	desc = "<span class='boldwarning'>I am dying of thirst! I need to find water, quick!</span>\n"
	icon_state = "thirst4"

/datum/status_effect/debuff/thirstyt4/tick()
	owner.adjustToxLoss(CONFIG_GET(number/dehydration_damage_per_tick))

/datum/status_effect/debuff/thirstyt4/on_apply()
	. = ..()
	to_chat(owner, "<span class='danger'>I am dying of thirst! I need to find water before it's too late!</span>")

/////////

/datum/status_effect/debuff/uncookedfood
	id = "uncookedfood"
	effectedstats = null
	duration = 10 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/uncookedfood

/atom/movable/screen/alert/status_effect/debuff/uncookedfood
	name = "Raw Food!"
	desc = "<span class='warning'>Augh! Why didn't I bring that food to fire?!</span>\n"
	icon_state = "uncookedfood"

/datum/status_effect/debuff/uncookedfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_NASTY_EATER) || HAS_TRAIT(owner, TRAIT_ORGAN_EATER))
		return FALSE
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(100)
		C.add_stress(/datum/stress_event/uncookedfood)

/datum/status_effect/debuff/badmeal
	alert_type = /atom/movable/screen/alert/status_effect/debuff/badmeal
	id = "badmeal"
	effectedstats = null
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/debuff/badmeal
	name = "Foul Food!"
	desc = "<span class='warning'>That tasted vile!</span>\n"
	icon_state = "badmeal"

/datum/status_effect/debuff/badmeal/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/badmeal)

/datum/status_effect/debuff/burnedfood
	alert_type = /atom/movable/screen/alert/status_effect/debuff/burntmeal
	id = "burnedfood"
	effectedstats = null
	duration = 10 MINUTES

/datum/status_effect/debuff/burnedfood/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/burntmeal)
		C.add_nausea(100)

/atom/movable/screen/alert/status_effect/debuff/burntmeal
	name = "Burnt Food!"
	desc = "<span class='warning'>That tasted like charcoal and cinder!</span>\n"
	icon_state = "burntmeal"

/datum/status_effect/debuff/rotfood
	alert_type = /atom/movable/screen/alert/status_effect/debuff/rotfood
	id = "rotfood"
	effectedstats = null
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/debuff/rotfood
	name = "Rotten Food!"
	desc = "<span class='warning'>MAGGOT-INFESTED BILE RISES TO MY THROAT!</span>\n"
	icon_state = "burntmeal"

/datum/status_effect/debuff/rotfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_ROT_EATER))
		return FALSE
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(200)
		C.add_stress(/datum/stress_event/rotfood)

/datum/status_effect/debuff/bleeding
	id = "bleedingt1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt1
	effectedstats = list(STATKEY_SPD = -2)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/bleedingt1
	name = "Dizzy"
	desc = "<span class='warning'>Gah! I am bleeding!</span>\n"
	icon_state = "bleed1"

/datum/status_effect/debuff/bleedingworse
	id = "bleedingt2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt2
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -4)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/bleedingt2
	name = "Faint"
	desc = "<span class='warning'>I am bleeding heavily! Help!</span>\n"
	icon_state = "bleed2"

/datum/status_effect/debuff/bleedingworst
	id = "bleedingt3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt3
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -6)
	duration = 100

/atom/movable/screen/alert/status_effect/debuff/bleedingt3
	name = "Drained"
	desc = "<span class='boldwarning'>I feel like I am dying... so... weak...</span>\n"
	icon_state = "bleed3"

/datum/status_effect/debuff/sleepytime
	id = "sleepytime"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/sleepytime
	effectedstats = list(STATKEY_SPD = -2, STATKEY_END = -2)

/datum/status_effect/debuff/sleepytime/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/sleepytime)

/datum/status_effect/debuff/sleepytime/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/sleepytime)

// We use this to not have triumph gain and dreaming tied to tiredness
/datum/status_effect/debuff/dreamytime
	id = "dreamytime"
	alert_type = null

/atom/movable/screen/alert/status_effect/debuff/netted
	name = "Net"
	desc = "<span class='boldwarning'>A net was thrown on me... how can I move?</span>\n"
	icon_state = "muscles"

/datum/status_effect/debuff/netted
	id = "net"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/netted
	duration = 2 MINUTES
	effectedstats = list(STATKEY_SPD = -5, STATKEY_END = -2)

/datum/status_effect/debuff/netted/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, multiplicative_slowdown = 3)

/datum/status_effect/debuff/netted/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN)
		// Already handled in uncuff()
		/*
		C.legcuffed = null
		C.update_inv_legcuffed()*/



/atom/movable/screen/alert/status_effect/debuff/sleepytime
	name = "Tired"
	desc = "<span class='warning'>I am feeling tired.</span>\n"
	icon_state = "sleepy"

/datum/status_effect/debuff/trainsleep
	id = "trainsleep"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/trainsleep
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -1, STATKEY_END = -1)

/atom/movable/screen/alert/status_effect/debuff/trainsleep
	name = "Muscle Soreness"
	desc = "<span class='warning'>Gaaaah, So sooooooore.</span>\n"
	icon_state = "muscles"

/datum/status_effect/debuff/barbfalter
	id = "barbfalter"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/barbfalter
	duration = 30 SECONDS
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/debuff/barbfalter
	name = "Faltering"
	desc = "<span class='warning'>I've pushed myself to my limit.</span>\n"
	icon_state = "muscles"

/datum/status_effect/debuff/revive
	id = "revive"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/revive
	duration = 15 MINUTES
	effectedstats = list(STATKEY_STR = -4, STATKEY_SPD = -3, STATKEY_END = -3, STATKEY_CON = -4)

/atom/movable/screen/alert/status_effect/debuff/revive
	name = "Revival Sickness"
	desc = "<span class='warning'>I have returned from oblivion... but the fatigue of death still affects me.</span>\n"
	icon_state = "muscles"

/datum/status_effect/debuff/chilled
	id = "chilled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/chilled
	effectedstats = list(STATKEY_SPD = -5, STATKEY_STR = -2, STATKEY_END = -2)
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/chilled
	name = "Chilled"
	desc = "I can barely feel my limbs!"
	icon_state = "chilled"

/datum/status_effect/debuff/vamp_dreams
	id = "sleepytime"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vamp_dreams

/atom/movable/screen/alert/status_effect/debuff/vamp_dreams
	name = "Insight"
	desc = "With some sleep in a coffin I feel like I could become better."
	icon_state = "sleepy"

/datum/status_effect/eorapacify
	id = "eorapacify"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	duration = 85
	alert_type = null

/datum/status_effect/eorapacify/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, "[type]")
	return ..()

/datum/status_effect/eorapacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "[type]")
	return ..()

/datum/status_effect/debuff/eoradrunk
	id = "eoradrunk"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/drunk
	effectedstats = list(STATKEY_STR = -2, STATKEY_LCK = -5, STATKEY_PER = -2, STATKEY_SPD = -3) //debuff stats important in attacking
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/debuff/drunk
	name = "Eoran Wine"
	desc = span_warning("I am intoxicated from ambrosia not meant for mortal mouths.\n")
	icon_state = "drunk"

/datum/status_effect/debuff/mesmerised
	id = "mesmerised"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/mesmerised
	effectedstats = list(STATKEY_STR = -2, STATKEY_LCK = -2, STATKEY_PER = -2, STATKEY_SPD = -2) //
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/mesmerised
	name = "Mesmerised"
	desc = span_warning("Their beauty is otherworldly...")
	icon_state = "acid"


/datum/status_effect/debuff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	effectedstats = list(STATKEY_END = -2, STATKEY_CON = -2)
	duration = 2.5 MINUTES

/atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	name = "Call to Slaughter"
	desc = "A putrid rotting scent fills your nose as Graggar's call for slaughter rattles you to your core..."
	icon_state = "call_to_slaughter"

/datum/status_effect/debuff/baothadruqks
	id = "baothadruqks"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/baothadruqks
	effectedstats = list(STATKEY_PER = -2, STATKEY_SPD = -1, STATKEY_LCK = -5)
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/debuff/baothadruqks
	name = "Baothan Dust"
	desc = span_warning("Someone blew some powders at me...\n")
	icon_state = "drunk"

/datum/status_effect/debuff/lux_drained
	id = "lux_drained"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/lux_drained
	effectedstats = list(STATKEY_LCK = -3, STATKEY_CON = -1, STATKEY_END = -1, STATKEY_INT = -1, STATKEY_PER = -1, STATKEY_SPD = -1, STATKEY_STR = -1)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/lux_drained
	name = "Lux Drained"
	desc = span_danger("I can't feel my soul, WHY CAN'T I FEEL MY SOUL!\n")

//charflaw variant of lux_drained, used when the flaw is selected
/datum/status_effect/debuff/flaw_lux_taken
	id = "lux_taken"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/flaw_lux_taken
	effectedstats = list(STATKEY_LCK = -3, STATKEY_CON = -1, STATKEY_END = -1, STATKEY_INT = -1, STATKEY_PER = -1, STATKEY_SPD = -1, STATKEY_STR = -1)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/flaw_lux_taken
	name = "Lux Drained"
	desc = span_danger("Oh- \n I don't... have it anymore.\n")


/datum/status_effect/debuff/stinky_person
	id = "stinky_person"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/stinky_person
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/stinky_person
	name = "Stinky Person"
	desc = "<span class='warning'>I smell HORRID.</span>\n"
	icon_state = "stinky" //TODO add icon

/datum/status_effect/debuff/stinky_person/on_apply()
	. = ..()
	owner.AddComponent(/datum/component/rot/stinky_person)

/datum/status_effect/debuff/stinky_person/on_remove()
	. = ..()
	var/datum/component/stinky_component = GetComponent(/datum/component/rot/stinky_person)
	stinky_component?.RemoveComponent()

/datum/status_effect/debuff/tainted_lux
	id = "tainted_lux"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/tainted_lux
	effectedstats = list(STATKEY_LCK = -2)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/tainted_lux
	name = "Tainted Lux"
	desc = span_danger("Something within me is broken... what was once bright now writhes with a poisoned pulse...")

/datum/status_effect/debuff/received_tainted_lux
	id = "received_tainted_lux"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/received_tainted_lux
	effectedstats = list(STATKEY_LCK = -2)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/received_tainted_lux
	name = "Received Tainted Lux"
	desc = span_danger("It stirs inside me... but it is wrong, twisted... if this is a soul, then it has been corrupted long before it reached me...")

/datum/status_effect/debuff/corrupted_by_tainted_lux
	id = "corrupted_by_tainted_lux"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/corrupted_by_tainted_lux
	effectedstats = list(STATKEY_LCK = -4)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/corrupted_by_tainted_lux
	name = "Corrupted..."
	desc = span_danger("It filled my veins with light and rot alike... I can feel it crawling under my skin, whispering that I should never have done it...")

/datum/status_effect/debuff/electrified
	id = "electrified"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/electrified
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/shock_strength = 30
	var/static/mutable_appearance/electric = mutable_appearance('icons/effects/effects.dmi', "electricity")

/datum/status_effect/debuff/electrified/on_apply()
	. = ..()
	to_chat(owner, span_warning("Your body crackles with electricity!"))
	if(isliving(owner))
		var/mob/living/L = owner
		RegisterSignal(L, COMSIG_MOVABLE_MOVED, PROC_REF(check_conductive_surface))
		L.add_overlay(electric)

/datum/status_effect/debuff/electrified/on_remove()
	. = ..()
	if(isliving(owner))
		var/mob/living/L = owner
		UnregisterSignal(L, COMSIG_MOVABLE_MOVED)
		L.cut_overlay(electric)

/datum/status_effect/debuff/electrified/proc/check_conductive_surface()
	SIGNAL_HANDLER
	var/mob/living/L = owner
	if(!L)
		return

	var/turf/T = get_turf(L)
	if(!T)
		return

	for(var/atom/A in list(T) + T.contents)
		if(A.flags_1 & CONDUCT_1)
			L.visible_message(span_warning("[L] gets shocked!"), span_danger("Electricity courses through your body!"))
			L.electrocute_act(shock_strength, src)
			return

/atom/movable/screen/alert/status_effect/debuff/electrified
	name = "Electrified"
	desc = "Your body is charged with unstable electricity!"
	icon_state = "dazed"

/datum/status_effect/debuff/cursed
	id = "cursed"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/cursed
	effectedstats = list(STATKEY_LCK = -5) // More severe so that the permanent debuff from having the perk makes it actually worth it.
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/debuff/cursed
	name = "Cursed"
	desc = "Necra has punished me by my blasphemous deeds with terribly bad luck."
	icon_state = "debuff"
