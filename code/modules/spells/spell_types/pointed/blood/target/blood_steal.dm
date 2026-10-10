/datum/action/cooldown/spell/blood_steal
	name = "Blood Steal"
	desc = "Launch a bolt that steals the blood and vitae reserves of a target. Shift-G to change modes."
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/vlightning.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = null
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation = "DR'N LF'E!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_slowdown = 0.7
	cooldown_time = 20 SECONDS
	spell_cost = 30
	spell_flags = SPELL_UNETCHABLE
	var/vitae_drain = 150
	var/blood_drain_perc = 5

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Weak", "tag" = "W", "vitae_drain" = 150, "blood_perc" = 5, "vitae_cost" = 30),
		list("name" = "Normal", "tag" = "N", "vitae_drain" = 300, "blood_perc" = 10, "vitae_cost" = 60),
		list("name" = "Enhanced", "tag" = "E", "vitae_drain" = 450, "blood_perc" = 15, "vitae_cost" = 90),
	)

/datum/action/cooldown/spell/blood_steal/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/blood_steal/proc/apply_mode(index)
	var/list/mode = modes[index]
	vitae_drain = mode["vitae_drain"]
	blood_drain_perc = mode["blood_perc"]
	spell_cost = mode["vitae_cost"]
	desc = "Launch a bolt which leeches the blood of those hit. Use [spell_cost] Vitae to drain [blood_drain_perc]% of the target's maximum blood and, if they have any, [vitae_drain] Vitae from their RESERVES."
	update_mode_maptext(mode["tag"])
	switch(current_mode)
		if(1)
			invocation_type = INVOCATION_WHISPER
		if(2, 3)
			invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/blood_steal/toggle_alt_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode. (Drain [vitae_drain] VTR and [blood_drain_perc]% blood for [spell_cost] Vitae)"))
	user.balloon_alert(user, modes[current_mode]["name"])

/datum/action/cooldown/spell/blood_steal/proc/update_mode_maptext(tag)
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

/datum/action/cooldown/spell/blood_steal/cast(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on) || !ishuman(owner))
		return
	var/mob/living/carbon/human/target = cast_on
	var/mob/living/carbon/human/human_owner = owner
	var/did_something = FALSE

	var/blood_adjustment = target.default_blood_volume * (blood_drain_perc/100)
	var/safe_to_take_blood = (human_owner.blood_volume <= (BLOOD_VOLUME_SAFE_MAXIMUM - blood_adjustment))

	if(!safe_to_take_blood)
		to_chat(human_owner, span_bloody("It is not safe for you to have any more blood in your body."))
	else if(target.blood_volume > (blood_adjustment + BLOOD_VOLUME_SURVIVE))
		target.adjust_blood_volume(-blood_adjustment)
		human_owner.adjust_blood_volume(blood_adjustment)
		to_chat(human_owner, span_bloody("You replenish your own blood from [target]."))
		did_something = TRUE
	else
		to_chat(human_owner, span_bloody("[target] does not have enough blood to steal!"))

	if(target.bloodpool) // You'll only get vitae IF they have vitae.
		did_something = TRUE
		var/true_drain = min(vitae_drain, target.bloodpool)
		target.adjust_bloodpool(-true_drain)
		human_owner.adjust_bloodpool(true_drain)
		to_chat(human_owner, span_bloody("You drain [true_drain] VTR from [target]."))
		if(HAS_TRAIT(target, TRAIT_VITAE_USER) || HAS_TRAIT(target, TRAIT_BLOOD_SENSE) || HAS_TRAIT(target, TRAIT_BLOOD_STUDENT))
			to_chat(target, span_bloody("[human_owner] has drained some of your Vitae!"))
	else
		to_chat(human_owner, span_bloody("[target] does not have any Vitae to steal!"))

	if(!did_something)
		return
	human_owner.Beam(target, icon_state = "drain_life", time = 3 SECONDS)
	target.apply_damage(blood_drain_perc * 2, BRUTE)
	target.visible_message(
		span_danger("[target] has their blood ripped from their body!"),
		span_userdanger("Blood erupts from my body!"),
		span_hear("I hear a fluid spill..."),
	)
	new /obj/effect/decal/cleanable/blood/puddle(get_turf(target), target.get_blood_type().color)
