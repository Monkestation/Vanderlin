/proc/lizard_name(gender)
	if(gender == MALE)
		return "[pick(GLOB.lizard_names_male)]-[pick(GLOB.lizard_names_male)]"
	else
		return "[pick(GLOB.lizard_names_female)]-[pick(GLOB.lizard_names_female)]"

/proc/ethereal_name()
	var/tempname = "[pick(GLOB.ethereal_names)] [random_capital_letter()]"
	if(prob(65))
		tempname += random_capital_letter()
	return tempname

/proc/station_name()
	if(!GLOB.station_name)
		var/newname
		var/config_station_name = CONFIG_GET(string/stationname)
		if(config_station_name)
			newname = config_station_name
		else
			newname = new_station_name()

		set_station_name(newname)

	return GLOB.station_name

/proc/set_station_name(newname)
	GLOB.station_name = newname
	world.name = "VANDERLIN"

/proc/new_station_name()
	var/random = rand(1,5)
	var/name = ""
	var/new_station_name = ""

	//Rare: Pre-Prefix
	if (prob(10))
		name = pick(GLOB.station_prefixes)
		new_station_name = name + " "
		name = ""

	// Prefix
	for(var/holiday_name in SSevents.holidays)
		if(holiday_name == "Friday the 13th")
			random = 13
		var/datum/holiday/holiday = SSevents.holidays[holiday_name]
		name = holiday.getStationPrefix()
		//get normal name
	if(!name)
		name = pick(GLOB.station_names)
	if(name)
		new_station_name += name + " "

	// Suffix
	name = pick(GLOB.station_suffixes)
	new_station_name += name + " "

	// ID Number
	switch(random)
		if(1)
			new_station_name += "[rand(1, 99)]"
		if(2)
			new_station_name += pick(GLOB.greek_letters)
		if(3)
			new_station_name += "\Roman[rand(1,99)]"
		if(4)
			new_station_name += pick(GLOB.phonetic_alphabet)
		if(5)
			new_station_name += pick(GLOB.numbers_as_words)
		if(13)
			new_station_name += pick("13","XIII","Thirteen")
	return new_station_name
