/* SWORDS
==========================================================*/

// Sword base
/obj/item/weapon/sword
	name = "sword"
	desc = "A trustworthy blade design, the first dedicated tool of war since before the age of history."
	icon = 'icons/roguetown/weapons/32/swords.dmi'
	icon_state = "sword1"
	parrysound = "sword"
	force = DAMAGE_SWORD
	force_wielded = DAMAGE_SWORD_WIELD
	throwforce = DAMAGE_SWORD - 10
	wdefense = GREAT_PARRY
	wlength = WLENGTH_NORMAL
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST)
	alt_intents = list(DAZE_BASH, SWORD_STRIKE, POMMEL_BASH)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONGEST
	minstr = 7

	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/swords
	pickup_sound = "unsheathe_sword"
	equip_sound = 'sound/foley/dropsound/holster_sword.ogg'
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	flags_1 = CONDUCT_1
	thrown_bclass = BCLASS_CUT
	melting_material = /datum/material/steel
	melt_amount = 75
	sellprice = 30
	grid_height = 96
	grid_width = 64

/obj/item/weapon/sword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 270,"sturn" = 90,"wturn" = 100,"eturn" = 261,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/*-----------------\
| Onehanded Swords |
\-----------------*/

/obj/item/weapon/sword/short
	name = "short sword"
	desc = "A steel sword of shortened design and a reduced grip for single hand use."
	icon_state = "swordshort"
	force = DAMAGE_SHORTSWORD
	force_wielded = 0
	wbalance = HARD_TO_DODGE
	wlength = WLENGTH_SHORT
	possible_item_intents = list(SHORT_CUT, SHORT_THRUST)
	gripped_intents = null
	max_integrity = INTEGRITY_STRONG
	minstr = 4
	w_class = WEIGHT_CLASS_NORMAL
	sellprice = 30

/obj/item/weapon/sword/short/iron
	desc = "An iron sword of shortened design and a reduced grip for single hand use."
	icon_state = "iswordshort"
	wdefense = GOOD_PARRY
	max_integrity = INTEGRITY_STANDARD
	melting_material = /datum/material/iron
	sellprice = 15

/obj/item/weapon/sword/short/bronze
	name = "bronze short sword"
	desc = "A bronze sword of shortened design and a reduced grip for single hand use."
	icon_state = "shortsword_bronze"
	wdefense = GOOD_PARRY
	max_blade_int = 85
	max_integrity = INTEGRITY_STANDARD
	melting_material = /datum/material/bronze
	sellprice = 10

/obj/item/weapon/sword/short/psy
	name = "psydonian shortsword"
	desc = "Grenzelhoftian smiths worked with artificers, and an esoteric blade was born: a blade with an unique design, dismissing a crossguard in favor of a hollow beak to hook and draw harm away from its user. Short in length, yet lethally light in weight."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psyswordshort"
	force = DAMAGE_SHORTSWORD + 3
	grid_width = 32
	grid_height = 96

/obj/item/weapon/sword/short/psy/Initialize(mapload)
	. = ..()						//+3 force, +100 blade int, +50 int, +1 def, make silver
	AddComponent(/datum/component/psyblessed, FALSE, 3, 100, 50, 1, TRUE)


//................ Arming Sword ............... //
/obj/item/weapon/sword/arming
	name = "arming sword"
	desc = "A trustworthy blade design, the first dedicated tool of war since before the age of history."
	icon_state = "sword1"
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
	name = "silver sword"
	desc = "A simple silver sword with an edge that gleams in moonlight."
	icon_state = "silversword"
	force = DAMAGE_SWORD - 1
	force_wielded = DAMAGE_SWORD_WIELD - 1
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/silver
	sellprice = 45
	last_used = 0

/obj/item/weapon/sword/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/sword/iron
	desc = "A simple iron sword with a tested edge, sharp and true."
	icon_state = "isword"
	force = DAMAGE_SWORD - 1
	force_wielded = DAMAGE_SWORD_WIELD - 1
	wdefense = GOOD_PARRY
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron

/obj/item/weapon/sword/bronze
	name = "bronze sword"
	desc = "A simple and reliable bronze sword."
	icon_state = "sword_bronze"
	force = DAMAGE_SWORD - 1
	force_wielded = DAMAGE_SWORD_WIELD - 1
	wdefense = AVERAGE_PARRY
	max_blade_int = 150
	max_integrity = INTEGRITY_STANDARD
	melting_material = /datum/material/bronze

/obj/item/weapon/sword/kaskara
	name = "steel kaskara"
	desc = "A steel sword with a small crossguard."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "kaskara_steel"
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_CHOP)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_CHOP)

/obj/item/weapon/sword/kaskara/iron
	name = "iron kaskara"
	desc = "A sword of with a small crossguard."
	icon_state = "kaskara_iron"
	force = DAMAGE_SWORD - 1
	force_wielded = DAMAGE_SWORD_WIELD - 1
	wdefense = GOOD_PARRY
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron

/obj/item/weapon/sword/short/ida
	name = "steel ida"
	desc = "A steel short sword with a leaf-shaped blade. Used to be a popular weapon in the east."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "ida_steel"
	wdefense = GOOD_PARRY
	minstr = 5
	sellprice = 50

/obj/item/weapon/sword/short/iron/ida
	name = "iron ida"
	desc = "A short sword with a leaf-shaped blade. Used to be a popular weapon in the east."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "ida_iron"
	sellprice = 20

/obj/item/weapon/sword/rapier/caneblade
	name = "cane blade"
	desc = "A steel blade with a gold handle, intended to be concealed inside of a cane. Has a focus on stabbing"
	icon = 'icons/roguetown/weapons/32/swords.dmi'
	icon_state = "caneblade"
	sellprice = 100 //Gold handle
	bigboy = FALSE
	SET_BASE_PIXEL(0, 0)

/obj/item/weapon/sword/rapier/caneblade/courtphysician
	name = "cane blade"
	desc = "A steel blade with a gold handle, intended to be concealed inside of a cane. This one bears the visage of a vulture on its pommel."
	icon = 'icons/roguetown/weapons/32/swords.dmi'
	icon_state = "doccaneblade"

/*-------\
| Sabres |	Onehanded, slightly weaker thrust, better for parries. Think rapier but cutting focus.
\-------*/
/obj/item/weapon/sword/sabre
	name = "sabre"
	desc = "A swift sabre, favored by duelists and cut-throats alike."
	icon_state = "saber"
	force_wielded = 0
	wdefense = ULTMATE_PARRY
	possible_item_intents = list(SWORD_CUT, CURVED_THRUST)
	gripped_intents = null
	minstr = 5

	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = BLADEWOOSH_SMALL

/obj/item/weapon/sword/sabre/dec
	name = "decorated sabre"
	desc = "A sabre decorated with fashionable gold accents without sacrificing its lethal practicality."
	icon_state = "decsaber"
	sellprice = 140

/obj/item/weapon/sword/sabre/stalker
	name = "stalker sabre"
	desc = "A once elegant blade of mythril, diminishing under the suns gaze"
	icon = 'icons/roguetown/weapons/32/elven.dmi'
	icon_state = "spidersaber"
	possible_item_intents = list(SWORD_CUT, SHORT_THRUST)

/obj/item/weapon/sword/sabre/noc
	name = "moonlight khopesh"
	icon = 'icons/roguetown/weapons/32/patron.dmi'
	icon_state = "nockhopesh"
	desc = "Glittering moonlight upon blued steel."
	possible_item_intents = list(SWORD_CUT, SHORT_THRUST, SWORD_CHOP)
	max_integrity = INTEGRITY_STANDARD

/obj/item/weapon/sword/sabre/noc/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

//................ Cutlass ............... //
/obj/item/weapon/sword/sabre/cutlass
	name = "cutlass"
	desc = "Both tool and weapon of war, favored by Abyssor cultists and sailors for seafaring battle."
	icon_state = "cutlass"
	wbalance = HARD_TO_DODGE
	minstr = 6

/obj/item/weapon/sword/sabre/dadao
	name = "steel dadao"
	icon_state = "dadao_steel"
	desc = "Sometimes also referred to as \"Saiga Choppers\". Dadaos are heavy eastern blades infamous for their ability to slice men in half."
	force = DAMAGE_SWORD + 1
	force_wielded = DAMAGE_SWORD_WIELD + 1
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	gripped_intents = list(AXE_CHOP, CURVED_THRUST)

/obj/item/weapon/sword/sabre/dadao/iron //Fix this
	name = "iron dadao"
	icon_state = "dadao_iron"
	melting_material = /datum/material/iron

/obj/item/weapon/sword/sabre/dadao/bronze
	name = "bronze dadao"
	icon_state = "dadao_bronze"
	melting_material = /datum/material/bronze
	max_blade_int = 95
	max_integrity = INTEGRITY_STANDARD

//................ Shalal Sabre ............... //
/obj/item/weapon/sword/sabre/shalal
	name = "shalal sabre"
	desc = "A fine weapon of Zaladin origin in the style of the Shalal tribesfolk, renowned for their defiance against magic and mastery of mounted swordsmanship."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "marlin"
	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	parrysound = "rapier"
	wlength = WLENGTH_LONG
	possible_item_intents = list(SWORD_CUT, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_STRIKE, SWDLONG_CHOP, SWDLONG_THRUST)
	minstr = 6

	bigboy = TRUE
	gripsprite = TRUE
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.
	sellprice = 80

/obj/item/weapon/sword/sabre/shalal/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 270,"sturn" = 90,"wturn" = 90,"eturn" = 261,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/weapon/sword/sabre/scythe
	name = "scythe sword"
	desc = "A farming tool blade has been fastened to a shorter wooden handle to create an improvised weapon."
	icon_state = "scytheblade"
	force = DAMAGE_SWORD - 2
	wdefense = AVERAGE_PARRY


/*----------\
| Scimitars |	Normal swords with a strong cutting emphasis.
\----------*/
/obj/item/weapon/sword/scimitar
	name = "scimitar"
	desc = "A Zaladin design for swords, these curved blades are a common sight in the lands of the Ziggurat."
	icon_state = "scimitar"
	wdefense = AVERAGE_PARRY
	possible_item_intents = list(SWORD_CUT, SWORD_CHOP)
	swingsound = BLADEWOOSH_LARGE

/obj/item/weapon/sword/scimitar/falchion
	name = "falchion"
	desc = "Broad blade, excellent steel, a design inspired by Malum the dwarves claim."
	icon_state = "falchion"
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(SWORD_CUT, AXE_CHOP)
	swingsound = BLADEWOOSH_HUGE

/obj/item/weapon/sword/scimitar/messer
	name = "messer"
	desc = "Straight iron blade, simple cutting edge, no nonsense and a popular northern blade."
	icon_state = "imesser"
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(SWORD_CUT, AXE_CHOP)
	gripped_intents = list(SWORD_CHOP, SWORD_THRUST)
	minstr = 8 // Heavy blade used by orcs
	melting_material = /datum/material/iron
	sellprice = 20

/obj/item/weapon/sword/scimitar/lakkarikhopesh/iron
	name = "iron khopesh"
	desc = "A crescent curved sword. It's popular among traveling Noccian scholars."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "khopesh_iron"
	melting_material = /datum/material/iron
	sellprice = 20

/obj/item/weapon/sword/scimitar/lakkarikhopesh
	name = "steel khopesh"
	desc = "A crescent curved sword. It's popular among traveling Noccian scholars."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "khopesh_steel"
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(SWORD_CUT, AXE_CHOP)
	gripped_intents = list(SWORD_CHOP, SWORD_THRUST)
	sellprice = 45

/obj/item/weapon/sword/scimitar/sengese/iron
	name = "iron sengese"
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "sengese_iron"
	melting_material = /datum/material/iron
	sellprice = 20

/obj/item/weapon/sword/scimitar/sengese
	name = "steel sengese"
	desc = "A curved sword made for deflecting blows. Many inexperienced swordsmen struggle to use it well due to its shape, but it's a force to be reckoned with in the hands of a master."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "sengese_steel"
	wdefense = GOOD_PARRY
	gripped_intents = list(SWORD_CUT, SWORD_CHOP, CURVED_THRUST)
	swingsound = BLADEWOOSH_SMALL
	minstr = 6
	sellprice = 45

/obj/item/weapon/sword/scimitar/sengese/bronze
	name = "bronze sengese"
	icon = 'icons/roguetown/weapons/32/swords.dmi'
	icon_state = "sengese_bronze"
	melting_material = /datum/material/bronze
	sellprice = 15

/obj/item/weapon/sword/scimitar/sengese/silver
	name = "silver sengese"
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "sengese_silver"
	minstr = 7
	melting_material = /datum/material/silver
	sellprice = 30

/obj/item/weapon/sword/scimitar/sengese/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/sword/scimitar/wodao
	name = "steel wo dao"
	desc = "A slightly curved blade of eastern origin. While less durable compared to other swords, it's swift balance and unique design makes it great for unleashing precise strikes."
	icon_state = "wodao_steel"
	wbalance = VERY_HARD_TO_DODGE
	possible_item_intents = list(RAPIER_THRUST,RAPIER_CUT)
	swingsound =  BLADEWOOSH_SMALL
	max_blade_int = 150
	max_integrity = INTEGRITY_STANDARD
	minstr = 6
	melting_material = /datum/material/steel

/obj/item/weapon/sword/scimitar/wodao/iron
	name = "iron wo dao"
	icon_state = "wodao_iron"
	max_blade_int = 125
	max_integrity = INTEGRITY_STANDARD
	melting_material = /datum/material/iron

/*--------\
| Rapiers |		Onehanded, slightly weaker cut, more AP thrust, harder to dodge.
\--------*/
/obj/item/weapon/sword/rapier
	name = "rapier"
	desc = "A duelist's weapon derived from western battlefield instruments, it features a tapered \
	blade with a specialized stabbing tip."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "rapier"
	force_wielded = 0
	wbalance = VERY_HARD_TO_DODGE
	possible_item_intents = list(RAPIER_THRUST, RAPIER_CUT)
	gripped_intents = null
	alt_intents = null
	minstr = 6

	bigboy = TRUE
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	parrysound = "rapier"
	swingsound = BLADEWOOSH_SMALL
	SET_BASE_PIXEL(-16, -16)
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

/obj/item/weapon/sword/rapier/psy
	name = "psydonian rapier"
	desc = "A highly ornate silver rapier, used more as a show of status for members of the inquisition."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psyrapier"
	wdefense = GOOD_PARRY
	max_integrity = INTEGRITY_STRONG
	max_blade_int = 300

/obj/item/weapon/sword/rapier/psy/Initialize(mapload)
	. = ..()
	//Pre-blessed, +100 Blade int, +100 int, +2 def, make it silver
	AddComponent(/datum/component/psyblessed, TRUE, 5, 100, 100, 2, TRUE)

/obj/item/weapon/sword/rapier/psy/relic
	name = "retribution"
	desc = "A rapier as swift as the inquisitors of the Ordo Venatari. Strike evil at its heart. Purge the unholy through the slightest window it offers, in Psydon’s name."

/obj/item/weapon/sword/rapier/dec
	name = "decorated rapier"
	desc = "A rapier decorated with gold inlaid on its hilt. A regal weapon fit for nobility."
	icon_state = "decrapier"
	sellprice = 140

/obj/item/weapon/sword/rapier/nimcha
	name = "nimcha"
	desc = "An embellished swift sword from the east."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "nimcha"
	wbalance = HARD_TO_DODGE
	dropshrink = 0.8
	sellprice = 140 // its made with gold and steel, thats pretty valuable

//................ Lord's Rapier ............... //
/obj/item/weapon/sword/rapier/dec/lord
	name = "Lord's Rapier"
	desc = "Passed down through the ages, a weapon that once carved a kingdom out now relegated to a decorative piece."
	icon_state = "lord_rapier"
	force = DAMAGE_SWORD_WIELD
	sellprice = 200
	max_blade_int = 400

/obj/item/weapon/sword/rapier/silver
	name = "silver rapier"
	desc = "An elegant silver rapier. Popular with lords and ladies in Valoria."
	icon_state = "rapier_s"
	force = DAMAGE_SWORD - 2
	melt_amount = 100
	max_blade_int = 240 // .8 of base steel
	max_integrity = INTEGRITY_STRONGEST * 0.8
	melting_material = /datum/material/silver
	sellprice = 45
	last_used = 0

/obj/item/weapon/sword/rapier/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/sword/rapier/eora
	name = "The Heartstring"
	desc = "For when soft words cannot be spoken more, and hearts are to be pierced."
	icon = 'icons/roguetown/weapons/32/patron.dmi'
	icon_state = "eorarapier"
	max_blade_int = 200

// Hoplite Kophesh
/obj/item/weapon/sword/khopesh
	name = "ancient khopesh"
	desc = "A bronze weapon of war from the age of Psydon's reign. This blade is older than a few elven generations, but has been very well-maintained and still keeps a good edge."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "khopesh"
	item_state = "khopesh"
	force = DAMAGE_SWORD + 2 // Unique weapon from rare job, slightly more force than most one-handers
	force_wielded = 0
	wdefense = GOOD_PARRY // Lower than average sword defense (meant to pair with a shield)
	wbalance = EASY_TO_DODGE // Likely weighted towards the blade, for deep cuts and chops
	possible_item_intents = list(SWORD_CUT, SWORD_CHOP, SWORD_STRIKE)
	gripped_intents = null
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONG
	minstr = 10 // Even though it's technically one-handed, you gotta have some muscle to wield this thing

	inhand_x_dimension = 64
	inhand_y_dimension = 64
	SET_BASE_PIXEL(-16, -16)
	dropshrink = 0.75
	bigboy = TRUE // WHY DOES THIS FUCKING VARIABLE CONTROL WHETHER THE BLOOD OVERLAY WORKS ON 64x64 WEAPONS
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	melting_material = /datum/material/bronze
	sellprice = 200 // A noble collector would love to get his/her hands on one of these blades



/*-----------------\
| Twohanded Swords |
\-----------------*/

//................ Long Sword ............... //
/obj/item/weapon/sword/long
	name = "longsword"
	desc = "A long hand-and-a-half blade, wielded by the virtuous and vile alike."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "longsword"
	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	force_wielded = DAMAGE_LONGSWORD_WIELD
	wlength = WLENGTH_LONG
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE, SWORD_CHOP)

	swingsound = BLADEWOOSH_LARGE
	parrysound = "largeblade"
	pickup_sound = "brandish_blade"
	bigboy = TRUE
	gripsprite = TRUE
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.75
	sellprice = 60
	grid_height = 96
	grid_width = 64

/obj/item/weapon/sword/long/shotel
	name = "steel shotel"
	icon_state = "shotel_steel"
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	desc = "A long, crescent curved blade."
	possible_item_intents = list(SWDLONG_CUT, SWDLONG_CHOP)
	gripped_intents = list(SWDLONG_CUT, SHOTEL_CHOP)

	gripsprite = FALSE
	dropshrink = 0.8
	sellprice = 80
	max_integrity = INTEGRITY_STRONG - 50 //this thing is long as hell, it would be more likely to break over time

/obj/item/weapon/sword/long/shotel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/shotel/iron //Balance-patch
	name = "iron shotel"
	icon_state = "shotel_iron"
	max_integrity = INTEGRITY_STANDARD - 50
	melting_material = /datum/material/iron
	sellprice = 60

/obj/item/weapon/sword/long/death
	color = CLOTHING_SOOT_BLACK

/obj/item/weapon/sword/long/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 212,"sturn" = 335,"wturn" = 165,"eturn" = 195,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 8,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/aruval
	name = "steel aruval"
	icon_state = "aruval_steel"
	desc = "A long billhook machete of Savannah Elf origin. It was originally designed to cut large branches, but has since evolved into a formidable weapon."
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWDLONG_THRUST, SWORD_STRIKE, SWDLONG_CUT, SWORD_DISARM)
	gripsprite = FALSE
	max_integrity = INTEGRITY_POOR + 25
	dropshrink = 0.9
	sellprice = 60

/obj/item/weapon/sword/long/aruval/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/aruval/iron //Balance-patch
	name = "iron aruval"
	icon_state = "aruval_iron"
	max_integrity = INTEGRITY_POOR - 25
	melting_material = /datum/material/iron
	sellprice = 35

/obj/item/weapon/sword/long/aruval/iron/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/death
	color = CLOTHING_SOOT_BLACK

/obj/item/weapon/sword/long/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 212,"sturn" = 335,"wturn" = 165,"eturn" = 195,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 8,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//................ Heirloom Sword ............... //
/obj/item/weapon/sword/long/heirloom
	icon_state = "heirloom"
	name = "old sword"
	desc = "An old steel sword with a heraldic green leather grip, mouldered by years of neglect."
	force = DAMAGE_SWORD - 2
	force_wielded = DAMAGE_SWORD_WIELD - 2
	max_blade_int = 180 // Neglected, unused
	max_integrity = INTEGRITY_STRONG
	static_price = TRUE
	sellprice = 45 // Old and chipped


// Repurposing this unused sword for the Paladin job as a heavy counter against vampires.
/obj/item/weapon/sword/long/judgement// this sprite is a one handed sword, not a longsword.
	icon_state = "judgement"
	name = "judgement"
	desc = "A sword with a silvered grip, a jeweled hilt and a honed blade; a design fit for nobility."
	force = DAMAGE_SWORD - 5
	force_wielded = DAMAGE_GREATSWORD_WIELD
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWDLONG_THRUST, SWORD_STRIKE, SWDLONG_CHOP)

	sellprice = 363
	static_price = TRUE
	last_used = 0

/obj/item/weapon/sword/long/judgement/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/sword/long/judgement/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/judgement/evil
	name = "decimator"
	desc = "A horrid sword with a silvered grip, a jeweled hilt and a honed blade; a design unfit for a true paladin."
	color = CLOTHING_SOOT_BLACK

/obj/item/weapon/sword/long/vlord // this sprite is a one handed sword, not a longsword.
	icon_state = "vlord"
	name = "Jaded Fang"
	desc = "An ancestral long blade with an ominous glow, serrated with barbs along its edges. Stained with a strange green tint."
	force = DAMAGE_SWORD - 2
	force_wielded = DAMAGE_GREATSWORD_WIELD
	sellprice = 363
	static_price = TRUE

/obj/item/weapon/sword/long/vlord/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/vampiric)

/obj/item/weapon/sword/long/vlord/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 130,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/rider
	icon_state = "tabi"
	name = "kilij scimitar"
	desc = "A curved blade of Zaladin origin meaning 'curved one'. The standard sword that saw the conquest of the Zalad continent and peoples."
	possible_item_intents = list(SWORD_CUT, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_STRIKE, SWDLONG_CHOP)
	sellprice = 80

/obj/item/weapon/sword/long/rider/steppe
	name = "steppe sabre"
	desc = "A curved blade of nomadic origin, it is used by cavalrymen all across the far steppes."
	icon_state = "steppe"
	force_wielded = 0
	wdefense = ULTMATE_PARRY
	possible_item_intents = list(SWORD_CUT, CURVED_THRUST)
	gripped_intents = null

/obj/item/weapon/sword/long/rider/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 270,"sturn" = 90,"wturn" = 100,"eturn" = 261,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/forgotten
	name = "forgotten blade"
	desc = "A large silver-alloy sword made in a revisionist style, honoring Psydon. Best known as the preferred weapon of Inquisitorial Lodges."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "oldpsybroadsword"
	force = DAMAGE_SWORD * 0.9 // Damage is .9 of a steel sword
	force_wielded = DAMAGE_LONGSWORD_WIELD
	wbalance = EASY_TO_DODGE
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWDLONG_THRUST, SWORD_STRIKE, SWDLONG_CHOP)
	max_blade_int = INTEGRITY_STRONG * 0.8 // Integrity and blade retention is .8 of a steel sword
	max_integrity = INTEGRITY_STRONGEST * 0.8

	last_used = 0
	melting_material = /datum/material/silver
	melt_amount = 75
	sellprice = 90

/obj/item/weapon/sword/long/forgotten/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/sword/long/ravox
	name = "duel settler"
	desc = "The tenets of Ravoxian duels are inscribed upon the blade of this sword."
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "ravoxflamberge"
	force = DAMAGE_SWORD + 2
	force_wielded = DAMAGE_LONGSWORD_WIELD

//................ Psydonian Longsword ............... //
/obj/item/weapon/sword/long/psydon
	name = "psydonian longsword"
	desc = "A large silver longsword forged in the shape of a psycross."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psysword"
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWDLONG_THRUST, SWORD_STRIKE, SWDLONG_CHOP)

	last_used = 0
	melting_material = /datum/material/silver
	sellprice = 100

/obj/item/weapon/sword/long/psydon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/sword/long/psydon/relic
	name = "Rememberance"
	desc = "A balanced silver blade, favoured by both the Ordo Benetarus and the Ordo Venetari. May it carve a path through the Unholy, in honour and rememberance of Psydon's sacrifice."

/obj/item/weapon/sword/long/psydon/relic/Initialize(mapload)
	. = ..()
	//Pre-blessed, +5 force +100 Blade int, +100 int, +1 def, make it silver
	AddComponent(/datum/component/psyblessed, TRUE, 5, 100, 100, 1, TRUE)

/obj/item/weapon/sword/long/decorated
	name = "decorated silver longsword"
	desc = "A finely crafted silver longsword with a decorated golden hilt."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "declongsword"
	force = DAMAGE_SWORD - 5
	force_wielded = DAMAGE_LONGSWORD_WIELD + 2
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWDLONG_THRUST, SWORD_STRIKE, SWDLONG_CHOP)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG

	last_used = 0
	melting_material = /datum/material/silver
	sellprice = 160

/obj/item/weapon/sword/long/decorated/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/sword/long/oldpsysword
	name = "old psydonian longsword"
	desc = "A finely made longsword, plated in a worn-down veneer of grubby silver. It's long seen better daes."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "opsysword"

//................ Greatsword ............... //
/obj/item/weapon/sword/long/greatsword
	name = "greatsword"
	desc = "An oversized hunk of metal designed for putting fear into men and killing beasts."
	icon_state = "gsw"
	force_wielded = DAMAGE_GREATSWORD_WIELD
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_GREAT
	possible_item_intents = list(SWORD_CUT, SWORD_STRIKE)
	minstr = 11

	swingsound = BLADEWOOSH_HUGE
	slot_flags = ITEM_SLOT_BACK
	melt_amount = 225
	sellprice = 90

/obj/item/weapon/sword/long/greatsword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 130,"sturn" = 220,"wturn" = 230,"eturn" = 130,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//................ Psydonian Greatsword ............... //
/obj/item/weapon/sword/long/greatsword/psydon
	name = "psydonian greatsword"
	desc = "A mighty silver greatsword made to strike fear into the heart of even archdevils."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psygsword"
	force_wielded = DAMAGE_LONGSWORD_WIELD
	gripped_intents = list(SWORD_CUT, SWDLONG_THRUST, SWORD_STRIKE, SWDLONG_CHOP)
	minstr = 11
	melting_material = /datum/material/silver
	melt_amount = 150
	sellprice = 150

/obj/item/weapon/sword/long/greatsword/psydon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/sword/long/greatsword/psydon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 85,"sturn" = 265,"wturn" = 275,"eturn" = 85,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/weapon/sword/long/greatsword/psydon/relic
	name = "Crusade"
	desc = "The grandest blade of the Ordo Benetarus. Its unparalleled strength commands even the greatest of foes to fall. Wade through the unholy in Psydon’s name. Let none survive."
	icon_state = "psygsword"
	force = DAMAGE_SWORD_WIELD
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, AXE_CHOP)
	minstr = 9 //So the ordinator can use his sword as old.

/obj/item/weapon/sword/long/broadsword/psy
	name = "old psydonian broadsword"
	desc = "Even the most ignorant of zealots know that the holy silver loses its properties when not blessed by Adjudicators and Priests of the Holy See for an extended period of time. Its edge remains as lethal as ever, however."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psybroadsword"
	melting_material = /datum/material/silver
	melt_amount = 150

/obj/item/weapon/sword/long/broadsword/psy/relic
	name = "Creed"
	desc = "Bathed in Psydonian prayers, this large and heavy blade exists to slay the inhumen and evil. The crossguard’s psycross is engraved with prayers of the Ordo Benetarus. You’re the light - show them the way."

/obj/item/weapon/sword/long/broadsword/psy/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.3, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/weapon/sword/long/broadsword/psy/relic/Initialize(mapload)
	. = ..()					//Pre-blessed, +5 DMG, +100 Blade int, +100 int, +2 def, make it silver
	AddComponent(/datum/component/psyblessed, TRUE, 5, 100, 100, 2, TRUE)

/obj/item/weapon/sword/long/greatsword/psydon/unforgotten
	name = "unforgotten blade"
	desc = "High Inquisitor Archibald once recorded an expedition of seven brave Adjudicators into eastern snow-felled wastes to root out evil. Its leader, Holy Ordinator Guillemin, was said to have held on for seven daes and seven nights against darksteel-clad heretics before Psydon acknowledged his endurance. Nothing but his blade remained - his psycross wrapped around its hilt in remembrance."
	icon_state = "forgottenblade"

/obj/item/weapon/sword/long/greatsword/psydon/unforgotten/Initialize()
	. = ..()					//+50 Blade int, +3 DMG, +50 int, +1 def, make it silver
	AddComponent(/datum/component/psyblessed, FALSE, 3, 50, 50, 1, TRUE)

//................ Flamberge ............... //
/obj/item/weapon/sword/long/greatsword/flamberge
	name = "flamberge"
	desc = "Commonly known as a flame-bladed sword, this weapon has an undulating blade. Its wave-like form distributes force better, and is less likely to break on impact."
	icon_state = "flamberge"
	wbalance = DODGE_CHANCE_NORMAL
	sellprice = 120

/obj/item/weapon/sword/long/greatsword/steelflamberge
	name = "steel flamberge"
	desc = "A steel variant of the Flamberge, It's wave-like form distributes force better, and is less likely to break on impact."
	icon_state = "steelflamberge"
	wbalance = DODGE_CHANCE_NORMAL
	melt_amount = 300
	sellprice = 120

/obj/item/weapon/sword/long/greatsword/zwei
	name = "zweihander"
	desc = "Sometimes known as a doppelhander or beidhander, this weapon's size is so impressive that its handling properties are more akin to that of a polearm than a sword."
	icon_state = "steelzwei"
	force_wielded = DAMAGE_LONGSWORD_WIELD
	possible_item_intents = list(ZWEI_CUT, ZWEI_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWDLONG_THRUST, SWORD_STRIKE, SWDLONG_CHOP)
	max_blade_int = 150 // Iron tier
	max_integrity = INTEGRITY_STRONG
	melting_material = /datum/material/iron
	melt_amount = 225
	sellprice = 60

/obj/item/weapon/sword/long/greatsword/zwei/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 85,"sturn" = 265,"wturn" = 275,"eturn" = 85,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
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
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 85,"sturn" = 265,"wturn" = 275,"eturn" = 85,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
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
			if("altgrip")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 130,"sturn" = 220,"wturn" = 230,"eturn" = 130,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 4,"sflip" = 4,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

//................ Claymores ............... //

/obj/item/weapon/sword/long/greatsword/ironclaymore
	name = "iron claymore"
	desc = "A large sword originating from the north, commonly used by ravoxians."
	icon_state = "ironclaymore"
	force_wielded = DAMAGE_LONGSWORD_WIELD
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE, SWDLONG_CHOP)
	max_blade_int = 150 // Iron tier
	max_integrity = INTEGRITY_STRONG
	minstr = 10
	sellprice = 90

/obj/item/weapon/sword/long/greatsword/ironclaymore/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.67,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.67,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.67,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.67,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/weapon/sword/long/greatsword/steelclaymore
	name = "steel claymore"
	desc = "A steel variant of the standard Claymore."
	icon_state = "steelclaymore"
	force_wielded = DAMAGE_GREATSWORD_WIELD
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE, SWDLONG_CHOP)
	max_blade_int = INTEGRITY_STRONG
	max_integrity = INTEGRITY_STRONGEST - 50
	minstr = 10
	sellprice = 110

/obj/item/weapon/sword/long/greatsword/steelclaymore/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.67,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.67,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.67,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.67,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/weapon/sword/long/greatsword/gsclaymore
	name = "ravoxian claymore"
	desc = "A huge sword constructed out of Steel and Gold, wielded by certain Templars of the Ravoxian Order."
	icon_state = "gsclaymore"
	force_wielded = DAMAGE_GREATSWORD_WIELD
	wdefense = ULTMATE_PARRY
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE, SWDLONG_CHOP)
	max_blade_int = INTEGRITY_STRONG + 50
	max_integrity = INTEGRITY_STRONGEST
	minstr = 10
	sellprice = 160

/obj/item/weapon/sword/long/greatsword/gsclaymore/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.67,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.67,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.67,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.67,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/weapon/sword/long/greatsword/gutsclaymore
	name = "berserker sword"
	desc = "A huge sword constructed out of a slab of Iron."
	icon_state = "gutsclaymore"
	force_wielded = DAMAGE_GREATSWORD_WIELD + 2
	wdefense = ULTMATE_PARRY
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(GUTS_CUT, GUTS_THRUST, GUTS_STRIKE, GUTS_CHOP)
	max_blade_int = INTEGRITY_STRONG + 50
	max_integrity = INTEGRITY_STRONGEST
	minstr = 15
	sellprice = 240

/obj/item/weapon/sword/long/greatsword/gutsclaymore/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.7,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.7,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


//................ Executioners Sword ............... //
/obj/item/weapon/sword/long/exe
	icon_state = "exe"
	name = "executioner's sword"
	desc = "An ancient blade of ginormous stature, with a round ended tip. The pride and joy of Vanderlin's greatest pastime, executions."
	possible_item_intents = list(SWORD_STRIKE)
	gripped_intents = list(SWORD_CHOP)
	minstr = 10
	slot_flags = ITEM_SLOT_BACK

/obj/item/weapon/sword/long/exe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 130,"sturn" = 220,"wturn" = 230,"eturn" = 130,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 3,"nx" = -1,"ny" = 2,"wx" = 3,"wy" = 4,"ex" = -1,"ey" = 5,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 20,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/weapon/sword/long/exe/astrata
	name = "solar judge"
	desc = "This wicked executioner's blade calls for order."
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "astratasword"
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE, SWORD_CHOP)
	max_integrity = INTEGRITY_STRONG

//................ Terminus Est ............... //
/obj/item/weapon/sword/long/exe/cloth
	icon_state = "terminusest"
	name = "Terminus Est"

/obj/item/weapon/sword/long/exe/cloth/attack_self_secondary(mob/user, list/modifiers)
	// . = ..()
	// if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
	// 	return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(user, "clothwipe", 100, TRUE)
	SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_SCRUB)
	user.visible_message("<span class='warning'>[user] wipes [src] down with its cloth.</span>", "<span class='notice'>I wipe [src] down with its cloth.</span>")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

// Copper Messer

/obj/item/weapon/sword/coppermesser
	name = "copper messer"
	desc = "A weapon of war from simpler times, its copper material is unideal but still efficient for the price."
	icon_state = "cmesser"
	item_state = "cmesser"
	force = DAMAGE_SWORD - 5 // Messers are heavy weapons, crude and STR based.
	force_wielded = DAMAGE_SWORD_WIELD - 5
	throwforce = DAMAGE_SWORD - 5
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_LONG
	possible_item_intents = list(SWORD_CUT, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_STRIKE, SWORD_CHOP)
	max_blade_int = 150
	max_integrity = INTEGRITY_POOR + 50

	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	swingsound = BLADEWOOSH_LARGE
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.90
	melting_material = /datum/material/copper
	sellprice = 10

/obj/item/weapon/sword/coppermesser/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 270,"sturn" = 90,"wturn" = 100,"eturn" = 261,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/rider/copper
	name = "copper falx"
	desc = "A special 'sword' of copper, the material isn't the best but is good enough to slash and kill."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "copperfalx"
	item_state = "copperfalx"
	force = DAMAGE_SWORD - 10
	force_wielded = DAMAGE_SWORD_WIELD - 5
	throwforce = DAMAGE_SWORD - 5
	gripped_intents = list(SWORD_CUT, SWORD_STRIKE)
	max_blade_int = 150 // Shitty Weapon
	max_integrity = INTEGRITY_POOR + 80

	parrysound = "sword"
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	slot_flags = ITEM_SLOT_BACK//how the fuck you could put this thing on your hip?
	melting_material = /datum/material/copper
	sellprice = 25//lets make the two bars worth it

/obj/item/weapon/sword/rapier/ironestoc
	name = "estoc"
	desc = "A sword possessed of a quite long and tapered blade that is intended to be thrust between the \
	gaps in an opponent's armor. The hilt is wrapped tight in black leather."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "estoc"
	force = DAMAGE_SWORD - 8
	force_wielded = DAMAGE_SWORD_WIELD
	wdefense = GREAT_PARRY
	wbalance = DODGE_CHANCE_NORMAL
	wlength = WLENGTH_GREAT
	possible_item_intents = list(SWORD_CHOP,SWORD_STRIKE,)
	gripped_intents = list(ESTOC_THRUST, ESTOC_LUNGE, SWORD_CHOP, SWORD_STRIKE)
	max_blade_int = 300
	max_integrity = INTEGRITY_STRONG
	minstr = 8

	inhand_x_dimension = 64
	inhand_y_dimension = 64
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	melting_material = /datum/material/iron

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

/obj/item/weapon/sword/gladius
	name = "gladius"
	desc = "A bronze short sword with a slightly wider end, and no guard. Compliments a shield."
	icon_state = "gladius"
	force = DAMAGE_SWORD + 2
	force_wielded = 0
	wdefense = AVERAGE_PARRY
	gripped_intents = null
	max_blade_int = 100
	max_integrity = INTEGRITY_STANDARD

	melting_material = /datum/material/bronze
	dropshrink = 0.80

//................ Gaffer's vanity sword ............... //

/obj/item/weapon/sword/long/replica
	name = "guild master's longsword"
	desc = ""
	force = DAMAGE_SWORD - 18
	force_wielded = DAMAGE_SWORD_WIELD - 20
	throwforce = DAMAGE_SWORD - 18
	max_integrity = INTEGRITY_STANDARD + 40
	sellprice = 1
	melting_material = /datum/material/tin

/obj/item/weapon/sword/long/replica/death
	color = CLOTHING_SOOT_BLACK

/obj/item/weapon/sword/long/replica/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("gen") return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback") return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded") return list("shrink" = 0.6,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 8,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt") return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/sword/long/replica/examine(mob/user)
	. = ..()
	if(is_gaffer_job(user.mind.assigned_role))
		. += span_info("A useless vanity piece I commissioned after retiring my bow. Unusable in battle, but light enough to forget its on your back.")
	else
		. += "A hollow replica of the usual longsword design presumebly made for showsake, useless in real battle"


//A weapon meant to be used with two hands.
/obj/item/weapon/sword/katana
	name = "katana"
	desc = "A foreign sword."
	icon_state = "eastsword1"
	force_wielded = DAMAGE_SWORD_WIELD + 3
	wdefense = GOOD_PARRY
	possible_item_intents = list(KATANA_ONEHAND, SWORD_STRIKE)
	gripped_intents = list(KATANA_CUT, KATANA_ARC, SWORD_STRIKE, PRECISION_CUT)

	parrysound = "bladedmedium"
	pickup_sound = "brandish_blade"
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	melt_amount = 75
	melting_material = /datum/material/steel

/obj/item/weapon/sword/katana/mulyeog
	name = "foreign straight blade"
	desc = "A foreign sword used by cut-throats & thugs. There's a red tassel on the hilt."
	icon_state = "eastsword1"

/obj/item/weapon/sword/katana/mulyeog/rumahench
	name = "hwang blade"
	desc = "A foreign steel sword with cloud patterns on the groove."
	icon_state = "eastsword2"

/obj/item/weapon/sword/katana/mulyeog/rumacaptain
	name = "samjeongdo"
	desc = "A gold-stained with cloud patterns on the groove. One of a kind."
	icon_state = "eastsword3"
	force = DAMAGE_SWORD + 5
	force_wielded = DAMAGE_SWORD_WIELD + 5
	wdefense = GREAT_PARRY

/obj/item/weapon/sword/sabre/hook
	name = "hook sword"
	desc = "A steel sword with a hooked design at the tip of it; perfect for disarming enemies. Its back edge is sharpened and the hilt appears to have a sharpened tip."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "hook_sword"
	possible_item_intents = list(SWORD_CUT, HOOK_THRUST, SWORD_STRIKE, SWORD_DISARM)
	max_integrity = INTEGRITY_STANDARD - 20

/obj/item/weapon/sword/sabre/hook/getonmobprop(tag)
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


//Snowflake version of hand-targeting disarm intent.
/datum/intent/sword/disarm
	name = "disarm"
	icon_state = "intake"
	animname = "strike"
	blade_class = null	//We don't use a blade class because it has on damage.
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = -100
	swingdelay = 2	//Small delay to hook
	damfactor = 0.1	//No real damage
	clickcd = 22	//Can't spam this; long delay.
	blade_class = BCLASS_BLUNT

/obj/item/weapon/sword/sabre/hook/attack(mob/living/M, mob/living/user, list/modifiers)
	. = ..()
	var/skill_diff = 0
	if(istype(user.used_intent, /datum/intent/sword/disarm))
		var/obj/item/I
		if(user.zone_selected == BODY_ZONE_PRECISE_L_HAND && M.active_hand_index == 1)
			I = M.get_active_held_item()
		else
			if(user.zone_selected == BODY_ZONE_PRECISE_R_HAND && M.active_hand_index == 2)
				I = M.get_active_held_item()
			else
				I = M.get_inactive_held_item()
		if(user.mind)
			skill_diff += (user.get_skill_level(/datum/skill/combat/swords, TRUE))	//You check your sword skill
		if(M.mind)
			skill_diff -= (M.get_skill_level(/datum/skill/combat/wrestling, TRUE))	//They check their wrestling skill to stop the weapon from being pulled.
		user.adjust_stamina(-rand(3,8))
		var/probby = clamp((((3 + (((user.STASTR - M.STASTR)/4) + skill_diff)) * 10)), 5, 95)
		if(I)
			if(M.mind)
				if(I.associated_skill)
					probby -= M.get_skill_level(I.associated_skill, TRUE) * 5
			var/obj/item/mainhand = user.get_active_held_item()
			var/obj/item/offhand = user.get_inactive_held_item()
			if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && istype(offhand, mainhand))
				probby += 20	//We give notable bonus to dual-wielders who use two hooked swords.
			if(prob(probby))
				M.dropItemToGround(I, force = FALSE, silent = FALSE)
				user.stop_pulling()
				user.put_in_inactive_hand(I)
				M.visible_message(span_danger("[user] takes [I] from [M]'s hand!"), \
				span_userdanger("[user] takes [I] from my hand!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
				user.changeNext_move(12)//avoids instantly attacking with the new weapon
				playsound(src, 'sound/combat/weaponr1.ogg', 100, FALSE, -1) //sound queue to let them know that they got disarmed
				if(!M.mind)	//If you hit an NPC - they pick up weapons instantly. So, we do more stuff.
					M.Stun(10)
			else
				probby += 20
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					M.visible_message(span_danger("[user] disarms [M] of [I]!"), \
					span_userdanger("[user] disarms me of [I]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
					if(!M.mind)
						M.Stun(20)	//high delay to pick up weapon
					else
						M.Stun(6)	//slight delay to pick up the weapon
				else
					user.Immobilize(10)
					M.Immobilize(10)
					M.visible_message(span_notice("[user.name] struggles to disarm [M.name]!"))
					playsound(src, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		if(!isliving(M))
			to_chat(user, span_warning("You cannot disarm this enemy!"))
			return
		else
			to_chat(user, span_warning("They aren't holding anything on that hand!"))
			return


/obj/item/weapon/sword/long/martyr
	name = "martyr sword"
	desc = "A relic from the Holy See's own vaults. It simmers with godly energies, and will only yield to the hands of those who have taken the Oath."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "martyrsword"
	item_state = "martyrsword"
	force = DAMAGE_GREATSWORD_WIELD
	force_wielded = DAMAGE_GREATSWORD_WIELD + 6
	throwforce = DAMAGE_SWORD - 5
	possible_item_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE)
	gripped_intents = list(SWORD_CUT, SWORD_THRUST, SWORD_STRIKE, SWORD_CHOP)
	max_blade_int = 200
	max_integrity = INTEGRITY_STRONG

	parrysound = "bladedmedium"
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	dropshrink = 1
	melting_material = /datum/material/gold

/datum/intent/sword/cut/martyr
		item_damage_type = "fire"
		blade_class = BCLASS_CUT
/datum/intent/sword/thrust/martyr
		item_damage_type = "fire"
		blade_class = BCLASS_PICK // so our armor-piercing attacks in ult mode can do crits(against most armors, not having crit)
/datum/intent/sword/strike/martyr
		item_damage_type = "fire"
		blade_class = BCLASS_SMASH
/datum/intent/sword/chop/martyr
		item_damage_type = "fire"
		blade_class = BCLASS_CHOP


/obj/item/weapon/sword/long/martyr/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback") return list("shrink" = 0.6,"sx" = -2,"sy" = 3,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 90,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded") return list("shrink" = 0.7,"sx" = 6,"sy" = -2,"nx" = -4,"ny" = 2,"wx" = -8,"wy" = -1,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = -200,"wturn" = -160,"eturn" = -25,"nflip" = 8,"sflip" = 8,"wflip" = 0,"eflip" = 0)
			if("onbelt") return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 0,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = -3,"ey" = -5,"nturn" = 180,"sturn" = 180,"wturn" = 0,"eturn" = 90,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
