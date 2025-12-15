/datum/action/cooldown/spell/projectile/blood_steal
	name = "Blood Steal"
	desc = "Launch a bolt which leeches the blood of those hit."
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/vlightning.ogg'

	associated_skill = /datum/skill/magic/blood
	attunements = list(
		/datum/attunement/blood = 0.7,
	)

	invocation = "DR'N LF'E!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 20 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/bloodsteal

/datum/action/cooldown/spell/projectile/blood_steal/on_cast_hit(atom/source, mob/living/carbon/human/firer, atom/hit, angle)
	. = ..()

	if(!firer || !ishuman(hit))
		return

	if(!firer.clan)
		return

	var/mob/living/carbon/human/H = hit
	if(H.bloodpool >= 500) // You'll only get vitae IF they have vitae.
		H.bloodpool -= 500
		firer.adjust_bloodpool(500)

/obj/projectile/magic/bloodsteal
	name = "blood steal"
	tracer_type = /obj/effect/projectile/tracer/bloodsteal
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = FLYING
	projectile_piercing = PROJECTILE_PIERCE_HIT
	damage = 25
	damage_type = BRUTE
	nodamage = FALSE
	speed = 0.3
	light_color = "#e74141"
	light_outer_range =  7

/obj/projectile/magic/bloodsteal/on_hit(target)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target

		H.blood_volume = max(H.blood_volume - 45, 0)

		H.visible_message(
			span_danger("[H] has their blood ripped from their body!"),
			span_userdanger("Blood erupts from my body!"),
			span_hear("I hear a fluid spill..."),
		)
		new /obj/effect/decal/cleanable/blood/puddle(get_turf(H))
