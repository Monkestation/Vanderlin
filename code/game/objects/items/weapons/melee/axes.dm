/* AXES - Ok damage, kinda bad parry, ok AP for chops
==========================================================*/

/obj/item/weapon/axe
	icon = 'icons/roguetown/weapons/32/axes_picks.dmi'
	item_state = "axe"
	parrysound = "parrywood"
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/axesmaces
	possible_item_intents = list(/datum/intent/axe/cut)
	gripped_intents = list(/datum/intent/axe/chop)
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	wlength = WLENGTH_NORMAL
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	axe_cut = 10	// bonus damage to trees
	grid_height = 64
	grid_width = 32

/*------------\
| Chop intent |	small AP, fewer protect vs this crit (more delimb?)
\------------*/

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


/*------------\
| Cut intent |	small AP
\------------*/

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

/*--------------\
| Impale intent |	big AP
\--------------*/

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

/*---------------------\
| Great axe cut intent |	small AP
\---------------------*/

/datum/intent/axe/cut/battle/greataxe //Decent to cut as well
	reach = 2
	damfactor = 1.1
	swingdelay = 1
	misscost = 10
	item_damage_type = "slash"

/*---------------------\
| Great axe chop intent |	medium AP
\---------------------*/

/datum/intent/axe/chop/battle/greataxe //Essentially a better polearm chop, this weapon is made to chop people limbs off.
	penfactor = AP_GREATAXE_CHOP  // Same AP as the polearm CHOP
	reach = 2
	chargetime = 2
	swingdelay = 2
	no_early_release = TRUE // Needs fo fully charge
	damfactor = 1.2
	misscost = 20

/*--------------------------------\
| Doublehead Great axe cut intent |	small AP
\--------------------------------*/

/datum/intent/axe/cut/battle/greataxe/doublehead //Better to cut as well
	reach = 2
	chargetime = 1.5
	damfactor = 1.2 // More damage as well
	swingdelay = 1.5
	misscost = 15 // Heavier means more stamina loss if you miss
	item_damage_type = "slash"

/*---------------------------------\
| Doublehead Great axe chop intent |	medium AP
\---------------------------------*/

/datum/intent/axe/chop/battle/greataxe/doublehead //Stronger than the one bladed axe but heavier
	penfactor = AP_GREATAXE_CHOP
	reach = 2
	chargetime = 2.5 // Needs more time to fully charge it
	no_early_release = TRUE // Needs fo fully charge
	swingdelay = 2.5
	damfactor = 1.3 // Stronger
	misscost = 25 // Costs more if you miss

//................ Stone Axe ............... //
/obj/item/weapon/axe/stone
	force = DAMAGE_BAD_AXE
	force_wielded = DAMAGE_BAD_AXE_WIELD
	name = "stone axe"
	desc = "Hewn wood, steadfast thread, a chipped stone. A recipe to bend nature to your will."
	icon_state = "stoneaxe"
	max_blade_int = 50
	max_integrity = 50
	wdefense = BAD_PARRY

	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_SHORT
	smeltresult = /obj/item/fertilizer/ash //is a wooden log and a stone hammered in the top
	melting_material = null
	sellprice = 10

/obj/item/weapon/axe/stone/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
	return ..()


//................ Battle Axe ............... //
/obj/item/weapon/axe/battle
	force = DAMAGE_AXE
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	name = "battle axe"
	desc = "A masterfully constructed ax, with additional weights in the form of ornate spikes and practical edges."
	icon_state = "battleaxe"
	max_blade_int = 500
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	minstr = 10 //meant to be a orc weapon or barbarian weapon
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	wdefense = AVERAGE_PARRY
	sellprice = 60
	melting_material = /datum/material/steel
	melt_amount = 150

/obj/item/weapon/axe/battle/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
	return ..()


//................ Iron Axe ............... //
/obj/item/weapon/axe/iron
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	name = "iron axe"
	desc = "Tool, weapon, loyal iron companion."
	icon_state = "axe"
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron
	melt_amount = 100
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

	wdefense = MEDIOCRE_PARRY
	minstr = 6

	sellprice = 20

/obj/item/weapon/axe/iron/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

/obj/item/weapon/axe/nsapo/iron
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	name = "iron kasuyu"
	desc = "An iron axe hailing from the nation of Lakkari. Great for felling trees and foes alike."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "nsapo_iron"
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron
	melt_amount = 75
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

	wdefense = MEDIOCRE_PARRY
	minstr = 6

	sellprice = 20

/obj/item/weapon/axe/nsapo/getonmobprop(tag)

	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

/obj/item/weapon/axe/iron/troll
	name = "splitter axe"
	desc = "A crudely made axe, more reminiscent to one used for splitting logs if it was made with tree trunk and a shiny sharpened rock; which does make you think, what use does a troll have for wood?"
	icon_state = "troll_axe"
	max_blade_int = 150
	force = DAMAGE_AXE+3
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	minstr = 10
	wdefense = AVERAGE_PARRY

//................ Psydonian Axe ............... //
/obj/item/weapon/axe/psydon
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	name = "psydonian axe"
	desc = "An axe forged of silver with a small psycross attached, Dendor and his foul beastmen be damned."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psyaxe"
	max_blade_int = 200
	max_integrity = INTEGRITY_STANDARD
	melting_material = /datum/material/silver
	melt_amount = 75
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	wdefense = MEDIOCRE_PARRY
	minstr = 6
	sellprice = 60

/obj/item/weapon/axe/psydon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/axe/psydon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)


//................ Pick Axe ............... //
// Pickaxe-axe ; Technically both a tool and weapon, but it goes here due to weapon function.
// Same stats as steel axe, but refactored for pickaxe quality purposes.
/obj/item/weapon/pick/paxe
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	name = "pickaxe"
	desc = "An odd mix of a pickaxe front and a hatchet blade back, capable of being switched between."
	icon = 'icons/roguetown/weapons/32/axes_picks.dmi'
	icon_state = "paxe"
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/pick)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	wlength = WLENGTH_NORMAL
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	associated_skill = /datum/skill/combat/axesmaces
	anvilrepair = /datum/skill/craft/weaponsmithing
	melting_material = /datum/material/steel
	melt_amount = 175
	resistance_flags = FIRE_PROOF
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	wdefense = MEDIOCRE_PARRY
	minstr = 6
	sellprice = 50
	pickmult = 1.2 // It's a pick...
	axe_cut = 15 // ...and an Axe!
	toolspeed = 2


//................ Steel Axe ............... //
/obj/item/weapon/axe/steel
	name = "steel axe"
	desc = "A bearded steel axe revered by dwarf, humen and elf alike. Performs much better than its iron counterpart."
	icon_state = "saxe"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	melting_material = /datum/material/steel
	melt_amount = 100
	resistance_flags = FIRE_PROOF
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	wdefense = AVERAGE_PARRY
	minstr = 6
	sellprice = 35
	axe_cut = 15 // Better than iron

/obj/item/weapon/axe/steel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

/obj/item/weapon/axe/nsapo
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	name = "steel kasuyu"
	desc = "A steel axe hailing from the nation of Lakkari. Great for felling trees and foes alike."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "nsapo_steel"
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	melting_material = /datum/material/steel
	melt_amount = 75
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

	wdefense = GOOD_PARRY
	minstr = 8
	sellprice = 45
	axe_cut = 15

/obj/item/weapon/axe/nsapo/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)


//................ Copper Hatchet ............... //
/obj/item/weapon/axe/copper
	force = DAMAGE_BAD_AXE
	force_wielded = DAMAGE_BAD_AXE_WIELD

	name = "copper hatchet"
	desc = "A simple designed handaxe, an outdated weaponry from simpler times."
	icon_state = "chatchet"

	max_blade_int = 120
	max_integrity = INTEGRITY_WORST
	minstr = 6
	melting_material = /datum/material/copper
	melt_amount = 150
	wlength = WLENGTH_SHORT
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	sellprice = 15
/obj/item/weapon/axe/copper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

//................ Bone Axe ............... //
/obj/item/weapon/axe/boneaxe
	name = "bone axe"
	desc = "A rough axe made of bones"
	icon_state = "boneaxe"
	force = DAMAGE_AXE - 2
	force_wielded =	DAMAGE_AXE_WIELD - 3
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop)
	gripped_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop)
	smeltresult = /obj/item/fertilizer/ash
	max_blade_int = 100
	minstr = 8
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_SHORT
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'

/obj/item/weapon/axe/boneaxe/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = -7,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
	return ..()

//................ Great Axe ............... //
/obj/item/weapon/greataxe
	name = "greataxe"
	desc = "An iron great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure.."
	icon = 'icons/roguetown/weapons/64/axes.dmi'
	icon_state = "igreataxe"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_HEAVYAXE_WIELD - 5
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/spear/bash) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe,  /datum/intent/spear/bash)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 11
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/axesmaces
	blade_dulling = DULLING_BASHCHOP
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	max_integrity = INTEGRITY_STRONG
	slowdown = 1
	slot_flags = ITEM_SLOT_BACK
	melting_material = /datum/material/iron
	melt_amount = 150
	sellprice = 60

/obj/item/weapon/greataxe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/weapon/greataxe/psy
	force = 15
	force_wielded = 25
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/mace/strike) //When possible, add the longsword's 'alternate grip' mechanic to let people flip this around into a Mace-scaling weapon with swapped damage.
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, /datum/intent/mace/strike) //Axe-equivalent to the Godendag or Grand Mace.
	name = "psydonic poleaxe"
	desc = "A poleaxe, fitted with a reinforced shaft and a beaked axe head of alloyed silver. As the fragility of swords've become more apparent, the Psydonic Orders - following the disastrous Massacre of Blastenghyll - have shifted their focus towards arming their paladins with longer-lasting greatweapons."
	icon = 'icons/roguetown/weapons/64/axes.dmi'
	icon_state = "silverpolearm"
	minstr = 12
	max_blade_int = 350
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/weapon/greataxe/psy/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/greataxe/steel
	name = "steel greataxe"
	desc = "A steel great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure."
	icon_state = "sgreataxe"
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	melting_material = /datum/material/steel
	melt_amount = 150
	sellprice = 90

/obj/item/weapon/greataxe/steel/doublehead // Trades more damage for being worse to parry with and easier to dodge of.
	name = "double-headed steel greataxe"
	desc = "A steel great axe with a wicked double-bladed head. Perfect for cutting either men or trees into stumps."
	icon_state = "doublegreataxe"
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/spear/bash) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe/doublehead, /datum/intent/axe/chop/battle/greataxe/doublehead,  /datum/intent/spear/bash)
	max_blade_int = 400
	minstr = 12
	melt_amount = 180
	wbalance = VERY_EASY_TO_DODGE
	wdefense = AVERAGE_PARRY
	sellprice = 100

/obj/item/weapon/greataxe/steel/doublehead/graggar
	name = "vicious greataxe"
	desc = "A greataxe who's edge thrums with the motive force, violence, oh, sweet violence!"
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "graggargaxe"
	blade_dulling = DULLING_BASHCHOP
	sellprice = 0 // Graggarite axe, nobody wants this

/obj/item/weapon/greataxe/dreamscape
	force = 10
	force_wielded = 35
	name = "otherworldly axe"
	desc = "A strange axe, who knows where it came from. It feels cold and unusually heavy."
	icon_state = "dreamaxe"
	minstr = 13
	max_blade_int = 250
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/gold
	associated_skill = /datum/skill/combat/axesmaces
	blade_dulling = DULLING_BASHCHOP
	wdefense = 5
	sellprice = 0

/obj/item/weapon/greataxe/dreamscape/active
	// to do, make this burn you if you don't regularly soak it.
	force = 15
	force_wielded = 40
	desc = "A strange axe, who knows where it came from. It is searing hot to the blade, the hilt is barely able to be held."
	icon_state = "dreamaxeactive"
	max_blade_int = 500
	wdefense = 6
	sellprice = 0

