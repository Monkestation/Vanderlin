/* AXES - Ok damage, kinda bad parry, ok AP for chops
==========================================================*/

/obj/item/weapon/axe
	icon = 'icons/roguetown/weapons/32/axes_picks.dmi'
	item_state = "axe"
	parrysound = "parrywood"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_AXE_WIELD
	wdefense = AVERAGE_PARRY
	possible_item_intents = list(AXE_CUT, AXE_CHOP)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	wlength = WLENGTH_NORMAL

	parrysound = "parrywood"
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/attribute/skill/combat/axesmaces
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	axe_cut = 10	// bonus damage to trees
	grid_height = 64
	grid_width = 32

	weapon_special = /datum/special_intent/axe_swing
	item_weight = 1.5 KILOGRAMS

//................ Stone Axe ............... //
/obj/item/weapon/axe/stone
	name = "stone axe"
	desc = "Hewn wood, steadfast thread, a chipped stone. A recipe to bend nature to your will."
	icon_state = "stoneaxe"
	force = DAMAGE_BAD_AXE
	force_wielded = DAMAGE_BAD_AXE_WIELD
	wdefense = BAD_PARRY
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(AXE_CUT)
	gripped_intents = list(AXE_CHOP)
	wlength = WLENGTH_SHORT
	max_blade_int = 50
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_IMPROV

	smeltresult = /obj/item/fertilizer/ash //is a wooden log and a stone hammered in the top
	sellprice = 10
	item_weight = 800 GRAMS

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
	desc = "A masterfully constructed axe, with additional weights in the form of ornate spikes and practical edges."
	icon_state = "battleaxe"
	force = DAMAGE_AXE + 3
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	max_blade_int = 300
	max_integrity = INTEGRITY_BATTLEAXE * INTEGRITY_MOD_STEEL

	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	smeltresult = /obj/item/ingot/steel_slag
	melting_material = /datum/material/steel
	melt_amount = 150
	sellprice = 60
	item_weight = 1.5 KILOGRAMS

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

/obj/item/weapon/axe/battle/double
	name = "double headed battle axe"
	desc = "Twice the heads for twice the carnage, excellent for cleaving the heads of your foes and the timber of the wood"
	icon_state = "battleaxedouble"
	force = DAMAGE_AXE + 5
	force_wielded = DAMAGE_HEAVYAXE_WIELD + 4
	max_blade_int = 400
	max_integrity = INTEGRITY_DBL_BATTLEAXE * INTEGRITY_MOD_STEEL
	melt_amount = 300
	sellprice = 120
	item_weight = 2.2 KILOGRAMS

//................ Iron Axe ............... //
/obj/item/weapon/axe/iron
	name = "iron axe"
	desc = "Tool, weapon, loyal iron companion."
	icon_state = "axe"
	wdefense = MEDIOCRE_PARRY
	max_blade_int = 200
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_IRON

	smeltresult = /obj/item/ingot/iron
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

	sellprice = 20
	item_weight = 1.2 KILOGRAMS

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
	item_weight = 1.2 KILOGRAMS

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
	item_weight = 2.2 KILOGRAMS
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_IRON * INTEGRITY_SPECIAL_BONUS

//................ Bronze ............... //
/obj/item/weapon/axe/bronze
	name = "bronze axe"
	desc = "Tool, weapon, loyal bronze companion."
	icon_state = "axe_bronze"
	wdefense = MEDIOCRE_PARRY
	max_blade_int = 150
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_BRONZE

	smeltresult = /obj/item/ingot/bronze
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'

	sellprice = 20
	item_weight = 1.1 KILOGRAMS

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
	max_blade_int = 240
	max_integrity = INTEGRITY_BATTLEAXE * INTEGRITY_MOD_SILVER

	resistance_flags = FIRE_PROOF //So the blessing doesn't fuck up
	smeltresult = /obj/item/ingot/silverblessed
	parrysound = "sword"
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sellprice = 60
	item_weight = 1.3 KILOGRAMS

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
	wdefense = AVERAGE_PARRY
	wlength = WLENGTH_NORMAL
	possible_item_intents = list(AXE_CUT, PICK_INTENT)
	gripped_intents = list(AXE_CUT, AXE_CHOP)
	max_blade_int = 300
	max_integrity = INTEGRITY_BATTLEAXE * INTEGRITY_MOD_STEEL

	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	associated_skill = /datum/attribute/skill/combat/axesmaces
	melting_material = /datum/material/steel
	melt_amount = 175
	sharpness = IS_SHARP
	resistance_flags = FIRE_PROOF
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	sellprice = 50
	pickmult = 1.2 // It's a pick...
	axe_cut = 15 // ...and an Axe!
	toolspeed = 2
	item_weight = 2.5 KILOGRAMS


//................ Steel Axe ............... //
/obj/item/weapon/axe/steel
	name = "steel axe"
	desc = "A bearded steel axe revered by dwarf, humen and elf alike. Performs much better than its iron counterpart."
	icon_state = "saxe"
	max_blade_int = 300
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_STEEL
	smeltresult = /obj/item/ingot/steel_slag
	resistance_flags = FIRE_PROOF
	sellprice = 35
	axe_cut = 15 // Better than iron
	item_weight = 1.2 KILOGRAMS

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

//................ Blacksteel Axe ............... //
/obj/item/weapon/axe/battle/blacksteel
	name = "blacksteel axe"
	desc = "A magnificent battle axe of blacksteel, fitted to counter both unarmored assailants and heavy infantry. The edge might be fluted with nobler alloys, but it is no less wicked when introduced to maille-and-bone."
	icon_state = "bs_axe"
	force = DAMAGE_AXE + 2
	force_wielded = DAMAGE_HEAVYAXE_WIELD + 2
	max_blade_int = 330
	max_integrity = INTEGRITY_BATTLEAXE * INTEGRITY_MOD_BLACKSTEEL
	smeltresult = null
	melting_material = /datum/material/blacksteel
	melt_amount = 200
	sellprice = 90
	item_weight = 1.2 KILOGRAMS

/obj/item/weapon/axe/battle/blacksteel/double
	name = "double headed blacksteel axe"
	desc = "A weapon with the grace of a dragon, and the power as well. The extra weight of the second head pounds the blade into the heaviest plate, leaving grievous wounds with graceful power."
	icon_state = "bs_axedouble"
	force = DAMAGE_AXE + 5
	force_wielded = DAMAGE_HEAVYAXE_WIELD + 5
	max_blade_int = 450
	max_integrity = INTEGRITY_DBL_BATTLEAXE * INTEGRITY_MOD_BLACKSTEEL
	melt_amount = 300
	sellprice = 150
	item_weight = 1.8 KILOGRAMS


//------------------ Silver Axe ---------------//
/obj/item/weapon/axe/silver
	name = "silver axe"
	desc = "A silver axe, not as strong as steel but more effective against supernatural foes."
	icon_state = "silveraxe"
	max_blade_int = 200
	max_integrity = INTEGRITY_BATTLEAXE * INTEGRITY_MOD_SILVER
	smeltresult = /obj/item/ingot/silver
	resistance_flags = FIRE_PROOF
	sellprice = 80
	axe_cut = 13
	item_weight = 1.5 KILOGRAMS

/obj/item/weapon/axe/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/axe/silver/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)

/obj/item/weapon/axe/silver/double
	name = "double headed silver axe"
	desc = "A silver axe with two cleaving heads, for sweeping thorugh the beasts of the nite"
	icon_state = "silveraxedouble"
	max_blade_int = 300
	max_integrity = INTEGRITY_DBL_BATTLEAXE * INTEGRITY_MOD_SILVER
	sellprice = 150
	axe_cut = 18
	item_weight = 2 KILOGRAMS

//.................. Bearded Axe ...............//
/obj/item/weapon/axe/steel/bearded
	name = "bearded axe"
	desc = "A large axe easily wielded in one hand or two, With a large hooked axe head to tearing into flesh and armor and ripping it away brutally."
	icon_state = "atgervi_axe"
	item_state = "atgervi_axe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	wlength = WLENGTH_LONG
	experimental_onhip = TRUE
	item_weight = 2.2 KILOGRAMS

/obj/item/weapon/axe/steel/bearded/getonmobprop(tag)
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
	sellprice = 45
	item_weight = 1.9 KILOGRAMS

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
	desc = "A simple designed handaxe, an outdated weapon from simpler times."
	icon_state = "chatchet"
	force = DAMAGE_BAD_AXE
	force_wielded = DAMAGE_BAD_AXE_WIELD
	throwforce = DAMAGE_BAD_AXE_WIELD
	wlength = WLENGTH_SHORT
	wdefense = AVERAGE_PARRY
	max_blade_int = 100
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_COPPER
	smeltresult = /obj/item/ingot/copper
	melting_material = /datum/material/copper
	melt_amount = 150
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	sellprice = 15
	item_weight = 700 GRAMS

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
	desc = "A rough axe made of bones."
	icon_state = "boneaxe"
	force = DAMAGE_BAD_AXE
	force_wielded =	DAMAGE_BAD_AXE_WIELD
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_SHORT
	anvilrepair = /datum/attribute/skill/craft/crafting
	max_blade_int = 100
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_IMPROV
	smeltresult = /obj/item/fertilizer/ash
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	item_weight = 900 GRAMS

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

/obj/item/weapon/axe/trollboneaxe
	name = "troll-horn bone axe"
	desc = "A rough axe made of bones, strengthed with an troll's horn."
	icon_state = "boneaxe"
	force = DAMAGE_BAD_AXE
	force_wielded =	DAMAGE_BAD_AXE_WIELD
	wdefense = MEDIOCRE_PARRY
	wlength = WLENGTH_SHORT
	anvilrepair = /datum/attribute/skill/craft/crafting
	max_blade_int = 150
	max_integrity = INTEGRITY_AXE * INTEGRITY_MOD_IMPROV * INTEGRITY_SPECIAL_BONUS
	smeltresult = /obj/item/fertilizer/ash
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	item_weight = 900 GRAMS

/obj/item/weapon/axe/trollboneaxe/getonmobprop(tag)
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
	desc = "An iron great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure."
	icon = 'icons/roguetown/weapons/64/axes.dmi'
	icon_state = "igreataxe"
	force = DAMAGE_AXE
	force_wielded = DAMAGE_HEAVYAXE_WIELD - 2
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_GREAT
	slowdown = 1
	possible_item_intents = list(AXE_CUT, AXE_CHOP, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(GREATAXE_CUT, GREATAXE_CHOP,  POLEARM_BASH)
	max_blade_int = 200
	max_integrity = INTEGRITY_GREATAXE * INTEGRITY_MOD_IRON

	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	anvilrepair = /datum/attribute/skill/craft/weapon_repair
	associated_skill = /datum/attribute/skill/combat/axesmaces
	slot_flags = ITEM_SLOT_BACK
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	melt_amount = 150
	sellprice = 60
	grid_height = 96
	grid_width = 64

	weapon_special = /datum/special_intent/axe_swing
	item_weight = 4 KILOGRAMS

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
	desc = "A poleaxe, fitted with a reinforced shaft and a beaked axe head of alloyed silver. As the fragility of swords has become more apparent, the Psydonic Orders have shifted their focus towards arming their paladins with longer-lasting greatweapons."
	icon = 'icons/roguetown/weapons/64/axes.dmi'
	icon_state = "silverpolearm"
	possible_item_intents = list(AXE_CUT, AXE_CHOP, MACE_STRIKE) //When possible, add the longsword's 'alternate grip' mechanic to let people flip this around into a Mace-scaling weapon with swapped damage.
	gripped_intents = list(GREATAXE_CUT, GREATAXE_CHOP, MACE_STRIKE) //Axe-equivalent to the Godendag or Grand Mace.
	max_blade_int = 240
	max_integrity = INTEGRITY_GREATAXE * INTEGRITY_MOD_SILVER
	smeltresult = /obj/item/ingot/silverblessed
	item_weight = 3.8 KILOGRAMS

/obj/item/weapon/greataxe/psy/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/greataxe/steel
	name = "steel greataxe"
	desc = "A steel great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure."
	icon_state = "sgreataxe"
	force_wielded = DAMAGE_HEAVYAXE_WIELD
	max_blade_int = 300
	max_integrity = INTEGRITY_GREATAXE * INTEGRITY_MOD_STEEL
	smeltresult = /obj/item/ingot/steel_slag
	melting_material = /datum/material/steel
	melt_amount = 150
	sellprice = 90
	item_weight = 4.5 KILOGRAMS

/obj/item/weapon/greataxe/steel/doublehead // Trades more damage for being worse to parry with and easier to dodge of.
	name = "double-headed steel greataxe"
	desc = "A steel great axe with a wicked double-bladed head. Perfect for cutting either men or trees into stumps."
	icon_state = "doublegreataxe"
	wbalance = VERY_EASY_TO_DODGE
	possible_item_intents = list(AXE_CUT, AXE_CHOP, POLEARM_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(DBLGREATAXE_CUT, DBLGREATAXE_CHOP, POLEARM_BASH)
	max_blade_int = 400
	minstr = 12
	melt_amount = 180
	sellprice = 100
	item_weight = 5.5 KILOGRAMS

/obj/item/weapon/greataxe/steel/slayer
	name = "dragonslayer axe"
	desc = "A mighty axe made of heavy, durable metal. The head alone is as big as a man, used to cleave heads from beasts and men alike."
	icon_state = "oath"
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(AXE_CUT, AXE_CHOP, POLEARM_BASH)
	gripped_intents = list(DBLGREATAXE_CUT, DBLGREATAXE_CHOP, POLEARM_BASH, GREATAXE_CLEAVE)
	max_blade_int = 400
	minstr = 13
	max_integrity = INTEGRITY_GREATAXE * INTEGRITY_MOD_STEEL * INTEGRITY_SPECIAL_BONUS
	item_weight = 12 KILOGRAMS

/obj/item/weapon/greataxe/steel/doublehead/graggar
	name = "vicious greataxe"
	desc = "A greataxe who's edge thrums with the motive force, violence, oh, sweet violence!"
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "graggargaxe"
	alt_intents = list(AXE_CUT, AXE_CHOP)
	sellprice = 0 // Graggarite axe, nobody wants this
	item_weight = 2 KILOGRAMS
	max_integrity = INTEGRITY_GREATAXE * INTEGRITY_MOD_STEEL * INTEGRITY_SPECIAL_BONUS

/obj/item/weapon/greataxe/blacksteel
	name = "blacksteel greataxe"
	desc = "A magnificent greataxe of blacksteel, tipped with spikes to keep the horrors at bay. No one's quite sure as to whether it's meant \
	to be called a 'poleaxe' or 'greataxe'; at this point, however, the terms might as well be interchangeable amongst the laymen."
	icon_state = "bs_greataxe"
	force_wielded = DAMAGE_HEAVYAXE_WIELD + 3
	max_blade_int = 300
	max_integrity = INTEGRITY_GREATAXE * INTEGRITY_MOD_BLACKSTEEL
	melting_material = /datum/material/blacksteel
	melt_amount = 150
	sellprice = 120
	item_weight = 4 KILOGRAMS

/obj/item/weapon/greataxe/blacksteel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
