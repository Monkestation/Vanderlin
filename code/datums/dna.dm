
/////////////////////////// DNA DATUM
/datum/dna
	var/unique_enzymes
	///Stores the hashed values of traits such as skin tones, hair style, and gender
	var/unique_identity
	var/datum/blood_type/human/human_blood_type
	var/datum/species/species = new /datum/species/human //The type of mutant race the player is if applicable (i.e. potato-man)
	var/list/features = MANDATORY_FEATURE_LIST
	var/real_name //Stores the real name of the person who originally got this dna datum. Used primarely for changelings,
	var/mob/living/holder
	///Body markings of the DNA's owner. This is for storing their original state for re-creating the character. They'll get changed on species mutation
	var/list/list/body_markings = list()
	var/list/organ_dna = list()
	//Familytree variable
	var/parent_mix

/datum/dna/New(mob/living/new_holder)
	if(istype(new_holder))
		holder = new_holder

/datum/dna/Destroy()
	if(iscarbon(holder))
		var/mob/living/carbon/cholder = holder
		if(cholder.dna == src)
			cholder.dna = null
	holder = null

	QDEL_NULL(species)

	return ..()

/datum/dna/proc/transfer_identity(mob/living/carbon/destination, update_prints)
	if(!istype(destination))
		return
	destination.dna.unique_enzymes = unique_enzymes
	destination.dna.unique_identity = unique_identity
	destination.dna.human_blood_type = human_blood_type
	destination.dna.organ_dna = organ_dna
	destination.set_species(species.type, icon_update=0)
	destination.dna.body_markings = deepCopyList(body_markings)
	destination.dna.features = features.Copy()
	destination.dna.real_name = real_name

/datum/dna/proc/copy_dna(datum/dna/new_dna)
	new_dna.unique_enzymes = unique_enzymes
	new_dna.unique_identity = unique_identity
	new_dna.human_blood_type = human_blood_type
	new_dna.body_markings = deepCopyList(body_markings)
	new_dna.features = features.Copy()
	new_dna.species = new species.type
	new_dna.real_name = real_name

/datum/dna/proc/generate_unique_identity()
	. = ""
	var/list/L = new /list(DNA_UNI_IDENTITY_BLOCKS)

	switch(holder.gender)
		if(MALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_MALE, 3)
		if(FEMALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_FEMALE, 3)
		else
			L[DNA_GENDER_BLOCK] = construct_block(G_PLURAL, 3)
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		L[DNA_SKIN_TONE_BLOCK] = H.skin_tone
		L[DNA_EYE_COLOR_BLOCK] = H.get_eye_color()

	for(var/i=1, i<=DNA_UNI_IDENTITY_BLOCKS, i++)
		if(L[i])
			. += L[i]
		else
			. += random_string(DNA_BLOCK_SIZE,GLOB.hex_characters)
	return .


/datum/dna/proc/generate_unique_enzymes()
	. = ""
	if(istype(holder))
		real_name = holder.real_name
		. += md5(holder.real_name)
	else
		. += random_string(DNA_UNIQUE_ENZYMES_LEN, GLOB.hex_characters)
	return .

/datum/dna/proc/update_ui_block(blocknumber)
	if(!blocknumber || !ishuman(holder))
		return
	var/mob/living/carbon/human/H = holder
	switch(blocknumber)
		if(DNA_SKIN_TONE_BLOCK)
			setblock(unique_identity, blocknumber, sanitize_hexcolor(H.skin_tone))
		if(DNA_EYE_COLOR_BLOCK)
			setblock(unique_identity, blocknumber, sanitize_hexcolor(H.get_eye_color()))
		if(DNA_GENDER_BLOCK)
			switch(H.gender)
				if(MALE)
					setblock(unique_identity, blocknumber, construct_block(G_MALE, 3))
				if(FEMALE)
					setblock(unique_identity, blocknumber, construct_block(G_FEMALE, 3))
				else
					setblock(unique_identity, blocknumber, construct_block(G_PLURAL, 3))

/datum/dna/proc/is_same_as(datum/dna/D)
	if(unique_identity == D.unique_identity && real_name == D.real_name)
		if(species.type == D.species.type && features == D.features && human_blood_type == D.human_blood_type)
			return 1
	return 0

//used to update dna UI, UE, and dna.real_name.
/datum/dna/proc/update_dna_identity()
	unique_identity = generate_unique_identity()
	unique_enzymes = generate_unique_enzymes()
	holder?.reset_limb_fingerprints()

/datum/dna/proc/initialize_dna(newblood_type = random_human_blood_type(), skip_index = FALSE)
	if(newblood_type)
		human_blood_type = newblood_type
	unique_enzymes = generate_unique_enzymes()
	unique_identity = generate_unique_identity()
	features = random_features()


/datum/dna/stored //subtype used by brain mob's stored_dna

/////////////////////////// DNA MOB-PROCS //////////////////////

/mob/proc/set_species(datum/species/mrace, icon_update = 1)
	return

/mob/living/brain/set_species(datum/species/mrace, icon_update = 1)
	if(mrace)
		if(ispath(mrace))
			stored_dna.species = new mrace()
		else
			stored_dna.species = mrace //not calling any species update procs since we're a brain, not a monkey/human


/mob/living/carbon/set_species(datum/species/mrace, icon_update = TRUE, datum/preferences/pref_load = null)
	if(mrace && has_dna())
		var/datum/species/new_race
		if(ispath(mrace))
			new_race = new mrace
		else if(istype(mrace))
			new_race = mrace
		else
			return
		deathsound = new_race.deathsound
		dna.species.on_species_loss(src, new_race, pref_load)
		var/datum/species/old_species = dna.species
		dna.species = new_race
		//BODYPARTS AND FEATURES
		if(pref_load)
			dna.features = pref_load.features.Copy()
			dna.body_markings = deepCopyList(pref_load.body_markings)
		dna.species.on_species_gain(src, old_species, pref_load)

/mob/living/carbon/human/set_species(datum/species/mrace, icon_update = TRUE, datum/preferences/pref_load = null)
	if(pref_load)
		skin_tone = pref_load.skin_tone
	..()
	if(icon_update)
		update_body()
		update_body_parts(TRUE)

/mob/proc/has_dna()
	return

/mob/living/carbon/has_dna()
	return dna


/mob/living/carbon/human/proc/hardset_dna(ui, list/mutation_index, newreal_name, newblood_type, datum/species/mrace, newfeatures, list/mutations, force_transfer_mutations)
//Do not use force_transfer_mutations for stuff like cloners without some precautions, otherwise some conditional mutations could break (timers, drill hat etc)
	if(newfeatures)
		dna.features = newfeatures

	if(mrace)
		var/datum/species/newrace = new mrace.type
		newrace.copy_properties_from(mrace)
		set_species(newrace, icon_update=0)

	if(newreal_name)
		real_name = newreal_name
		dna.generate_unique_enzymes()

	if(newblood_type)
		dna.human_blood_type = newblood_type

	if(ui)
		dna.unique_identity = ui
		updateappearance(icon_update=0)

	if(mrace || newfeatures || ui)
		update_body()
		update_body_parts()

/mob/living/carbon/proc/create_dna()
	dna = new /datum/dna(src)
	if(!dna.species)
		var/datum/species/random_species = GLOB.species_list[pick(GLOB.roundstart_species)]
		set_species(random_species, TRUE)

//proc used to update the mob's appearance after its dna UI has been changed
/mob/living/carbon/proc/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	if(!has_dna())
		return

	switch(deconstruct_block(getblock(dna.unique_identity, DNA_GENDER_BLOCK), 3))
		if(G_MALE)
			gender = MALE
		if(G_FEMALE)
			gender = FEMALE
		else
			gender = PLURAL

/mob/living/carbon/human/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	..()
	if(icon_update)
		update_body()
		if(mutcolor_update)
			update_body_parts()



/mob/proc/domutcheck()
	return


/////////////////////////// DNA HELPER-PROCS //////////////////////////////

/proc/getleftblocks(input,blocknumber,blocksize)
	if(blocknumber > 1)
		return copytext(input,1,((blocksize*blocknumber)-(blocksize-1)))

/proc/getrightblocks(input,blocknumber,blocksize)
	if(blocknumber < (length(input)/blocksize))
		return copytext(input,blocksize*blocknumber+1,length(input)+1)

/proc/getblock(input, blocknumber, blocksize=DNA_BLOCK_SIZE)
	return copytext(input, blocksize*(blocknumber-1)+1, (blocksize*blocknumber)+1)

/proc/setblock(istring, blocknumber, replacement, blocksize=DNA_BLOCK_SIZE)
	if(!istring || !blocknumber || !replacement || !blocksize)
		return 0
	return getleftblocks(istring, blocknumber, blocksize) + replacement + getrightblocks(istring, blocknumber, blocksize)



/mob/living/carbon/proc/randmuti()
	if(!has_dna())
		return
	var/num = rand(1, DNA_UNI_IDENTITY_BLOCKS)
	var/newdna = setblock(dna.unique_identity, num, random_string(DNA_BLOCK_SIZE, GLOB.hex_characters))
	dna.unique_identity = newdna
	updateappearance(mutations_overlay_update=1)

//value in range 1 to values. values must be greater than 0
//all arguments assumed to be positive integers
/proc/construct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	if(value < 1)
		value = 1
	value = (value * width) - rand(1,width)
	return num2hex(value, blocksize)

//value is hex
/proc/deconstruct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	value = round(hex2num(value) / width) + 1
	if(value > values)
		value = values
	return value

/mob/living/carbon/human/proc/MixDNA(mob/living/carbon/human/father = "", mob/living/carbon/human/mother = "", override = FALSE)
	if(override == FALSE && dna.parent_mix)
		dna.parent_mix = "[father]/[mother]"
