/datum/triumph_buy/random_curse
	name = "Random Curse"
	desc = "Become cursed by a random deity different from your patron. Curse effects vary from deity to deity."
	triumph_buy_id = TRIUMPH_BUY_CURSE
	triumph_cost = 0
	category = TRIUMPH_CAT_CHALLENGES
	visible_on_active_menu = TRUE
	manual_activation = TRUE
	var/list/patron_curse_map = list(
		/datum/patron/divine/astrata = /datum/curse/astrata,
		/datum/patron/divine/ravox = /datum/curse/ravox,
		/datum/patron/divine/necra = /datum/curse/necra,
		/datum/patron/divine/xylix = /datum/curse/xylix,
		/datum/patron/divine/pestra = /datum/curse/pestra,
		/datum/patron/divine/eora = /datum/curse/eora,
		/datum/patron/divine/malum = /datum/curse/malum,
		/datum/patron/inhumen/zizo = /datum/curse/zizo/minor,
		/datum/patron/inhumen/matthios = /datum/curse/matthios,
		/datum/patron/inhumen/baotha = /datum/curse/baotha,
		/datum/patron/inhumen/graggar_zizo = /datum/curse/zizo/minor,
	)

/datum/triumph_buy/random_curse/on_after_spawn(mob/living/carbon/human/H)
	. = ..()

	var/list/available_curses = (TEN_CURSES + INHUMEN_CURSES) - list(/datum/curse/noc, /datum/curse/graggar, /datum/curse/zizo)

	if(H.patron && patron_curse_map[H.patron.type])
		var/datum/curse/patron_curse = patron_curse_map[H.patron.type]
		available_curses -= patron_curse

	if(!length(available_curses))
		return

	var/selected_curse_type = pick(available_curses)
	H.add_curse(selected_curse_type)

	on_activate()
