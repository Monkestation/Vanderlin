
/proc/spread_germs_to_bodypart(obj/item/bodypart/bodypart, mob/living/carbon/human/user, obj/item/tool)
	. = FALSE
	if(!istype(user) || !istype(bodypart) || !istype(bodypart.owner) || bodypart.is_robotic_limb())
		return

	//Germs from the surgeon
	var/our_germ_level = user.germ_level
	if(user.gloves)
		our_germ_level = user.gloves.germ_level

	//Germs from the tool
	if(tool)
		our_germ_level += tool.germ_level
	//No tool, pretend the surgeon is the tool
	else
		our_germ_level *= 2

	//Germs from the dirtiness on the surgery room
	var/turf/open/floor/floor = get_turf(bodypart.owner)
	if(istype(floor))
		our_germ_level += floor.germ_level

	//Divide it by 10 to be reasonable
	our_germ_level = CEILING(our_germ_level/10, 1)

	//If the patient has antibiotics, kill germs by an amount equal to 10x the antibiotic force
	//e.g. nalixidic acid has 35 force, thus would decrease germs here by 350
	var/antibiotics = bodypart.owner.get_antibiotics()
	our_germ_level = max(0, our_germ_level - (antibiotics * 10))

	//This amount is not meaningful enough to cause an infection
	if(our_germ_level < INFECTION_LEVEL_ONE/2)
		return

	. = TRUE

	//If we still have germs, let's get that W

	//Injuries first
	for(var/datum/injury/injury as anything in bodypart.injuries)
		if((injury.required_status == BODYPART_ORGANIC) && (injury.germ_level < SURGERY_GERM_MAXIMUM))
			injury.adjust_germ_level(our_germ_level, maximum_germs = SURGERY_GERM_MAXIMUM)

	//Then, infect the organs on the bodypart
	for(var/obj/item/organ/organ as anything in bodypart.get_organs())
		if((organ.germ_level < SURGERY_GERM_MAXIMUM))
			organ.adjust_germ_level(our_germ_level, maximum_germs = SURGERY_GERM_MAXIMUM)

	//Then, infect the bodypart
	if(bodypart.is_organic_limb() && !CHECK_BITFIELD(bodypart.limb_flags, BODYPART_NO_INFECTION) && (bodypart.germ_level < SURGERY_GERM_MAXIMUM))
		bodypart.adjust_germ_level(our_germ_level, maximum_germs = SURGERY_GERM_MAXIMUM)
