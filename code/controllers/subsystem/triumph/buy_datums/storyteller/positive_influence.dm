/datum/triumph_buy/storyteller_influence_bonus
	name = "Storyteller Influence Bonus"
	desc = "Buy an extra 25 influence for this god!"
	triumph_cost = 2
	category = TRIUMPH_CAT_STORYTELLER
	visible_on_active_menu = TRUE
	limited = TRUE
	stock = 2
	/// The name of the storyteller we are giving bonus influence to
	var/storyteller_name

/datum/triumph_buy/storyteller_influence_bonus/on_activate()
	. = ..()
	if(storyteller_name)
		adjust_storyteller_influence(storyteller_name, 25)

/datum/triumph_buy/storyteller_influence_bonus/matthios
	name = "Matthios' Influence"
	triumph_buy_id = TRIUMPH_BUY_MATTHIOS_INFLUENCE
	storyteller_name = MATTHIOS

/datum/triumph_buy/storyteller_influence_bonus/graggar
	name = "Graggar's Influence"
	triumph_buy_id = TRIUMPH_BUY_GRAGGAR_INFLUENCE
	storyteller_name = GRAGGAR

/datum/triumph_buy/storyteller_influence_bonus/baotha
	name = "Baotha's Influence"
	triumph_buy_id = TRIUMPH_BUY_BAOTHA_INFLUENCE
	storyteller_name = BAOTHA

/datum/triumph_buy/storyteller_influence_bonus/zizo
	name = "Zizo's Influence"
	triumph_buy_id = TRIUMPH_BUY_ZIZO_INFLUENCE
	storyteller_name = ZIZO

/datum/triumph_buy/storyteller_influence_bonus/dendor
	name = "Dendor's Influence"
	triumph_buy_id = TRIUMPH_BUY_DENDOR_INFLUENCE
	storyteller_name = DENDOR

/datum/triumph_buy/storyteller_influence_bonus/eora
	name = "Eora's Influence"
	triumph_buy_id = TRIUMPH_BUY_EORA_INFLUENCE
	storyteller_name = EORA

/datum/triumph_buy/storyteller_influence_bonus/malum
	name = "Malum's Influence"
	triumph_buy_id = TRIUMPH_BUY_MALUM_INFLUENCE
	storyteller_name = MALUM

/datum/triumph_buy/storyteller_influence_bonus/pestra
	name = "Pestra's Influence"
	triumph_buy_id = TRIUMPH_BUY_PESTRA_INFLUENCE
	storyteller_name = PESTRA

/datum/triumph_buy/storyteller_influence_bonus/necra
	name = "Necra's Influence"
	triumph_buy_id = TRIUMPH_BUY_NECRA_INFLUENCE
	storyteller_name = NECRA

/datum/triumph_buy/storyteller_influence_bonus/xylix
	name = "Xylix's Influence"
	triumph_buy_id = TRIUMPH_BUY_XYLIX_INFLUENCE
	storyteller_name = XYLIX

/datum/triumph_buy/storyteller_influence_bonus/abyssor
	name = "Abyssor's Influence"
	triumph_buy_id = TRIUMPH_BUY_ABYSSOR_INFLUENCE
	storyteller_name = ABYSSOR

/datum/triumph_buy/storyteller_influence_bonus/ravox
	name = "Ravox's Influence"
	triumph_buy_id = TRIUMPH_BUY_RAVOX_INFLUENCE
	storyteller_name = RAVOX

/datum/triumph_buy/storyteller_influence_bonus/noc
	name = "Noc's Influence"
	triumph_buy_id = TRIUMPH_BUY_NOC_INFLUENCE
	storyteller_name = NOC

/datum/triumph_buy/storyteller_influence_bonus/astrata
	name = "Astrata's Influence"
	triumph_buy_id = TRIUMPH_BUY_ASTRATA_INFLUENCE
	storyteller_name = ASTRATA
