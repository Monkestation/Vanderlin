/datum/distillation_recipe/soulweave_distillate
	name = "Soulweave Distillate"
	id = "soulweave_distillate"
	distilled_reagent = /datum/reagent/medicine/pale_serum
	required_reagents = list(/datum/reagent/medicine/rosawater = 5)
	consume_reagents = TRUE
	results = list(/datum/reagent/medicine/soulweave_distillate = 1.5)
	required_temp = T0C + 150
	distill_message = "The pale serum and rosawater fuse into a faintly luminescent distillate."

/datum/distillation_recipe/mirrorwaste_refined
	name = "Refined Mirrorwaste"
	id = "mirrorwaste_refined"
	distilled_reagent = /datum/reagent/poison/mirrorwaste
	required_reagents = list(/datum/reagent/mercury = 3)
	consume_reagents = TRUE
	results = list(/datum/reagent/poison/mirrorwaste = 1.75)
	required_temp = T0C + 120
	distill_message = "The mercury burns off and the mirrorwaste concentrates into a purer form."

/datum/distillation_recipe/quietdeath_concentrated
	name = "Concentrated Quietdeath"
	id = "quietdeath_concentrated"
	distilled_reagent = /datum/reagent/poison/quietdeath
	required_reagents = list(/datum/reagent/toxin/amanitin = 3)
	consume_reagents = TRUE
	results = list(/datum/reagent/poison/quietdeath = 2.0)
	required_temp = T0C + 100
	distill_message = "The water evaporates away, leaving an even more potent concentrate behind."

/datum/distillation_recipe/vitalroot_distilled
	name = "Distilled Vitalroot"
	id = "vitalroot_distilled"
	distilled_reagent = /datum/reagent/medicine/vitalroot_draught
	required_reagents = list(/datum/reagent/medicine/rosawater = 5)
	consume_reagents = FALSE
	results = list(/datum/reagent/medicine/spiritwood_elixir = 1.25)
	required_temp = T0C + 130
	distill_message = "The vitalroot draught and rosawater condense through the heat into a spiritwood-like elixir."

/datum/distillation_recipe/gloomvenom_refined
	name = "Refined Gloomvenom"
	id = "gloomvenom_refined"
	distilled_reagent = /datum/reagent/poison/gloomvenom
	required_reagents = list(/datum/reagent/toxin/fentanyl = 3)
	consume_reagents = TRUE
	results = list(/datum/reagent/poison/gloomvenom = 1.75)
	required_temp = T0C + 110
	distill_message = "The venom concentrates through distillation, stripping impurities and deepening its violet hue."
