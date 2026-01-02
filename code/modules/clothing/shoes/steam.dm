/obj/item/clothing/shoes/boots/armor/steam
	name = "steamknight boots"
	desc = "Part of the steamknight armor. Requires knowledge in engineering to operate."
	icon = 'icons/roguetown/clothing/steamknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/steamknight_onmob.dmi'
	icon_state = "steamknight_boots"

	sleeved =  'icons/roguetown/clothing/onmob/steamknight_onmob.dmi'
	sleevetype = "steamknight_boots"

	anvilrepair = /datum/skill/craft/engineering
	slowdown = 1.5
	item_weight = 6 * BRONZE_MULTIPLIER

/obj/item/clothing/shoes/boots/armor/steam/dropped(mob/living/carbon/user)
	// Locate the boiler in the back slots
	var/obj/item/clothing/cloak/boiler/B = locate(/obj/item/clothing/cloak/boiler) in list(user.backr, user.backl)
	if(B)
		B.power_off(user)

	. = ..()

/obj/item/clothing/shoes/boots/armor/steam/proc/power_on(mob/living/user)
	slowdown = 0
	user.update_equipment_speed_mods()

/obj/item/clothing/shoes/boots/armor/steam/proc/power_off(mob/living/user)
	slowdown = 1.5
	user.update_equipment_speed_mods()
