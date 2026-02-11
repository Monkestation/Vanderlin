/datum/element/tipped_item
	element_flags = ELEMENT_DETACH
	var/max_reagents = 1
	var/dip_amount = 0.5
	var/inject_amount = 1
	var/attack_injects = TRUE
	var/show_examine = TRUE

/datum/element/tipped_item/Attach(atom/movable/target, _max_reagents = 1, _dip_amount = 0.5, _inject_amount = 1, _attack_injects = TRUE, _show_examine = TRUE)
	. = ..()
	if(!ismovableatom(target))
		return ELEMENT_INCOMPATIBLE
	max_reagents = _max_reagents
	dip_amount = _dip_amount
	inject_amount = _inject_amount
	attack_injects = _attack_injects
	show_examine = _show_examine
	if(!target.reagents)
		target.create_reagents(max_reagents)
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ITEM_ATTACK_OBJ, PROC_REF(check_dip))
	RegisterSignal(target, COMSIG_ITEM_PRE_ATTACK, PROC_REF(check_dip))
	RegisterSignal(target, COMSIG_ITEM_SPEC_ATTACKEDBY, PROC_REF(try_inject))

/datum/element/tipped_item/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, list(COMSIG_PARENT_EXAMINE, COMSIG_ITEM_ATTACK_OBJ, COMSIG_ITEM_PRE_ATTACK, COMSIG_ITEM_SPEC_ATTACKEDBY))

/datum/element/tipped_item/proc/check_dip(obj/item/dipper, obj/item/reagent_containers/attacked_container, mob/living/attacker, list/modifiers)
	SIGNAL_HANDLER

	if(QDELETED(attacked_container) || !istype(attacked_container))
		return
	if(attacker.cmode)
		return
	if(!attacked_container.reagents)
		return
	if(!attacked_container.reagents.total_volume)
		return
	if(!(attacked_container.reagents.flags & DRAINABLE))
		return
	if(dipper.reagents.total_volume == dipper.reagents.maximum_volume)
		return

	INVOKE_ASYNC(src, PROC_REF(start_dipping), dipper, attacked_container, attacker)
	return COMPONENT_NO_ATTACK | COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/tipped_item/proc/start_dipping(obj/item/dipper, obj/item/reagent_containers/attacked_container, mob/living/attacker, params)
	if(!do_after(attacker, 2 SECONDS, attacked_container))
		return
	attacked_container.reagents.trans_to(dipper, dip_amount, transfered_by = attacker)
	attacker.visible_message(span_danger("[attacker] dips [dipper] in [attacked_container]!"), "You dip [dipper] in [attacked_container]!", vision_distance = 2)

/datum/element/tipped_item/proc/try_inject(obj/item/source, atom/target, mob/user, obj/item/bodypart/affecting, actual_damage)
	if(!affecting)
		return
	if(!actual_damage)
		return
	if(isliving(target))
		source.reagents.trans_to(target, inject_amount, transfered_by = user, method = INJECT)

/datum/element/tipped_item/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	if(!show_examine)
		return
	if(source.reagents.total_volume)
		var/reagent_color = mix_color_from_reagents(source.reagents.reagent_list)
		examine_list += span_info("[source] has been dipped in <font color=[reagent_color]>something</font>!")
