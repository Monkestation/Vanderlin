/datum/action/cooldown/spell/status/vigorous_craft
	name = "Virgorous Craftsmanship"
	desc = ""
	button_icon_state = "craft_buff"
	sound = 'sound/items/bsmithfail.ogg'

	cast_range = 2
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/malum)

	invocation = "Through ash and flame! Legere librum!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	cooldown_time = 2.5 MINUTES
	spell_cost = 30

	status_effect = /datum/status_effect/buff/craft_buff

/datum/action/cooldown/spell/status/vigorous_craft/cast(mob/living/cast_on)
	. = ..()
	if(cast_on == owner)
		cast_on.adjust_energy(50)
		cast_on.visible_message(
			"<font color='yellow'>Vibrant flames swirl around [owner].</font>",
			"<font color='yellow'>Vibrant flames swirl around you, energizing your mind and muscles.</font>"
		)
		return
	if(isliving(owner))
		var/mob/living/L = owner
		if(L.energy > (50 * 2))
			L.adjust_energy(-(50 * 2))
			cast_on.adjust_energy(50 * 2)
			cast_on.visible_message(
				"<font color='yellow'>Vibrant flames swirl around [cast_on] as a dance of energy flows from [owner].</font>",
				"<font color='yellow'>A dance of energy flows from [owner], fueling vibrant flames that energize your mind and muscles.</font>"
			)
