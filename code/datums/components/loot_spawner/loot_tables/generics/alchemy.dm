/datum/loot_table/potion_vitals
	name = "generic vital potions"
	loot_table = list(
		/obj/item/reagent_containers/glass/bottle/healthpot = 10,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 5,
		/obj/item/reagent_containers/glass/bottle/manapot = 10,
		/obj/item/reagent_containers/glass/bottle/strongmanapot = 5,
		/obj/item/reagent_containers/glass/bottle/stampot = 10,
		/obj/item/reagent_containers/glass/bottle/strongstampot = 5
	)

/datum/loot_table/potion_poisons
	name = "generic poisons"
	loot_table = list(
		/obj/item/reagent_containers/glass/bottle/poison = 10,
		/obj/item/reagent_containers/glass/bottle/strongpoison = 5,
		/obj/item/reagent_containers/glass/bottle/stampoison = 10,
		/obj/item/reagent_containers/glass/bottle/strongstampoison = 5,
		/obj/item/reagent_containers/glass/bottle/stampot = 10,
		/obj/item/reagent_containers/glass/bottle/strongstampot = 5
	)

/datum/loot_table/potion_ingredient
	var/static/list/all_potion_ings = list()
	loot_table = list()

/datum/loot_table/potion_ingredient/New()
	if(!all_potion_ings.len)
		all_potion_ings = subtypesof(/obj/item/alch)
	if(!loot_table.len)
		var/list/ingredient_list = list()
		for(var/ingredient in all_potion_ings)
			ingredient_list[ingredient] = 1
		loot_table = ingredient_list
	..()

/datum/loot_table/potion_ingredient/herb
	name = "generic herbs"
	loot_table = list(
		/obj/item/alch/herb/atropa = 5,
		/obj/item/alch/herb/matricaria = 5,
		/obj/item/alch/herb/symphitum = 5,
		/obj/item/alch/herb/taraxacum = 5,
		/obj/item/alch/herb/euphrasia = 5,
		/obj/item/alch/herb/paris = 5,
		/obj/item/alch/herb/calendula = 5,
		/obj/item/alch/herb/mentha = 5,
		/obj/item/alch/herb/urtica = 5,
		/obj/item/alch/herb/salvia = 5,
		/obj/item/alch/herb/hypericum = 5,
		/obj/item/alch/herb/benedictus = 5,
		/obj/item/alch/herb/valeriana = 5,
		/obj/item/alch/herb/artemisia = 5,
		/obj/item/alch/herb/rosa = 5,
		/obj/item/alch/herb/euphorbia = 5
	)

/datum/loot_table/potion_stats
	name = "generic stat potions"
	loot_table = list(
			/obj/item/reagent_containers/glass/bottle/vial/strpot = 10,
			/obj/item/reagent_containers/glass/bottle/vial/perpot = 10,
			/obj/item/reagent_containers/glass/bottle/vial/endpot = 10,
			/obj/item/reagent_containers/glass/bottle/vial/conpot = 10,
			/obj/item/reagent_containers/glass/bottle/vial/intpot = 10,
			/obj/item/reagent_containers/glass/bottle/vial/spdpot = 10,
			/obj/item/reagent_containers/glass/bottle/vial/lucpot = 10
	)

/datum/loot_table/potion_skills
	name = "skill elixirs"
	loot_table = list(
			/obj/item/reagent_containers/glass/bottle/vial/bladeart = 10,
			/obj/item/reagent_containers/glass/bottle/vial/heavy_arms = 10,
			/obj/item/reagent_containers/glass/bottle/vial/whip_hand = 10,
			/obj/item/reagent_containers/glass/bottle/vial/marksmans_eye = 10,
			/obj/item/reagent_containers/glass/bottle/vial/shield_bearer = 10,
			/obj/item/reagent_containers/glass/bottle/vial/craftsmans_wit = 10,
			/obj/item/reagent_containers/glass/bottle/vial/smelters_patience = 10,
			/obj/item/reagent_containers/glass/bottle/vial/builders_draught = 10,
			/obj/item/reagent_containers/glass/bottle/vial/trappers_sense = 10,
			/obj/item/reagent_containers/glass/bottle/vial/alchemists_clarity = 10,
			/obj/item/reagent_containers/glass/bottle/vial/smiths_blood = 10,
			/obj/item/reagent_containers/glass/bottle/vial/skinners_elixir = 10,

			/obj/item/reagent_containers/glass/bottle/vial/locksmiths_oil = 10,
			/obj/item/reagent_containers/glass/bottle/vial/cooks_brine = 10,
			/obj/item/reagent_containers/glass/bottle/vial/prep_hands_tonic = 10,
			/obj/item/reagent_containers/glass/bottle/vial/brewers_wort = 10,
			/obj/item/reagent_containers/glass/bottle/vial/seamstress_thimble_drop = 10,
			/obj/item/reagent_containers/glass/bottle/vial/miners_heart = 10,
			/obj/item/reagent_containers/glass/bottle/vial/farmers_almanac = 10,
			/obj/item/reagent_containers/glass/bottle/vial/beastwhisper = 10,

			/obj/item/reagent_containers/glass/bottle/vial/miracle_water = 10,
			/obj/item/reagent_containers/glass/bottle/vial/vital_ichor = 10,
			/obj/item/reagent_containers/glass/bottle/vial/arcane_solvent = 10,
			/obj/item/reagent_containers/glass/bottle/vial/wild_draught = 10,

			/obj/item/reagent_containers/glass/bottle/vial/athletes_brine = 10,
			/obj/item/reagent_containers/glass/bottle/vial/shadow_tonic = 10,
			/obj/item/reagent_containers/glass/bottle/vial/scholars_ink = 10
	)
