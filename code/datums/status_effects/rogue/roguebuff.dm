/datum/status_effect/buff
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/buff/drunk
	id = "drunk"
	alert_type = /atom/movable/screen/alert/status_effect/buff/drunk
	effectedstats = list(STATKEY_INT = -1, STATKEY_SPD = -1, STATKEY_CON = 1)
	duration = 12 MINUTES

/atom/movable/screen/alert/status_effect/buff/drunk
	name = "Drunk"
	desc = span_nicegreen("I feel very drunk.")
	icon_state = "drunk"

/datum/status_effect/buff/drunk/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/drunk)
/datum/status_effect/buff/drunk/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/drunk)

/datum/status_effect/buff/foodbuff
	id = "foodbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/foodbuff
	effectedstats = list(STATKEY_CON = 1, STATKEY_END = 1)
	duration = 15 MINUTES

/atom/movable/screen/alert/status_effect/buff/foodbuff
	name = "Great Meal"
	desc = span_nicegreen("That was a good meal!")
	icon_state = "foodbuff"

/datum/status_effect/buff/foodbuff/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/goodfood)

//============= CLEAN PLUS ===============
/datum/status_effect/buff/clean_plus
	id = "cleanplus"
	alert_type = /atom/movable/screen/alert/status_effect/buff/clean_plus
	effectedstats = list(STATKEY_LCK = 1)
	duration = 10 MINUTES

/datum/status_effect/buff/clean_plus/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/clean_plus)

/atom/movable/screen/alert/status_effect/buff/clean_plus
	name = "Clean"
	desc = span_nicegreen("I feel very refreshed.")
	icon_state = "buff"	// add custom icon TO DO


/datum/status_effect/buff/druqks
	id = "druqks"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_INT = 4, STATKEY_SPD = 2, STATKEY_LCK = -5)
	duration = 2 MINUTES

/datum/status_effect/buff/druqks/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/high)
	var/atom/movable/plane_master_controller/pm_controller = owner.hud_used?.plane_master_controllers[PLANE_MASTERS_GAME]
	if(pm_controller)
		pm_controller.add_filter("druqks_ripple", 1, ripple_filter(0, 50, 1, x = 80))
		pm_controller.add_filter("druqks_color", 2, color_matrix_filter(list(0,0,1,0, 0,1,0,0, 1,0,0,0, 0,0,0,1, 0,0,0,0)))

/datum/status_effect/buff/druqks/on_remove()
	. = ..()
	owner.remove_stress(/datum/stress_event/high)
	var/atom/movable/plane_master_controller/pm_controller = owner.hud_used?.plane_master_controllers[PLANE_MASTERS_GAME]
	if(pm_controller)
		pm_controller.remove_filter(list("druqks_ripple", "druqks_color"))

/datum/status_effect/buff/druqks/baotha/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/buff/druqks/baotha/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRACKHEAD, TRAIT_STATUS_EFFECT(id))
	owner.visible_message("[owner]'s eyes appear to return to normal.")

/atom/movable/screen/alert/status_effect/buff/druqks
	name = "High"
	desc = span_nicegreen("Holy shit, I am tripping balls!")
	icon_state = "acid"

/datum/status_effect/buff/ozium
	id = "ozium"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = -4, STATKEY_PER = 2)
	duration = 2 MINUTES

/datum/status_effect/buff/ozium/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/ozium)
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/buff/ozium/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_STATUS_EFFECT(id))
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/ozium)

/datum/status_effect/buff/moondust
	id = "moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 2, STATKEY_END = 2, STATKEY_INT = -4)
	duration = 1 MINUTES

/datum/status_effect/buff/moondust/nextmove_modifier()
	return 0.5

/datum/status_effect/buff/moondust/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/moondust)

/datum/status_effect/buff/moondust/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/moondust)

/datum/status_effect/buff/moondust_purest
	id = "purest moondust"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_SPD = 4, STATKEY_END = 4, STATKEY_INT = -2)
	duration = 2 MINUTES

/datum/status_effect/buff/moondust_purest/nextmove_modifier()
	return 0.5

/datum/status_effect/buff/moondust_purest/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/moondust_purest)

/datum/status_effect/buff/moondust_purest/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/moondust_purest)


/datum/status_effect/buff/weed
	id = "weed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/weed
	effectedstats = list(STATKEY_INT = 2, STATKEY_SPD = -2,STATKEY_LCK = 2)
	duration = 5 MINUTES

/datum/status_effect/buff/weed/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/weed)

/datum/status_effect/buff/weed/on_remove()
	. = ..()
	owner.remove_stress(/datum/stress_event/weed)

/atom/movable/screen/alert/status_effect/buff/weed
	name = "Dazed"
	desc = span_nicegreen("I am so high maaaaaaaaan.")
	icon_state = "weed"

/atom/movable/screen/alert/status_effect/buff/featherfall
	name = "Featherfall"
	desc = "I am somewhat protected against falling from heights."
	icon_state = "buff"

/datum/status_effect/buff/featherfall
	id = "featherfall"
	alert_type = /atom/movable/screen/alert/status_effect/buff/featherfall
	duration = 1 MINUTES

/datum/status_effect/buff/featherfall/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel lighter."))
	ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE1, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/buff/featherfall/on_remove()
	. = ..()
	to_chat(owner, span_warning("The feeling of lightness fades."))
	REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE1, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/buff/darkvision
	id = "darkvision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/darkvision
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/darkvision
	name = "Darkvision"
	desc = span_nicegreen("I can see in the dark.")
	icon_state = "buff"

/datum/status_effect/buff/darkvision/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/eyes/eyes = H.getorgan(/obj/item/organ/eyes)
	if (!eyes || eyes.lighting_alpha)
		return
	ADD_TRAIT(owner, TRAIT_DARKVISION, TRAIT_STATUS_EFFECT(id))
	owner.update_sight()

/datum/status_effect/buff/darkvision/on_remove()
	. = ..()
	to_chat(owner, span_warning("Darkness shrouds your senses once more."))
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, TRAIT_STATUS_EFFECT(id))
	owner.update_sight()

/atom/movable/screen/alert/status_effect/buff/haste
	name = "Haste"
	desc = "I am magically hastened."

/datum/status_effect/buff/haste
	id = "haste"
	alert_type = /atom/movable/screen/alert/status_effect/buff/haste
	effectedstats = list(STATKEY_SPD = 3)
	duration = 1 MINUTES

/datum/status_effect/buff/calm
	id = "calm"
	alert_type = /atom/movable/screen/alert/status_effect/buff/calm
	effectedstats = list(STATKEY_LCK = 1)
	duration = 240 MINUTES

/atom/movable/screen/alert/status_effect/buff/calm
	name = "Calmness"
	desc = span_nicegreen("I feel a supernatural calm coming over me.")
	icon_state = "stressg"

/datum/status_effect/buff/calm/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/calm)

/datum/status_effect/buff/calm/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/calm)

/datum/status_effect/buff/barbrage
	id = "barbrage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/barbrage
	effectedstats = list(STATKEY_STR = 1, STATKEY_END = 2, STATKEY_PER = -2, STATKEY_INT = -2) //endurance to boost pain treshold, not powerful enough to warrant total painkilling
	duration = 30 SECONDS

/datum/status_effect/buff/adrenalinerush
	id = "adrenalinerush"
	alert_type = /atom/movable/screen/alert/status_effect/buff/adrenalinerush
	effectedstats = list(STATKEY_SPD = 4, STATKEY_END = 2, STATKEY_CON = 2) // Meant as a 'GET THE FUCK OUT' spell.
	duration = 2 MINUTES

/atom/movable/screen/alert/status_effect/buff/barbrage
	name = "Barbaric Rage"
	desc = span_nicegreen("WITNESS ME!")
	icon_state = "ravox"

/datum/status_effect/buff/barbrage/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.apply_status_effect(/datum/status_effect/debuff/barbfalter)

/atom/movable/screen/alert/status_effect/buff/adrenalinerush
	name = "Adrenaline Rush"
	desc = span_nicegreen("THE WIND IS PUSHING ME INTO THE CURRENT AGAIN! I FEEL THE BLOOD IN MY VEINS!")
	icon_state = "bestialsense"

/datum/status_effect/buff/adrenalinerush/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.apply_status_effect(/datum/status_effect/debuff/barbfalter)

//============================================================================
/*--------------\
|				|
| Divine Buffs	|
|		 	 	|
\---------------*/

// ---------------------- DIVINE KNOWLEDGE ( NOC ) ----------------------------
/datum/status_effect/buff/noc
	id = "nocbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nocbuff
	effectedstats = list(STATKEY_INT = 3)
	duration = 240 MINUTES

/atom/movable/screen/alert/status_effect/buff/nocbuff
	name = "Divine Knowledge"
	desc = span_nicegreen("Divine knowledge flows through me.")
	icon_state = "intelligence"



// ---------------------- DIVINE POWER ( RAVOX ) ----------------------------
/datum/status_effect/buff/ravox
	id = "ravoxbuff"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ravoxbuff
	effectedstats = list(STATKEY_CON = 1, STATKEY_END = 1, STATKEY_STR = 1)
	duration = 240 MINUTES

/atom/movable/screen/alert/status_effect/buff/ravoxbuff
	name = "Divine Power"
	desc = span_nicegreen("Divine power flows through me.")
	icon_state = "ravox"


/*-----------------\
|  Dendor Miracles |
\-----------------*/

// ---------------------- EYES OF THE BEAST ( DENDOR ) ----------------------------
/datum/status_effect/buff/beastsense
	id = "beastsense"
	alert_type = /atom/movable/screen/alert/status_effect/buff/beastsense
	effectedstats = list(STATKEY_PER = 2)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/buff/beastsense
	name = "Bestial Senses"
	desc = span_nicegreen("No scent too faint, no shadow too dark...")
	icon_state = "bestialsense"

/datum/status_effect/buff/beastsense/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/eyes/eyes = H.getorgan(/obj/item/organ/eyes)
	if(!eyes)
		return
	ADD_TRAIT(owner, TRAIT_BESTIALSENSE, REF(src))
	owner.update_sight()

/datum/status_effect/buff/beastsense/on_remove()
	. = ..()
	to_chat(owner, span_warning("Darkness shrouds your senses once more."))
	REMOVE_TRAIT(owner, TRAIT_BESTIALSENSE, REF(src))
	owner.update_sight()

// ---------------------- TROLL SHAPE ( DENDOR ) ----------------------------
/datum/status_effect/buff/trollshape
	id = "trollshape"
	alert_type = /atom/movable/screen/alert/status_effect/buff/trollshape
	effectedstats = list(STATKEY_STR = 4, STATKEY_END = 2, STATKEY_SPD = -2, STATKEY_INT = -4)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/trollshape
	name = "Troll Shape"
	desc = span_nicegreen("I AM STRONG! DENDOR'S ENEMIES WILL DIE!")
	icon_state = "trollshape"
/datum/status_effect/buff/trollshape/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/human/C = owner
		C.resize = 1.2
		C.update_transform()
		C.RemoveElement(/datum/element/footstep, C.footstep_type, 1, -6)
		C.AddElement(/datum/element/footstep, FOOTSTEP_MOB_HEAVY, 1, -2)

/datum/status_effect/buff/trollshape/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/human/C = owner
		C.emote("pain", forced = TRUE)
		playsound(C, 'sound/gore/flesh_eat_03.ogg', 100, TRUE)
		to_chat(C, span_warning("Dendor's transformation fades, flesh shrinking back. My body aches..."))
		C.adjustBruteLoss(10)
		C.apply_status_effect(/datum/status_effect/debuff/barbfalter)
		C.resize = (1/1.2)
		C.update_transform()
		C.RemoveElement(/datum/element/footstep, FOOTSTEP_MOB_HEAVY, 1, -2)
		C.AddElement(/datum/element/footstep, C.footstep_type, 1, -6)

// ---------------------- BRIAR'S RAGE ( DENDOR ) ----------------------------
/datum/status_effect/buff/barbrage/briarrage //barbarian rage but it's permanent and exclusive to the briar
	id = "briarrage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/barbrage/briarrage
	effectedstats = list(STATKEY_STR = 1, STATKEY_END = 2, STATKEY_PER = -2, STATKEY_INT = -2)
	duration = -1

/atom/movable/screen/alert/status_effect/buff/barbrage/briarrage
	name = "Dendor's frenzy"
	desc = span_nicegreen("EMBRACE WILDERNESS")
	icon_state = "bestialsense"

/*-----------------\
|   Eora Miracles  |
\-----------------*/

/datum/status_effect/buff/divine_beauty
	id = "divine_beauty"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_beauty
	duration = 5 MINUTES

/datum/status_effect/buff/divine_beauty/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/divine_beauty)

/datum/status_effect/buff/divine_beauty/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/divine_beauty)

/atom/movable/screen/alert/status_effect/buff/divine_beauty
	name = "Divine Beauty"
	desc = span_nicegreen("Everything about myself feels beautiful!")
	icon_state = "beauty"

/*-----------------\
|   Ravox Miracles |
\-----------------*/

/datum/status_effect/buff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_arms
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_END = 2, STATKEY_CON = 2)

/atom/movable/screen/alert/status_effect/buff/call_to_arms
	name = "Call to Arms"
	desc = span_bloody("THE FIGHT WILL BE BLOODY!")
	icon_state = "call_to_arms"

/*-----------------\
|   Malum Miracles |
\-----------------*/

/datum/status_effect/buff/craft_buff
	id = "crafting_buff_malum"
	alert_type = /atom/movable/screen/alert/status_effect/buff/craft_buff
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_INT = 2)

/atom/movable/screen/alert/status_effect/buff/craft_buff
	name = "Exquisite Craftsmanship"
	desc = span_notice("I am inspired to create!")
	icon_state = "malum_buff"


/*-----------------\
|   Inhumen Miracles |
\-----------------*/

/datum/status_effect/buff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_END = 1, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	name = "Call to Slaughter"
	desc = span_bloody("LAMBS TO THE SLAUGHTER!")
	icon_state = "call_to_slaughter"


#define BLOODRAGE_FILTER "bloodrage"

/atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	name = "BLOODRAGE"
	desc = "GRAGGAR! GRAGGAR! GRAGGAR!"
	icon_state = "bloodrage"

/datum/status_effect/buff/bloodrage
	id = "bloodrage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/graggar_bloodrage
	var/outline_color = "#ad0202"
	duration = 15 SECONDS

/datum/status_effect/buff/bloodrage/on_creation(mob/living/carbon/new_owner, duration_override, ...)
	var/holyskill = new_owner.get_skill_level(/datum/skill/magic/holy)
	duration = ((15 SECONDS) * holyskill)
	if(holyskill >= SKILL_LEVEL_APPRENTICE)
		effectedstats = list(STATKEY_STR = 2)
	else
		effectedstats = list(STATKEY_STR = 1)
	return ..()

/datum/status_effect/buff/bloodrage/on_apply()
	. = ..()
	owner.add_filter(BLOODRAGE_FILTER, 2, outline_filter(2, outline_color))



/datum/status_effect/buff/bloodrage/on_remove()
	. = ..()
	owner.visible_message(span_warning("[owner] wavers, their rage simmering down."))
	owner.OffBalance(3 SECONDS)
	owner.remove_filter(BLOODRAGE_FILTER)
	owner.emote("breathgasp", forced = TRUE)
	owner.Slowdown(3)

#undef BLOODRAGE_FILTER

/atom/movable/screen/alert/status_effect/buff/matthioshealing
	name = "Healing Miracle"
	desc = "Strange Divine intervention relieves me of my ailments."
	icon_state = "buff"

#define MIRACLE_HEALING_FILTER "miracle_heal_glow"

/datum/status_effect/buff/matthioshealing
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthioshealing
	duration = 10 SECONDS
	var/healing_on_tick = 1
	var/outline_colour = "#c42424"

/datum/status_effect/buff/matthioshealing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/matthioshealing/on_apply()
	. = ..()
	owner.add_filter(MIRACLE_HEALING_FILTER, 2,  outline_filter(2, outline_colour))
	return TRUE

/datum/status_effect/buff/matthioshealing/on_remove()
	. = ..()
	owner.remove_filter(MIRACLE_HEALING_FILTER)
	return TRUE

/datum/status_effect/buff/matthioshealing/get_examine_text()
	return "SUBJECTPRONOUN is bathed in a restorative aura!"

/datum/status_effect/buff/matthioshealing/tick()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+10, BLOOD_VOLUME_NORMAL)
	if(owner.get_wounds())
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_on_tick, 0)
		owner.adjustFireLoss(-healing_on_tick, FALSE)
		owner.adjustOxyLoss(-healing_on_tick, FALSE)
		owner.adjustToxLoss(-healing_on_tick, FALSE)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)

#undef MIRACLE_HEALING_FILTER //Why is this a thing?

#define CRANKBOX_FILTER "crankboxbuff_glow"
/atom/movable/screen/alert/status_effect/buff/churnerprotection
	name = "Magick Distorted"
	desc = "The wailing box is disrupting magicks around me!"
	icon_state = "buff"

/datum/status_effect/buff/churnerprotection
	var/outline_colour = "#fad55a"
	id = "soulchurnerprotection"
	alert_type = /atom/movable/screen/alert/status_effect/buff/churnerprotection
	duration = 20 SECONDS

/datum/status_effect/buff/churnerprotection/on_apply()
	. = ..()
	var/filter = owner.get_filter(CRANKBOX_FILTER)
	if (!filter)
		owner.add_filter(CRANKBOX_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))
	to_chat(owner, span_warning("I feel the wailing box distorting magicks around me!"))
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/buff/churnerprotection/on_remove()
	. = ..()
	to_chat(owner, span_warning("The wailing box's protection fades..."))
	owner.remove_filter(CRANKBOX_FILTER)
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_STATUS_EFFECT(id))

#undef CRANKBOX_FILTER

/atom/movable/screen/alert/status_effect/buff/churnernegative
	name = "Magick Distorted"
	desc = "That infernal contraption is sapping my very arcyne essence!"
	icon_state = "buff"


/datum/status_effect/buff/churnernegative
	id ="soulchurnernegative"
	alert_type = /atom/movable/screen/alert/status_effect/buff/churnernegative
	duration = 23 SECONDS

/datum/status_effect/buff/churnernegative/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_warning("I feel as if my connection to the Arcyne disappears entirely. The air feels still..."))
	owner.visible_message("[owner]'s arcyne aura seems to fade.")

/datum/status_effect/buff/churnernegative/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_STATUS_EFFECT(id))
	to_chat(owner, span_warning("I feel my connection to the arcyne surround me once more."))
	owner.visible_message("[owner]'s arcyne aura seems to return once more.")

/datum/status_effect/buff/lux_drank/baothavitae
	id = "druqks"
	duration = 1 MINUTES

// BARDIC BUFFS BELOW

/datum/status_effect/buff/bardic_inspiration
	id = "bardic_inspiration"
	alert_type = /atom/movable/screen/alert/status_effect/buff/bardic_inspiration
	duration = 45 SECONDS
	effectedstats = list(STATKEY_END = 2, STATKEY_SPD = 1, STATKEY_LCK = 1)

/atom/movable/screen/alert/status_effect/buff/bardic_inspiration
	name = "Bardic Inspiration"
	desc = span_nicegreen("Stirring words fill me with courage!")
	icon_state = "stressvgood"

/datum/status_effect/bardicbuff
	var/name
	id = "bardbuff"
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/bardbuff
	duration = 50 // Sanity, so that people outside the bard buff listening area lose the buff after a few seconds

// /datum/status_effect/bardicbuff/on_apply()
// 	. = ..()
// 	owner.add_stress(/datum/stress_event/bardicbuff)

// /datum/status_effect/bardicbuff/on_remove()
// 	. = ..()
// 	owner.remove_stress(/datum/stress_event/bardicbuff)

// SKELETON BARD BUFF ALERT
/atom/movable/screen/alert/status_effect/bardbuff
	name = "Musical Buff"
	desc = "My skills are improved by music!"
	icon_state = "intelligence"
	alert_group = ALERT_BUFF

// TIER 1 - WEAK
/datum/status_effect/bardicbuff/intelligence
	name = "Enlightening (+1 INT)"
	id = "bardbuff_int"
	effectedstats = list(STATKEY_INT = 1)
	alert_type = /atom/movable/screen/alert/status_effect/bardbuff/intelligence

/atom/movable/screen/alert/status_effect/bardbuff/intelligence
	name = "Enlightening"

// TIER 2 - AVERAGE
/datum/status_effect/bardicbuff/endurance
	name = "Invigorating (+1 END)"
	id = "bardbuff_end"
	effectedstats = list(STATKEY_END = 1)
	alert_type = /atom/movable/screen/alert/status_effect/bardbuff/endurance

/atom/movable/screen/alert/status_effect/bardbuff/endurance
	name = "Invigorating"

// TIER 3 - SKILLED
/datum/status_effect/bardicbuff/constitution
	name = "Fortitude (+1 CON)"
	id = "bardbuff_con"
	effectedstats = list(STATKEY_CON = 1)
	alert_type = /atom/movable/screen/alert/status_effect/bardbuff/constitution

/atom/movable/screen/alert/status_effect/bardbuff/constitution
	name = "Fortitude"

// TIER 4 - EXPERT
/datum/status_effect/bardicbuff/speed
	name = "Inspiring (+1 SPD)"
	id = "bardbuff_spd"
	effectedstats = list(STATKEY_SPD = 1)
	alert_type = /atom/movable/screen/alert/status_effect/bardbuff/speed

/atom/movable/screen/alert/status_effect/bardbuff/speed
	name = "Inspiring"

// TIER 5 - MASTER
/datum/status_effect/bardicbuff/ravox
	name = "Empowering (+1 STR, +1 PER)"
	id = "bardbuff_str"
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = 1)
	alert_type = /atom/movable/screen/alert/status_effect/bardbuff/ravox

/atom/movable/screen/alert/status_effect/bardbuff/ravox
	name = "Empowering"

// TIER 6 - LEGENDARY
/datum/status_effect/bardicbuff/awaken
	name = "Awaken! (+energy, +stamina, +1 FOR)"
	id = "bardbuff_awaken"
	alert_type = /atom/movable/screen/alert/status_effect/bardbuff/awaken
	effectedstats = list(STATKEY_LCK = 1)

/atom/movable/screen/alert/status_effect/bardbuff/awaken
	name = "Awaken!"

/datum/status_effect/bardicbuff/awaken/tick()
	for (var/mob/living/carbon/human/H in hearers(7, owner))
		if (!H.client)
			continue
		if(!H.can_hear())
			continue
		if(H.mind?.has_antag_datum(/datum/antagonist))
			if(!H.mind?.isactuallygood())
				continue
		H.adjust_energy(H.max_energy * 0.002)
		H.adjust_stamina(-H.maximum_stamina * 0.02, internal_regen = FALSE)

/datum/status_effect/buff/magicknowledge
	id = "intelligence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/knowledge
	effectedstats = list(STATKEY_INT = 2)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/knowledge
	name = "runic cunning"
	desc = "I am magically astute."
	icon_state = "buff"

/datum/status_effect/buff/magicstrength
	id = "strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/strength
	effectedstats = list(STATKEY_STR = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/strength
	name = "arcane reinforced strength"
	desc = "I am magically strengthened."
	icon_state = "buff"

/datum/status_effect/buff/magicstrength/lesser
	id = "lesser strength"
	alert_type = /atom/movable/screen/alert/status_effect/buff/strength/lesser
	effectedstats = list(STATKEY_STR = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/strength/lesser
	name = "lesser arcane strength"
	desc = "I am magically strengthened."
	icon_state = "buff"


/datum/status_effect/buff/magicspeed
	id = "speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/speed
	effectedstats = list(STATKEY_SPD = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/speed
	name = "arcane swiftness"
	desc = "I am magically swift."
	icon_state = "buff"

/datum/status_effect/buff/magicspeed/lesser
	id = "lesser speed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/speed/lesser
	effectedstats = list(STATKEY_SPD = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/speed/lesser
	name = "arcane swiftness"
	desc = "I am magically swift."
	icon_state = "buff"

/datum/status_effect/buff/magicendurance
	id = "endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/endurance
	effectedstats = list(STATKEY_END = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/endurance
	name = "arcane endurance"
	desc = "I am magically resilient."
	icon_state = "buff"

/datum/status_effect/buff/magicendurance/lesser
	id = "lesser endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/endurance/lesser
	effectedstats = list(STATKEY_END = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/endurance/lesser
	name = "lesser arcane endurance"
	desc = "I am magically resilient."
	icon_state = "buff"


/datum/status_effect/buff/magicconstitution
	id = "constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/constitution
	effectedstats = list(STATKEY_CON = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/constitution
	name = "arcane constitution"
	desc = "I feel reinforced by magick."
	icon_state = "buff"

/datum/status_effect/buff/magicconstitution/lesser
	id = "lesser constitution"
	alert_type = /atom/movable/screen/alert/status_effect/buff/constitution/lesser
	effectedstats = list(STATKEY_CON = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/constitution/lesser
	name = "lesser arcane constitution"
	desc = "I feel reinforced by magick."
	icon_state = "buff"

/datum/status_effect/buff/magicperception
	id = "perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/perception
	effectedstats = list(STATKEY_PER = 3)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/perception
	name = "arcane perception"
	desc = "I can see everything."
	icon_state = "buff"

/datum/status_effect/buff/magicperception/lesser
	id = "lesser perception"
	alert_type = /atom/movable/screen/alert/status_effect/buff/perception/lesser
	effectedstats = list(STATKEY_PER = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/perception/lesser
	name = "lesser arcane perception"
	desc = "I can see somethings."
	icon_state = "buff"
/atom/movable/screen/alert/status_effect/bardbuff/awaken
	name = "Awaken!"

/datum/status_effect/bardicbuff/awaken/tick()
	for (var/mob/living/carbon/human/H in hearers(7, owner))
		if (!H.client)
			continue
		if(!H.can_hear())
			continue
		if(H.mind?.has_antag_datum(/datum/antagonist))
			if(!H.mind?.isactuallygood())
				continue
		H.adjust_energy(1)
		H.adjust_stamina(-0.5, internal_regen = FALSE)

/datum/status_effect/debuff/cold
	id = "Frostveiled"
	alert_type =  /atom/movable/screen/alert/status_effect/debuff/cold
	effectedstats = list(STATKEY_SPD = -2)
	duration = 12 SECONDS

/datum/status_effect/debuff/cold/on_apply()
	. = ..()
	var/mob/living/target = owner
	var/newcolor = rgb(136, 191, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 12 SECONDS)

/atom/movable/screen/alert/status_effect/debuff/cold
	name = "Cold"
	desc = "Something has chilled me to the bone! It's hard to move."

/datum/status_effect/buff/nocblessing
	id = "nocblessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nocblessing
	effectedstats = list(STATKEY_INT = 1)
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/buff/nocblessing
	name = "Noc's blessing"
	desc = "Gazing Noc helps me think."
	icon_state = "buff"

/datum/status_effect/buff/nocblessed
	id = "nocblessed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/nocblessed
	effectedstats = list(STATKEY_INT = 3, STATKEY_PER = 2)
	duration = -1

/atom/movable/screen/alert/status_effect/buff/nocblessed
	name = "Blessed by Noc"
	desc = "I have been blessed by Noc since I was born, with his help I can see and think better than anyone."
	icon_state = "intelligence"


/datum/status_effect/buff/seelie_drugs
	id = "seelie drugs"
	alert_type = /atom/movable/screen/alert/status_effect/buff/druqks
	effectedstats = list(STATKEY_INT = 2, STATKEY_END = 4, STATKEY_SPD = -3)
	duration = 20 SECONDS

/datum/status_effect/buff/powered_steam_armor/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/eyes/eyes = H.getorgan(/obj/item/organ/eyes)
	if(!eyes)
		return
	ADD_TRAIT(owner, TRAIT_BESTIALSENSE, REF(src)) //It is not related to Dendor, it is just for the night vision.
	owner.update_sight()

/datum/status_effect/buff/powered_steam_armor
	id = "powered_steam"
	alert_type = /atom/movable/screen/alert/status_effect/buff/powered_steam_armor
	effectedstats = list(STATKEY_END = 2, STATKEY_CON = 2, STATKEY_STR = 2, STATKEY_SPD = 2)
	duration = -1

/atom/movable/screen/alert/status_effect/buff/powered_steam_armor
	name = "Powered Steam Armor"
	desc = "The armor is powered. I feel unstoppable."
	icon_state = "buff"

/datum/status_effect/buff/powered_steam_armor/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_BESTIALSENSE, REF(src))
	owner.update_sight()

/datum/status_effect/buff/lux_drank
	id = "lux_drank"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lux_drank
	effectedstats = list(STATKEY_LCK = 2)
	duration = 10 SECONDS

/datum/status_effect/buff/lux_drank/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/high)
	SEND_SIGNAL(owner, COMSIG_LUX_TASTED)

/datum/status_effect/buff/lux_drank/on_remove()
	owner.remove_stress(/datum/stress_event/high)

	. = ..()

/atom/movable/screen/alert/status_effect/buff/lux_drank
	name = "Invigorated"
	desc = "I have supped on the finest of delicacies: life!"

/datum/status_effect/buff/received_lux
	id = "received_lux"
	alert_type = /atom/movable/screen/alert/status_effect/buff/received_lux
	duration = -1

/atom/movable/screen/alert/status_effect/buff/received_lux
	name = "Received Lux"
	desc = "I can feel something... is this what it means to have a soul?"

// Small buff to halflings for having over 800 nutrition currently
/datum/status_effect/buff/stuffed
	id = "stuffed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/stuffed
	effectedstats = list(STATKEY_CON = 1, STATKEY_END = 1)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/buff/stuffed
	name = "Stuffed"
	desc = "A hearty meal!"

// Buff to halflings for not wearing shoes, comes with stress events
/datum/status_effect/buff/free_feet
	id = "free_feet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/free_feet
	effectedstats = list(STATKEY_SPD = 1)
	duration = -1

/datum/status_effect/buff/free_feet/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/feet_free)
	owner.remove_stress(/datum/stress_event/feet_constrained)

/datum/status_effect/buff/free_feet/on_remove()
	. = ..()
	if(!owner)
		return
	owner.add_stress(/datum/stress_event/feet_constrained)
	owner.remove_stress(/datum/stress_event/feet_free)

/atom/movable/screen/alert/status_effect/buff/free_feet
	name = "Foot Freedom"
	desc = "Not wearing shoes allows me to move more freely."
