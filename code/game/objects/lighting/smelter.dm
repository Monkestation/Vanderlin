/obj/machinery/light/fueled/smelter
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "stone furnace"
	desc = "A stone furnace, weathered by time and heat."
	icon_state = "cavesmelter0"
	base_state = "cavesmelter"
	anchored = TRUE
	density = TRUE
	climbable = TRUE
	climb_time = 0
	climb_offset = 10
	on = TRUE
	temperature_change = 80
	var/list/ore = list()
	var/maxore = 1
	var/cooking = 0
	var/actively_smelting = FALSE // Are we currently smelting?
	var/max_crucible_temperature = 1850
	fueluse = 30 MINUTES
	crossfire = FALSE

/obj/machinery/light/fueled/smelter/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(istype(W, /obj/item/weapon/tongs))
		if(!actively_smelting) // Prevents an exp gain exploit. - Foxtrot
			var/obj/item/weapon/tongs/T = W
			if(ore.len && !T.held_item)
				var/obj/item/I = ore[ore.len]
				ore -= I
				I.forceMove(T)
				T.held_item = I
				if(user.mind && isliving(user) && T.held_item?:smeltresult) // Prevents an exploit with coal and runtimes with everything else
					if(!istype(T.held_item, /obj/item/ore) && T.held_item?:smelted) // Burning items to ash won't level smelting.
						var/mob/living/L = user
						var/boon = user.get_learning_boon(/datum/skill/craft/smelting)
						var/amt2raise = L.STAINT*2 // Smelting is already a timesink, this is justified to accelerate levelling
						if(amt2raise > 0)
							user.adjust_experience(/datum/skill/craft/smelting, amt2raise * boon, FALSE)
							SEND_SIGNAL(user, COMSIG_ITEM_SMELTED)
				user.visible_message("<span class='info'>[user] retrieves [I] from [src].</span>")
				if(on)
					var/tyme = world.time
					T.hott = tyme
					T.proxy_heat(150, max_crucible_temperature)
					addtimer(CALLBACK(T, TYPE_PROC_REF(/obj/item/weapon/tongs, make_unhot), tyme), 50)
					if(istype(T, /obj/item/weapon/tongs/stone))
						T.take_damage(1, BRUTE, "blunt")
				T.update_appearance(UPDATE_ICON_STATE)
				return

			for(var/obj/item/storage/crucible/crucible in contents)
				user.visible_message("[user] starts removing a crucible from [src]!", "You start removing a crucible from [src]!")
				if(!do_after(user, 1.5 SECONDS, src))
					return
				crucible.forceMove(T)
				T.held_item = crucible
				T.update_appearance(UPDATE_ICON_STATE)
				return
			if(on)
				to_chat(user, "<span class='info'>Nothing to retrieve from inside.</span>")
				return // Safety for not smelting our tongs
		else
			to_chat(user, "<span class='warning'>\The [src] is currently smelting. Wait for it to finish, or douse it with water to retrieve items from it.</span>")
			return

	if(W.firefuel)
		if(alert(usr, "Fuel \the [src] with [W]?", "VANDERLIN", "Fuel", "Smelt") == "Fuel")
			return ..()

	if(istype(W, /obj/item/storage/crucible))
		W.forceMove(src)
		user.visible_message("Loads a crucible into [src].", "You load a crucible into [src].")
		return ..()

	if(W.smeltresult)
		if(ore.len < maxore)
			if(!(W in user.held_items) || !user.temporarilyRemoveItemFromInventory(W))
				return
			W.forceMove(src)
			ore += W
			if(!isliving(user) || !user.mind)
				ore[W] = SMELTERY_LEVEL_SPOIL
			else
				var/smelter_exp = user.get_skill_level(/datum/skill/craft/smelting) // 0 to 6
				if(smelter_exp < 6)
					ore[W] = floor(rand(smelter_exp*15, max(63, smelter_exp*25))/25) // Math explained below
				else
					ore[W] = floor(min(3, smelter_exp)) // Guarantees a return of 3 no matter how extra experience past 3000 you have.
				/*
				RANDOMLY PICKED NUMBER ACCORDING TO SMELTER SKILL:
					NO SKILL: 		between 00 and 63
					WEAK:	 		between 15 and 63
					AVERAGE:	 	between 30 and 63
					SKILLED: 		between 45 and 75
					EXPERT: 		between 60 and 100
					MASTER: 		between 75 and 125
					LEGENDARY: 		between 90 and 150

				PICKED NUMBER GETS DIVIDED BY 25 AND ROUNDED DOWN TO CLOSEST INTEGER.
				RESULT DETERMINES QUALITY OF BAR. SEE code/__DEFINES/skills.dm
					0 = SPOILED
					1 = POOR
					2 = NORMAL
					3 = GOOD
				*/
			user.visible_message("<span class='warning'>[user] puts something in \the [src].</span>")
			cooking = 0
			return
		else
			to_chat(user, "<span class='warning'>\The [W.name] [W.smeltresult? "can" : "can't"] be smelted, but \the [src] is full.</span>")
	else
		if(!W.firefuel && !istype(W, /obj/item/flint) && !istype(W, /obj/item/flashlight/flare/torch) && !istype(W, /obj/item/ore/coal))
			to_chat(user, "<span class='warning'>\The [W.name] cannot be smelted.</span>")
	return ..()

// Gaining experience from just retrieving bars with your hands would be a hard-to-patch exploit.
/obj/machinery/light/fueled/smelter/attack_hand(mob/user, list/modifiers)
	if(on)
		to_chat(user, "<span class='warning'>It's too hot to retrieve bars with your hands.</span>")
		return
	if(ore.len)
		var/obj/item/I = ore[ore.len]
		ore -= I
		I.loc = user.loc
		user.put_in_active_hand(I)
		user.visible_message("<span class='info'>[user] retrieves \the [I] from \the [src].</span>")
	else
		return ..()


/obj/machinery/light/fueled/smelter/process()
	..()
	if(maxore > 1)
		return
	if(!on)
		return
	if(!length(ore))
		return
	if(cooking < 20)
		cooking++
		playsound(src,'sound/misc/smelter_sound.ogg', 50, FALSE)
		actively_smelting = TRUE
		return
	if(cooking == 20)
		for(var/obj/item/I in ore)
			if(I.smeltresult)
				var/obj/item/R = new I.smeltresult(src, ore[I])
				ore -= I
				ore += R
				qdel(I)
		playsound(src,'sound/misc/smelter_fin.ogg', 100, FALSE)
		visible_message(span_notice("[src] finished smelting."))
		cooking = 21
		actively_smelting = FALSE

/obj/machinery/light/fueled/smelter/burn_out()
	cooking = 0
	actively_smelting = FALSE
	..()

/obj/machinery/light/fueled/smelter/great
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "great furnace"
	desc = "The pinnacle of dwarven engineering and the miracle of Malum's blessed fire crystal, allowing for greater alloys to be made."
	icon_state = "smelter0"
	base_state = "smelter"
	anchored = TRUE
	density = TRUE
	maxore = 4
	fueluse = 5 MINUTES
	climbable = FALSE
	max_crucible_temperature = 2000

/obj/machinery/light/fueled/smelter/great/process()
	..()
	if(on)
		if(ore.len)
			if(cooking < 30)
				cooking++
				playsound(src,'sound/misc/smelter_sound.ogg', 50, FALSE)
				actively_smelting = TRUE
			else
				if(cooking == 30)
					var/alloy //moving each alloy to it's own var allows for possible additions later
					var/steelalloy
					var/bronzealloy
					var/blacksteelalloy

					for(var/obj/item/I in ore)
						if(I.smeltresult == /obj/item/ore/coal)
							steelalloy = steelalloy + 1
						if(I.smeltresult == /obj/item/ingot/iron)
							steelalloy = steelalloy + 2
						if(I.smeltresult == /obj/item/ingot/tin)
							bronzealloy = bronzealloy + 1
						if(I.smeltresult == /obj/item/ingot/copper)
							bronzealloy = bronzealloy + 2
						if(I.smeltresult == /obj/item/ingot/silver)
							blacksteelalloy = blacksteelalloy + 1
						if(I.smeltresult == /obj/item/ingot/steel)
							blacksteelalloy = blacksteelalloy + 2

					if(steelalloy == 7)
						maxore = 3
						alloy = /obj/item/ingot/steel_slag
					else if(bronzealloy == 7)
						alloy = /obj/item/ingot/bronze
					else if(blacksteelalloy == 7)
						alloy = /obj/item/ingot/blacksteel
						maxore = 2
					else
						alloy = null
					if(alloy)
						// The smelting quality of all ores added together, divided by the number of ores, and then rounded to the lowest integer (this isn't done until after the for loop)
						var/floor_mean_quality = SMELTERY_LEVEL_SPOIL
						var/ore_deleted = 0
						for(var/obj/item/I in ore)
							floor_mean_quality += ore[I]
							ore_deleted += 1
							ore -= I
							qdel(I)
						floor_mean_quality = floor(floor_mean_quality/ore_deleted)
						for(var/i in 1 to maxore)
							var/obj/item/R = new alloy(src, floor_mean_quality)
							if(alloy == /obj/item/ingot/blacksteel)
								record_round_statistic(STATS_BLACKSTEEL_SMELTED)
							ore += R
					else
						for(var/obj/item/I in ore)
							if(I.smeltresult)
								var/obj/item/R = new I.smeltresult(src, ore[I])
								ore -= I
								ore += R
								qdel(I)
					maxore = initial(maxore)
					playsound(src,'sound/misc/smelter_fin.ogg', 100, FALSE)
					visible_message("<span class='notice'>\The [src] finished smelting.</span>")
					cooking = 31
					actively_smelting = FALSE
