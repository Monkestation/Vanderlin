
/datum/reagent/buff/strength/concentrated
	name = "Concentrated Strength"
	color = "#c86800"
	taste_description = "raw meat so dense it almost chokes you"
	scent_description = "blood and hot iron"

/datum/reagent/buff/strength/concentrated/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/strengthpot/concentrated))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/strength/concentrated, 2))
		M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot/concentrated)
		M.remove_reagent(/datum/reagent/buff/strength/concentrated, M.reagents.get_reagent_amount(/datum/reagent/buff/strength/concentrated))
	return ..()

/datum/reagent/buff/perception/concentrated
	name = "Concentrated Perception"
	color = "#c8c800"
	taste_description = "eye-watering acuity"
	scent_description = "ozone and pine"

/datum/reagent/buff/perception/concentrated/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/perceptionpot/concentrated))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/perception/concentrated, 2))
		M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot/concentrated)
		M.remove_reagent(/datum/reagent/buff/perception/concentrated, M.reagents.get_reagent_amount(/datum/reagent/buff/perception/concentrated))
	return ..()

/datum/reagent/buff/intelligence/concentrated
	name = "Concentrated Intelligence"
	color = "#2a5a1a"
	taste_description = "cold water from a very deep well"
	scent_description = "old parchment and ink"

/datum/reagent/buff/intelligence/concentrated/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/intelligencepot/concentrated))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/intelligence/concentrated, 2))
		M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot/concentrated)
		M.remove_reagent(/datum/reagent/buff/intelligence/concentrated, M.reagents.get_reagent_amount(/datum/reagent/buff/intelligence/concentrated))
	return ..()

/datum/reagent/buff/constitution/concentrated
	name = "Concentrated Constitution"
	color = "#0a0302"
	taste_description = "bile thick enough to stand a spoon in"
	scent_description = "deep earth and old stone"

/datum/reagent/buff/constitution/concentrated/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/constitutionpot/concentrated))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/constitution/concentrated, 2))
		M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot/concentrated)
		M.remove_reagent(/datum/reagent/buff/constitution/concentrated, M.reagents.get_reagent_amount(/datum/reagent/buff/constitution/concentrated))
	return ..()

/datum/reagent/buff/endurance/concentrated
	name = "Concentrated Endurance"
	color = "#507000"
	taste_description = "sweat and salt and iron will"
	scent_description = "exertion and dry heat"

/datum/reagent/buff/endurance/concentrated/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/endurancepot/concentrated))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/endurance/concentrated, 2))
		M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot/concentrated)
		M.remove_reagent(/datum/reagent/buff/endurance/concentrated, M.reagents.get_reagent_amount(/datum/reagent/buff/endurance/concentrated))
	return ..()

/datum/reagent/buff/speed/concentrated
	name = "Concentrated Speed"
	color = "#c8c840"
	taste_description = "pure lightning on the tongue"
	scent_description = "electric heat"

/datum/reagent/buff/speed/concentrated/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/speedpot/concentrated))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/speed/concentrated, 2))
		M.apply_status_effect(/datum/status_effect/buff/alch/speedpot/concentrated)
		M.remove_reagent(/datum/reagent/buff/speed/concentrated, M.reagents.get_reagent_amount(/datum/reagent/buff/speed/concentrated))
	return ..()

/datum/reagent/buff/fortune/concentrated
	name = "Concentrated Fortune"
	color = "#d4af37"
	taste_description = "sweetness that defies explanation"
	scent_description = "warm coin and morning air"

/datum/reagent/buff/fortune/concentrated/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/fortunepot/concentrated))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/fortune/concentrated, 2))
		M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot/concentrated)
		M.remove_reagent(/datum/reagent/buff/fortune/concentrated, M.reagents.get_reagent_amount(/datum/reagent/buff/fortune/concentrated))
	return ..()

/datum/reagent/skill_elixir
	description = ""
	random_reagent_color = TRUE
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_INSANELY_SLOW_METABOLISM

/datum/reagent/skill_elixir/blade_arts
	name = "Blade-Arts Tincture"
	description = "A biting, iron-rich tincture said to have been drunk by duelists before contests of blades."
	color = "#8a1a1a"
	taste_description = "blood and cold steel"
	scent_description = "iron and oiled leather"

/datum/reagent/skill_elixir/blade_arts/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/blade_arts)

/datum/reagent/skill_elixir/blade_arts/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/blade_arts)

/datum/reagent/skill_elixir/heavy_arms
	name = "Heavy-Arms Draught"
	description = "A thick, gritty draught smelling of soil and animal fat. Favoured by soldiers and brawlers."
	color = "#5a3010"
	taste_description = "rendered marrow and grit"
	scent_description = "sweat, earth, and old blood"

/datum/reagent/skill_elixir/heavy_arms/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/heavy_arms)

/datum/reagent/skill_elixir/heavy_arms/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/heavy_arms)

/datum/reagent/skill_elixir/whip_hand
	name = "Whip-Hand Oil"
	description = "A light, sharp-smelling oil that steadies the wrist and quickens the eye."
	color = "#704020"
	taste_description = "pepper and hot leather"
	scent_description = "tanned hide and sweat"

/datum/reagent/skill_elixir/whip_hand/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/whip_hand)

/datum/reagent/skill_elixir/whip_hand/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/whip_hand)

/datum/reagent/skill_elixir/marksmans_eye
	name = "Marksman's Eye Drop"
	description = "A sharp, resinous tonic said to steady the hand and sharpen the eye to a needle's point."
	color = "#a0a030"
	taste_description = "pine resin and something bright"
	scent_description = "woodsmoke and dry air"

/datum/reagent/skill_elixir/marksmans_eye/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/marksmans_eye)

/datum/reagent/skill_elixir/marksmans_eye/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/marksmans_eye)

/datum/reagent/skill_elixir/shield_bearer
	name = "Shield-Bearer's Draught"
	description = "A heavy, mineral-rich drink that settles the stance and firms the grip."
	color = "#505060"
	taste_description = "chalk and iron filings"
	scent_description = "stone dust and sweat"

/datum/reagent/skill_elixir/shield_bearer/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/shield_bearer)

/datum/reagent/skill_elixir/shield_bearer/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/shield_bearer)

/datum/reagent/skill_elixir/craftsmans_wit
	name = "Craftsman's Wit"
	description = "A sharp, acrid liquid that clears the mind for mechanical and constructive thought."
	color = "#3a3a4a"
	taste_description = "carbon and mineral oil"
	scent_description = "machine grease and sawdust"

/datum/reagent/skill_elixir/craftsmans_wit/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/craftsmans_wit)

/datum/reagent/skill_elixir/craftsmans_wit/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/craftsmans_wit)

/datum/reagent/skill_elixir/smelters_patience
	name = "Smelter's Patience"
	description = "A thick, warm draught that hardens the body against sustained heat and labour."
	color = "#b04800"
	taste_description = "charcoal and something sweet"
	scent_description = "hot metal and coal smoke"

/datum/reagent/skill_elixir/smelters_patience/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/smelters_patience)

/datum/reagent/skill_elixir/smelters_patience/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/smelters_patience)

/datum/reagent/skill_elixir/builders_draught
	name = "Builder's Draught"
	description = "A gritty, chalky drink mixed with sawdust that puts fire in the arms and steadiness in the hands."
	color = "#8a6030"
	taste_description = "chalk, sawdust, and something earthy"
	scent_description = "fresh-cut wood and stone"

/datum/reagent/skill_elixir/builders_draught/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/builders_draught)

/datum/reagent/skill_elixir/builders_draught/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/builders_draught)

/datum/reagent/skill_elixir/trappers_sense
	name = "Trapper's Sense"
	description = "A bitter, woodsy tincture that sharpens awareness and steadies the hands for delicate work."
	color = "#506030"
	taste_description = "bark and bitter herbs"
	scent_description = "wet leaves and earth"

/datum/reagent/skill_elixir/trappers_sense/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/trappers_sense)

/datum/reagent/skill_elixir/trappers_sense/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/trappers_sense)

/datum/reagent/skill_elixir/alchemists_clarity
	name = "Alchemist's Clarity"
	description = "A self-referential paradox: an elixir that sharpens the mind for making elixirs. Tastes like it knows something you don't."
	color = "#604080"
	taste_description = "sulfur, copper, and faint sweetness"
	scent_description = "reagent fumes and hot glass"

/datum/reagent/skill_elixir/alchemists_clarity/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/alchemists_clarity)

/datum/reagent/skill_elixir/alchemists_clarity/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/alchemists_clarity)

/datum/reagent/skill_elixir/smiths_blood
	name = "Smith's Blood"
	description = "A dark, iron-tasting draught that puts fire in the arm and certainty in the hammer."
	color = "#5a1010"
	taste_description = "iron, copper, and old fire"
	scent_description = "forge smoke and blood"

/datum/reagent/skill_elixir/smiths_blood/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/smiths_blood)

/datum/reagent/skill_elixir/smiths_blood/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/smiths_blood)

/datum/reagent/skill_elixir/skinners_elixir
	name = "Skinner's Elixir"
	description = "An oily, pungent brew said to make a tanner's hands supple and their eye sharp."
	color = "#8b6914"
	taste_description = "rendered fat and salt"
	scent_description = "raw hide and wood ash"

/datum/reagent/skill_elixir/skinners_elixir/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/skinners_elixir)

/datum/reagent/skill_elixir/skinners_elixir/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/skinners_elixir)

/datum/reagent/skill_elixir/locksmiths_oil
	name = "Locksmith's Oil"
	description = "A shimmering, slippery liquid that steadies the hands and narrows the focus."
	color = "#c0c0b0"
	taste_description = "metallic and slick"
	scent_description = "machine oil and brass"

/datum/reagent/skill_elixir/locksmiths_oil/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/locksmiths_oil)

/datum/reagent/skill_elixir/locksmiths_oil/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/locksmiths_oil)

/datum/reagent/skill_elixir/cooks_brine
	name = "Cook's Brine"
	description = "A complex, briny tonic that sharpens the palate and quickens culinary instinct."
	color = "#c8a060"
	taste_description = "salt, acid, and something savory"
	scent_description = "a working kitchen"

/datum/reagent/skill_elixir/cooks_brine/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/cooks_brine)

/datum/reagent/skill_elixir/cooks_brine/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/cooks_brine)

/datum/reagent/skill_elixir/prep_hands_tonic
	name = "Prep Hand's Tonic"
	description = "A sharp, herbal tonic that quickens the hands at the cutting board."
	color = "#90b060"
	taste_description = "sharp herbs and vinegar"
	scent_description = "a freshly-wiped chopping board"

/datum/reagent/skill_elixir/prep_hands_tonic/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/prep_hands_tonic)

/datum/reagent/skill_elixir/prep_hands_tonic/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/prep_hands_tonic)

/datum/reagent/skill_elixir/brewers_wort
	name = "Brewer's Wort"
	description = "A murky, yeasty liquid that smells of fermentation and old barrels. Fermenters swear by it."
	color = "#906020"
	taste_description = "yeast, barley, and something acidic"
	scent_description = "fermenting grain and oak"

/datum/reagent/skill_elixir/brewers_wort/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/brewers_wort)

/datum/reagent/skill_elixir/brewers_wort/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/brewers_wort)

/datum/reagent/skill_elixir/seamstress_thimble_drop
	name = "Seamstress's Thimble-Drop"
	description = "A delicate, waxy liquid that steadies the fingers for fine needlework."
	color = "#e0c8d0"
	taste_description = "beeswax and something faintly floral"
	scent_description = "clean linen and lavender"

/datum/reagent/skill_elixir/seamstress_thimble_drop/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/seamstress_thimble_drop)

/datum/reagent/skill_elixir/seamstress_thimble_drop/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/seamstress_thimble_drop)

/datum/reagent/skill_elixir/miners_heart
	name = "Miner's Heart"
	description = "A thick, charcoal-dark brew that bolsters the body for sustained physical labour."
	color = "#303030"
	taste_description = "charcoal, iron, and bitter mineral water"
	scent_description = "deep stone and coal dust"

/datum/reagent/skill_elixir/miners_heart/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/miners_heart)

/datum/reagent/skill_elixir/miners_heart/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/miners_heart)

/datum/reagent/skill_elixir/farmers_almanac
	name = "Farmer's Almanac Tonic"
	description = "A surprisingly complex herbal blend that sharpens practical knowledge and pattern recognition."
	color = "#608040"
	taste_description = "soil and chamomile and something almost sweet"
	scent_description = "turned earth and dried herbs"

/datum/reagent/skill_elixir/farmers_almanac/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/farmers_almanac)

/datum/reagent/skill_elixir/farmers_almanac/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/farmers_almanac)

/datum/reagent/skill_elixir/beastwhisper
	name = "Beastwhisper"
	description = "A strange, sweet-smelling tonic brewed from flowers and fish scales. Creatures seem calmer around those who drink it."
	color = "#70a080"
	taste_description = "river water and wildflower"
	scent_description = "something animals find calming"

/datum/reagent/skill_elixir/beastwhisper/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/beastwhisper)

/datum/reagent/skill_elixir/beastwhisper/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/beastwhisper)

/datum/reagent/skill_elixir/miracle_water
	name = "Miracle Water"
	description = "Blessed water charged with divine intent. Those of faith find their connection to their patron deepened by it."
	color = "#f0f0e0"
	glows = TRUE
	taste_description = "purity and something warm"
	scent_description = "incense and clean air"

/datum/reagent/skill_elixir/miracle_water/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/miracle_water)

/datum/reagent/skill_elixir/miracle_water/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/miracle_water)

/datum/reagent/skill_elixir/vital_ichor
	name = "Vital Ichor"
	description = "A crimson, viscous liquid that pulses faintly. Blood sorcerers report a deepened sensitivity to the flows of vitae when they consume it."
	color = "#800020"
	glows = TRUE
	taste_description = "copper and living heat"
	scent_description = "iron and something ancient"

/datum/reagent/skill_elixir/vital_ichor/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/vital_ichor)

/datum/reagent/skill_elixir/vital_ichor/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/vital_ichor)

/datum/reagent/skill_elixir/arcane_solvent
	name = "Arcane Solvent"
	description = "A faintly luminous blue liquid that smells of ozone and dried herbs. Mages report that it makes the abstract feel immediately legible."
	color = "#2030c0"
	glows = TRUE
	taste_description = "charged air and something metallic"
	scent_description = "ozone and mana-bloom"

/datum/reagent/skill_elixir/arcane_solvent/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/arcane_solvent)

/datum/reagent/skill_elixir/arcane_solvent/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/arcane_solvent)

/datum/reagent/skill_elixir/wild_draught
	name = "Wild Draught"
	description = "A mossy, root-bitter tincture that sharpens attunement to natural patterns and subtle movements."
	color = "#306020"
	glows = FALSE
	taste_description = "forest floor and morning dew"
	scent_description = "moss, bark, and turned earth"

/datum/reagent/skill_elixir/wild_draught/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/wild_draught)

/datum/reagent/skill_elixir/wild_draught/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/wild_draught)

/datum/reagent/skill_elixir/athletes_brine
	name = "Athlete's Brine"
	description = "A salty, mineral-rich drink that sustains the body through extended physical effort."
	color = "#20a060"
	taste_description = "salt, electrolytes, and something grassy"
	scent_description = "sea air and effort"

/datum/reagent/skill_elixir/athletes_brine/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/athletes_brine)

/datum/reagent/skill_elixir/athletes_brine/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/athletes_brine)

/datum/reagent/skill_elixir/shadow_tonic
	name = "Shadow Tonic"
	description = "A thin, colourless tonic that dulls the sound of footsteps and sharpens peripheral vision."
	color = "#202020"
	taste_description = "nothing, almost exactly"
	scent_description = "barely anything at all"

/datum/reagent/skill_elixir/shadow_tonic/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/shadow_tonic)

/datum/reagent/skill_elixir/shadow_tonic/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/shadow_tonic)

/datum/reagent/skill_elixir/scholars_ink
	name = "Scholar's Ink"
	description = "A dark, faintly astringent drink that clears the mind for learning, memory, and complex thought."
	color = "#101840"
	taste_description = "bitter oak gall and something almost sweet"
	scent_description = "old books and fresh ink"

/datum/reagent/skill_elixir/scholars_ink/on_mob_metabolize(mob/living/L)
	. = ..()
	L.apply_status_effect(/datum/status_effect/buff/skill/scholars_ink)

/datum/reagent/skill_elixir/scholars_ink/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_status_effect(/datum/status_effect/buff/skill/scholars_ink)


/datum/status_effect/buff/skill
	alert_type = null

/datum/status_effect/buff/skill/blade_arts
	id = "skill_buff_blade_arts"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/blade_arts/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/blade_arts)

/datum/status_effect/buff/skill/blade_arts/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/blade_arts)

/datum/status_effect/buff/skill/heavy_arms
	id = "skill_buff_heavy_arms"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/heavy_arms/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/heavy_arms)

/datum/status_effect/buff/skill/heavy_arms/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/heavy_arms)

/datum/status_effect/buff/skill/whip_hand
	id = "skill_buff_whip_hand"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/whip_hand/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/whip_hand)

/datum/status_effect/buff/skill/whip_hand/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/whip_hand)

/datum/status_effect/buff/skill/marksmans_eye
	id = "skill_buff_marksmans_eye"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/marksmans_eye/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/marksmans_eye)

/datum/status_effect/buff/skill/marksmans_eye/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/marksmans_eye)

/datum/status_effect/buff/skill/shield_bearer
	id = "skill_buff_shield_bearer"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/shield_bearer/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/shield_bearer)

/datum/status_effect/buff/skill/shield_bearer/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/shield_bearer)

/datum/status_effect/buff/skill/craftsmans_wit
	id = "skill_buff_craftsmans_wit"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/craftsmans_wit/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/craftsmans_wit)

/datum/status_effect/buff/skill/craftsmans_wit/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/craftsmans_wit)

/datum/status_effect/buff/skill/smelters_patience
	id = "skill_buff_smelters_patience"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/smelters_patience/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/smelters_patience)

/datum/status_effect/buff/skill/smelters_patience/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/smelters_patience)

/datum/status_effect/buff/skill/builders_draught
	id = "skill_buff_builders_draught"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/builders_draught/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/builders_draught)

/datum/status_effect/buff/skill/builders_draught/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/builders_draught)

/datum/status_effect/buff/skill/trappers_sense
	id = "skill_buff_trappers_sense"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/trappers_sense/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/trappers_sense)

/datum/status_effect/buff/skill/trappers_sense/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/trappers_sense)

/datum/status_effect/buff/skill/alchemists_clarity
	id = "skill_buff_alchemists_clarity"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/alchemists_clarity/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/alchemists_clarity)

/datum/status_effect/buff/skill/alchemists_clarity/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/alchemists_clarity)

/datum/status_effect/buff/skill/smiths_blood
	id = "skill_buff_smiths_blood"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/smiths_blood/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/smiths_blood)

/datum/status_effect/buff/skill/smiths_blood/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/smiths_blood)

/datum/status_effect/buff/skill/skinners_elixir
	id = "skill_buff_skinners_elixir"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/skinners_elixir/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/skinners_elixir)

/datum/status_effect/buff/skill/skinners_elixir/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/skinners_elixir)

/datum/status_effect/buff/skill/locksmiths_oil
	id = "skill_buff_locksmiths_oil"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/locksmiths_oil/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/locksmiths_oil)

/datum/status_effect/buff/skill/locksmiths_oil/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/locksmiths_oil)

/datum/status_effect/buff/skill/cooks_brine
	id = "skill_buff_cooks_brine"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/cooks_brine/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/cooks_brine)

/datum/status_effect/buff/skill/cooks_brine/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/cooks_brine)

/datum/status_effect/buff/skill/prep_hands_tonic
	id = "skill_buff_prep_hands_tonic"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/prep_hands_tonic/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/prep_hands_tonic)

/datum/status_effect/buff/skill/prep_hands_tonic/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/prep_hands_tonic)

/datum/status_effect/buff/skill/brewers_wort
	id = "skill_buff_brewers_wort"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/brewers_wort/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/brewers_wort)

/datum/status_effect/buff/skill/brewers_wort/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/brewers_wort)

/datum/status_effect/buff/skill/seamstress_thimble_drop
	id = "skill_buff_seamstress_thimble_drop"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/seamstress_thimble_drop/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/seamstress_thimble_drop)

/datum/status_effect/buff/skill/seamstress_thimble_drop/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/seamstress_thimble_drop)

/datum/status_effect/buff/skill/miners_heart
	id = "skill_buff_miners_heart"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/miners_heart/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/miners_heart)

/datum/status_effect/buff/skill/miners_heart/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/miners_heart)

/datum/status_effect/buff/skill/farmers_almanac
	id = "skill_buff_farmers_almanac"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/farmers_almanac/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/farmers_almanac)

/datum/status_effect/buff/skill/farmers_almanac/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/farmers_almanac)

/datum/status_effect/buff/skill/beastwhisper
	id = "skill_buff_beastwhisper"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/beastwhisper/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/beastwhisper)

/datum/status_effect/buff/skill/beastwhisper/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/beastwhisper)

// --- MAGIC ---
/datum/status_effect/buff/skill/miracle_water
	id = "skill_buff_miracle_water"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/miracle_water/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/miracle_water)

/datum/status_effect/buff/skill/miracle_water/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/miracle_water)

/datum/status_effect/buff/skill/vital_ichor
	id = "skill_buff_vital_ichor"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/vital_ichor/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/vital_ichor)

/datum/status_effect/buff/skill/vital_ichor/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/vital_ichor)

/datum/status_effect/buff/skill/arcane_solvent
	id = "skill_buff_arcane_solvent"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/arcane_solvent/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/arcane_solvent)

/datum/status_effect/buff/skill/arcane_solvent/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/arcane_solvent)

/datum/status_effect/buff/skill/wild_draught
	id = "skill_buff_wild_draught"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/wild_draught/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/wild_draught)

/datum/status_effect/buff/skill/wild_draught/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/wild_draught)

// --- MISC ---
/datum/status_effect/buff/skill/athletes_brine
	id = "skill_buff_athletes_brine"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/athletes_brine/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/athletes_brine)

/datum/status_effect/buff/skill/athletes_brine/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/athletes_brine)

/datum/status_effect/buff/skill/shadow_tonic
	id = "skill_buff_shadow_tonic"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/shadow_tonic/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/shadow_tonic)

/datum/status_effect/buff/skill/shadow_tonic/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/shadow_tonic)

/datum/status_effect/buff/skill/scholars_ink
	id = "skill_buff_scholars_ink"
	duration = 10 MINUTES

/datum/status_effect/buff/skill/scholars_ink/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/scholars_ink)

/datum/status_effect/buff/skill/scholars_ink/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/scholars_ink)
