/obj/item/clothing/shoes/boots
	name = "dark boots"
	//dropshrink = 0.75
	color = "#d5c2aa"
	desc = "Boots made out of darker materials. Offers light protection against melee attacks."
	gender = PLURAL
	icon_state = "blackboots"
	item_state = "blackboots"
	armor = list("blunt" = 15, "slash" = 15, "stab" = 15,  "piercing" = 5, "fire" = 0, "acid" = 0)
	sellprice = 10
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/shoes/boots/armor
	name = "plated boots"
	desc = "Armored boots made from steel offering heavy protection against both melee and ranged attacks."
	body_parts_covered = FEET
	icon_state = "armorboots"
	item_state = "armorboots"
	prevent_crits = list(BCLASS_LASHING, BCLASS_BITE, BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	color = null
	blocksound = PLATEHIT
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100,  "piercing" = 80, "fire" = 0, "acid" = 0)
	max_integrity = INTEGRITY_STRONGEST
	armor_class = AC_HEAVY
	clothing_flags = CANT_SLEEP_IN
	anvilrepair = /datum/skill/craft/armorsmithing
	resistance_flags = FIRE_PROOF
	pickup_sound = "rustle"
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	sellprice = 25
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/shoes/boots/armor/light
	name = "light plate boots"
	icon_state = "soldierboots"
	item_state = "soldierboots"
	desc = "Lightly armored boots made from iron offering protection against both melee and ranged attacks."
	armor = list("blunt" = 80, "slash" = 80, "stab" = 80,  "piercing" = 60, "fire" = 0, "acid" = 0)
	max_integrity = INTEGRITY_STRONG + 50
	armor_class = AC_MEDIUM
	sellprice = 20
	item_weight = 7 * IRON_MULTIPLIER

/obj/item/clothing/shoes/boots/armor/ironmaille
	name = "chainmail boots"
	icon_state = "mailleboots"
	item_state = "mailleboots"
	desc = "Chainmail boots made from iron and cured leather, they offer a good protection for their cheap cost."
	armor = ARMOR_MAILLE_IRON
	max_integrity = 200 //meant to be weaker than iron plated boots, better options are out there waiting at the smith
	armor_class = AC_LIGHT
	sellprice = VALUE_IRON_ARMOR
	item_weight = 6 * IRON_MULTIPLIER
	smeltresult = /obj/item/fertilizer/ash //we avoid melting one piece for one bar
	melting_material = /datum/material/iron // we get one bar per two pieces of the item recovered and smelted
	melt_amount = 75

/obj/item/clothing/shoes/boots/armor/light/rust
	name = "rusted light plate boots"
	desc = "Rusted armored boots made from iron offering protection against both melee and ranged attacks. They smell stained of blood and urine."
	icon_state = "rustboots"
	icon = 'icons/roguetown/clothing/special/rust_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/shoes/boots/armor/blkknight
	name = "blacksteel boots"
	desc = "Boots forged from blacksteel, light yet strong, perfect for a fearless stride."
	icon_state = "bkboots"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	armor_class = AC_MEDIUM
	armor = ARMOR_PLATE_GOOD
	item_weight = 7 * BLACKSTEEL_MULTIPLIER
	sellprice = VALUE_SILVER_ITEM * 2

/obj/item/clothing/shoes/boots/leather
	name = "leather boots"
	//dropshrink = 0.75
	desc = "Boots made out of sturdy leather. Providing light protection against melee attacks."
	prevent_crits = list(BCLASS_LASHING, BCLASS_BITE, BCLASS_TWIST)
	gender = PLURAL
	icon_state = "leatherboots"
	item_state = "leatherboots"
	armor = list("blunt" = 20, "slash" = 20, "stab" = 20,  "piercing" = 10, "fire" = 0, "acid" = 0)
	resistance_flags = FLAMMABLE
	sellprice = 10
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	item_weight = 3
	max_integrity = INTEGRITY_STANDARD

//THE ARMOUR VALUES OF ADVANCED AND MASTERWORK BOOTS ARE INTENDED
//KEEP THIS IN MIND

/obj/item/clothing/shoes/boots/leather/advanced
	name = "hardened leather boots"
	desc = "Sturdy, durable, flexible. A marvel of the dark ages that exists solely to protect your toes."
	max_integrity = INTEGRITY_STANDARD + 50
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 50, "slash" = 40, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)

/obj/item/clothing/shoes/boots/leather/advanced/watch
	name = "watch boots"
	color = "#d5c2aa"
	desc = "These boots are reinforced with iron padding, designed not just for protection but for presence, announcing the approach of the city watch long before they're seen."
	gender = PLURAL
	icon_state = "nobleboots"
	item_state = "nobleboots"

/obj/item/clothing/shoes/boots/leather/advanced/watch/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, custom_sounds = list(SFX_WATCH_BOOT_STEP))

/obj/item/clothing/shoes/boots/leather/masterwork
	name = "masterwork leather boots"
	desc = "These boots are a craftsmanship marvel. Made with the finest leather. Strong, nimible, reliable."
	max_integrity = INTEGRITY_STANDARD + 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP) //we're adding chop here!
	armor = list("blunt" = 80, "slash" = 60, "stab" = 40, "piercing" = 0,"fire" = 0, "acid" = 0)

/obj/item/clothing/shoes/boots/leather/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

/obj/item/clothing/shoes/boots/furlinedboots
	name = "fur lined boots"
	desc = "Leather boots lined with fur."
	gender = PLURAL
	icon_state = "furlinedboots"
	item_state = "furlinedboots"
	sewrepair = TRUE
	armor = list("blunt" = 30, "slash" = 10, "stab" = 20,  "piercing" = 0, "fire" = 0, "acid" = 0)
	salvage_result = /obj/item/natural/fur
	salvage_amount = 1
	item_weight = 3
	min_cold_protection_temperature = -20

/obj/item/clothing/shoes/boots/furlinedanklets
	name = "fur lined anklets"
	desc = "Leather anklets lined with fur, foot remains bare."
	gender = PLURAL
	icon_state = "furlinedanklets"
	item_state = "furlinedanklets"
	sewrepair = TRUE
	armor = list("blunt" = 30, "slash" = 10, "stab" = 20,  "piercing" = 0, "fire" = 0, "acid" = 0)
	is_barefoot = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/fur
	min_cold_protection_temperature = -20

/obj/item/clothing/shoes/boots/clothlinedanklets
	name = "cloth lined anklets"
	desc = "Cloth anklets lined with with fibers, foot remains bare."
	gender = PLURAL
	icon_state = "clothlinedanklets"
	item_state = "furlinedanklets"
	is_barefoot = TRUE
	sewrepair = TRUE
	armor = list("blunt" = 5, "slash" = 5, "stab" = 5,  "piercing" = 0, "fire" = 0, "acid" = 0) //Thinks its fair for a piece of cloth and fiber.
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	item_weight = 2

/obj/item/clothing/shoes/boots/armor/vampire
	name = "ancient ceremonial boots"
	desc = "Antediluvian boots with ceremonial ornamets from ages past."
	icon_state = "vboots"
	item_state = "vboots"
	prevent_crits = ALL_CRITICAL_HITS_VAMP
	armor = ARMOR_PLATE_GOOD
	item_weight = 5 * STEEL_MULTIPLIER

//............... Evil Boots ............... //

/obj/item/clothing/shoes/boots/armor/zizo
	name = "darksteel boots"
	desc = "Plate boots. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizoboots"
	item_state = "zizoboots"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this

/obj/item/clothing/shoes/boots/armor/matthios
	name = "gilded boots"
	desc = "Plate boots. A door kicked in, treasures to behold inside."
	icon_state = "matthiosboots"
	item_state = "matthiosboots"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

/obj/item/clothing/shoes/boots/armor/graggar
	name = "vicious boots"
	desc = "A menacing pair of plate boots, caked in blood and brain matter. Known for crushing skulls."
	icon_state = "graggarplateboots"
	item_state = "graggarplateboots"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment
