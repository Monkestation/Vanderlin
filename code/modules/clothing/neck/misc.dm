//..................................................................................................................................
/*---------------\
|			 	 |
|  Light Armor	 |
|			 	 |
\---------------*/
/obj/item/clothing/neck/goldamulet
	name = "gold amulet"
	icon_state = "amuletg"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 60

/obj/item/clothing/neck/silveramulet
	name = "silver amulet"
	icon_state = "amulets"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 35

/obj/item/clothing/neck/silveramulet/Initialize()
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/neck/jadeamulet
	name = "joapstone amulet"
	icon_state = "amulet_jade"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 60

/obj/item/clothing/neck/turqamulet
	name = "ceruleabaster amulet"
	icon_state = "amulet_turq"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 85

/obj/item/clothing/neck/onyxaamulet
	name = "onyxa amulet"
	icon_state = "amulet_onyxa"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 40

/obj/item/clothing/neck/coralamulet
	name = "aoetal amulet"
	icon_state = "amulet_coral"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 70

/obj/item/clothing/neck/amberamulet
	name = "petriamber amulet"
	icon_state = "amulet_amber"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 60

/obj/item/clothing/neck/opalamulet
	name = "opaloise amulet"
	icon_state = "amulet_opal"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 90

/obj/item/clothing/neck/roseamulet
	name = "rosellusk amulet"
	icon_state = "amulet_rose"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 25

/obj/item/clothing/neck/shellamulet
	name = "shell amulet"
	icon_state = "amulet_shell"
	slot_flags = ITEM_SLOT_NECK
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sellprice = 25

/obj/item/clothing/neck/coif
	name = "leather coif"
	desc = "A simple coif made of boiled leather, not that good as armor itself but mostly useful as padding for proper helmets."
	icon_state = "coif"
	item_state = "coif"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	blocksound = SOFTHIT
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	sewrepair = TRUE
	anvilrepair = null
	resistance_flags = FLAMMABLE // Made of leather
	smeltresult = /obj/item/fertilizer/ash

	armor_class = AC_LIGHT
	armor = ARMOR_LEATHER
	body_parts_covered = NECK|HAIR|EARS|HEAD
	max_integrity = INTEGRITY_POOR
	prevent_crits = CUT_AND_MINOR_CRITS


/obj/item/clothing/neck/coif/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = HIDEEARS|HIDEHAIR
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_neck()
					H.update_inv_head()
		user.regenerate_clothes()

/obj/item/clothing/neck/coif/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)

/obj/item/clothing/neck/coif/cloth
	name = "padded coif"
	desc = "A simple coif made of cloth. Not very effective armor, but may soften weak blows and keeps the head and neck warm."
	icon_state = "ccoif"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	blocksound = SOFTHIT
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE

	armor_class = AC_LIGHT
	armor = ARMOR_PADDED
	body_parts_covered = NECK|HAIR|EARS|HEAD
	prevent_crits = MINOR_CRITICALS

/obj/item/clothing/neck/leathercollar
	name = "leather collar"
	desc = "A fashionable piece of neckwear popular among Hollow-Kin."
	icon_state = "collar"
	blocksound = SOFTHIT
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	anvilrepair = null
	resistance_flags = FLAMMABLE
	smeltresult = /obj/item/fertilizer/ash

	armor = ARMOR_LEATHER
	max_integrity = INTEGRITY_WORST
	prevent_crits = CUT_AND_MINOR_CRITS

/obj/item/clothing/neck/bellcollar
	name = "bell collar"
	desc = "A leather collar with a small bell attached, popular among Hollow-Kin."
	icon_state = "bell_collar"
	blocksound = SOFTHIT
	equip_sound = SFX_JINGLE_BELLS
	pickup_sound = SFX_JINGLE_BELLS
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = SFX_JINGLE_BELLS
	sewrepair = TRUE
	anvilrepair = null
	resistance_flags = FLAMMABLE
	smeltresult = /obj/item/fertilizer/ash

	armor = ARMOR_LEATHER
	max_integrity = INTEGRITY_WORST
	prevent_crits = CUT_AND_MINOR_CRITS

/obj/item/clothing/neck/bellcollar/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = list(SFX_JINGLE_BELLS))
//..................................................................................................................................
/*---------------\
|			 	 |
|  Medium Armor	 |
|			 	 |
\---------------*/

/obj/item/clothing/neck/chaincoif
	name = "chain coif"
	desc = "A coif made of interwoven steel rings, made to protect against arrows and blades. \
			Generally used as padding, but serviceable enough on its own."
	icon_state = "chaincoif"
	flags_inv = HIDEEARS|HIDEHAIR
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = CHAINHIT
	smeltresult = null
	smeltresult = /obj/item/ingot/steel
	melting_material = /datum/material/iron
	melt_amount = 100
	clothing_flags = CANT_SLEEP_IN

	armor_class = AC_MEDIUM
	armor = ARMOR_MAILLE
	body_parts_covered = NECK|HAIR|EARS|HEAD
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_EXCEPT_BLUNT


/obj/item/clothing/neck/chaincoif/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = HIDEEARS|HIDEHAIR
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_neck()
					H.update_inv_head()

	user.regenerate_clothes()

/obj/item/clothing/neck/chaincoif/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)

/obj/item/clothing/neck/chaincoif/iron
	icon_state = "ichaincoif"
	name = "iron chain coif"
	desc = "A chain coif made of interwoven iron rings. Affordable protection against arrows and blades, \
			but should be used as padding rather than relied upon as armor."
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	melt_amount = 100

	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STRONG

/obj/item/clothing/neck/gorget/copper
	name = "neck protector"
	icon_state = "copperneck"
	desc = "An antique and simple protection for the neck, used more as an accessory by the common folk. But poor protection is still better than nothing."
	smeltresult = /obj/item/ingot/copper

	armor_class = AC_MEDIUM
	armor = ARMOR_LEATHER_GOOD
	max_integrity = INTEGRITY_POOR


//..................................................................................................................................
/*---------------\
|			 	 |
|  Heavy Armor	 |
|			 	 |
\---------------*/

/obj/item/clothing/neck/bevor
	name = "bevor"
	desc = "A piece of steel plate armor meant to protect the throat and neck of its wearer against decapitation, extending the protection of armor plates."
	icon_state = "bevor"
	flags_inv = HIDEFACIALHAIR
	melt_amount = 75
	melting_material = /datum/material/steel
	melt_amount = 100
	melting_material = /datum/material/steel
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	slot_flags = ITEM_SLOT_NECK
	blocksound = PLATEHIT
	clothing_flags = CANT_SLEEP_IN

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE
	body_parts_covered = NECK|EARS|MOUTH|NOSE
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_EXCEPT_STAB

/obj/item/clothing/neck/bevor/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)

/obj/item/clothing/neck/bevor/iron
	name = "iron bevor"
	desc = "A piece of iron plate armor meant to protect the throat and neck of its wearer against decapitation, extending the protection of armor plates."
	icon_state = "ibevor"
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG

/obj/item/clothing/neck/gorget
	name = "gorget"
	icon_state = "gorget"
	desc = "An affordable piece of iron armor meant to protect one's neck against chopping. \
			Fits comfortably beneath chest armor, despite its weight."
	flags_inv = HIDEFACIALHAIR
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	blocksound = PLATEHIT
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	clothing_flags = CANT_SLEEP_IN

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE_BAD
	body_parts_covered = NECK
	max_integrity = INTEGRITY_STRONG
	prevent_crits = ALL_EXCEPT_STAB

/obj/item/clothing/neck/gorget/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)

/obj/item/clothing/neck/gorget/hoplite // Better than an iron gorget, not quite as good as a steel bevor
	name = "bronze gorget"
	desc = "A heavy collar of great age, meant to protect the neck."
	icon_state = "aasimarneck"
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	armor = ARMOR_MAILLE_GOOD

/obj/item/clothing/neck/highcollier
	name = "high collier"
	desc = "A more durable, thicker, piece of chain neck protection, though, this one only covers the neck, ears and mouth when pulled up."
	icon_state = "high_collier"
	icon = 'icons/roguetown/clothing/special/coif.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/coif.dmi'
	body_parts_covered = NECK|MOUTH|EARS
	slot_flags = ITEM_SLOT_NECK
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	armor = ARMOR_MAILLE_GOOD
	resistance_flags = FIRE_PROOF
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = CHAINHIT
	smeltresult = null
	clothing_flags = CANT_SLEEP_IN
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_EXCEPT_BLUNT

/obj/item/clothing/neck/highcollier/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv = HIDEFACE|HIDEFACIALHAIR
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_neck()
		user.regenerate_clothes()

/obj/item/clothing/neck/highcollier/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)

/obj/item/clothing/neck/highcollier/iron
	name = "iron high collier"
	desc = "A thicker piece of chain neck protection made from iron, though, this one only covers the neck and mouth when pulled up."
	icon_state = "ihigh_collier"
	body_parts_covered = NECK|MOUTH
	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STRONG
	smeltresult = /obj/item/ingot/iron
	melt_amount = 100
	melting_material = /datum/material/iron

/obj/item/clothing/neck/highcollier/iron/renegadecollar
	icon_state = "renegadecollar"
	name = "black collar"
	desc = "A tough leather collar concealing iron chain mail, meant to be paired with its jacket. This one also covers not only the neck and mouth, but also the nose and ears."
	body_parts_covered = NECK|EARS|MOUTH|NOSE

//........................................................................................
/*---------------\
|				|
|	Misc?		|
|				|
\---------------*/


/obj/item/clothing/neck/talkstone
	name = "talkstone"
	desc = "A bizarre, enchanted necklace. Allows you to bridge the gap between languages."
	icon_state = "talkstone"
	item_state = "talkstone"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 98

/obj/item/clothing/neck/mercator
	name = "mercator's eye"
	desc = "An enchanted amulet commissioned by the Mercator Guild to quickly determine the commercial value of bulk goods."
	icon_state = "horus"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 30

/obj/item/clothing/neck/mercator/examine()
	. = ..()
	. += span_info("Click on a turf or an item to see how much it is worth.")

/obj/item/clothing/neck/mercator/afterattack(atom/A, mob/user, params)
	. = ..()
	var/total_sellprice = 0
	if(isturf(A))
		for(var/obj/item/I in A.contents)
			total_sellprice += I.sellprice
		to_chat(user, span_notice("Everything on the ground is worth [total_sellprice] mammons."))
	else if(istype(A, /obj/item))
		var/obj/item/I = A
		total_sellprice += I.sellprice
		for(var/obj/item/item in I.contents)
			total_sellprice += item.sellprice
		to_chat(user, span_notice("The item and its contents is worth [total_sellprice] mammons."))

/obj/item/clothing/neck/shalal
	name = "desert rider medal"
	desc = ""
	icon_state = "shalal"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 15

/obj/item/clothing/neck/shalal/emir
	name = "desert noble medal"

/obj/item/clothing/neck/feld
	name = "feldsher's collar"
	desc = "Fits snug."
	icon_state = "feldcollar"
	item_state = "feldcollar"
	sellprice = 15

/obj/item/clothing/neck/phys
	name = "physicker's collar"
	desc = "Fits snug."
	icon_state = "surgcollar"
	item_state = "surgcollar"
	sellprice = 15

/obj/item/clothing/neck/courtphysician
	name = "court physician's collar"
	desc = "Fits snug."
	icon_state = "courtcollar"
	item_state = "courtcollar"
	sellprice = 15
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'

/obj/item/clothing/neck/bogcowl
	name = "bogcowl"
	desc = "An odd cowl made using mud, sticks, and fibers."
	icon_state = "bogcowl"

/obj/item/clothing/neck/elfears
	name = "elfear necklace"
	desc = "A grim necklace made to show off the wearer's macabre collection of cut off elf ears."
	icon_state = "elfears"

/obj/item/clothing/neck/menears
	name = "menear necklace"
	desc = "A grim necklace made to show off the wearer's macabre collection of cut off humen ears."
	icon_state = "menears"
