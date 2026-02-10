/datum/follower_command/kill
	command_name = "Kill"
	var/target_name = ""
	var/list/target_images = list()
	var/datum/callback/update_timer

/datum/follower_command/kill/post_setup(mob/living/carbon/human/automaton, mob/living/issuer)
	target_name = browser_input_text(issuer, "Enter the name of the target to eliminate:", "Kill Target", max_length = MAX_NAME_LEN)
	if(!target_name)
		return FALSE
	return TRUE

/datum/follower_command/kill/execute(mob/living/carbon/human/automaton, mob/living/issuer)
	update_overlays(automaton)
	update_timer = addtimer(CALLBACK(src, PROC_REF(update_overlays), automaton), 5 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)

/datum/follower_command/kill/terminate(mob/living/carbon/human/automaton)
	if(update_timer)
		deltimer(update_timer)
	clear_overlays(automaton)

/datum/follower_command/kill/on_client_login(mob/living/carbon/human/automaton)
	update_overlays(automaton)

/datum/follower_command/kill/proc/update_overlays(mob/living/carbon/human/automaton)
	if(!automaton?.client)
		return

	clear_overlays(automaton)

	for(var/mob/living/target in GLOB.player_list)
		if(!target.client)
			continue
		if(!findtext(target.real_name, target_name) && !findtext(target.name, target_name))
			continue

		var/image/overlay = image('icons/effects/effects.dmi', target, "scanline")
		overlay.color = "#FF0000"
		overlay.alpha = 120
		overlay.blend_mode = BLEND_INSET_OVERLAY
		overlay.appearance_flags = RESET_COLOR | RESET_ALPHA | KEEP_TOGETHER
		overlay.layer = ABOVE_MOB_LAYER
		overlay.plane = GAME_PLANE_FOV_HIDDEN

		automaton.client.images += overlay
		target_images += overlay

/datum/follower_command/kill/proc/clear_overlays(mob/living/carbon/human/automaton)
	if(!automaton?.client)
		return

	for(var/image/img in target_images)
		automaton.client.images -= img
	target_images.Cut()

/datum/follower_command/kill/Destroy()
	if(update_timer)
		deltimer(update_timer)
	target_images = null
	return ..()
