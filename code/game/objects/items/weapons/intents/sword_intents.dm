
/*------------\
| Chop intent |
\------------*/
/datum/intent/sword/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops", "hacks")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = AP_SWORD_CHOP
	damfactor = 1.1
	swingdelay = 1
	misscost = 8
	item_damage_type = "slash"

/datum/intent/sword/chop/long
	damfactor = 1.1
	chargetime = 1.2
	swingdelay = 1.5
	misscost = 12
	warnie = "mobwarning"
	item_damage_type = "slash"

/datum/intent/sword/chop/long/shotel
	reach = 2 //shotels are long lol

/datum/intent/sword/chop/long/guts
	reach = 2 // BIG SWORD
	swingdelay = 3
	misscost = 90

/*------------\
| Stab intent |
\------------*/
/datum/intent/sword/thrust
	name = "stab"
	icon_state = "instab"
	attack_verb = list("stabs")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = AP_SWORD_THRUST
	misscost = 5
	item_damage_type = "stab"

/datum/intent/sword/thrust/curved
	penfactor = AP_SWORD_THRUST-2

/datum/intent/sword/thrust/short
	clickcd = 10
	penfactor = AP_SWORD_THRUST+2

/datum/intent/sword/thrust/rapier
	penfactor = AP_SWORD_THRUST+5

/datum/intent/sword/thrust/zwei
	name = "thrust"
	reach = 1
	chargetime = 1
	warnie = "mobwarning"
	swingdelay = 1

/datum/intent/sword/thrust/long
	reach = 2
	misscost = 10

/datum/intent/sword/thrust/guts
	reach = 2
	swingdelay = 3
	misscost = 90

/datum/intent/sword/thrust/hook
	damfactor = 0.9

/*--------------\
| Strike intent |	Pommel strike, some AP
\--------------*/
/datum/intent/sword/strike
	name = "pommel strike"
	icon_state = "instrike"
	attack_verb = list("bashes", "clubs")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = AP_CLUB_STRIKE
	swingdelay = 1
	damfactor = 0.8
	item_damage_type = "blunt"

/datum/intent/sword/strike/guts
	reach = 2
	swingdelay = 3
	misscost = 90

/datum/intent/sword/bash
	name = "pommel bash"
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	blade_class = BCLASS_BLUNT
	chargetime = 1
	charging_slowdown = 0.8
	penfactor = AP_CLUB_SMASH
	swingdelay = 1
	damfactor = 1.1
	item_damage_type = "blunt"

/*-----------\
| Cut intent |
\-----------*/
/datum/intent/sword/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	misscost = 4
	item_damage_type = "slash"

/datum/intent/sword/cut/long
	reach = 2

/datum/intent/sword/cut/zwei
	name = "cut"
	damfactor = 0.8
	reach = 1
	swingdelay = 1
	item_damage_type = "slash"

/datum/intent/sword/cut/rapier
	chargetime = 0
	damfactor = 0.8
	item_damage_type = "slash"

/datum/intent/sword/cut/short
	clickcd = 10
	damfactor = 0.85
	item_damage_type = "slash"

/datum/intent/sword/cut/guts
	reach = 2
	swingdelay = 2
	misscost = 90

/datum/intent/katana/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_damage_type = "slash"
	damfactor = 1.1
	misscost = 10
	swingdelay = 0.5

/datum/intent/katana/cut/one_hand_cut
	damfactor = 1
	misscost = 4
	swingdelay = 0


/*-----------\
|   Special  |
\-----------*/
/datum/intent/sword/thrust/estoc
	name = "thrust"
	penfactor = AP_SWORD_THRUST+10 //30 total
	recovery = 20
	clickcd = 10

/datum/intent/sword/lunge
	name = "lunge"
	icon_state = "inimpale"
	attack_verb = list("lunges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	reach = 2
	penfactor = AP_SWORD_THRUST+30 //50 total
	chargetime = 5
	no_early_release = TRUE
	recovery = 20
	clickcd = 10

/datum/intent/katana/arc
	name = "arc slash"
	icon_state = "inarc"
	attack_verb = list("sweeps", "arcs")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_damage_type = "slash"
	reach = 2
	swingdelay = 1.5
	chargetime = 1.2
	misscost = 20

/datum/intent/katana/precision_cut
	name = "precision cut"
	icon_state = "incut"
	attack_verb = list("precision-cuts", "clean-slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_damage_type = "slash"
	damfactor = 1.2
	penfactor = AP_SWORD_THRUST+5
	no_early_release = TRUE
	swingdelay = 3
	chargetime = 3
	chargedrain = 1
	misscost = 25
	recovery = 15
	charging_slowdown = 1
	clickcd = 15
