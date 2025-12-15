/datum/action/cooldown/spell/undirected/conjure_item/puffer
	name = "Conjure Puffer"
	desc = "Summons a Puffer out of somewhere..."
	button_icon_state = "acidsplash"
	sound = 'sound/magic/whiteflame.ogg'

	associated_skill = /datum/skill/magic/holy
	cooldown_time = 2 MINUTES
	invocation_type = INVOCATION_NONE
	item_type = /obj/item/gun/ballistic/revolver/grenadelauncher/pistol/conjured
	item_duration = null
	item_outline ="#ababab"
	spell_type = SPELL_STAMINA //It is a way to balance it out since you are not a real miracle user.
	spell_cost = 40
