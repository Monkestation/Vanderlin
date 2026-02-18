

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
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
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

/obj/item/natural/fur/direbear
	desc = "fur from one of Dendor's mightiest creachers."
	icon_state = "pelt_direbear"
	color = "#33302b"
	sellprice = 28

/obj/item/natural/fur/fox
	desc = "Fur from a venard."
	icon_state = "pelt_fox"
	color = null

/obj/item/natural/fur/raccoon
	desc = "Fur from a raccoon."
	icon_state = "pelt_raccoon"
	color = null
	sellprice = 12

/obj/item/natural/fur/bobcat
	desc = "Fur from a lynx."
	icon_state = "pelt_bobcat"
	color = null

/obj/item/natural/head
	possible_item_intents = list(/datum/intent/use)
	layer = 3.1
	grid_height = 64
	grid_width = 64
	w_class = WEIGHT_CLASS_NORMAL
	var/meat_to_give = /obj/item/reagent_containers/food/snacks/meat/steak
	var/rotten = FALSE

//quality from butchering, 0 is bad, 1 is normal, 2 is good, -1 means its rotten and useless
/obj/item/natural/head/proc/ButcheringResults(butchering_quality)
	switch(butchering_quality)
		if(0)
			sellprice = floor(sellprice * 0.75)
			headpricemin = floor(headpricemin * 0.75)
			headpricemax = floor(headpricemax * 0.75)
		if(1)
			EMPTY_BLOCK_GUARD
		if(2)
			sellprice = floor(sellprice * 1.25)
			headpricemin = floor(headpricemin * 1.25)
			headpricemax = floor(headpricemax * 1.25)
		if(-1)
			sellprice = floor(sellprice * 0.1)
			headpricemin = floor(headpricemin * 0.1)
			headpricemax = floor(headpricemax * 0.1)
			var/initial_name = name
			name = "rotten [initial_name]"
			rotten = TRUE

/obj/item/natural/head/MiddleClick(mob/living/user, list/modifiers)
	var/obj/item/held_item = user.get_active_held_item()
	if(held_item)
		var/path_to_check = ispath(held_item) ? held_item : held_item.type
		if(ispath(path_to_check, /obj/item/weapon/knife))
			var/butchering_skill = user.get_skill_level(/datum/skill/labor/butchering, TRUE)
			var/used_time = 8
			used_time = (used_time - 0.5 * butchering_skill) SECONDS
			visible_message("[user] begins to butcher \the [src].")
			playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
			var/amt2raise = user.STAINT/4
			if(do_after(user, used_time, src))
				var/obj/item/I = new meat_to_give(get_turf(src))
				if(rotten && istype(I,/obj/item/reagent_containers/food/snacks))
					var/obj/item/reagent_containers/food/snacks/F = I
					F.become_rotten()
				new /obj/effect/decal/cleanable/blood/splatter(get_turf(src))
				user.adjust_experience(/datum/skill/labor/butchering, amt2raise, FALSE)
				qdel(src)
	..()

/obj/item/natural/head/volf
	name = "volf head"
	desc = "The severed head of a fearsome volf."
	icon_state = "volfhead"
	headpricemin = 3
	headpricemax = 7
	sellprice = 5

/obj/item/natural/head/saiga
	name = "saiga head"
	desc = "The severed head of a proud saiga."
	icon_state = "saigahead"
	headprice = 3
	sellprice = 3

/obj/item/natural/head/troll
	name = "troll head"
	desc = "The severed head of a giant troll."
	icon_state = "trollhead"
	grid_height = 96
	grid_width = 96
	w_class = WEIGHT_CLASS_BULKY
	headpricemin = 80
	headpricemax = 230
	sellprice = 155

/obj/item/natural/head/troll/apply_components()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/natural/head/troll/axe
	name = "troll head"
	desc = "The severed head of a once mighty warrior troll."
	icon_state = "trollhead_axe"
	headpricemin = 90
	headpricemax = 250
	sellprice = 170

/obj/item/natural/head/troll/cave
	name = "cave troll head"
	icon_state = "cavetrollhead"
	headpricemin = 120
	headpricemax = 280
	sellprice = 200

/obj/item/natural/head/rous
	name = "rous head"
	desc = "The severed head of an unusually large rat."
	icon_state = "roushead"
	headpricemin = 3
	headpricemax = 7
	sellprice = 5
	meat_to_give = /obj/item/reagent_containers/food/snacks/meat/mince/beef

/obj/item/natural/head/direbear
	name = "direbear head"
	desc = "The head of a terrifying direbear."
	icon_state = "direbearhead"
	layer = 3.1
	sellprice = 20

/obj/item/natural/head/fox
	name = "venard head"
	desc = "The head of a majestic venard."
	icon_state = "foxhead"
	layer = 3.1
	grid_height = 32
	sellprice = 6

/obj/item/natural/head/spider
	name = "beespider head"
	desc = "The severed head of a venomous beespider."
	icon_state = "spiderhead"
	headpricemin = 4
	headpricemax = 20
	sellprice = 12
	meat_to_give = /obj/item/reagent_containers/food/snacks/meat/strange

/obj/item/natural/head/bug
	name = "bogbug head"
	desc = "The severed head of a gross bogbug."
	icon_state = "boghead"
	headpricemin = 4
	headpricemax = 15
	sellprice = 10
	meat_to_give = /obj/item/reagent_containers/food/snacks/meat/strange

/obj/item/natural/head/mole
	name = "mole head"
	desc = "The severed head of a lesser mole."
	icon_state = "molehead"
	grid_height = 96
	grid_width = 96
	headpricemin = 3
	headpricemax = 7
	sellprice = 5

/obj/item/natural/head/mole/apply_components()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/natural/head/gote
	name = "gote head"
	desc = "The severed head of a fiery gote."
	icon_state = "gotehead"
	headprice = 2
	sellprice = 2

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

/obj/item/natural/saddle/apply_components()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/natural/saddle/attack(mob/living/target, mob/living/carbon/human/user, list/modifiers)
	if(istype(target, /mob/living/simple_animal))
		var/mob/living/simple_animal/S = target
		if(S.can_saddle && !S.ssaddle)
			if(!target.has_buckled_mobs())
				user.visible_message("<span class='warning'>[user] tries to saddle [target]...</span>")
				if(do_after(user, 4 SECONDS, target))
					playsound(src, 'sound/foley/saddledismount.ogg', 100, FALSE)
					user.dropItemToGround(src)
					S.ssaddle = src
					src.forceMove(S)
					S.update_appearance(UPDATE_OVERLAYS)
		return
	..()

/mob/living/simple_animal/onbite(mob/living/user)
	. = ..()
	if(.)
		return
	var/damage = user.STASTR*0.5
	if(HAS_TRAIT(user, TRAIT_STRONGBITE))
		damage = damage*2
	user.do_attack_animation(src, ATTACK_EFFECT_BITE)
	playsound(user, "smallslash", 100, FALSE, -1)
	user.next_attack_msg.Cut()
	if(stat == DEAD && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(user.has_status_effect(/datum/status_effect/debuff/silver_bane))
			to_chat(user, span_notice("My power is weakened, I cannot heal!"))
			return TRUE
		if(is_species(user, /datum/species/werewolf))
			visible_message(span_danger("[user] ravenously consumes [src]!"), span_warning("I feed on succulent flesh. I feel reinvigorated."))
			H.rage_datum?.update_rage(text2num(WW_RAGE_HIGH))
			gib()
		return TRUE
	if(!src.apply_damage(damage, BRUTE))
		return TRUE
	if(is_species(user, /datum/species/werewolf))
		visible_message(span_danger("[user] bites into [src] and thrashes!"))
	else
		visible_message(span_danger("[user] bites [src]!"))
	if(HAS_TRAIT(user, TRAIT_POISONBITE) && src.reagents)
		var/poison = user.STACON/2
		src.reagents.add_reagent(/datum/reagent/toxin/venom, poison/2)
		src.reagents.add_reagent(/datum/reagent/medicine/soporpot, poison)
		to_chat(user, span_warning("Your fangs inject venom into [src]!"))
