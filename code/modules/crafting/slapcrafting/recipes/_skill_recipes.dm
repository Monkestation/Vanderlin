/datum/slapcraft_recipe/carpentry
	abstract_type = /datum/slapcraft_recipe/carpentry
	skillcraft = /datum/skill/craft/carpentry
	category = SLAP_CAT_CARPTENTRY

/datum/slapcraft_recipe/carpentry/structure
	abstract_type = /datum/slapcraft_recipe/carpentry/structure
	anchor_craft = TRUE
	subcategory = SLAP_SUBCAT_STRUCTURE
	assembly_weight_class = WEIGHT_CLASS_HUGE
	craftsound = 'sound/foley/Building-01.ogg'
	category = "Structure"

/datum/slapcraft_recipe/carpentry/structure/check_craft_requirements(mob/user, turf/T)
	if(istype(T,/turf/open/openspace))
		return FALSE
	if(istype(T, /turf/open/water))
		return FALSE
	if(istype(T, /turf/open/lava))
		return FALSE
	for(var/obj/structure/fluff/traveltile/TT in range(7, T))
		return FALSE
	for(var/obj/machinery/M in T)
		if(M.density)
			return FALSE
	for(var/obj/structure/S in T)
		if(S.density)
			return FALSE
	return ..()


/datum/slapcraft_recipe/masonry
	abstract_type = /datum/slapcraft_recipe/masonry
	skillcraft = /datum/skill/craft/masonry
	category = SLAP_CAT_MASONRY
	assembly_weight_class = WEIGHT_CLASS_HUGE

/datum/slapcraft_recipe/masonry/structure
	abstract_type = /datum/slapcraft_recipe/masonry/structure
	anchor_craft = TRUE
	subcategory = SLAP_SUBCAT_STRUCTURE
	craftsound = 'sound/foley/Building-02.ogg'
	category = "Structure"

/datum/slapcraft_recipe/masonry/structure/check_craft_requirements(mob/user, turf/T)
	if(istype(T,/turf/open/openspace))
		return FALSE
	if(istype(T, /turf/open/water))
		return FALSE
	if(istype(T, /turf/open/lava))
		return FALSE
	for(var/obj/structure/fluff/traveltile/TT in range(7, T))
		return FALSE
	for(var/obj/machinery/M in T)
		if(M.density)
			return FALSE
	for(var/obj/structure/S in T)
		if(S.density)
			return FALSE
	return ..()

/datum/slapcraft_recipe/engineering
	abstract_type = /datum/slapcraft_recipe/engineering
	skillcraft =/datum/skill/craft/engineering
	category = SLAP_CAT_ENGINEERING
	assembly_weight_class = WEIGHT_CLASS_HUGE

/datum/slapcraft_recipe/engineering/structure
	abstract_type = /datum/slapcraft_recipe/engineering/structure
	anchor_craft = TRUE
	subcategory = SLAP_SUBCAT_STRUCTURE
	craftsound = 'sound/foley/Building-01.ogg'
	category = "Structure"

/datum/slapcraft_recipe/engineering/structure/check_craft_requirements(mob/user, turf/T)
	if(istype(T,/turf/open/openspace))
		return FALSE
	if(istype(T, /turf/open/water))
		return FALSE
	if(istype(T, /turf/open/lava))
		return FALSE
	for(var/obj/structure/fluff/traveltile/TT in range(7, T))
		return FALSE
	for(var/obj/machinery/M in T)
		if(M.density)
			return FALSE
	for(var/obj/structure/S in T)
		if(S.density)
			return FALSE
	return ..()
