/obj/item/natural/fibers
	name = "fiber"
	desc = "Plant fiber. The peasants make their living sewing these into fabrics and clothing."
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	color = "#454032"
	firefuel = 1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	bundletype = /obj/item/natural/bundle/fibers

/obj/item/natural/silk
	name = "silk"
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	desc = "Silken strands. Their usage in clothing is exotic in all places save the Underdark."
	force = 0
	throwforce = 0
	color = "#e6e3db"
	firefuel = 1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	bundletype = /obj/item/natural/bundle/silk

#ifdef TESTSERVER

/client/verb/bloodnda()
	set category = "DEBUGTEST"
	set name = "bloodnda"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(GET_ATOM_BLOOD_DNA(I))
			testing("yep")
		else
			testing("nope")

#endif

/obj/item/natural/thorn
	name = "thorn"
	desc = "This bog-grown thorn is sharp and resistant like a needle."
	icon_state = "thorn"
	force = 10
	throwforce = 0
	possible_item_intents = list(/datum/intent/stab)
	firefuel = 1 MINUTES
	embedding = list("embedded_unsafe_removal_time" = 20, "embedded_pain_chance" = 10, "embedded_pain_multiplier" = 1, "embed_chance" = 35, "embedded_fall_chance" = 0)
	resistance_flags = FLAMMABLE
	max_integrity = 20
/obj/item/natural/thorn/attack_self(mob/living/user, list/modifiers)
	user.visible_message("<span class='warning'>[user] snaps [src].</span>")
	playsound(user,'sound/items/seedextract.ogg', 100, FALSE)
	qdel(src)

/obj/item/natural/thorn/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if(prob(prob2break))
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
			if (L.alpha == 0 && L.rogue_sneaking) // not anymore you're not
				L.update_sneak_invis(TRUE)
			L.consider_ambush()

/obj/item/natural/bundle/fibers
	name = "fiber bundle"
	desc = "Fibers, bundled together."
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	maxamount = 12
	color = "#454032"
	firemod =  1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/fibers
	icon1step = 3
	icon2step = 6

/obj/item/natural/bundle/fibers/full/Initialize()
	. = ..()
	amount = maxamount
	update_bundle()

/obj/item/natural/bundle/silk
	name = "silken weave"
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Silk neatly woven together."
	force = 0
	throwforce = 0
	maxamount = 6
	color = "#e6e3db"
	firemod = 1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/silk
	icon1step = 3
	icon2step = 6

/obj/item/natural/bundle/cloth
	name = "bundle of cloth"
	icon_state = "clothroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "A cloth roll of several pieces of fabric."
	force = 0
	throwforce = 0
	maxamount = 10
	firemod = 3 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/cloth
	stackname = "cloth"
	icon1 = "clothroll1"
	icon1step = 5
	icon2 = "clothroll2"
	icon2step = 10

/obj/item/natural/bundle/cloth/full/Initialize()
	. = ..()
	amount = maxamount
	update_bundle()

/obj/item/natural/bundle/stick
	name = "bundle of sticks"
	desc = "A bundle of wooden sticks, looks like they all need to stick together!"
	icon_state = "stickbundle1"
	possible_item_intents = list(/datum/intent/use)
	maxamount = 10
	force = 0
	throwforce = 0
	firemod = 5 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/grown/log/tree/stick
	stackname = "sticks"
	icon1 = "stickbundle1"
	icon1step = 4
	icon2 = "stickbundle2"
	icon2step = 7
	icon3 = "stickbundle3"

/obj/item/natural/bowstring
	name = "fibre bowstring"
	desc = "A simple cord of bowstring."
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	color = COLOR_BEIGE
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE

/obj/item/natural/bundle/worms
	name = "worms"
	desc = "Multiple wriggly worms."
	icon_state = "worm2"
	color = "#964B00"
	maxamount = 6
	icon1 = "worm2"
	icon1step = 3
	icon2 = "worm3"
	icon2step = 5
	icon3 = "worm4"
	stacktype = /obj/item/natural/worms
	stackname = "worms"

/obj/item/natural/bundle/bone
	name = "stack of bones"
	icon_state = "bonestack1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Bones stacked upon one another."
	force = 0
	throwforce = 0
	maxamount = 6
	color = null
	firefuel = null
	firemod = 0
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/alch/bone
	stackname = "bones"
	icon1 = "bonestack1"
	icon1step = 2
	icon2 = "bonestack2"
	icon2step = 4

/obj/item/natural/bundle/bone/full/Initialize()
	. = ..()
	amount = maxamount
	update_bundle()
