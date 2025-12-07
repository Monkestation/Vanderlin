/* WHIPS
==========================================================*/

/obj/item/weapon/whip
	force = DAMAGE_WHIP
	possible_item_intents = list(/datum/intent/whip/crack, /datum/intent/whip/lash)
	name = "whip"
	desc = "A leather whip, intertwining rope, leather and a fanged tip to inflict enormous pain. Favored by slavers and beast-tamers."
	icon_state = "whip"
	icon = 'icons/roguetown/weapons/32/whips_flails.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/combat/whipsflails
	anvilrepair = /datum/skill/craft/tanning
	resistance_flags = FLAMMABLE // Fully made of leather
	smeltresult = /obj/item/fertilizer/ash
	can_parry = FALSE
	swingsound = WHIPWOOSH
	throwforce = 5
	wdefense = 0
	minstr = 4
	sellprice = 30
	grid_width = 32
	grid_height = 64

/obj/item/weapon/whip/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/*------------\
| Lash intent |
\------------*/
/datum/intent/whip/lash
	name = "lash"
	blade_class = BCLASS_LASHING
	attack_verb = list("lashes", "whips")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 5
	recovery = 5
	penfactor = 5
	reach = 2
	misscost = 7
	icon_state = "inlash"
	canparry = FALSE //Has reach and can't be parried, but needs to be charged and punishes misses.
	item_damage_type = "slash"

/datum/intent/whip/cut
	name = "cut"
	blade_class = BCLASS_CUT
	attack_verb = list("slashes", "lacerates")
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	chargetime = 5
	recovery = 5
	penfactor = 5
	reach = 2
	misscost = 7
	icon_state = "incut"
	canparry = FALSE
	item_damage_type = "slash"

/*-------------\
| Crack intent |
\-------------*/
/datum/intent/whip/crack
	name = "crack"
	blade_class = BCLASS_BLUNT
	attack_verb = list("cracks", "strikes") //something something dwarf fotresss
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 5
	penfactor = 10
	reach = 1
	icon_state = "incrack"
	canparry = TRUE
	item_damage_type = "slash"

//................ Repenta En ............... //
/obj/item/weapon/whip/antique
	force = DAMAGE_WHIP+4
	name = "Repenta En"
	desc = "An extremely well maintained whip, with a polished steel tip and gilded handle"
	minstr = 7
	icon_state = "gwhip"
	resistance_flags = FIRE_PROOF
	melt_amount = 75
	melting_material = /datum/material/steel
	sellprice = 50

//................ Silver Whip ............... //
/obj/item/weapon/whip/silver
	name = "silver whip"
	desc = "A whip with a silver handle, core and tip. It has been modified for inflicting burning pain on Nitebeasts."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psywhip_lesser"
	resistance_flags = FIRE_PROOF
	smeltresult = /obj/item/ingot/silver
	last_used = 0

/obj/item/weapon/whip/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

//................ Psydon Whip ............... //
/obj/item/weapon/whip/psydon
	name = "psydonian whip"
	desc = "A whip fashioned with the iconography of Psydon, and crafted entirely out of silver."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psywhip"
	force = DAMAGE_WHIP+2
	resistance_flags = FIRE_PROOF
	smeltresult = /obj/item/ingot/silver
	last_used = 0

/obj/item/weapon/whip/psydon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/whip/psydon/relic
	name = "Daybreak"
	desc = "Holding this blessed silver evokes memories of the grand cathedrals, testaments to humanity’s faith. There, upon the ceiling, was painted a scene-most-beautiful: of Psydon, robed, in battle against the archdevils. Bring daelight to the faithful."

/obj/item/weapon/whip/psydon/relic/Initialize(mapload)
	. = ..()					// Pre-blessed, +5 force, +100 INT, +2 Def, Silver.
	AddComponent(/datum/component/psyblessed, TRUE, 5, FALSE, 100, 2, TRUE)

//................ Caning Stick.................//
/obj/item/weapon/whip/cane
	name = "caning stick"
	desc = "A thin cane meant for striking others as punishment."
	icon = 'icons/roguetown/weapons/32/special.dmi'
	icon_state = "canestick"
	possible_item_intents = list(/datum/intent/whip/lash/cane)
	force = DAMAGE_WHIP / 2
	wlength = WLENGTH_NORMAL
	max_integrity = 4 // Striking unarmoured parts doesn't take integrity, four hits to anything with an armor value will break it.
	sellprice = 0

/obj/item/weapon/whip/cane/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -6,
					"sy" = -6,
					"nx" = 6,
					"ny" = -5,
					"wx" = -1,
					"wy" = -5,
					"ex" = -1,
					"ey" = -5,
					"nturn" = -45,
					"sturn" = -45,
					"wturn" = -45,
					"eturn" = -45,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = FALSE,
					"southabove" = TRUE,
					"eastabove" = TRUE,
					"westabove" = FALSE
				)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/whip/lash/cane
	attack_verb = list("lashes", "canes")
	chargetime = 20
	no_early_release = TRUE
	penfactor = 0
	reach = 1 //no added range
	misscost = 10
	icon_state = "inlash"
	canparry = TRUE //Not meant for fighting with
	item_damage_type = "slash"

//................ Lashkiss Whip ............... //
/obj/item/weapon/whip/spiderwhip
	force = DAMAGE_WHIP+3
	name = "lashkiss whip"
	desc = "A dark whip with segmented, ashen spines for a base. Claimed to be hewn from dendrified prisoners of terror."
	icon = 'icons/roguetown/weapons/32/elven.dmi'
	icon_state = "spiderwhip"
	minstr = 6

//................ Chain Whip ............... //
/obj/item/weapon/whip/chain
	force = DAMAGE_WHIP+3
	possible_item_intents = list(/datum/intent/whip/crack/metal, /datum/intent/whip/lash/metal)
	name = "chain whip"
	desc = "An iron chain, fixed to a leather grip. Its incredibly heavy, and unwieldy. You'll likely hurt yourself more than anyone else with this."
	icon_state = "whip_chain"
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	smeltresult = /obj/item/ingot/iron
	anvilrepair = /datum/skill/craft/weaponsmithing
	minstr = 9
	melt_amount = 75

/datum/intent/whip/lash/metal
	chargetime = 10
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	recovery = 5
	penfactor = 15

/datum/intent/whip/crack/metal
	penfactor = 20

//................ Xylix Whip ............... //
/obj/item/weapon/whip/xylix
	name = "cackle lash"
	force = DAMAGE_WHIP+4
	desc = "The chimes of this whip are said to sound as the trickster's laughter itself."
	icon = 'icons/roguetown/weapons/32/patron.dmi'
	icon_state = "xylixwhip"
	anvilrepair = /datum/skill/craft/weaponsmithing
/obj/item/weapon/whip/nagaika
	name = "nagaika whip"
	desc = "A short but heavy leather whip, sporting a blunt reinforced tip and a longer handle."
	icon_state = "nagaika"
	force = 25		//Same as a cudgel/sword for intent purposes. Basically a 2 range cudgel while one-handing.
	possible_item_intents = list(/datum/intent/whip/crack/metal, /datum/intent/whip/lash, /datum/intent/sword/strike)
	wdefense = BAD_PARRY	//Akin to a cudgel, still terrible at parrying though. Better than nothing I guess; thing is used irl as a counter-weapon to knives.

//................ Urumi ............... //

/obj/item/weapon/whip/urumi
	name = "steel urumi"
	desc = "A long, flexible whip-like sword originally developed by the Savannah Elves. While an effective weapon, it requires more maintenance compared to other swords."
	icon_state = "urumi_steel"
	force = DAMAGE_WHIP+3
	possible_item_intents = list(/datum/intent/whip/crack/metal, /datum/intent/whip/lash, /datum/intent/whip/cut,)
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	resistance_flags = FIRE_PROOF
	minstr = 5
	sharpness = IS_SHARP
	max_blade_int = 175
	max_integrity = INTEGRITY_STANDARD
	blade_dulling = DULLING_BASH
	wdefense = BAD_PARRY // Parrying with a whip sword is inherently badass, plus its a small benefit for it since its supposed to have less durability.
	can_parry = TRUE

/obj/item/weapon/whip/urumi/iron
	name = "iron urumi"
	icon_state = "urumi_iron"
	force = DAMAGE_WHIP+2
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 150
	wdefense = BAD_PARRY
	can_parry = TRUE

/obj/item/weapon/whip/urumi/silver
	name = "silver urumi"
	icon_state = "urumi_silver"
	force = DAMAGE_WHIP+2
	smeltresult = /obj/item/ingot/silver
	max_blade_int= 130
	wdefense = BAD_PARRY
	can_parry = TRUE

/obj/item/weapon/whip/urumi/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)
