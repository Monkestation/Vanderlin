/obj/item/fake_machine/drugtrade
	name = "NARCOS"
	desc = "A machine that exports drugs throughout a network of pneumatic pipes."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_canister
	var/accepted_items
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC

/obj/structure/fake_machine/drug_chute
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/item/fake_machine/drugtrade/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	user.changeNext_move(CLICK_CD_MELEE)

	var/contents

	contents += "<center>THE DEN<BR>"
	contents += "--------------<BR>"
	//contents += "Guild's Tax: [SStreasury.queens_tax*100]%<BR>"
	contents += "Next Canister: [time2text((next_canister - world.time), "mm:ss")]</center><BR>"

	if(!user.can_read(src, TRUE))
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 220)
	popup.set_content(contents)
	popup.open()

/obj/item/fake_machine/drugtrade/Initialize()
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	set_light(2, 2, 2, l_color =  "#9C37B5")
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/fake_machine/drug_chute(T)

/obj/item/fake_machine/drugtrade/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/item/fake_machine/drugtrade/process()
	if(!anchored)
		return TRUE
	if(world.time > next_canister)
		next_canister = world.time + rand(2 MINUTES, 3 MINUTES)
#ifdef TESTSERVER
		next_canister = world.time + 5 SECONDS
#endif
		var/play_sound = FALSE
		for(var/D in GLOB.alldirs)
			var/budgie = 0
			var/turf/T = get_step(src, D)
			if(!T)
				continue
			var/obj/structure/fake_machine/drug_chute/E = locate() in T
			if(!E)
				continue
			accepted_items = list(/obj/item/reagent_containers/powder/spice, /obj/item/reagent_containers/powder/ozium, /obj/item/reagent_containers/powder/moondust, /obj/item/reagent_containers/powder/moondust_purest, /obj/item/reagent_containers/food/snacks/produce/swampweed_dried, /obj/item/reagent_containers/food/snacks/produce/dry_westleach)
			for(var/obj/I in T)
				if(I.anchored)
					continue
				if(!isturf(I.loc))
					continue
				if(!(I.type in accepted_items))
					continue
				var/prize = I.get_real_price() * 1 // 500% was a bit ridiculous, they've been rebalanced anyhow.
				if(prize >= 1)
					play_sound=TRUE
					budgie += prize
					I.visible_message("<span class='warning'>[I] is sucked into the tube!</span>")
					qdel(I)
			budgie = round(budgie)
			if(budgie > 0)
				play_sound=TRUE
				E.budget2change(budgie)
				budgie = 0
		if(play_sound)
			playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)


///PURITY 2.0///

#define UPGRADE_NOTAX		(1<<0)

/obj/structure/fake_machine/drugmachine
	name = "PURITY"
	desc = "You want to destroy your life."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "goldvendor"
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	lock = /datum/lock/key/purity
	var/list/held_items = list()
	var/budget = 0
	var/upgrade_flags
	var/current_cat
	var/list/available_categories = list("Narcotics", "Instruments")

/obj/structure/fake_machine/drugmachine/Initialize()
	. = ..()
	set_light(1, 1, 1, l_color =  "#8f06b5")

/obj/structure/fake_machine/drugmachine/atom_break(damage_flag)
	. = ..()
	budget2change(budget)
	set_light(0)

/obj/structure/fake_machine/drugmachine/atom_fix()
	. = ..()
	set_light(1, 1, 1, l_color =  "#8f06b5")

/obj/structure/fake_machine/drugmachine/Destroy()
	. = ..()
	budget2change(budget)
	set_light(0)

/obj/structure/fake_machine/drugmachine/attackby(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(istype(I, /obj/item/coin/inqcoin))
		return
	if(istype(I, /obj/item/coin))
		var/money = I.get_real_price()
		budget += money
		qdel(I)
		to_chat(user, span_info("I put [money] mammon in [src]."))
		playsound(src, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)

/obj/structure/fake_machine/drugmachine/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH) || locked())
		return
	var/mob/living/carbon/human/human_mob = usr
	if(href_list["buy"])
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("APOTHECARY [usr.key] IS TRYING TO BUY A [path] WITH THE GOLDFACE. THIS IS AN EXPLOIT.")
			return
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		var/cost = PA.cost
		var/tax_amt=round(SStreasury.tax_value * cost)
		cost=cost+tax_amt
		if(upgrade_flags & UPGRADE_NOTAX)
			cost = PA.cost
		if(budget >= cost)
			budget -= cost
			record_round_statistic(STATS_PURITY_VALUE_SPENT, cost)
			if(!(upgrade_flags & UPGRADE_NOTAX))
				SStreasury.give_money_treasury(tax_amt, "goldface import tax")
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, human_mob, tax_amt)
				record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
			else
				record_round_statistic(STATS_TAXES_EVADED, tax_amt)
		else
			say("Not enough!")
			return
		var/pathi = pick(PA.contains)
		var/obj/item/I = new pathi(get_turf(src))
		human_mob.put_in_hands(I)
		qdel(PA)
	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["changecat"])
		var/selected_category = href_list["changecat"]

		if (selected_category in available_categories)
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

/obj/structure/fake_machine/drugmachine/attack_hand(mob/living/user)
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
	contents = "<center>PURITY - In the pursuit of pleasure.<BR>"
	contents += "<a href='byond://?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"

	var/mob/living/carbon/human/H = user
	if(H.job == "Apothecary")
		if(canread)
			contents += "<a href='byond://?src=[REF(src)];secrets=1'>Secrets</a>"
		else
			contents += "<a href='byond://?src=[REF(src)];secrets=1'>[stars("Secrets")]</a>"

	contents += "</center><BR>"

	if(isnull(current_cat))
		contents += "<center>"
		for(var/category in available_categories)
			contents += "<a href='byond://?src=[REF(src)];changecat=[category]'>[category]</a><BR>"
		contents += "</center>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='byond://?src=[REF(src)];changecat=0'>\[RETURN\]</a><BR><BR></center>"
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group == current_cat)
				pax += PA
		for(var/datum/supply_pack/PA in sortList(pax))
			var/costy = PA.cost
			if(!(upgrade_flags & UPGRADE_NOTAX))
				costy=round(costy+(SStreasury.tax_value * costy))
			contents += "[PA.name] - ([costy])<a href='byond://?src=[REF(src)];buy=[PA.type]'>BUY</a><BR>"

	if(!canread)
		contents = stars(contents)

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 400)
	popup.set_content(contents)
	popup.open()

#undef UPGRADE_NOTAX
