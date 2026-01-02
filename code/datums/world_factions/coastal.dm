/obj/effect/mob_spawn/human/demi
	mob_species = /datum/species/demihuman

/obj/effect/mob_spawn/human/demi/trader
	outfit = /datum/outfit/bard

/obj/effect/mob_spawn/human/elf
	mob_species = /datum/species/elf/snow

/obj/effect/mob_spawn/human/elf/trader
	outfit = /datum/outfit/bard

/datum/world_faction/coastal_merchants
	faction_name = "Coastal Trade Union"
	desc = "Seafaring traders with exotic wares"
	faction_color = "#4682B4"
	trader_outfits = list(
		/obj/effect/mob_spawn/human/demi/trader,
		/obj/effect/mob_spawn/human/elf/trader
	)
	trader_type_weights = list(
		/datum/trader_data/sake_merchant = 4,
		/datum/trader_data/eastern_weapons = 4,
		/datum/trader_data/artifact_weapons = 1,
		/datum/trader_data/luxury_merchant = 25,
		/datum/trader_data/instrument_merchant = 20,
		/datum/trader_data/food_merchant = 20,
		/datum/trader_data/book_merchant = 15,
		/datum/trader_data/alchemist = 15,
		/datum/trader_data/livestock_merchant = 12,
		/datum/trader_data/clothing_merchant = 10,
		/datum/trader_data/material_merchant = 8,
		/datum/trader_data/medicine_merchant = 8,
		/datum/trader_data/exotic_merchant = 7,
		/datum/trader_data/seed_merchant = 5,
		/datum/trader_data/tool_merchant = 5,
		/datum/trader_data/weapon_merchant = 3,
	)
	essential_packs = list(
		/datum/supply_pack/tools/fishingrod,
		/datum/supply_pack/tools/bait,
		/datum/supply_pack/food/eel,
		/datum/supply_pack/apparel/undershirt_sailor,
		/datum/supply_pack/apparel/tights_sailor
	)
	common_pool = list(
		// Apparel suited for coastal life
		/datum/supply_pack/apparel/strawhat,
		/datum/supply_pack/apparel/undershirt_sailor_red,
		/datum/supply_pack/apparel/gladiator_sandals,
		/datum/supply_pack/apparel/hood,
		/datum/supply_pack/apparel/gambeson,
		/datum/supply_pack/apparel/arming,
		/datum/supply_pack/apparel/boots,
		/datum/supply_pack/apparel/shortboots,
		/datum/supply_pack/apparel/fingerless_gloves,
		/datum/supply_pack/apparel/tricorn,
		/datum/supply_pack/apparel/sailorcoat,
		// Seafood and coastal cuisine
		/datum/supply_pack/food/carp,
		/datum/supply_pack/food/drinks/beer,
		/datum/supply_pack/food/drinks/elfbeer,
		/datum/supply_pack/food/drinks/elfcab,
		/datum/supply_pack/food/drinks/tealeaves,
		/datum/supply_pack/food/driedtangerine,
		/datum/supply_pack/food/driedplum,
		/datum/supply_pack/food/saltfish,
		// Tools for maritime trade
		/datum/supply_pack/tools/bottle,
		/datum/supply_pack/tools/bottle_kit,
		/datum/supply_pack/tools/alch_bottles,
		/datum/supply_pack/tools/fryingpan,
		/datum/supply_pack/tools/pot,
		/datum/supply_pack/tools/wpipe,
		/datum/supply_pack/tools/fishingline,
		/datum/supply_pack/tools/fishinghook,
		/datum/supply_pack/storage/tray,
		// Materials
		/datum/supply_pack/rawmats/glass,
		/datum/supply_pack/apparel/cheapdyes,
		// Seeds for coastal cultivation
		/datum/supply_pack/seeds/lime,
		/datum/supply_pack/seeds/lemon,
		/datum/supply_pack/seeds/apple,
		/datum/supply_pack/seeds/blackberry,
		/datum/supply_pack/seeds/rasberry,
		/datum/supply_pack/seeds/avocado,
		/datum/supply_pack/seeds/pineapple,
		// Livestock - coastal communities
		/datum/supply_pack/livestock/chicken,
		/datum/supply_pack/livestock/cat
	)
	uncommon_pool = list(
		// Refined apparel
		/datum/supply_pack/apparel/spectacles,
		/datum/supply_pack/apparel/silkdress_random,
		/datum/supply_pack/apparel/tabard,
		/datum/supply_pack/apparel/halfcloak_random,
		/datum/supply_pack/apparel/magedyes,
		/datum/supply_pack/apparel/grenzelhat,
		/datum/supply_pack/apparel/grenzel_gloves,
		/datum/supply_pack/apparel/grenzel_trousers,
		/datum/supply_pack/apparel/grenzel_shirt,
		/datum/supply_pack/apparel/buckle_boots,
		/datum/supply_pack/apparel/Puritan_shirt,
		/datum/supply_pack/apparel/otavan_boots,
		/datum/supply_pack/apparel/otavan_gloves,
		/datum/supply_pack/apparel/leathercollar,
		/datum/supply_pack/apparel/thigh_boots,
		/datum/supply_pack/apparel/black_gloves,
		/datum/supply_pack/apparel/fancy_hat,
		/datum/supply_pack/weapons/iron/navaja,
		// Exotic foods
		/datum/supply_pack/food/angler,
		/datum/supply_pack/food/drinks/winezaladin,
		/datum/supply_pack/food/drinks/winegrenzel,
		// Musical instruments - coastal culture
		/datum/supply_pack/instruments/flute,
		/datum/supply_pack/instruments/harp,
		/datum/supply_pack/instruments/guitar,
		/datum/supply_pack/instruments/accord,
		/datum/supply_pack/instruments/hurdygurdy,
		/datum/supply_pack/instruments/viola,
		// Trade goods
		/datum/supply_pack/narcotics/perfume,
		/datum/supply_pack/jewelry/scom,
		// Seeds
		/datum/supply_pack/seeds/tangerine,
		/datum/supply_pack/seeds/mango,
		// Livestock - more valuable
		/datum/supply_pack/livestock/saiga,
		/datum/supply_pack/livestock/cow,
		/datum/supply_pack/livestock/goat,
		/datum/supply_pack/livestock/pig,
		// Medical supplies
		/datum/supply_pack/tools/medical/surgerybag,
		/datum/supply_pack/tools/medical/prarml,
		/datum/supply_pack/tools/medical/prarmr,
		/datum/supply_pack/tools/medical/prlegl,
		/datum/supply_pack/tools/medical/prlegr,
		/datum/supply_pack/tools/medical/health,
		/datum/supply_pack/tools/medical/mana
	)
	rare_pool = list(
		// Luxury apparel
		/datum/supply_pack/apparel/luxurydyes,
		/datum/supply_pack/apparel/fancyhat,
		/datum/supply_pack/apparel/hennin,
		/datum/supply_pack/apparel/chaperon,
		/datum/supply_pack/apparel/eastern1_gloves,
		/datum/supply_pack/apparel/east2_trousers,
		/datum/supply_pack/apparel/east1_trousers,
		/datum/supply_pack/apparel/easternhat,
		/datum/supply_pack/apparel/easterncloak,
		/datum/supply_pack/apparel/easternjacket,
		/datum/supply_pack/apparel/easterncoat,
		/datum/supply_pack/apparel/east1_shirt,
		/datum/supply_pack/apparel/east2_shirt,
		/datum/supply_pack/apparel/mentorcoat,
		/datum/supply_pack/apparel/craftcoat,
		/datum/supply_pack/apparel/kitsunemask,
		/datum/supply_pack/apparel/onimask,
		/datum/supply_pack/jewelry/mercatoreye,
		// Exotic seafood
		/datum/supply_pack/food/clownfish,
		/datum/supply_pack/food/drinks/winevalorred,
		/datum/supply_pack/food/drinks/winevalorwhite,
		/datum/supply_pack/food/drinks/black1,
		/datum/supply_pack/food/drinks/black2,
		/datum/supply_pack/food/drinks/black3,
		/datum/supply_pack/food/drinks/black4,
		/datum/supply_pack/food/drinks/black5,
		/datum/supply_pack/food/drinks/black6,
		/datum/supply_pack/food/drinks/black7,
		/datum/supply_pack/food/drinks/black8,
		// Weapons - refined coastal arms
		/datum/supply_pack/weapons/ranged/longbow,
		/datum/supply_pack/weapons/ranged/shortbow,
		/datum/supply_pack/weapons/ammo/boltquiver,
		/datum/supply_pack/weapons/ammo/arrows,
		/datum/supply_pack/weapons/ammo/bolts,
		/datum/supply_pack/weapons/ranged/bomb,
		/datum/supply_pack/weapons/ranged/tossbladeiron,
		/datum/supply_pack/weapons/ammo/Blowpouchp,
		/datum/supply_pack/weapons/iron/idadao,
		/datum/supply_pack/weapons/steel/aruval,
		/datum/supply_pack/weapons/steel/jile,
		/datum/supply_pack/weapons/steel/shishpar,
		/datum/supply_pack/weapons/steel/assegai,
		/datum/supply_pack/weapons/steel/sengese,
		/datum/supply_pack/weapons/steel/dadao,
		/datum/supply_pack/weapons/steel/scutlass,
		/datum/supply_pack/weapons/steel/mulyeog,
		/datum/supply_pack/weapons/steel/nimcha,
		// Jewelry
		/datum/supply_pack/jewelry/silverring,
		// Luxury goods
		/datum/supply_pack/luxury/spectacles_golden,
		/datum/supply_pack/luxury/spectacles_monocle,
		// Seeds
		/datum/supply_pack/seeds/pear,
		/datum/supply_pack/seeds/mangosteen,
		/datum/supply_pack/seeds/dragonfruit,
		/datum/supply_pack/seeds/poppy
	)
	exotic_pool = list(
		/datum/supply_pack/food/drinks/elfred,
		/datum/supply_pack/food/drinks/elfblue,
		/datum/supply_pack/food/chocolate,
		/datum/supply_pack/jewelry/goldring,
		/datum/supply_pack/jewelry/gemcirclet,
		/datum/supply_pack/luxury/glassware_set,
		/datum/supply_pack/apparel/royaldyes,
		/datum/supply_pack/narcotics/moondust,
		/datum/supply_pack/weapons/ranged/tossbladesteel,
		/datum/supply_pack/luxury/spectacles_inquisitor,
		/datum/supply_pack/weapons/ammo/cannonball,
		/datum/supply_pack/weapons/ammo/fuseparchment,
		/datum/supply_pack/weapons/ranged/cannon,
		/datum/supply_pack/apparel/bellcollar,
		/datum/supply_pack/weapons/ammo/powder
	)

/datum/world_faction/coastal_merchants/initialize_faction_stock()
	..()
	// Coastal merchants prefer luxury items and reagents
	hard_value_multipliers[/obj/item/reagent_containers] = 1.2
	hard_value_multipliers[/obj/item/clothing/ring] = 1.3
