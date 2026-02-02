/datum/alch_grind_recipe
	var/picky = TRUE // if TRUE: the item path MUST MATCH, and cannot be a subtype.
	var/valid_input = null //the typepath that, when ground, makes an output
	var/list/valid_outputs = list() //List of [Itempath = amnt?1] to be created always
	var/list/bonus_chance_outputs = list() //List of [Itempath = chance/100] to create sometimes.

/datum/alch_grind_recipe/sinew
	valid_input = /obj/item/alch/sinew
	valid_outputs = list(/obj/item/alch/viscera = 1)
	bonus_chance_outputs = list(/obj/item/alch/viscera = 75)

//Objects -> dusts
/datum/alch_grind_recipe/crow
	valid_input = /obj/item/reagent_containers/food/snacks/crow
	valid_outputs = list(/obj/item/alch/airdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 33, /obj/item/fertilizer/bone_meal = 33)

/datum/alch_grind_recipe/bone
	valid_input = /obj/item/alch/bone
	valid_outputs = list( /obj/item/fertilizer/bone_meal = 2)
	bonus_chance_outputs = list(/obj/item/fertilizer/bone_meal = 50)

/datum/alch_grind_recipe/horn
	valid_input = /obj/item/alch/horn
	valid_outputs = list(/obj/item/alch/earthdust = 1, /obj/item/fertilizer/bone_meal = 2)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 66)

/datum/alch_grind_recipe/fish
	picky = FALSE
	valid_input = /obj/item/reagent_containers/food/snacks/fish
	valid_outputs = list(/obj/item/alch/waterdust = 2) // makes fish worth buying , fisher/apothecary combo
	bonus_chance_outputs = list(/obj/item/alch/waterdust = 25 ,/obj/item/fertilizer/bone_meal = 33)

/datum/alch_grind_recipe/leech
	picky = FALSE
	valid_input = /obj/item/natural/worms/leech
	valid_outputs = list(/obj/item/alch/waterdust = 1) //easy source of waterdust
	bonus_chance_outputs = list(/obj/item/alch/waterdust = 10)

/datum/alch_grind_recipe/worm
	valid_input = /obj/item/natural/worms
	valid_outputs = list(/obj/item/alch/earthdust = 1) //easy source of earthdust
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 10)

/datum/alch_grind_recipe/swampweed
	valid_input = /obj/item/reagent_containers/food/snacks/produce/swampweed
	valid_outputs = list(/obj/item/alch/swampdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 33)

/datum/alch_grind_recipe/swampweed_dried
	valid_input = /obj/item/reagent_containers/food/snacks/produce/swampweed_dried
	valid_outputs = list(/obj/item/alch/swampdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/earthdust = 50,/obj/item/alch/swampdust = 50)

/datum/alch_grind_recipe/westleach
	valid_input = /obj/item/reagent_containers/food/snacks/produce/westleach
	valid_outputs = list(/obj/item/alch/tobaccodust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 33)

/datum/alch_grind_recipe/dry_westleach
	valid_input = /obj/item/reagent_containers/food/snacks/produce/dry_westleach
	valid_outputs = list(/obj/item/alch/tobaccodust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust = 50,/obj/item/alch/tobaccodust = 50)

/datum/alch_grind_recipe/fyritius
	valid_input = /obj/item/reagent_containers/food/snacks/produce/fyritius
	valid_outputs = list(/obj/item/alch/firedust = 1)
	bonus_chance_outputs = list(/obj/item/alch/firedust = 50)

/datum/alch_grind_recipe/poppy
	valid_input = /obj/item/reagent_containers/food/snacks/produce/poppy
	valid_outputs = list(/obj/item/reagent_containers/powder/ozium = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =33 ,/obj/item/alch/earthdust = 33, /obj/item/reagent_containers/powder/ozium = 10)

/datum/alch_grind_recipe/manabloom
	valid_input = /obj/item/reagent_containers/food/snacks/produce/manabloom
	valid_outputs = list(/obj/item/reagent_containers/powder/manabloom = 1)
	bonus_chance_outputs = list(/obj/item/reagent_containers/powder/manabloom =33, /obj/item/alch/runedust= 33)

/datum/alch_grind_recipe/seeds
	picky = FALSE
	valid_input = /obj/item/neuFarm/seed
	valid_outputs = list(/obj/item/alch/seeddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/airdust =25,/obj/item/alch/earthdust = 25)

/datum/alch_grind_recipe/ozium
	valid_input = /obj/item/reagent_containers/powder/ozium
	valid_outputs = list(/obj/item/alch/ozium = 1)
	bonus_chance_outputs = list(/obj/item/alch/ozium = 50)

//Ores -> dust
/datum/alch_grind_recipe/gold_ore
	valid_input = /obj/item/ore/gold
	valid_outputs = list(/obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 33)

/datum/alch_grind_recipe/silver_ore
	valid_input = /obj/item/ore/silver
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33)

/datum/alch_grind_recipe/iron_ore
	valid_input = /obj/item/ore/iron
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/irondust = 33)

/datum/alch_grind_recipe/coal_ore
	valid_input = /obj/item/ore/coal
	valid_outputs = list(/obj/item/alch/coaldust = 1)
	bonus_chance_outputs = list(/obj/item/alch/coaldust = 33)

/datum/alch_grind_recipe/charcoal_ore
	valid_input = /obj/item/ore/coal/charcoal
	valid_outputs = list(/obj/item/alch/coaldust = 1)
	bonus_chance_outputs = list(/obj/item/alch/coaldust = 33)

/datum/alch_grind_recipe/gold_bar
	valid_input = /obj/item/ingot/gold
	valid_outputs = list(/obj/item/alch/golddust = 1)
	bonus_chance_outputs = list(/obj/item/alch/golddust = 33)

/datum/alch_grind_recipe/silver_bar
	valid_input = /obj/item/ingot/silver
	valid_outputs = list(/obj/item/alch/silverdust = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust = 33)

/datum/alch_grind_recipe/iron_bar
	valid_input = /obj/item/ingot/iron
	valid_outputs = list(/obj/item/alch/irondust = 1)
	bonus_chance_outputs = list(/obj/item/alch/irondust = 33)

//Herb -> Herbseed
/datum/alch_grind_recipe/atropa_seed
	valid_input = /obj/item/alch/herb/atropa
	valid_outputs = list(/obj/item/neuFarm/seed/atropa = 1)

/datum/alch_grind_recipe/matricaria_seed
	valid_input = /obj/item/alch/herb/matricaria
	valid_outputs = list(/obj/item/neuFarm/seed/matricaria = 1)

/datum/alch_grind_recipe/symphitum_seed
	valid_input = /obj/item/alch/herb/symphitum
	valid_outputs = list(/obj/item/neuFarm/seed/symphitum = 1)

/datum/alch_grind_recipe/taraxacum_seed
	valid_input = /obj/item/alch/herb/taraxacum
	valid_outputs = list(/obj/item/neuFarm/seed/taraxacum = 1)

/datum/alch_grind_recipe/euphrasia_seed
	valid_input = /obj/item/alch/herb/euphrasia
	valid_outputs = list(/obj/item/neuFarm/seed/euphrasia = 1)

/datum/alch_grind_recipe/paris_seed
	valid_input = /obj/item/alch/herb/paris
	valid_outputs = list(/obj/item/neuFarm/seed/paris = 1)

/datum/alch_grind_recipe/calendula_seed
	valid_input = /obj/item/alch/herb/calendula
	valid_outputs = list(/obj/item/neuFarm/seed/calendula = 1)

/datum/alch_grind_recipe/mentha_seed
	valid_input = /obj/item/alch/herb/mentha
	valid_outputs = list(/obj/item/neuFarm/seed/mentha = 1)

/datum/alch_grind_recipe/urtica_seed
	valid_input = /obj/item/alch/herb/urtica
	valid_outputs = list(/obj/item/neuFarm/seed/urtica = 1)

/datum/alch_grind_recipe/salvia_seed
	valid_input = /obj/item/alch/herb/salvia
	valid_outputs = list(/obj/item/neuFarm/seed/salvia = 1)

/datum/alch_grind_recipe/hypericum_seed
	valid_input = /obj/item/alch/herb/hypericum
	valid_outputs = list(/obj/item/neuFarm/seed/hypericum = 1)

/datum/alch_grind_recipe/benedictus_seed
	valid_input = /obj/item/alch/herb/benedictus
	valid_outputs = list(/obj/item/neuFarm/seed/benedictus = 1)

/datum/alch_grind_recipe/valeriana_seed
	valid_input = /obj/item/alch/herb/valeriana
	valid_outputs = list(/obj/item/neuFarm/seed/valeriana = 1)

/datum/alch_grind_recipe/artemisia_seed
	valid_input = /obj/item/alch/herb/artemisia
	valid_outputs = list(/obj/item/neuFarm/seed/artemisia = 1)

/datum/alch_grind_recipe/rosa_seed
	valid_input = /obj/item/alch/herb/rosa
	valid_outputs = list(/obj/item/neuFarm/seed/rosa = 1)

/datum/alch_grind_recipe/euphorbia_seed
	valid_input = /obj/item/alch/herb/euphorbia
	valid_outputs = list(/obj/item/neuFarm/seed/euphorbia = 1)
