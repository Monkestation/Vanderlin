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
	var/mob/living/carbon/human/user_mob = user

	if(HAS_TRAIT(user, TRAIT_MATTHIOS_CURSE) && prob(33))
		to_chat(user_mob, "<span class='warning'>The idea repulses me!</span>")
		user_mob.cursed_freak_out()
		return

	if(user_mob.real_name in GLOB.outlawed_players)
		say("OUTLAW DETECTED! REFUSING SERVICE!")
		return

	if(user_mob in SStreasury.bank_accounts)
		var/amt = SStreasury.bank_accounts[user_mob]
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
		var/selection = input(user_mob, "Make a Selection", src) as null|anything in choicez
		if(!selection)
			return
		amt = SStreasury.bank_accounts[user_mob]
		var/mod = 1
		if(selection == "GOLD")
			mod = 10
		if(selection == "SILVER")
			mod = 5
		if(selection == "BRONZE") mod = 1
		var/coin_amt = input(user_mob, "There is [SStreasury.treasury_value] mammon in the treasury. You may withdraw [amt/mod] [selection] COINS from your account.", src) as null|num
		coin_amt = round(coin_amt)
		if(coin_amt < 1)
			return
		amt = SStreasury.bank_accounts[user_mob]
		if(!Adjacent(user_mob))
			return
		if((coin_amt*mod) > amt)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SStreasury.withdraw_money_account(coin_amt*mod, user_mob))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		record_round_statistic(STATS_MAMMONS_WITHDRAWN, coin_amt * mod)
		budget2change(coin_amt*mod, user_mob, selection)
	else
		to_chat(user_mob, "<span class='warning'>The machine bites my finger.</span>")
		icon_state = "atm-b"
		user_mob.flash_fullscreen("redflash3")
		playsound(user_mob, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		SStreasury.create_bank_account(user_mob)
		if(user_mob.mind)
			var/datum/job/target_job = SSjob.GetJob(user_mob.mind.assigned_role)
			if(target_job && target_job.noble_income)
				SStreasury.noble_incomes[user_mob] = target_job.noble_income
		spawn(5)
			say("New account created.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

/obj/structure/fake_machine/atm/attackby(obj/item/P, mob/user, list/modifiers)
	if(ishuman(user))
		if(istype(P, /obj/item/coin/inqcoin))
			return
		if(istype(P, /obj/item/coin))
			var/mob/living/carbon/human/H = user
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
	return ..()

/obj/structure/fake_machine/atm/examine(mob/user)
	. += ..()
	. += span_info("The current tax rate on deposits is [SStreasury.tax_value * 100] percent. Kingdom nobles exempt.")
