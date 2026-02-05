
/datum/world_faction/zalad_traders
	faction_name = "Zalad"
	desc = "Nomadic traders from the harsh desert regions"
	faction_color = "#D2691E"
	trader_type_weights = list(
		/datum/trader_data/exotic_merchant = 15,
		/datum/trader_data/artifact_weapons = 1,
		/datum/trader_data/seed_merchant = 18,
		/datum/trader_data/alchemist = 25,
		/datum/trader_data/clothing_merchant = 20,
		/datum/trader_data/material_merchant = 12,
		/datum/trader_data/medicine_merchant = 8,
		/datum/trader_data/food_merchant = 5,
		/datum/trader_data/livestock_merchant = 7,
		/datum/trader_data/weapon_merchant = 5,
		/datum/trader_data/tool_merchant = 10,
	)
	essential_packs = list(
		/datum/supply_pack/storage/backpack,
		/datum/supply_pack/storage/satchel,
		/datum/supply_pack/storage/pouch,
		/datum/supply_pack/tools/rope,
		/datum/supply_pack/food/drinks/water,
		/datum/supply_pack/food/hardtack,
		/datum/supply_pack/apparel/leather_belt,
		/datum/supply_pack/rawmats/silk,
		/datum/supply_pack/storage/sack
	)
	common_pool = list(
		// Light armor for desert travel
		/datum/supply_pack/armor/light/imask,
		/datum/supply_pack/armor/steel/smask,
		// Apparel suited for desert nomads
		/datum/supply_pack/apparel/headband,
		/datum/supply_pack/apparel/sandals,
		/datum/supply_pack/apparel/undershirt_random,
		/datum/supply_pack/apparel/tights_random,
		/datum/supply_pack/apparel/simpleshoes,
		/datum/supply_pack/apparel/shortshirt_random,
		/datum/supply_pack/apparel/tunic_random,
		/datum/supply_pack/apparel/skirt,
		/datum/supply_pack/apparel/shalal,
		/datum/supply_pack/apparel/keffiyeh,
		// Food essentials
		/datum/supply_pack/food/meat,
		/datum/supply_pack/food/cheese,
		/datum/supply_pack/food/pepper,
		/datum/supply_pack/food/honey,
		/datum/supply_pack/luxury/premiun_cutlery,
		/datum/supply_pack/food/saltseeds,
		// Tools for survival
		/datum/supply_pack/tools/candles,
		/datum/supply_pack/tools/flint,
		/datum/supply_pack/tools/bottle,
		/datum/supply_pack/tools/needle,
		/datum/supply_pack/tools/scroll,
		/datum/supply_pack/tools/parchment,
		/datum/supply_pack/tools/sleepingbag,
		/datum/supply_pack/tools/keyrings,
		// Materials
		/datum/supply_pack/rawmats/cloth,
		// Seeds for cultivation
		/datum/supply_pack/seeds/onion,
		/datum/supply_pack/seeds/potato,
		/datum/supply_pack/seeds/spelt,
		/datum/supply_pack/seeds/cabbage,
		/datum/supply_pack/seeds/turnip,
		/datum/supply_pack/luxury/spectacles_onyxa,
		/datum/supply_pack/jewelry/nosegold,
		/datum/supply_pack/apparel/engineering_goggles,
		/datum/supply_pack/apparel/hatblu
	)
	uncommon_pool = list(
		// Better armor
		/datum/supply_pack/armor/light/splint,
		/datum/supply_pack/armor/light/haukberk,
		// Apparel
		/datum/supply_pack/apparel/raincloak_random,
		/datum/supply_pack/apparel/leather_gloves,
		/datum/supply_pack/apparel/black_leather_belt,
		/datum/supply_pack/apparel/raincloak_furcloak_brown,
		/datum/supply_pack/apparel/dress_gen_random,
		/datum/supply_pack/armor/light/lightleather_armor,
		/datum/supply_pack/apparel/poncho,
		/datum/supply_pack/apparel/dress_pretty,
		/datum/supply_pack/apparel/ladycloth,
		/datum/supply_pack/apparel/clothcoif,
		/datum/supply_pack/apparel/banditcloth,
		/datum/supply_pack/apparel/watch_boots,
		/datum/supply_pack/apparel/desertcloak,
		// Weapons
		/datum/supply_pack/weapons/iron/ijile,
		/datum/supply_pack/weapons/iron/ikukri,
		/datum/supply_pack/weapons/steel/kaskara,
		/datum/supply_pack/weapons/ranged/whip,
		/datum/supply_pack/weapons/steel/irumi,
		/datum/supply_pack/weapons/iron/ikhopesh,
		// Food & Drink
		/datum/supply_pack/food/drinks/beer,
		/datum/supply_pack/food/drinks/onin,
		/datum/supply_pack/food/jelly1,
		/datum/supply_pack/food/jelly2,
		/datum/supply_pack/food/jelly3,
		/datum/supply_pack/food/jelly4,
		/datum/supply_pack/food/jelly5,
		/datum/supply_pack/food/redtallow,
		/datum/supply_pack/food/tallow,
		// Tools
		/datum/supply_pack/tools/lamptern,
		/datum/supply_pack/tools/dyebin,
		/datum/supply_pack/tools/lockpicks,
		// Materials & Seeds
		/datum/supply_pack/rawmats/feather,
		/datum/supply_pack/seeds/berry,
		/datum/supply_pack/seeds/weed,
		/datum/supply_pack/seeds/sleaf,
		// Instruments
		/datum/supply_pack/instruments/drum,
		/datum/supply_pack/instruments/lute,
		// Narcotics/Trade goods
		/datum/supply_pack/narcotics/sigs,
		/datum/supply_pack/narcotics/zigbox,
		/datum/supply_pack/narcotics/soap
	)
	rare_pool = list(
		// Apparel
		/datum/supply_pack/apparel/silkdress_random,
		/datum/supply_pack/apparel/shepherd,
		/datum/supply_pack/apparel/robe,
		/datum/supply_pack/apparel/armordress,
		/datum/supply_pack/armor/light/studleather,
		/datum/supply_pack/armor/light/lakkariancap,
		/datum/supply_pack/armor/light/lakkarianarmor,
		/datum/supply_pack/armor/light/stepperobes,
		/datum/supply_pack/armor/light/steppehidearmor,
		/datum/supply_pack/armor/steel/steppehelm,
		/datum/supply_pack/armor/steel/steppemask,
		/datum/supply_pack/armor/steel/beastmask,
		/datum/supply_pack/armor/steel/slamellar,
		/datum/supply_pack/armor/steel/zplatehelm,
		/datum/supply_pack/armor/steel/zsallet,
		/datum/supply_pack/armor/steel/zplatearmor,
		/datum/supply_pack/armor/steel/zplategloves,
		/datum/supply_pack/armor/steel/zplateboots,
		// Weapons
		/datum/supply_pack/weapons/iron/iassegai,
		/datum/supply_pack/weapons/ranged/shortbow,
		/datum/supply_pack/weapons/ranged/bow,
		/datum/supply_pack/weapons/steel/atgervi,
		/datum/supply_pack/weapons/ranged/crossbow,
		/datum/supply_pack/weapons/ammo/quivers,
		/datum/supply_pack/weapons/ammo/arrowquiver,
		/datum/supply_pack/weapons/shield/wood,
		/datum/supply_pack/weapons/ammo/Blowpouch,
		/datum/supply_pack/weapons/steel/khopesh,
		/datum/supply_pack/weapons/steel/steppesabre,
		// Food
		/datum/supply_pack/food/drinks/spottedhen,
		/datum/supply_pack/food/roastedcoffee,
		// Materials
			// Seeds
		/datum/supply_pack/seeds/sunflowers,
		/datum/supply_pack/seeds/plum,
		/datum/supply_pack/seeds/strawberry,
		// Narcotics
		/datum/supply_pack/narcotics/ozium,
		/datum/supply_pack/narcotics/poison
	)
	exotic_pool = list(
		/datum/supply_pack/apparel/silkcoat,
		/datum/supply_pack/apparel/menacing,
		/datum/supply_pack/apparel/bardhat,
		/datum/supply_pack/jewelry/silverring,
		/datum/supply_pack/food/chocolate,
		/datum/supply_pack/narcotics/spice,
		/datum/supply_pack/narcotics/spoison,
		/datum/supply_pack/seeds/sugarcane,
		/datum/supply_pack/jewelry/diademgold,
		/datum/supply_pack/narcotics/zigboxempt,
		/datum/supply_pack/jewelry/headdressgold,
		/datum/supply_pack/jewelry/psycross,
		/datum/supply_pack/jewelry/bglasses,
		/datum/supply_pack/jewelry/gmask,
		/datum/supply_pack/apparel/exoticsilkbelt,
		/datum/supply_pack/apparel/exoticsilkmask,
		/datum/supply_pack/apparel/exoticsilkbra,
		/datum/supply_pack/apparel/anklets,
		/datum/supply_pack/jewelry/nyle,
		/datum/supply_pack/jewelry/scom
	)

/datum/world_faction/zalad_traders/initialize_faction_stock()
	..()
	hard_value_multipliers[/obj/item/reagent_containers/food] = 1.3
	hard_value_multipliers[/obj/item/clothing/armor] = 1.2
