/datum/action/cooldown/spell/undirected/conjure_item/summon_leech
	name = "Summon Leech"
	desc = "Summon a leech from Abyssor's domain."
	button_icon_state = "curse2"
	sound = 'sound/foley/jumpland/waterland.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/abyssor)

	invocation = "Abyssor bless me with one of your servants!"
	invocation_type = INVOCATION_WHISPER

	cooldown_time = 1 MINUTES
	spell_cost = 30

	delete_old = FALSE
	item_type = /obj/item/natural/worms/leech
	item_duration = 0

/datum/action/cooldown/spell/undirected/conjure_item/summon_leech/pestra
	name = "Pestra's Leech"
	desc = "Summon a leech by Pestra's will."
	button_icon_state = "diagnose"

	required_items = list(/obj/item/clothing/neck/psycross/silver/pestra)

	invocation = "Pestra grant me the creacher to cleanse the blood!"
	invocation_type = INVOCATION_WHISPER
