/datum/brewing_recipe/cheese
	name = "Cheese"
	needed_reagents = list(/datum/reagent/consumable/milk/salted = 5)
	reagent_to_brew = null
	brewed_item = /obj/item/reagent_containers/food/snacks/cheese
	brew_time = 30 SECONDS
	brewed_amount = 0
	helpful_hints = span_info("Needs to be strained with a cloth to finish.")
	start_verb = "fermenting"
	brewed_item_count = 2
	pre_reqs = /datum/reagent/consumable/milk/salted

/datum/brewing_recipe/cheese/create_items(mob/user, obj/item/attacked_item, atom/source, number_of_repeats)
	if(brewed_item)
		for(var/i in 1 to (brewed_item_count * number_of_repeats))
			new brewed_item(get_turf(source))

/datum/brewing_recipe/cheese/after_finish_attackby(mob/user, obj/item/attacked_item, atom/source)
	if(!istype(attacked_item, /obj/item/natural/cloth))
		return FALSE

	user.visible_message("<span class='info'>[user] strains out fresh cheese...</span>")
	playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)

	if(!do_after(user, (90 - (user.get_skill_level(/datum/skill/craft/cooking, TRUE) * 15)), source))
		return FALSE

	return TRUE

/datum/brewing_recipe/cheese/gote
	name = "Gote Cheese"
	needed_reagents = list(/datum/reagent/consumable/milk/salted_gote = 5)
	brewed_item = /obj/item/reagent_containers/food/snacks/cheese/gote
	pre_reqs = /datum/reagent/consumable/milk/salted_gote
