/datum/action/cooldown/spell/conjure/web
	name = "Conjure Web"
	desc = "Create a small web to block foes."

	sound = 'sound/magic/webspin.ogg'

	charge_time = 4 SECONDS
	charge_drain = 3
	cooldown_time = 60 SECONDS
	spell_cost = 40

	invocation = "Strands that bind!"
	invocation_type = INVOCATION_WHISPER

	summon_type = list(/obj/structure/spider/stickyweb/summoned)
	summon_radius = 3
	summon_amount = 0
	spell_flags = SPELL_RITUOS

	required_form = FORM_DEATH
	associated_skill = /datum/attribute/skill/magic/arcane/death
	required_technique = TECHNIQUE_CREATION
