/obj/item/clothing/shirt/robe
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "robe"
	desc = "A common robe, worn mostly by religious adepts."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "white_robe"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	flags_inv = HIDEBOOB
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	resistance_flags = FLAMMABLE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP

	armor = ARMOR_MINIMAL
	prevent_crits = list(BCLASS_TWIST)
	max_integrity = INTEGRITY_POOR

/obj/item/clothing/shirt/robe/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shirt/robe/colored/linen
	color = CLOTHING_LINEN

/obj/item/clothing/shirt/robe/colored/plain
	color = CLOTHING_LINEN

/obj/item/clothing/shirt/robe/colored/black
	color = CLOTHING_DARK_INK

/obj/item/clothing/shirt/robe/colored/red//placeholder for malum & xylix acolyte robes
	color = CLOTHING_WINESTAIN_RED

/obj/item/clothing/shirt/robe/colored/purple
	color = CLOTHING_PLUM_PURPLE

//................ Temple Robes ............... //

/obj/item/clothing/shirt/robe/pestra
	name = "naga robe"
	desc = "Green robes which cover the body in many layers, resembling the ill form of the rotten naga."
	icon_state = "pestrarobe"
	icon = 'icons/roguetown/clothing/patron_robes.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/patron_robes.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_patron_robes.dmi'

/obj/item/clothing/shirt/robe/abyssor
	name = "sea robe"
	desc = "Dark green robes with a hood attached to the back, you feel like you're drowning in sweat just being in these."
	icon_state = "abyssrobe"
	icon = 'icons/roguetown/clothing/patron_robes.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/patron_robes.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/patron_robes.dmi'

/obj/item/clothing/shirt/robe/astrata
	name = "sun robe"
	desc = "The cloth of a follower of Astrata."
	icon_state = "astratarobe"

	sleeved = null

/obj/item/clothing/shirt/robe/noc
	name = "moon robe"
	desc = "The cloth of a follower of Noc."
	icon_state = "nocrobe"
	sleeved = null

//someone should make sure the necromancer robe gets dwarf and child sprites
/obj/item/clothing/shirt/robe/necromancer
	name = "necromancer robes"
	desc = "Eerie black garb of death."
	icon_state = "warlock"
	allowed_ages = ALL_AGES_LIST
	allowed_race = SPECIES_BASE_BODY
	sleeved = null

/obj/item/clothing/shirt/robe/dendor
	name = "briar robe"
	desc = "Nature nurtures us and we, in turn, will nurture it back in the end."
	icon_state = "dendorrobe"

/obj/item/clothing/shirt/robe/eora
	name = "eoran robe"
	desc = "Holy robes, intended for use by followers of Eora"
	icon_state = "eorarobes"

/obj/item/clothing/shirt/robe/eora/alt
	name = "eoran straps"
	desc = "Sanctified, form fitting straps. Used by more radical followers of the Eoran Church"
	icon_state = "eorastraps"

/obj/item/clothing/shirt/robe/necra
	name = "mourning robe"
	desc = "Black robes which cover the body not unlike those in depictions of the Carriageman himself."
	icon_state = "necrarobe"

/obj/item/clothing/shirt/robe/priest
	name = "solar vestments"
	desc = "Holy vestments sanctified by divine hands. Caution is advised if not a faithful."
	icon_state = "priestrobe"
	dropshrink = 0.8

/obj/item/clothing/shirt/robe/priest/pickup(mob/living/user)
	if((user.job != "Priest") && (user.job != "Priestess"))
		user.visible_message(span_reallybig("UNWORTHY HANDS TOUCH MY VISAGE, CEASE OR BE PUNISHED"))
		playsound(user, 'sound/misc/gods/astrata_omen.ogg', 80, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
		spawn(30)
			if(loc == user)
				user.adjust_divine_fire_stacks(5)
				user.IgniteMob()
	..()



//................ Wizard Robes ............... //
/obj/item/clothing/shirt/robe/colored/courtmage
	color = CLOTHING_CHALK_WHITE

/obj/item/clothing/shirt/robe/colored/mage/Initialize()
	color = pick(CLOTHING_BERRY_BLUE, CLOTHING_SPRING_GREEN, CLOTHING_TARAXACUM_YELLOW, CLOTHING_WINESTAIN_RED)
	. = ..()

/obj/item/clothing/shirt/robe/wizard
	name = "wizard's robe"
	desc = "What wizard's ensemble would be complete without robes?"
	icon_state = "wizardrobes"
	sellprice = 100

/obj/item/clothing/shirt/robe/magus
	name = "magus's robe"
	desc = "A dark padded robe worn by only the most mysterious of mages, the magi."
	icon_state = "warlock"
	allowed_sex = list(MALE)
	allowed_race = SPECIES_BASE_BODY
	sellprice = 70

	armor = list("blunt" = 40, "slash" = 40, "stab" = 40,  "piercing" = 15, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_TWIST)
	max_integrity = 200

/obj/item/clothing/shirt/robe/merchant
	name = "guilder jacket"
	desc = "A fancy jacket common with members of the Mercator Guild."
	icon_state = "merrobe"
	sellprice = 30

/obj/item/clothing/shirt/robe/nun
	name = "nun habit"
	icon_state = "nun"
	item_state = "nun"
	allowed_race = SPECIES_BASE_BODY
	allowed_sex = list(FEMALE)

/obj/item/clothing/shirt/robe/feld
	name = "feldsher's robe"
	desc = "Red to hide the blood."
	icon_state = "feldrobe"
	item_state = "feldrobe"

/obj/item/clothing/shirt/robe/phys
	name = "physicker's robe"
	desc = "Part robe, part butcher's apron."
	icon_state = "surgrobe"
	item_state = "surgrobe"

/obj/item/clothing/shirt/robe/courtphysician
	name = "court physician's robe"
	desc = "The dark red helps hide blood stains, and is elegant."
	icon_state = "courtrobe"
	item_state = "courtrobe"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'

/obj/item/clothing/shirt/robe/archivist
	name = "archivist's robe"
	desc = "Robes belonging to seekers of knowledge."
	icon_state = "archivist"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'
	boobed = TRUE
	flags_inv = HIDEBOOB
	allowed_race = SPECIES_BASE_BODY
	color = null
	sellprice = 100

/obj/item/clothing/shirt/robe/newmage
	name = "mage robe"
	desc = "base mage robe"
	icon_state = "adept-red"
	icon = 'icons/roguetown/clothing/shirts.dmi'
	color = null
	slot_flags = ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/shirts.dmi'
	toggle_icon_state = TRUE
	armor = ARMOR_PADDED_BAD
	max_integrity = 200
	color = null
	hoodtype = /obj/item/clothing/head/hooded/magehood
	salvage_result = /obj/item/natural/cloth
	var/picked
	var/newicon
	var/robe_count = 0	/// This var basicly counts the numbers of times this robe has changes its appearence
	abstract_type = /obj/item/clothing/shirt/robe/newmage

/obj/item/clothing/shirt/robe/newmage/ToggleHood()
	if(!hoodtoggled)
		if(ishuman(src.loc))
			var/mob/living/carbon/human/H = src.loc
			if(slot_flags & ITEM_SLOT_ARMOR)
				if(H.wear_armor != src)
					to_chat(H, span_warning("I should put that on first."))
					return
			if(slot_flags & ITEM_SLOT_CLOAK)
				if(H.cloak != src)
					to_chat(H, span_warning("I should put that on first."))
					return
			if(H.head)
				to_chat(H, span_warning("I'm already wearing something on my head."))
				return
			else if(H.equip_to_slot_if_possible(hood,ITEM_SLOT_HEAD,0,0,1))
				hoodtoggled = TRUE
				if(!picked)
					if(toggle_icon_state)
						src.icon_state = "[initial(icon_state)]-hood"
				else
					if(toggle_icon_state)
						src.icon_state = "[newicon]-hood"
						hood.icon_state = newicon
				H.update_inv_wear_suit()
				H.update_inv_cloak()
				H.update_inv_neck()
				H.update_inv_pants()
				H.update_fov_angles()
	else
		RemoveHood()

/obj/item/clothing/shirt/robe/newmage/RemoveHood()
	if(!hood)
		return
	if(!picked)
		src.icon_state = "[initial(icon_state)]"
	else
		src.icon_state = newicon
		hood.icon_state = newicon
	hoodtoggled = FALSE
	if(ishuman(hood.loc))
		var/mob/living/carbon/H = hood.loc
		H.transferItemToLoc(hood, src, TRUE)
		hood.moveToNullspace()
		H.update_inv_wear_suit()
		H.update_inv_cloak()
		H.update_inv_neck()
		H.update_inv_pants()
		H.update_fov_angles()
	else
		hood.moveToNullspace()

/obj/item/clothing/shirt/robe/newmage/adept
	name = "adept robe"
	desc = "Standard robes for an arcyne adept."
	icon = 'icons/roguetown/clothing/shirts.dmi'
	icon_state = "adept-red"
	item_state = "adept-red"
	hoodtype = /obj/item/clothing/head/hooded/magehood/adept


/obj/item/clothing/shirt/robe/newmage/adept/MiddleClick(mob/user, list/modifiers)
	. = ..()
	if(!do_after(user, 20, target = user))
		return
	if(robe_count == 0)
		icon_state = "adept-blue"
		hood.icon_state = "adept-blue"
		newicon = "adept-blue"
		robe_count += 1
	else if(robe_count == 1)
		icon_state = "adept-green"
		hood.icon_state = "adept-green"
		newicon = "adept-green"
		robe_count += 1
	else if(robe_count == 2)
		icon_state = "adept-gray"
		hood.icon_state = "adept-gray"
		newicon = "adept-gray"
		robe_count += 1
	else if(robe_count == 3)
		icon_state = "adept-red"
		hood.icon_state = "adept-red"
		newicon = "adept-red"
		robe_count = 0
	picked = TRUE
	to_chat(user, span_info("[src] magically changes it's colours!"))
	playsound(src, 'sound/magic/swap.ogg', 50, TRUE)


/obj/item/clothing/shirt/robe/newmage/sorcerer
	name = "sorcerer robe"
	desc = "Standard robes for an arcyne sorcerer."
	icon = 'icons/roguetown/clothing/shirts.dmi'
	icon_state = "sorcerer-red"
	item_state = "sorcerer-red"
	hoodtype = /obj/item/clothing/head/hooded/magehood/sorcerer

/obj/item/clothing/shirt/robe/newmage/sorcerer/MiddleClick(mob/user, list/modifiers)
	. = ..()
	if(!do_after(user, 20, target = user))
		return
	if(robe_count == 0)
		icon_state = "sorcerer-blue"
		hood.icon_state = "sorcerer-blue"
		newicon = "sorcerer-blue"
		robe_count += 1
	else if(robe_count == 1)
		icon_state = "sorcerer-green"
		hood.icon_state = "sorcerer-green"
		newicon = "sorcerer-green"
		robe_count += 1
	else if(robe_count == 2)
		icon_state = "sorcerer-gray"
		hood.icon_state = "sorcerert-gray"
		newicon = "sorcerer-gray"
		robe_count += 1
	else if(robe_count == 3)
		icon_state = "sorcerer-red"
		hood.icon_state = "sorcerer-red"
		newicon = "sorcerer-red"
		robe_count = 0
	picked = TRUE
	to_chat(user, span_info("[src] magically changes it's colours!"))
	playsound(src, 'sound/magic/swap.ogg', 50, TRUE)


/obj/item/clothing/shirt/robe/newmage/warlock
	name = "warlock robe"
	desc = "Standard robes for an arcyne sorcerer."
	icon = 'icons/roguetown/clothing/shirts.dmi'
	icon_state = "vizier-red"
	item_state = "vizier-red"
	sleevetype = "shirt"
	hoodtype = null

/obj/item/clothing/shirt/robe/newmage/warlock/MiddleClick(mob/user, list/modifiers)
	. = ..()
	if(!do_after(user, 20, target = user))
		return
	if(robe_count == 0)
		icon_state = "vizier-blue"
		newicon = "vizier-blue"
		robe_count += 1
	else if(robe_count == 1)
		icon_state = "vizier-green"
		newicon = "vizier-green"
		robe_count += 1
	else if(robe_count == 2)
		icon_state = "vizier-gray"
		newicon = "vizier-gray"
		robe_count += 1
	else if(robe_count == 3)
		icon_state = "vizier-red"
		newicon = "vizier-red"
		robe_count = 0
	picked = TRUE
	to_chat(user, span_info("[src] magically changes it's colours!"))
	playsound(src, 'sound/magic/swap.ogg', 50, TRUE)

/obj/item/clothing/shirt/robe/faceless
	desc = "A slimmed down, fitting robe made of fine silks and fabrics."
	color = null
	icon_state = "facelesscloth" //Credit goes to Cre
	item_state = "facelesscloth"

/obj/item/clothing/shirt/robe/kimono
	name = "kimono"
	desc = "Worn by merchants of Zhongese."
	color = null
	icon_state = "kimono"
	item_state = "kimono"
	sleeved = null
	sleevetype = null
	item_flags = ABSTRACT
