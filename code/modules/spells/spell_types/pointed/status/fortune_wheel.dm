/datum/action/cooldown/spell/status/wheel
	name = "Wheel of Fortune"
	desc = "Roll the dice for something nice..."
	sound = 'sound/misc/letsgogambling.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/xylix)

	charge_required = FALSE
	spell_cost = 35
	cooldown_time = 2 MINUTES

	status_effect = /datum/status_effect/wheel

//Xylix Gambling
/datum/status_effect/wheel
	id = "wheel"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES //keep same as spell charge cooldown
	alert_type = /atom/movable/screen/alert/status_effect/buff/wheel

/datum/status_effect/wheel/on_creation(mob/living/new_owner, duration_override, ...)
	var/list/mob_stats = MOBSTATS
	mob_stats = mob_stats.Copy() //why do i have to do this
	effectedstats[pick_n_take(mob_stats)] = rand(1, 5)
	effectedstats[pick_n_take(mob_stats)] = -rand(1, 5)
	if(prob(25)) // Nope!
		if(effectedstats[STATKEY_LCK])
			effectedstats[STATKEY_LCK] += 2
		else
			effectedstats[STATKEY_LCK] = 2
	return ..()

/atom/movable/screen/alert/status_effect/buff/wheel
	name = "The Wheel"
	desc = "Xylix has spun your fate. You feel disorientated as if you had been rotated.\n"
	icon_state = "acid"
