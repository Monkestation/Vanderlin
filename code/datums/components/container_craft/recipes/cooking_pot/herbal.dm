/datum/container_craft/cooking/herbal_tea
	abstract_type = /datum/container_craft/cooking/herbal_tea
	category = "Herbal Remedies"
	crafting_time = 8 SECONDS
	water_conversion = 1
	reagent_requirements = list(
		/datum/reagent/water = 20
	)
	craft_verb = "brewing "
	required_chem_temp = 350 // Lower temp for gentle herbal brewing
	pollute_amount = 200
	wording_choice = "leaves of"
	complete_message = "The herbal brew smells soothing!"
	used_skill = /datum/attribute/skill/craft/alchemy
	quality_modifier = 0.8

// Symphitum Tea Recipe
/datum/container_craft/cooking/herbal_tea/symphitum_tea
	name = "Symphitum Tea"
	created_reagent = /datum/reagent/medicine/herbal/symphitum_tea
	requirements = list(
		/obj/item/alch/herb/symphitum = 2
	)
	finished_smell = /datum/pollutant/food/teas

// Taraxacum Extract Recipe
/datum/container_craft/cooking/herbal_tea/taraxacum_extract
	name = "Taraxacum Extract"
	created_reagent = /datum/reagent/medicine/herbal/taraxacum_extract
	requirements = list(
		/obj/item/alch/herb/taraxacum = 3
	)
	crafting_time = 12 SECONDS
	wording_choice = "roots of"
	finished_smell = /datum/pollutant/food/bitter

// Urtica Brew Recipe
/datum/container_craft/cooking/herbal_tea/urtica_brew
	name = "Urtica Brew"
	created_reagent = /datum/reagent/medicine/herbal/urtica_brew
	requirements = list(
		/obj/item/alch/herb/urtica = 2
	)
	optional_requirements = list(
		/obj/item/alch/irondust = 1 // Iron dust enhances blood restoration
	)
	max_optionals = 1
	finished_smell = /datum/pollutant/food/roasted_seeds

// Calendula Salve Recipe (uses alcohol instead of water)
/datum/container_craft/cooking/herbal_salve
	abstract_type = /datum/container_craft/cooking/herbal_salve
	category = "Herbal Remedies"
	crafting_time = 15 SECONDS
	water_conversion = 1
	reagent_requirements = list(
		/datum/reagent/consumable/ethanol = 20
	)
	subtype_reagents_allowed = TRUE
	craft_verb = "preparing "
	required_chem_temp = 320 // Lower temp for salves
	pollute_amount = 150
	wording_choice = "petals of"
	complete_message = "The herbal salve looks ready!"
	used_skill = /datum/attribute/skill/craft/alchemy
	quality_modifier = 0.9

/datum/container_craft/cooking/herbal_salve/calendula_salve
	name = "Calendula Salve"
	created_reagent = /datum/reagent/medicine/herbal/calendula_salve
	requirements = list(
		/obj/item/alch/herb/calendula = 3
	)
	finished_smell = /datum/pollutant/food/flower

// Hypericum Tonic Recipe
/datum/container_craft/cooking/herbal_tea/hypericum_tonic
	name = "Hypericum Tonic"
	created_reagent = /datum/reagent/medicine/herbal/hypericum_tonic
	requirements = list(
		/obj/item/alch/herb/hypericum = 2
	)
	optional_requirements = list(
		/obj/item/alch/golddust = 1 // Gold dust enhances mana restoration
	)
	max_optionals = 1
	finished_smell = /datum/pollutant/food/bitter

// Mentha Tea Recipe
/datum/container_craft/cooking/herbal_tea/mentha_tea
	name = "Mentha Tea"
	created_reagent = /datum/reagent/medicine/herbal/mentha_tea
	requirements = list(
		/obj/item/alch/herb/mentha = 2
	)
	crafting_time = 6 SECONDS
	finished_smell = /datum/pollutant/food/mint

// Herbal Buff Teas
/datum/container_craft/cooking/herbal_tea/salvia_wisdom
	name = "Salvia Wisdom Tea"
	created_reagent = /datum/reagent/buff/herbal/salvia_wisdom
	requirements = list(
		/obj/item/alch/herb/salvia = 2
	)
	optional_requirements = list(
		/obj/item/fertilizer/bone_meal = 1 // Bone meal enhances wisdom
	)
	max_optionals = 1
	finished_smell = /datum/pollutant/food/herb

/datum/container_craft/cooking/herbal_tea/artemisia_luck
	name = "Artemisia Fortune Tea"
	created_reagent = /datum/reagent/buff/herbal/artemisia_luck
	requirements = list(
		/obj/item/alch/herb/artemisia = 2
	)
	optional_requirements = list(
		/obj/item/alch/silverdust = 1 // Silver dust enhances luck
	)
	max_optionals = 1
	finished_smell = /datum/pollutant/food/bitter

/datum/container_craft/cooking/herbal_tea/euphorbia_strength
	name = "Euphorbia Strength Tea"
	created_reagent = /datum/reagent/buff/herbal/euphorbia_strength
	requirements = list(
		/obj/item/alch/herb/euphorbia = 2
	)
	optional_requirements = list(
		/obj/item/alch/irondust = 1 // irondust enhances strength
	)
	max_optionals = 1
	finished_smell = /datum/pollutant/food/bitter

// Mild Poison Recipes
/datum/container_craft/cooking/herbal_tea/weak_atropa
	name = "Diluted Atropa Extract"
	created_reagent = /datum/reagent/poison/herbal/weak_atropa
	requirements = list(
		/obj/item/alch/herb/atropa = 1
	)
	crafting_time = 5 SECONDS
	finished_smell = /datum/pollutant/food/bitter
	complete_message = "The extract smells dangerous..."

/datum/container_craft/cooking/herbal_tea/matricaria_irritant
	name = "Matricaria Irritant"
	created_reagent = /datum/reagent/poison/herbal/matricaria_irritant
	requirements = list(
		/obj/item/alch/herb/matricaria = 2
	)
	finished_smell = /datum/pollutant/food/flower

/datum/container_craft/cooking/herbal_tea/rosa_water
	name = "Rosa Water"
	created_reagent = /datum/reagent/medicine/herbal/simple_rosa
	requirements = list(
		/obj/item/alch/herb/rosa = 1
	)
	crafting_time = 4 SECONDS
	finished_smell = /datum/pollutant/food/flower

/datum/container_craft/cooking/herbal_tea/euphrasia_wash
	name = "Euphrasia Eye Wash"
	created_reagent = /datum/reagent/medicine/herbal/euphrasia_eye_wash
	requirements = list(
		/obj/item/alch/herb/euphrasia = 2
	)
	finished_smell = /datum/pollutant/food/herb

// Valeriana Sleep Draught (calming/sleep aid)
/datum/container_craft/cooking/herbal_tea/valeriana_draught
	name = "Valeriana Sleep Draught"
	created_reagent = /datum/reagent/medicine/herbal/valeriana_draught
	requirements = list(
		/obj/item/alch/herb/valeriana = 2,
		/obj/item/alch/herb/mentha = 1
	)
	crafting_time = 10 SECONDS
	finished_smell = /datum/pollutant/food/herb
	complete_message = "The draught smells deeply relaxing..."

// Benedictus Vigor Tea (stamina enhancement)
/datum/container_craft/cooking/herbal_tea/benedictus_vigor
	name = "Benedictus Vigor Tea"
	created_reagent = /datum/reagent/buff/herbal/benedictus_vigor
	requirements = list(
		/obj/item/alch/herb/benedictus = 2
	)
	optional_requirements = list(
		/obj/item/alch/irondust = 1 // Iron enhances physical vigor
	)
	max_optionals = 1
	finished_smell = /datum/pollutant/food/herb

// Paris Numbing Poultice (topical anesthetic)
/datum/container_craft/cooking/herbal_salve/paris_poultice
	name = "Paris Numbing Poultice"
	created_reagent = /datum/reagent/medicine/herbal/paris_poultice
	requirements = list(
		/obj/item/alch/herb/paris = 2,
		/obj/item/alch/herb/calendula = 1
	)
	crafting_time = 18 SECONDS
	finished_smell = /datum/pollutant/food/bitter
	complete_message = "The poultice looks thick and medicinal."

// Complex Multi-Herb Recipes

// Herbalist's Panacea (multiple healing herbs)
/datum/container_craft/cooking/herbal_tea/herbalist_panacea
	name = "Herbalist's Panacea"
	created_reagent = /datum/reagent/medicine/herbal/herbalist_panacea
	requirements = list(
		/obj/item/alch/herb/symphitum = 1,
		/obj/item/alch/herb/calendula = 1,
		/obj/item/alch/herb/urtica = 1
	)
	optional_requirements = list(
		/obj/item/alch/herb/rosa = 1 // Rosa enhances the blend
	)
	max_optionals = 1
	crafting_time = 20 SECONDS
	finished_smell = /datum/pollutant/food/herb
	complete_message = "The panacea glows with herbal potency!"

// Witch's Bane (anti-poison blend)
/datum/container_craft/cooking/herbal_tea/witches_bane
	name = "Witch's Bane"
	created_reagent = /datum/reagent/medicine/herbal/witches_bane
	requirements = list(
		/obj/item/alch/herb/rosa = 1,
		/obj/item/alch/herb/hypericum = 1
	)
	reagent_requirements = list(
		/datum/reagent/medicine/herbal/simple_rosa = 20,
	)
	optional_requirements = list(
		/obj/item/alch/silverdust = 1 // Silver purifies
	)
	max_optionals = 1
	crafting_time = 15 SECONDS
	finished_smell = /datum/pollutant/food/flower

// Scholar's Focus (mental enhancement)
/datum/container_craft/cooking/herbal_tea/scholar_focus
	name = "Scholar's Focus Tea"
	created_reagent = /datum/reagent/buff/herbal/scholar_focus
	requirements = list(
		/obj/item/alch/herb/euphrasia = 1,
	)
	reagent_requirements = list(
		/datum/reagent/buff/herbal/alchemist_insight = 20
	)
	crafting_time = 12 SECONDS
	finished_smell = /datum/pollutant/food/mint
	complete_message = "The tea shimmers with intellectual clarity!"


// Moonwater Elixir (magical enhancement)
/datum/container_craft/cooking/herbal_tea/moonwater_elixir
	name = "Moonwater Elixir"
	created_reagent = /datum/reagent/buff/herbal/moonwater_elixir
	requirements = list(
		/obj/item/alch/herb/artemisia = 1,
		/obj/item/alch/herb/hypericum = 1
	)
	optional_requirements = list(
		/obj/item/alch/silverdust = 1,
		/obj/item/alch/waterdust = 1
	)
	max_optionals = 2
	crafting_time = 30 SECONDS // Long brewing time
	required_chem_temp = 320
	finished_smell = /datum/pollutant/food/herb
	complete_message = "The elixir glows faintly with moonlight!"

// Battle Stim (combat enhancement)
/datum/container_craft/cooking/herbal_tea/battle_stim
	name = "Warrior's Battle Broth"
	created_reagent = /datum/reagent/buff/herbal/battle_stim
	requirements = list(
		/obj/item/alch/herb/benedictus = 1,
		/obj/item/alch/herb/valeriana = 1, // Calms nerves
		/obj/item/alch/herb/urtica = 1    // Energizes
	)
	optional_requirements = list(
		/obj/item/alch/irondust = 1  // Strengthens resolve
	)
	max_optionals = 1
	crafting_time = 16 SECONDS
	finished_smell = /datum/pollutant/food/herb

// Experimental Tinctures

// Alchemist's Insight (reveals herb properties)
/datum/container_craft/cooking/herbal_tea/alchemist_insight
	name = "Alchemist's Insight"
	created_reagent = /datum/reagent/buff/herbal/alchemist_insight
	requirements = list(
		/obj/item/alch/herb/salvia = 1,
		/obj/item/alch/herb/mentha = 1
	)
	optional_requirements = list(
		/obj/item/alch/golddust = 1 // Gold enhances perception
	)
	max_optionals = 1
	crafting_time = 14 SECONDS
	finished_smell = /datum/pollutant/food/herb
	complete_message = "The insight brew swirls with hidden knowledge!"

// Purification Draught (removes negative effects)
/datum/container_craft/cooking/herbal_tea/purification_draught
	name = "Purification Draught"
	created_reagent = /datum/reagent/medicine/herbal/purification_draught
	requirements = list(
		/obj/item/alch/herb/rosa = 1,
		/obj/item/alch/herb/calendula = 1,
		/obj/item/alch/herb/hypericum = 1
	)
	optional_requirements = list(
		/obj/item/alch/silverdust = 1,
		/obj/item/alch/waterdust = 1
	)
	max_optionals = 2
	crafting_time = 25 SECONDS
	finished_smell = /datum/pollutant/food/flower
	complete_message = "The draught radiates purity and cleansing!"

/datum/container_craft/cooking/herbal_tea/purification_draught
	name = "Transis Potion"
	created_reagent = /datum/reagent/medicine/gender_potion
	water_conversion = 0.5
	requirements = list(
		/obj/item/alch/transisdust = 1,
		/obj/item/alch/silverdust = 1,
		/obj/item/alch/viscera = 1
	)
	crafting_time = 30 SECONDS
	finished_smell = /datum/pollutant/food/strawberry_cake
	complete_message = "The brew radiates heat and a sweet smell."

/datum/container_craft/cooking/perfume
	abstract_type = /datum/container_craft/cooking/perfume
	category = "Fragrances"
	crafting_time = 30 SECONDS
	water_conversion = 0.5
	reagent_requirements = list(
		/datum/reagent/medicine/herbal/simple_rosa = 25
	)
	craft_verb = "brewing "
	required_chem_temp = 350 // Lower temp for gentle herbal brewing
	pollute_amount = 200
	complete_message = "A strong, fragrant scent permeates the area."
	wording_choice = "leaves of"
	used_skill = /datum/attribute/skill/craft/alchemy
	quality_modifier = 0.8

/datum/container_craft/cooking/perfume/rosa
	name = "Rosa Perfume"
	created_reagent = /obj/item/perfume/rose
	requirements = list(
		/datum/reagent/medicine/herbal/simple_rosa = 25,
		/obj/item/alch/herb/rosa = 1
	)
	finished_smell = /datum/pollutant/fragrance/rose

	wording_choice = "petals of"
	complete_message = "A strong, fragrant scent of rosa permeates the area."

/datum/container_craft/cooking/perfume/mint
	name = "Mint Perfume"
	created_reagent = /obj/item/perfume/mint
	requirements = list(
		/datum/reagent/medicine/herbal/simple_rosa = 25,
		/obj/item/alch/herb/mentha = 1
	)
	finished_smell = /datum/pollutant/fragrance/mint

	wording_choice = "leaves of"
	complete_message = "A strong, fragrant scent of mint permeates the area."

/datum/container_craft/cooking/perfume/pear
	name = "Pear Perfume"
	created_reagent = /obj/item/perfume/pear
	requirements = list(
		/datum/reagent/medicine/herbal/simple_rosa = 25,
		/obj/item/reagent_containers/food/snacks/produce/fruit/pear = 1
	)
	finished_smell = /datum/pollutant/fragrance/pear
	complete_message = "A strong, fragrant scent of pear permeates the area."

	wording_choice = "pieces of"

/datum/container_craft/cooking/perfume/strawberry
	name = "Strawberry Perfume"
	created_reagent = /obj/item/perfume/strawberry
	requirements = list(
		/datum/reagent/medicine/herbal/simple_rosa = 25,
		/obj/item/reagent_containers/food/snacks/produce/fruit/strawberry = 1
	)
	finished_smell = /datum/pollutant/fragrance/strawberry
	complete_message = "A strong, fragrant scent of strawberry permeates the area."
	wording_choice = "pieces of"
