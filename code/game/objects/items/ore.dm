/obj/item/ore
	name = "ore"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ore"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	grid_width = 32
	grid_height = 32
	melt_amount = 100
	recipe_quality = SMELTERY_QUALITY_NORMAL
	var/atom/mill_result // What this ore becomes when milled

/obj/item/ore/set_quality(quality)
	. = ..()
	// Quality affects melt amount
	var/quality_multiplier = 1.0
	switch(recipe_quality)
		if(SMELTERY_QUALITY_GOOD)
			quality_multiplier = 1.15
		if(SMELTERY_QUALITY_GREAT)
			quality_multiplier = 1.3
		if(SMELTERY_QUALITY_EXCELLENT)
			quality_multiplier = 1.45

	melt_amount = round(initial(melt_amount) * quality_multiplier)

/obj/item/ore/gold
	name = "raw gold"
	icon_state = "oregold1"
	smeltresult = /obj/item/ingot/gold
	melting_material = /datum/material/gold
	sellprice = 10
	item_weight = 10.1 KILOGRAMS
	mill_result = /obj/item/ore/dust/gold

/obj/item/ore/gold/Initialize(mapload)
	. = ..()
	icon_state = "oregold[rand(1,3)]"

/obj/item/ore/silver
	name = "raw silver"
	icon_state = "oresilv1"
	smeltresult = /obj/item/ingot/silver
	melting_material = /datum/material/silver
	sellprice = 8
	item_weight = 5.5 KILOGRAMS
	mill_result = /obj/item/ore/dust/silver

/obj/item/ore/silver/Initialize(mapload)
	. = ..()
	icon_state = "oresilv[rand(1,3)]"
	enchant(/datum/enchantment/silver)

/obj/item/ore/iron
	name = "raw iron"
	icon_state = "oreiron1"
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	sellprice = 5
	item_weight = 4.15 KILOGRAMS
	mill_result = /obj/item/ore/dust/iron

/obj/item/ore/iron/Initialize(mapload)
	. = ..()
	icon_state = "oreiron[rand(1,3)]"

/obj/item/ore/copper
	name = "raw copper"
	icon_state = "orecop1"
	smeltresult = /obj/item/ingot/copper
	melting_material = /datum/material/copper
	sellprice = 2
	item_weight = 4.7 KILOGRAMS
	mill_result = /obj/item/ore/dust/copper

/obj/item/ore/copper/Initialize(mapload)
	. = ..()
	icon_state = "orecop[rand(1,3)]"

/obj/item/ore/tin
	name = "raw tin"
	desc = "A mass of soft, almost malleable white ore."
	icon_state = "oretin1"
	smeltresult = /obj/item/ingot/tin
	melting_material = /datum/material/tin
	sellprice = 4
	item_weight = 3.8 KILOGRAMS
	mill_result = /obj/item/ore/dust/tin

/obj/item/ore/tin/Initialize(mapload)
	. = ..()
	icon_state = "oretin[rand(1,3)]"

/obj/item/ore/coal
	name = "coal"
	icon_state = "orecoal1"
	firefuel = 10 MINUTES
	smeltresult = /obj/item/ore/coal
	melting_material = /datum/material/coke
	melt_amount = 100
	sellprice = 1
	item_weight = 1.8 KILOGRAMS

/obj/item/ore/coal/Initialize(mapload)
	. = ..()
	icon_state = "orecoal[rand(1,3)]"

/obj/item/ore/cinnabar
	name = "cinnabar"
	desc = "Red gems that contain the essence of quicksilver."
	icon_state = "orecinnabar"
	grind_results = list(/datum/reagent/mercury = 15)
	sellprice = 5
	item_weight = 4.2 KILOGRAMS
	indexed = TRUE

/obj/item/ore/coal/charcoal
	name = "charcoal"
	icon_state = "oreada"
	desc = "Burnt lumps of wood."
	dropshrink = 0.8
	color = "#929292"
	firefuel = 30 MINUTES
	smeltresult = /obj/item/ore/coal/charcoal
	sellprice = 1


/* ............Black Briar............ */

/obj/item/ore/cursedrosa
	name = "black briar rosa"
	icon_state = "cursedrosa"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_MOUTH
	item_weight = 4.7 KILOGRAMS
	sellprice = 10

	embedding = list(
		"embed_chance" = 0.1, // we're cheating to make these embed items so if this happens tough luck
		"embedded_pain_multiplier" = 0,
		"embedded_fall_chance" = 0,
	)

	max_integrity = 500
	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 15, "slash" = 15, "stab" = 15,  "piercing" = 15, "fire" = 15, "acid" = 0)
	attacked_sound = list('sound/combat/hits/armor/chain_slashed (1).ogg', 'sound/combat/hits/armor/chain_slashed (2).ogg', 'sound/combat/hits/armor/chain_slashed (3).ogg')

/obj/item/ore/cursedrosa/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_MOUTH)
		icon_state = "cursedrosa_mouth"
	else
		icon_state = "cursedrosa"

/obj/item/ore/cursedrosa/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursedrosa, FALSE, TRUE)

/obj/item/ore/cursedrosa/examine(mob/user)
	. = ..()
	if(GetComponent(/datum/component/cursedrosa))
		. += span_briar("Its thorns have not been trimmed.")
	else
		. += span_info("Its thorns have been trimmed.")

/obj/item/ore/cursedrosa/attackby(obj/item/I, mob/living/user, params)
	if(!user.cmode && istype(I, /obj/item/weapon/knife))
		var/datum/component/thorns = GetComponent(/datum/component/cursedrosa)
		if(QDELETED(thorns))
			to_chat(user, span_warning("It has no thorns to trim."))
		else
			user.visible_message(span_notice("[user] trims the thorns from [src]."), span_notice("I trim the thorns from [src]."))
			playsound(I, 'sound/items/flint.ogg', 100, TRUE)
			qdel(thorns)
		return
	return ..()

/* ............Ingots............ */
/obj/item/ingot
	name = "ingot"
	desc = "A parent bar of metal. If you see this, report it on github."
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ingot"
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = null
	resistance_flags = FIRE_PROOF

	grid_width = 64
	grid_height = 32
	melt_amount = 100
	recipe_quality = SMELTERY_QUALITY_NORMAL

/obj/item/ingot/examine()
	. += ..()

/obj/item/ingot/Initialize(mapload, smelt_quality)
	. = ..()
	if(smelt_quality)
		recipe_quality = smelt_quality
		var/datum/quality_calculator/metallurgy/metal_calc = new()
		metal_calc.apply_quality_to_item(src, TRUE, recipe_quality)
		qdel(metal_calc)

/obj/item/ingot/attack_hand_secondary(mob/user, list/modifiers)
	if(currecipe)
		to_chat(user, span_notice("You begin canceling the recipe of \the [currecipe.name]."))
		if(do_after(user, 5 SECONDS, src, display_over_user = TRUE))
			QDEL_NULL(currecipe)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	. = ..()

/obj/item/ingot/Destroy()
	if(istype(loc, /obj/machinery/anvil))
		var/obj/machinery/anvil/A = loc
		A.working_material = null
		A.update_appearance(UPDATE_OVERLAYS)
	return ..()

/obj/item/ingot/gold
	name = "gold bar"
	desc = "A bar of glittering gold."
	icon_state = "ingotgold"
	smeltresult = /obj/item/ingot/gold
	melting_material = /datum/material/gold
	sellprice = 100
	item_weight = 12.25 KILOGRAMS

/obj/item/ingot/iron
	name = "iron bar"
	desc = "A bar of wrought iron."
	icon_state = "ingotiron"
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	sellprice = 25
	item_weight = 5 KILOGRAMS

/obj/item/ingot/thaumic
	name = "thaumic iron bar"
	desc = "A bar of wrought iron tempered with fire essence."
	icon_state = "infused_iron"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	smeltresult = /obj/item/ingot/thaumic
	melting_material = /datum/material/thaumic_iron
	sellprice = 25
	item_weight = 5 KILOGRAMS

/obj/item/ingot/copper
	name = "copper bar"
	desc = "A bar of copper."
	icon_state = "ingotcop"
	smeltresult = /obj/item/ingot/copper
	melting_material = /datum/material/copper
	sellprice = 10
	item_weight = 5.7 KILOGRAMS

/obj/item/ingot/tin
	name = "tin bar"
	desc = "An ingot of strangely soft and malleable essence."
	icon_state = "ingottin"
	smeltresult = /obj/item/ingot/tin
	melting_material = /datum/material/tin
	sellprice = 15
	item_weight = 4.6 KILOGRAMS

/obj/item/ingot/bronze
	name = "bronze bar"
	desc = "A hard and durable alloy favored by engineers and followers of Malum alike."
	icon_state = "ingotbronze"
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	sellprice = 30
	item_weight = 5.55 KILOGRAMS

/obj/item/ingot/silver
	name = "silver bar"
	desc = "A bar of glistening silver. The bane of nitewalkers."
	icon_state = "ingotsilv"
	smeltresult = /obj/item/ingot/silver
	melting_material = /datum/material/silver
	sellprice = 60
	item_weight = 6.65 KILOGRAMS

/obj/item/ingot/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/ingot/steel
	name = "steel bar"
	desc = "A bar of alloyed steel."
	icon_state = "ingotsteel"
	smeltresult = /obj/item/ingot/steel
	melting_material = /datum/material/steel
	sellprice = 40
	item_weight = 5 KILOGRAMS

/obj/item/ingot/steelholy
	name = "holy steel bar"
	desc = "This ingot of steel has been touched by Malum. It radiates heat, even when outside a forge."
	icon_state = "ingotsteelholy"
	smeltresult = /obj/item/ingot/steel
	melting_material = /datum/material/steel //Smelting it removes the blessing
	sellprice = 60
	item_weight = 5 KILOGRAMS

/obj/item/ingot/silverblessed
	name = "blessed silver bar"
	desc = "This bar radiates a divine purity that is treasured by the Psydonic faith. The Psycross and holy liturgies are transcribed on the surface."
	icon_state = "ingotsilvblessed"
	smeltresult = /obj/item/ingot/silver
	melting_material = /datum/material/silver //Smelting it removes the blessing
	sellprice = 100
	item_weight = 6.65 KILOGRAMS

/obj/item/ingot/blacksteel
	name = "blacksteel bar"
	desc = "Sacrificing the holy elements of silver for raw strength, this strange and powerful ingot's origin carries dark rumors..."
	icon_state = "ingotblacksteel"
	sellprice = 90
	smeltresult = /obj/item/ingot/blacksteel
	melting_material = /datum/material/blacksteel
	item_weight = 5.2 KILOGRAMS

/obj/item/ingot/steel_slag
	name = "steel slag"
	desc = "Slag containing steel, the result of blooming iron and coal."
	icon_state = "steel_slag"
	smeltresult = /obj/item/ingot/steel
	melting_material = /datum/material/steel
	sellprice = 40
	item_weight = 5.5 KILOGRAMS
