/obj/item/weapon/scabbard
	icon = 'icons/roguetown/weapons/32/scabbard.dmi'
	alternate_worn_layer = UNDER_CLOAK_LAYER

	resistance_flags = FLAMMABLE
	parrysound = "parrywood"
	attacked_sound = "parrywood"
	sharpness = IS_BLUNT
	blade_dulling = DULLING_BASHCHOP
	wdefense = BAD_PARRY
	max_integrity = INTEGRITY_WORST
	possible_item_intents = list(SHIELD_BASH)

/obj/item/weapon/scabbard/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)

/obj/item/weapon/scabbard/update_icon_state()
	icon_state = initial(icon_state)
	item_state = initial(item_state)

	if(length(contents))
		var/obj/item/sheathed_weapon = contents[1]
		var/icon/possible_sheaths = icon(icon) //hehe
		var/list/extensions = list()
		for(var/s in possible_sheaths.IconStates(1))
			extensions[s] = TRUE
		qdel(possible_sheaths)
		if(extensions[icon_state+"_[sheathed_weapon.icon_state]"])
			icon_state += "_[sheathed_weapon.icon_state]"
		else
			icon_state += "-sheathed"
	return ..()

/*
	GENERIC SCABBARDS
*/
/obj/item/weapon/scabbard/knife
	name = "knife sheath"
	desc = "A slingable sheath made of leather, meant to host surprises of smaller sizes."
	icon_state = "sheath"
	force = DAMAGE_KNIFE - 7
	throwforce = DAMAGE_KNIFE - 7
	wdefense = MEDIOCRE_PARRY
	wbalance = HARD_TO_DODGE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK|ITEM_SLOT_WRISTS|ITEM_SLOT_NECK
	associated_skill = /datum/skill/combat/knives
	sewrepair = TRUE
	sellprice = 10
	experimental_onback = FALSE
	experimental_onhip = FALSE

	grid_width = 32
	grid_height = 64

/obj/item/weapon/scabbard/knife/apply_components()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, slot_flags|ITEM_SLOT_HANDS)
	AddComponent(/datum/component/storage/concrete/scabbard/knife)

/obj/item/weapon/scabbard/knife/getonmobprop(tag)
	..()

	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5, "sx" = -6, "sy" = -1, "nx" = 6, "ny" = -1, "wx" = 0, "wy" = -2, "ex" = 0, "ey" = -2, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 1, "sflip" = 1, "wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.4, "sx" = -3, "sy" = -1, "nx" = 0, "ny" = 0, "wx" = -4, "wy" = 0, "ex" = 2, "ey" = 1, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 0, "sturn" = 10, "wturn" = 32, "eturn" = -23, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5, "sx" = -2, "sy" = -5, "nx" = 4, "ny" = -5, "wx" = 0, "wy" = -5, "ex" = 2, "ey" = -5, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 1)

/obj/item/weapon/scabbard/knife/noble
	name = "silver decorated knife sheath"
	desc = "A slingable sheath made of leather, enamored with elaborate silver decorations, often seen on the hips of nobles"
	icon_state = "nsheath"
	sellprice = 50

/obj/item/weapon/scabbard/knife/royal
	name = "gold decorated knife sheath"
	desc = "A slingable sheath made of leather, enamored with exquisite golden decorations, often seen on the hips of royalty"
	icon_state = "rsheath"
	sellprice = 100

/obj/item/weapon/scabbard/sword
	name = "scabbard"
	desc = "A scabbard designed to hold a sword. The natural conclusion for those wishing to carry longblades."
	icon_state = "scabbard"
	force = DAMAGE_SWORD - 15
	force_wielded = DAMAGE_SWORD - 15
	wdefense = GREAT_PARRY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	anvilrepair = /datum/skill/craft/carpentry
	associated_skill = /datum/skill/combat/swords
	sellprice = 10

/obj/item/weapon/scabbard/sword/apply_components()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, slot_flags|ITEM_SLOT_HANDS)
	AddComponent(/datum/component/storage/concrete/scabbard/sword)

/obj/item/weapon/scabbard/sword/getonmobprop(tag)
	. = ..()

	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6, "sx" = -6, "sy" = -1, "nx" = 6, "ny" = -1, "wx" = 0, "wy" = -2, "ex" = 0, "ey" = -2, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 1, "sflip" = 0, "wflip" = 1, "eflip" = 0)
			if("onback")
				return list("shrink" = 0.5, "sx" = 1, "sy" = 4, "nx" = 1, "ny" = 2, "wx" = 3, "wy" = 3, "ex" = 0, "ey" = 2, "nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0, "nflip" = 8, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt")
				return list("shrink" = 0.5, "sx" = -2, "sy" = -5, "nx" = 4, "ny" = -5, "wx" = 0, "wy" = -5, "ex" = 2, "ey" = -5, "nturn" = 0, "sturn" = 0, "wturn" = -90, "eturn" = 0, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 1)

/obj/item/weapon/scabbard/sword/noble
	name = "silver decorated scabbard"
	desc = "A scabbard designed to hold a sword. This one is decorated on a silver platter."
	icon_state = "nscabbard"
	sellprice = 50

/obj/item/weapon/scabbard/sword/royal
	name = "gold decorated scabbard"
	desc = "A scabbard designed to hold a sword. This one is lined with golden fittings, fit for a royal."
	icon_state = "rscabbard"
	sellprice = 100

/obj/item/weapon/scabbard/cane
	name = "fancy cane"
	desc = "A polished, dark wooden cane, decorated with gold and silver. Often carried by nobility, even those without a limp, simply to flaunt their wealth to the peasantry. This one contains a concealed blade!"
	icon_state = "canesheath"
	force = DAMAGE_MACE - 4
	force_wielded = DAMAGE_MACE - 2
	wdefense = MEDIOCRE_PARRY
	sellprice = 45

	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_BULKY
	anvilrepair = /datum/skill/craft/carpentry
	associated_skill = /datum/skill/combat/swords

/obj/item/weapon/scabbard/cane/courtphysician
	name = "fancy cane"
	desc = "A decorated cane bearing the visage of a vulture."
	icon_state = "doccanesheath"

/obj/item/weapon/scabbard/cane/apply_components()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, slot_flags|ITEM_SLOT_HANDS)
	AddComponent(/datum/component/storage/concrete/scabbard/sword)

/obj/item/weapon/scabbard/cane/getonmobprop(tag)
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



/obj/item/weapon/scabbard/kazengun
	name = "simple eastern scabbard"
	desc = "A piece of steel lined with wood. Great for batting away blows."
	icon_state = "kazscab"
	item_state = "kazscab"
	force = DAMAGE_SWORD - 15
	force_wielded = DAMAGE_SWORD - 15
	wdefense = GREAT_PARRY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	anvilrepair = /datum/skill/craft/carpentry
	associated_skill = /datum/skill/combat/shields
	max_integrity = INTEGRITY_STANDARD
	sellprice = 10

/obj/item/weapon/scabbard/kazengun/apply_components()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob, slot_flags|ITEM_SLOT_HANDS)
	AddComponent(/datum/component/storage/concrete/scabbard/kazengun)

/obj/item/weapon/scabbard/kazengun/steel
	name = "hwang scabbard"
	desc = "A cloud-patterned scabbard with a cloth sash. Used for blocking."
	icon_state = "kazscab_steel"
	item_state = "kazscab_steel"
	max_integrity = INTEGRITY_STRONG

/obj/item/weapon/scabbard/kazengun/gold
	name = "gold-stained Xinyi scabbard"
	desc = "An ornate, wooden scabbard with a sash. Great for parrying."
	icon_state = "kazscab_gold"
	item_state = "kazscab_gold"
	max_integrity = INTEGRITY_STRONGEST
