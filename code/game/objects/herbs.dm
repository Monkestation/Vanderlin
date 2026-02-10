/obj/structure/flora/grass/herb
	name = "herbbush"
	desc = "A bush, for an herb. This shouldn't show up."
	icon = 'icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "spritemeplz"
	num_random_icons = 0
	max_integrity = 10
	climbable = FALSE
	dir = SOUTH
	var/herbtype
	var/obj/effect/skill_tracker/alchemy_plants/alchemy_effect
	var/obj/item/reagent_containers/food/snacks/spiderhoney/honey/honey_type

	var/timerid
	var/harvested = FALSE

/obj/structure/flora/grass/herb/Initialize()
	. = ..()
	desc = "A herb. This one looks like [name]."
	alchemy_effect = new(get_turf(src), src)
	GLOB.herb_locations |= src
	loot_replenish()

/obj/structure/flora/grass/herb/Destroy()
	GLOB.harvested_herbs -= src
	GLOB.herb_locations -= src
	return ..()


/obj/structure/flora/grass/herb/attack_hand(mob/user)
	if(harvested)
		to_chat(user, span_warning("Picked clean; but looks healthy. I should try again later."))
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src, "plantcross", 80, FALSE, -1)
		if(do_after(L, rand(3,5) DECISECONDS ,src))
			if(!looty.len)
				return
			if(prob(50))
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message(span_notice("[user] finds [B] in [src]."))
					harvested = TRUE
					timerid = addtimer(CALLBACK(src, PROC_REF(loot_replenish)), 8 MINUTES, flags = TIMER_STOPPABLE)
					add_filter("picked", 1, alpha_mask_filter(icon = icon('icons/effects/picked_overlay.dmi', "picked_overlay_[rand(1,3)]"), flags = MASK_INVERSE))
					GLOB.harvested_herbs |= src
					return
			user.visible_message(span_notice("[user] searches through [src]."))

/obj/structure/flora/grass/herb/proc/loot_replenish()
	if(herbtype)
		looty += herbtype
	harvested = FALSE
	remove_filter("picked")
	GLOB.harvested_herbs -= src
	if(timerid)
		deltimer(timerid)

/obj/structure/flora/grass/herb/random
	name = "random herb"
	desc = "Haha, I'm in danger."
	icon_state = "herb_random"

/obj/structure/flora/grass/herb/random/Initialize()
	var/type = pick(list(/obj/structure/flora/grass/herb/atropa,/obj/structure/flora/grass/herb/matricaria,
	/obj/structure/flora/grass/herb/symphitum,/obj/structure/flora/grass/herb/taraxacum,
	/obj/structure/flora/grass/herb/euphrasia,/obj/structure/flora/grass/herb/paris,
	/obj/structure/flora/grass/herb/calendula,/obj/structure/flora/grass/herb/mentha,
	/obj/structure/flora/grass/herb/urtica,/obj/structure/flora/grass/herb/salvia,
	/obj/structure/flora/grass/herb/hypericum,/obj/structure/flora/grass/herb/benedictus,
	/obj/structure/flora/grass/herb/valeriana,/obj/structure/flora/grass/herb/artemisia,
	/obj/structure/wild_plant/nospread/poppy,/obj/structure/flora/grass/herb/euphorbia))

	var/obj/structure/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL


/obj/structure/flora/grass/herb/atropa
	name = "atropa"
	icon_state = "atropa2"

	herbtype = /obj/item/alch/herb/atropa
	honey_type = /obj/item/reagent_containers/food/snacks/spiderhoney/honey/toxic

/obj/structure/flora/grass/herb/matricaria
	name = "matricaria"
	icon_state = "matricaria2"

	herbtype = /obj/item/alch/herb/matricaria

/obj/structure/flora/grass/herb/symphitum
	name = "symphitum"
	icon_state = "symphitum2"

	herbtype = /obj/item/alch/herb/symphitum

/obj/structure/flora/grass/herb/taraxacum
	name = "taraxacum"
	icon_state = "taraxacum2"

	herbtype = /obj/item/alch/herb/taraxacum

/obj/structure/flora/grass/herb/euphrasia
	name = "euphrasia"
	icon_state = "euphrasia2"

	herbtype = /obj/item/alch/herb/euphrasia

/obj/structure/flora/grass/herb/paris
	name = "paris"
	icon_state = "paris2"

	herbtype = /obj/item/alch/herb/paris
	honey_type = /obj/item/reagent_containers/food/snacks/spiderhoney/honey/toxic

/obj/structure/flora/grass/herb/calendula
	name = "calendula"
	icon_state = "calendula2"

	herbtype = /obj/item/alch/herb/calendula

/obj/structure/flora/grass/herb/mentha
	name = "mentha"
	icon_state = "mentha2"

	herbtype = /obj/item/alch/herb/mentha

/obj/structure/flora/grass/herb/urtica
	name = "urtica"
	icon_state = "urtica2"

	herbtype = /obj/item/alch/herb/urtica

/obj/structure/flora/grass/herb/salvia
	name = "salvia"
	icon_state = "salvia2"

	herbtype = /obj/item/alch/herb/salvia

/obj/structure/flora/grass/herb/hypericum
	name = "hypericum"
	icon_state = "hypericum2"

	herbtype = /obj/item/alch/herb/hypericum

/obj/structure/flora/grass/herb/benedictus
	name = "benedictus"
	icon_state = "benedictus2"

	herbtype = /obj/item/alch/herb/benedictus

/obj/structure/flora/grass/herb/valeriana
	name = "valeriana"
	icon_state = "valeriana2"

	herbtype = /obj/item/alch/herb/valeriana

/obj/structure/flora/grass/herb/artemisia
	name = "artemisia"
	icon_state = "artemisia2"

	herbtype = /obj/item/alch/herb/artemisia

/obj/structure/flora/grass/herb/rosa
	name = "rosa"
	icon_state = "rosa2"

	herbtype = /obj/item/alch/herb/rosa

/obj/structure/flora/grass/herb/euphorbia
	name = "euphorbia"
	icon_state = "euphorbia2"

	herbtype = /obj/item/alch/herb/euphorbia
