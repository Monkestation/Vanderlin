//copper tools

/obj/item/weapon/hoe/copper
	name = "copper hoe"
	desc = ""
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "choe"
	force = DAMAGE_STAFF
	force_wielded = DAMAGE_STAFF_WIELD
	possible_item_intents = list(INTENT_USE)
	experimental_inhand = TRUE
	experimental_onback = TRUE
	experimental_onhip = TRUE
	smeltresult = /obj/item/ingot/copper
	time_multiplier = 0.5

/obj/item/weapon/sickle/copper
	name = "copper sickle"
	desc = ""
	icon = 'icons/roguetown/weapons/tools.dmi'
	icon_state = "csickle"
	smeltresult = /obj/item/ingot/copper

/obj/item/weapon/pitchfork/copper
	name = "copper fork"
	desc = "A simple and rustic tool for working the fields, not a very effective weapon."
	icon_state = "cpitchfork"
	item_state = "pitchfork"
	force_wielded = DAMAGE_SPEAR
	wdefense = AVERAGE_PARRY
	experimental_inhand = TRUE
	experimental_onback = TRUE
	experimental_onhip = TRUE
	smeltresult = /obj/item/ingot/copper

/obj/item/weapon/pitchfork/copper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 0,"nx" = 8,"ny" = 0,"wx" = -5,"wy" = 0,"ex" = 0,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -32,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = -4,"nx" = 3,"ny" = -3,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 45,"sturn" = 135,"wturn" = -45,"eturn" = 45,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
