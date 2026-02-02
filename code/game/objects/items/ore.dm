/obj/item/ore
	name = "ore"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ore"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF
	grid_width = 32
	grid_height = 32
	melt_amount = 120
	var/atom/mill_result // What this ore becomes when milled
	var/mill_yield_bonus = 0 // Extra yield from milling

/obj/item/ore/set_quality(quality)
	. = ..()
	// Quality affects melt amount
	var/quality_multiplier = 1.0
	switch(recipe_quality)
		if(2)
			quality_multiplier = 1.15
		if(3)
			quality_multiplier = 1.3
		if(4)
			quality_multiplier = 1.5

	melt_amount = round(initial(melt_amount) * quality_multiplier)

	// Update mill yield bonus
	mill_yield_bonus = (recipe_quality - 1) * 0.2

/obj/item/ore/gold
	name = "raw gold"
	icon_state = "oregold1"
	smeltresult = /obj/item/ingot/gold
	sellprice = 10
	melting_material = /datum/material/gold
	item_weight = 6.2 * GOLD_MULITPLIER
	mill_result = /obj/item/ore/dust/gold

/obj/item/ore/gold/Initialize(mapload)
	. = ..()
	icon_state = "oregold[rand(1,3)]"

/obj/item/ore/silver
	name = "raw silver"
	icon_state = "oresilv1"
	smeltresult = /obj/item/ingot/silver
	sellprice = 8
	melting_material = /datum/material/silver
	item_weight = 6.2 * SILVER_MULTIPLIER
	mill_result = /obj/item/ore/dust/silver

/obj/item/ore/silver/Initialize(mapload)
	. = ..()
	icon_state = "oresilv[rand(1,3)]"
	enchant(/datum/enchantment/silver)

/obj/item/ore/iron
	name = "raw iron"
	icon_state = "oreiron1"
	smeltresult = /obj/item/ingot/iron
	sellprice = 5
	melting_material = /datum/material/iron
	item_weight = 6.2 * IRON_MULTIPLIER
	mill_result = /obj/item/ore/dust/iron

/obj/item/ore/iron/Initialize(mapload)
	. = ..()
	icon_state = "oreiron[rand(1,3)]"

/obj/item/ore/copper
	name = "raw copper"
	icon_state = "orecop1"
	smeltresult = /obj/item/ingot/copper
	sellprice = 2
	melting_material = /datum/material/copper
	item_weight = 6.2 * COPPER_MULTIPLIER
	mill_result = /obj/item/ore/dust/copper

/obj/item/ore/copper/Initialize(mapload)
	. = ..()
	icon_state = "orecop[rand(1,3)]"

/obj/item/ore/tin
	name = "raw tin"
	desc = "A mass of soft, almost malleable white ore."
	icon_state = "oretin1"
	smeltresult = /obj/item/ingot/tin
	sellprice = 4
	melting_material = /datum/material/tin
	item_weight = 6.2 * TIN_MULTIPLIER
	mill_result = /obj/item/ore/dust/tin

/obj/item/ore/tin/Initialize(mapload)
	. = ..()
	icon_state = "oretin[rand(1,3)]"

/obj/item/ore/coal
	name = "coal"
	icon_state = "orecoal1"
	firefuel = 10 MINUTES
	smeltresult = /obj/item/ore/coal
	sellprice = 1
	item_weight = 7

/obj/item/ore/coal/Initialize(mapload)
	. = ..()
	icon_state = "orecoal[rand(1,3)]"

/obj/item/ore/cinnabar
	name = "cinnabar"
	desc = "Red gems that contain the essence of quicksilver."
	icon_state = "orecinnabar"
	grind_results = list(/datum/reagent/mercury = 15)
	sellprice = 5
	item_weight = 6.2

/obj/item/ore/coal/charcoal
	name = "charcoal"
	icon_state = "oreada"
	desc = "Burnt lumps of wood."
	dropshrink = 0.8
	color = "#929292"
	firefuel = 30 MINUTES
	smeltresult = /obj/item/ore/coal/charcoal
	sellprice = 1

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
	var/datum/anvil_recipe/currecipe

/obj/item/ingot/examine()
	. += ..()
	if(currecipe)
		. += span_warning("It is currently being worked on to become [currecipe.get_display_name()].")

/obj/item/ingot/Initialize(mapload, smelt_quality)
	. = ..()
	if(smelt_quality)
		recipe_quality = smelt_quality
		smelted = TRUE
	var/datum/quality_calculator/metallurgy/metal_calc = new()
	metal_calc.apply_smelt_to_ingot(src, recipe_quality, TRUE)
	qdel(metal_calc)

/obj/item/ingot/attackby(obj/item/I, mob/user, list/modifiers)
	if(!istype(I, /obj/item/weapon/tongs))
		return ..()
	var/obj/item/weapon/tongs/T = I
	if(!T.held_item)
		if(item_flags & IN_STORAGE)
			if(!SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE))
				return ..()
		forceMove(T)
		T.held_item = src
		T.hott = null
		T.update_appearance(UPDATE_ICON_STATE)

/obj/item/ingot/attack_hand_secondary(mob/user, list/modifiers)
	if(currecipe)
		to_chat(user, span_notice("You begin canceling the recipe of [currecipe.get_display_name()]."))
		if(do_after(user, 5 SECONDS, src, display_over_user = TRUE))
			currecipe = null
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	. = ..()

/obj/item/ingot/Destroy()
	if(currecipe)
		QDEL_NULL(currecipe)
	if(istype(loc, /obj/machinery/anvil))
		var/obj/machinery/anvil/A = loc
		A.hingot = null
		A.update_appearance(UPDATE_OVERLAYS)
	return ..()

/obj/item/ingot/gold
	name = "gold bar"
	desc = "A bar of glittering gold."
	icon_state = "ingotgold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 100
	melting_material = /datum/material/gold
	item_weight = 7.5 * GOLD_MULITPLIER

/obj/item/ingot/iron
	name = "iron bar"
	desc = "A bar of wrought iron."
	icon_state = "ingotiron"
	smeltresult = /obj/item/ingot/iron
	sellprice = 25
	melting_material = /datum/material/iron
	item_weight = 7.5 * IRON_MULTIPLIER

/obj/item/ingot/thaumic
	name = "thaumic iron bar"
	desc = "A bar of wrought iron tempered with fire essence."
	icon_state = "infused_iron"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	smeltresult = /obj/item/ingot/thaumic
	sellprice = 25
	melting_material = /datum/material/thaumic_iron
	item_weight = 7.5 * IRON_MULTIPLIER

/obj/item/ingot/copper
	name = "copper bar"
	desc = "A bar of copper."
	icon_state = "ingotcop"
	smeltresult = /obj/item/ingot/copper
	sellprice = 10
	melting_material = /datum/material/copper
	item_weight = 7.5 * COPPER_MULTIPLIER

/obj/item/ingot/tin
	name = "tin bar"
	desc = "An ingot of strangely soft and malleable essence."
	icon_state = "ingottin"
	smeltresult = /obj/item/ingot/tin
	sellprice = 15
	melting_material = /datum/material/tin
	item_weight = 7.5 * TIN_MULTIPLIER

/obj/item/ingot/bronze
	name = "bronze bar"
	desc = "A hard and durable alloy favored by engineers and followers of Malum alike."
	icon_state = "ingotbronze"
	smeltresult = /obj/item/ingot/bronze
	sellprice = 30
	melting_material = /datum/material/bronze
	item_weight = 7.5 * BRONZE_MULTIPLIER

/obj/item/ingot/silver
	name = "silver bar"
	desc = "A bar of glistening silver. The bane of nitewalkers."
	icon_state = "ingotsilv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 60
	melting_material = /datum/material/silver
	item_weight = 7.5 * SILVER_MULTIPLIER

/obj/item/ingot/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/ingot/steel
	name = "steel bar"
	desc = "A bar of alloyed steel."
	icon_state = "ingotsteel"
	smeltresult = /obj/item/ingot/steel
	sellprice = 40
	melting_material = /datum/material/steel
	item_weight = 7.5 * STEEL_MULTIPLIER

/obj/item/ingot/steelholy/
	name = "holy steel bar"
	desc = "This ingot of steel has been touched by Malum. It radiates heat, even when outside a forge."
	icon_state = "ingotsteelholy"
	melting_material = /datum/material/steel //Smelting it removes the blessing
	sellprice = 20

/obj/item/ingot/silverblessed/
	name = "blessed silver bar"
	desc = "This bar radiates a divine purity. Treasured by the realms and commonly found in Psydonic weaponry."
	icon_state = "ingotsilvblessed"
	melting_material = /datum/material/silver
	sellprice = 100

/obj/item/ingot/silverblessed/bullion
	name = "blessed silver bullion"
	desc = "This bar radiates a divine purity. The Psycross and the words cast into the surface denotes the Oratorium Throni Vacui as the point of its origin."
	icon_state = "ingotsilvblessed_psy"
	melting_material = /datum/material/silver
	sellprice = 100


/obj/item/ingot/blacksteel
	name = "blacksteel bar"
	desc = "Sacrificing the holy elements of silver for raw strength, this strange and powerful ingot's origin carries dark rumors..."
	icon_state = "ingotblacksteel"
	smeltresult = /obj/item/ingot/blacksteel
	sellprice = 90
	melting_material = /datum/material/blacksteel
	item_weight = 7.5 * BLACKSTEEL_MULTIPLIER

/obj/item/ingot/steel_slag
	name = "steel slag"
	desc = "Slag containing steel, the result of blooming iron and coal."
	icon_state = "steel_slag"
	smeltresult = /obj/item/ingot/steel_slag
	sellprice = 90
	melting_material = /datum/material/steel
	item_weight = 7.5 * STEEL_MULTIPLIER
