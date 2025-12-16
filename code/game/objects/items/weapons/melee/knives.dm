/* KNIVES - Low damage, bad parry, ok AP
==========================================================*/

/obj/item/weapon/knife
	name = "knife"
	force = DAMAGE_KNIFE
	throwforce = DAMAGE_KNIFE
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	icon = 'icons/roguetown/weapons/32/knives.dmi'
	icon_state = "huntingknife"
	gripsprite = FALSE
	dropshrink = 0.8
	thrown_bclass = BCLASS_CUT
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	max_blade_int = 140
	max_integrity = INTEGRITY_STRONG
	associated_skill = /datum/skill/combat/knives
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	equip_sound = 'sound/foley/dropsound/holster_sword.ogg'
	drop_sound = 'sound/foley/dropsound/blade_drop.ogg'
	wdefense = MEDIOCRE_PARRY
	wbalance = HARD_TO_DODGE
	melting_material = /datum/material/steel
	melt_amount = 50
	sharpness = IS_SHARP
	sellprice = 30

	grid_height = 64
	grid_width = 32

/obj/item/weapon/knife/Initialize()
	. = ..()
	AddElement(/datum/element/tipped_item, _max_reagents = 10, _dip_amount = 5, _inject_amount = 0.5)

/obj/item/weapon/knife/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -8,"sy" = 0,"nx" = 9,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/dagger
	clickcd = 8

/*-----------\
| Cut intent |	small AP, fast
\-----------*/
/datum/intent/dagger/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 10
	chargetime = 0
	swingdelay = 1
	clickcd = 10	// between normal and fast
	item_damage_type = "slash"

/*------------\
| Stab intent |	good AP, fast
\---------.--*/
/datum/intent/dagger/thrust
	name = "stab"
	icon_state = "instab"
	attack_verb = list("stabs")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 30
	chargetime = 0
	clickcd = CLICK_CD_FAST
	swingdelay = 1
	item_damage_type = "stab"

/// special intent for profane dagger, steals the appearance of another
/datum/intent/peculate
	name = "peculate"
	hitsound = null
	desc = "Thieve the appearance of another."
	icon_state = "peculate"

/*------------\
| Pick intent |	great AP. Not actually used anywhere.
\------------*/
/*
/datum/intent/dagger/thrust/pick
	name = "thrust"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 50
	clickcd = CLICK_CD_MELEE
	swingdelay = 1
	blade_class = BCLASS_PICK
*/

/*------------\
| Chop intent |	small AP, bonus damage
\------------*/
/datum/intent/dagger/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 10
	damfactor = 1.5
	swingdelay = 1
	clickcd = CLICK_CD_MELEE
	item_damage_type = "slash"

/datum/intent/dagger/chop/cleaver
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	damfactor = 2

//................ Hunting Knife ............... //
/obj/item/weapon/knife/hunting
	force = DAMAGE_DAGGER
	throwforce = DAMAGE_KNIFE
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	name = "hunting knife"
	desc = "Loyal companion to hunters and poachers, from humble bone to truest steel, disembowel your prey with glee."
	icon_state = "huntingknife"
	max_blade_int = 140
	max_integrity = INTEGRITY_STRONG
	wdefense = MEDIOCRE_PARRY
	wbalance = HARD_TO_DODGE
	melting_material = /datum/material/steel
	melt_amount = 75
	sellprice = 6


/obj/item/weapon/knife/dagger/navaja
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut,  /datum/intent/dagger/thrust)
	name = "navaja"
	desc = "A folding Etruscan knife valued by merchants, mercenaries and peasants for its convenience. It possesses a long hilt, allowing for a sizable blade with good reach."
	force = 5
	icon_state = "navaja_c"
	item_state = "elfdag"
	var/extended = 0
	wdefense = TERRIBLE_PARRY
	sellprice = 30 //shiny :o

/obj/item/weapon/knife/dagger/navaja/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		force = 20
		wdefense = MEDIOCRE_PARRY
		w_class = WEIGHT_CLASS_NORMAL
		throwforce = 23
		icon_state = "navaja_o"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		sharpness = IS_SHARP
	else
		force = 5
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "navaja_c"
		attack_verb = list("stubbed", "poked")
		sharpness = IS_BLUNT
		wdefense = TERRIBLE_PARRY

/obj/item/weapon/knife/scissors
	name = "iron scissors"
	desc = "Scissors made of iron that may be used to salvage usable materials from clothing."
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "iscissors"
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/cut, /datum/intent/snip)
	max_integrity = INTEGRITY_WORST
	melting_material = /datum/material/iron
	melt_amount = 75

/datum/intent/snip // The salvaging intent! Used only for the scissors for now!
	name = "snip"
	icon_state = "insnip"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/obj/item/weapon/knife/scissors/pre_attack(atom/A, mob/living/user, params)
	if(user.used_intent.type == /datum/intent/snip && isitem(A))
		var/obj/item/item = A
		if(item.sewrepair && item.salvage_result) // We can only salvage objects which can be sewn!
			. = TRUE
			var/skill_level = user.get_skill_level(/datum/skill/misc/sewing)
			var/salvage_time = (7 SECONDS - (skill_level * 10))
			if(!do_after(user, salvage_time, A))
				return
			if(item.fiber_salvage) //We're getting fiber as base if fiber is present on the item
				new /obj/item/natural/fibers(get_turf(item))
			if(istype(item, /obj/item/storage))
				var/obj/item/storage/bag = item
				bag.emptyStorage()
			var/probability = max(0, 50 - (skill_level * 10))
			if(prob(probability)) // We are dumb and we failed!
				to_chat(user, span_warning("I ruined some of the materials due to my lack of skill..."))
				playsound(item, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				qdel(item)
				user.mind.add_sleep_experience(/datum/skill/misc/sewing, (user.STAINT)) //Getting exp for failing
				return //We are returning early if the skill check fails!
			item.salvage_amount -= item.torn_sleeve_number
			for(var/i = 1; i <= item.salvage_amount; i++) // We are spawning salvage result for the salvage amount minus the torn sleves!
				var/obj/item/Sr = new item.salvage_result(get_turf(item))
				Sr.color = item.color
			user.visible_message(span_notice("[user] salvages [item] into usable materials."))
			playsound(item, 'sound/items/flint.ogg', 100, TRUE) //In my mind this sound was more fitting for a scissor
			qdel(item)
			user.mind.add_sleep_experience(/datum/skill/misc/sewing, (user.STAINT)) //We're getting experience for salvaging!
			return
	return ..()

/obj/item/weapon/knife/scissors/steel
	force = DAMAGE_DAGGER + 2
	max_integrity = INTEGRITY_POOR
	name = "steel scissors"
	desc = "Scissors made of solid steel that may be used to salvage usable materials from clothing, more durable and a tad more deadly than their iron counterpart."
	icon_state = "sscissors"
	melting_material = /datum/material/steel
	melt_amount = 75

//................ Cleaver ............... //
/obj/item/weapon/knife/cleaver
	name = "cleaver"
	desc = "A chef's tool turned armament, cleave off cumbersome flesh with rudimentary ease."
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	icon_state = "cleav"
	item_state = "cleav"
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	experimental_onback = FALSE
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 15
	max_integrity = INTEGRITY_POOR
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CHOP
	w_class = WEIGHT_CLASS_NORMAL
	melting_material = /datum/material/steel
	melt_amount = 75
	wbalance = 0 // Except this one, too huge and used to chop
	dropshrink = 0.9

//................ Hack-Knife ............... //
/obj/item/weapon/knife/cleaver/combat
	name = "hack-knife"
	desc = "A short blade that even the weakest of hands can aspire to do harm with."
	force = DAMAGE_KNIFE
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop)
	icon_state = "combatknife"
	throwforce = 16
	max_integrity = INTEGRITY_STANDARD - 20
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	melting_material = /datum/material/iron
	melt_amount = 75
	wbalance = 1
	sellprice = 15

/obj/item/weapon/knife/cleaver/combat/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = 0,"nx" = 13,"ny" = 2,"wx" = -8,"wy" = 2,"ex" = 5,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 21,"sturn" = -18,"wturn" = -18,"eturn" = 21,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//................ Bronze Dagger ............... //s
/obj/item/weapon/knife/dagger/bronze
	name = "bronze dagger"
	desc = "A dagger made out of bronze."
	icon_state = "dagger_bronze"
	melting_material = /datum/material/bronze
	melt_amount = 75
	sellprice = 10

//................ Iron Dagger ............... //
/obj/item/weapon/knife/dagger
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	name = "iron dagger"
	desc = "Thin, sharp, pointed death."
	icon_state = "idagger"
	melting_material = /datum/material/iron
	melt_amount = 75
	sellprice = 12

/obj/item/weapon/knife/jile/iron
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	name = "iron jile"
	desc = "A curved iron dagger of Lakkarian origin. Nobles of Sakhumeti were often buried with these daggers, but this practice has become less common ever since Zizo's ascension."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "jile_iron"
	melting_material = null
	sellprice = 12
	dropshrink = 1.0

/obj/item/weapon/knife/dagger/kukri/iron
	name = "iron kukri"
	icon_state = "kukri_iron"
	desc = "A hefty knife that originated in the Southeastern reaches of Faience. Its design makes it great for chopping through vegetation and other obstacles."
	force = DAMAGE_DAGGER+1
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop, /datum/intent/dagger/thrust)

/obj/item/weapon/knife/njora/iron

	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop, /datum/intent/dagger/thrust)
	name = "iron seme"
	desc = "A broad iron dagger of ancient Lakkarian design. Popular amongst the indigenous jungle elf tribes of the Lakkarian Rainforests."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "njora_iron"
	melting_material = null
	sellprice = 12
	dropshrink = 1.0

//................ Steel Dagger ............... //
/obj/item/weapon/knife/dagger/steel
	name = "steel dagger"
	desc = "A dagger made of refined steel."
	icon_state = "sdagger"
	melting_material = /datum/material/steel
	melt_amount = 75
	wdefense = AVERAGE_PARRY
	wbalance = VERY_HARD_TO_DODGE

/obj/item/weapon/knife/jile/steel
	name = "steel jile"
	desc = "A curved steel dagger of Lakkarian origin. Nobles of Sakhumeti were often buried with these daggers, but this practice has become less common ever since Zizo's ascension."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "jile_steel"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	melting_material = null
	wdefense = AVERAGE_PARRY
	wbalance = VERY_HARD_TO_DODGE
	sellprice = 20
	dropshrink = 1.0

/obj/item/weapon/knife/njora/steel
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop, /datum/intent/dagger/thrust)
	name = "steel seme"
	desc = "A broad steel dagger of ancient Lakkarian design. Popular amongst the indigenous jungle elf tribes of the Lakkarian Rainforests."
	icon = 'icons/roguetown/weapons/32/lakkari.dmi'
	icon_state = "njora_steel"
	melting_material = null
	wdefense = AVERAGE_PARRY
	wbalance = HARD_TO_DODGE
	sellprice = 20
	dropshrink = 1.0

/obj/item/weapon/knife/dagger/steel/special
	icon_state = "sdaggeralt"
	desc = "A dagger of refined steel, and even more refined appearance."

/obj/item/weapon/knife/dagger/kukri/steel
	name = "steel kukri"
	icon_state = "kukri_steel"
	desc = "A hefty knife that originated in the Southeastern reaches of Faience. Its design makes it great for chopping through vegetation and other obstacles."
	force = DAMAGE_DAGGER+1
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop, /datum/intent/dagger/thrust)

/obj/item/weapon/knife/dagger/steel/pestrasickle
	name ="plaguebringer sickle"
	desc = "A wicked edge brings feculent delights."
	icon = 'icons/roguetown/weapons/32/patron.dmi'
	icon_state = "pestrasickle"
	max_integrity = INTEGRITY_STRONG
	wdefense = GOOD_PARRY //They use a dagger, but it should be fine for them to also parry with it.

//................ Fanged dagger ............... //
/obj/item/weapon/knife/dagger/steel/dirk
	name = "fanged dagger"
	desc = "A dagger modeled after the fang of an anthrax spider."
	icon = 'icons/roguetown/weapons/32/elven.dmi'
	icon_state = "spiderdagger"
	melting_material = null

/obj/item/weapon/knife/dagger/steel/dirk/baotha //this is a placeholder weapon until they actually receive a proper baothan weapon
	name = "laced dagger"
	desc = "Whispers of bliss seep deeper than the blade."
	melting_material = null
	color = "#f78ccc"
	max_integrity = 200
	wdefense = GOOD_PARRY //They use a dagger, but it should be fine for them to also parry with it.

/obj/item/weapon/knife/dagger/steel/dirk/baotha/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/baothagift)


//................ Silver Dagger ............... //
/obj/item/weapon/knife/dagger/silver
	name = "silver dagger"
	desc = "A dagger made of fine silver, the bane of the undead."
	icon_state = "sildagger"
	melting_material = /datum/material/silver
	max_blade_int = 120
	max_integrity = INTEGRITY_STRONG * 0.8
	sellprice = 45
	last_used = 0

/obj/item/weapon/knife/dagger/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

//................ Psydonian Dagger ............... //
/obj/item/weapon/knife/dagger/silver/psydon
	name = "psydonian dagger"
	desc = "A silver dagger favored by close range fighters of the inquisition."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psydagger"
	sellprice = 60

//................ Profane Dagger ............... //
/obj/item/weapon/knife/dagger/steel/profane
	// name = "profane dagger"
	// desc = "A profane dagger made of cursed black steel. Whispers emanate from the gem on its hilt."
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/peculate)
	sellprice = 250
	icon_state = "pdagger"
	melting_material = null
	embedding = list("embed_chance" = 0) // Embedding the cursed dagger has the potential to cause duping issues. Keep it like this unless you want to do a lot of bug hunting.
	resistance_flags = INDESTRUCTIBLE
	stealthy_audio = TRUE

/obj/item/weapon/knife/dagger/steel/profane/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ASSASSIN))
		. += "profane dagger whispers, \"[span_danger("Here we are!")]\""

/obj/item/weapon/knife/dagger/steel/profane/pickup(mob/living/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!HAS_TRAIT(H, TRAIT_ASSASSIN)) // Non-assassins don't like holding the profane dagger.
			H.add_stress(/datum/stress_event/profane)
			to_chat(M, "<span class='danger'>Your breath chills as you pick up the dagger. You feel a sense of morbid wrongness!</span>")
			var/message = pick(
				"<span class='danger'>Help me...</span>",
				"<span class='danger'>Save me...</span>",
				"<span class='danger'>It's cold...</span>",
				"<span class='danger'>Free us...please...</span>",
				"<span class='danger'>Necra...deliver...us...</span>")
//			H.visible_message("profane dagger whispers, \"[message]\"")
			to_chat(M, "profane dagger whispers, \"[message]\"")
		else
			var/message = pick(
				"<span class='danger'>Why...</span>",
				"<span class='danger'>...Who sent you?</span>",
				"<span class='danger'>...You will burn for what you've done...</span>",
				"<span class='danger'>I hate you...</span>",
				"<span class='danger'>Someone stop them!</span>",
				"<span class='danger'>Guards! Help!</span>",
				"<span class='danger'>...What's that in your hand?</span>",
				"<span class='danger'>...You love me...don't you?</span>",
				"<span class='danger'>Wait...don't I know you?</span>",
				"<span class='danger'>I thought you were...my friend...</span>",
				"<span class='danger'>How long have I been in here...</span>")
//			H.visible_message("profane dagger whispers, \"[message]\"")
			to_chat(M, "profane dagger whispers, \"[message]\"")

/obj/item/weapon/knife/dagger/steel/profane/pre_attack(mob/living/carbon/human/target, mob/living/user = usr, params)
	if(!istype(target))
		return FALSE
	if(target.has_flaw(/datum/charflaw/hunted) || HAS_TRAIT(target, TRAIT_ZIZOID_HUNTED)) // Check to see if the dagger will do 20 damage or 14
		force = DAMAGE_KNIFE * 2
	else
		force = DAMAGE_DAGGER + 2
	return FALSE

/obj/item/weapon/knife/dagger/steel/profane/afterattack(mob/living/carbon/human/target, mob/living/user = usr, proximity)
	. = ..()
	if(!ishuman(target))
		return
	if(target.stat == DEAD || (target.health < target.crit_threshold)) // Trigger soul steal or identity theft if the target is either dead or in crit
		if(istype(user.used_intent, /datum/intent/peculate))
			if(!ishuman(user)) // carbons don't have all features of a human
				to_chat(user, span_danger("You can't do that!"))
				return
			var/obj/item/bodypart/head/target_head = target.get_bodypart(BODY_ZONE_HEAD)
			if(QDELETED(target_head))
				to_chat(user, span_notice("I need their head or else I can't take their face!"))
				return
			if(!(target.dna?.species.id in RACES_PLAYER_ALL))
				to_chat(user, span_warning("I can't steal this face!"))
				return
			var/datum/beam/transfer_beam = user.Beam(target, icon_state = "drain_life", time = 6 SECONDS)

			playsound(
				user,
				get_sfx("changeling_absorb"), //todo: turn sound keys into defines.
				100,
			)
			to_chat(user, span_danger("I start absorbing [target]'s identity."))
			if(!do_after(user, 3 SECONDS, target = target))
				qdel(transfer_beam)
				return

			playsound( // and anotha one
				user,
				get_sfx("changeling_absorb"),
				100,
			)

			if(!do_after(user, 3 SECONDS, target = target))
				qdel(transfer_beam)
				return

			if(!user.client)
				qdel(transfer_beam)
				return
			qdel(transfer_beam)

			var/mob/living/carbon/human/human_user = user

			human_user.copy_physical_features(target)
			to_chat(user, span_purple("I take on a new face.."))
			ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)

			return

		if(target.has_flaw(/datum/charflaw/hunted) || HAS_TRAIT(target, TRAIT_ZIZOID_HUNTED)) // The profane dagger only thirsts for those who are hunted, by flaw or by zizoid curse.
			if(target.client == null) //See if the target's soul has left their body
				to_chat(user, "<span class='danger'>Your target's soul has already escaped its corpse...you try to call it back!</span>")
				get_profane_ghost(target,user) //Proc to capture a soul that has left the body.
			else
				user.adjust_triumphs(1)
				init_profane_soul(target, user) //If they are still in their body, send them to the dagger!

/obj/item/weapon/knife/dagger/steel/profane/proc/init_profane_soul(mob/living/carbon/human/target, mob/user)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_ASSASSINATIONS)
	var/mob/dead/observer/profane/S = new /mob/dead/observer/profane(src)
	S.AddComponent(/datum/component/profaned, src)
	S.name = "soul of [target.real_name]"
	S.real_name = "soul of [target.real_name]"
	S.deadchat_name = target.real_name
	S.ManualFollow(src)
	S.key = target.key
	S.language_holder = target.language_holder.copy(S)
	target.visible_message("<span class='danger'>[target]'s soul is pulled from their body and sucked into the profane dagger!</span>", "<span class='danger'>My soul is trapped within the profane dagger. Damnation!</span>")
	playsound(src, 'sound/magic/soulsteal.ogg', 100, extrarange = 5)
	blade_int = max_blade_int // Stealing a soul successfully sharpens the blade.
	repair_damage(max_integrity) // And fixes the dagger. No blacksmith required!

/obj/item/weapon/knife/dagger/steel/profane/proc/get_profane_ghost(mob/living/carbon/human/target, mob/user)
	var/mob/dead/observer/chosen_ghost
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit() //Check if a soul has already gone to the underworld
	if(underworld_spirit) // If they are in the underworld, pull them back to the real world and make them a normal ghost. Necra can't save you now!
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		chosen_ghost = ghost.get_ghost(TRUE,TRUE)
	else //Otherwise, try to get a ghost from the real world
		chosen_ghost = target.get_ghost(TRUE,TRUE)
	if(!chosen_ghost || !chosen_ghost.client) // If there is no valid ghost or if that ghost has no active player
		return FALSE
	user.adjust_triumphs(1)
	init_profane_soul(target, user) // If we got the soul, store them in the dagger.
	qdel(chosen_ghost) // Get rid of that ghost!
	return TRUE

/obj/item/weapon/knife/dagger/steel/profane/proc/release_profane_souls(mob/user) // For ways to release the souls trapped within a profane dagger, such as a Necrite burial rite. Returns the number of freed souls.
	var/freed_souls = 0
	for(var/mob/dead/observer/profane/A in src) // for every trapped soul in the dagger, whether they have left the game or not
		to_chat(A, "<b>I have been freed from my vile prison, I await Necra's cold grasp. Salvation!</b>")
		A.returntolobby() //Send the trapped soul back to the lobby
		user.visible_message("<span class='warning'>The [A.name] flows out from the profane dagger, finally free of its grasp.</span>")
		freed_souls += 1
	user.visible_message("<span class='warning'>The profane dagger shatters into putrid smoke!</span>")
	qdel(src) // Delete the dagger. Forevermore.
	return freed_souls

/datum/component/profaned
	var/atom/movable/container

/datum/component/profaned/Initialize(atom/movable/container)
	if(!istype(parent, /mob/dead/observer/profane))
		return COMPONENT_INCOMPATIBLE
	var/mob/dead/observer/profane/S = parent

	src.container = container

	S.forceMove(container)

//................ Stone Knife ............... //
/obj/item/weapon/knife/stone
	force = DAMAGE_KNIFE
	throwforce = DAMAGE_KNIFE
	possible_item_intents = list(/datum/intent/dagger/cut,/datum/intent/dagger/chop)
	name = "stone knife"
	desc = "A tool favored by the wood-elves, easy to make, useful for skinning the flesh of beast and man alike."
	icon_state = "stone_knife"
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	max_integrity = INTEGRITY_WORST - 70
	max_blade_int = 30
	wdefense = TERRIBLE_PARRY
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	sellprice = 5

/obj/item/weapon/knife/stone/kukri
	name = "joapstone kukri"
	desc = "A kukri made out of joapstone. It's more of a ceremonial piece than it is an implement of war, it's somewhat fragile. Be gentle with it."
	icon = 'icons/roguetown/gems/gem_jade.dmi'
	icon_state = "kukri_jade"
	max_integrity = INTEGRITY_POOR - 100
	max_blade_int = 35
	wdefense = AVERAGE_PARRY
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sellprice = 75

/obj/item/weapon/knife/stone/opal
	name = "opaloise knife"
	desc = "A beautiful knife carved out of opaloise. It's not intended for combat. Its presence is vital in some Crimson Elven ceremonies."
	icon = 'icons/roguetown/gems/gem_opal.dmi'
	icon_state = "knife_opal"
	max_integrity = INTEGRITY_POOR - 100
	max_blade_int = 35
	wdefense = AVERAGE_PARRY
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sellprice = 105
//................ Villager Knife ............... //
/obj/item/weapon/knife/villager
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	name = "villager knife"
	desc = "The loyal companion of simple peasants, able to cut hard bread and carve wood. A versatile kitchen utensil and tool."
	icon_state = "villagernife"
	melting_material = /datum/material/iron
	melt_amount = 25

/obj/item/weapon/knife/copper
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	name = "copper knife"
	desc = "A knife of an older design, the copper serves decent enough."
	icon_state = "cdagger"
	max_blade_int = 75
	max_integrity = INTEGRITY_WORST - 25
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/knives
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	melting_material = /datum/material/copper
	melt_amount = 50
	sellprice = 10


/obj/item/weapon/knife/throwingknife
	name = "iron tossblade"
	desc = ""
	item_state = "bone_dagger"
	force = DAMAGE_DAGGER
	throwforce = DAMAGE_DAGGER + 13
	throw_speed = 4
	max_integrity = INTEGRITY_WORST - 50
	wdefense = 1
	icon_state = "throw_knifei"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 25, "embedded_fall_chance" = 20)
	melting_material = /datum/material/iron
	melt_amount = 50
	sellprice = 3

/obj/item/weapon/knife/throwingknife/bronze
	name = "bronze tossblade"
	desc = "A tossblade forged from bronze. It's not as reliable compared to other tossblades, but it's much cheaper to make."
	item_state = "bone_dagger"
	force = DAMAGE_DAGGER
	throwforce = DAMAGE_DAGGER + 10
	throw_speed = 4
	max_integrity = INTEGRITY_WORST - 30
	wdefense = 1
	icon_state = "throwing_bronze"
	embedding = list("embedded_pain_multiplier" = 3, "embed_chance" = 20, "embedded_fall_chance" = 15)
	melting_material = /datum/material/bronze
	melt_amount = 50
	sellprice = 2

/obj/item/weapon/knife/throwingknife/steel
	name = "steel tossblade"
	desc = ""
	icon_state = "throw_knifes"
	item_state = "bone_dagger"
	throw_speed = 4
	max_integrity = INTEGRITY_WORST
	wdefense = 1
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 30, "embedded_fall_chance" = 15)
	melt_amount = 50
	sellprice = 4

/obj/item/weapon/knife/throwingknife/psydon
	name = "psydonian tossblade"
	desc = "An unconventional method of delivering silver to a heretic; but one PSYDON smiles at, all the same. Doubles as an 'actual' knife in a pinch."
	icon_state = "throw_knifes"
	item_state = "bone_dagger"
	throw_speed = 4
	max_integrity = INTEGRITY_POOR
	wdefense = 3
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 0)
	sellprice = 65
	melting_material = /datum/material/silver
	melt_amount = 50

/obj/item/weapon/knife/throwingknife/psydon/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/weapon/knife/throwingknife/rous
	name = "rous kunai"
	desc = "A typical knife used by rous assassins. Quite effective when thrown."
	icon_state = "rouskunai"
	throw_speed = 4
	wdefense = 3
	max_integrity = INTEGRITY_POOR
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 30, "embedded_fall_chance" = 15)
	sellprice = 5
	melt_amount = 50

/obj/item/weapon/knife/throwingknife/throwcard
	name = "Calling Card"
	desc = "A thin sheet of pig-iron stamped into a calling card, too thin and useless to be smelted. You've been had. From Heartfelt with love."
	icon_state = "throwcard"
	throw_speed = 5
	max_integrity = INTEGRITY_WORST - 50 // It's not about how effective it is, it's about sending a message.
	embedding = list("embedded_pain_multiplier" = 2, "embed_chance" = 50, "embedded_fall_chance" = 5)
	sellprice = 2
