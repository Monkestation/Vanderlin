/datum/action/cooldown/spell/projectile/blood_steal
	name = "Blood Steal"
	desc = "Launch a bolt which leeches the blood of those hit."
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/vlightning.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = null

	invocation = "DR'N LF'E!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 20 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/bloodsteal
	var/vitae_value = 150

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Weak", "tag" = "WEAK", "amount" = 150),
		list("name" = "Strong", "tag" = "STNG", "amount" = 300),
	)

/datum/action/cooldown/spell/projectile/blood_steal/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/projectile/blood_steal/proc/apply_mode(index)
	var/list/mode = modes[index]
	vitae_value = mode["amount"]
	spell_cost = mode["amount"] / 10
	update_mode_maptext(mode["tag"])
	if(vitae_value < 300)
		invocation_type = INVOCATION_WHISPER
	else
		invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/projectile/blood_steal/toggle_arc_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))

/datum/action/cooldown/spell/projectile/blood_steal/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.color = "#b11212"



/datum/action/cooldown/spell/projectile/blood_steal/on_cast_hit(atom/source, mob/living/carbon/human/firer, atom/hit, angle)
	. = ..()

	if(!firer || !ishuman(hit))
		return

	var/mob/living/carbon/human/target = hit

	var/blood_adjustment = target.default_blood_volume / 10
	if(target.blood_volume < (blood_adjustment + BLOOD_VOLUME_SURVIVE))
		to_chat(firer, span_bloody("[target] does not have enough blood to steal!"))
		return
	target.adjust_blood_volume(-blood_adjustment)
	firer.adjust_blood_volume(blood_adjustment)
	to_chat(firer, span_bloody("You replenish your own blood from [target]."))

	target.visible_message(
			span_danger("[target] has their blood ripped from their body!"),
			span_userdanger("Blood erupts from my body!"),
			span_hear("I hear a fluid spill..."),
		)
	new /obj/effect/decal/cleanable/blood/puddle(get_turf(target), target.get_blood_type().color)

	if(target.bloodpool >= vitae_value) // You'll only get vitae IF they have vitae.
		target.adjust_bloodpool(-vitae_value)
		firer.adjust_bloodpool(vitae_value)
		to_chat(firer, span_bloody("You drain Vitae from [target]."))
		to_chat(target, span_bloody("[firer] has drained some of your Vitae!"))
	else
		to_chat(firer, span_bloody("[target] does not have enough Vitae to steal!"))

/obj/projectile/magic/bloodsteal
	name = "draining bolt"
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
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	light_outer_range =  7
