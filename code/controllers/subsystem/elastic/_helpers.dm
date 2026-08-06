/proc/add_elastic_data(main_cat, list/assoc_data)
	if(!main_cat || !length(assoc_data))
		return
	var/datum/elastic_shard/S = SSelastic.get_shard(main_cat)
	if(!S)
		return
	S.add_list_data(assoc_data)
	return TRUE

/proc/add_elastic_data_immediate(main_cat, list/assoc_data)
	if(!main_cat || !length(assoc_data))
		return
	var/datum/elastic_shard/S = SSelastic.get_shard(main_cat)
	if(!S)
		return
	S.add_list_data(assoc_data)
	var/compiled = S.get_compiled_data(SSelastic)
	if(compiled)
		SSelastic.dispatch_request(compiled)
		S.reset()
	return TRUE

/proc/add_abstract_elastic_data(main_cat, abstract_name, abstract_value, maximum)
	if(!main_cat || !isnum(abstract_value))
		return
	var/datum/elastic_shard/S = SSelastic.get_shard(main_cat)
	if(!S)
		return
	S.add_abstract_data(abstract_name, abstract_value, maximum)
	return TRUE

/proc/init_abstract_zeros()
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_FIGHT_REVIVES, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_COIN_REVIVES, 0)
	add_abstract_elastic_data(ELASCAT_COMBAT, ELASDATA_EATEN_BODIES, 0)
	add_abstract_elastic_data(ELASCAT_COMBAT, ELASDATA_DECAPITATIONS, 0)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_MAMMONS_GAINED, 0)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_MAMMONS_SPENT, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_ANASTASIS_REVIVE, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_CPR_REVIVE, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_ABSOLVE_REVIVE, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_ULTIMATE_REVIVE, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_LUX_REVIVE, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_LUX_EXTRACT, 0)
	add_abstract_elastic_data(ELASCAT_MEDICAL, ELASDATA_LUX_EXTRACT_PLAYER, 0)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_TRIUMPH_SPENT, 0)
	add_abstract_elastic_data(ELASCAT_ECONOMY, ELASDATA_TRIUMPH_AWARDED, 0)
