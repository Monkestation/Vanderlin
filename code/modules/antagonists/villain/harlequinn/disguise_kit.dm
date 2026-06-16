/datum/component/disguise
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mutable_appearance/cloned_appearance
	var/examine_tone
	var/datum/species/examine_species
	var/examine_title
	var/old_gender
	var/old_name

/datum/component/disguise/Initialize(mob/living/carbon/human/source)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/user = parent
	old_gender = user.gender
	user.cut_overlays()
	old_name = user.real_name
	cloned_appearance = copy_appearance_filter_overlays(source.appearance)
	examine_tone = source.skin_tone
	examine_species = source.dna.species
	examine_title = source.get_role_title(source)
	cloned_appearance.transform = matrix()
	cloned_appearance.appearance_flags |= KEEP_APART | RESET_ALPHA
	user.add_overlay(cloned_appearance)
	user.alpha = 0
	user.name = source.name
	user.gender = source.gender
	user.real_name = source.name
	parent.AddElement(/datum/element/update_icon_blocker)
	parent.AddElement(/datum/element/relay_attackers)
	RegisterSignal(user, COMSIG_ATOM_UPDATE_APPEARANCE, PROC_REF(block_appearance_update))
	RegisterSignal(user, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked))

/datum/component/disguise/proc/on_attacked(mob/living/carbon/human/user, atom/attacker, damage)
	SIGNAL_HANDLER
	var/requirement = clamp(round(damage / 3), 4, 16)
	if(!user.diceroll(requirement, context = DICE_CONTEXT_DEFAULT))
		to_chat(user, span_warning("The impact disrupts your disguise!"))
		if(ismob(attacker))
			to_chat(attacker, span_notice("The blow seems to disturb [user]'s appearance, something looks off."))
		qdel(src)

/datum/component/disguise/proc/block_appearance_update()
	return COMSIG_ATOM_NO_UPDATE_NAME | COMSIG_ATOM_NO_UPDATE_DESC | COMSIG_ATOM_NO_UPDATE_ICON

/datum/component/disguise/Destroy()
	examine_species = null
	var/mob/living/carbon/human/user = parent
	user.gender = old_gender
	user.RemoveElement(/datum/element/update_icon_blocker)
	user.RemoveElement(/datum/element/relay_attackers)
	UnregisterSignal(user, list(
		COMSIG_ATOM_UPDATE_APPEARANCE,
		COMSIG_ATOM_WAS_ATTACKED,
	))
	user.name = old_name
	user.cut_overlays()
	user.regenerate_icons()
	user.alpha = 255
	user.update_appearance()
	return ..()

/obj/item/harlequin_disguise_kit
	name = "professional disguise kit"
	desc = "A collection of makeup, prosthetics, and costume pieces for mundane disguises."
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "rucksack"
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 32

/obj/item/harlequin_disguise_kit/attack_self(mob/user, list/modifiers)
	if(!ishuman(user))
		to_chat(user, span_warning("You don't know how to use this."))
		return

	if(user.GetComponent(/datum/component/disguise))
		remove_disguise(user)
		return

	var/list/options = list(
		"Quick Disguise (Random nearby person)" = "quick",
		"Detailed Disguise (Pick a person)" = "detailed",
		"Remove Disguise" = "remove"
	)
	var/choice = tgui_input_list(user, "What would you like to do?", "Disguise Kit", options)
	if(!choice)
		return
	switch(options[choice])
		if("quick")
			quick_disguise(user)
		if("detailed")
			detailed_disguise(user)
		if("remove")
			remove_disguise(user)

/obj/item/harlequin_disguise_kit/proc/get_nearby_humans(mob/user)
	var/list/nearby = list()
	for(var/mob/living/carbon/human/H in view(7, user))
		if(H == user)
			continue
		nearby += H
	return nearby

/obj/item/harlequin_disguise_kit/proc/quick_disguise(mob/living/carbon/human/user)
	var/list/nearby = get_nearby_humans(user)
	if(!length(nearby))
		to_chat(user, span_warning("There's no one nearby to disguise yourself as."))
		return
	if(user.GetComponent(/datum/component/disguise))
		remove_disguise(user)
		return

	var/mob/living/carbon/human/target = pick(nearby)
	to_chat(user, span_notice("You study [target] and begin quickly applying a disguise to match them..."))
	if(!do_after(user, 10 SECONDS, target = user))
		return
	if(user.GetComponent(/datum/component/disguise))
		remove_disguise(user)
		return
	user.AddComponent(/datum/component/disguise, target)
	to_chat(user, span_notice("You now look like a rough copy of [target.name], though it may not fool close inspection."))

/obj/item/harlequin_disguise_kit/proc/detailed_disguise(mob/living/carbon/human/user)
	var/list/nearby = get_nearby_humans(user)
	if(user.GetComponent(/datum/component/disguise))
		remove_disguise(user)
		return

	if(!length(nearby))
		to_chat(user, span_warning("There's no one nearby to disguise yourself as."))
		return

	var/list/named = list()
	for(var/mob/living/carbon/human/H in nearby)
		named[H.name] = H

	var/choice = tgui_input_list(user, "Who do you want to disguise yourself as?", "Disguise Kit", named)
	if(!choice)
		return

	var/mob/living/carbon/human/target = named[choice]
	if(!target || !target.loc)
		to_chat(user, span_warning("You can no longer see that person."))
		return

	to_chat(user, span_notice("You carefully study [target] and begin applying an elaborate disguise..."))
	if(!do_after(user, 20 SECONDS, target = user))
		return

	if(user.GetComponent(/datum/component/disguise))
		remove_disguise(user)
		return

	user.AddComponent(/datum/component/disguise, target)
	to_chat(user, span_notice("Your disguise is convincing and should fool most observers."))

/obj/item/harlequin_disguise_kit/proc/remove_disguise(mob/living/carbon/human/user)
	if(!user.GetComponent(/datum/component/disguise))
		to_chat(user, span_warning("You aren't wearing a disguise."))
		return
	to_chat(user, span_notice("You begin removing your disguise..."))
	if(!do_after(user, 10 SECONDS, target = user))
		return
	qdel(user.GetComponent(/datum/component/disguise))
	to_chat(user, span_notice("You return to your normal appearance."))
