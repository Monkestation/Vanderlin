/obj/item/dice_cup
	name = "metal dice cup"
	//in an ideal world, would make it both a reagent container and a dice cup, but I don't want to deal with issues of
	//rolling dice with a liquid inside. Like you would probably have to make a way for the insides to spill out right?
	desc = "An iron dice cup, used for rolling dice in secret."
	icon = 'icons/obj/dice.dmi'
	icon_state = "iron_cup"
	force = 5
	throwforce = 10
	dropshrink = 0.75
	w_class = WEIGHT_CLASS_NORMAL
	obj_flags = CAN_BE_HIT
	grid_height = 64
	grid_width = 32
	sellprice = 1
	melting_material = /datum/material/iron
	melt_amount = 25
	var/max_dice = 8
	var/list/dice_list = list()
	var/list/last_roll = list()

//done so we can have pre-filled dice cups
/obj/item/dice_cup/Initialize()
	. = ..()
	var/length = length(dice_list)
	if(length)
		if(length >= max_dice)
			stack_trace("[type] has more dice in its starter list than the allowed max dice.")
		for(var/obj/item/dice/dice as anything in dice_list)
			dice_list -= dice
			add_dice(new dice())

/obj/item/dice_cup/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(!istype(I, /obj/item/dice))
		return ..()
	if(length(dice_list) >= max_dice)
		to_chat(user, span_warning("\The [src] is full."))
		return
	to_chat(user, span_notice("I put [I] into \the [src]."))
	if(!user.temporarilyRemoveItemFromInventory(I))
		return
	add_dice(I)

/obj/item/dice_cup/proc/add_dice(obj/item/I)
	if(!I || !istype(I))
		return
	I.forceMove(src)
	dice_list += I

/obj/item/dice_cup/proc/pick_dice(mob/user)
	if(!length(dice_list))
		return
	var/obj/item/dice/die = pick(dice_list)
	dice_list -= die
	die.forceMove(user.loc)
	user.put_in_hands(die)
	return die

/obj/item/dice_cup/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(length(dice_list))
		var/obj/item/dice/die = pick_dice(user)
		to_chat(user, span_notice("I remove \a [die] from [src]."))
		user.put_in_active_hand(die)
		if(!length(dice_list))
			last_roll.Cut()
	else
		to_chat(user, span_notice("No dice."))//heh
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/dice_cup/attack_self(mob/user, list/modifiers)
	if(!length(dice_list))
		to_chat(user, span_warning("There are no dice to roll!"))
		return
	var/option = browser_input_list(user, "Do you wish to roll the die in secret?", "XYLIX", DEFAULT_INPUT_CHOICES)
	if(!option)
		return
	var/public_roll = TRUE
	if(option == CHOICE_YES)
		public_roll = FALSE
	last_roll.Cut()
	for(var/obj/item/dice/die in dice_list)
		die.diceroll(user, public_roll)
		last_roll += die.result
	if(!public_roll)
		user.visible_message(span_notice("[user] rolls dice in secret using [src]."), span_notice("I roll dice in secret using [src]."))

/obj/item/dice_cup/examine(mob/user)
	. = ..()
	if(!length(contents))
		desc = initial(desc)
		return
	desc = initial(desc)
	desc += "\n" + ("Contains [length(contents)] dice.")
	if(last_roll.len)
		desc += "\n" + ("Last rolls were: [last_roll.Join(", ")]")
	return ..()

/obj/item/dice_cup/proc/rig_dice_cup(user)
	var/obj/item/dice/which_one = browser_input_list(user, "Which die will you rig in your next roll?", "XYLIX", dice_list)
	if(which_one)
		INVOKE_ASYNC(which_one, TYPE_PROC_REF(/obj/item/dice, rig_dice), user)

/obj/item/dice_cup/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(HAS_TRAIT(user, TRAIT_BLACKLEG))
		INVOKE_ASYNC(src, PROC_REF(rig_dice_cup), user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/dice_cup/wooden
	name = "wooden dice cup"
	desc = "A wooden dice cup, used for rolling dice."
	icon_state = "wood_cup"
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
	metalizer_result = /obj/item/dice_cup

//a basic setup for liars dice, each player has 5 dice
/obj/item/dice_cup/wooden/liars_dice
	dice_list = list(/obj/item/dice/d6/wood, /obj/item/dice/d6/wood, /obj/item/dice/d6/wood, /obj/item/dice/d6/wood, /obj/item/dice/d6/wood)
