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

/obj/item/ore/cursedrosa/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(!istype(tool, /obj/item/weapon/knife))
		return NONE

	var/datum/component/thorns = GetComponent(/datum/component/cursedrosa)
	if(QDELETED(thorns))
		to_chat(user, span_warning("It has no thorns to trim."))
	else
		user.visible_message(span_notice("[user] trims the thorns from [src]."), span_notice("I trim the thorns from [src]."))
		playsound(tool, 'sound/items/flint.ogg', 100, TRUE)
		qdel(thorns)

	return ITEM_INTERACT_SUCCESS

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
	sellprice = M_GOLD
	item_weight = 12.25 KILOGRAMS

/obj/item/ingot/iron
	name = "iron bar"
	desc = "A bar of wrought iron."
	icon_state = "ingotiron"
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	sellprice = M_IRON
	item_weight = 5 KILOGRAMS

/obj/item/ingot/thaumic
	name = "thaumic iron bar"
	desc = "A bar of wrought iron tempered with fire essence."
	icon_state = "infused_iron"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	smeltresult = /obj/item/ingot/thaumic
	melting_material = /datum/material/thaumic_iron
	sellprice = M_IRON
	item_weight = 5 KILOGRAMS

/obj/item/ingot/copper
	name = "copper bar"
	desc = "A bar of copper."
	icon_state = "ingotcop"
	smeltresult = /obj/item/ingot/copper
	melting_material = /datum/material/copper
	sellprice = M_IRON * 0.5
	item_weight = 5.7 KILOGRAMS

/obj/item/ingot/tin
	name = "tin bar"
	desc = "An ingot of strangely soft and malleable essence."
	icon_state = "ingottin"
	smeltresult = /obj/item/ingot/tin
	melting_material = /datum/material/tin
	sellprice = M_IRON * 0.75
	item_weight = 4.6 KILOGRAMS

/obj/item/ingot/bronze
	name = "bronze bar"
	desc = "A hard and durable alloy favored by engineers and followers of Malum alike."
	icon_state = "ingotbronze"
	smeltresult = /obj/item/ingot/bronze
	melting_material = /datum/material/bronze
	sellprice = M_IRON * 2
	item_weight = 5.55 KILOGRAMS

/obj/item/ingot/silver
	name = "silver bar"
	desc = "A bar of glistening silver. The bane of nitewalkers."
	icon_state = "ingotsilv"
	smeltresult = /obj/item/ingot/silver
	melting_material = /datum/material/silver
	sellprice = M_SILVER
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
	sellprice = M_STEEL
	item_weight = 5 KILOGRAMS

/obj/item/ingot/steelholy
	name = "holy steel bar"
	desc = "This ingot of steel has been touched by Malum. It radiates heat, even when outside a forge."
	icon_state = "ingotsteelholy"
	smeltresult = /obj/item/ingot/steel
	melting_material = /datum/material/steel //Smelting it removes the blessing
	sellprice = M_STEEL * 1.5
	item_weight = 5 KILOGRAMS

/obj/item/ingot/silverblessed
	name = "blessed silver bar"
	desc = "This bar radiates a divine purity that is treasured by the Psydonic faith. The Psycross and holy liturgies are transcribed on the surface."
	icon_state = "ingotsilvblessed"
	smeltresult = /obj/item/ingot/silver
	melting_material = /datum/material/silver //Smelting it removes the blessing
	sellprice = M_SILVER * 1.5
	item_weight = 6.65 KILOGRAMS

/obj/item/ingot/blacksteel
	name = "blacksteel bar"
	desc = "Sacrificing the holy elements of silver for raw strength, this strange and powerful ingot's origin carries dark rumors..."
	icon_state = "ingotblacksteel"
	sellprice = M_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	melting_material = /datum/material/blacksteel
	item_weight = 5.2 KILOGRAMS

/obj/item/ingot/steel_slag
	name = "steel slag"
	desc = "Slag containing steel, the result of blooming iron and coal."
	icon_state = "steel_slag"
	smeltresult = /obj/item/ingot/steel
	melting_material = /datum/material/steel
	sellprice = M_STEEL - 5
	item_weight = 5.5 KILOGRAMS

/obj/item/ingot/aalloy
	name = "decrepit ingot"
	desc = "A decrepit slab of wrought bronze, uncomfortably cold to the touch. The gales shift into whispers, when held for long enough; 'progress commands sacrifice'."
	icon_state = "ingotancient"
	smeltresult = /obj/item/ingot/aaslag
	melting_material = /datum/material/ancient_alloy
	color = "#bb9696"
	sellprice = 33
	item_weight = 5.5 KILOGRAMS

/obj/item/ingot/purifiedaalloy
	name = "ancient alloy"
	desc = "An ingot of polished gilbranze, teeming with forbidden knowledge. The reflection on its surface isn't yours; it smiles back at you with eternal malice."
	icon_state = "ingotancient"
	smeltresult = /obj/item/ingot/purifiedaalloy
	melting_material = /datum/material/purified_alloy
	sellprice = 111
	item_weight = 5.5 KILOGRAMS

/obj/item/ingot/aaslag
	name = "glimmering slag"
	desc = "A mass of wrought bronze, rendered lame from the forge's heat. Sometimes, dead is better. </br>Yet, perhaps alloying it in equal parts with another glimmering piece of ore could resurrect its secrets."
	icon_state = "ancientslag"
	smeltresult = /obj/item/ingot/aaslag
	melting_material = /datum/material/glimmering_slag
	sellprice = 6
	item_weight = 6.15 KILOGRAMS

/obj/item/ingot/aaslag/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#FF4500", "alpha" = 50, "size" = 1))

//Anomalous Smeltings
/obj/item/ingot/weeping
	name = "enduring ingot"
	desc = "A slab of metal, aged and bare. You finally know what it is, yet no word can be sired to describe it. </br>'..none will ever know the greatest truths; of Aeon's grasp, of Adonai's presence, of Psydon's fate..' </br>'..but, perhaps, that's for the better. The malaise is gone, but the evils of this world are still very real..' </br>'..find a way to give the remains a new life; a new vessel that may yet make the followers of evil weep..'"
	icon_state = "ingotsilv"
	smeltresult = /obj/item/ingot/weeping
	melting_material = /datum/material/weeping
	color = "#CECA9C"
	sellprice = 222
	item_weight = 6.65 KILOGRAMS

/obj/item/ingot/weeping/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#8B0000", "alpha" = 100, "size" = 1))

/obj/item/ingot/draconic
	name = "draconic ingot"
	desc = "A slab of obsidian, crackling with energy. Your fingers blister from the sheer heat, radiating off of its glassy surface. </br>'..no man, be-they a saint or sinner, can truly withstand such power..' </br>'..but, perhaps, you are different..' </br>'..find a way to give the remains a new life; a new vessel that may yet make the followers of evil weep..'"
	icon_state = "ingotblacksteel"
	smeltresult = /obj/item/ingot/draconic
	melting_material = /datum/material/draconic
	color = "#70b8ff"
	sellprice = 333
	item_weight = 5.5 KILOGRAMS

/obj/item/ingot/draconic/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#FF4500", "alpha" = 100, "size" = 1))

/obj/item/ingot/avantyne
	name = "avantyne wafer"
	desc = "This ingot, though borne of unholy circumstance, rumbles with otherworldly potential. Chiseled onto the darksteel is a forbidden iteration of the psycross; a foreboding sign for those who bow to lesser gods."
	icon_state = "ingotavantyne"
	smeltresult = null
	sellprice = 130
	smeltresult = /obj/item/ingot/avantyne
	melting_material = /datum/material/avantyne

/obj/item/ingot/ketryl
	name = "ketryl ingot"
	desc = "Named after its mythical status, this ingot is forged as per the dwarven standards etched in a small imprint on the ingot's surface. Ketryl is often folded in thin layers, stronger than steel, yet unusually light at the same time."
	icon_state = "ingotketryl"
	smeltresult = null
	sellprice = 555
	smeltresult = /obj/item/ingot/ketryl
	melting_material = /datum/material/ketryl

/obj/item/ingot/lithmyc
	name = "lithmyc ingot"
	desc = "A strange green ingot. It seems to be covered in an oily metal-liquid, though it refuses to leave the ingot-shape no matter how you much you try. No one in the region yet knows what the metal can be shaped into, as it's exceedingly stubborn. But, it sure seems priceless."
	icon_state = "ingotlithmyc"
	smeltresult = /obj/item/ingot/lithmyc
	melting_material = /datum/material/lithmyc
	sellprice = 444

/obj/item/ingot/lithmyc/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#A0E65C", "alpha" = 100, "size" = 1))


/obj/item/ingot/component //Root. Don't use under most circumstances.
	name = "substanceless presence"
	desc = "Something that you were likely never meant to see. Pray to a higher presence for assistance, before rendering it asunder in the forge's flames once more."
	icon_state = "oreada"
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron
	sellprice = 1

/obj/item/ingot/component/glutcrystal
	name = "crystalline glut"
	desc = "Fractal violence, gleaming with a crimson haze that beckons for its final purpose to be accomplished."
	icon_state = "component_blood"
	smeltresult = /obj/item/gem/blood_diamond //Ensures that it can be reused for any Glut-specific ritual, should one find this in its crystalline form.
	sellprice = 33

/obj/item/ingot/component/glutcrystal/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/graggar)
			. += span_danger("You know this gem well. They are born out of great violence, but only if it involves the mightiest of warriors. </br>Fleshcrafting it with the meat of whatever warrior birthed this gem will allow me to summon another of their kind into this world.  </br>Melting away its crystalline shell is ideal, if you wish to ensure no chance for error while conducting such a ritual.")

/obj/item/ingot/component/glutcrystal/Initialize()
	. = ..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = "#8B0000", "alpha" = 120, "size" = 1))

/obj/item/ingot/component/heapofrawiron
	name = "heap of raw iron"
	desc = "A massive hunk, born from the incoherent fusion of molten iron. Chunks of ore-and-ingotry peak out from its jagged surface, yearning to be refined - be it into ingots, or something more purposeful."
	icon_state = "component_berserkheap"
	melting_material = /datum/material/iron
	melt_amount = 300
	sellprice = 44

/obj/item/ingot/component/berserkswordblade
	name = "blade of the berserkers sword"
	desc = "A massive blade, forged from a raw heap of iron. The unique spike-styled tang seems to be longer than what'd be seen on most greatswords, stowable only by the innards of a fittingly large handle."
	icon_state = "component_berserkblade"
	melting_material = /datum/material/iron
	melt_amount = 400
	sellprice = 33

/obj/item/ingot/component/berserkswordgrip
	name = "handle of the berserkers sword"
	desc = "A massive handle, assembled from the double-handed grip of an Executioner's Sword. The unique crescent-styled crossguard seems to have a slot, fittable only by the tang of a fittingly large blade."
	icon_state = "component_berserkhandle"
	sellprice = 33

/obj/item/ingot/component/threadavantyne
	name = "avantyne thread"
	desc = "These strands, though borne of unholy circumstance, shimmer with otherworldly potential. Each wire of darksteel seem to twitch with vigor, whenever brought close to another alloy; like a parasite drawn to a host."
	icon_state = "component_avantynethread"
	sellprice = 66

/obj/item/ingot/component/threadketryl
	name = "ketryl thread"
	desc = "Named after its mythical status, these glimmering strands are stronger than steel, yet unusually light at the same time."
	icon_state = "component_ketrylthread"
	sellprice = 111

/obj/item/ingot/component/zizo
	name = "avantyne fragment"
	desc = "Whispering fragments of an otherworldly alloy. </br>Power always comes at a price."
	icon_state = "component_zizo"
	dropshrink = 0.7

/obj/item/ingot/component/graggar
	name = "vicious fragment"
	desc = "Bleeding fragments of an otherworldly alloy. </br>Murder is nothing more than justice without arbitration."
	icon_state = "component_graggar"
	dropshrink = 0.7

/obj/item/ingot/component/matthios
	name = "gilded fragment"
	desc = "Glimmering fragments of an otherworldly alloy. </br>Wealth drags even the noblest souls down to perdition."
	icon_state = "component_matthios"
	dropshrink = 0.7

/obj/item/ingot/component/baotha
	name = "saccharine fragment"
	desc = "Aromatic fragments of an otherworldly alloy. </br>Despair is the gravest, most agonizing poison of them all."
	icon_state = "component_baotha"
	dropshrink = 0.7
