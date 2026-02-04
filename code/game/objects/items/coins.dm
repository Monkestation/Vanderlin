#define CTYPE_GOLD "g"
#define CTYPE_SILV "s"
#define CTYPE_COPP "c"
#define CTYPE_INQU "i"
#define CTYPE_ANCI "a"
#define MAX_COIN_STACK_SIZE 20

/obj/item/coin
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = ""
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.2
	drop_sound = 'sound/foley/coinphy (1).ogg'
	sellprice = 0
	static_price = TRUE
	simpleton_price = TRUE

	COOLDOWN_DECLARE(flip_cd)
	var/heads_tails = TRUE
	var/last_merged_heads_tails = TRUE
	var/base_type //used for compares
	var/quantity = 1
	var/plural_name
	var/rigged_outcome = 0 //1 for heads, 2 for tails

/obj/item/coin/on_consume(mob/living/eater)
	. = ..()
	eater.sellprice += quantity * sellprice

/obj/item/coin/Initialize(mapload, coin_amount)
	. = ..()
	if(coin_amount >= 1)
		set_quantity(floor(coin_amount))

/obj/item/coin/getonmobprop(tag)
	. = ..()
	if(tag != "gen")
		return
	return list("shrink" = 0.10, "sx" = -6, "sy" = 6, "nx" = 6, "ny" = 7, "wx" = 0, "wy" = 5, "ex" = -1, "ey" = 7, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -50, "sturn" = 40, "wturn" = 50, "eturn" = -50, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)

/obj/item/coin/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(src, 'sound/foley/coins1.ogg', 100, TRUE, -2)
	scatter(get_turf(src))
	..()

/obj/item/coin/pickup(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_MATTHIOS_CURSE) && prob(33))
		var/mob/living/carbon/human/H = user
		to_chat(H, span_warning("The idea repulses me!"))
		H.cursed_freak_out()
		H.Paralyze(4 SECONDS)
		return

/obj/item/coin/proc/scatter(turf/T)
	pixel_x = base_pixel_x + rand(-8, 8)
	pixel_y = base_pixel_y + rand(-5, 5)
	if(isturf(T) && quantity > 1)
		for(var/i in 2 to quantity) // exclude the first coin
			var/spawned_type = type
			if(base_type)
				switch(base_type)
					if(CTYPE_GOLD)
						spawned_type = /obj/item/coin/gold
					if(CTYPE_SILV)
						spawned_type = /obj/item/coin/silver
					if(CTYPE_COPP)
						spawned_type = /obj/item/coin/copper
					if(CTYPE_INQU)
						spawned_type = /obj/item/coin/inqcoin
					if(CTYPE_ANCI)
						spawned_type = /obj/item/coin/copper
					else
						return // Don't destroy coins into copper

			var/obj/item/coin/new_coin = new spawned_type
			new_coin.forceMove(T)
			new_coin.set_quantity(1) // prevent exploits with coin piles
			new_coin.pixel_x = new_coin.base_pixel_x + rand(-8, 8)
			new_coin.pixel_y = new_coin.base_pixel_y + rand(-5, 5)

	set_quantity(1)

/obj/item/coin/get_real_price()
	return sellprice * quantity

/obj/item/coin/proc/set_quantity(new_quantity)
	quantity = new_quantity
	if(quantity > 1)
		drop_sound = 'sound/foley/coins1.ogg'
	else
		drop_sound = 'sound/foley/coinphy (1).ogg'
	if(quantity == 1 || quantity == 2)
		dropshrink = 0.2
	else
		dropshrink = 1
	update_appearance(UPDATE_ICON_STATE | UPDATE_DESC | UPDATE_NAME)
	update_transform()

/obj/item/coin/get_displayed_price(mob/user)
	return FALSE  // Coins never show generic price text

/obj/item/coin/examine(mob/user)
	. = ..()
	var/denomination = quantity == 1 ? name : plural_name
	if(isobserver(user))
		. += span_info("[quantity_to_words(quantity)] [denomination] ([get_real_price()] mammon)")
		return

	if(HAS_TRAIT(user, TRAIT_COIN_ILLITERATE))
		if(quantity <= 1)
			. += span_info("A coin.")
		else
			. += span_info("[quantity_to_words(quantity)] coins.")
		return

	var/intelligence = user.mind?.current.STAINT
	if(quantity <= 1)  // Just so you don't count single coins, observers don't need to count.
		. += span_info("One [name] ([sellprice] mammon)")
		return

	var/list/skill_data = coin_skill(user, quantity)
	var/fuzzy_quantity = CLAMP(quantity + skill_data["error"], 1,  (quantity > 20) ? INFINITY : 20) // Cap at 20 only for small stacks)
	var/uncertainty_phrases = list("maybe","you think","roughly","perhaps","around","probably")

	switch(intelligence)						// Intelligence-based messaging
		if(0 to 6)
			user.visible_message(span_small(span_notice("[user] clumsily starts to count [src].")),span_small(span_notice("I clumsily start counting [src]...")), vision_distance = 2)
		if(7 to 9)
			user.visible_message(span_small(span_notice("[user] begins counting [src].")),span_small(span_notice("I begin counting [src].")), vision_distance = 2)
		if(10 to 13)
			user.visible_message(span_small(span_notice("[user] counts [src].")),span_small(span_notice("I count [src].")), vision_distance = 2)
		if(14 to INFINITY)
			user.visible_message(span_small(span_info("[user] effortlessly tallies [src].")),span_small(span_notice("I effortlessly tally [src].")), vision_distance = 2)

	if(!do_after(user, skill_data["delay"]))
		return

	var/estimated_value = fuzzy_quantity * sellprice
	estimated_value = CLAMP(estimated_value, sellprice, INFINITY)
	var/description = "[quantity_to_words(fuzzy_quantity)] [denomination]"
	var/value_text
	if(intelligence >= 10)
		value_text = "[estimated_value] mammon"
	else
		value_text = "~[estimated_value] mammon"
		if(intelligence <= 7)
			value_text = "[pick(uncertainty_phrases)] [value_text]"
			if(prob(30))
				value_text += "?"
	. += span_info("[description] ([value_text])")

/obj/item/coin/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src && quantity > 1)
		var/intended = input(user, "How many [plural_name] to split?", null, 1) as null|num
		if(QDELETED(src) || !user.is_holding(src))
			return
		intended = clamp(intended, 0, quantity)
		intended = round(intended, 1)
		if(!intended)
			return

		var/list/skill_data = coin_skill(user, intended)		// Get skill-based parameters
		var/delay_time = skill_data["delay"]

		if(delay_time > 5 SECONDS)			// Chat feedback
			user.visible_message(span_small(span_notice("[user] fumbles through [src].")),span_small(span_warning("You struggle to count while separating [src]!")), vision_distance = 2)
		else if(delay_time >= 1 SECONDS)
			user.visible_message(span_small(span_notice("[user] carefully separates out [src].")),span_small(span_notice("You concentrate on separating [src].")), vision_distance = 2)
		else if(delay_time == 0)
			user.visible_message(span_small(span_notice("[user] quickly splits [src].")),span_small(span_notice("You effortlessly divide [src].")), vision_distance = 2)

		if(delay_time > 0 && !do_after(user, delay_time))	// Make sure people don't move to cancel the delay
			return

		if(intended >= quantity)
			return ..()
		var/obj/item/coin/new_coins = new type()	// Split coins
		new_coins.set_quantity(intended)
		new_coins.heads_tails = last_merged_heads_tails
		set_quantity(quantity - intended)

		user.put_in_hands(new_coins)
		playsound(src, 'sound/foley/coins1.ogg', 100, TRUE, -2)
		return
	. = ..()

/obj/item/coin/proc/coin_skill(mob/user, intended)		// Coin counting and splitting
	var/intelligence = user.mind?.current.STAINT
	var/perception = user.mind?.current.STAPER
	var/speed = user.mind?.current.STASPD
	var/mathematics_skill = user.get_skill_level(/datum/skill/labor/mathematics) || 0
	var/list/skill_data = list("delay" = 1.2 SECONDS,"error" = 0)

	var/base_tier	// Base intelligence tiers
	switch(intelligence)
		if(0 to 6)
			base_tier = 1 			// Low INT
		if(7 to 9)
			base_tier = 2			// Below average INT
		if(10 to 11)
			base_tier = 3			// Average INT
		if(14 to INFINITY)
			base_tier = 4	// Very High INT
		else base_tier = 3 // Default for 12-13

	// Apply mathematics tier boost
	var/tier_boost = clamp(mathematics_skill - 1, 0, 4) // +1 tier for level 2, +2 for level 3+, etc.
	var/effective_tier = clamp(base_tier + tier_boost, 1, 4)

	switch(effective_tier)	// Set values based on effective tier
		if(1) // Very low INT
			skill_data["error"] = rand(-3,3)
			skill_data["delay"] = 3.5 SECONDS
		if(2) // Below Average INT
			skill_data["error"] = rand(-1,1)
			if(prob(10))
				skill_data["error"] += rand(-2,2)
		if(3) // Average INT
			if(prob(5))
				skill_data["error"] = rand(-1,1)
		if(4) // Genius
			skill_data["delay"] = 0

	if(perception < 7 && mathematics_skill == 0)	// Secondary stat modifiers
		skill_data["error"] += rand(-1,1)
	if(speed < 5)
		skill_data["delay"] += 1 SECONDS

	if(intended > 10 && mathematics_skill == 0) // can't count beyond your fingers
		skill_data["delay"] += 0.25 SECONDS

	return skill_data


/obj/item/coin/proc/quantity_to_words(amount)
	switch(amount)
		if(1 to 4)
			return "A few"
		if(5 to 9)
			return "Several"
		if(10 to 14)
			return "A dozen or so"
		if(15 to 19)
			return "A large number of"
		if(20)
			return "A full stack of"
		if(21 to INFINITY)
			return "An unbelieavably big stack of"
		else
			return "Some"

/obj/item/coin/proc/merge(obj/item/coin/G, mob/user)
	if(!G)
		return
	if(G.base_type != base_type)
		return
	if(user)
		if(user.get_inactive_held_item() != G && !isturf(G.loc) && user.get_active_held_item() != G)
			return

	var/amt_to_merge = min(G.quantity, MAX_COIN_STACK_SIZE - quantity)
	if(amt_to_merge <= 0)
		return
	set_quantity(quantity + amt_to_merge)
	last_merged_heads_tails = G.heads_tails

	G.set_quantity(G.quantity - amt_to_merge)
	rigged_outcome = 0
	G.rigged_outcome = 0
	if(G.quantity <= 0)
		qdel(G)
	playsound(src, 'sound/foley/coins1.ogg', 100, TRUE, -2)

/obj/item/coin/proc/rig_coin(mob/user)
	var/outcome = alert(user, "What will you rig the next coin flip to?","XYLIX","Heads","Tails","Play fair")
	if(QDELETED(src) || !user.is_holding(src))
		return
	switch(outcome)
		if("Heads")
			rigged_outcome = 1
			record_round_statistic(STATS_GAMES_RIGGED)
		if("Tails")
			rigged_outcome = 2
			record_round_statistic(STATS_GAMES_RIGGED)
		if("Play fair")
			rigged_outcome = 0

/obj/item/coin/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(quantity == 1 && HAS_TRAIT(user, TRAIT_BLACKLEG))
		INVOKE_ASYNC(src, PROC_REF(rig_coin), user)
		return TRUE

/obj/item/coin/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(quantity == 1)
		if(HAS_TRAIT(user, TRAIT_BLACKLEG))
			INVOKE_ASYNC(src, PROC_REF(rig_coin), user)
		return

	var/spawned_type
	if(base_type)
		switch(base_type)
			if(CTYPE_GOLD)
				spawned_type = /obj/item/coin/gold
			if(CTYPE_SILV)
				spawned_type = /obj/item/coin/silver
			if(CTYPE_INQU)
				spawned_type = /obj/item/coin/inqcoin
			else
				spawned_type = /obj/item/coin/copper
	if(spawned_type)
		user.put_in_active_hand(new spawned_type(user.loc, 1))
		set_quantity(quantity - 1)

/obj/item/coin/attack_self(mob/living/user, list/modifiers)
	if(quantity > 1 || !base_type)
		return
	if(!COOLDOWN_FINISHED(src, flip_cd))
		return
	COOLDOWN_START(src, flip_cd, 3 SECONDS)

	playsound(user, 'sound/foley/coinphy (1).ogg', 100, FALSE)
	var/flip_outcome = rigged_outcome ? rigged_outcome : prob(50)
	if(rigged_outcome)
		record_featured_stat(FEATURED_STATS_CRIMINALS, user)
		record_round_statistic(STATS_GAMES_RIGGED)
	var/outcome_text
	switch(flip_outcome)
		if(1)
			user.visible_message(span_info("[user] flips the coin. Heads!"))
			heads_tails = TRUE
			outcome_text = "heads"
		if(0,2)
			user.visible_message(span_info("[user] flips the coin. Tails!"))
			heads_tails = FALSE
			outcome_text = "tails"

	SEND_SIGNAL(user, COMSIG_COIN_FLIPPED, user, src, outcome_text)

	rigged_outcome = 0
	update_appearance(UPDATE_ICON_STATE)

/obj/item/coin/update_icon_state()
	. = ..()
	switch(quantity)
		if(1)
			icon_state = "[base_type][heads_tails]"
		if(2)
			icon_state = "[base_type]m"
			if(heads_tails == last_merged_heads_tails)
				icon_state = "[base_type][heads_tails]1"
		if(3)
			icon_state = "[base_type]2"
		if(4 to 5)
			icon_state = "[base_type]3"
		if(6 to 10)
			icon_state = "[base_type]5"
		if(11 to 15)
			icon_state = "[base_type]10"
		if(16 to INFINITY)
			icon_state = "[base_type]15"

/obj/item/coin/update_name()
	. = ..()
	if(quantity == 1)
		name = initial(name)
		gender = NEUTER
	else
		name = plural_name
		gender = PLURAL

/obj/item/coin/update_desc()
	. = ..()
	if(quantity == 1)
		desc = initial(desc)
	else
		desc = ""

/obj/item/coin/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/coin))
		var/obj/item/coin/G = I
		if(item_flags & IN_STORAGE)
			merge(G, user)
		else
			G.merge(src, user)
		return
	return ..()

//GOLD
/obj/item/coin/gold
	name = "zenar"
	desc = "A gold coin bearing the symbol of the Taurus and the pre-kingdom psycross. These were in the best condition of the provincial gold mints, the rest were melted down. It's valued at 10 mammon per coin."
	icon_state = "g1"
	sellprice = 10
	base_type = CTYPE_GOLD
	plural_name = "zenarii"


// SILVER
/obj/item/coin/silver
	name = "ziliqua"
	desc = "An ancient silver coin still in use due to its remarkable ability to last the ages. Though silver in name, the metal was alloyed and treated long ago, stripping it of any bane against the undead. It's valued at 5 mammon per coin."
	icon_state = "s1"
	sellprice = 5
	base_type = CTYPE_SILV
	plural_name = "ziliquae"

// COPPER
/obj/item/coin/copper
	name = "zenny"
	desc = "A brand-new bronze coin minted by the capital in an effort to be rid of the financial use of silver. It's valued at 1 mammon per coin."
	icon_state = "c1"
	sellprice = 1
	base_type = CTYPE_COPP
	plural_name = "zennies"

/obj/item/coin/copper/pile/Initialize(mapload, coin_amount)
	. = ..()
	if(!coin_amount)
		set_quantity(rand(4,14))

/obj/item/coin/silver/pile/Initialize(mapload, coin_amount)
	. = ..()
	if(!coin_amount)
		set_quantity(rand(4,14))

/obj/item/coin/gold/pile/Initialize(mapload, coin_amount)
	. = ..()
	if(!coin_amount)
		set_quantity(rand(4,14))

/obj/item/coin/silver/pile/xylix
	name = MAP_SWITCH("ziliqua", "INFINTE COIN PILE")

/obj/item/coin/silver/pile/xylix/Initialize()
	. = ..()
	set_quantity(rand(6,9))

/obj/item/coin/inqcoin
	name = "oratorium marque"
	desc = "A blessed silver coin finished with a unique wash of black dye, bearing the post-kingdom Psycross. Kingsfield has denied the existence of such a coin when queried, as such coinage is rumoured to be used internally by the Oratorium Throni Vacui."
	icon_state = "i1"
	sellprice = 0
	base_type = CTYPE_INQU
	plural_name = "oratorium marques"

/obj/item/coin/inqcoin/pile/Initialize()
	. = ..()
	set_quantity(rand(4,19))

/obj/item/coin/inqcoin/attack_self(mob/living/user)
	if(quantity > 1 || !base_type)
		return
	if(!COOLDOWN_FINISHED(src, flip_cd))
		return
	COOLDOWN_START(src, flip_cd, 3 SECONDS)
	playsound(user, 'sound/foley/coinphy (1).ogg', 100, FALSE)
	if(prob(50))
		user.visible_message(span_info("[user] flips the coin. ENDURE!"))
		heads_tails = TRUE
	else
		user.visible_message(span_info("[user] flips the coin. LIVE!"))
		heads_tails = FALSE
	update_appearance(UPDATE_ICON_STATE)

#undef CTYPE_GOLD
#undef CTYPE_SILV
#undef CTYPE_COPP
#undef CTYPE_INQU
#undef CTYPE_ANCI
#undef MAX_COIN_STACK_SIZE
