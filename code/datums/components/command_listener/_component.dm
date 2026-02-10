/datum/component/command_follower
	var/datum/follower_command/current_command
	var/atom/movable/screen/command_display/hud_element
	var/mob/living/carbon/human/owner
	var/list/order_priority = list(
		/datum/job/lord = 1,
		/datum/job/consort = 2,
		/datum/job/hand = 3,
		/datum/job/prince = 4,
		/datum/job/captain = 5,
		/datum/job/steward = 6,
		/datum/job/magician = 7,
		/datum/job/archivist = 8,
		/datum/job/courtphys = 9,
		/datum/job/minor_noble = 10,
		/datum/job/royalknight = 15,
		/datum/job/veteran = 16,
		/datum/job/lieutenant = 17,
		/datum/job/town_elder = 18,
		/datum/job/guardsman = 19,
		/datum/job/gatemaster = 19,
		/datum/job/jailor = 19,
		/datum/job/dungeoneer = 19,
		/datum/job/men_at_arms = 20,
		/datum/job/forestwarden = 20,
		/datum/job/forestguard = 20,
		/datum/job/priest = 25,
		/datum/job/inquisitor = 26,
		/datum/job/templar = 27,
		/datum/job/orthodoxist = 27,
		/datum/job/absolver = 27,
		/datum/job/monk = 28,
		/datum/job/adept = 28
	)

	var/list/available_commands = list(
		/datum/follower_command/custom,
		/datum/follower_command/protect,
		/datum/follower_command/kill,
		/datum/follower_command/guard_position,
		/datum/follower_command/follow,
	)

/datum/component/command_follower/Initialize(list/command_typepaths = list())
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	owner = parent

	for(var/command_path in command_typepaths)
		var/datum/follower_command/cmd = new command_path()
		available_commands[cmd.command_name] = command_path
		qdel(cmd)

	create_hud_element()
	RegisterSignal(parent, COMSIG_MOB_LOGIN, PROC_REF(on_login))
	RegisterSignal(parent, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_deleted))
	RegisterSignal(parent, COMSIG_PARENT_COMMAND_RECEIVED, PROC_REF(receive_command))
	RegisterSignal(parent, COMSIG_CLICK_CTRL, PROC_REF(on_ctrl_click))

/datum/component/command_follower/Destroy()
	clear_command()
	if(hud_element)
		QDEL_NULL(hud_element)
	available_commands = null
	owner = null
	return ..()

/datum/component/command_follower/proc/create_hud_element()
	hud_element = new()
	hud_element.screen_loc = "WEST+1,NORTH-1:14"
	if(owner?.client)
		owner.client.screen += hud_element
	update_hud()

/datum/component/command_follower/proc/on_login(datum/source)
	if(owner?.client && hud_element)
		owner.client.screen += hud_element
		update_hud()
	if(current_command)
		current_command.on_client_login(owner)

/datum/component/command_follower/proc/on_parent_deleted(datum/source)
	clear_command()

/datum/component/command_follower/proc/update_hud()
	if(!hud_element)
		return
	if(!current_command)
		hud_element.maptext = ""
		hud_element.alpha = 0
		return
	hud_element.alpha = 255
	var/command_text = "<span style='font-size:7px;color:#B87333;font-family:Small Fonts;'>"
	command_text += "Command: [current_command.command_name]<br>"
	command_text += "Issuer: [current_command.issuer_name]"
	command_text += "</span>"
	hud_element.maptext = command_text
	hud_element.maptext_width = 128
	hud_element.maptext_height = 32

/datum/component/command_follower/proc/receive_command(datum/source, datum/follower_command/new_command, mob/living/carbon/human/issuer)
	if(!new_command || !issuer)
		return FALSE
	if(current_command)
		var/current_priority = get_job_priority(current_command.issuer_job)
		var/new_priority = get_job_priority(issuer.job_type)
		if(new_priority > current_priority)
			owner.say("Command rejected: [issuer] lacks authority to override [current_command.issuer_name]'s command.", forced = TRUE)
	clear_command()
	current_command = new_command
	current_command.issuer_name = issuer.real_name
	current_command.issuer_job = issuer.job_type
	current_command.component = src
	current_command.execute(owner, issuer)
	update_hud()
	return TRUE

/datum/component/command_follower/proc/clear_command()
	if(current_command)
		current_command.terminate(owner)
		QDEL_NULL(current_command)
	update_hud()

/datum/component/command_follower/proc/get_job_priority(job_type)
	if(!job_type)
		return 999
	if(job_type in order_priority)
		return order_priority[job_type]
	return 999

/datum/component/command_follower/proc/on_ctrl_click(datum/source, mob/living/clicker)
	SIGNAL_HANDLER

	if(!length(available_commands))
		return
	if(!clicker.client)
		return

	// Check if clicker has authority
	var/clicker_priority = get_job_priority(clicker.job_type)
	if(clicker_priority >= 999)
		to_chat(clicker, span_warning("You lack the authority to issue commands."))
		return

	INVOKE_ASYNC(src, PROC_REF(show_command_menu), clicker)

/datum/component/command_follower/proc/show_command_menu(mob/living/clicker)
	var/list/choices = list()
	for(var/datum/follower_command/cmd_name as anything in available_commands)
		choices += initial(cmd_name.command_name)
		choices[initial(cmd_name.command_name)] = cmd_name

	var/choice = browser_input_list(clicker, "Select a command to issue to [owner]:", "Issue Command", choices)
	if(!choice)
		return

	var/command_path = choices[choice]
	var/datum/follower_command/new_cmd = new command_path()

	if(!new_cmd.post_setup(owner, clicker))
		qdel(new_cmd)
		return

	SEND_SIGNAL(owner, COMSIG_PARENT_COMMAND_RECEIVED, new_cmd, clicker)

/atom/movable/screen/command_display
	name = "Command Display"
