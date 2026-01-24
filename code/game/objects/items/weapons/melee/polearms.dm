/* POLEARMS
==========================================================*/

/obj/item/weapon/polearm
	throwforce = DAMAGE_STAFF
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	wdefense = GREAT_PARRY
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
	melt_amount = 75 //For the ones it paths to
	associated_skill = /datum/skill/combat/polearms
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	dropshrink = 0.8
	blade_dulling = DULLING_BASHCHOP
	thrown_bclass = BCLASS_STAB
	grid_height = 96
	grid_width = 64
	sellprice = 20

/obj/item/weapon/polearm/Initialize()
	. = ..()
	AddElement(/datum/element/walking_stick)

/obj/item/weapon/polearm/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


//................ Wooden Staff ............... //
/obj/item/weapon/polearm/woodstaff
	name = "wooden staff"
	desc = "The ultimate tool of travel for weary wanderers, support your weight or crack the heads that don't support you."
	icon_state = "woodstaff"
	force =  DAMAGE_STAFF
	force_wielded =  DAMAGE_STAFF_WIELD - 1
	wdefense = ULTMATE_PARRY
	wlength = WLENGTH_LONG
	possible_item_intents = list(POLEARM_BASH)
	gripped_intents = list(POLEARM_BASH, MACE_WOODSMASH)
	max_integrity = INTEGRITY_STANDARD
	minstr = 5

	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_BLUNT
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
	name = "wooden quarterstaff"
	desc = "A staff that makes any journey easier. Durable and swift, capable of bludgeoning stray volves and ruffians alike."
	icon_state = "quarterstaff"
	force_wielded =  DAMAGE_STAFF_WIELD
	max_integrity = INTEGRITY_STRONG
	sellprice = 10

//................ Iron-shod Staff ............... //
/obj/item/weapon/polearm/woodstaff/quarterstaff/iron
	name = "iron quarterstaff"
	desc = "A perfect tool for bounty hunters who prefer their prisoners broken and bruised but not slain. This reinforced staff is capable of clubbing even an armed opponent into submission with some carefully placed strikes."
	icon_state = "quarterstaff_iron"
	gripped_intents = list(POLEARM_BASH, MACE_SMASH)
	max_integrity = INTEGRITY_STRONG
	minstr = 7

/obj/item/weapon/polearm/woodstaff/quarterstaff/steel
	name = "steel quarterstaff"
	desc = "An unusual sight, a knightly combat staff made out of worked steel and reinforced wood. It is a heavy and powerful weapon, more than capable of beating the living daylights out of any brigand."
	icon_state = "quarterstaff_steel"
	force_wielded =  DAMAGE_STAFF_WIELD + 1
	gripped_intents = list(POLEARM_BASH, MACE_SMASH)
	max_integrity = INTEGRITY_STRONGEST
	minstr = 7

//................ Staff of the Testimonium ............... //
/obj/item/weapon/polearm/woodstaff/aries
	name = "staff of the testimonium"
	desc = "A symbolic staff, granted to enlightened acolytes who have achieved and bear witnessed to the miracles of the Gods."
	icon_state = "aries"
	force_wielded =  DAMAGE_STAFF_WIELD + 1
	resistance_flags = FIRE_PROOF // Leniency for unique items
	dropshrink = 0.6
	sellprice = 100

/obj/item/weapon/polearm/woodstaff/seer
	name = "staff of the rous seer"
	desc = "A staff used by the rousman seers, mainly to protect themselves."
	icon_state = "seerstaff"
	force_wielded =  DAMAGE_STAFF_WIELD + 1
	sellprice = 100

//................ Spear ............... //
/obj/item/weapon/polearm/spear
	name = "spear"
	desc = "The humble spear, use the pointy end."
	icon_state = "spear"
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR_WIELD
	throwforce = DAMAGE_SPEAR
	possible_item_intents = list(SPEAR_THRUST, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, POLEARM_BASH)
	max_blade_int = 100

	slot_flags = ITEM_SLOT_BACK
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
	force_wielded = DAMAGE_SPEAR_WIELD + 2
	throwforce = DAMAGE_SPEAR_WIELD

/obj/item/weapon/polearm/spear/assegai
	name = "iron assegai"
	desc = "A long spear originating from the east."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "assegai_iron"
	throwforce = DAMAGE_SPEAR_WIELD
	gripsprite = FALSE

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
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	max_integrity = INTEGRITY_STRONG
	resistance_flags = FIRE_PROOF
	melting_material = /datum/material/silver
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
	wdefense = ULTMATE_PARRY
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(POLEARM_THRUST, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, POLEARM_CHOP, POLEARM_BASH)
	max_blade_int = 100
	max_integrity = INTEGRITY_STRONG
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	melting_material = /datum/material/steel
	melt_amount = 75
	sellprice = 60

/obj/item/weapon/polearm/spear/billhook/ji
	name = "steel dagger-ax"
	desc = "An eastern polearm of ancient design. It's rarely seen on the battlefield these daes."
	icon_state = "ji_steel"
	wdefense = GOOD_PARRY
	gripsprite = FALSE

/obj/item/weapon/polearm/spear/billhook/ji/iron
	name = "iron dagger-ax"
	icon_state = "ji_iron"
	max_integrity = INTEGRITY_STANDARD
	melting_material = /datum/material/iron
	melt_amount = 75

/obj/item/weapon/polearm/spear/billhook/ji/bronze
	name = "bronze dagger-ax"
	icon_state = "ji_bronze"
	max_integrity = INTEGRITY_STANDARD
	max_blade_int = 95
	melting_material = /datum/material/bronze
	melt_amount = 75

//................ Stone Short Spear ............... //		- Short spears got shorter reach and worse wield effect, made for one handed and throwing
/obj/item/weapon/polearm/spear/stone
	name = "simple spear"
	desc = "With this weapon, the tribes of humenity became the chosen people of Psydon."
	icon_state = "stonespear"
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR + 2
	throwforce = DAMAGE_SPEAR
	wdefense = AVERAGE_PARRY
	wlength = WLENGTH_LONG
	max_blade_int = 50
	max_integrity = INTEGRITY_WORST
	minstr = 6

	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	dropshrink = 0.7
	sellprice = 5

//................ Javelin ............... //
/obj/item/weapon/polearm/spear/stone/copper
	name = "javelin"
	desc = "Made for throwing, long out of favor and using inferior metals, it still can kill when the aim is true."
	icon_state = "cspear"
	throwforce = DAMAGE_SPEAR_WIELD
	max_blade_int = 70
	max_integrity = INTEGRITY_POOR
	minstr = 7
	melting_material = /datum/material/copper
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
	name = "halberd"
	desc = "A reinforced polearm for clobbering ordained with a crested ax head, pick and sharp point, a royal arm for defence and aggression."
	icon_state = "halberd"
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_HALBERD_WIELD
	wdefense = ULTMATE_PARRY
	wbalance = EASY_TO_DODGE
	slowdown = 1
	possible_item_intents = list(POLEARM_THRUST, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, POLEARM_CHOP, POLEARM_BASH)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST

	slot_flags = ITEM_SLOT_BACK
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	dropshrink = 0.8
	melting_material = /datum/material/steel
	melt_amount = 150
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
	force = DAMAGE_AXE
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	gripped_intents = list(AXE_CUT, AXE_GRTCHOP)
	minstr = 8

	bigboy = TRUE
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	associated_skill = /datum/skill/combat/axesmaces //It's ultimately a massive axe
	dropshrink = 0.95
	axe_cut = 15
	melting_material = /datum/material/iron
	melt_amount = 75
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
	wdefense = GOOD_PARRY
	gripped_intents = list(AXE_CUT, AXE_GRTCHOP, AXE_THRUST, PICK_INTENT)
	minstr = 10

	bigboy = TRUE
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	associated_skill = /datum/skill/combat/axesmaces
	dropshrink = 0.95
	axe_cut = 15
	melting_material = /datum/material/iron
	melt_amount = 150
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
	name = "psydonian halberd"
	desc = "A mighty halberd capable of cutting down the heretical with remarkable ease, be it effigy, man, or beast."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psyhalberd"
	swingsound = BLADEWOOSH_MED
	max_blade_int = 250
	max_integrity = INTEGRITY_STRONG
	minstr = 8 //So inspector can use their weapon as old, plus normal halberds are 8.
	axe_cut = 10
	resistance_flags = FIRE_PROOF
	melting_material = /datum/material/silver
	melt_amount = 150
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
	name = "bardiche"
	desc = "A grand axe of northernly design, renowned for easily chopping off limbs clean with brutal strength."
	icon_state = "bardiche"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	wdefense = AVERAGE_PARRY
	wbalance = VERY_EASY_TO_DODGE
	possible_item_intents = list(AXE_CUT)
	gripped_intents = list(AXE_CUT, AXE_GRTCHOP, AXE_THRUST)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	minstr = 11

	swingsound = BLADEWOOSH_MED
	dropshrink = 0.95
	axe_cut = 10
	melting_material = /datum/material/iron
	melt_amount = 140
	sellprice = 30

/obj/item/weapon/polearm/halberd/bardiche/ancient
	name = "bardiche"
	desc = "A grand axe of northern design, renowned for easily chopping off limbs clean with brutal strength."
	icon_state = "ancient_bardiche"

/obj/item/weapon/polearm/halberd/bardiche/dendor
	name = "summer scythe"
	desc = "Summer's verdancy runs through the head of this scythe. All the more to sow."
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "dendorscythe"
	gripped_intents = list(POLEARM_THRUST, SCYTHE_CUT, SCYTHE_CHOP, POLEARM_BASH)

//................ Eagle Beak ............... //
/obj/item/weapon/polearm/eaglebeak
	name = "eagle's beak"
	desc = "A reinforced pole affixed with an ornate steel eagle's head, of which it's beak is intended to pierce with great harm."
	icon_state = "eaglebeak"
	force = DAMAGE_SPEAR
	force_wielded = DAMAGE_SPEAR_WIELD
	wbalance = EASY_TO_DODGE
	slowdown = 1
	possible_item_intents = list(POLEARM_BASH, POLEARM_CHOP) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(POLEARM_BASH, POLEARM_THRUST, MACE_HVYSMASH, WARHM_IMPALE)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	minstr = 11

	slot_flags = ITEM_SLOT_BACK
	dropshrink = 0.8
	melting_material = /datum/material/steel
	melt_amount = 150
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
	wbalance = VERY_EASY_TO_DODGE
	wdefense = AVERAGE_PARRY
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron
	melt_amount = 150
	sellprice = 40

//................ Hoplite Spear ............... //
/obj/item/weapon/polearm/spear/hoplite
	name = "ancient spear"
	desc = "A humble spear with a bronze head, a rare survivor from the battles long past that nearly destroyed Psydonia."
	icon_state = "bronzespear"
	force = DAMAGE_SPEARPLUS
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
	force = DAMAGE_SPEARPLUS + 2
	max_blade_int = 200
	melting_material = /datum/material/bronze
	melt_amount = 75


//scythe
/obj/item/weapon/sickle/scythe
	name = "scythe"
	desc = "A humble farming tool with long reach, traditionally used to cut grass or wheat."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "scythe"
	force = DAMAGE_STAFF
	force_wielded = DAMAGE_SPEARPLUS + 2
	throwforce = DAMAGE_SPEAR_WIELD
	wdefense = AVERAGE_PARRY
	wlength = WLENGTH_GREAT
	possible_item_intents = list(SPEAR_CUT) //truly just a long knife
	gripped_intents = list(SPEAR_CUT)
	max_blade_int = 100
	max_integrity = INTEGRITY_STRONG
	minstr = 5

	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	associated_skill = /datum/skill/combat/polearms
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	dropshrink = 0.75
	blade_dulling = DULLING_BASHCHOP
	melting_material = /datum/material/iron
	melt_amount = 75
	sellprice = 10

/obj/item/weapon/sickle/scythe/Initialize()
	. = ..()
	AddElement(/datum/element/walking_stick)

/obj/item/weapon/polearm/spear/bonespear
	name = "bone spear"
	desc = "A spear made of bones."
	// icon_state = "bonespear"
	icon_state = "stonespear_sk"
	force = DAMAGE_SPEARPLUS
	force_wielded = DAMAGE_SPEAR_WIELD - 3
	throwforce = DAMAGE_SPEARPLUS + 2
	max_blade_int = 70
	max_integrity = INTEGRITY_WORST - 40
	minstr = 6

	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	melting_material = null
	blade_dulling = DULLING_BASHCHOP

/obj/item/weapon/spear/naginata
	name = "Naginata"
	desc = "A traditional eastern polearm, combining the reach of a spear with the cutting power of a curved blade. Due to the brittle quality of certain eastern bladesmithing, weaponsmiths have adapted its blade to be easily replaceable when broken by a peg upon the end of the shaft."
	icon = 'icons/roguetown/weapons/64/polearms.dmi'
	icon_state = "naginata"
	force = DAMAGE_SPEAR + 1
	force_wielded = DAMAGE_SPEAR_WIELD + 5
	throwforce = DAMAGE_SPEAR - 3
	wdefense = ULTMATE_PARRY
	possible_item_intents = list(NAGI_CUT, POLEARM_BASH) // no stab for you little chuddy, it's a slashing weapon
	gripped_intents = list(NAGI_REND, NAGI_CUT, POLEARM_BASH)
	max_blade_int = 50 //Nippon suteeru (dogshit)
	minstr = 7
	blade_dulling = DULLING_BASHCHOP

/obj/item/weapon/spear/naginata/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/weapon/polearm/woodstaff/naledi
	name = "psydonian warstaff"
	desc = "A staff carrying the black and gold insignia of the war scholars."
	icon_state = "naledistaff"
	force = DAMAGE_SPEARPLUS
	force_wielded = DAMAGE_SPEAR_WIELD - 3
	possible_item_intents = list(POLEARM_BASH)
	gripped_intents = list(POLEARM_BASHRNG, MACE_WDRANGE)
	max_integrity = INTEGRITY_STANDARD + 50

/obj/item/weapon/polearm/woodstaff/naledi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
