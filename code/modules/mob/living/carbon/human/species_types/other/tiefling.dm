	/*==============*
	*				*
	*	Tiefling	*
	*				*
	*===============*/

/mob/living/carbon/human/species/tieberian
	race = /datum/species/tieberian

/datum/species/tieberian
	name = "Tiefling"
	id = "tiefling"
	desc = "Also known as Infernal-Spawn, Hell-Bloods, Surface-Devils, and perhaps in a more humorous manner, <i>thief</i>-lings. \
	\n\n\
	Their treatment ranges from shunning to distrust, depending on the region. \
	Shopkeeps and merchants always keep a wary eye out when a tiefling passes by. \
	The resentment feed into itself, leading to higher rates of tiefling ire and thievery against other species. \
	Many tieflings resign to seeking a solitary and nomadic life, huddled in groups outside the watchful eyes of others. \
	They also tend to be extremely perceptive and paranoid, as luck is rarely on their side. \
	\n\n\
	Tieflings are incapable of reproducing with mortals, \
	and thus are spawn of either devils, demons, or other tieflings. \
	A tiefling may develop any number of hellish features, a wide range of horns, potential hooves, odd spines and spikes, or scales. \
	Oddly positioned scales, hollow bones, and other varying oddities \
	that appear consistently in Tiefling biology make them considerably fragile. \
	It is not uncommon for a tiefling to be generally unpleasant to look at in the eye of the commonfolk. \
	If to make matters worse, their hellish progenitors have left them a destiny of misfortune, \
	though perhaps their immunity to fire opens new opportunities... \
	\n\n\
	THIS IS A DISCRIMINATED SPECIES. EXPECT A MORE DIFFICULT EXPERIENCE. <B>NOBLES EVEN MORE SO.</B> PLAY AT YOUR OWN RISK."

	skin_tone_wording = "Progenitor"

	exotic_bloodtype = /datum/blood_type/human/tiefling

	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP,TRAIT_NOFIRE)
	use_skintones = 1
	disliked_food = NONE
	liked_food = NONE
	possible_ages = NORMAL_AGES_LIST_CHILD
	changesource_flags = WABBAJACK
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mm.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon_m = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	hairyness = "t3"
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_RING = list(0,0), OFFSET_GLOVES = list(0,0), OFFSET_WRISTS = list(0,0),\
	OFFSET_CLOAK = list(0,0), OFFSET_FACEMASK = list(0,0), OFFSET_HEAD = list(0,0), \
	OFFSET_FACE = list(0,0), OFFSET_BELT = list(0,0), OFFSET_BACK = list(0,0), \
	OFFSET_NECK = list(0,0), OFFSET_MOUTH = list(0,0), OFFSET_PANTS = list(0,0), \
	OFFSET_SHIRT = list(0,0), OFFSET_ARMOR = list(0,0), OFFSET_HANDS = list(0,0), OFFSET_UNDIES = list(0,0), \
	OFFSET_RING_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
	OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
	OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,-1), OFFSET_BACK_F = list(0,-1), \
	OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
	OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,0))
	specstats = list(STATKEY_STR = 0, STATKEY_PER = 2, STATKEY_INT = 1, STATKEY_CON = -1, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = -1)
	specstats_f = list(STATKEY_STR = 0, STATKEY_PER = 2, STATKEY_INT = 1, STATKEY_CON = -1, STATKEY_END = 0, STATKEY_SPD = 1, STATKEY_LCK = -1)
	enflamed_icon = "widefire"
	patreon_req = 0

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_HORNS = /obj/item/organ/horns/tiefling,
		ORGAN_SLOT_TAIL = /obj/item/organ/tail/tiefling
	)
	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)
	customizers = list(
		/datum/customizer/organ/ears/tiefling,
		/datum/customizer/organ/horns/tiefling,
		/datum/customizer/organ/tail/tiefling,
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
	)
	body_markings = list(
		/datum/body_marking/tonage,
	)

/datum/species/tieberian/check_roundstart_eligible()
	return TRUE

/datum/species/tieberian/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/hellspeak)

/datum/species/tieberian/after_creation(mob/living/carbon/C)
	..()
//	if(!C.has_language(/datum/language/sandspeak))
	C.grant_language(/datum/language/hellspeak)
	to_chat(C, "<span class='info'>I can speak Infernal with ,h before my speech.</span>")

/datum/species/tieberian/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/hellspeak)

/datum/species/tieberian/handle_speech(datum/source, list/speech_args)
	. = ..()
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		if(message[1])
			if(message[1] != "*")
				message = " [message]"
				var/list/accent_words = strings("accents/accent_universal.json", "universal")

				for(var/key in accent_words)
					var/value = accent_words[key]
					if(islist(value))
						value = pick(value)

					message = replacetextEx(message, " [uppertext(key)]", " [uppertext(value)]")
					message = replacetextEx(message, " [capitalize(key)]", " [capitalize(value)]")
					message = replacetextEx(message, " [key]", " [value]")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/species/tieberian/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/tieberian/get_skin_list()
	var/static/list/skin_colors = sortList(list(
		"Crimson Land" = SKIN_COLOR_CRIMSON_LAND, // - (Bright red)
		"Sun Stained" = SKIN_COLOR_SUNSTAINED, // - (Dark orange)
		"Sundered" = SKIN_COLOR_SUNDERED, //  - (Orange)
		"Zarkana" = SKIN_COLOR_ARCANA, // - (Dark violet)
		"Zarconum" = SKIN_COLOR_ZARCONUM, // - (Pink)
		"Flayer" = SKIN_COLOR_FLAYER, // - (Purple)
		"Abyssium" = SKIN_COLOR_ABYSS, // - (Navy blue)
		"Castillian" = SKIN_COLOR_CASTILLIAN, // - (Pale red)
		"Asturias" = SKIN_COLOR_ASTURIAS, // - (Clay red)
		"Vaquero" = SKIN_COLOR_VAQUERO, // - (Earthly red)
		"Zanguine" = SKIN_COLOR_ZANGUINE, // - (Dark violet)
		"Ash" = SKIN_COLOR_ASH, // - (Pale blue)
		"Arlenneth" = SKIN_COLOR_ARLENNETH, // - (Lavender blue)
	))

	return skin_colors

/datum/species/tieberian/get_hairc_list()
	var/static/list/hair_colors = sortList(list(
		"black - oil" = "181a1d",
		"black - cave" = "201616",
		"black - rogue" = "2b201b",
		"black - midnight" = "1d1b2b",

		"blond - pale" = "9d8d6e",
		"blond - dirty" = "88754f",
		"blond - drywheat" = "d5ba7b",
		"blond - strawberry" = "c69b71",

		"purple - arcane" = "3f2f42",

		"blue - abyss" = "09282d",

		"red - demonic" = "480808",
		"red - impish" = "641010",
		"red - rubescent" = "8d5858"
	))

	return hair_colors

/datum/species/tieberian/get_possible_names(gender = MALE)
	var/static/list/male_names = world.file2list('strings/rt/names/other/tiefm.txt')
	var/static/list/female_names = world.file2list('strings/rt/names/other/tiefm.txt')
	return (gender == FEMALE) ? female_names : male_names

/datum/species/tieberian/get_possible_surnames(gender = MALE)
	var/static/list/last_names = world.file2list('strings/rt/names/other/tieflast.txt')
	return last_names

/datum/species/tieberian/get_accent_list()
	return strings("accents/spanish_replacement.json", "spanish")

/datum/species/tieberian/get_native_language()
	return "Infernal"
