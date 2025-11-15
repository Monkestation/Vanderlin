/datum/action/cooldown/spell/essence/divine_order/cast(atom/cast_on)
	. = ..()
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	owner.visible_message(span_notice("[owner] calls upon divine light to bring perfect order."))
	new /obj/effect/temp_visual/divine_order(target_turf)
	for(var/obj/item/I in range(2, target_turf))
		I.pixel_x = I.base_pixel_x
		I.pixel_y = I.base_pixel_y
		I.transform = matrix()

/obj/effect/temp_visual/divine_order
	icon = 'icons/effects/eldritch.dmi'
	icon_state = "ring_leader_effect"
	duration = 2 SECONDS
	layer = EFFECTS_LAYER
	color = "#f5ef7a"
