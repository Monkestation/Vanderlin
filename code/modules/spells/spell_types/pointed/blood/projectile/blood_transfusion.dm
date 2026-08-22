/datum/action/cooldown/spell/projectile/blood_transfusion
	name = "Blood Transfusion"
	desc = "Launch a bolt of your own blood to pass it to another."
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/vlightning.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_ALTERATION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation = "P'SS LF'E!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 20 SECONDS
	spell_cost = 125
	spell_flags = SPELL_UNETCHABLE
	projectile_type = /obj/projectile/magic/bloodtransfuse

/datum/action/cooldown/spell/projectile/blood_transfusion/on_cast_hit(atom/source, mob/living/carbon/human/firer, atom/hit, angle)
	. = ..()

	if(!firer || !ishuman(hit))
		return

	var/mob/living/carbon/human/target = hit

	var/blood_adjustment = firer.default_blood_volume / 10
	if(firer.blood_volume < (blood_adjustment + BLOOD_VOLUME_SURVIVE))
		to_chat(firer, span_bloody("I do not have enough blood for a transfusion."))
		return
	if(target.blood_volume >= BLOOD_VOLUME_MAXIMUM)
		to_chat(firer, span_bloody("[target] does not require a blood transfusion."))
		return
	firer.adjust_blood_volume(-blood_adjustment)
	target.adjust_blood_volume(blood_adjustment)
	target.adjust_jitter(4 SECONDS)
	to_chat(firer, span_bloody("You pass your own blood to [target]."))

	target.visible_message(
			span_danger("[target] shudders as blood pours into their veins!"),
			span_userdanger("Blood forces itself into my body!"),
			span_hear("I hear a fluid spill..."),
		)
	new /obj/effect/decal/cleanable/blood/puddle(get_turf(firer), firer.get_blood_type().color)


/obj/projectile/magic/bloodtransfuse
	name = "blood transfusion"
	tracer_type = /obj/effect/projectile/tracer/bloodsteal
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = FLYING
	projectile_piercing = PROJECTILE_PIERCE_HIT
	damage = 0
	damage_type = BRUTE
	nodamage = TRUE
	speed = 0.3
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	light_outer_range =  7
