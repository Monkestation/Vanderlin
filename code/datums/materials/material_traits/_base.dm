GLOBAL_LIST_INIT(material_traits, generate_material_traits())

/proc/generate_material_traits()
	var/list/material_traits = list()
	for(var/datum/material_trait/trait as anything in typesof(/datum/material_trait))
		if(IS_ABSTRACT(trait))
			continue
		material_traits |= trait
		material_traits[trait] = new trait
	return material_traits

/datum/material_trait
	var/name = "Material Trait"

/datum/material_trait/proc/on_consume(mob/target, amount)

/datum/material_trait/proc/on_life(mob/target, amount)
