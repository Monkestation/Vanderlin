/atom/movable/screen/controller_ui
	icon = 'icons/hud/rts_mob_hud.dmi'

/atom/movable/screen/controller_ui/controller_ui
	screen_loc = "WEST,SOUTH"
	icon = null

	var/atom/movable/screen/controller_ui/character_pane/character
	var/atom/movable/screen/controller_ui/name_pane/name_box
	var/atom/movable/screen/controller_ui/task_pane/task
	var/atom/movable/screen/controller_ui/stat_pane/stat

	var/atom/movable/screen/controller_ui/controller_button/one/button_one
	var/atom/movable/screen/controller_ui/controller_button/two/button_two
	var/atom/movable/screen/controller_ui/controller_button/mob_exit/mob_exit
	var/atom/movable/screen/controller_ui/controller_button/patrol/patrol_button

	var/mob/living/worker_mob
	var/datum/worker_mind/worker_mind

/atom/movable/screen/controller_ui/controller_ui/New(mob/living/worker, datum/worker_mind/creation_source)
	. = ..()
	worker_mob = worker
	worker_mind = creation_source
	create_and_position_buttons()

/atom/movable/screen/controller_ui/controller_ui/Destroy(force)
	QDEL_NULL(character)
	QDEL_NULL(name_box)
	QDEL_NULL(task)
	QDEL_NULL(stat)
	QDEL_NULL(button_one)
	QDEL_NULL(button_two)
	QDEL_NULL(mob_exit)
	QDEL_NULL(patrol_button)
	worker_mind = null
	worker_mob = null
	return ..()

/atom/movable/screen/controller_ui/controller_ui/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("screen_loc")
			update_screen_loc(var_value)
			return TRUE

	return ..()

/atom/movable/screen/controller_ui/controller_ui/proc/add_ui(client/client)
	if(!client)
		return
	update_all()
	client.screen += character
	client.screen += name_box
	client.screen += task
	client.screen += stat
	client.screen += button_one
	client.screen += button_two
	client.screen += mob_exit
	client.screen += patrol_button

/atom/movable/screen/controller_ui/controller_ui/proc/remove_ui(client/client)
	if(!client)
		return
	update_all()
	client.screen -= character
	client.screen -= name_box
	client.screen -= task
	client.screen -= stat
	client.screen -= button_one
	client.screen -= button_two
	client.screen -= mob_exit
	client.screen -= patrol_button

/atom/movable/screen/controller_ui/controller_ui/proc/create_and_position_buttons()
	character = new
	name_box = new
	task = new
	stat = new
	button_one = new

	button_two = new
	mob_exit = new

	patrol_button = new
	patrol_button.parent_ui = src

	update_screen_loc()
	update_all()

/atom/movable/screen/controller_ui/controller_ui/proc/update_screen_loc(new_loc)
	if(new_loc)
		screen_loc = new_loc

	character.screen_loc = screen_loc
	name_box.screen_loc = screen_loc
	task.screen_loc = screen_loc
	stat.screen_loc = screen_loc
	button_one.screen_loc = screen_loc
	button_two.screen_loc = screen_loc
	mob_exit.screen_loc = screen_loc
	patrol_button.screen_loc = screen_loc

/atom/movable/screen/controller_ui/controller_ui/proc/update_all()
	update_character_visual()
	update_task_text()
	update_name_text()
	update_stat_text()

/atom/movable/screen/controller_ui/controller_ui/proc/update_text()
	update_task_text()
	update_name_text()
	update_stat_text()

/atom/movable/screen/controller_ui/controller_ui/proc/update_character_visual()
	var/mutable_appearance/MA = mutable_appearance()
	MA.appearance = worker_mob.appearance

	var/matrix/transform_matrix = matrix()
	transform_matrix.Scale(2, 2)
	MA.transform = transform_matrix

	MA.plane = plane
	MA.layer = layer + 0.1

	MA.pixel_y = 36
	MA.pixel_x = 126

	character.cut_overlays()
	character.add_overlay(MA)

/atom/movable/screen/controller_ui/controller_ui/proc/update_task_text()
	var/task_text = "Idle"
	if(worker_mind.attack_mode?.current_target)
		task_text = "Attacking [worker_mind.attack_mode.current_target]"
	else if(worker_mind.current_task)
		task_text = "[worker_mind.current_task.name]"
	task.maptext = MAPTEXT_CENTER(task_text)

/atom/movable/screen/controller_ui/controller_ui/proc/update_name_text()
	name_box.maptext = MAPTEXT_BLACKMOOR("<span style='font-size: 12pt'>[worker_mind.worker_name]</span>")

/atom/movable/screen/controller_ui/controller_ui/proc/update_stat_text()
	stat.maptext = MAPTEXT_CENTER("Stamina: [worker_mind.current_stamina]\nWorkspeed: [worker_mind.work_speed]")

/atom/movable/screen/controller_ui/character_pane
	icon_state = "character_preview"

/atom/movable/screen/controller_ui/name_pane
	icon_state = "name"
	maptext_x = 206
	maptext_width = 120
	maptext_height = 32
	maptext_y = 64

/atom/movable/screen/controller_ui/task_pane
	icon_state = "task"
	maptext_x = 201
	maptext_width = 128
	maptext_height = 16
	maptext_y = 16

/atom/movable/screen/controller_ui/stat_pane
	icon_state = "stats"
	maptext_x = 346
	maptext_y = 62
	maptext_width = 128
	maptext_height = 32

/atom/movable/screen/controller_ui/controller_button
	icon_state = "blank_first"
	var/highlighted = FALSE
	var/highlight_color

/atom/movable/screen/controller_ui/controller_button/MouseExited()
	if(!usr.client)
		return

	. = ..()
	color = null
	if(highlighted)
		color = highlight_color

/atom/movable/screen/controller_ui/controller_button/MouseEntered(location,control,params)
	if(!usr.client)
		return

	. = ..()
	color = "#f0efab"
