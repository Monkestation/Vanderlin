/datum/orderless_slapcraft/bouquet
	name = "Flower Bouquet"
	starting_item = /obj/item/natural/cloth
	finishing_item = /obj/item/natural/fibers
	related_skill = /datum/attribute/skill/craft/crafting
	skill_xp_gained = 5
	action_time = 2.5 SECONDS
	requirements = list(
		list(/obj/item/alch/herb/rosa, /obj/item/alch/herb/salvia, /obj/item/alch/herb/matricaria, /obj/item/alch/herb/calendula) = 2,
	)
	/// Count of flowers added
	var/flower_count = 0

/datum/orderless_slapcraft/bouquet/before_process_item(obj/item/attacking_item, mob/user)
	// UTTER JANK TO KEEP THIS PURE ORDERLESS SLAPCRAFT
	if(!istype(hosted_source, /obj/item/bouquet))
		var/old_host = hosted_source
		UnregisterSignal(old_host, COMSIG_QDELETING)

		var/obj/item/bouquet/incomplete_bouquet = new(get_turf(old_host))
		hosted_source = incomplete_bouquet
		incomplete_bouquet.in_progress_slapcraft = src
		RegisterSignal(hosted_source, COMSIG_QDELETING, PROC_REF(early_end))
		starting_item = incomplete_bouquet.type

		qdel(old_host)

	if(istype(attacking_item, /obj/item/alch))
		var/mutable_appearance/flower_overlay
		switch(flower_count)
			if(0)
				flower_overlay = mutable_appearance(hosted_source.icon, "[initial(attacking_item.name)]_1")
			else
				flower_overlay = mutable_appearance(hosted_source.icon, "[initial(attacking_item.name)]_1", alpha = 140)
		hosted_source.add_overlay(flower_overlay)
		flower_count++

	hosted_source.name = "incomplete bouquet"
	var/remaining_flowers = 2 - flower_count
	hosted_source.desc = "A bouquet waiting for [remaining_flowers] flower[remaining_flowers != 1 ? "s" : ""] to be added and a fiber to tie everything together."
	return FALSE

/datum/orderless_slapcraft/bouquet/handle_output_item(mob/user, obj/item/new_item)
	new_item.name = initial(new_item.name)
	new_item.desc = initial(new_item.desc)
	. = ..()
