	/*==============*
	*				*
	*	Half-Elf	*
	*				*
	*===============*/

/mob/living/carbon/human/species/human/halfelf
	race = /datum/species/human/halfelf

/datum/species/human/halfelf
	name = "Half-Elf"
	id = SPEC_ID_HALF_ELF
	multiple_accents = list(
		"Humen Accent" = "Imperial",
		"Elf Accent" = "Elfish"
	)
	desc = "The child of an Elf and a Humen. \
	\n\n\
	Half-Elves are generally frowned upon by more conservative peoples, \
	although as species tensions lower, more and more half-elves are being born- \
	to the point that some scholars worry someday \
	it may be impossible to distinguish the two species. \
	\n\n\
	Half-Elves are extraordinarily diverse, as they combine both Humen and Elvish culture. \
	It is widely considered that Half-Elf culture is simply a melting pot of \
	various others condensing into one vibrant entity. \
	\n\n\
	With their longevity spanning too long for a human and too short for an elf, they tend to congregate together. \
	Depending on their heritage, Half-Elves tend to gain species traits \
	depending on how strong their fathers, or mothers, genes were. \
	Half-Elves typically struggle to find their own identity."

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)

	use_skintones = TRUE
	possible_ages = NORMAL_AGES_LIST_CHILD

	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mm.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'

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
		OFFSET_BELT = list(0,-1),\
		OFFSET_BACK = list(0,-1),\
		OFFSET_NECK = list(0,-1),\
		OFFSET_MOUTH = list(0,-1),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,0),\
		OFFSET_ARMOR = list(0,0),\
		OFFSET_UNDIES = list(0,0),\
	)

	specstats_m = list(STATKEY_STR = 0, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = 0, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = 0, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = 0, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = 0)

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/elf/less,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/elf,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	customizers = list(
		/datum/customizer/organ/ears/elf,
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)

	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)

	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/human/halfelf/check_roundstart_eligible()
	return TRUE

/datum/species/human/halfelf/get_hairc_list()
	return sortList(list(
		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",

		"brown - mud" = "362e25",
		"brown - oats" = "584a3b",
		"brown - grain" = "58433b",
		"brown - soil" = "48322a",

		"red - berry" = "b23434",
		"red - wine" = "82534c",
		"red - sunset" = "82462b",
		"red - blood" = "822b2b",
		"red - maroon" = "612929",

		"blond - pale" = "9d8d6e",
		"blond - dirty" = "88754f",
		"blond - drywheat" = "d5ba7b",
		"blond - strawberry" = "c69b71",

		"green - leaf" = "2f3c2e",
		"green - moss" = "3b3c2a"
	))

/datum/species/human/halfelf/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/elf/elfwm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/elf/elfwf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/human/halfelf/get_possible_surnames(gender = MALE)
	return null

/datum/species/human/halfelf/after_creation(mob/living/carbon/human/C)
	..()
	//If a donator picks the Elf Accent as a Half Elf, it will work the same as a non donator.
	if(C.accent == ACCENT_ELF)
		C.dna.species.native_language = "Elfish"
		C.dna.species.accent_language = C.dna.species.get_accent(C.dna.species.native_language, 1)
	if(!(C.accent in GLOB.accent_list))
		C.dna.species.native_language = C.accent
	C.dna.species.accent_language = C.dna.species.get_accent(C.dna.species.native_language, 1)
	C.grant_language(/datum/language/elvish)
	to_chat(C, "<span class='info'>I can speak Elvish with ,e before my speech.</span>")

