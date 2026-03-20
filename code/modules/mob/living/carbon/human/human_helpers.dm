
/mob/living/carbon/human/proc/change_name(new_name)
	real_name = new_name

/mob/living/carbon/human/check_language_hear(language)
	var/mob/living/carbon/V = src
	if(!language)
		return
	if(wear_neck)
		if(istype(wear_neck, /obj/item/clothing/neck/talkstone))
			return TRUE
	if(!has_language(language))
		if(has_quirk(/datum/quirk/vice/paranoid))
			V.add_stress(/datum/stress_event/para/talk)

/mob/living/carbon/human/canBeHandcuffed()
	if(num_hands < 2)
		return FALSE
	return TRUE

//gets assignment from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_assignment(if_no_id = "No id", if_no_job = "No job", hand_first = TRUE)
	return if_no_job

//gets name from ID or ID inside PDA or PDA itself
//Useful when player do something with computers
/mob/living/carbon/human/proc/get_authentification_name(if_no_id = "Unknown")
	return if_no_id

//repurposed proc. Now it combines get_id_name() and get_face_name() to determine a mob's name variable. Made into a separate proc as it'll be useful elsewhere
/// html_tags surrounds the real name with tags to differentiate it from the rest of the name. Used for examine strings.
/// html_tags = list("EM", "B")
/mob/living/carbon/get_visible_name(if_none = "Unknown", list/html_tags)
	if(name_override)
		return name_override
	var/face_name = get_face_name(if_none, html_tags)
	var/id_name = get_id_name(if_none, html_tags)
	// Face takes priority if its visible, then your ID
	if(face_name != id_name)
		return face_name != if_none ? face_name : id_name
	return if_none || "Unknown" // I'm really not sure why you would try and call this null but just in case

/// Returns "Unknown" if facially disfigured and real_name if not. Useful for setting name when Fluacided or when updating a human's name variable
/mob/living/carbon/proc/get_face_name(if_no_face = "Unknown", list/html_tags, include_honoraries=TRUE)
	if(!is_human_part_visible(src, HIDEFACE))
		return if_no_face
	var/obj/item/bodypart/O = get_bodypart(BODY_ZONE_HEAD)
	if( !O || (HAS_TRAIT(src, TRAIT_DISFIGURED)) || !real_name || O.skeletonized )	//disfigured. use id-name if possible
		return if_no_face
	. = real_name
	for(var/tag in html_tags)
		. = html_tag(tag, .)
	if(include_honoraries)
		if(honorary)
			. = "[honorary] [.]"
		if(SSticker.regent_mob == src)
			. = "Regent [.]"
		if(honorary_suffix)
			. += " [honorary_suffix]"

//gets name from ID or PDA itself, ID inside PDA doesn't matter
//Useful when player is being seen by other mobs
/mob/living/carbon/proc/get_id_name(if_no_id = "Unknown", html_tags)
	return if_no_id //to prevent null-names making the mob unclickable

/mob/living/carbon/human/IsAdvancedToolUser()
	if(HAS_TRAIT(src, TRAIT_MONKEYLIKE))
		return FALSE
	return TRUE//Humans can use guns and such

/mob/living/carbon/human/reagent_check(datum/reagent/R)
	return dna.species.handle_chemicals(R,src)
	// if it returns 0, it will run the usual on_mob_life for that reagent. otherwise, it will stop after running handle_chemicals for the species.


/mob/living/carbon/human/can_track(mob/living/user)
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/hat = head
		if(hat.blockTracking)
			return 0

	return ..()

/mob/living/carbon/human/can_use_guns(obj/item/G)
	. = ..()
	if(G.trigger_guard == TRIGGER_GUARD_NORMAL)
		if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS))
			to_chat(src, "<span class='warning'>My meaty finger is much too large for the trigger guard!</span>")
			return FALSE
	if(HAS_TRAIT(src, TRAIT_NOGUNS))
		to_chat(src, "<span class='warning'>I can't bring myself to use a ranged weapon!</span>")
		return FALSE

/mob/living/carbon/human/get_policy_keywords()
	. = ..()
	. += "[dna.species.type]"

/mob/living/carbon/human/can_see_reagents()
	. = ..()
	if(.) //No need to run through all of this if it's already true.
		return
	if(isclothing(head) && (head.clothing_flags & SCAN_REAGENTS))
		return TRUE
	if(isclothing(wear_mask) && (wear_mask.clothing_flags & SCAN_REAGENTS))
		return TRUE

/mob/living/carbon/human/get_punch_dmg()
	if(QDELETED(src) || !ishuman(src))
		return

	var/damage
	if(GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH) > 12 || GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH) < 10)
		damage = GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH)
	else
		damage = 12

	var/used_str = GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH)

	if(mind?.has_antag_datum(/datum/antagonist/werewolf))
		return damage * 2

	if(domhand)
		used_str = get_str_arms(used_hand)

	var/obj/G = get_item_by_slot(ITEM_SLOT_GLOVES)
	if(istype(G, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/GL = G
		damage = (damage * GL.unarmed_bonus)

	if(used_str >= 11)
		damage = max(damage * (1 + ((used_str - 10) * 0.03)), 1)
	if(used_str <= 9)
		damage = max(damage * (1 - ((10 - used_str) * 0.05)), 1)

	var/obj/item/bodypart/BP = has_hand_for_held_index(used_hand)
	if(istype(BP))
		damage *= BP.punch_modifier

	damage += dna.species.punch_damage
	return damage

/mob/living/carbon/human/proc/get_kick_damage(multiplier = 1)
	if(QDELETED(src) || !ishuman(src))
		return

	var/damage = 12
	var/used_str = GET_MOB_ATTRIBUTE_VALUE(src, STAT_STRENGTH)
	damage += dna?.species?.kick_damage || 0

	if(mind?.has_antag_datum(/datum/antagonist/werewolf))
		return 30 * multiplier

	if(used_str >= 11)
		damage = max(damage + (damage * ((used_str - 10) * 0.3)), 1)
	if(used_str <= 9)
		damage = max(damage - (damage * ((10 - used_str) * 0.1)), 1)

	if(shoes)
		damage *= (1 + (shoes.armor_class * 0.2))

	return damage * multiplier

/// Fully randomizes everything in the character.
// Reflect changes in [datum/preferences/proc/randomise_appearance_prefs]
/mob/living/carbon/human/proc/randomize_human_appearance(randomise_flags = ALL, include_donator = TRUE)
	if(!dna)
		return

	if(randomise_flags & RANDOMIZE_SPECIES)
		var/rando_race = GLOB.species_list[pick(GLOB.roundstart_species)]
		set_species(rando_race, FALSE)

	var/datum/species/species = dna.species

	if(NOEYESPRITES in species?.species_traits)
		randomise_flags &= ~RANDOMIZE_EYE_COLOR

	if(randomise_flags & RANDOMIZE_GENDER)
		gender = species.sexes ? pick(MALE, FEMALE) : PLURAL

	if(randomise_flags & RANDOMIZE_AGE)
		age = pick(species.possible_ages)

	if(randomise_flags & RANDOMIZE_NAME)
		real_name = species.random_name(gender, TRUE)

	if(randomise_flags & RANDOMIZE_UNDERWEAR)
		underwear = species.random_underwear(gender)

	if(randomise_flags & RANDOMIZE_SKIN_TONE)
		var/list/skin_list = species.get_skin_list()
		skin_tone = pick_assoc(skin_list)

	if(randomise_flags & RANDOMIZE_EYE_COLOR)
		set_eye_color(random_eye_color(TRUE))

	// if(randomise_flags & RANDOMIZE_FEATURES)
	// 	dna.features = random_features()

/*
* Family Tree subsystem helpers
* I was tired of editing indvidual values
* across fluff.dm and death.dm so im simplifying
* the process. They check with these procs that
* i can edit from here. -IP
*/
/mob/living/carbon/human/proc/RomanticPartner(mob/living/carbon/human/H)
	if(!ishuman(H))
		return
	if(spouse_mob == H)
		return TRUE

/mob/living/carbon/human/proc/IsWedded(mob/living/carbon/human/wedder)
	if(spouse_mob)
		return TRUE

//Instead of putting the spouse variable everywhere its all funneled through this proc.
/mob/living/carbon/human/proc/MarryTo(mob/living/carbon/human/spouse)
	if(!ishuman(spouse))
		return null

	// Set basic spouse relationship
	spouse_mob = spouse
	spouse.spouse_mob = src

	// Handle family integration
	var/datum/heritage/primary_family = null
	//var/datum/heritage/secondary_family = null
	var/datum/family_member/primary_member = null
	var/datum/family_member/secondary_member = null

	// Determine which family takes precedence
	if(family_datum && !spouse.family_datum)
		// Spouse joins our family
		primary_family = family_datum
		primary_member = family_member_datum
		secondary_member = primary_family.CreateFamilyMember(spouse)

	else if(!family_datum && spouse.family_datum)
		// We join spouse's family
		primary_family = spouse.family_datum
		primary_member = spouse.family_member_datum
		secondary_member = primary_family.CreateFamilyMember(src)

	else if(family_datum && spouse.family_datum)
		// Both have families - keep separate but mark as married
		primary_family = family_datum
		primary_member = family_member_datum
		secondary_member = spouse.family_member_datum

	else
		// Neither has family - create new one
		var/new_family_name = null
		// Use the male's surname traditionally, or first person's if no male
		if(gender == MALE)
			new_family_name = family_datum?.SurnameFormatting(src)
		else if(spouse.gender == MALE)
			new_family_name = family_datum?.SurnameFormatting(spouse)

		primary_family = new /datum/heritage(src, new_family_name)
		primary_member = primary_family.founder
		secondary_member = primary_family.CreateFamilyMember(spouse)

	// Add spouse relationship in family system
	if(primary_member && secondary_member && primary_family)
		primary_family.MarryMembers(primary_member, secondary_member)

	return primary_family

//Perspective stranger looks at --> src
/mob/living/carbon/human/proc/ReturnRelation(mob/living/carbon/human/stranger)
	return family_datum.ReturnRelation(src, stranger)

/mob/living/carbon/human/proc/highest_ac_worn(check_hands = FALSE)
	var/list/slots = DEFAULT_SLOT_PRIORITY - (check_hands ? null : ITEM_SLOT_HANDS)

	var/highest_ac = ARMOR_CLASS_NONE
	for(var/slot in slots)
		var/obj/item/clothing/clothes = get_item_by_slot(slot)
		if(!istype(clothes))
			continue

		if(clothes.armor_class == AC_HEAVY)
			return AC_HEAVY

		if(clothes.armor_class > highest_ac)
			highest_ac = clothes.armor_class

	return highest_ac
