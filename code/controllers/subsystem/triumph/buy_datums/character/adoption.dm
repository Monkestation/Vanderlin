/datum/triumph_buy/adoption
	name = "Adoption Ability"
	desc = "Gain an ability to adopt children and start your own family!"
	triumph_buy_id = TRIUMPH_BUY_ADOPTION
	triumph_cost = 1
	category = TRIUMPH_CAT_CHARACTER
	visible_on_active_menu = TRUE
	manual_activation = TRUE

/datum/triumph_buy/adoption/on_after_spawn(mob/living/carbon/human/H)
	. = ..()
	H.add_spell(/datum/action/cooldown/spell/adopt_child)
	on_activate()
