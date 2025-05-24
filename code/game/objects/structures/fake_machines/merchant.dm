/obj/item/roguemachine/merchant
	name = "SKY HANDLER"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC

/obj/structure/fake_machine/balloon_pad
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/item/roguemachine/merchant/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)

	var/contents

	contents += "<center>MERCHANT'S GUILD<BR>"
	contents += "--------------<BR>"
	//contents += "Guild's Tax: [SStreasury.queens_tax*100]%<BR>"
	contents += "Next Balloon: [time2text((next_airlift - world.time), "mm:ss")]</center><BR>"

	if(!user.can_read(src, TRUE))
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 220)
	popup.set_content(contents)
	popup.open()

/obj/item/roguemachine/merchant/update_icon()
	if(!anchored)
		w_class = WEIGHT_CLASS_BULKY
		set_light(0)
		return
	w_class = WEIGHT_CLASS_GIGANTIC
	set_light(2, 2, 2, l_color =  "#1b7bf1")

/obj/item/roguemachine/merchant/Initialize()
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	update_icon()
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/fake_machine/balloon_pad(T)

/obj/item/roguemachine/merchant/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/item/roguemachine/merchant/process()
	if(!anchored)
		return TRUE
	if(world.time > next_airlift)
		next_airlift = world.time + rand(2 MINUTES, 3 MINUTES)
#ifdef TESTSERVER
		next_airlift = world.time + 5 SECONDS
#endif
		var/play_sound = FALSE
		for(var/D in GLOB.alldirs)
			var/budgie = 0
			var/turf/T = get_step(src, D)
			if(!T)
				continue
			var/obj/structure/fake_machine/balloon_pad/E = locate() in T
			if(!E)
				continue
			for(var/obj/I in T)
				if(I.anchored)
					continue
				if(!isturf(I.loc))
					continue
				var/prize = I.get_real_price()// - (I.get_real_price() * SStreasury.queens_tax)
				if(prize >= 1)
					play_sound=TRUE
					budgie += prize
					I.visible_message("<span class='warning'>[I] is sucked into the air!</span>")
					qdel(I)
			budgie = round(budgie)
			if(budgie > 0)
				play_sound=TRUE
				E.budget2change(budgie)
				budgie = 0
		if(play_sound)
			playsound(loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

#define UPGRADE_NOTAX		(1<<0)
/*
#define UPGRADE_ARMOR		(1<<1)
#define UPGRADE_WEAPONS		(1<<2)
#define UPGRADE_FOOD		(1<<3)
*/

/obj/structure/fake_machine/merchantvend
	name = "GOLDFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "goldvendor"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	rattle_sound = 'sound/misc/machineno.ogg'
	unlock_sound = 'sound/misc/beep.ogg'
	lock_sound = 'sound/misc/beep.ogg'
	lock = /datum/lock/key/goldface
	var/list/held_items = list()
	var/budget = 0
	var/upgrade_flags
	var/current_cat = "1"

/obj/structure/fake_machine/merchantvend/Initialize()
	. = ..()
	set_light(1, 1, 1, l_color =  "#1b7bf1")

/obj/structure/fake_machine/merchantvend/obj_break(damage_flag, silent)
	. = ..()
	budget2change(budget)
	set_light(0)

/obj/structure/fake_machine/merchantvend/Destroy()
	. = ..()
	budget2change(budget)
	set_light(0)

/obj/structure/fake_machine/merchantvend/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/coin))
		var/money = I.get_real_price()
		budget += money
		qdel(I)
		to_chat(user, span_info("I put [money] mammon in [src]."))
		playsound(get_turf(src), 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	return ..()

/obj/structure/fake_machine/merchantvend/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	if(!usr.canUseTopic(src, BE_CLOSE) || locked())
		return
	var/mob/living/carbon/human/human_mob = usr
	if(href_list["buy"])
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("MERCHANT [usr.key] IS TRYING TO BUY A [path] WITH THE GOLDFACE. THIS IS AN EXPLOIT.")
			return
		var/datum/supply_pack/picked_pack = new path
		var/cost = picked_pack.cost
		var/tax_amt=round(SStreasury.tax_value * cost)
		cost=cost+tax_amt
		if(upgrade_flags & UPGRADE_NOTAX)
			cost = picked_pack.cost
		if(budget >= cost)
			budget -= cost
			if(!(upgrade_flags & UPGRADE_NOTAX))
				SStreasury.give_money_treasury(tax_amt, "goldface import tax")
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, human_mob, tax_amt)
				GLOB.vanderlin_round_stats[STATS_TAXES_COLLECTED] += tax_amt
		else
			say("Not enough!")
			return
		if(ispath(picked_pack.contains))
			var/obj/item/packitem = picked_pack.contains
			new packitem(get_turf(usr))
		else
			for(var/in_pack in picked_pack.contains)
				var/obj/item/packitem = in_pack
				new packitem(get_turf(usr))
		qdel(picked_pack)
	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["changecat"])
		current_cat = href_list["changecat"]
	if(href_list["secrets"])
		var/list/options = list()
		if(upgrade_flags & UPGRADE_NOTAX)
			options += "Enable Paying Taxes"
		else
			options += "Stop Paying Taxes"
		var/select = input(usr, "Please select an option.", "", null) as null|anything in options
		if(!select)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked())
			return
		switch(select)
			if("Enable Paying Taxes")
				upgrade_flags &= ~UPGRADE_NOTAX
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			if("Stop Paying Taxes")
				upgrade_flags |= UPGRADE_NOTAX
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	return attack_hand(usr)

/obj/structure/fake_machine/merchantvend/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	if(locked())
		to_chat(user, "<span class='warning'>It's locked. Of course.</span>")
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	contents = "<center>GOLDFACE - In the name of greed.<BR>"
	contents += "<a href='byond://?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"

	var/mob/living/carbon/human/H = user
	if(H.job == "Merchant")
		if(canread)
			contents += "<a href='byond://?src=[REF(src)];secrets=1'>Secrets</a>"
		else
			contents += "<a href='byond://?src=[REF(src)];secrets=1'>[stars("Secrets")]</a>"

	contents += "</center><BR>"

	var/list/unlocked_cats = list("Apparel","Armor","Consumable","Jewelry","Tools","Seeds","Weapons")

	if(current_cat == "1")
		contents += "<center>"
		for(var/X in unlocked_cats)
			contents += "<a href='byond://?src=[REF(src)];changecat=[X]'>[X]</a><BR>"
		contents += "</center>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='byond://?src=[REF(src)];changecat=1'>\[RETURN\]</a><BR><BR></center>"
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/picked_pack = SSmerchant.supply_packs[pack]
			if(picked_pack.group == current_cat)
				pax += picked_pack
		for(var/datum/supply_pack/picked_pack in sortList(pax))
			var/costy = picked_pack.cost
			if(!(upgrade_flags & UPGRADE_NOTAX))
				costy=round(costy+(SStreasury.tax_value * costy))
			contents += "[picked_pack.name] - ([costy])<a href='byond://?src=[REF(src)];buy=[picked_pack.type]'>BUY</a><BR>"

	if(!canread)
		contents = stars(contents)

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 400)
	popup.set_content(contents)
	popup.open()

#undef UPGRADE_NOTAX
