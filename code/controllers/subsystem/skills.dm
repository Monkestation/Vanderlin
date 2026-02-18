/*!
This subsystem mostly exists to populate and manage the skill singletons.
*/

SUBSYSTEM_DEF(skills)
	name = "Skills"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SKILLS
	lazy_load = FALSE
	///Dictionary of skill.type || skill ref
	var/list/all_skills = list()
	///Static assoc list of levels (ints) - strings
	var/list/level_names = list(span_info("Weak"), span_info("Average"), span_biginfo("Skilled"), span_biginfo("Expert"), "<B>Master</B>", span_greentext("Legendary"))//This list is already in the right order, due to indexing


/datum/controller/subsystem/skills/Initialize(timeofday)
	InitializeSkills()
	return ..()

///Ran on initialize, populates the skills dictionary
/datum/controller/subsystem/skills/proc/InitializeSkills(timeofday)
	for(var/datum/skill/type as anything in subtypesof(/datum/skill))
		if(IS_ABSTRACT(type))
			continue
		all_skills[type] = new type()
