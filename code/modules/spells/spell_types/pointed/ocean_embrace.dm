/datum/action/cooldown/spell/ocean_embrace
	name = "Ocean's Embrace"
	desc = "Restore the blood of a target, or drown them."
	button_icon_state = "revive"
	sound = 'sound/foley/jumpland/waterland.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	cast_range = 6
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/abyssor)

	invocation = "Embrace the waters of Abyssor's domain!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 1 SECONDS
	cooldown_time = 30 SECONDS
	spell_cost = 50

/datum/action/cooldown/spell/ocean_embrace/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/ocean_embrace/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.mob_biotypes & MOB_UNDEAD)
		if(cast_on.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
			cast_on.visible_message(span_warning("[cast_on] overpowers being swept away!"), span_greentext("I overpower being swept away!"))
			return
		cast_on.visible_message(span_danger("[cast_on] is drowned by turbulent tides!"), span_userdanger("I'm being drowned by turbulent tides!"))
		cast_on.safe_throw_at(get_step(cast_on, get_dir(owner, cast_on)), 1, 1, owner, spin = TRUE, force = cast_on.move_force)
		var/already_dead = cast_on.stat == DEAD ? TRUE : FALSE
		cast_on.adjustOxyLoss(80)
		if(!already_dead && cast_on.stat == DEAD && cast_on.client)
			record_round_statistic(STATS_PEOPLE_DROWNED)
		else
			cast_on.Knockdown(5)
			cast_on.Slowdown(60)
			cast_on.set_dizzy(10 SECONDS)
			cast_on.set_eye_blur_if_lower(40 SECONDS)
			cast_on.emote("drown")
		return

	cast_on.visible_message(span_info("A wave of replenishing water passes through [cast_on]!"), span_notice("I'm engulfed in a wave of replenishing water!"))
	cast_on.wash(CLEAN_WASH)
	var/situational_bonus = 1
	var/list/water = typesof(/turf/open/water) - typesof(/turf/open/water/acid)
	// the more water around us, the more we heal, up to times two
	for(var/turf/T in view(3, owner))
		if(is_type_in_list(T, water))
			situational_bonus = min(situational_bonus + 0.1, 2)
	if(situational_bonus > 1)
		to_chat(owner, span_greentext("Channeling Abyssor's power is easier in these conditions!"))
	cast_on.blood_volume += BLOOD_VOLUME_OKAY * situational_bonus
