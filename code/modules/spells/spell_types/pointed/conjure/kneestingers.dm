/datum/action/cooldown/spell/conjure/kneestingers
	name = "Fungal Illumination"
	desc = "Conjure kneestingers to light the path."
	button_icon_state = "kneestinger"
	sound = 'sound/items/dig_shovel.ogg'
	self_cast_possible = FALSE

	cast_range = 1
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/dendor)
	attunements = list(
		/datum/attunement/earth = 0.6,
	)

	invocation = "Treefather light the way."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_cost = 30

	summon_type = list(/obj/structure/kneestingers/decaying)
	summon_radius = 0
