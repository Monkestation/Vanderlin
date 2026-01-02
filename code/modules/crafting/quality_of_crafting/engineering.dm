/datum/repeatable_crafting_recipe/engineering
	abstract_type = /datum/repeatable_crafting_recipe/engineering
	skillcraft = /datum/skill/craft/engineering
	category = "Artificing"
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/engineering/shaft
	name = "wooden shaft"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/rotation_contraption/shaft
	output_amount = 12
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/cog
	name = "cogwheel"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/ingot/bronze = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/rotation_contraption/cog
	output_amount = 5
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/waterwheel
	name = "waterwheel"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/natural/wood/plank = 4,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/rotation_contraption/waterwheel
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/large_cog
	name = "large cogwheel"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/ingot/bronze = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/rotation_contraption/large_cog
	output_amount = 3
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/gearbox
	name = "gearbox"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/natural/wood/plank = 2,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/rotation_contraption/horizontal
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/vertical_gearbox
	name = "vertical gearbox"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/natural/wood/plank = 2,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/rotation_contraption/vertical
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/rails
	name = "minecart rails"
	requirements = list(
		/obj/item/grown/log/tree/stick= 1,
		/obj/item/ingot/iron = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/iron
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/minecart_rail
	output_amount = 10
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/railbreak
	name = "minecart rail break"
	requirements = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/ingot/iron = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/iron
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/minecart_rail/railbreak
	output_amount = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/water_pipe
	name = "fluid transport pipe"
	requirements = list(
		/obj/item/ingot/bronze = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/water_pipe
	output_amount = 12
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/minecart
	name = "minecart"
	requirements = list(
		/obj/item/ingot/iron = 3,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/iron
	starting_atom = /obj/item/weapon/hammer
	output = /obj/structure/closet/crate/miningcar
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/boiler
	name = "boiler"
	requirements = list(
		/obj/item/ingot/copper = 3,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/copper
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/boiler
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/pump
	name = "liquid pump"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/ingot/bronze = 2,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/rotation_contraption/pump
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/water_vent
	name = "fluid vent"
	requirements = list(
		/obj/item/ingot/bronze = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/water_vent
	output_amount = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/sprinkler
	name = "sprinkler"
	requirements = list(
		/obj/item/ingot/bronze = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/sprinkler
	output_amount = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/pressurizer
	name = "pressurizer"
	requirements = list(
		/obj/item/ingot/bronze = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/pressurizer
	output_amount = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/drain
	name = "drain"
	requirements = list(
		/obj/item/ingot/bronze = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/drain
	output_amount = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/engineering/steam_recharger
	name = "steam recharger"
	requirements = list(
		/obj/item/ingot/bronze = 2,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(span_notice("starts to hammer"), span_notice("start to hammer"), 'sound/items/bsmith2.ogg'),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/rotation_contraption/steam_recharger
	craft_time = 5 SECONDS