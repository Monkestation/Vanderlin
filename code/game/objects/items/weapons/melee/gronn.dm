// Weapons
/obj/item/weapon/sword/short/gronn
	name = "gronnic hinterblade"
	desc = "Due to the shortage of forged steel in Gronn, their iron blades have become hardier and thicker than what one may see elsewhere. The favoured weapon of choice for any able-bodied northman of Gronn, the hinterblade is the heftier, unwieldy cousin of the arming sword."
	possible_item_intents = list(/datum/intent/sword/cut/militia, /datum/intent/sword/chop/militia, /datum/intent/sword/thrust/short)
	icon_state = "gronnsword"
	gripped_intents = null
	minstr = 10 //NO TWINKS!!
	wdefense = 3 // Use it with a shield jackass
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL

	grid_width = 32
	grid_height = 96

/datum/intent/sword/cut/militia
	penfactor = 30
	damfactor = 1.2
	no_early_release = TRUE

/datum/intent/sword/chop/militia
	penfactor = 50
	swingdelay = 0
	damfactor = 1.0
	no_early_release = TRUE

/obj/item/weapon/handclaw
	slot_flags = ITEM_SLOT_HIP
	name = "Iron Hound Claws"
	desc = "A pair of heavily curved claws, styled after beasts of the wilds for rending bare flesh, \
			A show of the continual worship and veneration of beasts of strength in Gronn."
	icon_state = "ironclaws"
	icon = 'icons/roguetown/weapons/32/fists_claws.dmi'
	wdefense = 5
	force = 30
	possible_item_intents = list(/datum/intent/claw/cut/iron, /datum/intent/claw/lunge/iron, /datum/intent/claw/rend)
	wbalance = DODGE_CHANCE_NORMAL
	max_blade_int = 300
	max_integrity = 200
	gripsprite = FALSE
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	grid_height = 96
	grid_width = 32

/obj/item/weapon/handclaw/steel
	name = "Steel Mantis Claws"
	desc = "A pair of steel claws, An uncommon sight in Gronn as they do not forge their own steel, \
			Their longer blades offer a superior defence option but their added weight slows them down."
	icon_state = "steelclaws"
	wdefense = 6
	force = 35
	possible_item_intents = list(/datum/intent/claw/cut/steel, /datum/intent/claw/lunge/steel, /datum/intent/claw/rend/steel)
	wbalance = EASY_TO_DODGE
	max_blade_int = 180
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/weapon/handclaw/gronn
	name = "Gronn Beast Claws"
	desc = "A pair of uniquely reinforced iron claws forged with the addition of bone by the Iskarn shamans of the Northern Empty. \
			Their unique design aids them in slipping between the plates in armor and their light weight supports rapid aggressive slashes. \
			'To see the claws of the four, Is to see the true danger of the north. Not man, Not land but beast. We are all prey in their eyes.'"
	icon_state = "gronnclaws"
	wdefense = 3
	force = 25
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)
	wbalance = HARD_TO_DODGE
	max_blade_int = 200
	max_integrity = 200


/obj/item/rogueweapon/handclaw/getonmobprop(tag)
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

/datum/intent/claw/lunge/iron
	damfactor = 1.2
	swingdelay = 8
	clickcd = CLICK_CD_MELEE
	penfactor = 35

/datum/intent/claw/lunge/steel
	damfactor = 1.2
	swingdelay = 12
	clickcd = CLICK_CD_RESIST
	penfactor = 35

/datum/intent/claw/lunge/gronn
	damfactor = 1.1
	swingdelay = 5
	clickcd = 10
	penfactor = 45

/datum/intent/claw/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	item_damage_type = "slash"

/datum/intent/claw/cut/iron
	penfactor = 20
	swingdelay = 8
	damfactor = 1.4
	clickcd = CLICK_CD_RESIST

/datum/intent/claw/cut/steel
	penfactor = 10
	swingdelay = 4
	damfactor = 1.3
	clickcd = CLICK_CD_RESIST

/datum/intent/claw/cut/gronn
	penfactor = 30
	swingdelay = 0
	damfactor = 1.1
	clickcd = CLICK_CD_MELEE

/datum/intent/claw/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	penfactor = AP_CLUB_SMASH
	swingdelay = 20
	damfactor = 2.5
	clickcd = CLICK_CD_RESIST
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_damage_type = "slash"
	misscost = 10
	damfactor = 0.05

/datum/intent/claw/rend/steel
	damfactor = 3

/datum/intent/peculate
	name = "peculate"
	hitsound = null
	desc = "Thieve the appearance of another."
	icon_state = "peculate"
