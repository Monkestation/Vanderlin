/datum/action/cooldown/spell/projectile/acid_splash
	name = "Acid Splash"
	desc = "A slow-moving glob of acid that sprays over an area upon impact."
	button_icon_state = "acidsplash"
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1
	attunements = list(
		/datum/attunement/blood = 0.3,
		/datum/attunement/death = 0.4,
	)

	invocation = "HYDRO MURIATIC!!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 15 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/acidsplash

/datum/action/cooldown/spell/projectile/acid_splash/ready_projectile(obj/projectile/magic/acidsplash/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.damage *= attuned_strength
	to_fire.aoe_range *= attuned_strength
	to_fire.strength_modifier *= attuned_strength

/obj/projectile/magic/acidsplash
	name = "acid bubble"
	icon_state = "acid_splash"
	damage = 10
	damage_type = BURN
	range = 15
	speed = 3
	var/aoe_range = 1
	var/strength_modifier = 1

/obj/projectile/magic/acidsplash/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	aoe_range = round(aoe_range)
	var/turf/splashed = get_turf(target)
	for(var/turf/turf in RANGE_TURFS(aoe_range, splashed))
		if(turf.density)
			continue
		new /obj/effect/temp_visual/acidsplash5e(turf)
		for(var/mob/living/L in turf)
			if(!L.can_block_magic(MAGIC_RESISTANCE))
				L.apply_status_effect(/datum/status_effect/debuff/acidsplash, strength_modifier)

/datum/status_effect/debuff/acidsplash
	id = "acid splash"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/acidsplash
	duration = 10 SECONDS
	var/damage_per_tick = 2

/datum/status_effect/debuff/acidsplash/New(atom/A, scaled_damage = 2)
	. = ..()
	damage_per_tick = scaled_damage

/datum/status_effect/debuff/acidsplash/tick()
	var/mob/living/target = owner
	target.adjustFireLoss(damage_per_tick)

/atom/movable/screen/alert/status_effect/debuff/acidsplash
	name = "Acid Burn"
	desc = "My skin is burning!"
	icon_state = "debuff"

/obj/effect/temp_visual/acidsplash5e
	icon = 'icons/effects/effects.dmi'
	icon_state = "acid_pop"
	randomdir = TRUE
	duration = 1 SECONDS
	layer = GAME_PLANE_UPPER
