/datum/action/cooldown/spell/projectile/bullet // admin only spell
	name = "Arcane Bullet"
	desc = "Shoot out rapid bolts of arcyne power."
	button_icon_state =  "arcane_bolt"
	sound = 'sound/combat/Ranged/muskshoot.ogg'
	spell_cost = 0
	projectile_type = /obj/projectile/bullet/reusable/bullet

	invocation = "PARRY THIS!!!"
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/projectile/bullet/cast(atom/cast_on, mob/living/carbon)
	. = ..()
	var/turf/T = get_turf(owner)
	var/static/shakeradius = 1
	playsound(T, 'sound/foley/tinnitus.ogg', 60, TRUE, soundping = TRUE)
	T.pollute_turf(/datum/pollutant/smoke, 300)
	for (var/mob/living/carbon/shaken in view(shakeradius, T))
		shake_camera(shaken, 5, 5)


