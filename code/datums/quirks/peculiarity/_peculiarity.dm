
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
	return ..()

/datum/quirk/peculiarity/large_sized/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.transform = H.transform.Scale(0.87, 0.87)
	H.update_transform()
	return ..()

/datum/quirk/peculiarity/small_sized
	name = "Small Build"
	desc = "You're smaller and more compact than most. This makes you less imposing but potentially harder to hit."

/datum/quirk/peculiarity/small_sized/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.transform = H.transform.Scale(0.9, 0.9)
	H.update_transform()
	return ..()

/datum/quirk/peculiarity/small_sized/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.transform = H.transform.Scale(1.11, 1.11)
	H.update_transform()
	return ..()

/datum/quirk/peculiarity/witless_pixie
	name = "Witless Pixie"
	desc = "By some cruel twist of fate, you have been born a dainty-minded, dim-witted klutz. Yours is a life of constant misdirection, confusion and general incompetence. It is no small blessing your dazzling looks make up for this, sometimes."

/datum/quirk/peculiarity/witless_pixie/on_spawn()
	owner.adjust_stat_modifier(STATMOD_WITLESS_PIXIE, list(STAT_INTELLIGENCE = rand(-2, -5)))

	REMOVE_TRAIT(owner, TRAIT_BEAUTIFUL, NONE)
	REMOVE_TRAIT(owner, TRAIT_UGLY, NONE)
	REMOVE_TRAIT(owner, TRAIT_FISHFACE, NONE)

	if(prob(50))
		ADD_TRAIT(owner, TRAIT_BEAUTIFUL, QUIRK_TRAIT)
	else if(prob(30))
		ADD_TRAIT(owner, TRAIT_UGLY, QUIRK_TRAIT)
	return ..()

/datum/quirk/peculiarity/witless_pixie/on_remove()
	owner?.remove_stat_modifier(STATMOD_WITLESS_PIXIE)
	return ..()

/datum/quirk/peculiarity/ugly
	name = "Ugly"
	desc = "Your appearance turns heads... in all the wrong ways. With features ranging from unsightly to grotesque, you likely have yet to find anyone impressed with your looks."
	traits_to_add = list(TRAIT_UGLY)

/datum/quirk/peculiarity/ugly/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner

	REMOVE_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
	REMOVE_TRAIT(H, TRAIT_FISHFACE, TRAIT_GENERIC)
	return ..()

/datum/quirk/peculiarity/virgin
	name = "Virgin"
	desc = "YOU... ARE MAIDENLESS! Whether because of awkwardness, deep religiosity, or sheer unluckiness, your body remains untainted and pure."
	traits_to_add = list(TRAIT_VIRGIN)
