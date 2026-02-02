/datum/triumph_buy/secret_officiant
	name = "Secret Officiant"
	desc = "Love knows no bounds. Gain a trait that allows you to conduct secret marriage ceremonies outside of the chapel and with no announcement. Ceremony is otherwise the same, requiring an apple bitten by both participants and used on any holy cross."
	triumph_buy_id = TRIUMPH_BUY_SECRET_OFFICIANT
	triumph_cost = 2
	category = TRIUMPH_CAT_CHARACTER
	visible_on_active_menu = TRUE
	manual_activation = TRUE
	limited = TRUE
	stock = 1

/datum/triumph_buy/secret_officiant/on_after_spawn(mob/living/carbon/human/H)
	. = ..()
	ADD_TRAIT(H, TRAIT_SECRET_OFFICIANT, TRAIT_GENERIC)
	on_activate()
