/datum/component/abberant_eater
	var/list/extra_foods = list()
	var/excluding_subtypes = FALSE

/datum/component/abberant_eater/Initialize(list/food_list, exclude_subtypes = FALSE)
	if(!length(food_list))
		return COMPONENT_INCOMPATIBLE

	excluding_subtypes = exclude_subtypes
	extra_foods = excluding_subtypes ? typecacheof(food_list, only_root_path = TRUE) : food_list

	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, PROC_REF(try_eat))

/datum/component/abberant_eater/proc/try_eat(mob/living/user, mob/living/M, obj/item/source)
	if(user.cmode)
		return FALSE
	if(user != M)
		return FALSE

	var/can_we_eat = excluding_subtypes ? is_type_in_typecache(source, extra_foods) : is_type_in_list(source, extra_foods)
	if(!can_we_eat)
		return FALSE

	var/eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	M.nutrition += 10

	switch(M.nutrition)
		if(NUTRITION_LEVEL_FAT to INFINITY)
			user.visible_message("<span class='notice'>[user] forces [M.p_them()]self to eat \the [source].</span>", "<span class='notice'>I force myself to eat \the [source].</span>")
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_FAT)
			user.visible_message("<span class='notice'>[user] [eatverb]s \the [source].</span>", "<span class='notice'>I [eatverb] \the [source].</span>")
		if(0 to NUTRITION_LEVEL_STARVING)
			user.visible_message("<span class='notice'>[user] hungrily [eatverb]s \the [source], gobbling it down!</span>", "<span class='notice'>I hungrily [eatverb] \the [source], gobbling it down!</span>")
			M.changeNext_move(CLICK_CD_MELEE * 0.5)

	playsound(M,'sound/misc/eat.ogg', rand(30,60), TRUE)
	SEND_SIGNAL(source, COMSIG_FOOD_EATEN, M, user)
	source.on_consume(user)
	qdel(source)
	return TRUE
