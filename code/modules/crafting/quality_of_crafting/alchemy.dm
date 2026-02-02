/datum/repeatable_crafting_recipe/alchemy
	abstract_type = /datum/repeatable_crafting_recipe/alchemy
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0
	category = "Alchemy"

/datum/repeatable_crafting_recipe/alchemy/essence_connector
	name = "Pestran Connector"
	output = /obj/item/essence_connector
	requirements = list(
		/obj/item/ingot/thaumic = 1,
		/obj/item/natural/glass = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve out a rune", "start to carve a rune")
	)

	attacked_atom = /obj/item/ingot/thaumic
	starting_atom = /obj/item/weapon/knife
	subtypes_allowed = TRUE // so you can use any subtype of knife

/datum/repeatable_crafting_recipe/alchemy/essence_jar
	name = "Essence Node Jar"
	output = /obj/item/essence_node_jar
	requirements = list(
		/obj/item/ingot/thaumic = 1,
		/obj/item/natural/glass = 3,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve out a rune", "start to carve a rune")
	)

	attacked_atom = /obj/item/natural/glass
	starting_atom = /obj/item/weapon/knife
	subtypes_allowed = TRUE // so you can use any subtype of knife

/datum/repeatable_crafting_recipe/alchemy/essence_gauntlet
	name = "Essence Gauntlet"
	output = /obj/item/clothing/gloves/essence_gauntlet
	requirements = list(
		/obj/item/ingot/thaumic = 3,
		/obj/item/natural/glass = 4,
		/obj/item/mana_battery/mana_crystal = 2,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve out a rune", "start to carve a rune")
	)

	attacked_atom = /obj/item/natural/glass
	starting_atom = /obj/item/weapon/knife
	subtypes_allowed = TRUE // so you can use any subtype of knife

/datum/repeatable_crafting_recipe/alchemy/essence_vial
	name = "Essence Vial"
	output = /obj/item/essence_vial
	requirements = list(
		/obj/item/natural/glass = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve out a rune", "start to carve a rune")
	)

	attacked_atom = /obj/item/natural/glass
	starting_atom = /obj/item/weapon/knife
	subtypes_allowed = TRUE // so you can use any subtype of knife
	output_amount = 3

/datum/repeatable_crafting_recipe/alchemy/feau_dust
	name = "Feau Dust"
	output = /obj/item/alch/feaudust
	requirements = list(
		/obj/item/alch/golddust = 1,
		/obj/item/alch/irondust = 1,
	)
	tool_usage = list(
		/obj/item/pestle = list("starts to mix the dust together", "start to mix the dust together")
	)
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	starting_atom = /obj/item/pestle
	output_amount = 2
	craftdiff = 1

//a way to create thaumic iron without having to use a splitter. Not at all efficient, this simply exists so you can
//create alchemical machinery from scratch without admin intervention
/datum/repeatable_crafting_recipe/alchemy/thaumic_dust
	name = "Thaumic Iron Dust"
	output = /obj/item/alch/thaumicdust
	requirements = list(
		/obj/item/alch/firedust = 1,
		/obj/item/alch/irondust = 1,
		/obj/item/alch/feaudust = 1,//faedust as a sort of "catalyst" for the interaction
		/obj/item/alch/runedust = 1,

	)
	tool_usage = list(
		/obj/item/pestle = list("starts to mix the dust together", "start to mix the dust together")
	)
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	starting_atom = /obj/item/pestle
	output_amount = 1
	craftdiff = 3

//a way to get raw essentia other than rng by grinding down manablooms
//not a "good" way due to consuming a bunch of useful stuff for magicians and silver dust
//however, it's a guaranteed method of acquiring, which I believe justifies the costs
/datum/repeatable_crafting_recipe/alchemy/rune_dust
	name = "Raw Essentia"
	output = /obj/item/alch/runedust
	requirements = list(
		/obj/item/reagent_containers/powder/manabloom = 2,
		/obj/item/mana_battery/mana_crystal/small = 1,
		/obj/item/alch/silverdust = 1,
	)
	tool_usage = list(
		/obj/item/pestle = list("starts to grind the ingredients together", "start to grind the ingredients together")
	)
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	starting_atom = /obj/item/pestle
	output_amount = 2
	craftdiff = 3

//rather expensive crafting recipe
//you get more magic essence this way than if you just consumed rune dust
//but you need to "sacrifice" water, air, fire and earth dusts, which each give 20 of their respective essence
//is it worth it? Well that's for the alchemist to determine what they need more of
/datum/repeatable_crafting_recipe/alchemy/magic_dust
	name = "Pure Essentia"
	output = /obj/item/alch/magicdust
	requirements = list(
		/obj/item/alch/waterdust = 1,
		/obj/item/alch/airdust = 1,
		/obj/item/alch/firedust = 1,
		/obj/item/alch/earthdust = 1,
		/obj/item/alch/runedust = 1,
	)
	tool_usage = list(
		/obj/item/pestle = list("starts to mix the dust together", "start to mix the dust together")
	)
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	starting_atom = /obj/item/pestle
	output_amount = 1
	craftdiff = 4

//transis dust
//requires various herbs, like the original recipe
//in this case, I focused on those herbs with magic, order and cycle essence
//magic and order because that's what the dust gives when split
//cycle because cycle is the essence of change, which is what the transis dust does
/datum/repeatable_crafting_recipe/alchemy/transis_dust
	name = "Transis Dust"
	output = /obj/item/alch/transisdust
	requirements = list(
		/obj/item/alch/herb/matricaria = 1,
		/obj/item/alch/herb/taraxacum = 1,
		/obj/item/alch/herb/salvia = 1,
		/obj/item/alch/herb/hypericum = 1,
		/obj/item/alch/herb/benedictus = 1,
		/obj/item/reagent_containers/powder/manabloom = 1,
	)
	tool_usage = list(
		/obj/item/pestle = list("starts to grind and mix the herbs together", "start to grind and mix the herbs together")
	)
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	starting_atom = /obj/item/pestle
	output_amount = 1
	craftdiff = 4
