/datum/tutorial/vanderlin/injury
	name = "Treating Injuries"
	tutorial_id = "injury_treatment"
	category = TUTORIAL_CATEGORY_BASE
	parent_path = /datum/tutorial/vanderlin/injury

/datum/tutorial/vanderlin/injury/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return
	init_mob()
	message_to_player("You've taken some damage  - a <b>slash wound</b> on your <b>right arm</b> and a <b>burn</b> on your <b>head</b>. \
		Start by picking up the <b>Ethanol Bottle</b>.")
	update_objective("Pick up the <b>Ethanol Bottle</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/beer, ethanol_bottle)
	add_highlight(ethanol_bottle)
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(on_ethanol_pickup))

/datum/tutorial/vanderlin/injury/proc/on_ethanol_pickup(datum/source, obj/item/picked_up)
	SIGNAL_HANDLER
	if(!istype(picked_up, /obj/item/reagent_containers/glass/bottle/beer))
		return
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/beer, ethanol_bottle)
	remove_highlight(ethanol_bottle)
	message_to_player("Good. Now pick up the <b>Cloth Bandage</b>. You'll use it with <b>Soak</b> intent \
		 to absorb liquids from containers.")
	update_objective("Pick up the <b>Cloth Bandage</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/natural/cloth/bandage, cloth_bandage)
	add_highlight(cloth_bandage)
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(on_disinfect_bandage_pickup))

/datum/tutorial/vanderlin/injury/proc/on_disinfect_bandage_pickup(datum/source, obj/item/picked_up)
	SIGNAL_HANDLER
	if(!istype(picked_up, /obj/item/natural/cloth/bandage))
		return
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/natural/cloth/bandage, cloth_bandage)
	remove_highlight(cloth_bandage)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/beer, ethanol_bottle)
	add_highlight(ethanol_bottle)
	message_to_player("Now soak the <b>Cloth Bandage</b> in the <b>Ethanol Bottle</b>. \
	First, <b>uncork the bottle</b> by clicking it in your hand, then hold the bandage and click the bottle with <b>Soak</b> intent.")
	update_objective("Soak the <b>Cloth Bandage</b> in the <b>Ethanol Bottle</b>.")
	RegisterSignal(cloth_bandage, COMSIG_CLOTH_SOAKED, PROC_REF(on_bandage_soaked_ethanol))

/datum/tutorial/vanderlin/injury/proc/on_bandage_soaked_ethanol(datum/source, atom/soaked_in)
	SIGNAL_HANDLER
	if(!istype(soaked_in, /obj/item/reagent_containers/glass/bottle/beer))
		return
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/natural/cloth/bandage, cloth_bandage)
	UnregisterSignal(cloth_bandage, COMSIG_CLOTH_SOAKED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/beer, ethanol_bottle)
	remove_highlight(ethanol_bottle)
	message_to_player("Good. Now apply the soaked <b>Cloth Bandage</b> to your <b>right arm</b> to disinfect the slash wound. \
		Make sure your <b>right arm</b> is selected in the zone selector.")
	update_objective("Apply the soaked <b>Cloth Bandage</b> to your <b>right arm</b>.")
	var/mob/living/carbon/human/mob = tutorial_mob
	var/obj/item/bodypart/arm = mob.get_bodypart(BODY_ZONE_R_ARM)
	RegisterSignal(arm, COMSIG_BODYPART_DISINFECTED, PROC_REF(on_arm_disinfected))

/datum/tutorial/vanderlin/injury/proc/on_arm_disinfected(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/mob = tutorial_mob
	var/obj/item/bodypart/arm = mob.get_bodypart(BODY_ZONE_R_ARM)
	UnregisterSignal(arm, COMSIG_BODYPART_DISINFECTED)
	message_to_player("The wound is disinfected. Remove the bandage from your <b>right arm</b> before suturing  - \
		click your <b>right arm</b> with an empty hand to take it off.")
	update_objective("Remove the bandage from your <b>right arm</b>.")
	RegisterSignal(tutorial_mob, COMSIG_MOB_UNBANDAGE, PROC_REF(on_disinfect_bandage_removed))

/datum/tutorial/vanderlin/injury/proc/on_disinfect_bandage_removed(datum/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	// Removing the bandage from the limb puts it in the mob's hand, which fires after removal
	var/mob/living/carbon/human/mob = tutorial_mob
	var/obj/item/bodypart/arm = mob.get_bodypart(BODY_ZONE_R_ARM)
	if(arm != limb)
		return
	UnregisterSignal(tutorial_mob, COMSIG_MOB_UNBANDAGE)
	message_to_player("Good. Now pick up the <b>Suture Needle</b> to stitch the slash closed.")
	update_objective("Pick up the <b>Suture Needle</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/needle, suture_needle)
	add_highlight(suture_needle)
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(on_needle_pickup))

/datum/tutorial/vanderlin/injury/proc/on_needle_pickup(datum/source, obj/item/picked_up)
	SIGNAL_HANDLER
	if(!istype(picked_up, /obj/item/needle))
		return
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/needle, suture_needle)
	remove_highlight(suture_needle)
	message_to_player("Now use the <b>Suture Needle</b> on your <b>right arm</b> to stitch the slash wound closed. \
		Make sure your <b>right arm</b> is selected in the zone selector.")
	update_objective("Use the <b>Suture Needle</b> on your <b>right arm</b> to suture the slash wound.")
	var/mob/living/carbon/human/mob = tutorial_mob
	var/obj/item/bodypart/arm = mob.get_bodypart(BODY_ZONE_R_ARM)
	for(var/datum/injury/injury in arm.injuries)
		if(injury.damage_type == WOUND_SLASH)
			RegisterSignal(injury, COMSIG_INJURY_SUTURED, PROC_REF(on_slash_sutured))
			break

/datum/tutorial/vanderlin/injury/proc/on_slash_sutured(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_INJURY_SUTURED)
	message_to_player("The slash is stitched. Now pick up the <b>Calendula Salve Vial</b> to treat the burn on your <b>head</b>.")
	update_objective("Pick up the <b>Calendula Salve Vial</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/vial/calendula_salve, salve_vial)
	add_highlight(salve_vial)
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(on_salve_pickup))

/datum/tutorial/vanderlin/injury/proc/on_salve_pickup(datum/source, obj/item/picked_up)
	SIGNAL_HANDLER
	if(!istype(picked_up, /obj/item/reagent_containers/glass/bottle/vial/calendula_salve))
		return
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/vial/calendula_salve, salve_vial)
	remove_highlight(salve_vial)
	message_to_player("Now pick up the <b>Cloth Bandage</b> to soak in the salve.")
	update_objective("Pick up the <b>Cloth Bandage</b>.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/natural/cloth/bandage/tutorial_fresh, fresh_bandage)
	add_highlight(fresh_bandage)
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(on_salve_bandage_pickup))

/datum/tutorial/vanderlin/injury/proc/on_salve_bandage_pickup(datum/source, obj/item/picked_up)
	SIGNAL_HANDLER
	if(!istype(picked_up, /obj/item/natural/cloth/bandage/tutorial_fresh))
		return
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/natural/cloth/bandage/tutorial_fresh, fresh_bandage)
	remove_highlight(fresh_bandage)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/vial/calendula_salve, salve_vial)
	add_highlight(salve_vial)
	message_to_player("Now soak the <b>Cloth Bandage</b> in the <b>Calendula Salve Vial</b>. \
   		First, <b>uncork the vial</b> by clicking it in your hand, then hold the bandage and click the vial with <b>Soak</b> intent.")
	update_objective("Soak the <b>Cloth Bandage</b> in the <b>Calendula Salve Vial</b>.")
	RegisterSignal(fresh_bandage, COMSIG_CLOTH_SOAKED, PROC_REF(on_bandage_soaked_salve))

/datum/tutorial/vanderlin/injury/proc/on_bandage_soaked_salve(datum/source, atom/soaked_in)
	SIGNAL_HANDLER
	if(!istype(soaked_in, /obj/item/reagent_containers/glass/bottle/vial/calendula_salve))
		return
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/natural/cloth/bandage/tutorial_fresh, fresh_bandage)
	UnregisterSignal(fresh_bandage, COMSIG_CLOTH_SOAKED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_containers/glass/bottle/vial/calendula_salve, salve_vial)
	remove_highlight(salve_vial)
	message_to_player("Good. Now apply the soaked <b>Cloth Bandage</b> to your <b>head</b> to treat the burn. \
		Make sure your <b>head</b> is selected in the zone selector.")
	update_objective("Apply the soaked <b>Cloth Bandage</b> to your <b>head</b>.")
	var/mob/living/carbon/human/mob = tutorial_mob
	var/obj/item/bodypart/head = mob.get_bodypart(BODY_ZONE_HEAD)
	for(var/datum/injury/injury in head.injuries)
		if(injury.damage_type == WOUND_BURN)
			RegisterSignal(injury, COMSIG_INJURY_SALVED, PROC_REF(on_burn_salved))
			break

/datum/tutorial/vanderlin/injury/proc/on_burn_salved(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_INJURY_SALVED)
	message_to_player("The burn is treated. Your wounds are closed and dressed  - you're ready.")
	tutorial_end_in(7.5 SECONDS, TRUE)

/datum/tutorial/vanderlin/injury/init_map()
	var/obj/item/reagent_containers/glass/bottle/beer/ethanol_bottle = new(loc_from_corner(2, 4))
	add_to_tracking_atoms(ethanol_bottle)

	var/obj/item/reagent_containers/glass/bottle/vial/calendula_salve/salve_vial = new(loc_from_corner(3, 4))
	add_to_tracking_atoms(salve_vial)

	// Soaked in salve and applied to the burn
	var/obj/item/natural/cloth/bandage/cloth_bandage = new(loc_from_corner(4, 4))
	add_to_tracking_atoms(cloth_bandage)

	// Dry wrap for the final bandage step
	var/obj/item/natural/cloth/bandage/tutorial_fresh/fresh_bandage = new(loc_from_corner(4, 3))
	add_to_tracking_atoms(fresh_bandage)

	var/obj/item/needle/suture_needle = new(loc_from_corner(5, 4))
	add_to_tracking_atoms(suture_needle)

/datum/tutorial/vanderlin/injury/init_mob()
	. = ..()
	var/mob/living/carbon/human/mob = tutorial_mob
	var/obj/item/bodypart/arm = mob.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/head = mob.get_bodypart(BODY_ZONE_HEAD)
	if(!arm || !head)
		return
	var/datum/injury/slash = arm.create_injury(WOUND_SLASH, 25)
	slash.adjust_germ_level(200)
	head.create_injury(WOUND_BURN, 20)

/obj/item/natural/cloth/bandage/tutorial_fresh
	name = "cloth bandage"  // Looks identical to the player
