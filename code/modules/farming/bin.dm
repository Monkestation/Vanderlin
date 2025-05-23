//Not adding this yet

/obj/item/bin
	name = "wood bin"
	desc = "A washbin, a trashbin, a bloodbin... Your choices are limitless."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "washbin"
	var/base_state
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	max_integrity = 80
	w_class = WEIGHT_CLASS_GIGANTIC
	var/kover = FALSE
	drag_slowdown = 2
	throw_speed = 1
	throw_range = 1
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT

/obj/item/bin/alt	// probably unnecessary
	icon_state = "washbin2"

/obj/item/bin/Initialize()
	if(!base_state)
		create_reagents(600, DRAINABLE | AMOUNT_VISIBLE | REFILLABLE | OPENCONTAINER)
		base_state = icon_state
	AddComponent(/datum/component/storage/concrete/grid/bin)
	. = ..()
	pixel_x = 0
	pixel_y = 0
	update_icon()

/obj/item/bin/Destroy()
	layer = 2.8
	icon_state = "washbin_destroy"
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))
	return ..()


/obj/item/bin/update_icon()
	if(kover)
		icon_state = "[base_state]over"
	else
		icon_state = "[base_state]"
	cut_overlays()
	if(reagents)
		if(reagents.total_volume)
			var/mutable_appearance/filling = mutable_appearance('icons/roguetown/misc/structure.dmi', "liquid2")
			filling.color = mix_color_from_reagents(reagents.reagent_list)
			filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
			add_overlay(filling)

/obj/item/bin/onkick(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(kover)
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks [src]!</span>", \
				"<span class='warning'>I kick [src]!</span>")
			return
		if(prob(L.STASTR * 8))
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks over [src]!</span>", \
				"<span class='warning'>I kick over [src]!</span>")
			kover = TRUE
			playsound(loc, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg', 'sound/foley/water_land3.ogg'), 100, FALSE)
			chem_splash(loc, 2, list(reagents), adminlog = TRUE)
			var/datum/component/storage/STR = GetComponent(/datum/component/storage)
			if(STR)
				var/list/things = STR.contents()
				for(var/obj/item/I in things)
					STR.remove_from_storage(I, get_turf(src))
			update_icon()
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks [src]!</span>", \
				"<span class='warning'>I kick [src]!</span>")

/obj/item/bin/attack_hand(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE

/obj/item/bin/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(kover)
		if(kover)
			user.visible_message("<span class='notice'>[user] starts to pick up [src]...</span>", \
				"<span class='notice'>I start to pick up [src]...</span>")
			if(do_after(user, 3 SECONDS, src))
				kover = FALSE
				update_icon()
			return
	else
		if(!reagents || !reagents.maximum_volume)
			return
		if(isliving(user))
			var/mob/living/L = user
			if(L.stat != CONSCIOUS)
				return
			var/removereg = /datum/reagent/water
			if(!reagents.has_reagent(/datum/reagent/water, 5))
				removereg = /datum/reagent/water/gross
				if(!reagents.has_reagent(/datum/reagent/water/gross, 5))
					to_chat(user, "<span class='warning'>No water to wash these stains.</span>")
					return
			reagents.remove_reagent(removereg, 5)
			var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
			playsound(user, pick_n_take(wash), 100, FALSE)
			var/obj/item/item2wash = user.get_active_held_item()
			if(!item2wash)
				user.visible_message("<span class='info'>[user] starts to wash in [src].</span>")
				if(do_after(L, 3 SECONDS, src))
					user.wash(CLEAN_WASH)
					playsound(user, pick(wash), 100, FALSE)
			else
				user.visible_message("<span class='info'>[user] starts to wash [item2wash] in [src].</span>")
				if(do_after(L, 3 SECONDS, src))
					item2wash.wash(CLEAN_WASH)
					playsound(user, pick(wash), 100, FALSE)
			var/datum/reagent/water_to_dirty = reagents.has_reagent(/datum/reagent/water, 5)
			if(water_to_dirty)
				var/amount_to_dirty = water_to_dirty.volume
				if(amount_to_dirty)
					reagents.remove_reagent(/datum/reagent/water, amount_to_dirty)
					reagents.add_reagent(/datum/reagent/water/gross, amount_to_dirty)
			return

//We need to use this or the object will be put in storage instead of attacking it
/obj/item/bin/StorageBlock(obj/item/I, mob/user)
	if(user.used_intent)
		if(user.used_intent.type in list(/datum/intent/fill,/datum/intent/pour,/datum/intent/splash))
			return TRUE
	if(istype(I, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/T = I
		if(T.held_item && istype(T.held_item, /obj/item/ingot))
			return TRUE
	return FALSE

/obj/item/bin/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/dye_pack))
		var/obj/item/dye_pack/pack = I
		user.visible_message(span_info("[user] begins to add [pack] to [src]..."))
		if(do_after(user, 3 SECONDS, src))
			playsound(src, "bubbles", 50, 1)
			new /obj/structure/dye_bin(get_turf(src), pack)
			qdel(src)
		return

	if(!reagents || !reagents.maximum_volume) //trash
		return ..()

	if(istype(I, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/T = I
		if(T.held_item && istype(T.held_item, /obj/item/ingot))
			var/obj/item/ingot/ingot = T.held_item
			var/removereg = /datum/reagent/water
			if(!reagents.has_reagent(/datum/reagent/water, 5))
				removereg = /datum/reagent/water/gross
				if(!reagents.has_reagent(/datum/reagent/water/gross, 5))
					to_chat(user, "<span class='warning'>Need more water to quench in.</span>")
					return
			if(!T.held_item:currecipe)
				to_chat(user, "<span class='warning'>Huh?</span>")
				return
			if(ingot.currecipe.progress != 100)
				to_chat(user, "<span class='warning'>It's not finished yet.</span>")
				return
			if(!T.hott)
				to_chat(user, "<span class='warning'>I need to heat it to temper the metal.</span>")
				return
			var/used_turf = user.loc
			if(!isturf(used_turf))
				used_turf = get_turf(src)
			// This behemoth of a chunk of code is necessary to create copies of an altered item
			// Because engine is dumb and doesn't have a copy object proc
			// We take all values of a recipe, apply them to floating vars, then assign them to every extra copy
			// (substracting one every time it runs) until we run out of that number
			var/datum/anvil_recipe/R = T.held_item:currecipe
			var/obj/item/crafteditem = R.created_item
			if(R.createmultiple)
				var/obj/item/IT = new crafteditem(used_turf)
				R.handle_creation(IT)
				var/newname = IT.name
				var/newmaxinteg = IT.max_integrity
				var/newinteg = IT.obj_integrity
				var/newprice = IT.sellprice
				var/obj/item/lockpick/L = IT
				var/newpicklvl = L.picklvl
				var/obj/item/weapon/W = IT
				var/newforce = W.force
				var/newthrow = W.throwforce
				var/newblade = W.blade_int
				var/newmaxblade = W.max_blade_int
				var/newap = W.armor_penetration
				var/newdef = W.wdefense
				var/obj/item/clothing/C = IT
				var/newdamdef = C.damage_deflection
				var/newintegfail = C.integrity_failure
				var/newarmor = C.armor
				var/newdelay = C.equip_delay_self
				while(R.createditem_num)
					R.createditem_num--
					var/obj/item/editme = new crafteditem(used_turf)
					record_featured_stat(FEATURED_STATS_SMITHS, user)
					record_featured_object_stat(FEATURED_STATS_FORGED_ITEMS, editme.name)
					editme.name = newname
					editme.max_integrity = newmaxinteg
					editme.obj_integrity = newinteg
					editme.sellprice = newprice
					if(istype(editme, /obj/item/lockpick))
						editme.picklvl = newpicklvl
					if(istype(editme, /obj/item/weapon))
						editme.force = newforce
						editme.throwforce = newthrow
						editme.blade_int = newblade
						editme.max_blade_int = newmaxblade
						editme.armor_penetration = newap
						editme.wdefense = newdef
					if(istype(IT, /obj/item/clothing))
						editme.damage_deflection = newdamdef
						editme.integrity_failure = newintegfail
						editme.armor = newarmor
						editme.equip_delay_self = newdelay
			else // Just make one buddy
				var/obj/item/IT = new crafteditem(used_turf)
				record_featured_stat(FEATURED_STATS_SMITHS, user)
				record_featured_object_stat(FEATURED_STATS_FORGED_ITEMS, IT.name)
				R.handle_creation(IT)
			playsound(src,pick('sound/items/quench_barrel1.ogg','sound/items/quench_barrel2.ogg'), 100, FALSE)
			user.visible_message("<span class='info'>[user] tempers \the [T.held_item.name] in \the [src], hot metal sizzling.</span>")
			QDEL_NULL(T.held_item)
			T.update_icon()
			reagents.remove_reagent(removereg, 5)
			var/datum/reagent/water_to_dirty = reagents.has_reagent(/datum/reagent/water, 5)
			if(water_to_dirty)
				var/amount_to_dirty = water_to_dirty.volume
				if(amount_to_dirty)
					reagents.remove_reagent(/datum/reagent/water, amount_to_dirty)
					reagents.add_reagent(/datum/reagent/water/gross, amount_to_dirty)
			update_icon()
			return
	. = ..()

/obj/item/bin/trash
	name = "trash bin"
	desc = "An eyesore that is meant to make things look cleaner."
	icon_state = "trashbin"
	base_state = "trashbin"

/obj/item/bin/trash/StorageBlock(obj/item/I, mob/user)
	return FALSE

/obj/item/bin/trash/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/dye_pack)) //it works... but we can do better, surely?
		return
	. = ..()
