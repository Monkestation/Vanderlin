
// AXE CHOP INTENTS //
/datum/intent/axe/chop
	name = "chop"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("chops", "hacks")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = AP_AXE_CHOP
	swingdelay = 1
	misscost = 5
	item_damage_type = "slash"

/datum/intent/axe/chop/great//unique long attack for axes, basically you swing really really hard, stills worse than a polearm like the bardiche or spear
	penfactor = AP_HEAVYAXE_CHOP
	reach = 2
	chargetime = 1
	item_damage_type = "slash"

/datum/intent/axe/chop/scythe //Unique intent for Dendorite Templar
	reach = 2

/datum/intent/axe/chop/battle/greataxe //Essentially a better polearm chop, this weapon is made to chop people limbs off.
	penfactor = AP_GREATAXE_CHOP  // Same AP as the polearm CHOP
	reach = 2
	chargetime = 2
	swingdelay = 2
	no_early_release = TRUE // Needs fo fully charge
	damfactor = 1.2
	misscost = 20

/datum/intent/axe/chop/battle/greataxe/doublehead //Stronger than the one bladed axe but heavier
	penfactor = AP_GREATAXE_CHOP
	reach = 2
	chargetime = 2.5 // Needs more time to fully charge it
	no_early_release = TRUE // Needs fo fully charge
	swingdelay = 2.5
	damfactor = 1.3 // Stronger
	misscost = 25 // Costs more if you miss

// AXE CUT INTENTS //
/datum/intent/axe/cut
	name = "cut"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("cuts", "slashes")
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	animname = "cut"
	penfactor = AP_AXE_CUT
	swingdelay = 0
	misscost = 5
	item_damage_type = "slash"

/datum/intent/axe/cut/battle/greataxe //Decent to cut as well
	reach = 2
	damfactor = 1.1
	swingdelay = 1
	misscost = 10
	item_damage_type = "slash"

/datum/intent/axe/cut/battle/greataxe/doublehead //Better to cut as well
	reach = 2
	chargetime = 1.5
	damfactor = 1.2 // More damage as well
	swingdelay = 1.5
	misscost = 15 // Heavier means more stamina loss if you miss
	item_damage_type = "slash"

// AXE THRUST INTENTS //
/datum/intent/axe/thrust
	name = "impale"
	blade_class = BCLASS_STAB
	attack_verb = list("stabs")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	chargetime = 1
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = AP_HEAVYAXE_STAB
	swingdelay = 1
	misscost = 10
	item_damage_type = "stab"
