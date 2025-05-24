/mob/living/carbon/human/species/halforc
	race = /datum/species/halforc

/datum/species/halforc
	id = "halforc"
	name = "Half-Orc"
	desc = "The bastards of Graggar. \
	\n\n\
	Half-Orcs are the offspring of orcs and another race, \
	the powerful Graggarite genes of the former corrupting and maiming those of their fairer mates. \
	This causes their children to be severely deformed, looking much more like their monstrous progenitor. \
	\n\n\
	Due to their orcish parent's refusal to nurture them, \
	as well as their other parent often rejecting or attacking them, \
	most Half-Orcs will grow as orphans. \
	Their rejection by the rest of society causes their growth to stunt, \
	often making them hostile and prone to violence. Because of this, most will assume the worst in them, \
	believing that they are cursed to follow their orcish parent's footsteps in the gorging of kin-flesh. \
	\n\n\
	A Half-Orc may look much like its monstrous progenitor, sporting tusks and natural strength. \
	\n\n\
	THIS IS AN <I>EXTREMELY</I> DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. <B>NOBLES EVEN MORE SO.</B> PLAY AT YOUR OWN RISK."

	skin_tone_wording = "Clan"
	nutrition_mod = 2 // 200% higher hunger rate. Hungry, hungry horcs

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_NOSTINK)
	// horcs are STINKY
	components_to_add = list(/datum/component/rot/stinky_person)
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = NORMAL_AGES_LIST_CHILD
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt_muscular.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/ft_muscular.dmi'
	dam_icon_m = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	swap_female_clothes = TRUE
	soundpack_m = /datum/voicepack/male/elf
	soundpack_f = /datum/voicepack/female/elf
	offset_features = list(OFFSET_RING = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
	OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
	OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
	OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
	OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
	OFFSET_RING_F = list(0,1), OFFSET_GLOVES_F = list(0,1), OFFSET_WRISTS_F = list(0,1), OFFSET_HANDS_F = list(0,1), \
	OFFSET_CLOAK_F = list(0,1), OFFSET_FACEMASK_F = list(0,1), OFFSET_HEAD_F = list(0,1), \
	OFFSET_FACE_F = list(0,1), OFFSET_BELT_F = list(0,1), OFFSET_BACK_F = list(0,1), \
	OFFSET_NECK_F = list(0,1), OFFSET_MOUTH_F = list(0,1), OFFSET_PANTS_F = list(0,0), \
	OFFSET_SHIRT_F = list(0,1), OFFSET_ARMOR_F = list(0,1), OFFSET_UNDIES_F = list(0,1))
	specstats = list(STATKEY_STR = 2, STATKEY_PER = -2, STATKEY_INT = -2, STATKEY_CON = 2, STATKEY_END = 1, STATKEY_SPD = 0, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = 2, STATKEY_PER = -2, STATKEY_INT = -1, STATKEY_CON = 1, STATKEY_END = 1, STATKEY_SPD = 0, STATKEY_LCK = 0)
	enflamed_icon = "widefire"
	exotic_bloodtype = /datum/blood_type/human/horc
	meat = /obj/item/reagent_containers/food/snacks/meat/strange

	customizers = list(
		/datum/customizer/organ/ears/halforc,
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
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/halforc,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

/datum/species/halforc/check_roundstart_eligible()
	return TRUE

/datum/species/halforc/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/orcish)

/datum/species/halforc/after_creation(mob/living/carbon/C)
	..()
	C.grant_language(/datum/language/orcish)
	to_chat(C, span_info("I can speak Orcish with ,o before my speech."))

/datum/species/halforc/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/orcish)

/datum/species/halforc/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/halforc/get_skin_list()
	return list(
		"Shellcrest" = SKIN_COLOR_SHELLCREST,
		"Bloodaxe" = SKIN_COLOR_BLOOD_AXE,
		"Splitjaw" = SKIN_COLOR_GROONN, //Changed name from Gronn, which no longer aligned with lore here or elsewhere.
		"Blackhammer" = SKIN_COLOR_BLACK_HAMMER,
		"Skullseeker" = SKIN_COLOR_SKULL_SEEKER,
		"Crescent Fang" = SKIN_COLOR_CRESCENT_FANG,
		"Murkwalker" = SKIN_COLOR_MURKWALKER,
		"Shatterhorn" = SKIN_COLOR_SHATTERHORN,
		"Spiritcrusher" = SKIN_COLOR_SPIRITCRUSHER
	)

/datum/species/halforc/get_hairc_list()
	return sortList(list(
	"brown - minotaur" = "58433b",
	"brown - volf" = "48322a",
	"brown - bark" = "2d1300",

	"green - maneater" = "458745",
	"green - swampgrass" = "2A3B2B",

	"black - charcoal" = "201616"
	))

/datum/species/halforc/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/other/halforcm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/other/halforcf.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/halforc/get_possible_surnames(gender = MALE)
	return null

/datum/species/halforc/get_accent_list()
	return strings("accents/halforc_replacement.json", "halforc")

/datum/species/halforc/get_native_language()
	return "Orcish"
