/datum/ai_behavior/lay_egg

/datum/ai_behavior/lay_egg/perform(delta_time, datum/ai_controller/controller, emote)
	var/mob/living/simple_animal/hostile/retaliate/chicken/living_pawn = controller.pawn
	if(!istype(living_pawn))
		return
	if(living_pawn.production < 29)
		finish_action(controller, FALSE)
		return
	living_pawn.visible_message(span_emote("[living_pawn] [pick(living_pawn.layMessage)]"))
	living_pawn.production = max(living_pawn.production - 30, 0)
	var/obj/item/reagent_containers/food/snacks/egg/E = new living_pawn.egg_type(get_turf(living_pawn))
	E.pixel_x = E.base_pixel_x + rand(-6,6)
	E.pixel_y = E.base_pixel_y + rand(-6,6)
	if(living_pawn.eggsFertile)
		if(living_pawn.chicken_count < MAX_CHICKENS && prob(1))
			E.fertile = TRUE
	finish_action(controller, TRUE)
