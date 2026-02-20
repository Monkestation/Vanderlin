/datum/special_intent/side_sweep
	name = "Distracting Swipe"
	desc = "Swing tall at your primary flank in a distracting fashion. \
		Anyone caught in it will be exposed for a short while. \
		However, those on the floor will not be struck."

	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"
	post_sound = 'sound/combat/sidesweep_hit.ogg'

	stamina_cost = 25

	attack_delay = 0.6 SECONDS
	cooldown = 17 SECONDS

	tile_coordinates = list(list(0,0), list(1,0), list(1,-1))	//L shape that hugs our -right- flank.

	/// Damage we deal
	var/damage = 20
	/// Users intent when we started the attack, instead of checking it when it happens
	var/target_zone

/datum/special_intent/side_sweep/pre_creation(mob/living/user, obj/item/parent, turf/target)
	if(user.used_hand == 1)	//We invert it if it's the left arm.
		tile_coordinates = list(list(0,0), list(-1,0), list(-1,-1))
	else
		tile_coordinates = list(list(0,0), list(1,0), list(1,-1))

	var/statmod = max(user.STASTR, user.STASPD, user.STAPER)	//It's a versatile weapon, so the scaling is versatile, too
	if(parent)
		damage = parent.force * (statmod / 10)

	target_zone = null
	if(user.zone_selected != BODY_ZONE_CHEST)
		if(check_zone(user.zone_selected) != user.zone_selected || user.STAPER < 11)
			if(prob(33))
				target_zone = user.zone_selected
		else
			target_zone = user.zone_selected

	if(!target_zone)
		target_zone = BODY_ZONE_CHEST

/datum/special_intent/side_sweep/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		// victim.apply_status_effect(/datum/status_effect/debuff/exposed, 5 SECONDS)
		apply_generic_weapon_damage(user, parent, victim, damage, SLASH, target_zone, damage_class = BCLASS_CUT)

/datum/special_intent/shin_swipe
	name = "Shin Prod"
	desc = "A hasty attack at the legs, extending ourselves. \
		Slows down the opponent if hit. \
		However, those on the floor will not be struck"

	pre_icon_state = "trap"
	post_icon_state = "sweep_fx"
	post_sound = 'sound/combat/shin_swipe.ogg'

	stamina_cost = 25

	attack_delay = 0.5 SECONDS
	cooldown = 20 SECONDS

	tile_coordinates = list(list(0,0), list(1,0), list(-1,0))

	var/damage

/datum/special_intent/shin_swipe/pre_creation(mob/living/user, obj/item/parent, turf/target)
	damage = parent.force * max((1 + (((user.STASPD - 10) + (user.STAPER - 10)) / 10)), 0.1)

/datum/special_intent/shin_swipe/apply_hit(mob/living/user, obj/item/parent, turf/target)
	for(var/mob/living/victim in target)
		if(victim == user)
			continue
		if(victim.body_position == LYING_DOWN)
			continue
		victim.Slowdown(5)
		victim.apply_status_effect(/datum/status_effect/debuff/hobbled)
		apply_generic_weapon_damage(user, parent, victim, damage, STAB, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), damage_class = BCLASS_CUT)

