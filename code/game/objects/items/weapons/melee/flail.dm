/* FLAILS - Zero wdefense, can´t parry, best AP
==========================================================*/
/obj/item/weapon/flail
	name = "military flail"
	desc = "A sturdy handle affixed to a cruel spiked ball with a harrowing metal chain."
	icon_state = "iflail"
	icon = 'icons/roguetown/weapons/32/whips_flails.dmi'
	force = DAMAGE_NORMAL_FLAIL
	throwforce = DAMAGE_WEAK_FLAIL - 12
	can_parry = FALSE // You can't parry with this, it'd be awkward to tangle chains, use a shield
	wdefense = TERRIBLE_PARRY
	wlength = WLENGTH_NORMAL
	possible_item_intents = list(FLAIL_STRIKE, FLAIL_SMASH)
	max_integrity = INTEGRITY_STRONG
	minstr = 6

	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/combat/whipsflails
	melting_material = /datum/material/iron
	melt_amount = 100
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	swingsound = BLUNTWOOSH_MED
	sellprice = 20

	grid_width = 32
	grid_height = 96

/obj/item/weapon/flail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


//................ Militia Flail ............... //
/obj/item/weapon/flail/militia
	name = "militia flail"
	desc = "A lucky hit from such a flail can squash a cheap helmet along with the wearer's skull."
	icon_state = "militiaflail"

//................ Wooden Flail ............... // Obsolete by the thresher? No smash so its bad
/obj/item/weapon/flail/towner
	name = "wooden flail"
	desc = "During peacetime these flails are used to thresh wheat. During wartime - to chase off marauders."
	icon_state = "peasantflail"
	force = DAMAGE_WEAK_FLAIL
	possible_item_intents = list(MACE_WDSTRIKE)
	gripped_intents = list(FLAIL_THRESH, MACE_WDSTRIKE)
	max_integrity = INTEGRITY_STANDARD
	minstr = 5
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	sellprice = 10


//................ Steel Flail ............... //
/obj/item/weapon/flail/sflail
	name = "steel flail"
	desc = "A knightly flail made of worked steel, with a flanged head. An effective and brutal design."
	icon_state = "flail"
	force = DAMAGE_GOOD_FLAIL
	max_integrity = INTEGRITY_STRONGEST
	minstr = 4
	melting_material = /datum/material/steel
	melt_amount = 75
	sellprice = 35

/obj/item/weapon/flail/sflail/ancient
	name = "ancient flail"
	desc = "An ancient knightly flail made of worked steel, with a flanged head. An effective and brutal design."
	icon_state = "aflail"

/obj/item/weapon/flail/sflail/necraflail
	name = "swift journey"
	desc = "The striking head resembles Necra's original skull, striking true with a sculpted emblem of love and sacrifice. Perhaps one of the few Psydonic-designed emblems of The Ten left."
	icon = 'icons/roguetown/weapons/32/patron.dmi'
	icon_state = "necraflail"

//................ Psydon Flail ............... //
/obj/item/weapon/flail/psydon
	name = "psydonian flail"
	desc = "A flail fashioned with the iconography of Psydon, and crafted entirely out of silver."
	icon = 'icons/roguetown/weapons/32/psydonite.dmi'
	icon_state = "psyflail"
	force = DAMAGE_GOOD_FLAIL
	max_integrity = INTEGRITY_STRONGEST
	minstr = 4
	melting_material = /datum/material/silver
	melt_amount = 75
	sellprice = 50
	last_used = 0

/obj/item/weapon/flail/psydon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/psyblessed, FALSE, 3, FALSE, 50, 1, TRUE)

/obj/item/weapon/flail/psydon/relic
	name = "Consecratia"
	desc = "The weight of His anguish, His pain, His hope and His love for humenkind - all hanging on this ornamental silver-steel head chained to this arm. A declaration of love for all that Psydon lives for, and a crushing reminder that the Ordo Benetarus will endure anything to defend it."
	icon_state = "psymorningstar"


//................ Peasant Flail ............... // A little confusing still
/obj/item/weapon/flail/peasant
	name = "peasant flail"
	desc = "What used to be a humble thresher by design, has become a deadly flail with extended range and punch. Favored by the peasantry militia or knight errants."
	icon = 'icons/roguetown/weapons/64/flails.dmi'
	icon_state = "bigflail"
	force = DAMAGE_NORMAL_FLAIL
	force_wielded = DAMAGE_GOOD_FLAIL
	wbalance = DODGE_CHANCE_NORMAL
	wlength = WLENGTH_LONG
	possible_item_intents = list(FLAIL_LNGSTRIKE)
	gripped_intents = list(FLAIL_LNGSTRIKE, FLAIL_LNGSMASH)
	max_integrity = INTEGRITY_STRONG + 50
	minstr = 8

	bigboy = TRUE
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	sellprice = 20

/obj/item/weapon/flail/peasant/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/weapon/flail/peasantwarflail //Unattainable
	name = "militia thresher"
	desc = "Just like how a sling's bullet can fell a giant, so too does this great flail follow the principle of converting 'momentum' into 'plate-rupturing force'."
	icon = 'icons/roguetown/weapons/64/flails.dmi'
	icon_state = "peasantwarflail"
	force = DAMAGE_WEAK_FLAIL - 7
	force_wielded = DAMAGE_GOOD_FLAIL + 2
	wbalance = VERY_HARD_TO_DODGE
	wlength = WLENGTH_GREAT
	possible_item_intents = list(FLAIL_STRIKE)
	gripped_intents = list(FLAIL_LNGSTRIKE, FLAIL_LNGSMASH)
	minstr = 9

	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	anvilrepair = /datum/skill/craft/carpentry
	dropshrink = 0.9
	blade_dulling = DULLING_BASH
	resistance_flags = FLAMMABLE

/obj/item/weapon/flail/peasantwarflail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/weapon/flail/peasantwarflail/matthios
	name = "Gilded Flail"
	desc = "Weight of wealth in a deadly striking end."
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "matthiosflail"
	force_wielded = DAMAGE_GOOD_FLAIL + 7
	possible_item_intents = list(MATTHIOS_STRIKE)
	gripped_intents = list(MATTHIOS_STRIKE, MATTHIOS_SMASH)
	slot_flags = ITEM_SLOT_BACK
	blade_dulling = DULLING_BASHCHOP
	anvilrepair = /datum/skill/craft/weaponsmithing
	melting_material = /datum/material/steel
	melt_amount = 150
	sellprice = 250
