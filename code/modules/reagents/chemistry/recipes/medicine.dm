
/datum/chemical_reaction/ichor_of_mending
	name = "Ichor of Mending"
	id = "ichor_of_mending"
	required_reagents = list(
		/datum/reagent/medicine/healthpot = 5,
		/datum/reagent/ash = 3,
		/datum/reagent/medicine/rosawater = 5
	)
	results = list(/datum/reagent/medicine/ichor_of_mending = 13)
	mix_message = "The mixture thickens into a golden viscous ichor."

/datum/chemical_reaction/ashbinders_salve
	name = "Ashbinder's Salve"
	id = "ashbinders_salve"
	required_reagents = list(
		/datum/reagent/ash = 5,
		/datum/reagent/medicine/rosawater = 5,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/medicine/ashbinders_salve = 15)
	mix_message = "The mixture cools and darkens into a thick grey salve."

/datum/chemical_reaction/vitalroot_draught
	name = "Vitalroot Draught"
	id = "vitalroot_draught"
	required_reagents = list(
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/water = 5,
		/datum/reagent/medicine/rosawater = 5
	)
	results = list(/datum/reagent/medicine/vitalroot_draught = 15)
	mix_message = "The liquid takes on a vibrant green hue as it settles."

/datum/chemical_reaction/tombsilt_tincture
	name = "Tombsilt Tincture"
	id = "tombsilt_tincture"
	required_reagents = list(
		/datum/reagent/ash = 5,
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/mercury = 3
	)
	results = list(/datum/reagent/medicine/tombsilt_tincture = 13)
	mix_message = "The concoction turns a deep brownish grey as the ash settles into suspension."

/datum/chemical_reaction/mirewort_compress
	name = "Mirewort Compress"
	id = "mirewort_compress"
	required_reagents = list(
		/datum/reagent/water/gross = 5,
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/ash = 3
	)
	results = list(/datum/reagent/medicine/mirewort_compress = 13)
	mix_message = "The mixture takes on the murky green quality of bog water."

/datum/chemical_reaction/woundwrack_oil
	name = "Woundwrack Oil"
	id = "woundwrack_oil"
	required_reagents = list(
		/datum/reagent/water = 5,
		/datum/reagent/ash = 5,
		/datum/reagent/tree_sap = 3
	)
	results = list(/datum/reagent/medicine/woundwrack_oil = 13)
	mix_message = "The mixture separates briefly before fusing into a shimmering amber oil."

/datum/chemical_reaction/pale_serum
	name = "Pale Serum"
	id = "pale_serum"
	required_reagents = list(
		/datum/reagent/water = 5,
		/datum/reagent/mercury = 3,
		/datum/reagent/consumable/nutriment/bone_marrow = 5
	)
	results = list(/datum/reagent/medicine/pale_serum = 13)
	mix_message = "The mercury disperses into the solution, leaving a chalky white fluid."

/datum/chemical_reaction/crystalline_lymph
	name = "Crystalline Lymph"
	id = "crystalline_lymph"
	required_reagents = list(
		/datum/reagent/water = 5,
		/datum/reagent/medicine/manapot = 5,
		/datum/reagent/medicine/antidote = 3
	)
	results = list(/datum/reagent/medicine/crystalline_lymph = 13)
	mix_message = "The liquid shimmers and briefly becomes almost transparent before settling."

/datum/chemical_reaction/bloodelder_wine
	name = "Bloodelder Wine"
	id = "bloodelder_wine"
	required_reagents = list(
		/datum/reagent/blood = 5,
		/datum/reagent/medicine/healthpot = 5,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/medicine/bloodelder_wine = 15)
	mix_message = "The blood dissolves into the mixture, yielding a dark crimson wine."

/datum/chemical_reaction/nervebind_extract
	name = "Nervebind Extract"
	id = "nervebind_extract"
	required_reagents = list(
		/datum/reagent/medicine/soporpot = 5,
		/datum/reagent/water = 5,
		/datum/reagent/ash = 3
	)
	results = list(/datum/reagent/medicine/nervebind_extract = 13)
	mix_message = "The soporific thins into a cool purple fluid with a mild numbing scent."

/datum/chemical_reaction/sunpetal_decoction
	name = "Sunpetal Decoction"
	id = "sunpetal_decoction"
	required_reagents = list(
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/toxin/fyritiusnectar = 5,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/medicine/sunpetal_decoction = 13)
	mix_message = "The mix brightens to a warm golden yellow with a sweet floral scent."

/datum/chemical_reaction/stonevein_broth
	name = "Stonevein Broth"
	id = "stonevein_broth"
	required_reagents = list(
		/datum/reagent/medicine/healthpot = 5,
		/datum/reagent/mercury = 3,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/medicine/stonevein_broth = 13)
	mix_message = "The reagents fuse into a heavy, silvery-grey broth."

/datum/chemical_reaction/fever_oil
	name = "Fever Oil"
	id = "fever_oil"
	required_reagents = list(
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/toxin/plasma = 2,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/medicine/fever_oil = 12)
	mix_message = "The mix heats rapidly, releasing a spicy burning aroma."

/datum/chemical_reaction/witchknit_paste
	name = "Witchknit Paste"
	id = "witchknit_paste"
	required_reagents = list(
		/datum/reagent/ash = 5,
		/datum/reagent/consumable/ethanol/aqua_vitae = 5,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/medicine/witchknit_paste = 13)
	mix_message = "The ash dissolves unevenly into the rosawater, forming a pale grey paste."

/datum/chemical_reaction/mindclear_tonic
	name = "Mindclear Tonic"
	id = "mindclear_tonic"
	required_reagents = list(
		/datum/reagent/water = 5,
		/datum/reagent/medicine/manapot = 5,
		/datum/reagent/mercury = 3
	)
	results = list(/datum/reagent/medicine/mindclear_tonic = 13)
	mix_message = "The mixture briefly turns opaque before clearing into a cool teal fluid."

/datum/chemical_reaction/marrowbrew
	name = "Marrowbrew"
	id = "marrowbrew"
	required_reagents = list(
		/datum/reagent/medicine/healthpot = 5,
		/datum/reagent/medicine/stampot = 5,
		/datum/reagent/consumable/nutriment/bone_marrow = 3,
	)
	results = list(/datum/reagent/medicine/marrowbrew = 13)
	mix_message = "The reagents emulsify into a rich, cream-coloured broth."

/datum/chemical_reaction/spiritwood_elixir
	name = "Spiritwood Elixir"
	id = "spiritwood_elixir"
	required_reagents = list(
		/datum/reagent/medicine/healthpot = 5,
		/datum/reagent/medicine/rosawater = 5,
		/datum/reagent/medicine/manapot = 5
	)
	results = list(/datum/reagent/medicine/spiritwood_elixir = 15)
	mix_message = "The three reagents spiral together in pale green light before settling into an elixir."

/datum/chemical_reaction/coldvein_compress
	name = "Coldvein Compress"
	id = "coldvein_compress"
	required_reagents = list(
		/datum/reagent/water = 5,
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/mercury = 3
	)
	results = list(/datum/reagent/medicine/coldvein_compress = 13)
	mix_message = "The solution drops sharply in temperature, exhaling a fine cold mist."

/datum/chemical_reaction/ashwarden_brew
	name = "Ashwarden Brew"
	id = "ashwarden_brew"
	required_reagents = list(
		/datum/reagent/ash = 5,
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/consumable/nutriment/bone_marrow = 2
	)
	results = list(/datum/reagent/medicine/ashwarden_brew = 12)
	mix_message = "The brew darkens to near-black, releasing a sulphurous cloud."

/datum/chemical_reaction/thornmorrow_tincture
	name = "Thornmorrow Tincture"
	id = "thornmorrow_tincture"
	required_reagents = list(
		/datum/reagent/thorn_essence = 5,
		/datum/reagent/medicine/antidote = 5,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/medicine/thornmorrow_tincture = 15)
	mix_message = "The tincture darkens to a deep forest green and thickens slowly."

/datum/chemical_reaction/blistergall
	name = "Blistergall"
	id = "blistergall"
	required_reagents = list(
		/datum/reagent/medicine/soporpot = 3,
		/datum/reagent/toxin/venom = 5,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/poison/blistergall = 13)
	mix_message = "The mixture boils with a caustic hiss before settling into a neon green slurry."

/datum/chemical_reaction/ashfall_dust
	name = "Ashfall Dust"
	id = "ashfall_dust"
	required_reagents = list(
		/datum/reagent/ash = 7,
		/datum/reagent/toxin/plasma = 3
	)
	results = list(/datum/reagent/poison/ashfall_dust = 10)
	mix_message = "The ash absorbs the purple aetherium, solidifying into a fine scorched powder."

/datum/chemical_reaction/gloomvenom
	name = "Gloomvenom"
	id = "gloomvenom"
	required_reagents = list(
		/datum/reagent/toxin/venom = 5,
		/datum/reagent/toxin/fentanyl = 5,
		/datum/reagent/water = 3)
	results = list(/datum/reagent/poison/gloomvenom = 13)
	mix_message = "The venom and fentanyl fuse into a deep purple, slightly luminescent fluid."

/datum/chemical_reaction/rotwater
	name = "Rotwater"
	id = "rotwater"
	required_reagents = list(
		/datum/reagent/water/gross = 7,
		/datum/reagent/toxin/amatoxin = 3,
		/datum/reagent/toxin/bad_food = 3
	)
	results = list(/datum/reagent/poison/rotwater = 13)
	mix_message = "The ingredients slurry together into a revolting brown sludge."

/datum/chemical_reaction/hexblood_poison
	name = "Hexblood Poison"
	id = "hexblood_poison"
	required_reagents = list(
		/datum/reagent/blood = 5,
		/datum/reagent/toxin/venom = 5,
		/datum/reagent/ash = 3
	)
	results = list(/datum/reagent/poison/hexblood_poison = 13)
	mix_message = "The blood ignites briefly in the mixture before darkening into a thick, clotted poison."

/datum/chemical_reaction/mirrorwaste
	name = "Mirrorwaste"
	id = "mirrorwaste"
	required_reagents = list(
		/datum/reagent/mercury = 5,
		/datum/reagent/toxin/manabloom_juice = 5,
		/datum/reagent/water = 3
	)
	results = list(/datum/reagent/poison/mirrorwaste = 13)
	mix_message = "The mercury and mana-laced juice merge into a rippling silver liquid."

/datum/chemical_reaction/ironblight
	name = "Ironblight"
	id = "ironblight"
	required_reagents = list(
		/datum/reagent/mercury = 5,
		/datum/reagent/toxin/fyritiusnectar = 5,
		/datum/reagent/toxin/plasma = 2
	)
	results = list(/datum/reagent/poison/ironblight = 12)
	mix_message = "The reagents combine into a pitch-black fluid that immediately starts corroding the container slightly."

/datum/chemical_reaction/blinding_spore
	name = "Blinding Spore"
	id = "blinding_spore"
	required_reagents = list(
		/datum/reagent/toxin/amatoxin = 5,
		/datum/reagent/ash = 7
	)
	results = list(/datum/reagent/poison/blinding_spore = 12)
	mix_message = "The mixture desiccates rapidly into a fine pale powder."

/datum/chemical_reaction/heatcramp_oil
	name = "Heatcramp Oil"
	id = "heatcramp_oil"
	required_reagents = list(
		/datum/reagent/toxin/venom = 5,
		/datum/reagent/toxin/fyritiusnectar = 3,
		/datum/reagent/water = 5
	)
	results = list(/datum/reagent/poison/heatcramp_oil = 13)
	mix_message = "The mixture grows scalding hot, releasing a sharp peppery aroma."

/datum/chemical_reaction/mirelung_brew
	name = "Mirelung Brew"
	id = "mirelung_brew"
	required_reagents = list(
		/datum/reagent/water/gross = 5,
		/datum/reagent/toxin/venom = 5,
		/datum/reagent/toxin/bad_food = 3
	)
	results = list(/datum/reagent/poison/mirelung_brew = 13)
	mix_message = "The brew settles into a swampy green-brown fluid with a stagnant smell."

/datum/chemical_reaction/quietdeath
	name = "Quietdeath"
	id = "quietdeath"
	required_reagents = list(
		/datum/reagent/toxin/amanitin = 5,
		/datum/reagent/water = 7,
		/datum/reagent/mercury = 3
	)
	results = list(/datum/reagent/poison/quietdeath = 15)
	mix_message = "The mixture turns completely clear with barely a sound — not even a bubble."

/datum/chemical_reaction/soulbane_ichor
	name = "Soulbane Ichor"
	id = "soulbane_ichor"
	required_reagents = list(
		/datum/reagent/toxin/venom = 5,
		/datum/reagent/blood = 5,
		/datum/reagent/toxin/amatoxin = 5
	)
	results = list(/datum/reagent/poison/soulbane_ichor = 15)
	mix_message = "The reagents collapse into a lightless black ichor that seems to absorb nearby illumination."
