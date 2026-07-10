// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

// Base type. Subtypes are found in /grown dir. Lavaland-based subtypes can be found in mining/ash_flora.dm
/obj/item/reagent_containers/food/snacks/grown
	icon = 'icons/roguetown/items/produce.dmi'
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	// Saves us from having to define each stupid grown's dried_type as itself.
	// If you don't want a plant to be driable (watermelons) set this to null in the time definition.
	dried_type = -1
	var/plantname = ""
	// If set, bitesize = 1 + round(reagents.total_volume / bitesize_mod)
	var/bitesize_mod = 0
	var/splat_type = /obj/effect/decal/cleanable/food/plant_smudge

	var/dry_grind = FALSE //If TRUE, this object needs to be dry to be ground up
	var/wine_flavor //If NULL, this is automatically set to the fruit's flavor. Determines the flavor of the wine if distill_reagent is NULL.
	var/wine_power = 10 //Determines the boozepwr of the wine if distill_reagent is NULL.

	var/list/pipe_reagents = list()
	var/obj/item/neuFarm/seed/seed = null

/obj/item/reagent_containers/food/snacks/grown/Initialize(mapload, obj/item/neuFarm/seed/new_seed)
	. = ..()
	if(!tastes)
		tastes = list("[name]" = 1)

	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

	if(dried_type == -1)
		dried_type = src.type

	if(new_seed)
		if(seed)
			QDEL_NULL(seed)
		seed = new_seed

/obj/item/reagent_containers/food/snacks/grown/Destroy()
	if(istype(seed))
		QDEL_NULL(seed)
	return ..()

/obj/item/reagent_containers/food/snacks/grown/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!isturf(loc))
		return NONE

	if(user.cmode)
		return NONE

	if(user.used_intent.blade_class != BCLASS_BLUNT || user.used_intent.noaa)
		return ..()

	playsound(src,'sound/items/seedextract.ogg', 100, FALSE)

	user.changeNext_move(CLICK_CD_FAST)

	if(prob(5))
		qdel(src)
		return

	user.visible_message("<span class='info'>[user] extracts the seeds.</span>")

	seed.forceMove(loc)
	if(prob(90))
		new seed.type(loc)
	if(prob(23))
		new seed.type(loc)
	if(prob(6))
		new seed.type(loc)

	seed = null
	qdel(src)

	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/food/snacks/grown/Crossed(mob/living/carbon/human/H)
	..()
	if(prob(33))
		if(istype(H))
			if(eat_effect == /datum/status_effect/debuff/rotfood)
				visible_message("<span class='warning'>[H] crushes [src] underfoot.</span>")
				qdel(src)

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
