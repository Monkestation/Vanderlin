// FLAIL DERIVING INTENTS //

/datum/intent/flail/strike
	name = "strike"
	icon_state = "instrike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	swingdelay = 5
	misscost = 5
	attack_verb = list("strikes", "hits")
	penfactor = AP_FLAIL_STRIKE
	item_damage_type = "slash"
	acc_bonus = 12

/datum/intent/flail/strike/long
	reach = 2
	misscost = 8

/datum/intent/flail/strike/smash
	name = "smash"
	icon_state = "insmash"
	blade_class = BCLASS_SMASH
	no_early_release = TRUE
	chargetime = 5
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	misscost = 10
	attack_verb = list("smashes")
	damfactor = 1.2
	penfactor = AP_FLAIL_SMASH
	item_damage_type = "slash"
	knockback = TRUE

/datum/intent/flail/strike/smash/long
	reach = 2
	misscost = 12

/datum/intent/flail/strike/matthiosflail
	reach = 2

/datum/intent/flail/strike/smash/matthiosflail
	reach = 2

/datum/intent/flail/cut
	name = "cut"
	blade_class = BCLASS_CUT
	attack_verb = list("slashes", "lacerates")
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	swingdelay = 5
	penfactor = 5
	misscost = 5
	icon_state = "incut"
	item_damage_type = "slash"
	acc_bonus = 12

/datum/intent/flail/cut/long
	reach = 2
	misscost = 10
