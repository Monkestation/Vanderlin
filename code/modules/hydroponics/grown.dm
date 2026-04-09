// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

// Base type. Subtypes are found in /grown dir. Lavaland-based subtypes can be found in mining/ash_flora.dm
/obj/item/reagent_containers/food/snacks/grown
	icon = 'icons/roguetown/items/produce.dmi'
	var/obj/item/neuFarm/seed/seed = null // type path, gets converted to item on New(). It's safe to assume it's always a seed item.
	var/plantname = ""
	var/bitesize_mod = 0
	var/splat_type = /obj/effect/decal/cleanable/food/plant_smudge
	// If set, bitesize = 1 + round(reagents.total_volume / bitesize_mod)
	dried_type = -1
	// Saves us from having to define each stupid grown's dried_type as itself.
	// If you don't want a plant to be driable (watermelons) set this to null in the time definition.
	resistance_flags = FLAMMABLE
	var/dry_grind = FALSE //If TRUE, this object needs to be dry to be ground up
	var/wine_flavor //If NULL, this is automatically set to the fruit's flavor. Determines the flavor of the wine if distill_reagent is NULL.
	var/wine_power = 10 //Determines the boozepwr of the wine if distill_reagent is NULL.
	w_class = WEIGHT_CLASS_SMALL
	var/list/pipe_reagents = list()

/obj/item/reagent_containers/food/snacks/grown/attackby(obj/item/W, mob/user, list/modifiers)
	if(W && isturf(loc))
		if(seed && (user.used_intent.blade_class == BCLASS_BLUNT) && (!user.used_intent.noaa))
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			user.visible_message("<span class='info'>[user] extracts the seeds.</span>")
			if(prob(5))
				qdel(src)
				return
			seed.forceMove(loc)
			if(prob(90))
				new seed.type(loc)
			if(prob(23))
				new seed.type(loc)
			if(prob(6))
				new seed.type(loc)
			seed = null
			qdel(src)
			return
	..()

/obj/item/reagent_containers/food/snacks/grown/Crossed(mob/living/carbon/human/H)
	..()
	if(prob(33))
		if(istype(H))
			if(eat_effect == /datum/status_effect/debuff/rotfood)
				visible_message("<span class='warning'>[H] crushes [src] underfoot.</span>")
				qdel(src)

/obj/item/reagent_containers/food/snacks/grown/Initialize(mapload, obj/item/neuFarm/seed/new_seed)
	. = ..()
	if(!tastes)
		tastes = list("[name]" = 1)

	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

	if(dried_type == -1)
		dried_type = src.type


/obj/item/reagent_containers/food/snacks/grown/proc/add_juice()
	if(reagents)
		return 1
	return 0


/obj/item/reagent_containers/food/snacks/grown/proc/squash(atom/target)
	var/turf/T = get_turf(target)
	forceMove(T)
	if(ispath(splat_type, /obj/effect/decal/cleanable/food/plant_smudge))
		if(filling_color)
			var/obj/O = new splat_type(T)
			O.color = filling_color
			O.name = "[name] smudge"
	else if(splat_type)
		new splat_type(T)

	if(trash)
		generate_trash(T)

	visible_message("<span class='warning'>[src] has been squashed.</span>","<span class='hear'>I hear a smack.</span>")

	reagents.reaction(T)
	for(var/A in T)
		reagents.reaction(A)

	qdel(src)

/obj/item/reagent_containers/food/snacks/grown/generate_trash(atom/location)
	if(trash && (ispath(trash, /obj/item/grown) || ispath(trash, /obj/item/reagent_containers/food/snacks/grown)))
		. = new trash(location, seed)
		trash = null
		return
	return ..()

/obj/item/reagent_containers/food/snacks/grown/grind_requirements()
	if(dry_grind && !dry)
		to_chat(usr, "<span class='warning'>[src] needs to be dry before it can be ground up!</span>")
		return
	return TRUE

/obj/item/reagent_containers/food/snacks/grown/on_grind()
	var/nutriment = reagents.get_reagent_amount(/datum/reagent/consumable/nutriment)
	if(grind_results&&grind_results.len)
		for(var/i in 1 to grind_results.len)
			grind_results[grind_results[i]] = nutriment
		reagents.del_reagent(/datum/reagent/consumable/nutriment)
		reagents.del_reagent(/datum/reagent/consumable/nutriment/vitamin)

/obj/item/reagent_containers/food/snacks/grown/on_juice()
	var/nutriment = reagents.get_reagent_amount(/datum/reagent/consumable/nutriment)
	if(juice_results&&juice_results.len)
		for(var/i in 1 to juice_results.len)
			juice_results[juice_results[i]] = nutriment
		reagents.del_reagent(/datum/reagent/consumable/nutriment)
		reagents.del_reagent(/datum/reagent/consumable/nutriment/vitamin)
