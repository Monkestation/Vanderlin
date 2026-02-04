/obj/item/fake_machine/merchant
	name = "SKY HANDLER"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
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

/obj/item/fake_machine/merchant/attack_hand(mob/living/user)
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

/obj/item/fake_machine/merchant/Initialize()
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	set_light(2, 2, 2, l_color =  "#1b7bf1")
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/fake_machine/balloon_pad(T)

/obj/item/fake_machine/merchant/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/item/fake_machine/merchant/process()
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
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)

/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

#define UPGRADE_NOTAX		(1<<0)

/obj/structure/fake_machine/merchantvend
	name = "GOLDFACE"
	desc = "Gilded tombs do worms enfold."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "goldvendor"
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	rattle_sound = 'sound/misc/machineno.ogg'
	unlock_sound = 'sound/misc/beep.ogg'
	lock_sound = 'sound/misc/beep.ogg'
	lock = /datum/lock/key/goldface
	var/list/held_items = list()
	var/budget = 200
	var/upgrade_flags
	var/current_cat
	var/base_price = 0
	var/final_price = 0
	var/taxes = 0
	// this is the list of supply groups that you can purchase with this machine
	var/list/unlocked_cats = list("Apparel","Storage","Armor(Light)","Armor(Steel)","Food","Drinks","Jewelry","Luxury","Tools","Seeds","Shields","Medicine","Raw Materials",
								"Weapons (Iron)","Weapons (Steel)","Weapons (Ranged)","Ammunition")

/obj/structure/fake_machine/merchantvend/Initialize()
	. = ..()
	set_light(1, 1, 1, l_color =  "#1b7bf1")

/obj/structure/fake_machine/merchantvend/atom_break(damage_flag)
	. = ..()
	budget2change(budget)
	set_light(0)

/obj/structure/fake_machine/merchantvend/atom_fix()
	. = ..()
	set_light(1, 1, 1, l_color =  "#1b7bf1")

/obj/structure/fake_machine/merchantvend/Destroy()
	. = ..()
	budget2change(budget)
	set_light(0)

/obj/structure/fake_machine/merchantvend/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/coin))
		var/money = I.get_real_price()
		budget += money
		qdel(I)
		to_chat(user, span_info("I put [money] mammon in [src]."))
		playsound(src, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	return ..()

/obj/structure/fake_machine/merchantvend/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())
		return
	var/mob/living/carbon/human/human_mob = usr
	if(href_list["buy"])
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("MERCHANT [usr.key] IS TRYING TO BUY A [path] WITH THE GOLDFACE. THIS IS AN EXPLOIT.")
			return
		var/datum/supply_pack/picked_pack = SSmerchant.supply_packs[path]
		base_price = picked_pack.cost
		taxes = round(SStreasury.tax_value * base_price)
		final_price = round(base_price + taxes)
		if(upgrade_flags & UPGRADE_NOTAX)
			final_price = base_price
		if(budget >= final_price)
			budget -= final_price
			record_round_statistic(STATS_GOLDFACE_VALUE_SPENT, final_price)
			if(!(upgrade_flags & UPGRADE_NOTAX))
				SStreasury.give_money_treasury(taxes, "goldface import tax")
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, human_mob, taxes)
				record_round_statistic(STATS_TAXES_COLLECTED, taxes)
			else
				record_round_statistic(STATS_TAXES_EVADED, taxes)
		else
			say("Not enough!")
			return
		if(ispath(picked_pack.contains))
			var/obj/item/packitem = picked_pack.contains
			new packitem(get_turf(usr))
		else
			for(var/obj/item/packitem as anything in picked_pack.contains)
				new packitem(get_turf(usr))
		qdel(picked_pack)
	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["changecat"])
		var/selected_category = href_list["changecat"]

		if (selected_category in unlocked_cats)
			current_cat = selected_category
		else
			current_cat = null
	if(href_list["secrets"])
		var/list/options = list()
		if(upgrade_flags & UPGRADE_NOTAX)
			options += "Enable Paying Taxes"
		else
			options += "Stop Paying Taxes"
		var/select = input(usr, "Please select an option.", "", null) as null|anything in options
		if(!select)
			return
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())
			return
		switch(select)
			if("Enable Paying Taxes")
				upgrade_flags &= ~UPGRADE_NOTAX
				playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
			if("Stop Paying Taxes")
				upgrade_flags |= UPGRADE_NOTAX
				playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
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
	playsound(src, 'sound/misc/beep.ogg', 100, FALSE, -1)
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

	var/split = ceil(unlocked_cats.len / 2)

	if(isnull(current_cat))
		contents += "<table style='width: 100%' line-height: 20px;'>"
		for(var/i = 1 to split)
			contents += "<tr>"
			contents += "<td style='width: 50%; text-align: center;'>\
				<a href='?src=[REF(src)];changecat=[unlocked_cats[i]]'>[unlocked_cats[i]]</a>\
				</td>"
			if(i + split <= unlocked_cats.len)
				contents += "<td style='width: 50%; text-align: center;'>\
					<a href='?src=[REF(src)];changecat=[unlocked_cats[i+split]]'>[unlocked_cats[i+split]]</a>\
					</td>"
			else
				contents += "<td></td>"
			contents += "</tr>"
		contents += "</table>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=0'>\[RETURN\]</a><BR><BR></center>"
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

	var/datum/browser/popup = new(user, "VENDORTHING", "", 500, 800)
	popup.set_content(contents)
	popup.open()

#undef UPGRADE_NOTAX
