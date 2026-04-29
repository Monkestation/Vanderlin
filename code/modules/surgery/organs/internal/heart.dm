/obj/item/organ/heart
	name = "heart"
	desc = "Following your HEART shall be the whole of LAW."
	icon_state = "heart"
	zone = BODY_ZONE_CHEST
	organ_efficiency = list(ORGAN_SLOT_HEART = 100)
	w_class = WEIGHT_CLASS_SMALL
	low_threshold_passed = span_info("Prickles of pain appear then die out from within my chest...")
	high_threshold_passed = span_warning("Something inside my chest hurts, and the pain isn't subsiding. I am breathing far faster than before.")
	now_fixed = span_info("My heart begins to beat again.")
	high_threshold_cleared = span_info("The pain in my chest has died down, and my breathing becomes more relaxed.")
	organ_volume = 0.5
	max_blood_storage = 100
	current_blood = 100
	blood_req = 10
	oxygen_req = 5
	nutriment_req = 3
	hydration_req = 1.5
	/// Have we been bypassed to avoid nasty blockages?
	var/open = FALSE
	/// If we're not beating that is not a good sign
	var/beating = TRUE
	/// Whether we've already triggered the failing message this cycle, to avoid spam
	var/failed = FALSE
	///convulsion sounds
	var/convulsion_sound = list('sound/emotes/convulse1.wav', 'sound/emotes/convulse2.wav')

	/// Markings on this heart for the maniac antagonist.
	/// Assoc list using Maniac antag datums as keys. One for each maniac, but not for each wonder.
	var/inscryptions = list()
	/// Assoc list tracking antag datums to 4-letter maniac keys
	var/inscryption_keys = list()
	/// Assoc list tracking antag datums to wonder ID number (1-4)
	var/maniacs2wonder_ids = list()
	/// List of Maniac datums that have inscribed on this heart
	var/maniacs = list()

	var/graggometer = 0

	///humors we have yet to attach to the body
	var/list/loose_humors = list()


	food_type = /obj/item/reagent_containers/food/snacks/meat/organ/heart

/obj/item/organ/heart/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(stop_if_unowned)), 8 SECONDS)

/obj/item/organ/heart/examine(mob/user)
	. = ..()
	if(IsAdminGhost(user) && inscryptions)
		for(var/datum/antagonist/maniac/maniaque in maniacs)
			var/N = maniaque.owner?.name
			var/W = LAZYACCESS(maniacs2wonder_ids, maniaque)
			var/P = LAZYACCESS(inscryptions, maniaque)
			. += span_notice("Marked by [N ? "[N]'s " : ""]Wonder[W ? " #[W]" : ""]: [P].")
		return .
	var/datum/antagonist/maniac/dreamer = user.mind?.has_antag_datum(/datum/antagonist/maniac)
	if(dreamer)
		if(!maniacs)
			. += "<span class='danger'><b>There is NOTHING on this heart. \
				Should be? Following the TRUTH - not here. I need to keep LOOKING. Keep FOLLOWING my heart.</b></span>"
		else
			if(!(dreamer in maniacs))
				. += "<span class='danger'><b>This heart has INDECIPHERABLE etching. \
					Following the TRUTH - not here. I need to keep LOOKING. Keep FOLLOWING my heart.</b></span>"
				return .
			var/my_inscryption = LAZYACCESS(inscryptions, dreamer)
			. += "<b><span class='warning'>There's something CUT on this HEART.</span>\n\"[my_inscryption]. Add it to the other keys to exit INRL.\"</b>"
			if(!(my_inscryption in dreamer.hearts_seen))
				var/wonder_code = LAZYACCESS(maniacs2wonder_ids, dreamer)
				dreamer.hearts_seen += my_inscryption
				SEND_SOUND(dreamer, 'sound/villain/newheart.ogg')
				user.log_message("got the Maniac inscryption [wonder_code ? " for Wonder #[wonder_code]" : ""][my_inscryption ? ": \"[STRIP_HTML_SIMPLE(my_inscryption, MAX_MESSAGE_LEN)].\"" : ""]", LOG_GAME)
				if(wonder_code == 4)
					message_admins("Maniac [ADMIN_LOOKUPFLW(user)] has obtained the fourth and final heart code.")

	var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
	if(chimeric)
		. += span_notice("This heart has been transformed.")
		if(chimeric.failed)
			. += span_warning("The chimeric organ has failed.")
		if(length(chimeric.inputs) || length(chimeric.outputs) || length(chimeric.partnerless_inputs) || length(chimeric.partnerless_outputs))
			var/list/stitched = list()
			for(var/datum/chimeric_node/node in chimeric.inputs + chimeric.partnerless_inputs)
				stitched += node.name
			for(var/datum/chimeric_node/node in chimeric.outputs + chimeric.partnerless_outputs)
				stitched += node.name
			. += span_notice("You can see a few humors stitched to [src], [english_list(stitched)].")
	if(length(loose_humors))
		var/list/loose_names = list()
		for(var/obj/item/chimeric_node/node in loose_humors)
			loose_names += node.name
		. += span_warning("You can see a few humors loosely pressed against [src], [english_list(loose_names)].")

/obj/item/organ/heart/is_working()
	if(owner)
		return (..() && beating)
	return ..()

/obj/item/organ/heart/is_failing()
	if(owner)
		return (..() || !beating)
	return ..()

/obj/item/organ/heart/Remove(mob/living/carbon/old_owner, special = FALSE)
	. = ..()
	if(!special)
		addtimer(CALLBACK(src, PROC_REF(stop_if_unowned)), 12 SECONDS)

/obj/item/organ/heart/attack_self(mob/user)
	. = ..()
	if(!beating)
		user.visible_message(span_notice("[user] squeezes [src] to make it beat again!"), \
					span_notice("You squeeze [src] to make it beat again!"))
		Restart()
		addtimer(CALLBACK(src, PROC_REF(stop_if_unowned)), 8 SECONDS)

/obj/item/organ/heart/proc/can_stop()
	if(beating)
		return TRUE
	return FALSE

/obj/item/organ/heart/proc/stop_if_unowned()
	if(!owner)
		Stop()

/obj/item/organ/heart/proc/Stop()
	var/old_beating = beating
	beating = FALSE
	update_appearance()
	if(owner && old_beating)
		var/deathsdoor = TRUE
		for(var/thing in (owner.getorganslotlist(ORGAN_SLOT_HEART) - src))
			var/obj/item/organ/heart/heart = thing
			if(heart.beating)
				deathsdoor = FALSE
		if(deathsdoor)
			to_chat(owner, span_danger("I'm knocking on death's door!"))
	return TRUE

/obj/item/organ/heart/proc/Restart()
	var/old_beating = beating
	beating = TRUE
	update_appearance()
	if(owner && !old_beating)
		to_chat(owner, span_userdanger("My [name] beats again!"))
	return TRUE

/obj/item/organ/heart/get_availability(datum/species/S)
	return (!(NOBLOOD in S.species_traits) && !(TRAIT_STABLEHEART in S.inherent_traits))

/obj/item/organ/heart/get_mechanics_examine(mob/user)
	. = ..()

	if(owner && !damage)
		var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
		if(length(loose_humors))
			. += "Use a suture to stitch the loose humors into this heart."
		if(!chimeric)
			. += "Use a hemostat to begin a chimeric transformation on this heart."
		else if(chimeric.failed)
			. += "Use a healing item or tool to attempt to repair the failed chimeric organ."

	if(owner)
		. += "Place a chimeric node on this heart to add a humor to it."

/obj/item/organ/heart/handle_organ_attack(obj/item/tool, mob/living/user, params)
	if(owner && DOING_INTERACTION_WITH_TARGET(user, owner))
		return TRUE
	else if(DOING_INTERACTION_WITH_TARGET(user, src))
		return TRUE
	if(owner && tool.tool_behaviour == TOOL_SUTURE && !damage)
		if(length(loose_humors))
			handle_chimeric_stitching(tool, user)
			return TRUE
	if(owner && CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		for(var/thing in attaching_items)
			if(istype(tool, thing))
				handle_attaching_item(tool, user, params)
				return TRUE
	for(var/thing in healing_items)
		if(istype(tool, thing))
			handle_healing_item(tool, user, params)
			if(GetComponent(/datum/component/chimeric_organ)?.failed)
				handle_chimeric_repair(tool, user)
			return TRUE
	for(var/thing in healing_tools)
		if(tool.tool_behaviour == thing)
			handle_healing_item(tool, user, params)
			if(GetComponent(/datum/component/chimeric_organ)?.failed)
				handle_chimeric_repair(tool, user)
			return TRUE
	if(owner && tool.tool_behaviour == TOOL_HEMOSTAT)
		handle_organ_attack_hemostat_chimeric(tool, user)
		return TRUE
	if(istype(tool, /obj/item/chimeric_node))
		handle_humor_placement(tool, user)
		return TRUE
	if(owner && (tool.sharpness == IS_SHARP || tool.tool_behaviour == TOOL_SCALPEL) && !CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		handle_cutting_away(tool, user, params)
		return TRUE
	if(tool.tool_behaviour == TOOL_CAUTERY)
		handle_burning_rot(tool, user, params)
		return TRUE

/obj/item/organ/heart/proc/handle_organ_attack_hemostat_chimeric(obj/item/tool, mob/living/user)
	var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
	if(!chimeric)
		handle_chimeric_transformation(tool, user)
		return TRUE

	ui_interact(user)
	return TRUE

/obj/item/organ/heart/ui_state(mob/user)
	return GLOB.always_state

/obj/item/organ/heart/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "ChimericHeart", "Chimeric Organ")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/item/organ/heart/ui_data(mob/user)
	var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
	if(!chimeric)
		return list()

	var/list/inp_list = list()
	for(var/datum/chimeric_node/input/N as anything in chimeric.inputs)
		inp_list += list(N.to_tgui())

	var/list/out_list = list()
	for(var/datum/chimeric_node/output/N as anything in chimeric.outputs)
		out_list += list(N.to_tgui())

	var/list/p_inp_list = list()
	for(var/datum/chimeric_node/input/N as anything in chimeric.partnerless_inputs)
		p_inp_list += list(N.to_tgui())

	var/list/p_out_list = list()
	for(var/datum/chimeric_node/output/N as anything in chimeric.partnerless_outputs)
		p_out_list += list(N.to_tgui())

	var/list/sp_list = list()
	for(var/datum/chimeric_node/special/N as anything in chimeric.special_nodes)
		sp_list += list(N.to_tgui())

	var/list/blood_list = list()
	var/datum/component/blood_stability/blood_stab = owner?.GetComponent(/datum/component/blood_stability)
	for(var/datum/blood_type/blood_type as anything in chimeric.blood_requirements)
		var/required = chimeric.blood_requirements[blood_type]
		var/stored = blood_stab ? blood_stab.get_blood_amount(blood_type) : 0
		blood_list += list(list(
			"blood_type" = initial(blood_type.name),
			"required" = required,
			"stored" = stored,
		))

	return list(
		"organ_name" = name,
		"failed" = chimeric.failed,
		"failed_percent"  = chimeric.failed_precent,
		"processing" = chimeric.processing,
		"maximum_tier_difference" = chimeric.maximum_tier_difference,
		"inputs"  = inp_list,
		"outputs"  = out_list,
		"partnerless_inputs" = p_inp_list,
		"partnerless_outputs"= p_out_list,
		"special_nodes" = sp_list,
		"blood_requirements" = blood_list,
	)

/obj/item/organ/heart/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
	if(!chimeric || chimeric.failed)
		return FALSE

	switch(action)
		if("connect_nodes")
			var/input_id = params["input_id"]
			var/output_id = params["output_id"]
			if(!input_id || !output_id)
				return FALSE
			return chimeric.ui_connect_nodes(input_id, output_id, usr)

		if("disconnect_node")
			var/node_id = params["node_id"]
			var/node_type = params["node_type"]
			if(!node_id || !node_type)
				return FALSE
			return chimeric.ui_disconnect_node(node_id, node_type, usr)

	return FALSE


/obj/item/organ/heart/proc/handle_humor_placement(obj/item/chimeric_node/node, mob/living/user)
	var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
	if(!chimeric)
		to_chat(user, span_warning("[src] has not been transformed and cannot accept humors!"))
		return TRUE
	if(chimeric.failed)
		to_chat(user, span_warning("[src] has failed and cannot accept humors until repaired!"))
		return TRUE
	if(node in loose_humors)
		to_chat(user, span_warning("That humor is already placed."))
		return TRUE
	loose_humors += node
	node.forceMove(src)
	user.visible_message(
		span_notice("[user] presses [node] against [owner]'s [src]. It clings wetly to the surface."),
		span_notice("I press [node] against [owner]'s [src]. It adheres, waiting to be stitched."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	to_chat(owner, span_warning("You feel something cold pressed against your [src]."))
	return TRUE

/obj/item/organ/heart/proc/handle_chimeric_stitching(obj/item/tool, mob/living/user)
	var/mob/living/carbon/target = owner
	var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
	if(!chimeric)
		return TRUE

	user.visible_message(
		span_notice("[user] begins stitching the loose humors into [target]'s [src]..."),
		span_notice("I begin stitching [loose_humors.len] humor\s into [target]'s [src]..."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	if(!do_after(user, 3 SECONDS * loose_humors.len, target))
		to_chat(user, span_warning("I must stand still!"))
		return TRUE
	if(!owner)
		return TRUE

	chimeric = GetComponent(/datum/component/chimeric_organ)
	if(!chimeric || chimeric.failed)
		to_chat(user, span_warning("[src] can no longer accept humors!"))
		return TRUE

	var/datum/component/blood_stability/blood_stab = target.GetComponent(/datum/component/blood_stability)
	if(!blood_stab)
		to_chat(user, span_warning("[target] lacks a blood stability system!"))
		return TRUE

	var/grafted = 0
	var/list/failed_humors = list()
	for(var/obj/item/chimeric_node/node in loose_humors)
		var/datum/chimeric_node/test_node = node.stored_node
		var/node_slot = INPUT_NODE
		if(istype(test_node, /datum/chimeric_node/output))
			node_slot = OUTPUT_NODE

		var/value = chimeric.handle_node_injection(
			tier = node.node_tier,
			purity = node.node_purity,
			slot = node_slot,
			injected_node = test_node,
			overlay_state = node.icon_state
		)
		if(value)
			node.stored_node = null
			qdel(node)
			grafted++
		else
			failed_humors |= node
			to_chat(user, span_warning("One humor was rejected, and the stitches come loose."))

	loose_humors = failed_humors

	user.visible_message(
		span_notice("[user] finishes stitching. [grafted] humor\s take hold in [target]'s [src]."),
		span_notice("[grafted] humor\s have been stitched into [src]."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	to_chat(user, span_warning("Current blood requirements for [src]:"))
	for(var/datum/blood_type/blood_type as anything in chimeric.blood_requirements)
		var/required_amount = chimeric.blood_requirements[blood_type]
		var/stored_amount = blood_stab.get_blood_amount(blood_type)
		var/status = stored_amount >= required_amount ? "+" : "-"
		to_chat(user, span_notice("  [status] [initial(blood_type.name)]: [stored_amount] / [required_amount] required"))

	if(!chimeric.check_blood_requirements(blood_stab))
		to_chat(user, span_boldwarning("[target] needs more blood infusions for this organ to function!"))
		to_chat(target, span_userdanger("You feel your [src] struggling - it needs more blood essence!"))
	else
		to_chat(target, span_notice("You feel the alien flesh knit into your [src]."))
	return TRUE

/obj/item/organ/heart/proc/handle_chimeric_transformation(obj/item/tool, mob/living/user)
	var/mob/living/carbon/target = owner
	user.visible_message(
		span_notice("[user] begins carving strange patterns into [target]'s [src]."),
		span_notice("I begin carving dark runes into [target]'s [src], preparing it for transformation..."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	if(!do_after(user, 10 SECONDS, target))
		to_chat(user, span_warning("I must stand still!"))
		return TRUE
	if(!owner)
		return TRUE
	AddComponent(/datum/component/chimeric_organ)
	if(!target.GetComponent(/datum/component/blood_stability))
		target.AddComponent(/datum/component/blood_stability)
		to_chat(user, span_boldnotice("As the ritual completes, [target]'s body adapts to accept infused blood essence."))
	user.visible_message(
		span_notice("[user] completes the dark ritual. The [src] writhes and changes."),
		span_notice("The ritual completes! [target]'s [src] pulses with unnatural life."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)
	to_chat(user, span_warning("[target]'s [src] can now accept humors. Each node will require stored blood essence based on its tier and purity."))
	to_chat(target, span_userdanger("You feel something inside you change fundamentally. Your body now stores the essence of blood..."))
	return TRUE

/obj/item/organ/heart/proc/handle_chimeric_repair(obj/item/tool, mob/living/user)
	var/mob/living/carbon/target = owner
	var/datum/component/chimeric_organ/chimeric = GetComponent(/datum/component/chimeric_organ)
	if(!chimeric || !chimeric.failed)
		return TRUE

	user.visible_message(
		span_notice("[user] works to restore [target]'s failing [src]..."),
		span_notice("I work to restore [target]'s [src] alongside the healing..."),
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	chimeric.failed = FALSE
	chimeric.failed_precent = 0
	chimeric.start_processing()

	for(var/datum/chimeric_node/input/input_node as anything in chimeric.inputs)
		input_node.register_triggers(target)

	var/datum/component/blood_stability/blood_stab = target.GetComponent(/datum/component/blood_stability)

	to_chat(user, span_boldnotice("[src] has been restored to function."))
	to_chat(user, span_warning("Blood requirements for [src]:"))
	var/all_met = TRUE
	for(var/blood_type in chimeric.blood_requirements)
		var/required_amount = chimeric.blood_requirements[blood_type]
		var/stored_amount = blood_stab.get_blood_amount(blood_type)
		var/status = stored_amount >= required_amount ? "+" : "-"
		to_chat(user, span_notice("  [status] [blood_type]: [stored_amount] / [required_amount] required"))
		if(stored_amount < required_amount)
			all_met = FALSE

	if(!all_met)
		to_chat(user, span_boldwarning("WARNING: [target] still needs more blood infusions for stable function!"))
		to_chat(target, span_warning("Your [src] is restored, but still craves more blood essence..."))
	else
		to_chat(target, span_notice("You feel your [src] stabilize and resume functioning."))
	return TRUE
