/obj/structure/fake_machine/lottery_roguetown
	name = "XYLIX'S FORTUNE"
	desc = "An infinite, yawning hole that makes or breaks men. Come and play!"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "lottery"
	density = FALSE
	pixel_y = 32
	light_outer_range = 5
	light_color = "#1b7bf1"

	// Gambling variables
	var/gamblingprice = 0
	var/gamblingprob = 60
	var/gamblingbaseprob = 60
	var/oldtithe = 0

	// Roll and limit variables
	var/diceroll = 100
	var/maxtithing = 100
	var/mintithing = 5
	var/probpenalty = 2

	// State variables
	var/stopgambling = 0
	var/checkchatter = 0
	var/chatterbox = 0


/obj/structure/fake_machine/lottery_roguetown/attack_hand(mob/living/user)
	say("Your current tithe is [gamblingprice] mammons. Care to spin?")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	return


/obj/structure/fake_machine/lottery_roguetown/attackby(obj/item/coin/P, mob/living/user, list/modifiers)
	. = ..()

	if(!istype(P))
		return

	if(stopgambling)
		return

	// Reject special coins
	if(istype(P, /obj/item/coin/inqcoin))
		return

	var/coin_value = P.sellprice * P.quantity
	var/new_total = gamblingprice + coin_value

	// Validate tithe amount
	if(new_total > maxtithing)
		say("This puts the starting tithe over [maxtithing] mammons.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	if(new_total < mintithing)
		say("This is below [mintithing] mammons.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	// Accept the coin
	gamblingprice += coin_value
	qdel(P)
	say("Your current tithe is now [gamblingprice] mammons. Care to spin?")
	playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
	return


/obj/structure/fake_machine/lottery_roguetown/MiddleClick(mob/living/user, params)
	if(stopgambling)
		return

	// Check if player has bet
	if(gamblingprice == 0)
		say(pick(
			"Eager fool; you need mammons to gamble your life away.", \
			"You are missing your tithe.", \
			"A lord without land is no lord at all."\
		))
		stopgambling = 1
		sleep(20)
		stopgambling = 0
		return

	// Start gambling sequence
	diceroll = rand(1, 100)
	say(pick(
		"Around and around I go, where I stop, only I know.",\
		"Xylix smiles upon your idiocy, child.",\
		"The wheel of fate spins, and spins.",\
		"Oh, you poor fool.",\
		"This is going to hurt for one of us.",\
		"I laugh, you cry; I weep, you cheer..",\
		"I will be your fool; I'll perform for you...",\
		"Let's go gambling!",\
		"Around and around, folly abounds.",\
		"Dance with ruin and wealth."\
	))

	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	playsound(src, 'sound/misc/letsgogambling.ogg', 100, FALSE, -1)

	gamblingprob += (user.STALUC - probpenalty)
	stopgambling = 1
	checkchatter -= 1

	// Shake animation
	var/oldx = pixel_x
	animate(src, pixel_x = oldx + 1, time = 1)
	animate(pixel_x = oldx - 1, time = 1)
	animate(pixel_x = oldx, time = 1)
	sleep(50)

	// Determine result
	if(gamblingprob > diceroll)
		handle_win()
		SEND_SIGNAL(user, COMSIG_GAMBLING_WON)
	else
		handle_loss()


/obj/structure/fake_machine/lottery_roguetown/proc/handle_win()
	oldtithe = gamblingprice
	gamblingprice *= pick(1.1, 1.1, 1.1, 1.1, 1.2, 1.2, 1.2, 1.4, 1.4, 2)
	gamblingprice = round(gamblingprice)

	peasant_betting()
	letsgogamblinggamblers()

	say(pick(
		"Well-maneuvered, aristocrat! Your peasant's tithe is now [gamblingprice] mammons. Play again?",\
		"A bountiful harvest, this year- the peasant's tithe rises to [gamblingprice] mammons. Spin me again?"\
	))

	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	gamblingprob = gamblingbaseprob
	oldtithe = gamblingprice
	sleep(15)
	stopgambling = 0


/obj/structure/fake_machine/lottery_roguetown/proc/handle_loss()
	say(pick(
		"TEN, WHEEL OF FORTUNE - inversed.",\
		"The Castle. O, Omen!",\
		"A harvest of locusts...!",\
		"Look into my eyes and whisper your woes.",\
		"Aw, dangit.",\
		"Fool. Poor fool.",\
		"Your eyes leak out of your skull, drool falling from your lips.",\
		"Divine idiocy.",\
		"You stand just as I did; loser and a freek."\
	))

	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	sleep(20)

	say(pick(
		"King of fools, your land is barren. Play again?",\
		"Divine comedy. Play again?",\
		"Next time, surely. Play again?",\
		"Haha-...ah-ha-ha! Again! Play again, jester!",\
		"Poor beggar! Spin me again?"\
	))

	playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
	gamblingprob = gamblingbaseprob
	gamblingprice = 0
	oldtithe = 0
	sleep(15)
	stopgambling = 0


/obj/structure/fake_machine/lottery_roguetown/attackby_secondary(obj/item/weapon, mob/user, params)
	. = ..()

	if(!ishuman(user) || stopgambling)
		return

	if(gamblingprice <= 0)
		say("Poor thing, you are coinless.")
		return

	if(gamblingprice < 0)
		say("Your peasant's tithe is NEGATIVE.")
		return

	// Build coin options
	var/list/choicez = list()
	if(gamblingprice > 10)
		choicez += "GOLD"
	if(gamblingprice > 5)
		choicez += "SILVER"
	choicez += "BRONZE"

	var/selection = input(user, "Make a Selection", src) as null|anything in choicez
	if(!selection)
		return

	// Calculate coin value
	var/mod = 1
	if(selection == "GOLD")
		mod = 10
	if(selection == "SILVER")
		mod = 5

	var/coin_amt = input(user, "Sayyid, you have [gamblingprice] mammon in tithes. You may withdraw [floor(gamblingprice/mod)] [selection] COINS.", src) as null|num
	coin_amt = round(coin_amt)

	if(coin_amt < 1)
		return

	if(!Adjacent(user) || stopgambling)
		return

	if((coin_amt * mod) > gamblingprice)
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	budget2change(coin_amt * mod, user, selection)
	gamblingprice -= coin_amt * mod


/obj/structure/fake_machine/lottery_roguetown/proc/peasant_betting()
	if(gamblingprice == oldtithe)
		gamblingprice += pick(1, 1, 1, 1, 2, 2)


/obj/structure/fake_machine/lottery_roguetown/proc/letsgogamblinggamblers()
	if(checkchatter > 1 || prob(90))
		return

	chatterbox = rand(1, 12)

	switch(chatterbox)
		if(1)
			say("I still remember the rain on my skin.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			say("The wind in my fur...or was it hair? Either way...")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)

		if(2)
			say("The worship of gods is pernicious.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(20)
			say("But this punishment is not as bad as others'! Ha-ha-ha!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

		if(3)
			say("There are fates worse than death...")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			say("...especially for a lowly fool who thought himself a king.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

		if(4)
			say("She didn't realize Her machine would kill Her, of course.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			say("...though 'tis difficult to argue what happened after that didn't benefit Her.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

		if(5)
			say("Oh, Psydon?")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
			sleep(30)
			say("To be honest, I'm about PSY-DONE with this whole debate! Ha-ha-h- ...No? Too soon? Alright.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

		if(6)
			say("You know, jester, those Ecclesials have the right idea.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			say("Won't someone think of the deadite-loving, tax-hating, drug-using murderers?!")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

		if(7)
			say("...well, don't look at me for conversation.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			say("I've been the one doing all the chatting.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)

		if(8)
			say("Can't you smell the stench in the air? It's terrible.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			say("It wasn't nearly so bad, before. Rot and puss. Oh, well.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

		if(9)
			say("Can't you smell the stench in the air, fool? It's terrible.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			say("I don't know how you could miss it. Rot and puss. Oh, well.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

		if(10)
			say("Maybe you ought stop while you are ahead, jester.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			say("...greed is what got your lot into this mess, after all.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

		if(11)
			say("A father and his son are riding a carriage through a forrest. Suddenly, Z's curse! The axle snaps!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			say("The father dies, but the son- the son yet lives! He's brought to the nearby village's physician.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			say("Upon seeing him, the physician ga-...what do you mean, you've heard this one before?")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

		else
			say("Me? Am I anybody important...? Oh, no.")
			playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
			sleep(25)
			say("I am nothing but a lowly jester, just like you! Ha-ha-ha!")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

	sleep(40)
	checkchatter = rand(1, 11)
