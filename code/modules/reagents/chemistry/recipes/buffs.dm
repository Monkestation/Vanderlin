/datum/chemical_reaction/blade_arts_tincture
	name = "Blade-Arts Tincture"
	id = "blade_arts_tincture"
	mix_message = "The mixture turns a deep arterial red and smells sharply of iron."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/speed/concentrated = 3,
		/datum/reagent/buff/strength/concentrated = 3,
		/datum/reagent/blood = 2,
		/datum/reagent/consumable/eggyolk = 2
	)
	results = list(/datum/reagent/skill_elixir/blade_arts = 10)

/datum/chemical_reaction/heavy_arms_draught
	name = "Heavy-Arms Draught"
	id = "heavy_arms_draught"
	mix_message = "The mixture thickens and darkens, smelling of old blood and earth."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/strength/concentrated = 4,
		/datum/reagent/blood = 3,
		/datum/reagent/consumable/nutriment/bone_marrow = 3
	)
	results = list(/datum/reagent/skill_elixir/heavy_arms = 10)

/datum/chemical_reaction/whip_hand_oil
	name = "Whip-Hand Oil"
	id = "whip_hand_oil"
	mix_message = "The mixture shimmers as the concentrates merge into a supple, sharp-smelling oil."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/speed/concentrated = 3,
		/datum/reagent/buff/perception/concentrated = 3,
		/datum/reagent/toxin/fyritiusnectar = 1
	)
	results = list(/datum/reagent/skill_elixir/whip_hand = 10)

/datum/chemical_reaction/marksmans_eye_drop
	name = "Marksman's Eye Drop"
	id = "marksmans_eye_drop"
	mix_message = "The mixture brightens to a clear amber and smells of pine resin."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/perception/concentrated = 4,
		/datum/reagent/medicine/rosawater = 3,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/skill_elixir/marksmans_eye = 10)

/datum/chemical_reaction/shield_bearers_draught
	name = "Shield-Bearer's Draught"
	id = "shield_bearers_draught"
	mix_message = "The mixture turns a chalky grey and settles heavily in the vessel."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/endurance/concentrated = 4,
		/datum/reagent/ash = 3,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/skill_elixir/shield_bearer = 10)

/datum/chemical_reaction/craftsmans_wit
	name = "Craftsman's Wit"
	id = "craftsmans_wit"
	mix_message = "The mixture darkens and smells sharply of metal shavings and machine oil."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/intelligence/concentrated = 4,
		/datum/reagent/ash = 3,
		/datum/reagent/toxin/fyritiusnectar = 1,
	)
	results = list(/datum/reagent/skill_elixir/craftsmans_wit = 10)

/datum/chemical_reaction/smelters_patience
	name = "Smelter's Patience"
	id = "smelters_patience"
	mix_message = "The mixture flares briefly warm and settles into a deep orange-brown."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/endurance/concentrated = 5,
		/datum/reagent/ash = 3,
		/datum/reagent/blood = 2
	)
	results = list(/datum/reagent/skill_elixir/smelters_patience = 10)

/datum/chemical_reaction/builders_draught
	name = "Builder's Draught"
	id = "builders_draught"
	mix_message = "The mixture turns gritty and pale, smelling of cut wood and stone."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/strength/concentrated = 4,
		/datum/reagent/ash = 3,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/skill_elixir/builders_draught = 10)

/datum/chemical_reaction/trappers_sense
	name = "Trapper's Sense"
	id = "trappers_sense"
	mix_message = "The mixture darkens to a mossy green-brown and smells of wet bark."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/perception/concentrated = 4,
		/datum/reagent/water = 3,
		/datum/reagent/consumable/honey = 3
	)
	results = list(/datum/reagent/skill_elixir/trappers_sense = 10)

/datum/chemical_reaction/alchemists_clarity
	name = "Alchemist's Clarity"
	id = "alchemists_clarity"
	mix_message = "The mixture emits a brief sulfurous flash before settling into a deep violet."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/intelligence/concentrated = 4,
		/datum/reagent/medicine/healthpot = 2,
		/datum/reagent/water = 2
	)
	results = list(/datum/reagent/skill_elixir/alchemists_clarity = 10)

/datum/chemical_reaction/smiths_blood
	name = "Smith's Blood"
	id = "smiths_blood"
	mix_message = "The mixture turns a deep arterial red and smells of the forge."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/strength/concentrated = 4,
		/datum/reagent/blood = 3,
		/datum/reagent/ash = 3
	)
	results = list(/datum/reagent/skill_elixir/smiths_blood = 10)

/datum/chemical_reaction/skinners_elixir
	name = "Skinner's Elixir"
	id = "skinners_elixir"
	mix_message = "The mixture takes on a greasy, amber hue and smells of raw hide."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/perception/concentrated = 4,
		/datum/reagent/blood = 3,
		/datum/reagent/ash = 3  // potash, used in hide tanning
	)
	results = list(/datum/reagent/skill_elixir/skinners_elixir = 10)

/datum/chemical_reaction/locksmiths_oil
	name = "Locksmith's Oil"
	id = "locksmiths_oil"
	mix_message = "The mixture shimmers with a faint silvery iridescence."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/perception/concentrated = 4,
		/datum/reagent/toxin/fyritiusnectar = 4,
		/datum/reagent/water = 2
	)
	results = list(/datum/reagent/skill_elixir/locksmiths_oil = 10)

/datum/chemical_reaction/cooks_brine
	name = "Cook's Brine"
	id = "cooks_brine"
	mix_message = "The mixture takes on a rich golden colour and smells of a busy kitchen."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/intelligence/concentrated = 4,
		/datum/reagent/consumable/nutriment/bone_marrow = 3,
		/datum/reagent/consumable/honey = 3
	)
	results = list(/datum/reagent/skill_elixir/cooks_brine = 10)

/datum/chemical_reaction/prep_hands_tonic
	name = "Prep Hand's Tonic"
	id = "prep_hands_tonic"
	mix_message = "The mixture fizzes and brightens to a vivid herbal green."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/speed/concentrated = 4,
		/datum/reagent/consumable/eggyolk = 3,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/skill_elixir/prep_hands_tonic = 10)

/datum/chemical_reaction/brewers_wort
	name = "Brewer's Wort"
	id = "brewers_wort"
	mix_message = "The mixture clouds to a murky amber and gives off a yeasty warmth."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/intelligence/concentrated = 4,
		/datum/reagent/consumable/sugar = 3,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/skill_elixir/brewers_wort = 10)

/datum/chemical_reaction/seamstress_thimble_drop
	name = "Seamstress's Thimble-Drop"
	id = "seamstress_thimble_drop"
	mix_message = "The mixture turns pale and fragrant, with a faint silky sheen."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/perception/concentrated = 4,
		/datum/reagent/consumable/honey = 3,
		/datum/reagent/medicine/rosawater = 3
	)
	results = list(/datum/reagent/skill_elixir/seamstress_thimble_drop = 10)

/datum/chemical_reaction/miners_heart
	name = "Miner's Heart"
	id = "miners_heart"
	mix_message = "The mixture turns a deep charcoal black, smelling of stone and effort."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/strength/concentrated = 4,
		/datum/reagent/toxin/fyritiusnectar = 3,
		/datum/reagent/blood = 3
	)
	results = list(/datum/reagent/skill_elixir/miners_heart = 10)

/datum/chemical_reaction/farmers_almanac_tonic
	name = "Farmer's Almanac Tonic"
	id = "farmers_almanac_tonic"
	mix_message = "The mixture turns a warm earthy brown and smells of turned soil and chamomile."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/intelligence/concentrated = 4,
		/datum/reagent/caveweep = 3,
		/datum/reagent/consumable/honey = 3
	)
	results = list(/datum/reagent/skill_elixir/farmers_almanac = 10)

/datum/chemical_reaction/beastwhisper
	name = "Beastwhisper"
	id = "beastwhisper"
	mix_message = "The mixture turns a pale green and gives off a smell that is oddly calming."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/perception/concentrated = 3,
		/datum/reagent/buff/fortune/concentrated = 3,
		/datum/reagent/tree_sap = 2,
		/datum/reagent/consumable/nutriment/bone_marrow = 2
	)
	results = list(/datum/reagent/skill_elixir/beastwhisper = 10)

/datum/chemical_reaction/miracle_water
	name = "Miracle Water"
	id = "miracle_water"
	mix_message = "The mixture glows faintly and smells of incense and clean air."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/fortune/concentrated = 4,
		/datum/reagent/medicine/rosawater = 3,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/skill_elixir/miracle_water = 10)

/datum/chemical_reaction/vital_ichor
	name = "Vital Ichor"
	id = "vital_ichor"
	mix_message = "The mixture deepens to a pulsing crimson, smelling of iron and old magic."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/constitution/concentrated = 4,
		/datum/reagent/blood = 3,
		/datum/reagent/toxin/manabloom_juice = 3
	)
	results = list(/datum/reagent/skill_elixir/vital_ichor = 10)

/datum/chemical_reaction/arcane_solvent
	name = "Arcane Solvent"
	id = "arcane_solvent"
	mix_message = "The mixture shifts through blue and violet before settling into a luminous azure."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/intelligence/concentrated = 4,
		/datum/reagent/toxin/manabloom_juice = 4,
		/datum/reagent/water = 2
	)
	results = list(/datum/reagent/skill_elixir/arcane_solvent = 10)

/datum/chemical_reaction/wild_draught
	name = "Wild Draught"
	id = "wild_draught"
	mix_message = "The mixture darkens to a forest green and smells of moss and morning dew."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/perception/concentrated = 3,
		/datum/reagent/buff/fortune/concentrated = 3,
		/datum/reagent/thorn_essence = 2,
		/datum/reagent/tree_sap = 2
	)
	results = list(/datum/reagent/skill_elixir/wild_draught = 10)

/datum/chemical_reaction/athletes_brine
	name = "Athlete's Brine"
	id = "athletes_brine"
	mix_message = "The mixture clears to a pale green and smells of sea air."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/endurance/concentrated = 4,
		/datum/reagent/consumable/ethanol/ale = 3,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/skill_elixir/athletes_brine = 10)

/datum/chemical_reaction/shadow_tonic
	name = "Shadow Tonic"
	id = "shadow_tonic"
	mix_message = "The mixture fades to near-colourless and gives off almost no scent at all."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/speed/concentrated = 3,
		/datum/reagent/buff/perception/concentrated = 3,
		/datum/reagent/water = 4
	)
	results = list(/datum/reagent/skill_elixir/shadow_tonic = 10)

/datum/chemical_reaction/scholars_ink
	name = "Scholar's Ink"
	id = "scholars_ink"
	mix_message = "The mixture turns a deep blue-black and smells of old books and fresh ink."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/buff/intelligence/concentrated = 4,
		/datum/reagent/toxin/manabloom_juice = 2,
		/datum/reagent/toxin/plasma = 2,
	)
	results = list(/datum/reagent/skill_elixir/scholars_ink = 10)

/datum/chemical_reaction/hallucinogen_from_extract
	name = "Refined Hallucinogen"
	id = "hallucinogen_from_extract"
	mix_message = "The extract shimmers violently and resolves into a deeply purple fluid."
	mix_sound = "pour"
	required_reagents = list(
		/datum/reagent/drug/hallucinogen_concetrate = 4,
		/datum/reagent/toxin/manabloom_juice = 2,
		/datum/reagent/water = 2
	)
	results = list(/datum/reagent/drug/hallucinogen = 10)
