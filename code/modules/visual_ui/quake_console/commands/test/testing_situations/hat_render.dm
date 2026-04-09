/datum/test_situation/hat_test
	start = "hat_test"

	var/static/list/created_mobs = list()
	var/static/timer

	var/static/last_dir = NORTH



/datum/test_situation/hat_test/execute_test(obj/abstract/visual_ui_element/scrollable/console_output/output, list/arg_list)
	. = ..()
	if(length(created_mobs))
		for(var/mob/mob in created_mobs)
			created_mobs -= mob
			qdel(mob)
		return

	var/mob/living/starter = output.get_user()

	var/turf/start_turf = get_turf(starter)

	var/step = 0
	var/y_step = 0
	var/turf/spawn_turf = start_turf
	for(var/obj/item/clothing/head/hat as anything in subtypesof(/obj/item/clothing/head))
		if(IS_ABSTRACT(hat))
			continue
		step++
		if(step > 13)
			spawn_turf = start_turf
			step =0
			y_step++
			for(var/i = 1 to y_step)
				spawn_turf = get_step(spawn_turf, NORTH)
		else
			spawn_turf = get_step(spawn_turf, EAST)


		var/mob/living/carbon/human/species/human/northern/human = new(spawn_turf)
		var/obj/item/clothing/head/new_hat = new hat(get_turf(human))
		human.equip_to_appropriate_slot(new_hat)
		human.skin_tone = "#9d8d6e"
		human.set_hair_style(/datum/sprite_accessory/hair/head/warrior, FALSE)
		human.set_hair_color("#aca918", FALSE)
		human.set_facial_hair_style(/datum/sprite_accessory/hair/facial/none)
		human.real_name = initial(hat.name)
		human.name = initial(hat.name)
		created_mobs |= human

	timer = addtimer(CALLBACK(src, PROC_REF(spin_humans)), 5 SECONDS, TIMER_LOOP)

/datum/test_situation/hat_test/proc/spin_humans()
	if(!length(created_mobs))
		deltimer(timer)
		timer = null
		last_dir = NORTH
		return


	switch(last_dir) //could just use GLOB.cardinals but its not in the order I like.
		if(NORTH)
			last_dir = EAST
		if(EAST)
			last_dir = SOUTH
		if(SOUTH)
			last_dir = WEST
		if(WEST)
			last_dir = NORTH

	for(var/mob/mob as anything in created_mobs)
		mob.dir = last_dir
