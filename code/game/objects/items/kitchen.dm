/* Kitchen tools
 * Contains:
 *		Fork
 *		Kitchen knives
 *		Ritual Knife
 *		Butcher's cleaver
 *		Combat Knife
 *		Rolling Pins
 *		Plastic Utensils
 */

/obj/item/kitchen/fork
	name = "fork"
	desc = ""
	icon_state = "fork"
	force = 5
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 1
	throw_range = 5
	flags_1 = CONDUCT_1
	possible_item_intents = list(/datum/intent/food, /datum/intent/stab)
	attack_verb = list("attacked", "stabbed", "poked")
	hitsound = 'sound/blank.ogg'
	armor = list("blunt" = 0, "slash" = 0, "stab" = 0,  "piercing" = 0, "fire" = 50, "acid" = 30)
	var/datum/reagent/forkload //used to eat omelette

/obj/item/kitchen/fork/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] stabs \the [src] into [user.p_their()] chest! It looks like [user.p_theyre()] trying to take a bite out of [user.p_them()]self!</span>")
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	return BRUTELOSS

/obj/item/kitchen/fork/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(istype(A, /obj/item/reagent_containers/food/snacks) && user.used_intent.type == /datum/intent/food)
		var/obj/item/reagent_containers/food/snacks/S = A
		S.attack(user, user)
		user.changeNext_move(CLICK_CD_MELEE)
		return TRUE
	. = ..()

/obj/item/kitchen/fork/attack(mob/living/carbon/M, mob/living/carbon/user, list/modifiers)
	if(!istype(M))
		return ..()

	if(forkload)
		if(M == user)
			M.visible_message("<span class='notice'>[user] eats a delicious forkful of food!</span>")
			M.reagents.add_reagent(forkload.type, 1)
		else
			M.visible_message("<span class='notice'>[user] feeds [user] a delicious forkful of food!</span>")
			M.reagents.add_reagent(forkload.type, 1)
		icon_state = "fork"
		forkload = null


	// else if(user.zone_selected == BODY_ZONE_PRECISE_R_EYE)
	// 	return eyestab(M,user)
	else
		return ..()

/obj/item/kitchen/rollingpin
	name = "rolling pin"
	desc = ""
	icon_state = "rolling_pin"
	item_state = "rolling_pin"
	force = 11
	throwforce = 5
	throw_speed = 1
	throw_range = 7
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("bashed", "battered", "bludgeoned", "thrashed", "whacked")
	custom_price = 5
	resistance_flags = FLAMMABLE // Weapon made mostly of wood
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	smeltresult = /obj/item/fertilizer/ash
	experimental_inhand = FALSE

/obj/item/kitchen/rollingpin/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins flattening [user.p_their()] head with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS
