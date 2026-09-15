/* This comment bypasses grep checks */ var/__memprofile
#define MEMPROFILE_DLL (world.system_type == MS_WINDOWS ? "byond_memprofile.dll" : (__memprofile ||= __detect_auxtools("byond_memprofile")))

/proc/__detect_auxtools(library)
	if(IsAdminAdvancedProcCall())
		return
	if (fexists("./lib[library].so"))
		return "./lib[library].so"
	else if (fexists("[world.GetConfig("env", "HOME")]/.byond/bin/lib[library].so"))
		return "[world.GetConfig("env", "HOME")]/.byond/bin/lib[library].so"
	else
		CRASH("Could not find lib[library].so")


/proc/memprofile_init()
	return call_ext(MEMPROFILE_DLL, "memprofile_init")()

/proc/memprofile_census()
	return call_ext(MEMPROFILE_DLL, "memprofile_census")()

/proc/memprofile_lists(row_count_or_all, output_path)
	if(isnull(row_count_or_all) && isnull(output_path))
		return call_ext(MEMPROFILE_DLL, "memprofile_lists")()
	if(isnull(output_path))
		return call_ext(MEMPROFILE_DLL, "memprofile_lists")("[row_count_or_all]")
	return call_ext(MEMPROFILE_DLL, "memprofile_lists")("[row_count_or_all]", output_path)

/proc/memprofile_var_histogram()
	return call_ext(MEMPROFILE_DLL, "memprofile_var_histogram")()

/proc/memprofile_diff()
	return call_ext(MEMPROFILE_DLL, "memprofile_diff")()

/proc/memprofile_byond_compat()
	return call_ext(MEMPROFILE_DLL, "memprofile_byond_compat")()

/proc/_memprofile_decode(json)
	if(!json)
		return null
	return json_decode(json)

/proc/memprofile_census_json(output_path)
	if(isnull(output_path))
		return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_census_json")())
	return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_census_json")(output_path))

/proc/memprofile_lists_json(row_count_or_all, output_path)
	if(isnull(row_count_or_all) && isnull(output_path))
		return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_lists_json")())
	if(isnull(output_path))
		return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_lists_json")("[row_count_or_all]"))
	return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_lists_json")("[row_count_or_all]", output_path))

/proc/memprofile_var_histogram_json()
	return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_var_histogram_json")())

/proc/memprofile_diff_json()
	return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_diff_json")())

/proc/memprofile_byond_compat_json()
	return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_byond_compat_json")())

/proc/memprofile_base_sizes()
	return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_base_sizes_json")())

/proc/memprofile_coverage()
	return _memprofile_decode(call_ext(MEMPROFILE_DLL, "memprofile_get_coverage")())

/proc/memprofile_debug()
	return call_ext(MEMPROFILE_DLL, "memprofile_get_debug")()

/proc/memprofile_clear()
	return call_ext(MEMPROFILE_DLL, "memprofile_clear")()

/proc/memprofile_report()
	var/text = memprofile_census()
	if(!text)
		world.log << "=== memprofile: no output (did memprofile_init() succeed?) ==="
		return
	for(var/line in splittext(text, "\n"))
		world.log << line
