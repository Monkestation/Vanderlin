/datum/brewing_recipe/butter
	name = "Butter"
	needed_reagents = list(/datum/reagent/consumable/milk/salted = 15)
	reagent_to_brew = null
	brewed_item = /obj/item/reagent_containers/food/snacks/butter
	brew_time = 30 SECONDS
	brewed_amount = 0
	helpful_hints = span_info("Needs to be stirred with a stick to finish.")
	start_verb = "churning"
	brewed_item_count = 2
	pre_reqs = /datum/reagent/consumable/milk/salted

/datum/brewing_recipe/butter/create_items(mob/user, obj/item/attacked_item, atom/source, number_of_repeats)
	if(brewed_item)
		for(var/i in 1 to (brewed_item_count * number_of_repeats))
			new brewed_item(get_turf(source))

/datum/brewing_recipe/butter/after_finish_attackby(mob/living/user, obj/item/attacked_item, atom/source)
	if(!istype(attacked_item, /obj/item/grown/log/tree/stick))
		return FALSE

	user.adjust_stamina(20)
	user.visible_message(span_info("[user] churns butter..."))
	playsound(src, 'sound/foley/butterchurn.ogg', 100, TRUE, -1)

	if(!do_after(user, (10 SECONDS - (user.get_skill_level(/datum/skill/craft/cooking, TRUE) * 9)), source))
		return FALSE
	user.adjust_stamina(25)
	user.nobles_seen_servant_work()
	return TRUE

/datum/brewing_recipe/butter/gote
	name = "Gote Butter"
	needed_reagents = list(/datum/reagent/consumable/milk/salted_gote = 15)
	pre_reqs = /datum/reagent/consumable/milk/salted_gote
