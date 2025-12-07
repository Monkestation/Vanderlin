/* POLEARMS
==========================================================*/

/obj/item/weapon/polearm
	throwforce = DAMAGE_STAFF
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	max_blade_int = 100
	max_integrity = INTEGRITY_STRONG
	minstr = 8
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	associated_skill = /datum/skill/combat/polearms
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	dropshrink = 0.8
	blade_dulling = DULLING_BASHCHOP
	wdefense = GREAT_PARRY
	thrown_bclass = BCLASS_STAB
	sellprice = 20

/obj/item/weapon/polearm/Initialize()
	. = ..()
	AddComponent(/datum/component/walking_stick)

/obj/item/weapon/polearm/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/*--------------\
| Thrust intent |
\--------------*/
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

/*------------\
| Bash intent |
\------------*/
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

/*-------------\
| Swing intent |
\-------------*/
/datum/intent/polearm/bash/swing//AYAYAYAYA BONK BONK BONK
	name = "swing"
	attack_verb = list("bashes", "strikes", "swings")
	reach = 2
	chargetime = 1
	item_damage_type = "slash"

/*-----------\
| Cut intent |
\-----------*/
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

/*------------\
| Chop intent |
\------------*/
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


//................ Wooden Staff ............... //
/obj/item/weapon/polearm/woodstaff
	force =  DAMAGE_STAFF
	force_wielded =  DAMAGE_STAFF_WIELD-1
	possible_item_intents = list(POLEARM_BASH)
	gripped_intents = list(POLEARM_BASH,/datum/intent/mace/smash/wood)
	name = "wooden staff"
	desc = "The ultimate tool of travel for weary wanderers, support your weight or crack the heads that don't support you."
	icon_state = "woodstaff"
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_BLUNT
	max_integrity = 200
	wdefense = ULTMATE_PARRY
	minstr = 5
	sellprice = 5

/obj/item/weapon/polearm/woodstaff/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//................ Quarterstaff ............... //!
/obj/item/weapon/polearm/woodstaff/quarterstaff
	force_wielded =  DAMAGE_STAFF_WIELD
	name = "wooden quarterstaff"
	desc = "A staff that makes any journey easier. Durable and swift, capable of bludgeoning stray volves and ruffians alike."
	icon_state = "quarterstaff"
	max_integrity = INTEGRITY_STRONG
	sellprice = 10

//................ Iron-shod Staff ............... //
/obj/item/weapon/polearm/woodstaff/quarterstaff/iron
	force_wielded =  DAMAGE_STAFF_WIELD
	gripped_intents = list(POLEARM_BASH,/datum/intent/mace/smash)
	name = "iron quarterstaff"
	desc = "A perfect tool for bounty hunters who prefer their prisoners broken and bruised but not slain. This reinforced staff is capable of clubbing even an armed opponent into submission with some carefully placed strikes."
	icon_state = "quarterstaff_iron"
	minstr = 7
	max_integrity = INTEGRITY_STRONG

/obj/item/weapon/polearm/woodstaff/quarterstaff/steel
	force_wielded =  DAMAGE_STAFF_WIELD+1
	gripped_intents = list(POLEARM_BASH,/datum/intent/mace/smash)
	name = "steel quarterstaff"
	desc = "An unusual sight, a knightly combat staff made out of worked steel and reinforced wood. It is a heavy and powerful weapon, more than capable of beating the living daylights out of any brigand."
	icon_state = "quarterstaff_steel"
	minstr = 7
	max_integrity = INTEGRITY_STRONGEST

//................ Staff of the Testimonium ............... //
/obj/item/weapon/polearm/woodstaff/aries
	force_wielded =  DAMAGE_STAFF_WIELD+1
	name = "staff of the testimonium"
	desc = "A symbolic staff, granted to enlightened acolytes who have achieved and bear witnessed to the miracles of the Gods."
	icon_state = "aries"
	resistance_flags = FIRE_PROOF // Leniency for unique items
	dropshrink = 0.6
	sellprice = 100

/obj/item/weapon/polearm/woodstaff/seer
	force_wielded =  DAMAGE_STAFF_WIELD+1
	name = "staff of the rous seer"
	desc = "A staff used by the rousman seers, mainly to protect themselves."
	icon_state = "seerstaff"
	sellprice = 100

//................ Spear ............... //
/obj/item/weapon/polearm/spear
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR_WIELD
	throwforce = DAMAGE_SPEAR
	possible_item_intents = list(SPEAR_THRUST, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, POLEARM_BASH)
	name = "spear"
	desc = "The humble spear, use the pointy end."
	icon_state = "spear"
	slot_flags = ITEM_SLOT_BACK
	max_blade_int = 100
	melting_material = /datum/material/iron
	melt_amount = 75
	dropshrink = 0.8
	thrown_bclass = BCLASS_STAB
	sellprice = 22

/obj/item/weapon/polearm/spear/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/weapon/polearm/spear/abyssor
	name = "depthseeker"
	desc = "An instrument of Abyssor's wrath to punish the ignorant."
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "gsspear"
	force_wielded = DAMAGE_SPEAR_WIELD+2
	throwforce = DAMAGE_SPEAR_WIELD

/obj/item/weapon/polearm/spear/assegai
	name = "iron assegai"
	desc = "A long spear originating from the southern regions of Lakkari. Lakkarian women in the city of Sekket are taught to use assegai so they can defend themselves against Zalad bandits."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "assegai_iron"
	gripsprite = FALSE
	possible_item_intents = list(SPEAR_THRUST, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, POLEARM_BASH)
	force_wielded = DAMAGE_SPEAR_WIELD
	throwforce = DAMAGE_SPEAR_WIELD

/obj/item/weapon/polearm/spear/steel/assegai
	name = "steel assegai"
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "assegai_steel"
	force_wielded = DAMAGE_SPEAR_WIELD + 2

//................ Psydonian Spear ............... //
/obj/item/weapon/polearm/spear/psydon
	name = "psydonian spear"
	desc = "A polearm with a twisting trident head perfect for mangling the bodies of the impure."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psyspear"
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR_WIELD
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	melting_material = /datum/material/silver
	max_integrity = INTEGRITY_STRONG
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	sellprice = 60

/obj/item/weapon/polearm/spear/psydon/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/polearm/spear/psydon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


//................ Billhook ............... //
/obj/item/weapon/polearm/spear/billhook
	name = "billhook"
	desc = "A polearm with a curved krag, a Valorian design for dismounting mounted warriors and to strike down monstrous beasts."
	icon_state = "billhook"
	possible_item_intents = list(POLEARM_THRUST, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, /datum/intent/polearm/chop, POLEARM_BASH)
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	max_blade_int = 100
	melting_material = /datum/material/steel
	melt_amount = 75
	max_integrity = INTEGRITY_STRONG
	wdefense = ULTMATE_PARRY
	wbalance = EASY_TO_DODGE
	sellprice = 60

/obj/item/weapon/polearm/spear/billhook/ji
	name = "steel dagger-ax"
	desc = "An eastern polearm of ancient design. It's rarely seen on the battlefield these daes."
	icon_state = "ji_steel"
	wdefense = GOOD_PARRY
	wbalance = null
	gripsprite = FALSE

/obj/item/weapon/polearm/spear/billhook/ji/iron
	name = "iron dagger-ax"
	icon_state = "ji_iron"
	melting_material = /datum/material/iron
	melt_amount = 75
	max_integrity = INTEGRITY_STANDARD

//................ Stone Short Spear ............... //		- Short spears got shorter reach and worse wield effect, made for one handed and throwing
/obj/item/weapon/polearm/spear/stone
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR+2
	throwforce = DAMAGE_SPEAR
	name = "simple spear"
	desc = "With this weapon, the tribes of humenity became the chosen people of Psydon."
	icon_state = "stonespear"
	minstr = 6
	max_blade_int = 50
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	dropshrink = 0.7
	wlength = WLENGTH_LONG
	wdefense = AVERAGE_PARRY
	max_integrity = INTEGRITY_WORST
	sellprice = 5

//................ Javelin ............... //
/obj/item/weapon/polearm/spear/stone/copper
	throwforce = DAMAGE_SPEAR_WIELD
	name = "javelin"
	desc = "Made for throwing, long out of favor and using inferior metals, it still can kill when the aim is true."
	icon_state = "cspear"
	max_blade_int = 70
	max_integrity = INTEGRITY_POOR
	minstr = 7
	melting_material = null
	melt_amount = 75
	dropshrink = 0.9
	sellprice = 15
	throw_speed = 3
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 0, "embedded_ignore_throwspeed_threshold" = 1)

/obj/item/weapon/polearm/spear/stone/copper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


//................ Halberd ............... //
/obj/item/weapon/polearm/halberd
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_HALBERD_WIELD
	slowdown = 1
	possible_item_intents = list(POLEARM_THRUST, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, /datum/intent/polearm/chop, POLEARM_BASH)
	name = "halberd"
	desc = "A reinforced polearm for clobbering ordained with a crested ax head, pick and sharp point, a royal arm for defence and aggression."
	icon_state = "halberd"
	slot_flags = ITEM_SLOT_BACK
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	melting_material = /datum/material/steel
	melt_amount = 150
	dropshrink = 0.8
	wdefense = ULTMATE_PARRY
	wbalance = EASY_TO_DODGE
	sellprice = 90

/obj/item/weapon/polearm/halberd/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//originally in the axes.dm file, moved here because they inherit from the bardiche
//................ Woodcutter Axe ............... //
/obj/item/weapon/polearm/halberd/bardiche/woodcutter
	name = "woodcutter axe"
	desc = "The tool, weapon, and loyal companion of woodcutters. Able to chop mighty trees and repel the threats of the forest."
	icon = 'icons/roguetown/weapons/64/axes.dmi'
	icon_state = "woodcutter"
	slot_flags = ITEM_SLOT_BACK
	bigboy = TRUE
	force = DAMAGE_AXE
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron
	melt_amount = 75
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop/great)
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	associated_skill = /datum/skill/combat/axesmaces //It's ultimately a massive axe
	wdefense = AVERAGE_PARRY
	dropshrink = 0.95
	minstr = 8
	axe_cut = 15
	sellprice = 20

/obj/item/weapon/woodchopper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//................ War Axe ............... //
//attempting to fix transformation issues//it worked wohoo, don't touch it.
/obj/item/weapon/polearm/halberd/bardiche/warcutter
	name = "footman war axe"
	desc = "An enormous spiked axe. The ideal choice for a militiaman wanting to cut a fancy noble whoreson down to size."
	icon = 'icons/roguetown/weapons/64/axes.dmi'
	icon_state = "warcutter"
	slot_flags = ITEM_SLOT_BACK
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	bigboy = TRUE
	melting_material = /datum/material/iron
	melt_amount = 150
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop/great, /datum/intent/axe/thrust, /datum/intent/pick)
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	associated_skill = /datum/skill/combat/axesmaces
	dropshrink = 0.95
	minstr = 10
	wdefense = 3
	axe_cut = 15
	sellprice = 20

/obj/item/weapon/polearm/halberd/bardiche/warcutter/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -2,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//................ Psydonian Halberd ............... //
/obj/item/weapon/polearm/halberd/psydon
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_HALBERD_WIELD
	name = "psydonian halberd"
	desc = "A mighty halberd capable of cutting down the heretical with remarkable ease, be it effigy, man, or beast."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psyhalberd"
	melting_material = /datum/material/silver
	melt_amount = 150
	swingsound = BLADEWOOSH_MED
	max_blade_int = 250
	max_integrity = INTEGRITY_STRONG
	minstr = 11
	axe_cut = 10
	sellprice = 100

/obj/item/weapon/polearm/halberd/psydon/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/polearm/halberd/psydon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/polearm/halberd/psydon/relic
	name = "Sanctum"
	desc = "These silver-tipped polearms are the bulwark of the Ordo Venatari, borrowing techniques from the Ordo Benetarus. During the early sieges, the Ordos used these to hold the horrors at bay for forty days-and-nites. A time always comes to fight - strike true."
	icon_state = "psyhalberd"

//................ Bardiche ............... //
/obj/item/weapon/polearm/halberd/bardiche
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop/great, /datum/intent/axe/thrust)
	name = "bardiche"
	desc = "A grand axe of northernly design, renowned for easily chopping off limbs clean with brutal strength."
	icon_state = "bardiche"
	melting_material = /datum/material/iron
	melt_amount = 140
	swingsound = BLADEWOOSH_MED
	wbalance = VERY_EASY_TO_DODGE
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	dropshrink = 0.95
	minstr = 10
	wdefense = AVERAGE_PARRY
	axe_cut = 10
	sellprice = 30

/obj/item/weapon/polearm/halberd/bardiche/dendor
	name = "summer scythe"
	desc = "Summer's verdancy runs through the head of this scythe. All the more to sow."
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "dendorscythe"
	gripped_intents = list(POLEARM_THRUST, /datum/intent/spear/cut/bardiche/scythe, /datum/intent/axe/chop/scythe, POLEARM_BASH)

//................ Eagle Beak ............... //
/obj/item/weapon/polearm/eaglebeak
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR_WIELD
	slowdown = 1
	possible_item_intents = list(POLEARM_BASH, /datum/intent/polearm/chop) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_BASH, POLEARM_THRUST, /datum/intent/mace/smash/heavy, /datum/intent/mace/warhammer/impale)
	name = "eagle's beak"
	desc = "A reinforced pole affixed with an ornate steel eagle's head, of which it's beak is intended to pierce with great harm."
	icon_state = "eaglebeak"
	slot_flags = ITEM_SLOT_BACK
	minstr = 11
	melting_material = /datum/material/steel
	melt_amount = 150
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	dropshrink = 0.8
	wbalance = EASY_TO_DODGE
	sellprice = 60

/obj/item/weapon/polearm/eaglebeak/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -8,"sy" = 6,"nx" = 8,"ny" = 6,"wx" = -5,"wy" = 6,"ex" = 0,"ey" = 6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -32,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -2,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//................ Lucerne Hammer ............... //
/obj/item/weapon/polearm/eaglebeak/lucerne
	name = "lucerne"
	desc = "A polehammer of simple iron, fracture bone and dissent with simple brute force."
	icon_state = "polehammer"
	melting_material = /datum/material/iron
	melt_amount = 150
	max_integrity = INTEGRITY_STRONG
	sellprice = 40
	wbalance = VERY_EASY_TO_DODGE
	wdefense = AVERAGE_PARRY

//................ Hoplite Spear ............... //
/obj/item/weapon/polearm/spear/hoplite
	force = DAMAGE_SPEARPLUS
	name = "ancient spear"
	desc = "A humble spear with a bronze head, a rare survivor from the battles long past that nearly destroyed Psydonia."
	icon_state = "bronzespear"
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/bronze
	melt_amount = 75
	sellprice = 120 // A noble collector would love to get his/her hands on one of these spears

/obj/item/weapon/polearm/spear/hoplite/winged // Winged version has +1 weapon defence and sells for a bit more, but is identical otherwise
	name = "ancient winged spear"
	desc = "A spear with a winged bronze head, a rare survivor from the battles long past that nearly destroyed Psydonia."
	icon_state = "bronzespear_winged"
	wdefense = ULTMATE_PARRY
	sellprice = 150 // A noble collector would love to get his/her hands on one of these spears

/obj/item/weapon/polearm/spear/hoplite/abyssal
	name = "Abyssal spear"
	desc = "A spear with a toothed end, inspired after the teeth of an abyssal monstrosity"
	icon = 'icons/roguetown/weapons/64/ancient.dmi'
	icon_state = "ancient_spear"
	wdefense = ULTMATE_PARRY
	sellprice = 40

/obj/item/weapon/polearm/spear/bronze
	name = "Bronze Spear"
	desc = "A spear forged of bronze. Expensive but more durable than a regular iron one."
	icon_state = "bronzespear"
	max_blade_int = 200
	melting_material = /datum/material/bronze
	melt_amount = 75
	force = 20
	force_wielded = 25


//scythe
/obj/item/weapon/sickle/scythe
	name = "scythe"
	desc = "A humble farming tool with long reach, traditionally used to cut grass or wheat."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "scythe"
	force = 10
	force_wielded = 20
	possible_item_intents = list(SPEAR_CUT) //truly just a long knife
	gripped_intents = list(SPEAR_CUT)
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	max_blade_int = 100
	max_integrity = 300
	minstr = 5
	melting_material = /datum/material/iron
	melt_amount = 75
	associated_skill = /datum/skill/combat/polearms
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	dropshrink = 0.75
	blade_dulling = DULLING_BASHCHOP
	wdefense = 2
	thrown_bclass = BCLASS_CUT
	throwforce = 25
	sellprice = 10

/obj/item/weapon/sickle/scythe/Initialize()
	. = ..()
	AddComponent(/datum/component/walking_stick)

/obj/item/weapon/polearm/spear/bonespear
	force = 18
	force_wielded = 22
	name = "bone spear"
	desc = "A spear made of bones."
	// icon_state = "bonespear"
	icon_state = "stonespear_sk"
	//SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 6
	max_blade_int = 70
	melting_material = null
	associated_skill = /datum/skill/combat/polearms
	blade_dulling = DULLING_BASHCHOP
	wdefense = 4
	max_integrity = 60
	throwforce = 20

/datum/intent/spear/cut/naginata
	damfactor = 1.2
	chargetime = 0

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

/obj/item/weapon/spear/naginata
	name = "Naginata"
	desc = "A traditional Kazengunese polearm, combining the reach of a spear with the cutting power of a curved blade. Due to the brittle quality of Kazengunese bladesmithing, weaponsmiths have adapted its blade to be easily replaceable when broken by a peg upon the end of the shaft."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "naginata"
	force = 16
	force_wielded = 30
	possible_item_intents = list(/datum/intent/spear/cut/naginata, /datum/intent/spear/bash) // no stab for you little chuddy, it's a slashing weapon
	gripped_intents = list(/datum/intent/rend/reach, /datum/intent/spear/cut/naginata, /datum/intent/spear/bash)
	minstr = 7
	max_blade_int = 50 //Nippon suteeru (dogshit)
	wdefense = 5
	throwforce = 12	//Not a throwing weapon.
	blade_dulling = DULLING_BASHCHOP

/obj/item/weapon/spear/naginata/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/datum/intent/spear/bash/ranged
	reach = 2

/datum/intent/mace/smash/wood/ranged
	reach = 2

/obj/item/weapon/polearm/woodstaff/naledi
	name = "psydonian warstaff"
	desc = "A staff carrying the black and gold insignia of the war scholars."
	icon_state = "naledistaff"
	possible_item_intents = list(/datum/intent/spear/bash)
	gripped_intents = list(/datum/intent/spear/bash/ranged,/datum/intent/mace/smash/wood/ranged)
	force = 18
	force_wielded = 22
	max_integrity = 250

/obj/item/weapon/polearm/woodstaff/naledi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
