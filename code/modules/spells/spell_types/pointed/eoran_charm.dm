/datum/action/cooldown/spell/charm
	desc = "Captivate a target and prevent them from moving."
	button_icon_state = "love"
	sound = 'sound/magic/whiteflame.ogg'
	self_cast_possible = FALSE

	cast_range = 4

	charge_time = 6 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 2 MINUTES
	spell_cost = 100

/datum/action/cooldown/spell/charm/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/charm/cast(mob/living/cast_on)
	. = ..()
	do_charm(cast_on)

/datum/action/cooldown/spell/charm/proc/do_charm(mob/living/cast_on)
	cast_on.apply_status_effect(/datum/status_effect/eorapacify)
	cast_on.Immobilize(85)

/datum/action/cooldown/spell/charm/eoran
	name = "Eoran Charm"
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/eora)

	invocation = "Experiamur vim amoris!"
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/charm/eoran/do_charm(mob/living/cast_on)
	var/list/charms_public = list("<b style='color:pink'>[owner] is influenced by the beauty of Eora's follower.</b>", "<b style='color:pink'>[cast_on] stares mesmerized at [owner] and does not move.</b>")
	var/list/charms_target = list("<b style='color:pink'>Your eyes cannot move away from [owner].</b>", "<b style='color:pink'>You are enchanted by the beauty of the follower of Eora.</b>")
	cast_on.visible_message(span_warning("[pick(charms_public)]"), span_warning("[pick(charms_target)]"))
	cast_on.apply_status_effect(/datum/status_effect/eorapacify)
	cast_on.apply_status_effect(/datum/status_effect/debuff/mesmerised, 8 SECONDS)
	cast_on.Immobilize(4 SECONDS)

/datum/action/cooldown/spell/charm/vampire
	name = "Vampiric Charm"
	sound = 'sound/magic/PSY.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	attunements = list(
		/datum/attunement/blood = 0.5,
	)

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 80 SECONDS
	spell_cost = 80

	spell_type = SPELL_BLOOD
	antimagic_flags = MAGIC_RESISTANCE_UNHOLY
	associated_skill = /datum/skill/magic/blood

/datum/action/cooldown/spell/charm/vampire/do_charm(mob/living/cast_on)
	var/list/charms_public = list("<b style='color:pink'>[owner]'s eyes glow as they look towards the person.</b>", "<b style='color:pink'>[cast_on] stares mesmerized at [owner] and does not move.</b>")
	var/list/charms_target = list("<b style='color:pink'>Your eyes cannot move away from [owner].</b>", "<b style='color:pink'>You are enchanted by the beauty of the person standing infront of you.</b>")
	cast_on.visible_message(span_warning("[pick(charms_public)]"), span_warning("[pick(charms_target)]"))
	cast_on.apply_status_effect(/datum/status_effect/eorapacify)
	cast_on.apply_status_effect(/datum/status_effect/debuff/mesmerised)
	cast_on.Immobilize(40)
	cast_on.Slowdown(15)
	cast_on.blur_eyes(20)
	cast_on.emote("drool")
