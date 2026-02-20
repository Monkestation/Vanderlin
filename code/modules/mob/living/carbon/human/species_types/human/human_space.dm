	/*==============*
	*				*
	*	 Human		*
	*				*
	*===============*/

//	( +1 STR, +1 PER, +4 INT, +1 CON, +2 END, +2 SPD -1 FOR)

/mob/living/carbon/human/species/human/space
	race = /datum/species/human/space

/datum/species/human/space
	name = "Human"
	id = SPEC_ID_HUMAN_SPACE
	desc = "A space-faring species. \
	\n\n\
	Humans have long since departed from the restraints of their homeworld, 'Earth.' \
	Most live within megacorporation jurisdiction, TerraGov space, or politically irrelevant planetary colonies. \
	Most humans rightfully avoid this section of space, however the corporation Interdyne Pharmaceuticals \
	avoids these warnings with Syndicate backing, repeatedly attempting planetary landing in effort to create \
	some nondescript bioweapon under codename 'Romero.' \
	\n\n\
	While genetic alteration technologies allow for a wide range of hair colours, \
	only those considered 'natural' are allowed on missions to Psydonia. They are expected to blend in \
	with the local- and strikingly similar- 'humen' species population due to difficulties of extraction. \
	\n\n\
	Human bodies have largely adapted to their space-faring lifestyle. Through their training, their physical \
	abilities largely overshadow most Psydonia-native species, divine or otherwise. A human's intelligence and knowledge \
	VASTLY dwarfs anything seen on the planet. However, the gods of Psydonia do not smile upon them. They must stay \
	covert, or face an another immediate sunbeam to their location."

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	use_skintones = TRUE

	possible_ages = NORMAL_AGES_LIST

	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mm.dmi'	//If we want to be funny, change these in the future? Has to be subtle.
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'	//We don't want this species to be meta-detectable.

	soundpack_m = /datum/voicepack/male						//Also a funny potential switch, more feasible to stay covert given that this is tied to emotes almost exclusively.
	soundpack_f = /datum/voicepack/female

	offset_features_m = list(
		OFFSET_RING = list(0,0),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,0),\
		OFFSET_HEAD = list(0,0),\
		OFFSET_FACE = list(0,0),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,0),\
		OFFSET_NECK = list(0,0),\
		OFFSET_MOUTH = list(0,0),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,-1),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,0),\
		OFFSET_HANDS = list(0,0),\
		OFFSET_CLOAK = list(0,0),\
		OFFSET_FACEMASK = list(0,-1),\
		OFFSET_HEAD = list(0,-1),\
		OFFSET_FACE = list(0,-1),\
		OFFSET_BELT = list(0,0),\
		OFFSET_BACK = list(0,-1),\
		OFFSET_NECK = list(0,-1),\
		OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	specstats_m = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_INT = 4, STATKEY_CON = 1, STATKEY_END = 2, STATKEY_SPD = 2, STATKEY_LCK = -1)
	specstats_f = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_INT = 4, STATKEY_CON = 1, STATKEY_END = 2, STATKEY_SPD = 2, STATKEY_LCK = -1)

	enflamed_icon = "widefire"

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)
	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/human/space/check_roundstart_eligible()
	return FALSE

/datum/species/human/space/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/human/humnorm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/human/humnorf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/human/space/get_possible_surnames(gender = MALE)
	var/static/list/last_names = world.file2list('strings/rt/names/human/humnorlast.txt')
	return last_names
