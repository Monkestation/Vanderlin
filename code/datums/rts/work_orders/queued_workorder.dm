/obj/effect/visual_effect/turf_break
	name = ""
	icon = 'icons/effects/alphacolors.dmi'
	icon_state = "blue"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/turf/turf_to_break

/obj/effect/visual_effect/turf_break/Initialize(mapload, ...)
	. = ..()
	turf_to_break = loc
	RegisterSignal(turf_to_break, COMSIG_PARENT_QDELETING, PROC_REF(clean_up))
	RegisterSignal(turf_to_break, COMSIG_CANCEL_TURF_BREAK, PROC_REF(clean_up))

/obj/effect/visual_effect/turf_break/proc/clean_up()
	turf_to_break.break_overlay = null
	UnregisterSignal(turf_to_break, COMSIG_PARENT_QDELETING)
	turf_to_break = null
	qdel(src)

/turf
	var/obj/effect/visual_effect/turf_break/break_overlay

/proc/create_turf_break_overlay(turf/breaking_turf)
	breaking_turf.break_overlay = new /obj/effect/visual_effect/turf_break(breaking_turf)

/datum/queued_workorder
	var/datum/work_order/work_path
	var/mob/camera/strategy_controller/master

	var/arg_1
	var/arg_2
	var/arg_3
	var/arg_4

/datum/queued_workorder/New(datum/work_order/work_path, mob/living/master, arg1, arg2, arg3, arg4)
	. = ..()
	src.master = master
	src.work_path = work_path
	src.arg_1 = arg1
	src.arg_2 = arg2
	src.arg_3 = arg3
	src.arg_4 = arg4

	if(ispath(work_path, /datum/work_order/break_turf))
		create_turf_break_overlay(arg1)
		RegisterSignal(arg1, COMSIG_CANCEL_TURF_BREAK, PROC_REF(clean_up))

/datum/queued_workorder/proc/clean_up()
	master?.in_progress_workorders -= src
	master = null
	qdel(src)
