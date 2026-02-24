/datum/slapcraft_step/use_item
	abstract_type = /datum/slapcraft_step/use_item
	insert_item = FALSE
	start_verb = "of"
	perform_time = 3.5 SECONDS

/datum/slapcraft_step/use_item/sewing
	abstract_type = /datum/slapcraft_step/use_item/sewing
	skill_type = /datum/skill/craft/sewing


/datum/slapcraft_step/use_item/carpentry
	abstract_type = /datum/slapcraft_step/use_item/carpentry
	skill_type = /datum/skill/craft/carpentry

/datum/slapcraft_step/use_item/masonry
	abstract_type = /datum/slapcraft_step/use_item/masonry
	skill_type = /datum/skill/craft/masonry

/datum/slapcraft_step/use_item/engineering
	abstract_type = /datum/slapcraft_step/use_item/engineering
	skill_type = /datum/skill/craft/masonry

/datum/slapcraft_step/item
	abstract_type = /datum/slapcraft_step/item
	perform_time = 0.2 SECONDS

/datum/slapcraft_step/structure
	abstract_type = /datum/slapcraft_step/structure
	check_if_mob_can_drop_item = FALSE
	insert_item_into_result = TRUE

/datum/slapcraft_step/structure/move_item_to_assembly(mob/living/user, obj/structure/structure, obj/item/slapcraft_assembly/assembly)
	structure.forceMove(assembly)
	if(insert_item_into_result)
		assembly.items_to_place_in_result += structure

/datum/slapcraft_step/structure/make_finished_desc()
	return "\The [list_desc] has been acted upon."
