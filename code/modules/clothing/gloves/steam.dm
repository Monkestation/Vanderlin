/obj/item/clothing/gloves/plate/steam
	name = "steamknight gloves"
	desc = "Part of the steamknight armor. Requires knowledge in engineering to operate."

	icon = 'icons/roguetown/clothing/steamknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/steamknight_onmob.dmi'
	icon_state = "steamknight_gloves"

	sleeved =  'icons/roguetown/clothing/onmob/steamknight_onmob.dmi'
	sleevetype = "steamknight_gloves"

	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	item_weight = 7 * BRONZE_MULTIPLIER

/obj/item/clothing/shoes/boots/armor/steam/dropped(mob/living/carbon/user)
	// Locate the boiler in the back slots
	var/obj/item/clothing/cloak/boiler/B = locate(/obj/item/clothing/cloak/boiler) in list(user.backr, user.backl)
	if(B)
		B.power_off(user)

	. = ..()
