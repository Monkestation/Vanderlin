/datum/persistant_workorder/mine
	name = "Farm"
	ui_icon = 'icons/roguetown/items/ore.dmi'
	work_type = /datum/work_order/mine


/datum/persistant_workorder/mine/apply_to_worker(mob/living/worker)
	arg_1 = pick(created_node.workspots)
	arg_3 = created_node
	. = ..()

/datum/persistant_workorder/mine/ores
	name = "Mine Ores"
	ui_icon_state = "orecop1"

	arg_2 = MAT_ORE
	arg_4 = 30 SECONDS

/datum/persistant_workorder/mine/stones
	name = "Mine Stone"
	ui_icon = 'icons/roguetown/items/natural.dmi'
	ui_icon_state = "stone1"

	arg_2 = MAT_STONE
	arg_4 = 15 SECONDS

/datum/persistant_workorder/mine/coal
	name = "Mine Coal"
	ui_icon_state = "orecoal3"

	arg_2 = MAT_COAL
	arg_4 = 20 SECONDS


/datum/persistant_workorder/mine/gem
	name = "Mine Stone"
	ui_icon = 'icons/roguetown/items/natural.dmi'
	ui_icon_state = "iridescent_scale"

	arg_2 = MAT_GEM
	arg_4 = 45 SECONDS

