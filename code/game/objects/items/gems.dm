/obj/item/gem
	name = "random gem"
	desc = "If you find this, yell at coderbus"
	icon_state = "aros"
	icon = 'icons/roguetown/items/gems.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	drop_sound = 'sound/items/gem.ogg'
	///I am leaving this here as a note. If you leave the price null on subtypes, you're eating the infinite recursion pill.
	///I dont care if its negative just DONT LEAVE IT 0
	sellprice = 0
	static_price = FALSE
	experimental_inhand = FALSE
	item_weight = 15 GRAMS
	///For Mappers; gem_path = weight
	var/list/valid_gems = list()

	var/quality = GEM_REGULAR
	var/is_cut = FALSE
	var/arcyne_potency = 20
	var/datum/attunement/attuned

/obj/item/gem/Initialize()
	. = ..()
	if(sellprice == 0)
		var/new_gem
		if(length(valid_gems))
			new_gem = pickweight(valid_gems)
		else
			new_gem = pick(subtypesof(/obj/item/gem))
		var/obj/item/gem/spawned = new new_gem(get_turf(src))
		if(prob(20)) //! TODO: remove this when ore nodes are created
			spawned.quality = rand(GEM_CHIPPED, GEM_PERFECT)
		spawned.update_appearance(UPDATE_ICON_STATE)
		return INITIALIZE_HINT_QDEL

	if(quality == GEM_REGULAR && prob(20))
		quality = rand(GEM_CHIPPED, GEM_PERFECT)

	update_appearance(UPDATE_ICON_STATE)

/obj/item/gem/examine(mob/user)
	. = ..()
	if(is_cut)
		. += span_notice("This gem has been professionally cut.")

/obj/item/gem/on_consume(mob/living/eater)
	. = ..()
	eater.extra_mob_weight += get_carry_weight(eater)

/obj/item/gem/on_anti_consume(mob/living/eater)
	eater.extra_mob_weight -= get_carry_weight(eater)

///This is a switch incase anyone would like to add more...
/obj/item/gem/update_icon_state()
	if(icon_state == "aros") // :(
		switch(rand(1,2))
			if(1)
				icon_state = "d_cut"
			if(2)
				icon_state = "e_cut"
	return ..()

/obj/item/gem/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gem/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(src, pick('sound/items/gems (1).ogg','sound/items/gems (2).ogg'), 100, TRUE, -2)
	..()

/obj/item/gem/blood_diamond
	name = "glut"
	icon_state = "blood"
	sellprice = 188
	desc = "Something about this gem just doesn't sit right with you. Holding it makes the blood leave your fingertips."
	smeltresult = /obj/item/ingot/component/glutcrystal
	dropshrink = 1
	examine_highlight_type = /datum/examine_highlight/heresy_veryodd/glut

/obj/item/gem/blood_diamond/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/graggar)
			. += span_danger("You know this gem well. They are born out of great violence, but only if it involves the mightiest of warriors. </br>Fleshcrafting it with the meat of whatever warrior birthed this gem will allow me to summon another of their kind into this world.")

/obj/item/gem/blood_diamond/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#8B0000", "alpha" = 188, "size" = 1))

/obj/item/gem/green
	name = "gemerald"
	desc = "Glints with verdant brilliance."
	//color = "#15af158c"
	icon_state = "emerald_cut"
	sellprice = 44
	dropshrink = 0.4
	arcyne_potency = 7
	attuned = /datum/attunement/earth
	item_weight = 24 GRAMS

/obj/item/gem/blue
	name = "blortz"
	desc = "Pale blue, like a frozen tear."
	//color = "#1ca5aa8c"
	icon_state = "quartz_cut"
	sellprice = 88
	dropshrink = 0.4
	arcyne_potency = 25
	attuned = /datum/attunement/ice
	item_weight = 18 GRAMS

/obj/item/gem/yellow
	name = "toper"
	desc = "Its amber hues remind you of the sunset."
	//color = "#e6a0088c"
	icon_state = "topaz_cut"
	sellprice = 25
	dropshrink = 0.4
	arcyne_potency = 5
	attuned = /datum/attunement/electric
	item_weight = 21 GRAMS

/obj/item/gem/violet
	name = "saffira"
	desc = "This gem is admired by many wizards."
	//color = "#1733b38c"
	icon_state = "sapphire_cut"
	sellprice = 56
	dropshrink = 0.4
	arcyne_potency = 10
	attuned = /datum/attunement/arcyne
	item_weight = 21 GRAMS

/obj/item/gem/diamond
	name = "dorpel"
	desc = "Beautifully pure, it demands respect."
	//color = "#ffffff8c"
	icon_state = "diamond_cut"
	sellprice = 121
	dropshrink = 0.4
	arcyne_potency = 15
	attuned = /datum/attunement/light
	item_weight = 15 GRAMS

/obj/item/gem/red
	name = "rontz"
	desc = "Glistening with unkempt rage."
	//color = "#ff00008c"
	icon_state = "ruby_cut"
	sellprice = 100
	attuned = /datum/attunement/fire
	item_weight = 24 GRAMS

/obj/item/gem/onyxa
	name = "raw onyxa"
	desc = "A piece of fossilized spider honey that glimmers in the dark. It was once prized by the Drow, but it's significance to their culture has long been replaced by the more common saffira."
	icon = 'icons/roguetown/gems/gem_onyxa.dmi'
	icon_state = "raw_onyxa"
	sellprice = 30
	item_weight = 45 GRAMS

/obj/item/gem/jade
	name = "raw joapstone"
	desc = "A dull green gem. Joapstone is valued in multiple humen cultures and is believed to bring good fortune."
	icon = 'icons/roguetown/gems/gem_jade.dmi'
	icon_state = "raw_jade"
	sellprice = 50
	item_weight = 60 GRAMS

/obj/item/gem/oyster
	name = "fossilized clam"
	desc = "A fossilized clamshell. It would be a good idea to pry it open with a knife."
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "oyster_closed"
	sellprice = 5
	item_weight = 75 GRAMS

/obj/item/gem/coral
	name = "raw aoetal"
	desc = "Jagged like a hounds tooth. Aoetal is speculated to be the crystallized blood of fallen sailors. It is sacred to Abyssorians and is used in numerous Abyssorian rituals."
	icon = 'icons/roguetown/gems/gem_coral.dmi'
	icon_state = "raw_coral"
	sellprice = 60
	item_weight = 54 GRAMS

/obj/item/gem/turq
	name = "raw ceruleabaster"
	desc = "A beautiful teal gem that is easily carved."
	icon = 'icons/roguetown/gems/gem_turq.dmi'
	icon_state = "raw_turq"
	sellprice = 75
	item_weight = 66 GRAMS

/obj/item/gem/amber
	name = "raw petriamber"
	desc = "A chunk of fossilized mushroom that shines radiantly in sunlight. It's prized amongst Astratans."
	icon = 'icons/roguetown/gems/gem_amber.dmi'
	icon_state = "raw_amber"
	sellprice = 50
	item_weight = 36 GRAMS

/obj/item/gem/opal
	name = "raw opaloise"
	desc = "A dazzling gem that is remarkably valuable. Opaloise is widely speculated to be the crystallized essence left behind by rainbows, and is greatly prized by aboriginal Crimson Elves."
	icon = 'icons/roguetown/gems/gem_opal.dmi'
	icon_state = "raw_opal"
	sellprice = 80
	item_weight = 30 GRAMS

/// riddle


/obj/item/riddleofsteel
	name = "riddle of steel"
	icon_state = "ros"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "Flesh, mind."
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 454
	item_weight = 4.9 KILOGRAMS

/obj/item/riddleofsteel/Initialize()
	. = ..()
	set_light(2, 2, 1, l_color = "#ff0d0d")
