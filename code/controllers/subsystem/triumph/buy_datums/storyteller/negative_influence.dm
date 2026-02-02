/datum/triumph_buy/storyteller_influence_reduction
	name = "Storyteller Influence Reduction"
	desc = "Reduce the influence of this god by 25!"
	triumph_cost = 2
	category = TRIUMPH_CAT_STORYTELLER
	visible_on_active_menu = TRUE
	limited = TRUE
	stock = 2
	/// The name of the storyteller we are reducing influence for
	var/storyteller_name

/datum/triumph_buy/storyteller_influence_reduction/on_activate()
	. = ..()
	if(storyteller_name)
		adjust_storyteller_influence(storyteller_name, -25)

/datum/triumph_buy/storyteller_influence_reduction/matthios
	name = "Matthios' Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_MATTHIOS_INFLUENCE_REDUCTION
	storyteller_name = MATTHIOS

/datum/triumph_buy/storyteller_influence_reduction/graggar
	name = "Graggar's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_GRAGGAR_INFLUENCE_REDUCTION
	storyteller_name = GRAGGAR

/datum/triumph_buy/storyteller_influence_reduction/baotha
	name = "Baotha's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_BAOTHA_INFLUENCE_REDUCTION
	storyteller_name = BAOTHA

/datum/triumph_buy/storyteller_influence_reduction/zizo
	name = "Zizo's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_ZIZO_INFLUENCE_REDUCTION
	storyteller_name = ZIZO

/datum/triumph_buy/storyteller_influence_reduction/dendor
	name = "Dendor's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_DENDOR_INFLUENCE_REDUCTION
	storyteller_name = DENDOR

/datum/triumph_buy/storyteller_influence_reduction/eora
	name = "Eora's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_EORA_INFLUENCE_REDUCTION
	storyteller_name = EORA

/datum/triumph_buy/storyteller_influence_reduction/malum
	name = "Malum's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_MALUM_INFLUENCE_REDUCTION
	storyteller_name = MALUM

/datum/triumph_buy/storyteller_influence_reduction/pestra
	name = "Pestra's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_PESTRA_INFLUENCE_REDUCTION
	storyteller_name = PESTRA

/datum/triumph_buy/storyteller_influence_reduction/necra
	name = "Necra's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_NECRA_INFLUENCE_REDUCTION
	storyteller_name = NECRA

/datum/triumph_buy/storyteller_influence_reduction/xylix
	name = "Xylix's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_XYLIX_INFLUENCE_REDUCTION
	storyteller_name = XYLIX

/datum/triumph_buy/storyteller_influence_reduction/abyssor
	name = "Abyssor's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_ABYSSOR_INFLUENCE_REDUCTION
	storyteller_name = ABYSSOR

/datum/triumph_buy/storyteller_influence_reduction/ravox
	name = "Ravox's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_RAVOX_INFLUENCE_REDUCTION
	storyteller_name = RAVOX

/datum/triumph_buy/storyteller_influence_reduction/noc
	name = "Noc's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_NOC_INFLUENCE_REDUCTION
	storyteller_name = NOC

/datum/triumph_buy/storyteller_influence_reduction/astrata
	name = "Astrata's Influence Reduction"
	triumph_buy_id = TRIUMPH_BUY_ASTRATA_INFLUENCE_REDUCTION
	storyteller_name = ASTRATA
