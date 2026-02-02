
// MACE DERIVING INTENTS //
// MACE STRIKE INTENTS
/datum/intent/mace/strike
	name = "strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "hits")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = AP_CLUB_STRIKE
	swingdelay = 0
	icon_state = "instrike"
	misscost = 5
	item_damage_type = "blunt"

/datum/intent/mace/strike/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')

/datum/intent/mace/strike/heavy
	penfactor = AP_CLUB_HEAVY_STRIKE
	swingdelay = 2
	icon_state = "instrike"
	misscost = 12

/datum/intent/mace/strike/shovel
	hitsound = list('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	penfactor = 10
	icon_state = "instrike"

// MACE SMASH INTENTS //
/datum/intent/mace/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = AP_CLUB_SMASH
	damfactor = 1.1
	chargetime = 3
	swingdelay = 3
	charging_slowdown = 0.8
	icon_state = "insmash"
	misscost = 10
	item_damage_type = "blunt"

/datum/intent/mace/smash/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')

/datum/intent/mace/smash/wood/ranged
	reach = 2

/datum/intent/mace/smash/heavy
	penfactor = AP_HEAVY_SMASH
	damfactor = 1.2
	chargetime = 3
	swingdelay = 3
	misscost = 22
	warnie = "mobwarning"

/datum/intent/mace/thrust
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("stabs")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	chargetime = 1
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 40
	swingdelay = 1
	misscost = 15
	item_damage_type = "blunt"

/datum/intent/mace/warhammer/stab
	name = "thrust"
	icon_state = "instab"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "stabs")
	animname = "stab"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 20
	damfactor = 0.8
	item_damage_type = "stab"

/datum/intent/mace/warhammer/impale
	name = "impale"
	icon_state = "inimpale"
	blade_class = BCLASS_PICK
	attack_verb = list("picks", "impales")
	animname = "stab"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 14
	chargedrain = 1
	misscost = 1
	no_early_release = TRUE
	penfactor = 80
	damfactor = 0.9
	item_damage_type = "stab"

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
	recovery = 10
	misscost = 10
	attack_verb = list("smashes")
	damfactor = 1.2
	penfactor = AP_FLAIL_SMASH
	item_damage_type = "slash"

/datum/intent/flail/strike/smash/long
	reach = 2
	recovery = 12
	misscost = 12

/datum/intent/flail/strike/matthiosflail
	reach = 2

/datum/intent/flail/strike/smash/matthiosflail
	reach = 2

