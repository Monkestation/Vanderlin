

/obj/item/natural/hide
	name = "hide"
	icon_state = "hide"
	desc = "Hide from one of Dendor's creachers."
	dropshrink = 0.90
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 5
/obj/item/natural/hide/cured
	name = "cured leather"
	icon_state = "leather"
	desc = "A hide piece that has been cured and may now be worked."
	sellprice = 7
	bundletype = /obj/item/natural/bundle/curred_hide

/obj/item/natural/bundle/curred_hide
	name = "bundle of cured leather"
	desc = "A bunch of cured leather pieces bundled together."
	icon_state = "leatherroll1"
	maxamount = 10
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/hide/cured
	stackname = "cured leather"
	icon1 = "leatherroll1"
	icon1step = 5
	icon2 = "leatherroll2"
	icon2step = 10

/obj/item/natural/cured/essence
	name = "essence of wilderness"
	icon_state = "wessence"
	desc = "A mystical essence embued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

/obj/item/natural/fur // a piece of skin with animal hair on it. Could be called a fur but its untanned and also encompasses rat skins and goat skins so pelt is more suitable at least to my ears.
	name = "fur"
	icon_state = "wool1"
	desc = "Pelt from one of Dendor's creachers."
	dropshrink = 0.90
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 5

/obj/item/natural/fur/gote
	desc = "Pelt from a gote."
	icon_state = "pelt_gote"

/obj/item/natural/fur/volf
	desc = "Pelt from a volf."
	icon_state = "pelt_volf"

/obj/item/natural/fur/mole
	desc = "Pelt from a mole."
	icon_state = "pelt_mole"

/obj/item/natural/fur/rous
	desc = "Pelt from a rous."
	icon_state = "pelt_rous"

/obj/item/natural/fur/cabbit
	desc = "Pelt from a cabbit."
	icon_state = "wool2"

/obj/item/natural/head
	possible_item_intents = list(/datum/intent/use)

/obj/item/natural/head/volf
	name = "volf head"
	desc = "the head of a fearsome volf."
	icon_state = "volfhead"
	layer = 3.1
	grid_height = 64
	grid_width = 64
	headpricemin = 3
	headpricemax = 7

/obj/item/natural/head/saiga
	name = "saiga head"
	desc = "the head of a proud saiga."
	icon_state = "saigahead"
	layer = 3.1
	grid_height = 64
	grid_width = 64
	headprice = 3

/obj/item/natural/head/troll
	name = "troll head"
	desc = "the head of a giant troll."
	icon_state = "trollhead"
	layer = 3.1
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE
	headpricemin = 80
	headpricemax = 230

/obj/item/natural/head/troll/axe
	name = "troll head"
	desc = "The head of a once mighty warrior troll."
	icon_state = "trollhead_axe"
	headpricemin = 90
	headpricemax = 250

/obj/item/natural/head/troll/cave
	name = "cave troll head"
	icon_state = "cavetrollhead"
	headpricemin = 120
	headpricemax = 280

/obj/item/natural/head/rous
	name = "rous head"
	desc = "the head of an unusually large rat."
	icon_state = "roushead"
	layer = 3.1
	grid_height = 64
	grid_width = 64
	headpricemin = 3
	headpricemax = 7

/obj/item/natural/head/spider
	name = "honeyspider head"
	desc = "the head of a venomous honeyspider."
	icon_state = "spiderhead"
	layer = 3.1
	grid_height = 64
	grid_width = 64
	headpricemin = 4
	headpricemax = 20

/obj/item/natural/head/bug
	name = "bogbug head"
	desc = "the head of a gross bogbug."
	icon_state = "boghead"
	layer = 3.1
	grid_height = 64
	grid_width = 64
	headpricemin = 4
	headpricemax = 15

/obj/item/natural/head/mole
	name = "mole head"
	desc = "the head of a lesser mole."
	icon_state = "molehead"
	layer = 3.1
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE
	headpricemin = 3
	headpricemax = 7

/obj/item/natural/head/gote
	name = "gote head"
	desc = "the head of a fiery gote."
	icon_state = "gotehead"
	layer = 3.1
	headprice = 2

//RTD make this a storage item and make clickign on animals with things put it in storage
/obj/item/natural/saddle
	name = "saddle"
	desc = "A culmination of leather, fur and hide. Strapped onto the backs of beasts for ease of riding."
	icon_state = "saddle"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = FLAMMABLE
	gripped_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	sellprice = 80
	twohands_required = TRUE

/obj/item/natural/saddle/attack(mob/living/target, mob/living/carbon/human/user)
	if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/S = target
		if(S.can_saddle && !S.ssaddle)
			if(!target.has_buckled_mobs())
				user.visible_message("<span class='warning'>[user] tries to saddle [target]...</span>")
				if(do_after(user, 4 SECONDS, target))
					playsound(loc, 'sound/foley/saddledismount.ogg', 100, FALSE)
					user.dropItemToGround(src)
					S.ssaddle = src
					src.forceMove(S)
					S.update_icon()
		return
	..()

/mob/living/simple_animal
	var/can_saddle = FALSE
	var/obj/item/ssaddle
	// A flat percentage bonus to our ability to detect sneaking people only. Use in lieu of giving mobs huge STAPER bonuses if you want them to be observant.
	var/simple_detect_bonus = 0

/mob/living/simple_animal/onbite(mob/living/carbon/human/user)
	var/damage = 10*(user.STASTR/20)
	if(HAS_TRAIT(user, TRAIT_STRONGBITE))
		damage = damage*2
	user.do_attack_animation(src, ATTACK_EFFECT_BITE)
	playsound(user.loc, "smallslash", 100, FALSE, -1)
	user.next_attack_msg.Cut()
	if(stat == DEAD)
		if(user.has_status_effect(/datum/status_effect/debuff/silver_curse))
			to_chat(user, span_notice("My power is weakened, I cannot heal!"))
			return
		if(user.mind && istype(user, /mob/living/carbon/human/species/werewolf))
			visible_message(span_danger("The werewolf ravenously consumes the [src]!"))
			to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
			user.reagents.add_reagent(/datum/reagent/medicine/healthpot, 30)
			gib()
		return
	if(src.apply_damage(damage, BRUTE))
		if(istype(user, /mob/living/carbon/human/species/werewolf))
			visible_message(span_danger("The werewolf bites into [src] and thrashes!"))
		else
			visible_message(span_danger("[user] bites [src]! What is wrong with them?"))
		if(HAS_TRAIT(user, TRAIT_POISONBITE))
			if(src.reagents)
				var/poison = user.STACON/2
				src.reagents.add_reagent(/datum/reagent/toxin/venom, poison/2)
				src.reagents.add_reagent(/datum/reagent/medicine/soporpot, poison)
				to_chat(user, span_warning("Your fangs inject venom into [src]!"))
