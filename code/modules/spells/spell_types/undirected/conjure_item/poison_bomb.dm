/datum/action/cooldown/spell/undirected/conjure_item/poison_bomb //Yes, I am aware, this is busted, why not just make the bearer craft them? I could, but giving them a way to basically instantly craft one to defend themselves while making other smoke bombs would be better.
	name = "Poison Bomb"
	desc = "Summons a Poison-Bomb out of somewhere."
	button_icon_state = "acidsplash"
	sound = 'sound/magic/whiteflame.ogg'


	cooldown_time = 2 MINUTES
	invocation_type = INVOCATION_NONE
	associated_skill = /datum/skill/craft/alchemy
	item_type = /obj/item/smokebomb/poison_bomb
	item_duration = null
	item_outline ="#0e5c21"
	delete_old = FALSE
	spell_type = SPELL_STAMINA
	spell_cost = 30
