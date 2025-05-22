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
		C.add_stress(/datum/stressevent/peckish)

/datum/status_effect/debuff/hungryt1/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/peckish)

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
		C.add_stress(/datum/stressevent/hungry)

/datum/status_effect/debuff/hungryt2/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/hungry)

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
		C.add_stress(/datum/stressevent/starving)

/datum/status_effect/debuff/hungryt3/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/starving)

//SILVER DAGGER EFFECT

/datum/status_effect/debuff/silver_curse
	id = "silver_curse"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/silver_curse
	effectedstats = list(STATKEY_STR = -2, STATKEY_PER = -2, STATKEY_INT = -2, STATKEY_CON = -2, STATKEY_END = -2, STATKEY_SPD = -2, STATKEY_LCK = -2)
	duration = 1 MINUTES

/*	Pointless subtype, code doesnt handle it well, dont use
/datum/status_effect/debuff/silver_curse/greater
	duration = 10 SECONDS
*/
/atom/movable/screen/alert/status_effect/debuff/silver_curse
	name = "Silver Curse"
	desc = "My BANE!"
	icon_state = "hunger3"

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
		C.add_stress(/datum/stressevent/drym)

/datum/status_effect/debuff/thirstyt1/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/drym)

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
		C.add_stress(/datum/stressevent/thirst)

/datum/status_effect/debuff/thirstyt2/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/thirst)

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
		C.add_stress(/datum/stressevent/parched)

/datum/status_effect/debuff/thirstyt3/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/parched)

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
		C.add_stress(/datum/stressevent/uncookedfood)

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
		C.add_stress(/datum/stressevent/badmeal)

/datum/status_effect/debuff/burnedfood
	alert_type = /atom/movable/screen/alert/status_effect/debuff/burntmeal
	id = "burnedfood"
	effectedstats = null
	duration = 10 MINUTES

/datum/status_effect/debuff/burnedfood/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stressevent/burntmeal)
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
		C.add_stress(/datum/stressevent/rotfood)

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
		C.add_stress(/datum/stressevent/sleepytime)

/datum/status_effect/debuff/sleepytime/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stressevent/sleepytime)

// We use this to not have triumph gain and dreaming tied to tiredness
/datum/status_effect/debuff/dreamytime
	id = "dreamytime"
	alert_type = null

/atom/movable/screen/alert/status_effect/debuff/netted
	name = "Net"
	desc = "<span class='boldwarning'>A net was thrown on me.. how can I move?</span>\n"
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
	desc = "<span class='warning'>I have returned from oblivion.. but the fatigue of death still affects me.</span>\n"
	icon_state = "muscles"

/datum/status_effect/debuff/viciousmockery
	id = "viciousmockery"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/viciousmockery
	duration = 1 MINUTES
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2,STATKEY_END = -2)

/atom/movable/screen/alert/status_effect/debuff/viciousmockery
	name = "Vicious Mockery"
	desc = "<span class='warning'>THAT SPOONY BARD! ARGH!</span>\n"
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

/datum/status_effect/eorapacify/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

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
	desc = span_warning("I am intoxicated from ambromsia not meant for mortal mouths.\n")
	icon_state = "drunk"

/datum/status_effect/debuff/forestguard
	id = "forestguard"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/forestguard
	effectedstats = list(STATKEY_STR = -2, STATKEY_PER = -2, STATKEY_CON = -2, STATKEY_END = -2, STATKEY_SPD = -2, STATKEY_LCK = -2)
	duration = INFINITY

/atom/movable/screen/alert/status_effect/debuff/forestguard
	name = "Foreign Lands"
	desc = span_warning("Goblins hide in the alleys! I must return to the forest!\n")
	icon_state = "debuff"
