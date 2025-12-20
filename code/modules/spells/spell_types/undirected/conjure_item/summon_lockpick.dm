/datum/action/cooldown/spell/undirected/conjure_item/summon_lockpick
	name = "Skeleton Key"
	desc = "Procure a Skeleton Key from somewhere within. The maggots churn and the flies writhe as they coalesce and form into a malleable, slim shape." // Yes, this is Canon.
	button_icon_state = "darkvision" // No, I'm not going to elaborate about it.
	sound = 'sound/magic/turntoflies2.ogg'


	cooldown_time = 1 MINUTES
	invocation_type = INVOCATION_NONE
	associated_skill = /datum/skill/misc/lockpicking
	item_type = /obj/item/lockpick
	item_duration = 1 MINUTES
	item_outline ="#1e202cff"
	delete_old = FALSE
	spell_type = SPELL_STAMINA
	spell_cost = 30

/datum/action/cooldown/spell/undirected/conjure_item/summon_lockpick/cast(mob/living/cast_on)
	. = ..()
	cast_on.adjustBruteLoss(3) // This shit ain't free, man
