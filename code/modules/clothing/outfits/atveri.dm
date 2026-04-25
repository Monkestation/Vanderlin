
/obj/item/clothing/armor/chainmail/hauberk/atgervi
	name = "dwarven-make hauberk"
	desc = "The pride of mercenaries from the Dwarven Federation, a well crafted blend of chain and leather into a dense protective coat."
	icon_state = "atgervi_raider_mail"
	item_state = "atgervi_raider_mail"
	max_integrity = 400

/obj/item/clothing/armor/leather/atgervi
	name = "shaman's coat"
	desc = "A furred protective coat, often made by hand from a beast killed in the bearer's hunt."
	icon_state = "atgervi_shaman_coat"
	item_state = "atgervi_shaman_coat"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = ALL_EXCEPT_STAB
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER

/obj/item/clothing/armor/leather/atgervi/advanced
	name = "hardened shaman's coat"
	desc = "A thick, furred protective coat, often made by hand expertly from a beast killed in the bearer's hunt."
	max_integrity = INTEGRITY_STRONG
	prevent_crits = ALL_EXCEPT_CHOP_AND_STAB
	armor = list("blunt" = 75, "slash" = 60, "stab" = 30, "piercing" = 10, "fire" = 0, "acid" = 0)

/obj/item/clothing/armor/leather/atgervi/masterwork
	name = "masterwork shaman's coat"
	desc = "This coat was masterfully hand crafted with dendors blessing, and interwined with the fur and hide of beasts of the true, untamed wilds, often made by hand masterfully from a dangerous beast killed in the bearer's many hunts."
	max_integrity = INTEGRITY_STRONG + 100
	prevent_crits = ALL_EXCEPT_STAB
	armor = list("blunt" = 100, "slash" = 70, "stab" = 40, "piercing" = 10, "fire" = 0, "acid" = 0)

/obj/item/clothing/armor/leather/atgervi/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))


/obj/item/clothing/pants/trou/leather/atgervi
	name = "fur pants"
	desc = "Thick fur pants made to endure the coldest winds, offering a share of protection from fang and claw of beast or men alike."
	icon_state = "atgervi_pants"
	item_state = "atgervi_pants"

/obj/item/clothing/pants/trou/leather/atgervi/advanced
	name = "hardened fur chausses"
	desc = "Expertly made thick fur pants made to endure the coldest winds, offering a measure of protection from fang and claw of beast or men alike."
	max_integrity = INTEGRITY_STRONG
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 70, "slash" = 60, "stab" = 30, "piercing" = 20,"fire" = 0, "acid" = 0)

/obj/item/clothing/pants/trou/leather/atgervi/masterwork
	name = "masterwork fur chausses"
	desc = "Masterfully made thick fur pants made to endure extreme winter winds, offering a reliable amount of protection from fang, and claw of beast or men alike."
	max_integrity = INTEGRITY_STRONG + 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP)
	armor = list("blunt" = 100, "slash" = 70, "stab" = 40, "piercing" = 20, "fire" = 0, "acid" = 0)

/obj/item/clothing/pants/trou/leather/atgervi/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))


/obj/item/clothing/gloves/angle/atgervi
	name = "fur-lined leather gloves"
	desc = "Thick, padded gloves made for the harshest of climates, and wildest of beasts encountered in the untamed lands."
	icon_state = "atgervi_raider_gloves"
	item_state = "atgervi_raider_gloves"

/obj/item/clothing/gloves/angle/atgervi/advanced
	name = "hardened fur-lined leather gloves"
	desc = "Thick, well padded gloves made for the harshest of climates, and wildest- and most dangeress- of beasts encountered in the untamed lands."
	icon_state = "atgervi_raider_gloves"
	item_state = "atgervi_raider_gloves"
	max_integrity = INTEGRITY_STRONG
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 70, "slash" = 60, "stab" = 30, "piercing" = 20,"fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/angle/atgervi/masterwork
	name = "masterwork fur-lined leather gloves"
	desc = "Thick, masterfully padded gloves made for the harshest, most extreme of climates, and wildest- and most dangeress- of beasts encountered in the untamed lands."
	max_integrity = INTEGRITY_STRONG + 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP)
	armor = list("blunt" = 100, "slash" = 70, "stab" = 40, "piercing" = 20, "fire" = 0, "acid" = 0)

/obj/item/clothing/gloves/angle/atgervi/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

/obj/item/clothing/gloves/plate/atgervi
	name = "beast claws"
	desc = "A menacing pair of plated claws, a ceremonial weapon of the Osslandic hunters. The four claws symbolize the four godly aspects they revere."
	icon_state = "atgervi_shaman_gloves"
	item_state = "atergvi_shaman_gloves"

/obj/item/clothing/head/helmet/bascinet/atgervi
	name = "owl helmet"
	desc = "A carefully forged steel helmet in the shape of an owl's face, with added chain to cover the face and neck against many blows."
	icon_state = "atgervi_raider"
	item_state = "atgervi_raider"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48

/obj/item/clothing/head/helmet/leather/saiga/atgervi
	name = "moose hood"
	desc = "A deceptively strong hood of hide with a pair of large heavy antlers. A suitable memorial for a worthy beast."
	icon_state = "atgervi_shaman"
	item_state = "atgervi_shaman"
	flags_inv = HIDEEARS|HIDEFACE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	flags_inv = HIDEEARS
	bloody_icon = 'icons/effects/blood64x64.dmi'
	worn_x_dimension = 32
	worn_y_dimension = 48
	experimental_inhand = TRUE
	experimental_onhip = FALSE

/obj/item/clothing/shoes/boots/leather/atgervi
	name = "atgervi leather boots"
	desc = "A pair of strong leather boots, designed to endure battle and the chill of the frozen north both."
	icon_state = "atgervi_boots"
	item_state = "atgervi_boots"

/obj/item/weapon/shield/atgervi
	name = "kite shield"
	desc = "A large but light wooden shield with a steel boss in the center to deflect blows more easily."
	icon_state = "atgervi_shield"
	item_state = "atgervi_shield"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	force = DAMAGE_SHIELD + 5
	throwforce = DAMAGE_SHIELD
	dropshrink = 0.8
	coverage = 80
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 300
	experimental_inhand = FALSE

/obj/item/weapon/shield/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onback")
				return list("shrink" = 0.7,"sx" = -17,"sy" = -15,"nx" = -15,"ny" = -15,"wx" = -12,"wy" = -15,"ex" = -18,"ey" = -15,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

// Gronnic subtypes of atgervi clothes
/obj/item/clothing/head/helmet/leather/shaman_hood
	name = "moose hood"
	desc = "A deceptively strong hood of hide with a pair of large heavy antlers. A suitable memorial for a worthy beast."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/gronn.dmi'
	icon_state = "gronnfurhood"
	item_state = "gronnfurhood"
	bloody_icon = 'icons/effects/blood64x64.dmi'
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	misc_flags = CRAFTING_TEST_EXCLUDE //special item with unique mechanics, not craftable
	armor = ARMOR_LEATHER_GOOD
	flags_inv = HIDEEARS|HIDEFACE
	worn_x_dimension = 32
	worn_y_dimension = 48
	sellprice = 10
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	salvage_result = /obj/item/natural/hide/cured
	var/on = FALSE
	var/lux_consumed = FALSE
	var/lux_color = LIGHT_COLOR_CYAN
	adjustable = CAN_CADJUST
	light_color = LIGHT_COLOR_ORANGE
	light_system = MOVABLE_LIGHT
	light_inner_range = 3
	light_power = 1
	toggle_icon_state = TRUE

/obj/item/clothing/head/helmet/leather/shaman_hood/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.remove_status_effect(/datum/status_effect/debuff/lost_shaman_hood)
		H.remove_stress(/datum/stress_event/shamanhoodlost)

/obj/item/clothing/head/helmet/leather/shaman_hood/dropped(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.merctype == 1) //Atgervi
			H.apply_status_effect(/datum/status_effect/debuff/lost_shaman_hood)
			H.add_stress(/datum/stress_event/shamanhoodlost)

/obj/item/clothing/head/helmet/leather/shaman_hood/Initialize(mapload)
	. = ..()
	set_light_on(FALSE)

/obj/item/clothing/head/helmet/leather/shaman_hood/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()

	if(.)
		return
	if(adjustable == CADJUSTED)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	toggle_helmet_light(user)
	to_chat(user, span_info("I spark [src] [on ? "on" : "off"]."))

/obj/item/clothing/head/helmet/leather/shaman_hood/proc/toggle_helmet_light(mob/living/user)
	on = !on
	set_light_on(on)
	if(on)
		playsound(loc, 'sound/effects/hood_ignite.ogg', 100, TRUE)
		do_sparks(2, FALSE, user)
	else
		playsound(loc, 'sound/misc/toggle_lamp.ogg', 100)
	update_icon()

/obj/item/clothing/head/helmet/leather/shaman_hood/update_icon_state()
	if(adjustable == CADJUSTED)
		..()
		return
	if(on)
		icon_state = "gronnfurhood_lit[lux_consumed ? "3" : "2"]"
		item_state = "gronnfurhood_lit[lux_consumed ? "3" : "2"]"
	else
		icon_state = "gronnfurhood"
		item_state = "gronnfurhood"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_head()
	..()

/obj/item/clothing/head/helmet/leather/shaman_hood/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/lux))
		if(adjustable == CADJUSTED)
			to_chat(user, span_warning("The hood must be up for this to work!"))
			return
		if(lux_consumed)
			to_chat(user, span_warning("It has already been infused."))
			return
		to_chat(user, span_warning("I infuse the hood with the soul energies!"))
		lux_consumed = TRUE
		set_light_range_power_color(6, 2, lux_color) //The light is doubled
		if(!on)
			toggle_helmet_light(user)
		else
			update_icon()
		qdel(I)
	. = ..()


/obj/item/clothing/head/helmet/leather/shaman_hood/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			playsound(src, 'sound/foley/equip/rummaging-03.ogg', 50, TRUE)
			if(on)
				toggle_helmet_light(user)
			if(toggle_icon_state)
				icon_state = "gronnfurhood_down"
				item_state = "gronnfurhood_down"
			adjustable = CADJUSTED
			flags_inv = null
			body_parts_covered = null
		else if(adjustable == CADJUSTED)
			playsound(src, 'sound/foley/equip/cloak (3).ogg', 50, TRUE)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_neck()
			H.update_inv_head()

/obj/item/clothing/head/helmet/leather/shaman_hood/ResetAdjust(mob/user)
	. = ..()
	if(on)
		set_light_on(FALSE)
	update_icon()


/obj/item/clothing/head/helmet/bascinet/atgervi/gronn
	name = "osslandic skull-helm"
	desc = "A helmet of hardened leather with a carefully preserved animal skull. \
			The skull integrated is a trophy of the bearer's great hunt, and a symbol of their reincarnation after death."

	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnleatherhelm"
	item_state = "gronnleatherhelm"
	block2add = null
	body_parts_covered = HEAD|HAIR|EARS|EYES|NOSE
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/clothing/head/helmet/bascinet/atgervi/gronn/ownel
	name = "osslandic scout's helmet"
	desc = "A full helmet that adequately protect the eyes and head; \
			The slits are decorated with a harsh gold dye - it is rumoured in Ossland to grant one the ability to see as keenly as The Hunter himself."
	icon_state = "gronnhelm"
	item_state = "gronnhelm"

/obj/item/clothing/armor/chainmail/hauberk/gronn
	name = "osslandic chain hauberk"
	desc = "A chain shirt of Osslandic design with a leather coat layered over, \
			offering additional protection and superior movement. It is often used by sea raiders."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnchain"
	item_state = "gronnchain"
	smeltresult = /obj/item/ingot/iron
