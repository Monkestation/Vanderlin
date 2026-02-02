/datum/persistant_workorder/farm
	name = "Farm"
	ui_icon = 'icons/roguetown/items/produce.dmi'
	work_type = /datum/work_order/farm_food


/datum/persistant_workorder/farm/apply_to_worker(mob/living/worker)
	arg_1 = pick(created_node.workspots)
	arg_3 = created_node
	. = ..()

/datum/persistant_workorder/farm/grain
	name = "Farm Grains"
	ui_icon_state = "oatchaff"

	arg_2 = "Grain"

/datum/persistant_workorder/farm/fruit
	name = "Farm Fruits"
	ui_icon_state = "apple"

	arg_2 = "Fruit"

/datum/persistant_workorder/farm/vegetable
	name = "Farm Vegetables"
	ui_icon_state = "cabbage"

	arg_2 = "Vegetable"
