
/obj/item/bodypart/chest
	name = "chest"
	desc = ""
	icon_state = "default_human_chest"
	max_damage = 200
	body_zone = BODY_ZONE_CHEST
	body_part = CHEST
	px_x = 0
	px_y = 0
	aux_zone = "boob"
	aux_layer = BODYPARTS_LAYER
	subtargets = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_GROIN)
	grabtargets = list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_GROIN)
	offset = OFFSET_ARMOR
	dismemberable = FALSE

	max_cavity_item_size = WEIGHT_CLASS_BULKY
	max_cavity_volume = 10

	grid_width = 64
	grid_height = 96

	artery_type = ARTERY_CHEST
	limb_flags = BODYPART_HAS_ARTERY | BODYPART_BONE_ENCASED

/obj/item/bodypart/chest/set_disabled(new_disabled)
	. = ..()
	if(!.)
		return
	if(bodypart_disabled == BODYPART_DISABLED_DAMAGE || bodypart_disabled == BODYPART_DISABLED_WOUND)
		if(owner.stat < DEAD)
			to_chat(owner, "<span class='warning'>I feel a sharp pain in my back!</span>")

/obj/item/bodypart/chest/Destroy()
	return ..()

/obj/item/bodypart/chest/monkey
	icon = 'icons/mob/animal_parts.dmi'
	icon_state = "default_monkey_chest"
	animal_origin = MONKEY_BODYPART

/obj/item/bodypart/chest/devil
	dismemberable = 0
	max_damage = 5000
	animal_origin = DEVIL_BODYPART
