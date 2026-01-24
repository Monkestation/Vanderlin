/datum/action/cooldown/spell/undirected/conjure_item/summon_parchment
	name = "Summon Parchment"
	desc = "Summon a blank sheet of parchment from the library of Noc."
	button_icon_state = "summon_paper"
	sound = 'sound/items/book_page.ogg'

	spell_type = SPELL_MANA
	antimagic_flags = MAGIC_RESISTANCE
	associated_skill = /datum/skill/magic/arcane
	experience_modifier = 0.1

	invocation_type = INVOCATION_NONE

	cooldown_time = 2 MINUTES
	spell_cost = 30

	delete_old = FALSE
	item_type = /obj/item/paper
	item_duration = 0

/datum/action/cooldown/spell/undirected/conjure_item/summon_parchment/cast(mob/living/carbon/cast_on)
	playsound(cast_on, 'sound/foley/finger-snap.ogg', 100, FALSE)
	return ..()

/datum/action/cooldown/spell/undirected/conjure_item/summon_parchment/scroll
	name = "Summon Scroll"
	desc = "Summon empty papyrus, ready to transcribed upon."
	sound = 'sound/items/scroll_open.ogg'

	item_type = /obj/item/paper/scroll

