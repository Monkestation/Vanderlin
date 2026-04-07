/obj/machinery/artificer_table
	name = "artificer table"
	desc = "An artificers wood work station, nice and sturdy for working."
	icon_state = "art_table"
	icon = 'icons/roguetown/misc/tables.dmi'
	var/obj/item/material
	damage_deflection = 25
	density = TRUE
	climbable = TRUE
	can_buckle = TRUE
	buckle_lying = 0
	max_buckled_mobs = 1

/obj/machinery/artificer_table/examine(mob/user)
	. = ..()
	if(material)
		. += span_warning("There's a [initial(material.name)] ready to be worked.")

	var/mob/living/buckled = locate() in buckled_mobs
	if(buckled)
		. += span_notice("[buckled] is secured to the table.")
		var/stability = SEND_SIGNAL(buckled, COMSIG_AUGMENT_GET_STABILITY)
		if(stability)
			. += span_info("Core Stability: [stability]%")

/obj/machinery/artificer_table/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(!M.CanReach(src))
		return
	if(!isliving(M) || !isliving(user))
		return

	if(!SEND_SIGNAL(M, COMSIG_AUGMENT_GET_STABILITY) && !istype(M, /mob/living/carbon/human))
		to_chat(user, span_warning("[M] cannot be secured to the table!"))
		return

	M.forceMove(get_turf(src))
	return ..()

/obj/machinery/artificer_table/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(istype(I, /obj/item/weapon/hammer))
		var/mob/living/carbon/human/buckled = locate() in buckled_mobs
		if(buckled)
			if(SEND_SIGNAL(buckled, COMSIG_AUGMENT_GET_STABILITY))
				var/skill = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering)
				var/repair_amount = 5 + (skill * 3)
				to_chat(user, span_notice("You begin repairing [buckled]..."))
				if(do_after(user, 5 SECONDS, target = buckled))
					SEND_SIGNAL(buckled, COMSIG_AUGMENT_REPAIR, repair_amount, user)
					user.mind?.add_sleep_experience(/datum/attribute/skill/craft/engineering, GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE))
			return
		var/obj/item/weapon/hammer/H = I
		user.changeNext_move(CLICK_CD_RAPID)
		if(!material)
			return
		if(!material.artrecipe)
			if(!choose_recipe(user))
				return
		if(material.artrecipe.hammered || material.artrecipe.progress == 100)
			playsound(src,'sound/combat/hits/onmetal/sheet (2).ogg', 100, TRUE)
			shake_camera(user, 1, 1)
		if(!H.no_spark)	//wood and copper hammers don't spark
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_turf(src)
			S.set_up(1, 1, front)
			S.start()
		var/skill = GET_MOB_SKILL_VALUE_OLD(user, material.artrecipe.appro_skill)
		if(material.artrecipe.progress == 100)
			for(var/i in 1 to material.artrecipe.created_amount)
				var/atom/new_atom = new material.artrecipe.created_item(get_turf(src))
				new_atom.update_integrity(new_atom.max_integrity, update_atom = FALSE)
				material.artrecipe.item_created(new_atom)
			var/obj/item/created_item_instance = material.artrecipe.created_item
			user.visible_message(span_info("[user] creates \a [created_item_instance.name]."))
			user.mind.add_sleep_experience(material.artrecipe.appro_skill, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * (material.artrecipe.craftdiff + 1)/2) * user.get_learning_boon(material.artrecipe.appro_skill))
			qdel(material)
			material = null
			update_appearance(UPDATE_OVERLAYS)
			return
		if(skill < material.artrecipe.craftdiff)
			if(prob(max(0, 25 - user.goodluck(2) - (skill * 2))))
				to_chat(user, span_warning("Ah yes, my incompetence bears fruit."))
				playsound(src,'sound/combat/hits/onwood/destroyfurniture.ogg', 100, FALSE)
				user.mind.add_sleep_experience(material.artrecipe.appro_skill, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * material.artrecipe.craftdiff * 0.25))
				qdel(material)
				material = null
				return
		if(!material.artrecipe.hammered)
			playsound(src, pick('sound/combat/hits/onwood/fence_hit1.ogg', 'sound/combat/hits/onwood/fence_hit2.ogg', 'sound/combat/hits/onwood/fence_hit3.ogg'), 100, FALSE)
			material.artrecipe.advance(I, user)
			return
	else if(!material && !(I.item_flags & (ABSTRACT|DROPDEL)))
		I.forceMove(src)
		material = I
		update_appearance(UPDATE_OVERLAYS)
		return

	if(material && material.artrecipe && material.artrecipe.hammered && istype(I, material.artrecipe.needed_item))
		material.artrecipe.item_added(user)
		qdel(I)
		return

	..()

/obj/machinery/artificer_table/proc/choose_recipe(user)
	if(!material)
		return

	var/list/valid_types = list()

	for(var/datum/artificer_recipe/R in GLOB.artificer_recipes)
		if(istype(material, R.required_item))
			if(!valid_types.Find(R.i_type))
				valid_types += R.i_type

	if(!valid_types.len)
		return

	var/i_type_choice = tgui_input_list(user, "Choose a type", "Artificer", valid_types)
	if(!i_type_choice)
		return

	var/list/appro_recipe = list()
	for(var/datum/artificer_recipe/R in GLOB.artificer_recipes)
		if(R.type != R.abstract_type && R.i_type == i_type_choice && istype(material, R.required_item))
			appro_recipe += R

	for(var/datum/artificer_recipe/R as anything in appro_recipe)
		if(!R.required_item)
			appro_recipe -= R
		if(!istype(material, R.required_item))
			appro_recipe -= R

	if(appro_recipe.len)
		var/datum/chosen_recipe = tgui_input_list(user, "Choose A Creation", "Artificer", sortNames(appro_recipe.Copy()))
		if(!material.artrecipe && chosen_recipe)
			material.artrecipe = new chosen_recipe.type(material)
			return TRUE

	return FALSE

/obj/machinery/artificer_table/attack_hand(mob/user, list/modifiers)
	if(!material)
		return ..()
	var/obj/item/I = material
	material = null
	I.loc = user.loc
	user.put_in_active_hand(I)
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/artificer_table/update_overlays()
	. = ..()
	if(!material)
		return
	var/obj/item/I = material
	I.pixel_x = I.base_pixel_x
	I.pixel_y = I.base_pixel_y
	var/mutable_appearance/M = new /mutable_appearance(I)
	M.transform *= 0.8
	M.pixel_y = 6
	M.pixel_x = 0
	. += M
