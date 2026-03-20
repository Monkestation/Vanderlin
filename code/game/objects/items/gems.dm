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
	///For Mappers; gem_path = weight
	var/list/valid_gems = list()

	var/quality = GEM_REGULAR
	var/datum/gem_effect/effect_template
	var/is_cut = FALSE

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
		spawned.generate_socketing_properties()
		spawned.update_appearance(UPDATE_ICON_STATE)
		return INITIALIZE_HINT_QDEL

	if(quality == GEM_REGULAR && prob(20))
		quality = rand(GEM_CHIPPED, GEM_PERFECT)

	generate_socketing_properties()
	update_appearance(UPDATE_ICON_STATE)

/obj/item/gem/examine(mob/user)
	. = ..()
	. += get_socketing_description()
	if(is_cut)
		. += span_notice("This gem has been professionally cut.")

/obj/item/gem/on_consume(mob/living/eater)
	. = ..()
	if(attuned)
		//eater.adjust_spell_points(0.5)
		eater.mana_pool.adjust_attunement(attuned, 0.1)

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

/obj/item/gem/proc/generate_socketing_properties()
	effect_template = create_gem_effect()

	var/quality_name = GLOB.gem_quality_names[quality]
	if(quality_name)
		name = lowertext("[quality_name] [name]")

/obj/item/gem/proc/create_gem_effect()
	if(ispath(effect_template))
		return new effect_template(quality)
	return effect_template

/obj/item/gem/proc/get_socketing_description()
	if(!effect_template)
		return "This gem can be socketed into equipment."
	return "Socketing Effects:\n[effect_template.get_description()]"

/obj/item/gem/proc/get_slot_type(obj/item/target)
	if(istype(target, /obj/item/weapon/shield)) ///0.0000001% faster operation goes brrr
		return SLOT_SHIELD
	else if(istype(target, /obj/item/weapon))
		return SLOT_WEAPON
	else if(istype(target, /obj/item/clothing))
		return SLOT_ARMOR
	return SLOT_WEAPON

/obj/item/gem/proc/create_rune_effect_for_slot(slot_type)
	if(!effect_template)
		return null
	return effect_template.create_effect_for_slot(slot_type)

/obj/item/gem/proc/apply_cut(datum/gem_cut/cut, mob/user)
	if(is_cut)
		to_chat(user, "[src] has already been cut!")
		return FALSE
	var/gemcutter_level = get_profession_level(user.ckey, /datum/profession/gemcutter)
	var/downgrade_chance = initial(cut.downgrade_chance) + (100 - gemcutter_level)

	var/failed = FALSE
	var/original_quality = quality
	while(prob(downgrade_chance))
		quality = max(1, quality - 1)
		downgrade_chance -= 100
		failed = TRUE

	effect_template = create_gem_effect_with_cut(cut)
	is_cut = TRUE

	// Update name and description
	var/cut_name = initial(cut.name)
	name = "[cut_name] [name]"
	desc += " This gem has been cut with a [cut_name] pattern."

	to_chat(user, "You cut [src] with a [cut_name] pattern!")
	if(failed)
		to_chat(user, "You messed up cutting [src] and it dropped from [GLOB.gem_quality_names[original_quality]] to [GLOB.gem_quality_names[quality]]!")
	return TRUE

/obj/item/gem/proc/create_gem_effect_with_cut(cut_type)
	var/datum/gem_effect/new_effect = new effect_template.type(quality, cut_type)

	var/bonus = get_cut_quality_bonus()
	if(bonus != 1.0)
		multiply_effect_data(new_effect, bonus)

	return new_effect

/obj/item/gem/proc/multiply_effect_data(datum/gem_effect/effect, multiplier)
	for(var/i = 1 to length(effect.weapon_effect_data))
		effect.weapon_effect_data[i] = round(effect.weapon_effect_data[i] * multiplier)

	for(var/i = 1 to length(effect.armor_effect_data))
		effect.armor_effect_data[i] = round(effect.armor_effect_data[i] * multiplier)

	for(var/i = 1 to length(effect.shield_effect_data))
		effect.shield_effect_data[i] = round(effect.shield_effect_data[i] * multiplier)

/obj/item/gem/proc/get_cut_quality_bonus()
	switch(quality)
		if(GEM_CHIPPED) return 0.8
		if(GEM_REGULAR) return 1.0
		if(GEM_FLAWLESS) return 1.3
		if(GEM_PERFECT) return 1.6
	return 1.0

/obj/item/gem/green
	name = "gemerald"
	desc = "Glints with verdant brilliance."
	//color = "#15af158c"
	icon_state = "emerald_cut"
	sellprice = 44
	dropshrink = 0.4
	attuned = /datum/attunement/earth
	effect_template = /datum/gem_effect/gemerald

/obj/item/gem/blue
	name = "blortz"
	desc = "Pale blue, like a frozen tear."
	//color = "#1ca5aa8c"
	icon_state = "quartz_cut"
	sellprice = 88
	dropshrink = 0.4
	attuned = /datum/attunement/ice
	effect_template = /datum/gem_effect/blortz

/obj/item/gem/yellow
	name = "toper"
	desc = "Its amber hues remind you of the sunset."
	//color = "#e6a0088c"
	icon_state = "topaz_cut"
	sellprice = 25
	dropshrink = 0.4
	attuned = /datum/attunement/electric
	effect_template = /datum/gem_effect/toper

/obj/item/gem/violet
	name = "saffira"
	desc = "This gem is admired by many wizards."
	//color = "#1733b38c"
	icon_state = "sapphire_cut"
	sellprice = 56
	dropshrink = 0.4
	attuned = /datum/attunement/arcyne
	effect_template = /datum/gem_effect/saffira

/obj/item/gem/diamond
	name = "dorpel"
	desc = "Beautifully pure, it demands respect."
	//color = "#ffffff8c"
	icon_state = "diamond_cut"
	sellprice = 121
	dropshrink = 0.4
	attuned = /datum/attunement/light
	effect_template = /datum/gem_effect/dorpel

/obj/item/gem/red
	name = "rontz"
	desc = "Glistening with unkempt rage."
	//color = "#ff00008c"
	icon_state = "ruby_cut"
	sellprice = 100
	attuned = /datum/attunement/fire
	effect_template = /datum/gem_effect/rubor

/obj/item/gem/onyxa
	name = "raw onyxa"
	desc = "A piece of fossilized spider honey that glimmers in the dark. It was once prized by the Drow, but it's significance to their culture has long been replaced by the more common saffira."
	icon = 'icons/roguetown/gems/gem_onyxa.dmi'
	icon_state = "raw_onyxa"
	sellprice = 30

/obj/item/gem/jade
	name = "raw joapstone"
	desc = "A dull green gem. Joapstone is valued in multiple humen cultures and is believed to bring good fortune."
	icon = 'icons/roguetown/gems/gem_jade.dmi'
	icon_state = "raw_jade"
	sellprice = 50

/obj/item/gem/oyster
	name = "fossilized clam"
	desc = "A fossilized clamshell. It would be a good idea to pry it open with a knife."
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "oyster_closed"
	sellprice = 5

/obj/item/gem/coral
	name = "raw aoetal"
	desc = "Jagged like a hounds tooth. Aoetal is speculated to be the crystallized blood of fallen sailors. It is sacred to Abyssorians and is used in numerous Abyssorian rituals."
	icon = 'icons/roguetown/gems/gem_coral.dmi'
	icon_state = "raw_coral"
	sellprice = 60

/obj/item/gem/turq
	name = "raw ceruleabaster"
	desc = "A beautiful teal gem that is easily carved."
	icon = 'icons/roguetown/gems/gem_turq.dmi'
	icon_state = "raw_turq"
	sellprice = 75

/obj/item/gem/amber
	name = "raw petriamber"
	desc = "A chunk of fossilized mushroom that shines radiantly in sunlight. It's prized amongst Astratans."
	icon = 'icons/roguetown/gems/gem_amber.dmi'
	icon_state = "raw_amber"
	sellprice = 50

/obj/item/gem/opal
	name = "raw opaloise"
	desc = "A dazzling gem that is remarkably valuable. Opaloise is widely speculated to be the crystallized essence left behind by rainbows, and is greatly prized by aboriginal Crimson Elves."
	icon = 'icons/roguetown/gems/gem_opal.dmi'
	icon_state = "raw_opal"
	sellprice = 80

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

/obj/item/riddleofsteel/Initialize()
	. = ..()
	set_light(2, 2, 1, l_color = "#ff0d0d")
