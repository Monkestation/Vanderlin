//entirely neutral or internal status effects go here


//Roguetown

/datum/status_effect/incapacitating/off_balanced
	id = "off_balanced"
	alert_type = /atom/movable/screen/alert/status_effect/off_balanced

/atom/movable/screen/alert/status_effect/off_balanced
	name = "Off Balanced"
	desc = "I am knocked off balance!"
	icon_state = "off_balanced"

//ENDROGUE

/datum/status_effect/sigil_mark //allows the affected target to always trigger sigils while mindless
	id = "sigil_mark"
	duration = -1
	alert_type = null
	var/stat_allowed = DEAD //if owner's stat is below this, will remove itself

/datum/status_effect/sigil_mark/tick()
	if(owner.stat < stat_allowed)
		qdel(src)

/datum/status_effect/crusher_damage //tracks the damage dealt to this mob by kinetic crushers
	id = "crusher_damage"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/total_damage = 0

/atom/movable/screen/alert/status_effect/in_love
	name = "In Love"
	desc = ""
	icon_state = "in_love"

/datum/status_effect/in_love
	id = "in_love"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/in_love
	var/mob/living/date

/datum/status_effect/in_love/on_creation(mob/living/new_owner, duration_override, mob/living/love_interest)
	. = ..()
	if(.)
		date = love_interest
	linked_alert.desc = ""

/datum/status_effect/in_love/tick()
	if(date)
		new /obj/effect/temp_visual/love_heart/invisible(get_turf(date.loc), owner)


/datum/status_effect/throat_soothed
	id = "throat_soothed"
	duration = 60 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/throat_soothed/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SOOTHED_THROAT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/throat_soothed/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SOOTHED_THROAT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/bounty
	id = "bounty"
	status_type = STATUS_EFFECT_UNIQUE
	var/mob/living/rewarded

/datum/status_effect/bounty/on_creation(mob/living/new_owner, duration_override, mob/living/caster)
	. = ..()
	if(.)
		rewarded = caster

/datum/status_effect/bounty/on_apply()
	to_chat(owner, span_boldnotice("You hear something behind you talking... \"You have been marked for death by [rewarded]. If you die, they will be rewarded.\""))
	playsound(owner, 'sound/blank.ogg', 75, FALSE)
	return ..()

/datum/status_effect/bounty/tick()
	if(owner.stat == DEAD)
		rewards()
		qdel(src)

/datum/status_effect/bounty/proc/rewards()
	if(rewarded && rewarded.mind && rewarded.stat != DEAD)
		to_chat(owner, span_boldnotice("You hear something behind you talking... \"Bounty claimed.\""))
		playsound(owner, 'sound/blank.ogg', 75, FALSE)
		to_chat(rewarded, span_greentext("You feel a surge of mana flow into you!"))
		for(var/datum/action/cooldown/spell/spell in rewarded.actions)
			spell.reset_spell_cooldown()
		rewarded.adjustBruteLoss(-25)
		rewarded.adjustFireLoss(-25)
		rewarded.adjustToxLoss(-25)
		rewarded.adjustOxyLoss(-25)
		rewarded.adjustCloneLoss(-25)

/datum/status_effect/bugged //Lets another mob hear everything you can
	id = "bugged"
	duration = -1
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = /atom/movable/screen/alert/bugged
	var/obj/item/listeningdevice/device

/datum/status_effect/bugged/on_apply(mob/living/new_owner, obj/item/listeningdevice/tracker)
	. = ..()
	if (.)
		RegisterSignal(new_owner, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))


/datum/status_effect/bugged/on_remove()
	..()

	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	if(device)
		owner.contents.Remove(device)
		device.forceMove(owner.loc)
		owner.put_in_hands(device)


/datum/status_effect/bugged/proc/handle_hearing(datum/source, list/hearing_args)
//	listening_in.show_message(hearing_args[HEARING_MESSAGE])
	device.Hear(hearing_args[HEARING_MESSAGE], hearing_args[HEARING_SPEAKER], raw_message = hearing_args[HEARING_RAW_MESSAGE])

/atom/movable/screen/alert/bugged
	name = "BUGGED"
	desc = "AN AUDIO-PARASITE ON ME."
	icon_state = "blackeye"

/atom/movable/screen/alert/bugged/Click()
	var/mob/living/L = usr

	if(!L.has_status_effect(/datum/status_effect/bugged))
		return FALSE

	to_chat(L, span_notice("I tug and rip out the parasite."))
	playsound(L, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)

	L.remove_status_effect(/datum/status_effect/bugged)

	return TRUE
