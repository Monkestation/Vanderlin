/obj/item/weapon/knife/dagger/steel/zizo_dagger
	name = "darksteel dagger"
	desc = "A vile dagger made of darksteel."
	icon_state = "zizodagger"
	sellprice = 0 // Super evil Zizo sword, nobody wants this
	melting_material = /datum/material/avantyne

/obj/item/weapon/sword/arming/zizo_arming
	name = "darksteel arming sword"
	desc = "A short dark red blade, built upon a reliable design that has served for centuries. Called forth from Her will, if you wield this blade you are to be feared, if you do not, you are dead."
	icon_state = "zizoarming"
	sellprice = 0 // Super evil Zizo sword, nobody wants this
	smeltresult = /obj/item/ingot/avantyne

/obj/item/weapon/sword/rapier/zizo_rapier
	name = "darksteel rapier"
	desc = "A tapered dark red blade with a specialized stabbing tip. Called forth from Her will, if you wield this blade you are to be feared, if you do not, you are dead."
	icon_state = "zizorapier"
	sellprice = 0 // Super evil Zizo sword, nobody wants this
	smeltresult = /obj/item/ingot/avantyne

/obj/item/weapon/sword/long/zizo_longsword
	name = "darksteel longsword"
	desc = "A long dark red hand-and-a-half blade. Called forth from Her will, if you wield this blade you are to be feared, if you do not, you are dead."
	icon = 'icons/roguetown/weapons/64/swords.dmi'
	icon_state = "zizolongsword"
	sellprice = 0 // Super evil Zizo sword, nobody wants this
	smeltresult = /obj/item/ingot/avantyne

/obj/item/weapon/sword/long/greatsword/claymore/zizo_greatsword
	name = "darksteel greatsword"
	desc = "A dark red blade of dangerous proportions. Called forth from Her will, if you wield this blade you are to be feared, if you do not, you are dead."
	icon_state = "zizogsw"
	sellprice = 0 // Super evil Zizo sword, nobody wants this
	item_weight = 2.4 KILOGRAMS
	melting_material = /datum/material/avantyne

/obj/item/weapon/sword/long/greatsword/zizo_kriegsmesser
	name = "darksteel kriegsmesser"
	desc = "A dark red curved blade. Called forth from Her will, if you wield this blade you are to be feared, if you do not, you are dead."
	icon_state = "zizosword"
	wdefense = ULTMATE_PARRY
	sellprice = 0 // Super evil Zizo sword, nobody wants this
	item_weight = 2.3 KILOGRAMS
	melting_material = /datum/material/avantyne

/obj/item/weapon/sword/long/greatsword/zizo_kriegsmesser/getonmobprop(tag)
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

