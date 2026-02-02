/datum/persistant_workorder/sew_clothes
    name = "Sew Clothes"
    ui_icon = 'icons/roguetown/items/natural.dmi'
    ui_icon_state = "cloth"
    work_type = /datum/work_order/sew_clothes

/datum/persistant_workorder/sew_clothes/apply_to_worker(mob/living/worker)
    arg_1 = pick(created_node.workspots)
    arg_2 = created_node
    . = ..()
