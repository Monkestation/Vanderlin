/datum/action/cooldown/spell/essence/stone_shape
	name = "Form Brick"
	desc = "Forms a brick out of the grounds materials."
	button_icon_state = "stone_shape"
	cast_range = 2
	point_cost = 4
	attunements = list(/datum/attunement/earth)

/datum/action/cooldown/spell/essence/stone_shape/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] shapes the stone with magical force."))

	if(!isliving(owner))
		return
	var/mob/living/L = owner
	var/INT = L.STAINT
	if(INT <= 10)
		return
	var/obj/item/brick = new /obj/item/weapon/magicbrick(target_turf)
	var/int_scaling = INT - 10
	brick.force = (brick.force + int_scaling)
	brick.throwforce = (brick.throwforce + int_scaling * 2)
	brick.name = "magician's brick +[int_scaling]"
	owner.put_in_hands(brick, FALSE)
