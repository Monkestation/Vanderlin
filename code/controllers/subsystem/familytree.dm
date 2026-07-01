SUBSYSTEM_DEF(familytree)
	name = "Family Manager"
	wait = 5 SECONDS
	lazy_load = FALSE

	/*
	* The family that kings, queens, and princes
	* are automatically placed into. Has no other
	* real function.
	*/
	var/datum/heritage/ruling_family
	var/list/families = list()
	var/list/viable_spouses = list()

	var/const/MAX_HOUSE_MEMBERS = 6

	var/datum/family_member/cached_monarch = null
	var/list/pending_latejoin = list()

	var/list/excluded_jobs = list(
		/datum/job/prince, /datum/job/advclass/heir,
		/datum/job/consort, /datum/job/advclass/consort,
		/datum/job/lord, /datum/job/hand,
		/datum/job/advclass/hand, /datum/job/adept,
		/datum/job/advclass/adept, /datum/job/orphan,
		/datum/job/innkeep_son, /datum/job/churchling,
	)

	var/list/preset_family_species = list(
		/datum/species/human/northern, /datum/species/elf,
		/datum/species/elf/dark, /datum/species/human/halfelf,
		/datum/species/dwarf/mountain, /datum/species/tieberian,
		/datum/species/aasimar, /datum/species/rakshari,
		/datum/species/halforc,
	)

/datum/controller/subsystem/familytree/Initialize()
	ruling_family = new /datum/heritage(null, "Royal", /datum/species/human/northern)

	for(var/species_type in preset_family_species)
		for(var/i in 1 to 2)
			families += new /datum/heritage(null, null, species_type)

	return ..()

/datum/controller/subsystem/familytree/fire(resumed)
	ResolvePendingLatejoins()

/datum/controller/subsystem/familytree/proc/GetAgeValue(age_string)
	switch(age_string)
		if(AGE_CHILD)      return 0
		if(AGE_ADULT)      return 1
		if(AGE_MIDDLEAGED) return 2
		if(AGE_OLD)        return 3
		if(AGE_IMMORTAL)   return 4
	return 1

/datum/controller/subsystem/familytree/proc/CanBeParentOf(parent_age, child_age)
	if(parent_age == AGE_IMMORTAL)
		return (child_age != AGE_IMMORTAL)
	if(parent_age == AGE_ADULT && child_age == AGE_CHILD)
		return TRUE
	return (GetAgeValue(parent_age) > GetAgeValue(child_age))

/datum/controller/subsystem/familytree/proc/CanBeSiblings(age1, age2)
	if(age1 == age2)
		return TRUE
	if(age1 == AGE_CHILD || age2 == AGE_CHILD)
		return FALSE
	return (abs(GetAgeValue(age1) - GetAgeValue(age2)) <= 1)


// Returns TRUE if adding `person` to `house` would violate parent/child age ordering.
/datum/controller/subsystem/familytree/proc/WouldCreateAgeConflict(datum/heritage/house, mob/living/carbon/human/person)
	for(var/datum/family_member/member in house.members)
		if(!member.person?.mind)
			continue
		for(var/datum/relation/family/R in member.person.mind.relations)
			if(R.bond_type == FAMILY_MEMBER_PARENT)
				var/datum/family_member/child = house.GetFamilyMemberByMind(R.other)
				if(child?.person && !CanBeParentOf(person.age, child.person.age))
					return TRUE
			if(R.bond_type == FAMILY_MEMBER_CHILD)
				var/datum/family_member/parent = house.GetFamilyMemberByMind(R.other)
				if(parent?.person && !CanBeParentOf(parent.person.age, person.age))
					return TRUE
	return FALSE

// Returns the structural role a person should occupy given the current house.
/datum/controller/subsystem/familytree/proc/DetermineRole(datum/heritage/house, mob/living/carbon/human/person)
	// Explicit preferences always win regardless of age
	if(person.setparent)
		for(var/datum/family_member/member in house.members)
			if(member.person?.real_name == person.setparent)
				return FAMILY_MEMBER_CHILD

	if(person.setchild)
		for(var/datum/family_member/member in house.members)
			if(member.person?.real_name == person.setchild)
				return FAMILY_MEMBER_PARENT

	// Fall through to age-based logic
	if(person.age == AGE_CHILD)
		return FAMILY_MEMBER_CHILD

	for(var/datum/family_member/member in house.members)
		if(member.person && CanBeParentOf(member.person.age, person.age))
			return FAMILY_MEMBER_CHILD

	for(var/datum/family_member/member in house.members)
		if(member.person && CanBeSiblings(member.person.age, person.age))
			return FAMILY_MEMBER_SIBLING

	return FAMILY_MEMBER_PARENT

/datum/controller/subsystem/familytree/proc/AddLocal(mob/living/carbon/human/H, status)
	if(!H?.mind || istype(H, /mob/living/carbon/human/dummy))
		return
	if(H.mind.assigned_role && is_type_in_list(H.mind.assigned_role, excluded_jobs))
		return

	var/mode = H.familytree_pref || status
	if(!mode || mode == FAMILY_NONE)
		_MaybeMakeDivorcedStub(H)
		return

	var/assigned = FALSE
	switch(mode)
		if(FAMILY_PARTIAL)
			assigned = AssignToHouse(H, H.family_adoption_pref)

		if(FAMILY_NEWLYWED)
			if(H.age == AGE_CHILD)
				assigned = AssignToHouse(H, H.family_adoption_pref)
			else
				assigned = AssignNewlyWed(H)

		if(FAMILY_FULL)
			if(H.virginity || H.age == AGE_CHILD)
				assigned = AssignToHouse(H, H.family_adoption_pref)
			else
				assigned = AssignToFamily(H)

	// If nothing worked, queue for deferred resolution
	if(!assigned)
		pending_latejoin += H

	_MaybeMakeDivorcedStub(H)

/datum/controller/subsystem/familytree/proc/ResolvePendingLatejoins()
	if(!LAZYLEN(pending_latejoin))
		return

	var/list/retry = pending_latejoin.Copy()
	pending_latejoin.Cut()

	for(var/mob/living/carbon/human/H in retry)
		if(!H?.mind)
			continue
		var/mode = H.familytree_pref
		if(!mode || mode == FAMILY_NONE)
			continue
		switch(mode)
			if(FAMILY_PARTIAL)
				AssignToHouse(H, H.family_adoption_pref)
			if(FAMILY_NEWLYWED)
				if(H.age == AGE_CHILD)
					AssignToHouse(H, H.family_adoption_pref)
				else
					AssignNewlyWed(H)
			if(FAMILY_FULL)
				if(H.virginity || H.age == AGE_CHILD)
					AssignToHouse(H, H.family_adoption_pref)
				else
					AssignToFamily(H)

/datum/controller/subsystem/familytree/proc/AddRoyal(mob/living/carbon/human/H, status)
	if(!ruling_family.housename)
		ruling_family.housename = "Royal"

	var/datum/family_member/member = ruling_family.CreateFamilyMember(H)
	if(!member)
		return

	if(!ruling_family.founder)
		ruling_family.founder = member
		cached_monarch = member
		ruling_family.dominant_species = H.dna.species.type
		H.ShowFamilyUI(TRUE)
		return

	var/datum/family_member/monarch = GetCurrentMonarch()

	switch(status)
		if(FAMILY_FATHER, FAMILY_MOTHER)
			if(monarch)
				ruling_family.MarryMembers(monarch, member)
				MarryAndLink(monarch.person, H)

		if(FAMILY_PROGENY)
			if(monarch)
				LinkRelatives(H.mind, monarch.person?.mind, FAMILY_MEMBER_CHILD, FAMILY_MEMBER_PARENT)
				if(monarch.person?.mind)
					// also link to monarch's first spouse if present
					for(var/datum/relation/family/R in monarch.person.mind.relations)
						if(R.bond_type == FAMILY_MEMBER_SPOUSE)
							LinkRelatives(H.mind, R.other, FAMILY_MEMBER_CHILD, FAMILY_MEMBER_PARENT)
							break

		if(FAMILY_OMMER)
			_CreateCadetBranch(member)

	H.ShowFamilyUI(TRUE)

/datum/controller/subsystem/familytree/proc/GetCurrentMonarch()
	if(cached_monarch?.person?.job == JOB_MONARCH)
		return cached_monarch
	for(var/datum/family_member/member in ruling_family.members)
		if(member.person?.job == JOB_MONARCH)
			cached_monarch = member
			return member
	return null

// Places a cadet-branch member as a sibling of the monarch
// by sharing the monarch's parent relations.
/datum/controller/subsystem/familytree/proc/_CreateCadetBranch(datum/family_member/member)
	var/datum/family_member/monarch = GetCurrentMonarch()
	if(!monarch || !monarch.person?.mind || !member.person?.mind)
		return
	for(var/datum/relation/family/R in monarch.person.mind.relations)
		if(R.bond_type == FAMILY_MEMBER_CHILD) // monarch is child of this mind = their parent
			LinkRelatives(member.person.mind, R.other, FAMILY_MEMBER_CHILD, FAMILY_MEMBER_PARENT)
	// Sibling link to monarch directly.
	link_family(member.person.mind, monarch.person.mind, FAMILY_MEMBER_SIBLING)
	link_family(monarch.person.mind, member.person.mind, FAMILY_MEMBER_SIBLING)

// Returns TRUE if a house was found and the person was added, FALSE otherwise.
/datum/controller/subsystem/familytree/proc/AssignToHouse(mob/living/carbon/human/H, force_adopted = FALSE)
	if(!H)
		return FALSE

	var/species = H.dna.species.type
	var/adopted = force_adopted
	var/datum/heritage/chosen_house
	var/is_young = (H.age == AGE_CHILD || H.age == AGE_ADULT)

	var/list/active = list()
	var/list/seed = list()
	for(var/datum/heritage/house in families)
		var/n = LAZYLEN(house.members)
		if(house.housename && n >= 1 && n < MAX_HOUSE_MEMBERS)
			active += house
		else
			seed += house

	if(H.setchild)
		for(var/datum/heritage/house in active + seed)
			if(!HousePassesFilters(H, house))
				continue
			for(var/datum/family_member/member in house.members)
				if(member.person?.real_name == H.setchild)
					chosen_house = house
					break
			if(chosen_house)
				break

	if(!chosen_house && is_young && H.setparent)
		for(var/datum/heritage/house in active + seed)
			if(!HousePassesFilters(H, house))
				continue
			for(var/datum/family_member/member in house.members)
				if(member.person?.real_name == H.setparent)
					chosen_house = house
					break
			if(chosen_house)
				break

	if(!chosen_house)
		for(var/datum/heritage/house in active)
			if(!HousePassesFilters(H, house) || WouldCreateAgeConflict(house, H))
				continue
			if(house.dominant_species == species && LAZYLEN(house.members) < 4)
				chosen_house = house
				break

	if(!chosen_house)
		for(var/datum/heritage/house in active)
			if(!HousePassesFilters(H, house) || WouldCreateAgeConflict(house, H))
				continue
			if(house.dominant_species != species && force_adopted)
				chosen_house = house
				adopted = TRUE
				break

	if(!chosen_house)
		for(var/datum/heritage/house in seed)
			if(!HousePassesFilters(H, house) || WouldCreateAgeConflict(house, H))
				continue
			if(house.dominant_species == species)
				chosen_house = house
				break

	if(!chosen_house && force_adopted)
		for(var/datum/heritage/house in seed)
			if(!HousePassesFilters(H, house) || WouldCreateAgeConflict(house, H))
				continue
			chosen_house = house
			adopted = TRUE
			break

	if(chosen_house)
		AddPersonToHouse(chosen_house, H, adopted)
		return TRUE

	return FALSE

// Returns TRUE if H was placed into an existing or new family, FALSE otherwise.
/datum/controller/subsystem/familytree/proc/AssignToFamily(mob/living/carbon/human/H)
	if(!H)
		return FALSE

	var/species = H.dna.species.type

	for(var/datum/heritage/house in families)
		if(house.dominant_species != species)
			continue

		for(var/datum/family_member/member in house.members)
			if(!member.person || member.person.age == AGE_CHILD)
				continue
			var/already_wed = FALSE
			if(member.person.mind)
				for(var/datum/relation/family/R in member.person.mind.relations)
					if(R.bond_type == FAMILY_MEMBER_SPOUSE)
						already_wed = TRUE
						break
			if(already_wed)
				continue
			if(!_SpouseCompatible(H, member.person))
				continue

			var/datum/family_member/new_member = house.CreateFamilyMember(H)
			if(new_member)
				house.MarryMembers(new_member, member)
				MarryAndLink(H, member.person)
			return TRUE

		if(!house.housename)
			var/datum/family_member/new_member = house.CreateFamilyMember(H)
			if(new_member)
				house.founder = new_member
				house.housename = house.SurnameFormatting(H)
			return TRUE

	if(species != /datum/species/aasimar)
		families += new /datum/heritage(H, null, species)
		return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/_SpouseCompatible(mob/living/carbon/human/H, mob/living/carbon/human/other)
	if(!H || !other)
		return FALSE
	if(H.setspouse == other.real_name && other.setspouse == H.real_name)
		return TRUE
	if(H.setspouse && H.setspouse != other.real_name)
		return FALSE
	if(other.setspouse && other.setspouse != H.real_name)
		return FALSE
	return (PassesFamilyFilters(H, other) && PassesFamilyFilters(other, H) \
		&& H.pronouns_match(H, other) && other.pronouns_match(other, H))

/datum/controller/subsystem/familytree/proc/_ChildCompatible(mob/living/carbon/human/parent, mob/living/carbon/human/child)
	if(!parent || !child)
		return FALSE
	if(parent.setchild == child.real_name && child.setparent == parent.real_name)
		return TRUE
	if(parent.setchild && parent.setchild != child.real_name)
		return FALSE
	return CanBeParentOf(parent.age, child.age)

// Returns TRUE if H was married or queued as a viable spouse, FALSE if nothing happened.
/datum/controller/subsystem/familytree/proc/AssignNewlyWed(mob/living/carbon/human/H)
	viable_spouses += H

	var/mob/living/carbon/human/best_match
	var/best_priority = -1

	for(var/mob/living/carbon/human/candidate in viable_spouses)
		if(!candidate || candidate == H || candidate.spouse_mob)
			continue

		var/mutual = (H.setspouse == candidate.real_name) && (candidate.setspouse == H.real_name)

		var/priority
		if(mutual)
			priority = 3
		else if(H.setspouse == candidate.real_name && !candidate.setspouse)
			priority = 2
		else if(candidate.setspouse == H.real_name && !H.setspouse)
			priority = 1
		else if(!H.setspouse && !candidate.setspouse && _SpouseCompatible(H, candidate))
			priority = 0
		else
			continue

		if(priority > best_priority)
			best_priority = priority
			best_match = candidate

	if(best_match)
		viable_spouses -= best_match
		viable_spouses -= H
		MarryAndLink(H, best_match)
		return TRUE

	return FALSE

/datum/controller/subsystem/familytree/proc/AddPersonToHouse(datum/heritage/house, mob/living/carbon/human/person, adopted = FALSE)
	var/role = DetermineRole(house, person)
	switch(role)
		if(FAMILY_MEMBER_CHILD)   PlaceAsChild(house, person, adopted)
		if(FAMILY_MEMBER_SIBLING) PlaceAsSibling(house, person, adopted)
		if(FAMILY_MEMBER_PARENT)  PlaceAsParent(house, person)

// Adds person as a child of the eldest eligible parents in the house.
/datum/controller/subsystem/familytree/proc/PlaceAsChild(datum/heritage/house, mob/living/carbon/human/person, adopted)
	var/list/potential_parents = list()
	for(var/datum/family_member/member in house.members)
		if(!member.person || !CanBeParentOf(member.person.age, person.age))
			continue
		if(!PassesChildFilters(member.person, person))
			continue
		if(member.person.setchild == person.real_name)
			potential_parents.Insert(1, member)
		else
			potential_parents += member

	var/datum/family_member/parent1 = LAZYLEN(potential_parents) >= 1 ? potential_parents[1] : null
	var/datum/family_member/parent2 = null

	// Only take a second parent if they are actually married to parent1
	if(parent1?.person?.mind && LAZYLEN(potential_parents) >= 2)
		for(var/datum/relation/family/R in parent1.person.mind.relations)
			if(R.bond_type != FAMILY_MEMBER_SPOUSE)
				continue
			for(var/datum/family_member/candidate in potential_parents)
				if(candidate == parent1)
					continue
				if(candidate.person?.mind == R.other)
					parent2 = candidate
					break
			if(parent2)
				break

	house.AddToFamily(person, parent1, parent2, adopted)

	if(!person.mind)
		return

	LinkRelatives(person.mind, parent1?.person?.mind, FAMILY_MEMBER_CHILD, FAMILY_MEMBER_PARENT, adopted)
	LinkRelatives(person.mind, parent2?.person?.mind, FAMILY_MEMBER_CHILD, FAMILY_MEMBER_PARENT, adopted)

	if(parent1?.person?.mind)
		for(var/datum/family_member/sib in house.members)
			if(!sib.person?.mind || sib.person == person)
				continue
			for(var/datum/relation/family/R in sib.person.mind.relations)
				if(R.bond_type == FAMILY_MEMBER_CHILD && R.other == parent1.person.mind)
					link_family(person.mind, sib.person.mind, FAMILY_MEMBER_SIBLING, /datum/relation/family, adopted)
					link_family(sib.person.mind, person.mind, FAMILY_MEMBER_SIBLING, /datum/relation/family, adopted)
					break

// Adds person as a sibling: inherits first compatible member's parents,
// then links bidirectionally to all age-compatible members.
/datum/controller/subsystem/familytree/proc/PlaceAsSibling(datum/heritage/house, mob/living/carbon/human/person, adopted)
	var/linked_parents = FALSE
	for(var/datum/family_member/member in house.members)
		if(!member.person || !CanBeSiblings(member.person.age, person.age))
			continue

		if(!linked_parents && member.person.mind)
			// Copy parent relations from this sibling.
			for(var/datum/relation/family/R in member.person.mind.relations)
				if(R.bond_type == FAMILY_MEMBER_CHILD)
					LinkRelatives(person.mind, R.other, FAMILY_MEMBER_CHILD, FAMILY_MEMBER_PARENT, adopted)
			linked_parents = TRUE

		if(person.mind && member.person.mind)
			link_family(person.mind, member.person.mind, FAMILY_MEMBER_SIBLING, /datum/relation/family)
			link_family(member.person.mind, person.mind, FAMILY_MEMBER_SIBLING, /datum/relation/family)

	house.AddToFamily(person, null, null, adopted)

// Adds person as a founding parent; no relation links needed at this stage.
/datum/controller/subsystem/familytree/proc/PlaceAsParent(datum/heritage/house, mob/living/carbon/human/person)
	var/datum/family_member/new_member = house.CreateFamilyMember(person)
	if(!new_member)
		return
	if(!house.founder)
		house.founder = new_member
	if(!house.housename)
		house.housename = house.SurnameFormatting(person)

// Writes a bidirectional pair of relation links between two minds.
// Skips silently if either mind is null (e.g. NPC stubs).
/datum/controller/subsystem/familytree/proc/LinkRelatives(datum/mind/mind_a, datum/mind/mind_b, bond_a, bond_b, adopted = FALSE)
	if(!mind_a || !mind_b)
		return
	link_family(mind_a, mind_b, bond_a, /datum/relation/family, adopted)
	link_family(mind_b, mind_a, bond_b, /datum/relation/family, adopted)

/datum/controller/subsystem/familytree/proc/MarryAndLink(mob/living/carbon/human/H, mob/living/carbon/human/other)
	if(!H?.mind || !other?.mind)
		return null
	H.MarryTo(other)
	link_family(H.mind, other.mind, FAMILY_MEMBER_SPOUSE, /datum/relation/family/spouse)
	link_family(other.mind, H.mind, FAMILY_MEMBER_SPOUSE, /datum/relation/family/spouse)

// Full filter: species, faith, and job group. Used for spouse matching.
/datum/controller/subsystem/familytree/proc/PassesFamilyFilters(mob/living/carbon/human/person_a, mob/living/carbon/human/person_b)
	if(!person_a || !person_b)
		return FALSE

	if(person_a.same_species_family)
		if(person_a.dna?.species?.type != person_b.dna?.species?.type)
			return FALSE
	else
		var/list/accepted_sp = person_a.accepted_family_species
		if(length(accepted_sp) && !("[person_b.dna?.species?.type]" in accepted_sp))
			return FALSE

	var/list/accepted_faiths = person_a.accepted_patron_faiths
	if(length(accepted_faiths))
		var/datum/patron/their_patron = person_b.patron
		var/their_faith = their_patron ? "[their_patron.associated_faith]" : null
		if(!their_faith || !(their_faith in accepted_faiths))
			return FALSE

	var/list/job_filter = person_a.family_job_filter
	if(length(job_filter))
		var/their_job = person_b.job
		var/passed = FALSE
		for(var/group_key in job_filter)
			if(their_job && (their_job in job_group_list(group_key)))
				passed = TRUE
				break
		if(!passed)
			return FALSE

	return TRUE

/datum/controller/subsystem/familytree/proc/PassesChildFilters(mob/living/carbon/human/parent, mob/living/carbon/human/child)
	if(!parent || !child)
		return FALSE

	// Check parent's species preference toward child
	if(parent.same_species_family)
		if(parent.dna?.species?.type != child.dna?.species?.type)
			return FALSE
	else
		var/list/accepted_sp = parent.accepted_family_species
		if(length(accepted_sp) && !("[child.dna?.species?.type]" in accepted_sp))
			return FALSE

	// Check child's species preference toward parent
	if(child.same_species_family)
		if(child.dna?.species?.type != parent.dna?.species?.type)
			return FALSE
	else
		var/list/accepted_sp = child.accepted_family_species
		if(length(accepted_sp) && !("[parent.dna?.species?.type]" in accepted_sp))
			return FALSE

	// Check parent's faith preference toward child
	var/list/parent_faiths = parent.accepted_patron_faiths
	if(length(parent_faiths))
		var/datum/patron/child_patron = child.patron
		var/child_faith = child_patron ? "[child_patron.associated_faith]" : null
		if(!child_faith || !(child_faith in parent_faiths))
			return FALSE

	// Check child's faith preference toward parent
	var/list/child_faiths = child.accepted_patron_faiths
	if(length(child_faiths))
		var/datum/patron/parent_patron = parent.patron
		var/parent_faith = parent_patron ? "[parent_patron.associated_faith]" : null
		if(!parent_faith || !(parent_faith in child_faiths))
			return FALSE

	return TRUE

// Reduced filter for house membership: species + faith only.
/datum/controller/subsystem/familytree/proc/HousePassesFilters(mob/living/carbon/human/H, datum/heritage/house)
	if(!LAZYLEN(house.members))
		return TRUE
	for(var/datum/family_member/member in house.members)
		if(!member.person)
			continue
		if(H.same_species_family && H.dna?.species?.type != member.person.dna?.species?.type)
			return FALSE
		else if(!H.same_species_family)
			var/list/accepted_sp = H.accepted_family_species
			if(length(accepted_sp) && !("[member.person.dna?.species?.type]" in accepted_sp))
				return FALSE
		var/list/accepted_faiths = H.accepted_patron_faiths
		if(length(accepted_faiths))
			var/datum/patron/their_patron = member.person.patron
			var/their_faith = their_patron ? "[their_patron.associated_faith]" : null
			if(!their_faith || !(their_faith in accepted_faiths))
				return FALSE
	return TRUE

// Creates a placeholder divorced-spouse relation so the UI can show
// "formerly married" without needing a live mind reference.
/datum/controller/subsystem/familytree/proc/_MaybeMakeDivorcedStub(mob/living/carbon/human/H)
	if(!H.was_divorced || !H.mind)
		return
	for(var/datum/relation/divorced/D in H.mind.relations)
		return
	var/datum/relation/divorced/stub = new()
	stub.holder = H.mind
	stub.other = null
	stub.snapshot = list(
		"name"   = "Former Spouse",
		"vcolor" = "#ffffff",
		"job"    = "Unknown",
		"gender" = PLURAL,
		"age"    = AGE_ADULT,
	)
	H.mind.relations += stub

// Removes stale member entries from a family after late departures
// or character deletions. Relation cleanup is handled by dissolve() on
// the mind side; we only need to drop dead family_member nodes here.
/datum/controller/subsystem/familytree/proc/ValidateFamily(datum/heritage/family)
	if(!family)
		return
	for(var/datum/family_member/member in family.members)
		if(!member.person)
			family.members -= member

/mob/living/carbon/human/proc/pronouns_match(mob/living/carbon/human/H, mob/living/carbon/human/other)
	if(H.gender_choice_pref == ANY_GENDER)
		return TRUE

	var/my_neutral    = (H.pronouns == THEY_THEM || H.pronouns == IT_ITS)
	var/other_neutral = (other.pronouns == THEY_THEM || other.pronouns == IT_ITS)

	if(my_neutral)
		return (other_neutral || other.gender_choice_pref == ANY_GENDER)
	if(other_neutral)
		return FALSE
	if(H.gender_choice_pref == SAME_GENDER)
		return (H.pronouns == other.pronouns)
	if(H.gender_choice_pref == DIFFERENT_GENDER)
		return (H.pronouns != other.pronouns)

	return FALSE
