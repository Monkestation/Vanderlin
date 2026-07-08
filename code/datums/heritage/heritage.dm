/datum/heritage
	var/housename
	var/datum/species/dominant_species
	var/list/members = list()
	var/list/family_icons = list()
	var/datum/family_member/founder

	var/list/family_curses = list()
	var/list/curse_history = list()

/datum/heritage/New(mob/living/carbon/human/founder_person, new_name, majority_species)
	if(!founder_person)
		dominant_species = majority_species
		return

	founder = CreateFamilyMember(founder_person)
	housename = new_name || SurnameFormatting(founder_person)
	dominant_species = majority_species || founder_person?.dna?.species?.type

/datum/heritage/proc/CreateFamilyMember(mob/living/carbon/human/person)
	if(!ishuman(person))
		return null

	for(var/datum/family_member/existing in members)
		if(existing.person == person)
			return existing

	var/datum/family_member/new_member = new(person, src)
	members += new_member
	person.family_datum = src
	person.family_member_datum = new_member

	AddFamilyIcon(person)
	LateJoinAddToUI(person)
	LearnFamilyIdentities(person)

	return new_member

/datum/heritage/proc/GetFamilyMemberByMind(datum/mind/M)
	if(!M)
		return null
	for(var/datum/family_member/member in members)
		if(member.person?.mind == M)
			return member
	return null

/datum/heritage/proc/AddToFamily(mob/living/carbon/human/person, datum/family_member/parent1, datum/family_member/parent2, adopt = FALSE)
	var/datum/family_member/new_member = CreateFamilyMember(person)
	if(!new_member)
		return null

	new_member.adoption_status = adopt

	if(parent1)
		link_family(person.mind, parent1.person?.mind, FAMILY_MEMBER_CHILD, adopted = adopt)
		link_family(parent1.person?.mind, person.mind, FAMILY_MEMBER_PARENT, adopted = adopt)

	if(parent2)
		link_family(person.mind, parent2.person?.mind, FAMILY_MEMBER_CHILD, adopted = adopt)
		link_family(parent2.person?.mind, person.mind, FAMILY_MEMBER_PARENT, adopted = adopt)

	// Link to existing siblings via shared parent.
	var/list/linked_siblings = list()
	for(var/datum/family_member/parent in list(parent1, parent2))
		if(!parent?.person?.mind)
			continue
		for(var/datum/relation/family/R in parent.person.mind.relations)
			if(R.bond_type != FAMILY_MEMBER_PARENT)
				continue
			if(R.other == person.mind)
				continue
			if(R.other in linked_siblings)
				continue
			linked_siblings += R.other
			link_family(person.mind, R.other, FAMILY_MEMBER_SIBLING, adopted = adopt)
			link_family(R.other, person.mind, FAMILY_MEMBER_SIBLING, adopted = adopt)

	// Attempt biological DNA mixing; force adoption if species are incompatible.
	if(!adopt && parent1 && parent2)
		if(SpeciesCalculation(person, parent1.person, parent2.person))
			person?.MixDNA(parent1.person, parent2.person, override = TRUE)
		else
			new_member.adoption_status = TRUE

	to_chat(person, span_notice("You have been added to the [housename] family."))
	InheritCurses(new_member)
	return new_member

/datum/heritage/proc/GetFamilyMember(mob/living/carbon/human/person)
	for(var/datum/family_member/member in members)
		if(member.person == person)
			return member
	return null

/datum/heritage/proc/MarryMembers(datum/family_member/person1, datum/family_member/person2)
	if(!person1 || !person2)
		return FALSE

	var/datum/mind/mind1 = person1.person?.mind
	var/datum/mind/mind2 = person2.person?.mind
	if(!mind1 || !mind2)
		return FALSE

	for(var/datum/relation/family/R in mind1.relations)
		if(R.other == mind2 && R.bond_type == FAMILY_MEMBER_SPOUSE)
			return FALSE

	link_family(mind1, mind2, FAMILY_MEMBER_SPOUSE)

	// Stamp in-law relations across both sides.
	_stamp_inlaw_relations(mind1, mind2)
	_stamp_inlaw_relations(mind2, mind1)

	to_chat(person1.person, span_love("You are now married to [person2.person?.real_name]!"))
	to_chat(person2.person, span_love("You are now married to [person1.person?.real_name]!"))
	return TRUE

// For every blood/adopted relation that `their_side` has, give `my_side` an in-law link to them.
/datum/heritage/proc/_stamp_inlaw_relations(datum/mind/my_side, datum/mind/their_side)
	for(var/datum/relation/family/R in their_side.relations)
		if(R.bond_type == FAMILY_MEMBER_SPOUSE)
			continue  // don't in-law the spouse's other spouses
		if(R.in_law)
			continue  // don't chain in-laws of in-laws

		// Mirror the bond type from their perspective to ours.
		var/inlaw_bond = R.bond_type
		link_family(my_side, R.other, inlaw_bond, in_law = TRUE)
		link_family(R.other, my_side, _mirror_bond(inlaw_bond), in_law = TRUE)

/datum/heritage/proc/_mirror_bond(bond_type)
	switch(bond_type)
		if(FAMILY_MEMBER_PARENT)  return FAMILY_MEMBER_CHILD
		if(FAMILY_MEMBER_CHILD)   return FAMILY_MEMBER_PARENT
		if(FAMILY_MEMBER_SIBLING) return FAMILY_MEMBER_SIBLING
	return bond_type

/datum/heritage/proc/ConductWedding(datum/family_member/bride, datum/family_member/groom, mob/living/carbon/human/officiant)
	if(!bride || !groom || !officiant)
		return FALSE
	if(!MarryMembers(bride, groom))
		return FALSE

	var/announcement = "[bride.person?.real_name] and [groom.person?.real_name] have been wed in the [housename] family!"
	for(var/datum/family_member/member in members)
		if(member.person?.client)
			to_chat(member.person, span_love(announcement))

	// Retroactively legitimise any shared children.
	_legitimise_shared_children(bride, groom)
	return TRUE

// After a wedding, re-check children shared by both spouses and mix DNA
// if species are now compatible.
/datum/heritage/proc/_legitimise_shared_children(datum/family_member/p1, datum/family_member/p2)
	if(!p1.person?.mind || !p2.person?.mind)
		return
	for(var/datum/relation/family/R in p1.person.mind.relations)
		if(R.bond_type != FAMILY_MEMBER_PARENT)
			continue
		var/datum/mind/child_mind = R.other
		// Check p2 also has a parent relation to this child.
		for(var/datum/relation/family/R2 in p2.person.mind.relations)
			if(R2.bond_type == FAMILY_MEMBER_PARENT && R2.other == child_mind)
				var/mob/living/carbon/human/child_mob = child_mind?.current
				if(!ishuman(child_mob))
					continue
				if(SpeciesCalculation(child_mob, p1.person, p2.person))
					var/datum/family_member/child_member = GetFamilyMember(child_mob)
					if(child_member)
						child_member.adoption_status = FALSE
					child_mob.MixDNA(p1.person, p2.person, override = TRUE)
				break

/datum/heritage/proc/AddFamilyCurse(datum/family_curse/curse_type, severity, mob/curser)
	var/datum/family_curse/new_curse = new curse_type()
	new_curse.curse_type = curse_type
	new_curse.severity = severity
	new_curse.cursed_by = WEAKREF(curser)
	new_curse.when_cursed = world.time

	family_curses += new_curse
	curse_history += "The [housename] family was cursed with [new_curse.name] by [curser?.real_name || "unknown"]"

	ApplyCurseEffects(new_curse)
	return new_curse

/datum/heritage/proc/ApplyCurseEffects(datum/family_curse/curse)
	for(var/datum/family_member/F in members)
		if(!F.person) continue
		for(var/effect in curse.curse_effects)
			F.person.apply_status_effect(effect)

/datum/heritage/proc/InheritCurses(datum/family_member/child)
	for(var/datum/family_curse/curse in family_curses)
		if(!curse.inherited) continue
		for(var/effect in curse.curse_effects)
			child.person?.apply_status_effect(effect)

/datum/heritage/proc/ReturnRelation(mob/living/carbon/human/lookee, mob/living/carbon/human/looker)
	if(lookee == looker)
		return null

	var/datum/family_member/looker_member = GetFamilyMember(looker)
	var/datum/family_member/lookee_member = GetFamilyMember(lookee)

	if(!looker_member || !lookee_member)
		return null

	var/relationship = looker_member.GetRelationshipTo(lookee_member)
	if(!relationship)
		return null

	var/p_He = lookee.p_they(TRUE)
	var/rel_text = "[p_He] is my [relationship]"
	if(lookee_member.adoption_status && (relationship in list("son", "daughter", FAMILY_MEMBER_CHILD)))
		rel_text += " (adopted)"

	return span_love(span_bold("[rel_text]."))

/datum/heritage/proc/SpeciesCalculation(mob/living/carbon/human/child, mob/living/carbon/human/parent1, mob/living/carbon/human/parent2)
	var/datum/species/child_sp = child.dna?.species
	var/datum/species/p1_sp = parent1?.dna?.species
	var/datum/species/p2_sp = parent2?.dna?.species

	if(!child_sp || !p1_sp || !p2_sp)
		return FALSE

	if(istype(p1_sp, p2_sp) && istype(child_sp, p1_sp))
		return TRUE

	var/list/mix_map = list(
		"human+elf"     = /datum/species/human/halfelf,
		"human+halforc" = /datum/species/halforc,
	)

	var/list/tags = list()
	if(istype(p1_sp, /datum/species/human/northern)    || istype(p2_sp, /datum/species/human/northern))    tags += "human"
	if(istype(p1_sp, /datum/species/elf/snow)          || istype(p2_sp, /datum/species/elf/snow))          tags += "elf"
	if(istype(p1_sp, /datum/species/elf/dark)          || istype(p2_sp, /datum/species/elf/dark))          tags += "darkelf"
	if(istype(p1_sp, /datum/species/dwarf/mountain)    || istype(p2_sp, /datum/species/dwarf/mountain))    tags += "dwarf"
	if(istype(p1_sp, /datum/species/tieberian)         || istype(p2_sp, /datum/species/tieberian))         tags += "tiefling"
	if(istype(p1_sp, /datum/species/rakshari)          || istype(p2_sp, /datum/species/rakshari))          tags += "rakshari"
	if(istype(p1_sp, /datum/species/halforc)           || istype(p2_sp, /datum/species/halforc))           tags += "halforc"

	sortTim(tags, GLOBAL_PROC_REF(cmp_text_asc))
	var/mix_key = tags.Join("+")

	return istype(child_sp, mix_map[mix_key])

/datum/heritage/proc/SurnameFormatting(mob/living/carbon/human/person)
	var/full_name = person?.real_name
	if(!full_name)
		return person?.dna?.species?.random_surname()

	if(findtext(full_name, " of ") || findtext(full_name, " the "))
		return person.dna.species.random_surname()

	var/space = findtext(full_name, " ")
	if(!space)
		return person.dna.species.random_surname()

	person.original_name = full_name
	return copytext(full_name, space)

/datum/heritage/proc/AddFamilyIcon(mob/living/carbon/human/famicon)
	var/datum/family_member/member = GetFamilyMember(famicon)
	if(!member)
		return FALSE

	var/icon_state = member.adoption_status ? "adopted" : "related"
	var/image/I = new('icons/relations.dmi', loc = famicon, icon_state = icon_state)

	if(famicon in family_icons)
		family_icons.Remove(famicon)
	family_icons[famicon] = I
	return TRUE

/datum/heritage/proc/LateJoinAddToUI(mob/living/carbon/human/new_fam)
	for(var/datum/family_member/member in members)
		var/mob/living/carbon/human/H = member.person
		if(H?.family_UI && H.client && H != new_fam && (new_fam in family_icons))
			H.client.images.Add(family_icons[new_fam])

/datum/heritage/proc/ApplyUI(mob/living/carbon/human/iconer, toggle_true = FALSE)
	if(!iconer.client)
		return FALSE
	for(var/mob/living/carbon/human/H in family_icons)
		if(toggle_true)
			iconer.client.images.Remove(family_icons[H])
			continue
		if(!H || H == iconer)
			continue
		iconer.client.images.Add(family_icons[H])

/datum/heritage/proc/LearnFamilyIdentities(mob/living/carbon/human/new_member)
	for(var/datum/family_member/existing in members)
		var/mob/living/carbon/human/fam = existing.person
		if(fam == new_member || !new_member.mind || !fam?.mind)
			continue
		new_member.mind.share_identities(fam.mind)

/datum/family_member
	var/tmp/mob/living/carbon/human/person
	var/datum/heritage/family
	var/adoption_status = FALSE

/datum/family_member/New(mob/living/carbon/human/new_person, datum/heritage/new_family)
	person = new_person
	family = new_family

// Returns a plain-text label for the relationship from src's perspective.
/datum/family_member/proc/GetRelationshipTo(datum/family_member/other)
	if(!other || other == src)
		return null

	var/datum/mind/my_mind   = person?.mind
	var/datum/mind/their_mind = other.person?.mind
	if(!my_mind || !their_mind)
		return null

	for(var/datum/relation/family/R in my_mind.relations)
		if(R.other != their_mind)
			continue

		var/adopted_prefix = R.adopted ? "adopted " : ""
		var/inlaw_suffix   = R.in_law  ? "-in-law"  : ""

		switch(R.bond_type)
			if(FAMILY_MEMBER_CHILD)
				if(other.person?.gender == MALE)
					return "[adopted_prefix]father[inlaw_suffix]"
				else if(other.person?.gender == FEMALE)
					return "[adopted_prefix]mother[inlaw_suffix]"
				else
					return "[adopted_prefix]parent[inlaw_suffix]"

			if(FAMILY_MEMBER_PARENT)
				if(other.person?.gender == MALE)
					return "[adopted_prefix]son[inlaw_suffix]"
				else if(other.person?.gender == FEMALE)
					return "[adopted_prefix]daughter[inlaw_suffix]"
				else
					return "[adopted_prefix]child[inlaw_suffix]"

			if(FAMILY_MEMBER_SPOUSE)
				if(other.person?.gender == MALE)
					return "husband"
				else if(other.person?.gender == FEMALE)
					return "wife"
				else
					return "spouse"

			if(FAMILY_MEMBER_SIBLING)
				if(other.person?.gender == MALE)
					return "[adopted_prefix]brother[inlaw_suffix]"
				else if(other.person?.gender == FEMALE)
					return "[adopted_prefix]sister[inlaw_suffix]"
				else
					return "[adopted_prefix]sibling[inlaw_suffix]"

	// Two-hop relations.
	var/two_hop = two_hop_relation(my_mind, their_mind, other.person?.gender)
	if(two_hop)
		return two_hop

	// In-law relations (really just a fallback)
	var/in_law = in_law_relation(my_mind, their_mind, other.person?.gender)
	if(in_law)
		return in_law

	return "distant relative"

// Grandparent, grandchild, aunt/uncle, niece/nephew, cousin. Anything two hops away.
/datum/family_member/proc/two_hop_relation(datum/mind/mine, datum/mind/theirs, gender)
	for(var/datum/relation/family/hop1 in mine.relations)
		var/datum/mind/mid = hop1.other
		for(var/datum/relation/family/hop2 in mid.relations)
			if(hop2.other != theirs)
				continue

			if(hop1.bond_type == FAMILY_MEMBER_CHILD && hop2.bond_type == FAMILY_MEMBER_CHILD)
				if(gender == MALE)
					return "grandfather"
				else if(gender == FEMALE)
					return "grandmother"
				else
					return "grandparent"

			if(hop1.bond_type == FAMILY_MEMBER_PARENT && hop2.bond_type == FAMILY_MEMBER_PARENT)
				if(gender == MALE)
					return "grandson"
				else if(gender == FEMALE)
					return "granddaughter"
				else
					return "grandchild"

			if(hop1.bond_type == FAMILY_MEMBER_CHILD && hop2.bond_type == FAMILY_MEMBER_SIBLING)
				if(gender == MALE)
					return "uncle"
				else if(gender == FEMALE)
					return "aunt"
				else
					return "parent's sibling"

			if(hop1.bond_type == FAMILY_MEMBER_SIBLING && hop2.bond_type == FAMILY_MEMBER_PARENT)
				if(gender == MALE)
					return "nephew"
				else if(gender == FEMALE)
					return "niece"
				else
					return "sibling's child"

			if(hop1.bond_type == FAMILY_MEMBER_CHILD)
				for(var/datum/relation/family/hop3 in mid.relations)
					if(hop3.bond_type != FAMILY_MEMBER_SIBLING)
						continue
					for(var/datum/relation/family/hop4 in hop3.other.relations)
						if(hop4.other == theirs && hop4.bond_type == FAMILY_MEMBER_PARENT)
							return "cousin"

	for(var/datum/relation/family/a in mine.relations)
		for(var/datum/relation/family/b in a.other.relations)
			for(var/datum/relation/family/c in b.other.relations)
				if(c.other != theirs)
					continue
				if(a.bond_type == FAMILY_MEMBER_CHILD && b.bond_type == FAMILY_MEMBER_CHILD && c.bond_type == FAMILY_MEMBER_CHILD)
					if(gender == MALE)
						return "great-grandfather"
					else if(gender == FEMALE)
						return "great-grandmother"
					else
						return "great-grandparent"
				if(a.bond_type == FAMILY_MEMBER_PARENT && b.bond_type == FAMILY_MEMBER_PARENT && c.bond_type == FAMILY_MEMBER_PARENT)
					if(gender == MALE)
						return "great-grandson"
					else if(gender == FEMALE)
						return "great-granddaughter"
					else
						return "great-grandchild"

	return null

/datum/family_member/proc/in_law_relation(datum/mind/mine, datum/mind/theirs, gender)
	for(var/datum/relation/family/R in mine.relations)
		if(R.bond_type != FAMILY_MEMBER_SPOUSE)
			continue
		var/datum/mind/spouse = R.other
		for(var/datum/relation/family/S in spouse.relations)
			if(S.other == theirs)
				switch(S.bond_type)
					if(FAMILY_MEMBER_CHILD)
						if(gender == MALE)
							return "father-in-law"
						else if(gender == FEMALE)
							return "mother-in-law"
						else
							return "parent-in-law"
					if(FAMILY_MEMBER_PARENT)
						if(gender == MALE)
							return "son-in-law"
						else if(gender == FEMALE)
							return "daughter-in-law"
						else
							return "child-in-law"
					if(FAMILY_MEMBER_SIBLING)
						if(gender == MALE)
							return "brother-in-law"
						else if(gender == FEMALE)
							return "sister-in-law"
						else
							return "sibling-in-law"

	for(var/datum/relation/family/R in mine.relations)
		if(R.bond_type != FAMILY_MEMBER_SIBLING)
			continue
		for(var/datum/relation/family/S in R.other.relations)
			if(S.other == theirs && S.bond_type == FAMILY_MEMBER_SPOUSE)
				if(gender == MALE)
					return "brother-in-law"
				else if(gender == FEMALE)
					return "sister-in-law"
				else
					return "sibling-in-law"

	for(var/datum/relation/family/R in mine.relations)
		if(R.bond_type != FAMILY_MEMBER_PARENT)
			continue
		for(var/datum/relation/family/S in R.other.relations)
			if(S.other == theirs && S.bond_type == FAMILY_MEMBER_SPOUSE)
				if(gender == MALE)
					return "son-in-law"
				else if(gender == FEMALE)
					return "daughter-in-law"
				else
					return "child-in-law"

	return null

/datum/family_member/proc/has_children()
	if(!person?.mind)
		return FALSE
	for(var/datum/relation/family/R in person.mind.relations)
		if(R.bond_type == FAMILY_MEMBER_PARENT)
			return TRUE
	return FALSE

/datum/family_member/proc/has_parents()
	if(!person?.mind)
		return FALSE
	for(var/datum/relation/family/R in person.mind.relations)
		if(R.bond_type == FAMILY_MEMBER_CHILD)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/RomanticPartner(mob/living/carbon/human/H)
	if(!ishuman(H))
		return FALSE
	return (spouse_mob == H)

/mob/living/carbon/human/proc/IsWedded()
	return (spouse_mob != null)

/mob/living/carbon/human/proc/MarryTo(mob/living/carbon/human/spouse)
	if(!ishuman(spouse))
		return null

	spouse_mob = spouse
	spouse.spouse_mob = src

	var/datum/heritage/primary_family
	var/datum/family_member/primary_member
	var/datum/family_member/secondary_member

	if(family_datum && !spouse.family_datum)
		primary_family   = family_datum
		primary_member   = family_member_datum
		secondary_member = primary_family.CreateFamilyMember(spouse)

	else if(!family_datum && spouse.family_datum)
		primary_family   = spouse.family_datum
		primary_member   = spouse.family_member_datum
		secondary_member = primary_family.CreateFamilyMember(src)

	else if(family_datum && spouse.family_datum)
		primary_family   = family_datum
		primary_member   = family_member_datum
		secondary_member = spouse.family_member_datum

	else
		var/new_name
		if(gender == MALE)
			new_name = dna?.species?.random_surname() || real_name
		else if(spouse.gender == MALE)
			new_name = spouse.dna?.species?.random_surname() || spouse.real_name
		primary_family   = new /datum/heritage(src, new_name, dna?.species?.type)
		primary_member   = primary_family.founder
		secondary_member = primary_family.CreateFamilyMember(spouse)

	if(primary_family && primary_member && secondary_member)
		primary_family.MarryMembers(primary_member, secondary_member)

	return primary_family

/mob/living/carbon/human/proc/ReturnRelation(mob/living/carbon/human/stranger)
	return family_datum?.ReturnRelation(src, stranger)

/mob/living/carbon/human/verb/ToggleFamilyUI()
	set name = "Family UI"
	set category = "IC"
	ShowFamilyUI(FALSE)

/mob/living/carbon/human/proc/ShowFamilyUI(silent)
	if(spouse_mob) ApplySpouseUI(family_UI)
	if(family_datum) family_datum.ApplyUI(src, family_UI)
	else if(!silent) to_chat(src, "You're not part of any notable family.")

	family_UI = !family_UI
	if(!silent)
		to_chat(src, "FamilyUI Toggled [family_UI ? "On" : "Off"]")

/mob/living/carbon/human/proc/ApplySpouseUI(toggle_true = FALSE)
	if(!spouse_mob || !client)
		return
	if(!spouse_indicator)
		spouse_indicator = new('icons/relations.dmi', loc = spouse_mob, icon_state = "related")
	if(toggle_true)
		client.images.Remove(spouse_indicator)
	else
		client.images.Add(spouse_indicator)
