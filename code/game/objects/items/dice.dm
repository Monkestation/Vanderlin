/*****************************Dice Bags********************************/

/obj/item/storage/pill_bottle/dice
	name = "bag of dice"
	desc = ""
	icon = 'icons/obj/dice.dmi'
	icon_state = "dicebag"
	var/last_shake_time
	var/list/special_die = list(
				/obj/item/dice/d1,
				/obj/item/dice/d2,
				/obj/item/dice/fudge,
				/obj/item/dice/d6/space,
				/obj/item/dice/d00,
				/obj/item/dice/eightbd20,
				/obj/item/dice/fourdd6,
				/obj/item/dice/d100
				)
	populate_contents = list(
		/obj/item/dice/d4,
		/obj/item/dice/d6,
		/obj/item/dice/d6,
		/obj/item/dice/d8,
		/obj/item/dice/d10,
		/obj/item/dice/d12,
		/obj/item/dice/d20,
	)

/obj/item/storage/pill_bottle/dice/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is gambling with death! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (OXYLOSS)

/*****************************Dice********************************/

/obj/item/dice //depreciated d6, use /obj/item/dice/d6 if you actually want a d6
	name = "die"
	desc = ""
	icon = 'icons/obj/dice.dmi'
	icon_state = "d6"
	w_class = WEIGHT_CLASS_TINY
	var/sides = 6
	var/result = null
	var/list/special_faces = list() //entries should match up to sides var if used
	var/microwave_riggable = TRUE

	var/rigged = DICE_NOT_RIGGED
	var/rigged_value
	var/permanently_rigged = FALSE

/obj/item/dice/Initialize()
	. = ..()
	if(!result)
		result = roll(sides)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/dice/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is gambling with death! It looks like [user.p_theyre()] trying to commit suicide!"))
	return (OXYLOSS)

/obj/item/dice/proc/rig_dice(user)
	var/list/possible_outcomes = list()
	var/special = FALSE
	if(special_faces.len == sides)
		possible_outcomes.Add(special_faces)
		special = TRUE
	else
		for(var/i in 1 to sides)
			possible_outcomes += i
	var/outcome = input(user, "What will you rig the next roll to?", "XYLIX") as null|anything in possible_outcomes
	if(special)
		outcome = special_faces.Find(outcome)
	if(!outcome)
		return
	record_round_statistic(STATS_GAMES_RIGGED)
	rigged = DICE_BASICALLY_RIGGED
	rigged_value = outcome

/obj/item/dice/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(HAS_TRAIT(user, TRAIT_BLACKLEG))
		INVOKE_ASYNC(src, PROC_REF(rig_dice), user)
		return TRUE

/obj/item/dice/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(HAS_TRAIT(user, TRAIT_BLACKLEG))
		INVOKE_ASYNC(src, PROC_REF(rig_dice), user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/dice/d1
	name = "d1"
	icon_state = "d1"
	sides = 1

/obj/item/dice/d2
	name = "d2"
	icon_state = "d2"
	sides = 2

/obj/item/dice/d4
	name = "d4"
	icon_state = "d4"
	sides = 4

/obj/item/dice/d4/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, 1, 4) //1d4 damage

/obj/item/dice/d6
	name = "d6"

/obj/item/dice/d6/wood
	name = "die"
	desc = "A six sided die carved from wood."

/obj/item/dice/d6/bone
	name = "bone die"
	icon_state = "bone_d6"
	desc = "A six sided die carved from bone."

/obj/item/dice/d6/ebony
	name = "ebony die"
	icon_state = "de6"
	microwave_riggable = FALSE // You can't melt wood in the microwave

/obj/item/dice/d6/space
	name = "space cube"
	icon_state = "spaced6"

/obj/item/dice/d6/space/Initialize()
	. = ..()
	if(prob(10))
		name = "spess cube"

/obj/item/dice/fudge
	name = "fudge die"
	sides = 3 //shhh
	icon_state = "fudge"
	special_faces = list("minus","blank","plus")

/obj/item/dice/d8
	name = "d8"
	icon_state = "d8"
	sides = 8

/obj/item/dice/d10
	name = "d10"
	icon_state = "d10"
	sides = 10

/obj/item/dice/d00
	name = "d00"
	icon_state = "d00"
	sides = 10

/obj/item/dice/d12
	name = "d12"
	icon_state = "d12"
	sides = 12

/obj/item/dice/d20
	name = "d20"
	icon_state = "d20"
	sides = 20

/obj/item/dice/d100
	name = "d100"
	icon_state = "d100"
	w_class = WEIGHT_CLASS_SMALL
	sides = 100

/obj/item/dice/d100/Initialize(mapload, ...)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/dice/eightbd20
	name = "strange d20"
	icon_state = "8bd20"
	sides = 20
	special_faces = list("It is certain","It is decidedly so","Without a doubt","Yes, definitely","You may rely on it","As I see it, yes","Most likely","Outlook good","Yes","Signs point to yes","Reply hazy try again","Ask again later","Better not tell you now","Cannot predict now","Concentrate and ask again","Don't count on it","My reply is no","My sources say no","Outlook not so good","Very doubtful")

/obj/item/dice/eightbd20/Initialize(mapload, ...)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/dice/fourdd6
	name = "4d d6"
	icon_state = "4dd6"
	sides = 48
	special_faces = list("Cube-Side: 1-1","Cube-Side: 1-2","Cube-Side: 1-3","Cube-Side: 1-4","Cube-Side: 1-5","Cube-Side: 1-6","Cube-Side: 2-1","Cube-Side: 2-2","Cube-Side: 2-3","Cube-Side: 2-4","Cube-Side: 2-5","Cube-Side: 2-6","Cube-Side: 3-1","Cube-Side: 3-2","Cube-Side: 3-3","Cube-Side: 3-4","Cube-Side: 3-5","Cube-Side: 3-6","Cube-Side: 4-1","Cube-Side: 4-2","Cube-Side: 4-3","Cube-Side: 4-4","Cube-Side: 4-5","Cube-Side: 4-6","Cube-Side: 5-1","Cube-Side: 5-2","Cube-Side: 5-3","Cube-Side: 5-4","Cube-Side: 5-5","Cube-Side: 5-6","Cube-Side: 6-1","Cube-Side: 6-2","Cube-Side: 6-3","Cube-Side: 6-4","Cube-Side: 6-5","Cube-Side: 6-6","Cube-Side: 7-1","Cube-Side: 7-2","Cube-Side: 7-3","Cube-Side: 7-4","Cube-Side: 7-5","Cube-Side: 7-6","Cube-Side: 8-1","Cube-Side: 8-2","Cube-Side: 8-3","Cube-Side: 8-4","Cube-Side: 8-5","Cube-Side: 8-6")

/obj/item/dice/fourdd6/Initialize(mapload, ...)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/dice/attack_self(mob/user, list/modifiers)
	diceroll(user, TRUE)

/obj/item/dice/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	diceroll(thrownby, TRUE)
	. = ..()

/obj/item/dice/proc/diceroll(mob/user, var/shown)
	result = roll(sides)
	if(rigged != DICE_NOT_RIGGED && result != rigged_value)
		if(rigged == DICE_BASICALLY_RIGGED)
			if(prob(80))
				result = rigged_value
		else if(rigged == DICE_TOTALLY_RIGGED)
			result = rigged_value
	if(!permanently_rigged)
		rigged = DICE_NOT_RIGGED
		rigged_value = null

	. = result

	var/fake_result = roll(sides)//Daredevil isn't as good as he used to be
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "NAT 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	update_appearance(UPDATE_OVERLAYS)
	if(initial(icon_state) == "d00")
		result = (result - 1)*10
	if(special_faces.len == sides)
		result = special_faces[result]
	if(user != null) //Dice was rolled by someone
		if(shown)
			user.visible_message(span_notice("[user] has rolled [src]. It lands on [result]. [comment]"), \
								span_notice("I roll [src]. It lands on [result]. [comment]"), \
								span_hear("I hear [src] rolling, it sounds like a [fake_result]."))
		else
			to_chat(user, span_notice("I roll [src] in secret. It lands on [result]. [comment]"))
	else if(!src.throwing) //Dice was knocked around and is coming to rest
		visible_message(span_notice("[src] rolls to a stop, landing on [result]. [comment]"))

/obj/item/dice/update_overlays()
	. = ..()
	. += "[icon_state]-[result]"
