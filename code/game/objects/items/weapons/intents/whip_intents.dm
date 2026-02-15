// WHIP LASH INTENTS //
/datum/intent/whip/lash
	name = "lash"
	blade_class = BCLASS_LASHING
	attack_verb = list("lashes", "whips")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	swingdelay = 2
	clickcd = 14
	penfactor = 5
	reach = 2
	misscost = 7
	icon_state = "inlash"
	canparry = FALSE //Has reach and can't be parried, but needs to be charged and punishes misses.
	item_damage_type = "slash"
	acc_bonus = 10

/datum/intent/whip/lash/metal
	clickcd = 18
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	penfactor = 15

/datum/intent/whip/lash/cane
	attack_verb = list("lashes", "canes")
	chargetime = 20
	no_early_release = TRUE
	penfactor = 0
	reach = 1 //no added range
	misscost = 10
	icon_state = "inlash"
	canparry = TRUE //Not meant for fighting with
	item_damage_type = "slash"

// WHIP CUT INTENTS //
/datum/intent/whip/cut
	name = "cut"
	blade_class = BCLASS_CUT
	attack_verb = list("slashes", "lacerates")
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	clickcd = 18
	swingdelay = 1
	penfactor = 5
	reach = 2
	misscost = 7
	icon_state = "incut"
	canparry = FALSE
	item_damage_type = "slash"

// WHIP CRACK INTENTS //
/datum/intent/whip/crack
	name = "crack"
	blade_class = BCLASS_BLUNT
	attack_verb = list("cracks", "strikes") //something something dwarf fotresss
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	penfactor = 10
	icon_state = "incrack"
	canparry = TRUE
	item_damage_type = "slash"
	acc_bonus = 12

/datum/intent/whip/crack/metal
	penfactor = 20
