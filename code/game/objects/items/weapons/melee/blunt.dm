/* BLUNT - low-ish damage, limited defense, good AP
==========================================================*/
//................ Mace ............... //
/obj/item/weapon/mace
	name = "iron mace"
	desc = "A heavy iron mace, preferred by those with a grudge against knightly whoresons."
	icon_state = "mace"
	icon = 'icons/roguetown/weapons/32/clubs.dmi'
	force = DAMAGE_MACE
	force_wielded = DAMAGE_MACE_WIELD
	possible_item_intents = list(/datum/intent/mace/strike)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
	item_state = "mace_greyscale"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	equip_sound = "rustle"
	sharpness = IS_BLUNT
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/combat/axesmaces
	melting_material = /datum/material/iron
	melt_amount = 75
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	max_integrity = INTEGRITY_STRONG
	minstr = 7
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	sellprice = 20
	blade_dulling = DULLING_BASHCHOP
	grid_height = 64
	grid_width = 32

/obj/item/weapon/mace/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -6,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
	return ..()

/obj/item/weapon/mace/rungu/iron
	force = DAMAGE_MACE
	force_wielded = DAMAGE_MACE_WIELD
	possible_item_intents = list(/datum/intent/mace/strike)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
	name = "iron rungu"
	desc = "An iron Lakkarian mace favored by the Shinobi's of Sekket. It is the bane of Zalad slavers."
	icon_state = "rungu_iron"
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	equip_sound = "rustle"
	sharpness = IS_BLUNT
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/combat/axesmaces
	melting_material = /datum/material/iron
	melt_amount = 75
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	max_integrity = INTEGRITY_STRONG
	minstr = 7
	wdefense = AVERAGE_PARRY
	wbalance = EASY_TO_DODGE
	sellprice = 20
	blade_dulling = DULLING_BASHCHOP
	grid_height = 64
	grid_width = 32

/obj/item/weapon/mace/rungu/iron/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -12,"sy" = -10,"nx" = 12,"ny" = -10,"wx" = -8,"wy" = -7,"ex" = 3,"ey" = -9,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = -12,"sy" = 3,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -6,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
	return ..()

/obj/item/weapon/mace/shishpar/iron
	name = "iron shishpar"
	desc = "A heavy foreign mace with a sword-like handle. It's weight makes it a little hard to wield, but its capable of delivering devastating blows."
	force = DAMAGE_MACE+1
	force_wielded = DAMAGE_MACE_WIELD+2
	icon_state = "shishpar_iron"
	wbalance = EASY_TO_DODGE
	wdefense = GOOD_PARRY
	sellprice = 35

/*--------------\
| Strike intent |	moderate AP
\--------------*/
/datum/intent/mace/strike
	name = "strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "hits")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = AP_CLUB_STRIKE
	swingdelay = 0
	icon_state = "instrike"
	misscost = 5
	item_damage_type = "blunt"

/datum/intent/mace/strike/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')

/datum/intent/mace/strike/heavy
	penfactor = AP_CLUB_HEAVY_STRIKE
	swingdelay = 2
	icon_state = "instrike"
	misscost = 12


/*--------------\
| Smash intent |	10% force increase and moderate+ AP, has slightly higher penalties
\--------------*/
/datum/intent/mace/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = AP_CLUB_SMASH
	damfactor = 1.1
	chargetime = 3
	swingdelay = 3
	charging_slowdown = 0.8
	icon_state = "insmash"
	misscost = 10
	item_damage_type = "blunt"

/datum/intent/mace/smash/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')

/datum/intent/mace/smash/heavy
	penfactor = AP_HEAVY_SMASH
	damfactor = 1.2
	chargetime = 3
	swingdelay = 3
	misscost = 22
	warnie = "mobwarning"


/*--------------\
| Thrust intent |	Godendag stab
\--------------*/
/datum/intent/mace/thrust
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("stabs")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	chargetime = 1
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 40
	swingdelay = 1
	misscost = 15
	item_damage_type = "blunt"

//................ Court Physician Cane ............... //

/obj/item/weapon/mace/courtphysician
	name = "physician's cane"
	desc = "A prized cane. Embellished with a golden serpent, representing the Kingsfield university. The pointy end is quite sharp."
	icon = 'icons/roguetown/weapons/32/special.dmi'
	icon_state = "fancy_cane"
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/thrust)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash)
	sellprice = 30
	minstr = 5
	force = DAMAGE_MACE - 3
	force_wielded = DAMAGE_MACE - 1
	wdefense = MEDIOCRE_PARRY

/obj/item/weapon/mace/courtphysician/Initialize()
	. = ..()
	AddComponent(/datum/component/walking_stick)

/obj/item/weapon/mace/courtphysician/getonmobprop(tag)
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
			if("wielded")
				return list(
					"shrink" = 0.5,
					"sx" = 0,
					"sy" = 0,
					"nx" = 0,
					"ny" = 0,
					"wx" = -3,
					"wy" = 0,
					"ex" = 3,
					"ey" = 0,
					"nturn" = -90,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = FALSE,
					"southabove" = TRUE,
					"eastabove" = TRUE,
					"westabove" = TRUE
				)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//................ Bell ringer ............... //
/obj/item/weapon/mace/church
	force = DAMAGE_MACE+3
	force_wielded = DAMAGE_MACE_WIELD+3
	name = "bell ringer"
	desc = "Faith is sometimes best administered with steel and blood."
	icon_state = "churchmace"
	melting_material = /datum/material/steel
	melt_amount = 75
	blade_dulling = DULLING_BASH
	sellprice = 100
	wdefense = GOOD_PARRY


//................ Steel mace ............... //	Better wbalance and wdefense
/obj/item/weapon/mace/steel
	name = "steel mace"
	desc = "A well-crafted mace with a steel head. Easier to control and hits just as hard."
	icon_state = "smace"
	blade_dulling = DULLING_BASH
	melting_material = /datum/material/steel
	melt_amount = 150
	wbalance = DODGE_CHANCE_NORMAL
	sellprice = 60
	wdefense = GOOD_PARRY

/obj/item/weapon/mace/steel/rungu
	name = "steel rungu"
	desc = "A steel Lakkarian mace favored by the Shinobi's of Sekket. It is the bane of Zalad slavers."
	icon_state = "rungu_steel"
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	blade_dulling = DULLING_BASH
	melting_material = /datum/material/steel
	melt_amount = 150
	wbalance = DODGE_CHANCE_NORMAL
	sellprice = 60
	wdefense = GOOD_PARRY

/obj/item/weapon/mace/steel/shishpar
	name = "steel shishpar"
	desc = "A heavy foreign mace with a sword-like handle. Its weight makes it a little hard to wield, but it's capable of delivering devastating blows."
	force = DAMAGE_MACE+2
	force_wielded = DAMAGE_MACE_WIELD+3
	icon_state = "shishpar_steel"
	wbalance = EASY_TO_DODGE
	wdefense = GREAT_PARRY
	sellprice = 75

//................ Spiked club ............... //
/obj/item/weapon/mace/spiked
	force = DAMAGE_MACE+2
	force_wielded = DAMAGE_MACE_WIELD+3
	name = "spiked mace"
	icon_state = "spikedmace"
	max_integrity = 200
	melting_material = /datum/material/iron
	melt_amount = 150

//................ Morningstar ............... //
/obj/item/weapon/mace/steel/morningstar
	force = DAMAGE_MACE+2
	force_wielded = DAMAGE_MACE_WIELD+3
	name = "morningstar"
	icon_state = "spiked_club_old"
	max_integrity = 300


//................ Iron Bludgeon ............... // Bludgeons have less force, less integrity, and worse parry than their mace counterarts, but are harder to dodge.
/obj/item/weapon/mace/bludgeon
	force = DAMAGE_CLUB+3
	force_wielded = DAMAGE_CLUB_WIELD+2
	name = "iron bludgeon"
	desc = "An iron headed club, useful for beating the dregs back into their gutters."
	icon_state = "ibludgeon"
	max_integrity = INTEGRITY_STRONG-50
	wbalance = HARD_TO_DODGE
	wdefense = MEDIOCRE_PARRY

/obj/item/weapon/mace/bludgeon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 10,"ny" = -6,"wx" = -1,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 91,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = -11,"sy" = 2,"nx" = 12,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 4,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -5,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = -15,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)


//................ Copper bludgeon ............... //
/obj/item/weapon/mace/bludgeon/copper
	force = DAMAGE_CLUB+1
	force_wielded = DAMAGE_CLUB_WIELD+1
	name = "copper bludgeon"
	desc = "An extremely crude weapon for cruder bastards."
	icon_state = "cbludgeon"
	max_integrity = INTEGRITY_POOR-20
	minstr = 5
	melting_material = /datum/material/copper
	melt_amount = 75
	sellprice = 10
	wdefense = MEDIOCRE_PARRY


//................ Club ............... //
/obj/item/weapon/mace/woodclub
	force = DAMAGE_CLUB
	force_wielded = DAMAGE_CLUB_WIELD
	name = "club"
	desc = "A weapon older than recorded time itself."
	icon_state = "club1"
	max_integrity = INTEGRITY_WORST
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	minstr = 2
	sellprice = 5
	wdefense = MEDIOCRE_PARRY

/obj/item/weapon/mace/woodclub/Initialize(mapload)
	. = ..()
	if(icon_state == "club1")
		icon_state = "club[rand(1,2)]"


//................ Cudgel ............... //
/obj/item/weapon/mace/cudgel
	force = DAMAGE_CLUB
	force_wielded = DAMAGE_CLUB_WIELD
	name = "cudgel"
	icon_state = "cudgel"
	desc = "A stubby little club favored for thwacking thieves and smart-mouthed peasant folk."
	gripped_intents = null
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = INTEGRITY_STANDARD
	minstr = 2
	wbalance = HARD_TO_DODGE
	sellprice = 15
	wdefense = MEDIOCRE_PARRY

/obj/item/weapon/mace/cudgel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -8,"sy" = -7,"nx" = 10,"ny" = -7,"wx" = -1,"wy" = -8,"ex" = 1,"ey" = -7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 91,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -3,"sy" = -4,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 70,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)

/obj/item/weapon/mace/cudgel/psy
	name = "psydonian handmace"
	desc = "A shorthanded mace, a convenient sleeping aid, or a means to root out heresy. It's all in the wrist."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psyflangedmace"
	resistance_flags = FIRE_PROOF
	wdefense = 2

/obj/item/weapon/mace/cudgel/psy/Initialize(mapload)
	. = ..()
	// +3 force, +100 blade int, +50 int, +1 def, make silver
	AddComponent(/datum/component/psyblessed, FALSE, 3, 100, 50, 1, TRUE)

/obj/item/weapon/mace/cudgel/shellrungu
	name = "shell rungu"
	desc = "A ceremonial rungu carved out of a clam shell. Not intended for combat. It's used in various Sea and Coastal Elven rituals and ceremonies."
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "rungu_shell"

	max_integrity = INTEGRITY_POOR
	sellprice = 35

//................ Alt cudgel ............... //
/obj/item/weapon/mace/cudgel/carpenter
	name = "peasant cudgel"
	icon_state = "carpentercudgel"
	desc = "A stubby club reinforced with iron bits, popular among village watchmen and peasant militias. Despite being reinforced and hard-hitting, it still cannot compare to a proper mace."

//................ Wooden sword ............... //
/obj/item/weapon/mace/woodclub/train_sword
	name = "wooden sword"
	desc = "Crude wood assembled into the shape of a sword, a terrible weapon to be on the receiving end of during a training spat."
	icon = 'icons/roguetown/weapons/32/swords.dmi'
	icon_state = "wsword"
	force = 5
	force_wielded = 8
	wbalance = DODGE_CHANCE_NORMAL
	associated_skill = /datum/skill/combat/swords
	wdefense = ULTMATE_PARRY
	metalizer_result = /obj/item/weapon/sword/iron
	max_integrity = INTEGRITY_STANDARD

/obj/item/weapon/mace/woodclub/train_sword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//................ Goedendag ............... //
/obj/item/weapon/mace/goden
	name = "warclub"
	desc = "A two-handed club, decorated with a spiked cap crown. A perfect way to say Good Morning to any would be noble-knight."
	icon = 'icons/roguetown/weapons/64/maces.dmi'
	icon_state = "goedendag"
	force = DAMAGE_CLUB
	force_wielded = DAMAGE_HEAVYCLUB_WIELD
	possible_item_intents = list(/datum/intent/mace/strike/heavy)
	gripped_intents = list(/datum/intent/mace/smash/heavy, /datum/intent/mace/thrust)
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	minstr = 10
	parrysound = "parrywood"
	max_integrity = INTEGRITY_STRONG
	wbalance = EASY_TO_DODGE
	sellprice = 35
	wdefense = GOOD_PARRY

/obj/item/weapon/mace/goden/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/mace/goden/deepduke
	name = "deep duke's staff"
	desc = "A staff made of seaglass and sturdy but unusual metal, holding no power after its misled owner's death. More useful as a bashing tool than a magic focus."
	icon = 'icons/roguetown/mob/monster/pufferboss.dmi'
	icon_state = "pufferprod"
	force = DAMAGE_MACE - 5
	force_wielded = DAMAGE_HEAVYCLUB_WIELD + 5
	minstr = 11
	max_integrity = INTEGRITY_STRONGEST * 1.2

//................ Grand mace ............... //
/obj/item/weapon/mace/goden/steel
	gripped_intents = list(/datum/intent/mace/smash/heavy) // It's a 2h flanged mace, not a goedendag.
	name = "grand mace"
	desc = "A cast polearm, rumored to be the weapon-design used by Psydon himself."
	icon_state = "polemace"
	resistance_flags = FIRE_PROOF
	melting_material = /datum/material/steel
	melt_amount = 75
	max_integrity = INTEGRITY_STRONGEST
//	slowdown = 1
	sellprice = 60
	wbalance = DODGE_CHANCE_NORMAL

/obj/item/weapon/mace/goden/steel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -8,"sy" = 6,"nx" = 8,"ny" = 6,"wx" = -5,"wy" = 6,"ex" = 0,"ey" = 6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -32,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -2,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -24,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)


/obj/item/weapon/mace/goden/steel/malum
	name = "forgefiend"
	desc = "This hammer's creation took a riddle in its own making. A great sacrifice for perfect quality"
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "malumhammer"
	gripped_intents = list(/datum/intent/mace/strike/heavy, /datum/intent/mace/smash/heavy)
	max_integrity = 200

//................ Psydonian Grand Mace ............... //
/obj/item/weapon/mace/goden/psydon
	name = "psydonian grand mace"
	desc = "A mighty mace which seems to be a large psycross with a handle, though no less effective at crushing the spirit and bones of the inhumen."
	icon = 'icons/roguetown/weapons/64/psydonite.dmi'
	icon_state = "psymace"
	resistance_flags = FIRE_PROOF
	melting_material = /datum/material/silver
	melt_amount = 150
	wbalance = DODGE_CHANCE_NORMAL
	sellprice = 100
	wdefense = GOOD_PARRY
	minstr = 11

/obj/item/weapon/mace/goden/psydon/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/mace/goden/psydon/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -8,"sy" = 6,"nx" = 8,"ny" = 6,"wx" = -5,"wy" = 6,"ex" = 0,"ey" = 6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -32,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -2,"ex" = 5,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -24,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)


//................ Shillelagh ............... //
/obj/item/weapon/mace/goden/shillelagh		// The Briar signature weapon. Sturdy oak war club.
	name = "shillelagh"
	desc = "Big old oak branch, carved to a deadly weapon."
	icon = 'icons/roguetown/weapons/32/clubs.dmi'
	icon_state = "shillelagh"
	gripped_intents = list(/datum/intent/mace/smash/wood)
	SET_BASE_PIXEL(0, 0)
	bigboy = FALSE
	gripsprite = TRUE
	slot_flags = ITEM_SLOT_BACK
	max_integrity = 200
	minstr = 8
	sellprice = 5

/obj/item/weapon/mace/goden/shillelagh/Initialize()
	. = ..()
	AddComponent(/datum/component/walking_stick)

/obj/item/weapon/mace/goden/shillelagh/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 6,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -15,"sturn" = 12,"wturn" = 0,"eturn" = 354,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 6,"sy" = -6,"nx" = -5,"ny" = -6,"wx" = 2,"wy" = -6,"ex" = 6,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 20,"eturn" = -20,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.7,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 2,"wy" = -5,"ex" = 8,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//................ Dwarf Warhammer ............... // - Unique Langobardo weapon
/obj/item/weapon/mace/goden/steel/warhammer
	name = "dwarven warhammer"
	desc = "A great dwarven warhammer made of stern steel, engraved with oaths of battle and time."
	icon_state = "warhammer"
	wlength = WLENGTH_GREAT
	swingsound = BLUNTWOOSH_HUGE
	sellprice = 100

/obj/item/weapon/mace/goden/steel/warhammer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//................ Copper goden ............... //
/obj/item/weapon/mace/goden/copper
	force = DAMAGE_CLUB - 5
	force_wielded = DAMAGE_CLUB_WIELD
	slowdown = 1
	name = "copper warclub"
	desc = "A two-handed club, decorated with a crown of spikes. A barbaric design, good enough to be used as a weapon."
	icon_state = "cwarclub"
	melting_material = /datum/material/copper
	melt_amount = 75
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	parrysound = "parrywood"
	max_integrity = INTEGRITY_POOR
	minstr = 10
	sellprice = 35

//................ Warhammers ............... //
/obj/item/weapon/mace/warhammer
	force = DAMAGE_MACE
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/mace/warhammer/impale)
	gripped_intents = null
	name = "iron warhammer"
	desc = "Made to punch through armor and skull alike."
	icon_state = "iwarhammer"
	wbalance = EASY_TO_DODGE
	melting_material = /datum/material/iron
	melt_amount = 75
	blade_dulling = DULLING_BASH
	wdefense = GOOD_PARRY

/obj/item/weapon/mace/warhammer/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = -7,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
	return ..()

/obj/item/weapon/mace/warhammer/steel
	force = 25
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/mace/warhammer/impale, /datum/intent/mace/warhammer/stab)
	name = "steel warhammer"
	desc = "A fine steel warhammer, makes a satisfying sound when paired with a knight's helm."
	icon_state = "swarhammer"
	melting_material = /datum/material/steel
	melt_amount = 150
	wdefense = GREAT_PARRY

/datum/intent/mace/warhammer/stab
	name = "thrust"
	icon_state = "instab"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "stabs")
	animname = "stab"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 20
	damfactor = 0.8
	item_damage_type = "stab"

/datum/intent/mace/warhammer/impale
	name = "impale"
	icon_state = "inimpale"
	blade_class = BCLASS_PICK
	attack_verb = list("picks", "impales")
	animname = "stab"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 14
	chargedrain = 1
	misscost = 1
	no_early_release = TRUE
	penfactor = 80
	damfactor = 0.9
	item_damage_type = "stab"

//................ Elven Club  ............... //

/obj/item/weapon/mace/elvenclub
	name = "elven war club"
	desc = "A one-handed war club with a sharp end."
	icon_state = "elvenclub"
	force = DAMAGE_MACE - 1
	force_wielded = DAMAGE_MACE_WIELD - 1
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/axe/cut)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/axe/cut, /datum/intent/axe/chop) //can't smash with this weapon.
	minstr = 5
	sharpness = IS_SHARP

/obj/item/weapon/mace/elvenclub/steel
	name = "regal elven war club"
	desc = "A sleek, one-handed war club, reforged from captured Grenzel steel. Its elegant design channels elven grace, It is capable of delivering swift, painful blows"
	icon_state = "regalelvenclub"
	force = DAMAGE_MACE
	force_wielded = DAMAGE_MACE_WIELD
	blade_dulling = DULLING_BASH
	melting_material = /datum/material/steel
	melt_amount = 150
	wbalance = DODGE_CHANCE_NORMAL
	sellprice = 60
	wdefense = GOOD_PARRY

//................ Silver ............... //

/obj/item/weapon/mace/silver/rungu
	name = "silver rungu"
	desc = "A silver mace favored by Lakkarian clerics. The weapon of choice for the monster-slayers of Sakhumeti."
	icon_state = "rungu_silver"
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	blade_dulling = DULLING_BASH
	melting_material = /datum/material/silver
	melt_amount = 150
	wbalance = DODGE_CHANCE_NORMAL
	sellprice = 45
	wdefense = GOOD_PARRY

/obj/item/weapon/mace/silver/rungu/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/mace/silver/gada
	name = "regal gada"
	icon_state = "gada"
	desc = "A luxurious silver mace of Savannah Elf origin that's been reinforced and embellished with gold. It's considerably heavier compared to other maces."
	minstr = 8
	force = DAMAGE_MACE+2
	wbalance = DODGE_CHANCE_NORMAL
	wdefense = AVERAGE_PARRY
	sellprice = 150 // It's silver and gold.

/obj/item/weapon/mace/silver/gada/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)
