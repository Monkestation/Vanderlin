///basically subtypes of these process kinda like a machine but don't
///need the entire machine
/obj/structure/fake_machine
	destroy_sound = 'sound/foley/breaksound.ogg'
	break_sound = 'sound/foley/machinebreak.ogg'
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE

/obj/structure/fake_machine/proc/budget2change(budget, mob/user, specify)
	var/turf/T
	if(!user || (!ismob(user)))
		T = get_turf(src)
	else
		T = get_turf(user)
	if(!budget || budget <=0)
		return
	budget = floor(budget)
	var/type_to_put
	var/zenars_to_put
	if(specify)
		switch(specify)
			if("GOLD")
				zenars_to_put = budget/10
				type_to_put = /obj/item/coin/gold
			if("SILVER")
				zenars_to_put = budget/5
				type_to_put = /obj/item/coin/silver
			if("BRONZE")
				zenars_to_put = budget
				type_to_put = /obj/item/coin/copper
			if("MARQUE")
				zenars_to_put = budget
				type_to_put = /obj/item/coin/inqcoin
	else
		var/highest_found = FALSE
		var/zenars = floor(budget/10)
		if(zenars)
			budget -= zenars * 10
			highest_found = TRUE
			type_to_put = /obj/item/coin/gold
			zenars_to_put = zenars
		zenars = floor(budget/5)
		if(zenars)
			budget -= zenars * 5
			if(!highest_found)
				highest_found = TRUE
				type_to_put = /obj/item/coin/silver
				zenars_to_put = zenars
			else
				new /obj/item/coin/silver(T, zenars)
		if(budget >= 1)
			if(!highest_found)
				type_to_put = /obj/item/coin/copper
				zenars_to_put = budget
			else
				new /obj/item/coin/copper(T, budget)
	if(!type_to_put || zenars_to_put < 1)
		return

	var/stacks = CEILING(zenars_to_put / 20, 1)
	for(var/i in 1 to stacks)
		var/zenar_value = min(floor(zenars_to_put), 20)
		var/obj/item/coin/G = new type_to_put(T, zenar_value)
		zenars_to_put -= zenar_value
		G.pixel_y = G.base_pixel_y + rand(-4, 4)
		G.pixel_x = G.base_pixel_x + rand(-4, 4)

		if(user)
			user.put_in_hands(G)

	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
