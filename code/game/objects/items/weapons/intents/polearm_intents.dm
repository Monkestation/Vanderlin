// POLEARM THRUST INTENTS //
/datum/intent/polearm/thrust
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("stabs")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	chargetime = 1
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = AP_POLEARM_THRUST
	swingdelay = 1
	misscost = 10
	item_damage_type = "stab"

/datum/intent/polearm/thrust/spear
	penfactor = AP_SPEAR_THRUST

//POLEARM BASH INTENTS //
/datum/intent/polearm/bash
	name = "bash"
	blade_class = BCLASS_BLUNT
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')
	penfactor = AP_POLEARM_BASH
	damfactor = 0.8
	swingdelay = 1
	misscost = 5
	item_damage_type = "blunt"

/datum/intent/polearm/bash/ranged
	reach = 2

// POLEARM CUT INTENTS //
/datum/intent/polearm/cut
	name = "cut"
	blade_class = BCLASS_CUT
	attack_verb = list("cuts", "slashes")
	icon_state = "incut"
	animname = "cut"
	damfactor = 0.8
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	reach = 2
	swingdelay = 1
	misscost = 10
	item_damage_type = "slash"

/datum/intent/spear/cut/bardiche/scythe //Unique intent for Dendorite Templar
	reach = 2

/datum/intent/spear/cut/naginata
	damfactor = 1.2
	chargetime = 0


// POLEARM CHOP INTENTS //
/datum/intent/polearm/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops", "hacks")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = AP_POLEARM_CHOP
	chargetime = 1.5
	damfactor = 1.2
	swingdelay = 2
	misscost = 20
	warnie = "mobwarning"
	item_damage_type = "slash"

// POLEARM REND INTENTS //
/datum/intent/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	damfactor = 1.2
	chargetime = 10
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_damage_type = "slash"
	misscost = 10

/datum/intent/rend/reach
	name = "long rend"
	penfactor = -100
	misscost = 5
	chargetime = 5
	reach = 2
