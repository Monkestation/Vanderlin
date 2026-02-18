
/datum/quirk/peculiarity
	abstract_type = /datum/quirk/peculiarity
	quirk_category = QUIRK_PECULIARITY
	point_value = 0

/datum/quirk/peculiarity/large_sized
	name = "Large Build"
	desc = "You're taller and broader than most. This makes you more imposing but also harder to miss."

/datum/quirk/peculiarity/large_sized/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.transform = H.transform.Scale(1.15, 1.15)
	H.update_transform()

/datum/quirk/peculiarity/large_sized/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.transform = H.transform.Scale(0.87, 0.87)
	H.update_transform()

/datum/quirk/peculiarity/small_sized
	name = "Small Build"
	desc = "You're smaller and more compact than most. This makes you less imposing but potentially harder to hit."

/datum/quirk/peculiarity/small_sized/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.transform = H.transform.Scale(0.9, 0.9)
	H.update_transform()

/datum/quirk/peculiarity/small_sized/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.transform = H.transform.Scale(1.11, 1.11)
	H.update_transform()


/datum/quirk/peculiarity/witless_pixie
	name = "Witless Pixie"
	desc = "By some cruel twist of fate, you have been born a dainty-minded, dim-witted klutz. Yours is a life of constant misdirection, confusion and general incompetence. It is no small blessing your dazzling looks make up for this, sometimes."

/datum/quirk/peculiarity/witless_pixie/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_stat_modifier(STATMOD_QUIRK, STATKEY_INT, rand(-2, -5))

	REMOVE_TRAIT(H, TRAIT_BEAUTIFUL, QUIRK_TRAIT)
	REMOVE_TRAIT(H, TRAIT_UGLY, QUIRK_TRAIT)
	REMOVE_TRAIT(H, TRAIT_FISHFACE, QUIRK_TRAIT)

	if(prob(50))
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, QUIRK_TRAIT)
	else if(prob(30))
		ADD_TRAIT(H, TRAIT_UGLY, QUIRK_TRAIT)

/datum/quirk/peculiarity/witless_pixie/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	// Remove stat penalty (inverse of what was applied)
	// This is approximate since we randomized on spawn
	H.adjust_stat_modifier(STATMOD_QUIRK, STATKEY_INT, 3)

/datum/quirk/peculiarity/ugly
	name = "Ugly"
	desc = "Your appearance turns heads... in all the wrong ways. With features ranging from unsightly to grotesque, you likely have yet to find anyone impressed with your looks."

/datum/quirk/peculiarity/ugly/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	REMOVE_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
	REMOVE_TRAIT(H, TRAIT_FISHFACE, TRAIT_GENERIC)

	ADD_TRAIT(H, TRAIT_UGLY, TRAIT_GENERIC)

/datum/quirk/peculiarity/ugly/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	REMOVE_TRAIT(H, TRAIT_UGLY, TRAIT_GENERIC)

/datum/quirk/peculiarity/virgin
	name = "Virgin"
	desc = "YOU... ARE MAIDENLESS!! you never were good with women... or men, whether cause you are a awkward freak, or religous reasons, or simply plain unlucky, your blood remains untainted and pure."

/datum/quirk/peculiarity/virgin/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.virginity = FALSE

/datum/quirk/peculiarity/virgin/after_job_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.virginity = FALSE


/datum/quirk/peculiarity/mystery_box
	name = "Mystery Box"
	desc = "You possess a locked box that you cannot open. Someone in this world knows the code..."
	point_value = 0
	var/obj/item/mystery/mystery_box
	var/passcode
	var/mob/living/carbon/human/keeper

/datum/quirk/peculiarity/mystery_box/on_spawn()
	if(!owner || !ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner

	// Generate magic passcode using the word procs
	if(!passcode)
		passcode = "[open_word()] [magic_word()]"

	// Create and give the mystery box
	var/turf/T = get_turf(H)
	mystery_box = new(T)
	mystery_box.name = "mysterious locked box"
	mystery_box.desc = "A strange box sealed with an intricate lock. You can't open it, but you know someone who can..."
	mystery_box.linked_quirk = src

	H.put_in_hands(mystery_box)
	find_keeper()

/datum/quirk/peculiarity/mystery_box/proc/find_keeper()
	var/mob/living/carbon/human/H = owner

	// Find a random player to be the keeper
	var/list/possible_keepers = list()
	for(var/mob/living/carbon/human/P in GLOB.player_list)
		if(P != H && P.mind && P.stat != DEAD)
			possible_keepers += P

	if(length(possible_keepers))
		keeper = pick(possible_keepers)

		// Give keeper the knowledge with flavor
		to_chat(keeper, span_notice("A memory surfaces... you know the passcode to a mysterious box: \"[passcode]\""))
		keeper.mind.store_memory("Passcode to [H.real_name]'s box: \"[passcode]\"")

		to_chat(H, span_notice("You remember that [keeper.real_name] knows how to open this box..."))
	else
		to_chat(H, span_warning("You can't remember who knows the passcode..."))

	RegisterSignal(mystery_box, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine), TRUE)

/datum/quirk/peculiarity/mystery_box/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(user == keeper)
		examine_list += span_notice("You know the passcode to this box: \"[passcode]\"")

/datum/quirk/peculiarity/mystery_box/proc/try_unlock(code)
	if(lowertext(trim(code)) == lowertext(passcode))
		var/datum/loot_table/loot_generator
		var/roll = rand(1, 100)

		// 60% chance of medium loot, 30% common, 10% rare
		if(roll <= 10)
			loot_generator = new /datum/loot_table/rare()
		else if(roll <= 40)
			loot_generator = new /datum/loot_table/common()
		else
			loot_generator = new /datum/loot_table/medium()

		var/turf/T = get_turf(mystery_box)
		if(loot_generator && T)
			var/list/loot = loot_generator.spawn_loot(null, 1, 1.0)
			for(var/obj/item/I in loot)
				I.forceMove(T)

		mystery_box.visible_message(span_notice("[mystery_box] clicks open, revealing its contents!"))
		qdel(mystery_box)
		return TRUE
	return FALSE

/datum/quirk/peculiarity/mystery_box/on_remove()
	if(mystery_box)
		UnregisterSignal(mystery_box, COMSIG_PARENT_EXAMINE)
		qdel(mystery_box)

/obj/item/mystery
	name = "locked box"
	desc = "A mysterious locked box."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "mimic_trinket"
	var/datum/quirk/peculiarity/mystery_box/linked_quirk
	var/listening = TRUE

/obj/item/mystery/Initialize()
	. = ..()
	become_hearing_sensitive()

/obj/item/mystery/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/mystery/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	. = ..()
	if(!listening || !linked_quirk)
		return

	// Check if the speaker is nearby (within 7 tiles)
	if(!speaker || get_dist(src, speaker) > 7)
		return

	// Decode and check the message
	var/decoded_message = html_decode(original_message)
	if(linked_quirk.try_unlock(decoded_message))
		visible_message(span_green("[src] glows briefly and clicks open!"))
		listening = FALSE

/obj/item/mystery/attack_self(mob/user)
	if(!linked_quirk)
		to_chat(user, span_warning("This box seems permanently locked."))
		return

	to_chat(user, span_notice("You examine [src] carefully. Perhaps speaking the right words aloud near it will open it..."))
	to_chat(user, span_boldnotice("Hint: Someone in this world knows the passcode: [linked_quirk.keeper ? linked_quirk.keeper.real_name : "someone"]."))

/obj/item/mystery/examine(mob/user)
	. = ..()
	if(!linked_quirk.keeper)
		linked_quirk.find_keeper()
	if(user == linked_quirk?.keeper)
		. += span_green("You know the words to open this box: \"[linked_quirk.passcode]\"")
	else
		. += span_notice("It seems to respond to spoken words. Perhaps [linked_quirk?.keeper ? linked_quirk.keeper.real_name : "someone"] knows how to open it.")
	. += span_notice("Right-click to get a hint about who might know the passcode.")
