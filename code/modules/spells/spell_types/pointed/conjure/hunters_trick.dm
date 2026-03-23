/datum/action/cooldown/spell/conjure/hunters_trick
	name = "Hunter's Trick"
	desc = "Conjure a hunting snare."
	button_icon_state = "ensnare"
	sound = 'sound/items/dig_shovel.ogg'
	self_cast_possible = FALSE

	cast_range = 5
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/great_hunt)
	attunements = list(
		/datum/attunement/earth = 0.6,
	)

	invocation = "Forest bind them..."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_cost = 30

	summon_type = list(/obj/item/restraints/legcuffs/beartrap/hunting_snare)
	summon_radius = 0
	summon_lifespan = 3 MINUTES
