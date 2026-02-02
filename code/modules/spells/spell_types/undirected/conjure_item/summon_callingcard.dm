/datum/action/cooldown/spell/undirected/conjure_item/calling_card
	name = "Calling Card"
	desc = "Retrieve a Calling Card from your wrist."
	button_icon_state = "curse2"
	sound = 'sound/magic/summonwhistle.ogg'


	cooldown_time = 5 MINUTES // This isn't meant to be used in combat/stacked. The idea of throwing shit like gambit's funny, though
	invocation_type = INVOCATION_NONE
	associated_skill = /datum/skill/craft/bombs
	item_type = /obj/item/weapon/knife/throwingknife/throwcard
	item_duration = null
	item_outline ="#154666ff"
	delete_old = FALSE
	spell_type = SPELL_STAMINA
