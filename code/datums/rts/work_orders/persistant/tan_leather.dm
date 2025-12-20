/datum/persistant_workorder/tan_leather
    name = "Tan Leather"
    ui_icon = 'icons/roguetown/items/natural.dmi'
    ui_icon_state = "leather"
    work_type = /datum/work_order/tan_leather

/datum/persistant_workorder/tan_leather/apply_to_worker(mob/living/worker)
    arg_1 = pick(created_node.workspots)
    arg_2 = created_node
    . = ..()
