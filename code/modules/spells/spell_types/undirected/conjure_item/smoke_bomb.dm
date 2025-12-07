/datum/action/cooldown/spell/undirected/conjure_item/smoke_bomb
	name = "Smoke Bomb"
	desc = "Summons a Smoke-Bomb out of somewhere."
	button_icon_state = "darkvision"
	sound = 'sound/magic/magicbottle.ogg'


	cooldown_time = 2 MINUTES
	invocation_type = INVOCATION_NONE
	associated_skill = /datum/skill/craft/bombs
	item_type = /obj/item/smokebomb
	item_duration = null
	item_outline ="#0e5c21"
	delete_old = TRUE // Antiquarian has alot of other utility spells now, goodbye FALSE my beloved.
	spell_type = SPELL_STAMINA
	spell_cost = 30
