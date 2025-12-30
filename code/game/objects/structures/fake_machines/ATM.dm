/obj/structure/fake_machine/atm
	name = "MEISTER"
	desc = "Stores and withdraws currency for accounts managed by the Kingdom."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	blade_dulling = DULLING_BASH
	SET_BASE_PIXEL(0, 32)

/obj/structure/fake_machine/atm/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(HAS_TRAIT(user, TRAIT_MATTHIOS_CURSE) && prob(33))
		to_chat(H, "<span class='warning'>The idea repulses me!</span>")
		H.cursed_freak_out()
		return

	if(user.real_name in GLOB.outlawed_players)
		say("OUTLAW DETECTED! REFUSING SERVICE!")
		return

	if(H in SStreasury.bank_accounts)
		var/amt = SStreasury.bank_accounts[H]
		if(!amt)
			say("Your balance is nothing.")
			return
		if(amt < 0)
			say("Your balance is NEGATIVE.")
			return
		var/list/choicez = list()
		if(amt >= 10)
			choicez += "GOLD"
		if(amt >= 5)
			choicez += "SILVER"
		if(amt > 1) choicez += "BRONZE"
		var/selection = input(user, "Make a Selection", src) as null|anything in choicez
		if(!selection)
			return
		amt = SStreasury.bank_accounts[H]
		var/mod = 1
		if(selection == "GOLD")
			mod = 10
		if(selection == "SILVER")
			mod = 5
		if(selection == "BRONZE") mod = 1
		var/coin_amt = input(user, "There is [SStreasury.treasury_value] mammon in the treasury. You may withdraw [amt/mod] [selection] COINS from your account.", src) as null|num
		coin_amt = round(coin_amt)
		if(coin_amt < 1)
			return
		amt = SStreasury.bank_accounts[H]
		if(!Adjacent(user))
			return
		if((coin_amt*mod) > amt)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SStreasury.withdraw_money_account(coin_amt*mod, H))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		record_round_statistic(STATS_MAMMONS_WITHDRAWN, coin_amt * mod)
		budget2change(coin_amt*mod, user, selection)
	else
		to_chat(user, "<span class='warning'>The machine bites my finger.</span>")
		icon_state = "atm-b"
		H.flash_fullscreen("redflash3")
		playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		SStreasury.create_bank_account(H)
		if(H.mind)
			var/datum/job/target_job = SSjob.GetJob(H.mind.assigned_role)
			if(target_job && target_job.noble_income)
				SStreasury.noble_incomes[H] = target_job.noble_income
		spawn(5)
			say("New account created.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

/obj/structure/fake_machine/atm/attackby(obj/item/P, mob/user, params)
	if(ishuman(user))
		if(istype(P, /obj/item/coin/inqcoin))
			return
		var/mob/living/carbon/human/H = user
		if(istype(P, /obj/item/coin))
			if(HAS_TRAIT(user, TRAIT_MATTHIOS_CURSE) && prob(33))
				to_chat(H, "<span class='warning'>The idea repulses me!</span>")
				H.cursed_freak_out()
				return

			if(user.real_name in GLOB.outlawed_players)
				say("OUTLAW DETECTED! REFUSING SERVICE!")
				return

			if(H in SStreasury.bank_accounts)
				var/list/deposit_results = SStreasury.generate_money_account(P.get_real_price(), H)
				if(islist(deposit_results))
					record_round_statistic(STATS_MAMMONS_DEPOSITED, deposit_results[1] - deposit_results[2])
					if(deposit_results[2] != 0)
						say("Your deposit was taxed [deposit_results[2]] mammon.")
						record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, deposit_results[2])
						record_round_statistic(STATS_TAXES_COLLECTED, deposit_results[2])
				qdel(P)
				playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
				return
			else
				say("No account found. Submit your fingers for inspection.")
				return
		if(istype(P, /obj/item/paper/merc_work_onetime))
			var/obj/item/paper/merc_work_onetime/WC = P
			if(!WC.jobsdone)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("This contract is unfinished!")
				return
			var/mob/jobberref = WC.jobber.resolve()
			if(jobberref in SStreasury.bank_accounts)
				var/amt = SStreasury.bank_accounts[jobberref]
				if(amt < WC.payment)
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					say("[jobberref.real_name] does not have enough funds to pay for this contract.")
					return
				budget2change(WC.payment, user)
				return
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			say("[jobberref.real_name] does not have an account.")
			return
		if(istype(P, /obj/item/paper/merc_work_conti/))
			var/obj/item/paper/merc_work_conti/CW = P
			if(!CW.signed)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("This contract is not recognized as legitimate.")
				return
			if(CW.worktime < 1)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("This contract's payment obligations have been fulfilled.")
				return
			if(CW.daycount == GLOB.dayspassed) //if you wait a whole week you won't get your pay, but thats on you.
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("The payment cycle is not in effect.")
				return
			var/mob/jobberref = CW.jobber.resolve()
			if(jobberref in SStreasury.bank_accounts)
				var/amt2 = SStreasury.bank_accounts[jobberref]
				if(amt2 < CW.payment)
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					say("[jobberref.real_name] does not have enough funds to pay for this contract.")
					return
				budget2change(CW.payment, user)
				CW.worktime--
				return
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			say("[jobberref.real_name] does not have an account.")
			return
		if(istype(P, /obj/item/paper/merc_will/adven_will))
			var/obj/item/paper/merc_will/adven_will/AW = P
			if(!AW.yuptheydied || !AW.stewardsigned)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("This... err... 'health insurance' can't be claimed without the proper signatures.")
				return
			H.flash_fullscreen("redflash3")
			playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
			var/mob/inheretorialref = AW.inheretorial.resolve()
			if(H != inheretorialref)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("You are not the individual in this coverage")
				return
			var/mob/soontodieref = AW.soontodie.resolve()
			if(soontodieref in SStreasury.bank_accounts)
				var/deadsaccount = SStreasury.bank_accounts[soontodieref]
				if(deadsaccount < 0) //generational debt mechanic
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					say("Your acquaintance, [soontodieref.real_name] has left you their debt. The crown thanks you, personally, for continuing to pay what is rightfully owned to the crown")
					inheretorialref += deadsaccount
					return
				var/list/deposit_results2 = SStreasury.generate_money_account(deadsaccount, H)
				if(islist(deposit_results2))
					if(deposit_results2[2] != 0)
						say("The crown is sorry for your loss... TAX OF [deposit_results2[2]] MAMMONS APPLIED!!")
						record_featured_stat(FEATURED_STATS_TAX_PAYERS, H, deposit_results2[2])
						GLOB.vanderlin_round_stats[STATS_TAXES_COLLECTED] += deposit_results2[2]
				var/mob/yuptheydiedref = AW.yuptheydied.resolve()
				if((yuptheydiedref in SStreasury.bank_accounts) && (deadsaccount > 0))
					var/gaffersaccount = SStreasury.bank_accounts[yuptheydiedref]
					var/gafferscut = deadsaccount * 0.05
					gafferscut = round(gafferscut)
					deadsaccount -= gafferscut
					gaffersaccount += gafferscut
				budget2change(deadsaccount, H)
				qdel(AW)
				return
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			say("[soontodieref.real_name] does not have an account to pay out.")
			return
		if(istype(P, /obj/item/paper/merc_will))
			var/obj/item/paper/merc_will/MW = P
			if(!MW.yuptheydied || !MW.stewardsigned)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("This... err... 'health insurance' can't be claimed without the proper signatures.")
				return
			H.flash_fullscreen("redflash3")
			playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
			var/mob/inheretorialref = MW.inheretorial.resolve()
			if(H != inheretorialref)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("You are not the individual in this coverage")
				return
			var/mob/soontodieref = MW.soontodie.resolve()
			if(soontodieref in SStreasury.bank_accounts)
				var/deadsaccount = SStreasury.bank_accounts[soontodieref]
				if(deadsaccount < 0) //generational debt mechanic
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					say("Your acquaintance, [soontodieref.real_name] has left you their debt. The crown thanks you, personally, for continuing to pay what is rightfully owned to the crown")
					inheretorialref += deadsaccount
					return
				var/mob/yuptheydiedref = MW.yuptheydied.resolve()
				if((yuptheydiedref in SStreasury.bank_accounts) && (deadsaccount > 0))
					var/gaffersaccount = SStreasury.bank_accounts[yuptheydiedref]
					var/gafferscut = deadsaccount * 0.05
					gafferscut = round(gafferscut)
					deadsaccount -= gafferscut
					gaffersaccount += gafferscut
				budget2change(deadsaccount, H)
				qdel(MW)
				return
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			say("[soontodieref.real_name] does not have an account to pay out.")
			return
		if(istype(P, /obj/item/paper/voucher))
			var/obj/item/paper/voucher/voucher = P
			var/treasury_value = SStreasury.treasury_value
			var/voucherpay = SStreasury.herovoucher
			if(!voucherpay)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("The crown is no longer accepting these vouchers")
				return
			if(voucherpay > treasury_value)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("[src] is not legitimate") //keeping it hush hush that they are fucking broke.
				return
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			say("Enjoy the [voucherpay] mammons from the ever generous crown, 'we look forward to your future achivements!'")
			budget2change(voucherpay, H)
			SStreasury.treasury_value -= voucherpay
			qdel(voucher)
		if(istype(P, /obj/item/paper/merchantprotectionpact_gaffpart))
			var/obj/item/paper/merchantprotectionpact_gaffpart/garf
			if(!garf.merchpart)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("This contract is no longer in effect.")
				return
			if(garf.lastpay == GLOB.dayspassed)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				say("The payment cycle is not in effect.")
				return
			var/mob/merchref = garf.merch.resolve()
			if(merchref in SStreasury.bank_accounts)
				var/merchantsaccounts = SStreasury.bank_accounts[merchref]
				if(merchantsaccounts < garf.pay)
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					say("[merchref.real_name] does not have enough funds to pay for this contract.")
					return
				garf.lastpay = GLOB.dayspassed
				budget2change(merchantsaccounts, H)
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				return
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			say("[merchref.real_name] does not have an account.")
			return
	return ..()

/obj/structure/fake_machine/atm/examine(mob/user)
	. += ..()
	. += span_info("The current tax rate on deposits is [SStreasury.tax_value * 100] percent. Kingdom nobles exempt.")
