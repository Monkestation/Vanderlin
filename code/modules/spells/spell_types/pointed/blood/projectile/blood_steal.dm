/datum/action/cooldown/spell/projectile/blood_steal
	name = "Blood Steal"
	desc = "Launch a bolt which leeches the blood of those hit."
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/vlightning.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_ALTERATION

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

	var/mob/living/carbon/human/target = hit

	var/blood_adjustment = target.default_blood_volume / 10
	if(target.blood_volume < blood_adjustment)
		return
	target.adjust_blood_volume(-blood_adjustment)
	firer.adjust_blood_volume(blood_adjustment)
	to_chat(firer, span_bloody("You replenish your own blood from [target]."))

	if(firer.clan && target.clan && target.bloodpool >= 500) // You'll only get vitae IF they have vitae.
		target.adjust_bloodpool(-500)
		firer.adjust_bloodpool(500)
		to_chat(firer, span_bloody("You drain Vitae from [target]."))
		to_chat(target, span_bloody("[firer] has drained some of your Vitae!"))

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
		var/mob/living/carbon/human/human_target = target

		human_target.visible_message(
			span_danger("[human_target] has their blood ripped from their body!"),
			span_userdanger("Blood erupts from my body!"),
			span_hear("I hear a fluid spill..."),
		)
		new /obj/effect/decal/cleanable/blood/puddle(get_turf(human_target), human_target.get_blood_type().color)
