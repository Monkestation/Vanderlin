/datum/action/cooldown/spell/undirected/conjure_item/vamp_sword
	name = "Conjure Vampiric Weapon"
	desc = "Summons your Vampiric Weapon."
	button_icon_state = "acidsplash"
	sound = 'sound/magic/whiteflame.ogg'

	associated_skill = /datum/skill/magic/blood
	cooldown_time = 2 MINUTES
	invocation_type = INVOCATION_NONE
	item_type = /obj/item/weapon/sword/long/vlord
	item_duration = null
	spell_type = SPELL_BLOOD
	spell_cost = 50
