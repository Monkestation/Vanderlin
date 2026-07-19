/datum/preference/list_type/role_setting/picker/supply_pack
	savefile_key = "supply_pack"
	setting_display_name = "Merchant Starting Supply"
	ui_category = "Merchant"
	max_lines = 3
	/// List of type paths to pick from
	picker_options = list()
	post_job_pref = TRUE
	job_types = list(
		/datum/job/merchant
	)

/datum/preference/list_type/role_setting/picker/supply_pack/New()
	. = ..()
	for(var/datum/supply_pack/pack as anything in subtypesof(/datum/supply_pack))
		if(IS_ABSTRACT(pack) || !initial(pack.allowed_start))
			continue
		picker_options |= pack

/datum/preference/list_type/role_setting/picker/supply_pack/post_job_apply(mob/living/carbon/human/H, value, client/client)
	if(!islist(value))
		return
	var/list/packs = value
	for(var/path in packs)
		var/datum/supply_pack/pack_type = text2path(path)
		if(!pack_type || !ispath(pack_type, /datum/supply_pack))
			continue
		var/datum/supply_pack/pack = SSmerchant.supply_packs[pack_type]
		if(!pack)
			continue
		if(SSmerchant.requestlist[pack])
			SSmerchant.requestlist[pack]++
		else
			SSmerchant.requestlist[pack] = 1

/datum/preference/list_type/role_setting/picker/supply_pack/get_option_data()
	var/list/result = list()
	for(var/path in picker_options)
		var/datum/supply_pack/A = new path
		var/atom/supply
		if(islist(A.contains))
			supply = A.contains[1]
		else
			supply = A.contains
		result += list(list(
			"value" = "[path]",
			"name" = initial(A.name),
			"icon" = initial(supply.icon),
			"icon_state" = initial(supply.icon_state),
			"is_path" = TRUE,
		))
		qdel(A)
	return result
