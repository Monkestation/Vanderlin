/datum/action/cooldown/spell/projectile/smoke_burst
	button_icon = 'icons/mob/actions/spells/mage_pyromancy.dmi'
	name = "Smoke Burst"
	desc = "Hurl a harmless ball of smouldering cinders that bursts into a thick 3x3 cloud of smoke on impact, blocking sight for around 15 seconds.\
	Deals no damage. \
	Toggle arc mode (Shift+G) while the spell is active to lob it over intervening mobs and obstacles."
	button_icon_state = "smoke_burst"
	sound = 'sound/items/firesnuff.ogg'

	projectile_type = /obj/projectile/magic/smoke_burst
	projectile_type_arc = /obj/projectile/magic/smoke_burst/arc
	cast_range = SPELL_RANGE_PROJECTILE

	spell_cost = 20

	required_form = FORM_FIRE

	invocation = "Evomere Fumum!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 0.4 SECONDS

	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 45 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/projectile/magic/smoke_burst
	name = "smoke burst"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "spark"
	light_color = "#8a8a8a"
	light_outer_range = 2
	speed = 2.5
	nodamage = TRUE
	damage = 0
	flag = "fire"
	hitsound = 'sound/blank.ogg'
	reflectable = FALSE
	var/smoke_range = 1
	var/has_burst = FALSE

/obj/projectile/magic/smoke_burst/arc
	name = "arced smoke burst"
	arcshot = TRUE

/obj/projectile/magic/smoke_burst/proc/burst_smoke(turf/epicenter)
	if(has_burst || !epicenter)
		return
	has_burst = TRUE
	playsound(epicenter, 'sound/items/firesnuff.ogg', 70, TRUE)
	for(var/turf/T in range(smoke_range, epicenter))
		if(T.density)
			continue
		new /obj/effect/particle_effect/smoke/pyro_screen(T)

/obj/projectile/magic/smoke_burst/on_hit(atom/target, blocked = FALSE)
	. = ..()
	burst_smoke(get_turf(target))

/obj/projectile/magic/smoke_burst/on_range()
	burst_smoke(get_turf(src))
	. = ..()

/obj/effect/particle_effect/smoke/pyro_screen
	lifetime = 7
