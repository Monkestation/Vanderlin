/* SWORDS
==========================================================*/

// Sword base
/obj/item/weapon/sword
	force = DAMAGE_SWORD
	force_wielded = DAMAGE_SWORD_WIELD
	throwforce = 10
	slot_flags = ITEM_SLOT_HIP
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust)
	name = "sword"
	desc = "A trustworthy blade design, the first dedicated tool of war since before the age of history."
	icon_state = "sword1"
	parrysound = "sword"
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	pickup_sound = "unsheathe_sword"
	equip_sound = 'sound/foley/dropsound/holster_sword.ogg'
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	flags_1 = CONDUCT_1
	thrown_bclass = BCLASS_CUT
	smeltresult = /obj/item/ingot/steel
	minstr = 7
	sellprice = 30
	wdefense = GREAT_PARRY

/obj/item/weapon/sword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

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
	penfactor = AP_CLUB_SMASH
	swingdelay = 1
	damfactor = 0.8
	item_damage_type = "slash"



/*-----------------\
| Onehanded Swords |
\-----------------*/

//................ Arming Sword ............... //
/obj/item/weapon/sword/arming
	name = "arming sword"
	desc = "A trustworthy blade design, the first dedicated tool of war since before the age of history."
	icon_state = "sword1"
	smeltresult = /obj/item/ingot/steel
	sellprice = 30

/obj/item/weapon/sword/arming/Initialize()
	. = ..()
	if(icon_state == "sword1")
		icon_state = "sword[rand(1,3)]"


/obj/item/weapon/sword/decorated
	icon_state = "decsword1"
	sellprice = 140

/obj/item/weapon/sword/decorated/Initialize()
	. = ..()
	if(icon_state == "decsword1")
		icon_state = "decsword[rand(1,3)]"


//................ Silver Sword ............... //
/obj/item/weapon/sword/silver
	force = DAMAGE_SWORD-1
	force_wielded = DAMAGE_SWORD_WIELD-1
	name = "silver sword"
	desc = "A simple silver sword with an edge that gleams in moonlight."
	icon_state = "sword_s"
	smeltresult = /obj/item/ingot/silver
	max_integrity = INTEGRITY_STRONG
	sellprice = 45
	last_used = 0
	is_silver = TRUE

/obj/item/weapon/sword/iron
	force = DAMAGE_SWORD-1
	force_wielded = DAMAGE_SWORD_WIELD-1
	desc = "A simple iron sword with a tested edge, sharp and true."
	icon_state = "isword"
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	wdefense = GOOD_PARRY
	smeltresult = /obj/item/ingot/iron

/obj/item/weapon/sword/short
	force = DAMAGE_SHORTSWORD
	name = "short sword"
	desc = "An iron sword of shortened design, a reduced grip for primarily single hand use."
	icon_state = "iswordshort"
	possible_item_intents = list(/datum/intent/sword/cut/short, /datum/intent/sword/thrust/short)
	gripped_intents = null
	smeltresult = /obj/item/ingot/iron
	max_integrity = INTEGRITY_STANDARD
	minstr = 4
	wdefense = GOOD_PARRY
	wbalance = HARD_TO_DODGE
	sellprice = 15



/*-------\
| Sabres |	Onehanded, slightly weaker thrust, better for parries. Think rapier but cutting focus.
\-------*/
/obj/item/weapon/sword/sabre
	name = "sabre"
	desc = "A swift sabre, favored by duelists and cut-throats alike."
	icon_state = "saber"
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/curved)
	gripped_intents = null
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	minstr = 5
	wdefense = ULTMATE_PARRY

/obj/item/weapon/sword/sabre/dec
	name = "decorated sabre"
	desc = "A saber decorated with fashionable gold accents without sacrificing its lethal practicality."
	icon_state = "decsaber"
	sellprice = 140

/obj/item/weapon/sword/sabre/stalker
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/short)
	name = "stalker sabre"
	desc = "A once elegant blade of mythril, diminishing under the suns gaze"
	icon_state = "spidersaber"

/obj/item/weapon/sword/sabre/noc
	name = "moonlight khopesh"
	icon_state = "nockhopesh"
	desc = "Glittering moonlight upon blued steel."
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/short, /datum/intent/sword/chop)
	max_integrity = 200

//................ Cutlass ............... //
/obj/item/weapon/sword/sabre/cutlass
	name = "cutlass"
	desc = "Both tool and weapon of war, favored by Abyssor cultists and sailors for seafaring battle."
	icon_state = "cutlass"
	minstr = 6
	wbalance = HARD_TO_DODGE

//................ Shalal Sabre ............... //
/obj/item/weapon/sword/sabre/shalal
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike, /datum/intent/sword/chop/long, /datum/intent/sword/thrust/long)
	icon_state = "marlin"
	name = "shalal sabre"
	desc = "A fine weapon of Zybantu origin in the style of the Shalal tribesfolk, renowned for their defiance against magic and mastery of mounted swordsmanship."
	parrysound = "rapier"
	minstr = 6
	sellprice = 80
	icon = 'icons/roguetown/weapons/64.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	bigboy = TRUE
	wlength = WLENGTH_LONG
	gripsprite = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.75

/obj/item/weapon/sword/sabre/shalal/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/weapon/sword/sabre/scythe
	force = DAMAGE_SWORD-2
	name = "scythe sword"
	desc = "A farming tool blade has been fastened to a shorter wooden handle to create an improvised weapon."
	icon_state = "scytheblade"
	wdefense = AVERAGE_PARRY


/*----------\
| Scimitars |	Normal swords with a strong cutting emphasis.
\----------*/
/obj/item/weapon/sword/scimitar
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop)
	name = "scimitar"
	desc = "A Zybantu design for swords, these curved blades are a common sight in the lands of the Ziggurat."
	icon_state = "scimitar"
	swingsound = BLADEWOOSH_LARGE
	wdefense = AVERAGE_PARRY

/obj/item/weapon/sword/scimitar/falchion
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/axe/chop)
	name = "falchion"
	desc = "Broad blade, excellent steel, a design inspired by Malum the dwarves claim."
	icon_state = "falchion_old"
	swingsound = BLADEWOOSH_HUGE
	wbalance = EASY_TO_DODGE
	sellprice = 100

/obj/item/weapon/sword/scimitar/messer
	name = "messer"
	desc = "Straight iron blade, simple cutting edge, no nonsense and a popular northern blade."
	icon_state = "imesser"
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/axe/chop)
	gripped_intents = list(/datum/intent/sword/chop, /datum/intent/sword/thrust)
	minstr = 8 // Heavy blade used by orcs
	wbalance = EASY_TO_DODGE
	sellprice = 20
	smeltresult = /obj/item/ingot/iron


/*--------\
| Rapiers |		Onehanded, slightly weaker cut, more AP thrust, harder to dodge.
\--------*/
/obj/item/weapon/sword/rapier
	name = "rapier"
	desc = "A duelist's weapon derived from western battlefield instruments, it features a tapered \
	blade with a specialized stabbing tip."
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "rapier"
	bigboy = TRUE
	possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier)
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	gripped_intents = null
	parrysound = "rapier"
	swingsound = BLADEWOOSH_SMALL
	minstr = 6
	wbalance = VERY_HARD_TO_DODGE
	pixel_y = -16
	pixel_x = -16
	dropshrink = 0.8

/obj/item/weapon/sword/rapier/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.5,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.5,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)



/obj/item/weapon/sword/rapier/dec
	icon_state = "decrapier"
	desc = "A rapier decorated with gold inlaid on its hilt. A regal weapon fit for nobility."
	sellprice = 140

//................ Lord's Rapier ............... //
/obj/item/weapon/sword/rapier/dec/lord
	force = DAMAGE_SWORD_WIELD
	name = "Lord's Rapier"
	desc = "Passed down through the ages, a weapon that once carved a kingdom out now relegated to a decorative piece."
	icon_state = "lord_rapier"
	sellprice = 200
	max_blade_int = 400

/obj/item/weapon/sword/rapier/silver
	force = DAMAGE_SWORD-2
	name = "silver rapier"
	desc = "An elegant silver rapier. Popular with lords and ladies in Valoria."
	icon_state = "rapier_s"
	smeltresult = /obj/item/ingot/silver
	max_blade_int = 240 // .8 of base steel
	max_integrity = 400 // .8 of base steel
	sellprice = 45
	last_used = 0
	is_silver = TRUE

/obj/item/weapon/sword/rapier/eora
	name = "The Heartstring"
	desc = "For when soft words cannot be spoken more, and hearts are to be pierced."
	icon_state = "eorarapier"
	max_blade_int = 200

// Hoplite Kophesh
/obj/item/weapon/sword/khopesh
	name = "ancient khopesh"
	desc = "A bronze weapon of war from the era of Apotheosis. This blade is older than a few elven generations, but has been very well-maintained and still keeps a good edge."
	force = 22 // Unique weapon from rare job, slightly more force than most one-handers
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop, /datum/intent/sword/strike)
	gripped_intents = null
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "khopesh"
	item_state = "khopesh"
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	pixel_y = -16
	pixel_x = -16
	dropshrink = 0.75
	bigboy = TRUE // WHY DOES THIS FUCKING VARIABLE CONTROL WHETHER THE BLOOD OVERLAY WORKS ON 64x64 WEAPONS
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	smeltresult = null // No bronze ingots yet
	max_blade_int = 300
	max_integrity = 300
	minstr = 10 // Even though it's technically one-handed, you gotta have some muscle to wield this thing
	wdefense = 3 // Lower than average sword defense (meant to pair with a shield)
	wbalance = -1 // Likely weighted towards the blade, for deep cuts and chops
	sellprice = 200 // A noble collector would love to get his/her hands on one of these blades



/*-----------------\
| Twohanded Swords |
\-----------------*/

//................ Long Sword ............... //
/obj/item/weapon/sword/long
	force_wielded = DAMAGE_LONGSWORD_WIELD
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "longsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	name = "longsword"
	desc = "A long hand-and-a-half blade, wielded by the virtuous and vile alike."
	swingsound = BLADEWOOSH_LARGE
	parrysound = "largeblade"
	pickup_sound = "brandish_blade"
	bigboy = TRUE
	wlength = WLENGTH_LONG
	gripsprite = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.75
	sellprice = 60

/obj/item/weapon/sword/long/death
	color = CLOTHING_SOOT_BLACK

/obj/item/weapon/sword/long/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 8,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//................ Heirloom Sword ............... //
/obj/item/weapon/sword/long/heirloom
	force = DAMAGE_SWORD-2
	force_wielded = DAMAGE_SWORD_WIELD-2
	icon_state = "heirloom"
	name = "old sword"
	desc = "An old steel sword with a heraldic green leather grip, mouldered by years of neglect."
	max_blade_int = 180 // Neglected, unused
	max_integrity = INTEGRITY_STRONG
	static_price = TRUE
	sellprice = 45 // Old and chipped


// Repurposing this unused sword for the Paladin job as a heavy counter against vampires.
/obj/item/weapon/sword/long/judgement// this sprite is a one handed sword, not a longsword.
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/strike, /datum/intent/sword/chop/long)
	icon_state = "judgement"
	name = "judgement"
	desc = "A sword with a silvered grip, a jeweled hilt and a honed blade; a design fit for nobility."
	sellprice = 363
	static_price = TRUE
	last_used = 0
	is_silver = TRUE

/obj/item/weapon/sword/long/judgement/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/weapon/sword/long/vlord // this sprite is a one handed sword, not a longsword.
	force = 18
	force_wielded = 30
	icon_state = "vlord"
	name = "Jaded Fang"
	desc = "An ancestral long blade with an ominous glow, serrated with barbs along it's edges. Stained with a strange green tint."
	sellprice = 363
	static_price = TRUE

/obj/item/weapon/sword/long/vlord/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/rider
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike, /datum/intent/sword/chop/long)
	icon_state = "tabi"
	name = "kilij scimitar"
	desc = "A curved blade of Zybantu origin meaning 'curved one'. The standard sword that saw the conquest of the Zybantine continent and peoples."
	sellprice = 80

/obj/item/weapon/sword/long/rider/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/weapon/sword/long/forgotten
	force = 16 // Damage is .9 of a steel sword
	force_wielded = 25
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/strike, /datum/intent/sword/chop/long)
	icon_state = "forgotten"
	name = "forgotten blade"
	desc = "A large silver-alloy sword made in a revisionist style, honoring Psydon. Best known as the prefered weapon of Inquisitorial Lodges."
	max_blade_int = 240 // Integrity and blade retention is .8 of a steel sword
	max_integrity = 400
	smeltresult = /obj/item/ingot/silver
	wbalance = -1
	wdefense = 4
	sellprice = 90
	last_used = 0
	is_silver = TRUE


/obj/item/weapon/sword/long/ravox
	name = "duel settler"
	desc = "The tenets of ravoxian duels are enscribed upon the blade of this sword."
	icon_state = "ravoxflamberge"
	force = DAMAGE_SWORD+2
	force_wielded = DAMAGE_SWORD_WIELD+2

//................ Psydonian Longsword ............... //
/obj/item/weapon/sword/long/psydon
	force_wielded = DAMAGE_LONGSWORD_WIELD
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/strike, /datum/intent/sword/chop/long)
	icon_state = "psysword"
	name = "psydonian longsword"
	desc = "A large silver longsword forged in the shape of a psycross."
	smeltresult = /obj/item/ingot/silver
	sellprice = 100
	last_used = 0
	is_silver = TRUE


//................ Greatsword ............... //
/obj/item/weapon/sword/long/greatsword
	force_wielded = DAMAGE_GREATSWORD_WIELD
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	name = "greatsword"
	desc = "An oversized hunk of metal designed for putting fear into men and killing beasts."
	icon_state = "gsw"
	swingsound = BLADEWOOSH_HUGE
	wlength = WLENGTH_GREAT
	slot_flags = ITEM_SLOT_BACK
	minstr = 11
	wbalance = EASY_TO_DODGE
	sellprice = 90

/obj/item/weapon/sword/long/greatsword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//................ Psydonian Greatsword ............... //
/obj/item/weapon/sword/long/greatsword/psydon
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/strike, /datum/intent/sword/chop/long)
	force_wielded = DAMAGE_LONGSWORD_WIELD
	name = "psydonian greatsword"
	desc = "A mighty silver greatsword made to strike fear into the heart of even archdevils."
	icon_state = "psygsword"
	smeltresult = /obj/item/ingot/silver
	sellprice = 150
	minstr = 11
	is_silver = TRUE

/obj/item/weapon/sword/long/greatsword/psydon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//................ Flamberge ............... //
/obj/item/weapon/sword/long/greatsword/flamberge
	name = "flamberge"
	desc = "Commonly known as a flame-bladed sword, this weapon has an undulating blade. It's wave-like form distributes force better, and is less likely to break on impact."
	icon_state = "flamberge"
	wbalance = DODGE_CHANCE_NORMAL
	sellprice = 120

/obj/item/weapon/sword/long/greatsword/zwei
	possible_item_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/thrust/zwei, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/strike, /datum/intent/sword/chop/long)
	force_wielded = DAMAGE_LONGSWORD_WIELD
	name = "zweihander"
	desc = "Sometimes known as a doppelhander or beidhander, this weapon's size is so impressive that it's handling properties are more akin to that of a polearm than a sword."
	icon_state = "steelzwei"
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 150 // Iron tier
	max_integrity = 300
	sellprice = 60

/obj/item/weapon/sword/long/greatsword/zwei/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//................ Kriegsmesser ............... //
/obj/item/weapon/sword/long/greatsword/elfgsword
	name = "elven kriegsmesser"
	desc = "A huge, curved elven blade. It's metal is of a high quality, yet still light, crafted by the greatest elven bladesmiths."
	icon_state = "kriegsmesser"
	wdefense = ULTMATE_PARRY
	minstr = 10
	sellprice = 120

/obj/item/weapon/sword/long/greatsword/elfgsword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//................ Zizo Sword ............... //
/obj/item/weapon/sword/long/greatsword/zizo
	name = "darksteel kriegsmesser"
	desc = "A dark red curved blade. Called forth from Her will, if you wield this blade you are to be feared, if you do not, you are dead."
	icon_state = "zizosword"
	wdefense = ULTMATE_PARRY
	minstr = 10
	sellprice = 0 // Super evil Zizo sword, nobody wants this

/obj/item/weapon/sword/long/greatsword/zizo/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//................ Executioners Sword ............... //
/obj/item/weapon/sword/long/exe
	possible_item_intents = list(/datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/chop)
	icon_state = "exe"
	name = "executioner's sword"
	desc = "An ancient blade of ginormous stature, with a round ended tip. The pride and joy of Vanderlin's greatest pastime, executions."
	minstr = 10
	slot_flags = ITEM_SLOT_BACK

/obj/item/weapon/sword/long/exe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/weapon/sword/long/exe/astrata
	name = "solar judge"
	desc = "This wicked executioner's blade calls for order."
	icon_state = "astratasword"
	max_integrity = 200
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)

//................ Terminus Est ............... //
/obj/item/weapon/sword/long/exe/cloth
	icon_state = "terminusest"
	name = "Terminus Est"

/obj/item/weapon/sword/long/exe/cloth/rmb_self(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(user, "clothwipe", 100, TRUE)
	SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_SCRUB)
	user.visible_message("<span class='warning'>[user] wipes [src] down with its cloth.</span>","<span class='notice'>I wipe [src] down with its cloth.</span>")
	return


// Copper Messer

/obj/item/weapon/sword/coppermesser
	force = 15 // Messers are heavy weapons, crude and STR based.
	force_wielded = 20
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "cmesser"
	item_state = "cmesser"
	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	name = "copper messer"
	desc = "A weapon of war from simpler times, its copper material is unideal but still efficient for the price."
	swingsound = BLADEWOOSH_LARGE
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	wlength = WLENGTH_LONG
	max_blade_int = 150
	max_integrity = 200
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	throwforce = 15
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.90
	smeltresult = /obj/item/ingot/copper
	wbalance = -1
	sellprice = 10

/obj/item/weapon/sword/coppermesser/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/rider/copper
	force = 10
	force_wielded = 20 // Shitty Design, Shitty materials, SHITTY WEAPON
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	icon_state = "copperfalx"
	icon = 'icons/roguetown/weapons/64.dmi'
	item_state = "copperfalx"
	name = "copper falx"
	desc = "A special 'sword' of copper, the material isn't the best but is good enough to slash and kill. "
	parrysound = "sword"
	swingsound = BLADEWOOSH_LARGE
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	bigboy = TRUE
	max_blade_int = 150 // Shitty Weapon
	max_integrity = 230//this is fair to be fair
	wlength = WLENGTH_LONG
	gripsprite = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	associated_skill = /datum/skill/combat/swords
	throwforce = 15
	thrown_bclass = BCLASS_CUT
	slot_flags = ITEM_SLOT_BACK//how the fuck you could put this thing on your hip?
	dropshrink = 0.75
	smeltresult = /obj/item/ingot/copper
	sellprice = 25//lets make the two bars worth it




/obj/item/weapon/sword/rapier/ironestoc
	name = "estoc"
	desc = "A sword possessed of a quite long and tapered blade that is intended to be thrust between the \
	gaps in an opponent's armor. The hilt is wrapped tight in black leather."
	icon_state = "estoc"
	force = 12
	force_wielded = 25
	icon = 'icons/roguetown/weapons/64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	possible_item_intents = list(
		/datum/intent/sword/chop,
		/datum/intent/sword/strike,
	)
	gripped_intents = list(
		/datum/intent/sword/thrust/estoc,
		/datum/intent/sword/lunge,
		/datum/intent/sword/chop,
		/datum/intent/sword/strike,
	)
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 300
	wdefense = GREAT_PARRY
	wbalance = DODGE_CHANCE_NORMAL

/obj/item/weapon/estoc/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -6,
					"sy" = 7,
					"nx" = 6,
					"ny" = 8,
					"wx" = 0,
					"wy" = 6,
					"ex" = -1,
					"ey" = 8,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -50,
					"sturn" = 40,
					"wturn" = 50,
					"eturn" = -50,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0,
					)
			if("wielded")
				return list(
					"shrink" = 0.6,
					"sx" = 3,
					"sy" = 5,
					"nx" = -3,
					"ny" = 5,
					"wx" = -9,
					"wy" = 4,
					"ex" = 9,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 15,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 8,
					"eflip" = 0,
					)

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


/obj/item/weapon/sword/gladius
	force = 22
	name = "Gladius"
	desc = "A bronze short sword with a slightly wider end, and no guard. Compliments a shield."
	icon_state = "gladius"
	gripped_intents = null
	smeltresult = /obj/item/ingot/bronze
	max_blade_int = 100
	max_integrity = 200
	dropshrink = 0.80
	wdefense = 2

//................ Gaffer's vanity sword ............... //

/obj/item/weapon/sword/long/replica
	name = "guild master's longsword"
	desc = ""
	force = 2
	force_wielded = 5
	throwforce = 2
	max_integrity = 240
	sellprice = 1
	smeltresult = /obj/item/ingot/tin //the truth comes out

/obj/item/weapon/sword/long/replica/death
	color = CLOTHING_SOOT_BLACK

/obj/item/weapon/sword/long/replica/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback") return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded") return list("shrink" = 0.6,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 8,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt") return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/replica/examine(mob/user)
	. = ..()
	if(is_gaffer_job(user.mind.assigned_role))
		. += "A useless vanity piece I commissioned after retiring my bow, unusable in battle, but light enough to forget its on your back"
	else
		. += "A hollow replica of the usual longsword design presumebly made for showsake, useless in real battle"
