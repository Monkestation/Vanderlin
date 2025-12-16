/// Subtype more forgiving for items.
/// Careful, this can go wrong and keep a mob hyperfocused on an item it can't lose aggro on
/datum/targetting_datum/basic/allow_items

/datum/targetting_datum/basic/allow_items/can_attack(mob/living/living_mob, atom/the_target)
	. = ..()
	if(isitem(the_target))
		// trust fall exercise
		return TRUE

/datum/targetting_datum/basic/allow_items/meatvine

/datum/targetting_datum/basic/allow_items/meatvine/can_attack(mob/living/living_mob, atom/the_target)
	var/datum/ai_controller/controller = living_mob.ai_controller
	if(length(controller.blackboard[BB_MEATVINE_ATTACK_FAIL]))
		var/list/fail_list = controller.blackboard[BB_MEATVINE_ATTACK_FAIL]
		for(var/datum/ref as anything in fail_list)
			if(fail_list[ref] + 1 MINUTES < world.time)
				controller.blackboard[BB_MEATVINE_ATTACK_FAIL] -= ref
				continue
			var/datum/component/bounded/bound = living_mob.GetComponent(/datum/component/bounded)
			if(!bound)
				var/mob/living/simple_animal/hostile/retaliate/meatvine/meat_mob = living_mob
				if(meat_mob.tether_distance)
					var/broken = FALSE
					for(var/obj/structure/meatvine/floor/floor in range(meat_mob.tether_distance, the_target))
						broken = TRUE
						break
					if(!broken)
						return FALSE
			else
				if(get_dist(bound.master, the_target) > bound.max_dist + 1) //mobs can actually attack 1 past bounds
					return FALSE
	. = ..()
