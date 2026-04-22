// Weapons
/obj/item/weapon/sword/short/gronn
	name = "Osslandic hinterblade"
	desc = "Due to the shortage of forged steel in Ossland, their iron blades have become hardier and thicker than what one may see elsewhere. The favoured weapon of choice for any able-bodied hunter of Ossland, the hinterblade is the heftier, unwieldy cousin of the arming sword."
	icon_state = "gronnsword"
	force = DAMAGE_SWORD
	wdefense = GOOD_PARRY
	possible_item_intents = list(/datum/intent/sword/cut/militia, /datum/intent/sword/chop/militia, SHORT_THRUST)
	wlength = WLENGTH_SHORT
	gripped_intents = null
	minstr = 9 //NO TWINKS!!
	w_class = WEIGHT_CLASS_NORMAL

	grid_width = 32
	grid_height = 96
	item_weight = 1.2 KILOGRAMS

/datum/intent/sword/cut/militia
	penfactor = 10

/datum/intent/sword/chop/militia
	penfactor = 10

/obj/item/weapon/handclaw
	name = "Iron Hound Claws"
	desc = "A pair of heavily curved claws, styled after beasts of the wilds for rending bare flesh, \
			a show of the continual worship and veneration of the Great Hunt in Ossland."
	icon = 'icons/roguetown/weapons/32/fists_claws.dmi'
	icon_state = "ironclaws"
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	force = DAMAGE_KATAR + 5
	throwforce = DAMAGE_KATAR - 3
	wbalance = DODGE_CHANCE_NORMAL
	wdefense = AVERAGE_PARRY
	wlength = WLENGTH_NORMAL
	possible_item_intents = list(/datum/intent/claw/cut, /datum/intent/claw/lunge, /datum/intent/claw/rend)
	max_blade_int = 300
	max_integrity = INTEGRITY_STANDARD

	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CUT
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	associated_skill = /datum/attribute/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	melting_material = /datum/material/iron
	anvilrepair = /datum/attribute/skill/craft/weaponsmithing
	grid_height = 96
	grid_width = 32
	item_weight = 800 GRAMS

/obj/item/weapon/handclaw/steel
	name = "Steel Mantis Claws"
	desc = "A pair of steel claws, an uncommon sight in Ossland as they do not forge their own steel, \
			Their longer blades offer a superior defence option but their added weight slows them down."
	icon_state = "steelclaws"
	force = DAMAGE_KATAR + 7
	wdefense = GOOD_PARRY
	possible_item_intents = list(/datum/intent/claw/cut/steel, /datum/intent/claw/lunge/steel, /datum/intent/claw/rend/steel)
	wbalance = EASY_TO_DODGE
	max_blade_int = 250
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron
	item_weight = 900 GRAMS

/obj/item/weapon/handclaw/gronn
	name = "Ossland Beast Claws"
	desc = "A pair of uniquely reinforced iron claws forged with the addition of bone by the cleric-priests of Ossland. \
			Their unique design aids them in slipping between the plates in armor and their light weight supports rapid aggressive slashes. \
			'The cycle of predator and prey continues. To hunt is to be hunted is to hunt in return.'"
	icon_state = "gronnclaws"
	wdefense = GOOD_PARRY
	possible_item_intents = list(/datum/intent/claw/cut, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)
	wbalance = HARD_TO_DODGE
	item_weight = 750 GRAMS


/obj/item/weapon/handclaw/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/claw/lunge
	name = "lunge"
	icon_state = "inimpale"
	attack_verb = list("lunges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	swingdelay = 3
	penfactor = 20
	misscost = 4

/datum/intent/claw/lunge/steel
	damfactor = 1.1

/datum/intent/claw/lunge/gronn
	clickcd = 10

/datum/intent/claw/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	item_damage_type = "slash"
	misscost = 4
	penfactor = AP_AXE_CHOP
	swingdelay = 3

/datum/intent/claw/cut/steel
	damfactor = 1.1

/datum/intent/claw/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	penfactor = AP_AXE_CHOP
	swingdelay = 5
	clickcd = 16
	damfactor = 1.1
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_damage_type = "slash"
	misscost = 8

/datum/intent/claw/rend/steel
	damfactor = 1.2

//Mauls. Woe. Most characters will not be able to engage with this, beyond hobbling.
//Why? The unique strength lockout. The minimum strength is not a suggestion.
/obj/item/weapon/mace/goden/maul
	name = "maul"
	desc = "Who would need something this large? It looks like it was made for tearing down walls, rather than men."
	icon_state = "sledge"
	force_wielded = DAMAGE_HEAVYCLUB_WIELD - 3 //-3 compared to grand mace(steel goden). Better intents.
	wdefense = GOOD_PARRY
	wlength = WLENGTH_LONG
	possible_item_intents = list(/datum/intent/mace/strike)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/effect/daze, /datum/intent/effect/hobble)
	minstr = 12

	swingsound = BLUNTWOOSH_HUGE
	slot_flags = null //No.
	dropshrink = 0.6
	bigboy = TRUE
	gripsprite = TRUE
	item_weight = 6 KILOGRAMS

//Intents for the mauls.
/datum/intent/effect/hobble
	name = "hobbling strike"
	desc = "A heavy strike aimed at the legs to cripple movement."
	icon_state = "incrack"//Temp. Just so it's easy to differentiate.
	attack_verb = list("hobbles")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/shovel_hit3.ogg')
	swingdelay = 6
	damfactor = 0.8
	penfactor = AP_CLUB_STRIKE
	item_damage_type = "blunt"
	intent_effect = /datum/status_effect/debuff/hobbled
	target_parts = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //Intentionally leaving out feet. If you know, you know.
