
/datum/intent/effect
	var/datum/status_effect/intent_effect	//Status effect this intent will apply on a damaging hit
	var/list/target_parts					//Targeted bodyparts which will apply the effect. Leave blank for anywhere on the body.

/datum/intent/effect/examine(mob/user)
	. = ..()
	. += "\nThis intent will apply a status effect on a damaging hit."
	if(LAZYLEN(target_parts))
		. += "\nWorks on these bodyparts: "
		for(var/part in target_parts)
			. +="|[parse_zone(part)]| "

/datum/intent/effect/daze
	name = "dazing strike"
	icon_state = "indaze"
	attack_verb = list("dazes")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/daze_hit.ogg')
	chargetime = 0
	penfactor = 50
	swingdelay = 6
	damfactor = 0.5
	item_damage_type = "blunt"
	intent_effect = /datum/status_effect/debuff/dazed
	target_parts = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL)

/datum/status_effect/debuff/dazed
	id = "dazed"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed
	effectedstats = list(STATKEY_PER = -2, STATKEY_INT = -2)
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/debuff/dazed/on_apply()
	. = ..()
	owner.set_dizzy(15 SECONDS)

/datum/status_effect/debuff/dazed/refresh(mob/living/new_owner, duration_override, ...)
	. = ..()
	owner.set_dizzy(15 SECONDS)

/atom/movable/screen/alert/status_effect/debuff/dazed
	name = "Dazed"
	desc = "You've been smacked on the head very hard. That way is left, right?"
	icon_state = "dazed"
