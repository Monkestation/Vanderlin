/datum/action/cooldown/spell/status/malum_anvil
	name = "Malum's Anvil MAKE NAME"
	desc = ""
	button_icon_state = "craft_buff"
	sound = 'sound/items/bsmithfail.ogg'

	cast_range = 2
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/malum)

	invocation = "Really Cool Invocation Involving Anvils!"
	invocation_type = INVOCATION_SHOUT

	//CHANGES THIS BEFOER LIVE
	charge_time = 2 SECONDS
	cooldown_time = 2 SECONDS
	spell_cost = 5

	status_effect = /datum/status_effect/buff/malum_anvil

/datum/action/cooldown/spell/status/malum_anvil/cast(mob/living/cast_on)
	. = ..()
	if(cast_on == owner)
		cast_on.visible_message( //TODO messages
			"<font color='yellow'>Vibrant flames swirl around [owner].</font>",
			"<font color='yellow'>Vibrant flames swirl around you, energizing your mind and muscles.</font>"
		)
		return
	if(isliving(owner))
		cast_on.visible_message( //TODO messages
			"<font color='yellow'>Vibrant flames swirl around [cast_on] as a dance of energy flows from [owner].</font>",
			"<font color='yellow'>A dance of energy flows from [owner], fueling vibrant flames that energize your mind and muscles.</font>"
		)
