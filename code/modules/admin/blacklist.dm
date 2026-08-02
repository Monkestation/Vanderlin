#define NAMEBANFILE "[global.config.directory]/roguetown/nameban.txt"

GLOBAL_LIST(nameban)
GLOBAL_PROTECT(nameban)

/proc/load_nameban()
	GLOB.nameban = list()
	for(var/line in file2list(NAMEBANFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.nameban += ckey(line)

	if(!GLOB.nameban.len)
		GLOB.nameban = null

/proc/check_nameban(ckey)
	if(!GLOB.nameban)
		return FALSE
	. = (ckey in GLOB.nameban)

#undef NAMEBANFILE

