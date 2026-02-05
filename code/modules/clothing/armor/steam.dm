/obj/item/clothing/armor/steam
	name = "steamknight plate"
	desc = "The centerpiece of the steamknight armor. Requires knowledge in engineering to operate."

	icon = 'icons/roguetown/clothing/steamknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/steamknight_onmob.dmi'
	icon_state = "steamknight_chest"

	sleeved =  'icons/roguetown/clothing/onmob/steamknight_onmob.dmi'
	sleevetype = "steamknight_chest"

	anvilrepair = /datum/skill/craft/engineering

	clothing_flags = CANT_SLEEP_IN

	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE_GOOD
	body_parts_covered = COVERAGE_FULL
	prevent_crits = ALL_EXCEPT_BLUNT
	max_integrity = INTEGRITY_STRONGEST
	item_weight = 25 * BRONZE_MULTIPLIER
	stand_speed_reduction = 1.4

	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/armor/steam/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = SFX_POWER_ARMOR_STEP)

/obj/item/clothing/armor/steam/dropped(mob/living/carbon/user)
	// Locate the boiler in the back slots
	var/obj/item/clothing/cloak/boiler/B = locate(/obj/item/clothing/cloak/boiler) in list(user.backr, user.backl)
	if(B)
		B.power_off(user)

	. = ..()
