/mob/living/carbon/human/species/triton
	race = /datum/species/triton

/datum/species/triton
	name = "Triton"
	id = SPEC_ID_TRITON
	native_language = "Deepspeak"
	changesource_flags = WABBAJACK

	desc = "The Children of Abyssor, also known as Tritons or their colloquial name, \"Deep Folk,\" \
	are a strange species of people that live under the waves of Psydonia. \
	Born from creatures of the deep with Abyssor's guidance, \
	these aquatic wayfarers all share a few common traits. \
	Similar to other creatures that dwell below the surface, their eyes are dull with disuse. \
	Tritons feel pain when gazing upon that which direct light of Astrata herself illuminates. \
	\n\n\
	Unlike most of the people of Psydonia, their culture is often considered cold and dour; \
	an apathetic attitude to most negative or positive news. For them, the depths of Psydonias oceans are cold and unforgiving. \
	Large beasts travel the waters that swallow their kin whole... \
	but the crushing depths have provided them a hearty disposition and resistance to most threats. \
	Born of Abyssor, their normally placid emotions can swing into a wild rage when they view injustice done upon their kin at the hands of a sapient being. \
	\n\n\
	Tritons seen on the surface are very important trade partners, mercenaries, and surprising academics. \
	Merchants often spend vast amounts of coin to have them aboard their trade vessels, fending off pirates or guiding their boats through turbulent weather. \
	Be it on or within the sea, they excel- on land, however, they struggle. \
	With their awkward and gangly fins, long, sharp talons, ghastly, lipless teeth, \
	and milky, foreign eyes, they seem unfit to walk amongst the people. Humen children are often afraid of them due to such appearances. \
	\n\n\
	Their species is not without its tribalism, however. Large sections of their kin have broken away form their father, \
	to consider themselves Noc's chosen. Due to their extreme sexual dimorphism similar to that of the common angler, \
	males of this species are more likely to pursue magick with their weaker frames compared to their stronger female counterparts."

	possible_ages = NORMAL_AGES_LIST

	skin_tone_wording = "Spawn"
	default_color = "9cc2e2"
	use_skintones = TRUE

	species_traits = list(NO_UNDERWEAR, HAIR, FACEHAIR, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP, TRAIT_WATER_BREATHING, TRAIT_GOOD_SWIM, TRAIT_FISHFACE)
	inherent_traits_f = list(TRAIT_STRONGBITE)
	inherent_skills = list(
		/datum/skill/labor/fishing = 3,
		/datum/skill/misc/swimming = 4,
	)

	allowed_voicetypes_f = list(
		VOICE_TYPE_MASC,
	)

	allowed_voicetypes_m = list(
		VOICE_TYPE_ANDRO
	)

	specstats_m = list(STATKEY_STR = -1, STATKEY_PER = -2, STATKEY_CON = -2, STATKEY_SPD = 1, STATKEY_INT = 2)
	specstats_f = list(STATKEY_STR = 2, STATKEY_PER = -4, STATKEY_CON = 3, STATKEY_SPD = -3)

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/triton.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/triton.dmi'

	soundpack_m = /datum/voicepack/female
	soundpack_f = /datum/voicepack/male

	swap_female_clothes = TRUE
	swap_male_clothes = TRUE

	exotic_bloodtype = /datum/blood_type/human/triton
	enflamed_icon = "widefire"

	// FEMALE from Male Humen
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

	// MALE from Female Humen
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

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/triton,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/fish,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_HORNS = /obj/item/organ/horns/triton,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/triton
	)

	customizers = list(
		/datum/customizer/organ/tail/triton,
		/datum/customizer/bodypart_feature/hair/head/humanoid/triton,
		/datum/customizer/bodypart_feature/hair/facial/humanoid/triton,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)

	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/triton/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/deepspeak)

/datum/species/triton/after_creation(mob/living/carbon/C)
	. = ..()
	C.grant_language(/datum/language/deepspeak)
	to_chat(C, "<span class='info'>I can speak Deepspeak with ,f before my speech.</span>")

/datum/species/triton/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/deepspeak)

/datum/species/triton/check_roundstart_eligible()
	return TRUE

/datum/species/triton/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/triton/get_skin_list()
	// Manually sorted please sort your new entries
	return list(
		"Algae Borne" = SKIN_COLOR_ALGAE,
		"Deep Borne" = SKIN_COLOR_DEEP,
		"Jellyfish Borne" = SKIN_COLOR_JELLYFISH,
		"kelp Borne" = SKIN_COLOR_KELP,
		"Reef Borne" = SKIN_COLOR_REEF,
		"Sand Borne" = SKIN_COLOR_SAND,
		"Shallow Borne" = SKIN_COLOR_SHALLOW,
		"Urchin Borne" = SKIN_COLOR_URCHIN,
	)

/datum/species/triton/get_hairc_list()
	return list(
		"Abyss" = HAIR_COLOR_ABYSS,
		"Clown" = HAIR_COLOR_CLOWN,
		"Hydrothermal" = HAIR_COLOR_HYDROTHERMAL,
		"Inky" = HAIR_COLOR_INKY,
		"Sea Foam" = HAIR_COLOR_SEA_FOAM,
	)

/datum/species/triton/get_oldhc_list()
	return list(
		"Fog" = HAIR_COLOR_SEA_FOG,
		"Gravel" = HAIR_COLOR_GRAVEL,
		"Mist" = HAIR_COLOR_MIST,
		"Photic" = HAIR_COLOR_PHOTIC,
		"Turtle Egg" = HAIR_COLOR_TURTLE,
	)

