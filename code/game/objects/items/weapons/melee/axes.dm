/* AXES - Ok damage, kinda bad parry, ok AP for chops
==========================================================*/

/obj/item/weapon/axe
	icon = 'icons/roguetown/weapons/32/axes_picks.dmi'
	item_state = "axe"
	parrysound = "parrywood"
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/axesmaces
	possible_item_intents = list(AXE_CUT)
	gripped_intents = list(AXE_CHOP)
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	wlength = WLENGTH_NORMAL

	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	axe_cut = 10	// bonus damage to trees
	melt_amount = 75
	grid_height = 64
	grid_width = 32


//................ Stone Axe ............... //
/obj/item/weapon/axe/stone
	name = "stone axe"
	desc = "Hewn wood, steadfast thread, a chipped stone. A recipe to bend nature to your will."
	icon_state = "stoneaxe"
	force = DAMAGE_BAD_AXE
	force_wielded = DAMAGE_BAD_AXE_WIELD
	wdefense = BAD_PARRY
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_SHORT
	max_blade_int = 50
	max_integrity = INTEGRITY_WORST / 2

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
	name = "battle axe"
	desc = "A masterfully constructed ax, with additional weights in the form of ornate spikes and practical edges."
	icon_state = "battleaxe"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	wdefense = AVERAGE_PARRY
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONG
	minstr = 10 //meant to be a orc weapon or barbarian weapon

	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	melting_material = /datum/material/steel
	melt_amount = 150
	sellprice = 60

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
	name = "iron axe"
	desc = "Tool, weapon, loyal iron companion."
	icon_state = "axe"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	wdefense = MEDIOCRE_PARRY
	possible_item_intents = list(AXE_CUT, AXE_CHOP)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	minstr = 6

	melting_material = /datum/material/iron
	melt_amount = 100
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

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

/obj/item/weapon/axe/iron/nsapo
	name = "iron kasuyu"
	desc = "An iron axe hailing from the fallen east. Great for felling trees and foes alike."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "nsapo_iron"
	melt_amount = 75

/obj/item/weapon/axe/iron/nsapo/getonmobprop(tag)

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
	force = DAMAGE_AXE + 3
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	wdefense = AVERAGE_PARRY
	max_blade_int = 150
	minstr = 10

//................ Bronze ............... //
/obj/item/weapon/axe/bronze
	name = "bronze axe"
	desc = "Tool, weapon, loyal bronze companion."
	icon_state = "axe_bronze"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	wdefense = MEDIOCRE_PARRY
	possible_item_intents = list(AXE_CUT, AXE_CHOP)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 150
	max_integrity = INTEGRITY_STANDARD
	minstr = 6

	melting_material = /datum/material/bronze
	melt_amount = 100
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

	sellprice = 20

/obj/item/weapon/axe/bronze/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

//................ Psydonian Axe ............... //
/obj/item/weapon/axe/psydon
	name = "psydonian axe"
	desc = "An axe forged of silver with a small psycross attached, Dendor and his foul beastmen be damned."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psyaxe"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	wdefense = MEDIOCRE_PARRY
	possible_item_intents = list(AXE_CUT, AXE_CHOP)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 200
	max_integrity = INTEGRITY_STANDARD
	minstr = 6

	resistance_flags = FIRE_PROOF //So the blessing doesn't fuck up
	melting_material = /datum/material/silver
	melt_amount = 75
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
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
	name = "pickaxe"
	desc = "An odd mix of a pickaxe front and a hatchet blade back, capable of being switched between."
	icon = 'icons/roguetown/weapons/32/axes_picks.dmi'
	icon_state = "paxe"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_NORMAL
	possible_item_intents = list(AXE_CUT, PICK_INTENT)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	minstr = 6

	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	associated_skill = /datum/skill/combat/axesmaces
	melting_material = /datum/material/steel
	melt_amount = 175
	resistance_flags = FIRE_PROOF
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
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
	wdefense = AVERAGE_PARRY
	possible_item_intents = list(AXE_CUT, AXE_CHOP)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	minstr = 6

	melting_material = /datum/material/steel
	melt_amount = 100
	resistance_flags = FIRE_PROOF
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

//.................. Bearded Axe ...............//
/obj/item/weapon/axe/steel/atgervi
	name = "bearded axe"
	desc = "A large axe easily wielded in one hand or two, With a large hooked axe head to tearing into flesh and armor and ripping it away brutally."
	icon_state = "atgervi_axe"
	item_state = "atgervi_axe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	wlength = WLENGTH_LONG
	experimental_onhip = TRUE
	max_integrity = INTEGRITY_STRONGEST * 0.8

/obj/item/weapon/axe/steel/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 2,"sy" = -8,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/weapon/axe/steel/nsapo
	name = "steel kasuyu"
	desc = "A steel axe hailing from the fallen east. Great for felling trees and foes alike."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "nsapo_steel"
	wdefense = GOOD_PARRY
	minstr = 8
	melt_amount = 75
	sellprice = 45

/obj/item/weapon/axe/steel/nsapo/getonmobprop(tag)
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
	name = "copper hatchet"
	desc = "A simple designed handaxe, an outdated weaponry from simpler times."
	icon_state = "chatchet"
	force = DAMAGE_BAD_AXE
	force_wielded = DAMAGE_BAD_AXE_WIELD
	wlength = WLENGTH_SHORT
	max_blade_int = 120
	max_integrity = INTEGRITY_WORST
	minstr = 6

	melting_material = /datum/material/copper
	melt_amount = 150
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
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_SHORT
	possible_item_intents = list(AXE_CUT, AXE_CHOP)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 100
	minstr = 8

	smeltresult = /obj/item/fertilizer/ash
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
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_GREAT
	slowdown = 1
	possible_item_intents = list(AXE_CUT, AXE_CHOP, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(GREATAXE_CUT, GREATAXE_CHOP,  POLEARM_BASH)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	minstr = 11

	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	anvilrepair = /datum/skill/craft/weaponsmithing
	associated_skill = /datum/skill/combat/axesmaces
	blade_dulling = DULLING_BASHCHOP
	slot_flags = ITEM_SLOT_BACK
	melting_material = /datum/material/iron
	melt_amount = 150
	sellprice = 60
	grid_height = 96
	grid_width = 64

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
	name = "psydonic poleaxe"
	desc = "A poleaxe, fitted with a reinforced shaft and a beaked axe head of alloyed silver. As the fragility of swords've become more apparent, the Psydonic Orders - following the disastrous Massacre of Blastenghyll - have shifted their focus towards arming their paladins with longer-lasting greatweapons."
	icon = 'icons/roguetown/weapons/64/axes.dmi'
	icon_state = "silverpolearm"
	force = DAMAGE_AXE - 5
	possible_item_intents = list(AXE_CUT, AXE_CHOP, MACE_STRIKE) //When possible, add the longsword's 'alternate grip' mechanic to let people flip this around into a Mace-scaling weapon with swapped damage.
	gripped_intents = list(GREATAXE_CUT, GREATAXE_CHOP, MACE_STRIKE) //Axe-equivalent to the Godendag or Grand Mace.
	max_blade_int = 350
	minstr = 12
	melting_material = /datum/material/silver

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
	wbalance = VERY_EASY_TO_DODGE
	possible_item_intents = list(AXE_CUT, AXE_CHOP, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(DBLGREATAXE_CUT, DBLGREATAXE_CHOP,  POLEARM_BASH)
	max_blade_int = 400
	minstr = 12

	melt_amount = 180
	sellprice = 100

/obj/item/weapon/greataxe/steel/doublehead/graggar
	name = "vicious greataxe"
	desc = "A greataxe who's edge thrums with the motive force, violence, oh, sweet violence!"
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "graggargaxe"
	alt_intents = list(AXE_CUT, AXE_CHOP)
	minstr = 11 // Just there to prevent the occasional hiccup where Graggar Iconoclast rolls under their minimum str for the axe without just outright buffing their str. It's made of blacksteel it can get away with being a little lighter.
	blade_dulling = DULLING_BASHCHOP
	sellprice = 0 // Graggarite axe, nobody wants this

/obj/item/weapon/greataxe/dreamscape
	name = "otherworldly axe"
	desc = "A strange axe, who knows where it came from. It feels cold and unusually heavy."
	icon_state = "dreamaxe"
	force = DAMAGE_AXE - 10
	force_wielded = DAMAGE_HEAVYAXE_WIELD + 5
	wdefense = ULTMATE_PARRY
	max_blade_int = 250
	minstr = 13

	melting_material = /datum/material/gold
	sellprice = 0

/obj/item/weapon/greataxe/dreamscape/active
	// to do, make this burn you if you don't regularly soak it.
	desc = "A strange axe, who knows where it came from. It is searing hot to the blade, the hilt is barely able to be held."
	icon_state = "dreamaxeactive"
	force = DAMAGE_AXE - 5
	force_wielded = DAMAGE_HEAVYAXE_WIELD + 10
	wdefense = ULTMATE_PARRY + 1
	max_blade_int = 500
	sellprice = 0

