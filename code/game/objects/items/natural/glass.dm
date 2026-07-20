/obj/item/natural/glass
	name = "glass"
	desc = "A glass pane for constructing windows."
	icon_state = "glasspane"
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	possible_item_intents = list(/datum/intent/use)
	force = 10
	throwforce = 12
	throw_range = 5
	max_integrity = 20
	w_class = WEIGHT_CLASS_BULKY
	bundletype = /obj/item/natural/bundle/glass
	item_weight = 450 GRAMS

/obj/item/natural/bundle/glass
	name = "stack of glass"
	desc = "A stack of fragile glass panes."
	icon_state = "glasspane1"
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	item_state = "glasspane"
	possible_item_intents = list(/datum/intent/use)
	force = 15
	throwforce = 18
	throw_range = 2
	firefuel = null
	resistance_flags = null
	firemod = null
	w_class = WEIGHT_CLASS_HUGE
	stackname = "glass"
	stacktype = /obj/item/natural/glass
	maxamount = 3
	icon1 = "glasspane1"
	icon1step = 2
	icon2 = "glasspane2"
	icon2step = 3

/obj/item/natural/glass/shard
	name = "shard"
	desc = "A sharp shard of glass."
	icon = 'icons/obj/shards.dmi'
	icon_state = "large"
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	item_state = "shard"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/stab)
	force = 3
	throwforce = 5
	resistance_flags = null
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("stabbed", "slashed", "sliced", "cut")
	max_integrity = 40
	smeltresult = /obj/item/natural/glass
