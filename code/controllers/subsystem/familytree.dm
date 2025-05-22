/*
* The familytree subsystem is supposed to be a way to
* assist RP by setting people up as related roundstart.
* This relation can be based on role (IE king and prince
* being father and son) or random chance.
*/
/*
* NOTES: There is some areas of this
* subsystem that can be more fleshed out
* such as how right now a house is just
* a bunch of names. Potentially this system
* can be used to create family curses/boons that
* effect all family members.
* There is also a additional variable i placed
* in human.dna called parent_mix that could be
* used for intrigue but currently it has
* no use and is only changed by the
* heritage datum BloodTies() proc.`
*/
SUBSYSTEM_DEF(familytree)
	name = "familytree"
	flags = SS_NO_FIRE
	lazy_load = FALSE

	/*
	* The family that kings, queens, and princes
	* are automatically placed into. Has no other
	* real function.
	*/
	var/datum/heritage/ruling_family
	/*
	* The other major houses of Rockhill.
	* Id say think Shrouded Isle families but
	* smaller.
	*/
	var/list/families = list()
	/*
	* Bachalors and Bachalorettes
	*/
	var/list/viable_spouses = list()
	//These jobs are excluded from AddLocal()
	var/excluded_jobs = list(
		"Prince",
		"Princess",
		"Consort",
		"Monarch",
		"Hand",
		"Inquisitor",
		"Adept",
		"Jailor",
		"Orphan",
		"Innkeepers Son",
		"Churchling",
		)
	//This creates 2 families for each race roundstart so that siblings dont fail to be added to a family.
	var/list/preset_family_species = list(
		/datum/species/human/northern,
		/datum/species/elf,
		/datum/species/elf/dark,
		/datum/species/human/halfelf,
		/datum/species/dwarf/mountain,
		/datum/species/tieberian,
		/datum/species/aasimar,
		/datum/species/rakshari,
		/datum/species/halforc
		)

/datum/controller/subsystem/familytree/Initialize()
	ruling_family = new /datum/heritage(majority_species = /datum/species/human/northern)
	//Blank starter families that we can customize for players.
	for(var/pioneer_household in preset_family_species)
		for(var/I = 1 to 2)
		families += new /datum/heritage(majority_species = pioneer_household)

	return ..()

/*
* In order for us to use age in sorting of generations we would need to
* make the king & queen older than the prince.
*/
/datum/controller/subsystem/familytree/proc/AddLocal(mob/living/carbon/human/H, status)
	if(!H || !status || istype(H, /mob/living/carbon/human/dummy))
		return
	//Exclude princes and princesses from having their parentage calculated.
	if(H.job in excluded_jobs)
		return
	switch(status)
		if(FAMILY_PARTIAL)
			AssignToHouse(H)

		if(FAMILY_NEWLYWED)
			if(H.age == AGE_CHILD)
				AssignToHouse(H)
				return
			else
				AssignNewlyWed(H)

		if(FAMILY_FULL)
			if(H.virginity)
				return
			if(H.age == AGE_CHILD)
				AssignToHouse(H)
				return
			AssignToFamily(H)

/*
* Assigns lord and lady to the royal family.
* If they are father or mother they claim the house in their name.
*/
/datum/controller/subsystem/familytree/proc/AddRoyal(mob/living/carbon/human/H, status)
	if(status == FAMILY_FATHER || status == FAMILY_MOTHER)
		if(!ruling_family.housename)
			ruling_family.ClaimHouse(H)
			return
		//If king has already married another, the queen is not added to the royal family by default. Get angry!
		if(ruling_family.matriarch && ruling_family.patriarch)
			return
	ruling_family.addToHouse(H, status)

/*
* Assigns people randomly as heirs to one of the major
* famlies of Rockhill based on their species.
*/
/datum/controller/subsystem/familytree/proc/AssignToHouse(mob/living/carbon/human/H)
	//If no human and they are older than adult age.
	if(!H)
		return
	//Akward way of assigning people as aunts and uncles to houses.
	if(H.age > AGE_ADULT)
		AssignAuntUncle(H)
		return
	if(H.age > AGE_CHILD)
		AssignAuntUncle(H)
		return
	var/species = H.dna.species.type
	var/adopted = FALSE
	var/datum/heritage/chosen_house
	var/list/low_priority_houses = list()
	var/list/high_priority_houses = list()
	for(var/datum/heritage/I in families)
		if(I.housename && (I.family.len >= 1 && I.family.len < 6))
			high_priority_houses.Add(I)
		else
			low_priority_houses.Add(I)
	//Extremely sloppy but shorter code than writing the same code twice. -IP
	for(var/i = 1 to 2)
		var/list/what_we_checkin = high_priority_houses
		//If second run then check the other houses.
		if(i == 2)
			what_we_checkin = low_priority_houses
		for(var/datum/heritage/I in what_we_checkin)
			if(I.dominant_species == species && (I.family.len >= 1 && I.family.len < 4))
				chosen_house = I
				break
			//Its weird to be placed as a foster child in a family with no people in it.
			if(prob(20) && (I.family.len > 1 && I.family.len <= 8))
				chosen_house = I
				adopted = TRUE
				break
		if(chosen_house)
			break

	if(chosen_house)
		chosen_house.addToHouse(H, adopted ? FAMILY_ADOPTED : FAMILY_PROGENY)

/*
* Allows players to claim a
* house as patriarch or matriarch.
* Currently roundstart families are
* male and female since it makes
* species calulcation easier on me.
*/
/datum/controller/subsystem/familytree/proc/AssignToFamily(mob/living/carbon/human/H)
	if(!H)
		return
	var/our_species = H.dna.species.type
	var/list/low_priority_houses = list()
	var/list/medium_priority_houses = list()
	var/list/high_priority_houses = list()
	for(var/datum/heritage/I in families)
		//This house is full.
		if(I.matriarch && I.patriarch)
			continue
		//The accursed setspouse code so people can preset their spouses
		var/mob/living/carbon/human/spouse_to_be
		if(ishuman(I.matriarch))
			spouse_to_be = I.matriarch
		if(ishuman(I.patriarch))
			spouse_to_be = I.patriarch
		//There is someone in this house.
		if(spouse_to_be)
			//If this player has the name of the spouse you want.
			if(spouse_to_be.real_name == H.setspouse)
				//You have eachothers names as your setspouse
				if(spouse_to_be.setspouse == H.real_name)
					high_priority_houses.Add(I)
				//They are impartial
				if(!spouse_to_be.setspouse)
					medium_priority_houses.Add(I)
				continue
			//They would like you as their spouse and your impartial to it.
			if(!H.setspouse && spouse_to_be.setspouse == H.real_name)
				medium_priority_houses.Add(I)
				continue
			//They are waiting for someone else.
			if(spouse_to_be.setspouse)
				continue
		//Normal Code
		if(I.dominant_species != our_species)
			continue
		low_priority_houses.Add(I)

	/*
	* Checks 3 lists.
	* 1 High Priority: Houses that have the setspouse player.
	* 2 Medium Priority: Houses without spouses
	* 3 Low Priority: Everything else that applies
	*/
	var/list/what_we_checkin = list()
	for(var/cycle = 1 to 3)
		//If second run then check the other houses.
		switch(cycle)
			if(1)
				what_we_checkin = high_priority_houses
			if(2)
				what_we_checkin = medium_priority_houses
			if(3)
				what_we_checkin = low_priority_houses
		for(var/datum/heritage/eligable_house in what_we_checkin)
			var/mob/living/carbon/human/mat = eligable_house.matriarch
			var/mob/living/carbon/human/pat = eligable_house.patriarch
			if(!eligable_house.housename)
				eligable_house.ClaimHouse(H)
				return
			//Sloppy method to check husband and wife one after another.
			if(!mat && H.gender == FEMALE)
				eligable_house.addToHouse(H, FAMILY_MOTHER)
				return
			if(!pat && H.gender == MALE)
				eligable_house.addToHouse(H, FAMILY_FATHER)
				return
	//None of the above added the person to a family. This means we must add them to a entirely new house.
	if(our_species != /datum/species/aasimar)
		families += new /datum/heritage(H)

/*
* For marrying two people together based on spousename.
*/
/datum/controller/subsystem/familytree/proc/AssignNewlyWed(mob/living/carbon/human/H)
	viable_spouses.Add(H)
	var/list/high_priority_lover = list()
	var/list/mid_priority_lover = list()
	var/list/low_priority_lover = list()
	for(var/vs in viable_spouses)
		//Thats no one.
		if(!vs || !ishuman(vs))
			continue
		var/mob/living/carbon/human/L = vs
		//Thats you dude.
		if(L == H)
			continue
		//They already have a spouse so skip this one.
		if(L.spouse_mob)
			continue
		//True love! They chose you and chose love them!
		if(H.setspouse == L.real_name && L.setspouse == H.real_name)
			high_priority_lover.Add(L)
			break
		/*
		* This person has the name of the
		* spouse you want. But their setspouse is none.
		*/
		if(H.setspouse == L.real_name && !L.setspouse)
			high_priority_lover.Add(L)
			continue
		// This person wants you but you didnt choose them.
		if(L.setspouse == H.real_name)
			mid_priority_lover.Add(L)
			continue
		//Everyone else is placed in the loser pile.
		low_priority_lover.Add(L)

	var/lover
	//Im sorry its convoluted but i think its more COMPRESSED.
	for(var/cycle = 1 to 3)
		//WE FOUND THEM!!!
		if(lover)
			break
		if(cycle > 2 && H.setspouse)
			break
		var/list/what_we_checkin = list()
		switch(cycle)
			if(1)
				what_we_checkin = high_priority_lover
			if(2)
				what_we_checkin = mid_priority_lover
			if(3)
				what_we_checkin = low_priority_lover
		//To avoid runtime errors due to picking from a empty list.
		if(what_we_checkin.len)
			lover = pick(what_we_checkin)
	//Success YOUR MARRIED!!!
	if(ishuman(lover) && lover)
		viable_spouses -= lover
		viable_spouses -= H
		H.MarryTo(lover)

/*
* Assings people as uncles and aunts.
*/
/datum/controller/subsystem/familytree/proc/AssignAuntUncle(mob/living/carbon/human/H)
	var/species = H.dna.species.type
	var/inlaw = FALSE
	var/datum/heritage/chosen_house
	var/list/low_priority_houses = list()
	var/list/high_priority_houses = list()
	for(var/datum/heritage/I in families)
		if(I.housename && (I.family.len >= 1 && I.family.len > 6))
			high_priority_houses.Add(I)
		else
			low_priority_houses.Add(I)

	//Extremely sloppy but shorter code than writing the same code twice. -IP
	for(var/i = 1 to 2)
		var/list/what_we_checkin = high_priority_houses
		//If second run then check the other houses.
		if(i == 2)
			what_we_checkin = low_priority_houses
		for(var/datum/heritage/I in what_we_checkin)
			if((I.dominant_species == species && (I.family.len > 1 || I.family.len <=6 )) && I.housename)
				chosen_house = I
				break
			if((prob(2) && (I.family.len > 1)) && I.housename)
				chosen_house = I
				inlaw = TRUE
				break
		if(chosen_house)
			break

	if(chosen_house)
		chosen_house.addToHouse(H, inlaw ?  FAMILY_INLAW : FAMILY_OMMER)

/*
* For admins to view EVERY FAMILY and see all the
* akward and convoluted coding.
*/
/datum/controller/subsystem/familytree/proc/ReturnAllFamilies()
	. = ""
	if(ruling_family)
		. += ruling_family.FormatFamilyList()
	for(var/datum/heritage/I in families)
		if(!I.housename && !I.family.len)
			continue
		. += I.FormatFamilyList()
