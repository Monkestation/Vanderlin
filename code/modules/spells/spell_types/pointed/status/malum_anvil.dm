/datum/action/cooldown/spell/status/malum_anvil
	name = "Malum's Anvil"
	desc = ""
	button_icon_state = "malum_anvil"
	sound = 'sound/items/bsmithfail.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	cast_range = 0
	self_cast_possible = TRUE
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/malum)

	invocation = "I am the ANVIL on which the HAMMER of creation STRIKES!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	cooldown_time = 1 MINUTES
	spell_cost = 55

	status_effect = /datum/status_effect/buff/malum_anvil

/datum/action/cooldown/spell/status/malum_anvil/is_valid_target(atom/cast_on)
	return cast_on == owner

/datum/action/cooldown/spell/status/malum_anvil/cast(mob/living/cast_on)
	. = ..()
	cast_on.visible_message(
		"<font color='yellow'>[owner] begins to glow brightly as their body hardens!</font>",
		"<font color='yellow'>You feel your body harden and emit a glow as energy flows through you, preparing you for your TOIL.</font>"
	)
