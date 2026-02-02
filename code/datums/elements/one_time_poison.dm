/datum/element/one_time_poison
	element_flags = ELEMENT_DETACH

/datum/element/one_time_poison/Attach(atom/movable/target, list/reagent_list)
	. = ..()
	if(!istype(target, /obj/item/weapon))
		return ELEMENT_INCOMPATIBLE
	if(!LAZYLEN(reagent_list))
		return ELEMENT_INCOMPATIBLE
	if(!target.reagents)
		target.create_reagents(1)
	target.reagents.add_reagent_list(reagent_list)
	RegisterSignal(target, COMSIG_ITEM_ATTACK_EFFECT_SELF, PROC_REF(try_inject))
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/element/one_time_poison/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ITEM_ATTACK_EFFECT_SELF, COMSIG_PARENT_EXAMINE))

/datum/element/one_time_poison/proc/try_inject(obj/item/source, mob/user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone)
	var/reagentlog2 = source.reagents
	if(!isliving(victim))
		return

	log_combat(user, victim, "poisoned", addition="with [reagentlog2]")
	source.reagents.trans_to(victim, source.reagents.get_reagent_amount(), transfered_by = user)
	Detach(src, TRUE)
	qdel(src, TRUE)

/datum/element/one_time_poison/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	if(source.reagents.total_volume)
		var/reagent_color = mix_color_from_reagents(source.reagents.reagent_list)
		examine_list += span_red("Has been dipped in <font color=[reagent_color]>something</font>!")
