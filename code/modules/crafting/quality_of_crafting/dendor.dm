/datum/repeatable_crafting_recipe/dendor
	abstract_type = /datum/repeatable_crafting_recipe/dendor
	category = "Dendor"

/datum/repeatable_crafting_recipe/dendor/sacrifice_growing
	name = "green sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_gote
	starting_atom = /obj/item/natural/worms/grub_silk
	requirements = list(/obj/item/natural/worms/grub_silk = 1,
				/obj/item/reagent_containers/food/snacks/produce/swampweed = 1,
				/obj/item/reagent_containers/food/snacks/produce/poppy = 1)
	output = /obj/item/dendor_blessing/growing
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/sacrifice_tending
	name = "viridian sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_gote
	starting_atom = /obj/item/alch/herb/euphorbia
	requirements = list(/obj/item/alch/herb/euphorbia = 1,
				/obj/item/reagent_containers/food/snacks/produce/swampweed = 1,
				/obj/item/natural/thorn = 2)
	output = /obj/item/dendor_blessing/tending
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/sacrifice_stinging
	name = "yellow sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_saiga
	starting_atom = /obj/item/reagent_containers/food/snacks/fish/eel
	requirements = list(/obj/item/reagent_containers/food/snacks/fish/eel = 1,
				/obj/item/reagent_containers/food/snacks/produce/westleach = 1,
				/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1)
	output = /obj/item/dendor_blessing/stinging
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/sacrifice_hiding
	name = "citrine sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_saiga
	starting_atom = /obj/item/alch/herb/calendula
	requirements = list(/obj/item/alch/herb/calendula = 1,
				/obj/item/natural/fibers = 1,
				/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1)
	output = /obj/item/dendor_blessing/hiding
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/sacrifice_devouring
	name = "red sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_volf
	starting_atom = /obj/item/bait/bloody
	requirements = list(/obj/item/bait/bloody = 2)
	output = /obj/item/dendor_blessing/devouring
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/sacrifice_falconing
	name = "crimson sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_volf
	starting_atom = /obj/item/reagent_containers/food/snacks/egg
	requirements = list(/obj/item/reagent_containers/food/snacks/egg = 1,
				/obj/item/natural/feather = 2)
	output = /obj/item/dendor_blessing/falconing
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/sacrifice_lording
	name = "purple sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_troll
	starting_atom = /obj/item/alch/horn
	requirements = list(/obj/item/alch/horn = 2)
	output = /obj/item/dendor_blessing/lording
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/sacrifice_shaping
	name = "indigo sacrifice to Dendor (unique)"
	attacked_atom = /obj/structure/fluff/psycross/crafted/shrine/dendor_troll
	starting_atom = /obj/item/alch/sinew
	requirements = list(/obj/item/alch/sinew = 2,
				/obj/item/reagent_containers/food/snacks/meat/strange = 1)
	output = /obj/item/dendor_blessing/shaping
	crafting_sound = 'sound/foley/burning_sacrifice.ogg'

/datum/repeatable_crafting_recipe/dendor/shillelagh
	name = "Shillelagh (unique)"
	output = /obj/item/weapon/mace/goden/shillelagh
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/reagent_containers/food/snacks/fat
	requirements = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/fertilizer/ash = 1,
				/obj/item/reagent_containers/food/snacks/fat = 1)
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/dendor/forestdelight
	name = "forest guardian offering (unique)"
	starting_atom = /obj/item/bait/bloody
	attacked_atom = /obj/item/reagent_containers/food/snacks/produce/swampweed_dried
	requirements = list(/obj/item/bait/bloody = 1,
				/obj/item/reagent_containers/food/snacks/produce/swampweed_dried = 1,
				/obj/item/reagent_containers/food/snacks/raisins = 1 )
	output = /obj/item/bait/forestdelight
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/dendor/visage
	name = "druids mask (unique)"
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	requirements = list(/obj/item/grown/log/tree/small = 1)
	output = /obj/item/clothing/face/druid
	subtypes_allowed = TRUE
