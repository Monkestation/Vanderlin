#define MINIMUM_FLAVOR_TEXT		0
#define MINIMUM_OOC_NOTES 		0

//Preference toggles
#define SOUND_ADMINHELP			(1<<0)
#define SOUND_MIDI				(1<<1)
#define SOUND_AMBIENCE			(1<<2)
#define SOUND_LOBBY				(1<<3)
#define MEMBER_PUBLIC			(1<<4)
#define INTENT_STYLE			(1<<5)
#define MIDROUND_ANTAG			(1<<6)
#define SOUND_INSTRUMENTS		(1<<7)
#define SOUND_SHIP_AMBIENCE		(1<<8)
#define SOUND_PRAYERS			(1<<9)
#define ANNOUNCE_LOGIN			(1<<10)
#define SOUND_ANNOUNCEMENTS		(1<<11)
#define DISABLE_DEATHRATTLE		(1<<12)
#define DISABLE_ARRIVALRATTLE	(1<<13)
#define COMBOHUD_LIGHTING		(1<<14)
#define DEADMIN_ALWAYS			(1<<15)
#define DEADMIN_ANTAGONIST		(1<<16)
#define DEADMIN_POSITION_HEAD	(1<<17)
#define DEADMIN_POSITION_SECURITY	(1<<18)
#define DEADMIN_POSITION_SILICON	(1<<19)
#define TOGGLE_FULLSCREEN		(1<<20)
#define SCHIZO_VOICE			(1<<21)
#define UI_SCALE				(1<<22)

#define TOGGLES_DEFAULT (SOUND_ADMINHELP|SOUND_MIDI|SOUND_AMBIENCE|SOUND_LOBBY|MIDROUND_ANTAG|SOUND_INSTRUMENTS|SOUND_SHIP_AMBIENCE|SOUND_PRAYERS|SOUND_ANNOUNCEMENTS|TOGGLE_FULLSCREEN)

//Chat toggles
#define CHAT_OOC			(1<<0)
#define CHAT_DEAD			(1<<1)
#define CHAT_GHOSTEARS		(1<<2)
#define CHAT_GHOSTSIGHT		(1<<3)
#define CHAT_PRAYER			(1<<4)
#define CHAT_RADIO			(1<<5)
#define CHAT_PULLR			(1<<6)
#define CHAT_GHOSTWHISPER	(1<<7)
#define CHAT_GHOSTPDA		(1<<8)
#define CHAT_GHOSTRADIO 	(1<<9)
#define CHAT_BANKCARD  (1<<10)

#define TOGGLES_DEFAULT_CHAT (CHAT_OOC|CHAT_PRAYER|CHAT_RADIO|CHAT_PULLR|CHAT_GHOSTPDA|CHAT_BANKCARD)

// Maptext toggles
#define DISABLE_RUNECHAT (1<<0)
#define DISABLE_HOVER_TEXT (1<<1)
#define DISABLE_BALLOON_ALERTS (1<<3)

#define PARALLAX_INSANE -1 //for show offs
#define PARALLAX_HIGH    0 //default.
#define PARALLAX_MED     1
#define PARALLAX_LOW     2
#define PARALLAX_DISABLE 3 //this option must be the highest number

#define PIXEL_SCALING_AUTO 0
#define PIXEL_SCALING_1X 1
#define PIXEL_SCALING_1_2X 1.5
#define PIXEL_SCALING_2X 2
#define PIXEL_SCALING_3X 3

#define SCALING_METHOD_NORMAL "normal"
#define SCALING_METHOD_DISTORT "distort"
#define SCALING_METHOD_BLUR "blur"

#define PARALLAX_DELAY_DEFAULT world.tick_lag
#define PARALLAX_DELAY_MED     1
#define PARALLAX_DELAY_LOW     2

// Playtime tracking system, see jobs_exp.dm
#define EXP_TYPE_LIVING			"Living"
#define EXP_TYPE_GHOST			"Ghost"
#define EXP_TYPE_ADMIN			"Admin"
#define EXP_TYPE_ANTAG			"Antag"

#define EXP_TYPE_TOWNER			"Towner Roles"
#define EXP_TYPE_NOBLE			"Noble Roles"
#define EXP_TYPE_ADVENTURER		"Adventurer Roles"
#define EXP_TYPE_CHURCH			"Church Roles"
#define EXP_TYPE_GARRISON		"Garrison Roles"
#define EXP_TYPE_MERCHANT_COMPANY	"Merchant Roles"
#define EXP_TYPE_INQUISITION	"Inquisition Roles"
#define EXP_TYPE_MEDICAL	"Medical Roles"
#define EXP_TYPE_LEADERSHIP	"Leadership Roles"
#define EXP_TYPE_MERCENARY	"Mercenary Roles"

#define EXP_TYPE_CLERIC	"Cleric Roles"
#define EXP_TYPE_RANGER	"Ranger Roles"
#define EXP_TYPE_BARD	"Bard Roles"
#define EXP_TYPE_THIEF	"Thief Roles"
#define EXP_TYPE_MAGICK	"Magick Roles"
#define EXP_TYPE_COMBAT	"Combat Roles"


//Flags in the players table in the db
#define DB_FLAG_EXEMPT 1

//Job preferences levels
#define JP_LOW 1
#define JP_MEDIUM 2
#define JP_HIGH 3

//randomised elements
#define RANDOM_NAME "random_name"
#define RANDOM_NAME_ANTAG "random_name_antag"
#define RANDOM_BODY "random_body"
#define RANDOM_BODY_ANTAG "random_body_antag"
#define RANDOM_SPECIES "random_species"
#define RANDOM_GENDER "random_gender"
#define RANDOM_GENDER_ANTAG "random_gender_antag"
#define RANDOM_PRONOUNS "random_pronouns"
#define RANDOM_PRONOUNS_ANTAG "random_pronouns_antag"
#define RANDOM_VOICETYPE "random_voicetype"
#define RANDOM_VOICETYPE_ANTAG "random_voicetype_antag"
#define RANDOM_AGE "random_age"
#define RANDOM_AGE_ANTAG "random_age_antag"
#define RANDOM_UNDERWEAR "random_underwear"
#define RANDOM_UNDERWEAR_COLOR "random_underwear_color"
#define RANDOM_UNDERSHIRT "random_undershirt"
#define RANDOM_SKIN_TONE "random_skin_tone"
#define RANDOM_EYE_COLOR "random_eye_color"

// randomise_appearance_prefs() and randomize_human_appearance() proc flags
#define RANDOMIZE_GENDER (1<<0)
#define RANDOMIZE_SPECIES (1<<1)
#define RANDOMIZE_PRONOUNS (1<<2)
#define RANDOMIZE_VOICETYPE (1<<3)
#define RANDOMIZE_NAME (1<<4)
#define RANDOMIZE_AGE (1<<5)
#define RANDOMIZE_UNDERWEAR (1<<6)
#define RANDOMIZE_HAIRSTYLE (1<<7)
#define RANDOMIZE_FACIAL_HAIRSTYLE (1<<8)
#define RANDOMIZE_HAIR_COLOR (1<<9)
#define RANDOMIZE_FACIAL_HAIR_COLOR (1<<10)
#define RANDOMIZE_SKIN_TONE (1<<11)
#define RANDOMIZE_EYE_COLOR (1<<12)
#define RANDOMIZE_FEATURES (1<<13)

#define RANDOMIZE_HAIR_FEATURES (RANDOMIZE_HAIRSTYLE | RANDOMIZE_FACIAL_HAIRSTYLE)
#define RANDOMIZE_HAIR_COLORS (RANDOMIZE_HAIR_COLOR | RANDOMIZE_HAIR_COLORS)
#define RANDOMIZE_HAIR_ALL (RANDOMIZE_HAIR_FEATURES | RANDOMIZE_HAIR_COLORS)

//Age ranges
#define AGE_CHILD			"Youngling"
#define AGE_ADULT			"Adult"
#define AGE_MIDDLEAGED		"Middle-Aged"
#define AGE_OLD				"Old"
#define AGE_IMMORTAL		"Immortal"

#define NORMAL_AGES_LIST			list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
#define NORMAL_AGES_LIST_CHILD		list(AGE_CHILD, AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
#define ALL_AGES_LIST				list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
#define ALL_AGES_LIST_CHILD			list(AGE_CHILD, AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)

// Pronouns
#define HE_HIM			"He/Him"
#define SHE_HER			"She/Her"
#define THEY_THEM		"They/Them"
#define IT_ITS			"It/Its"

#define PRONOUNS_LIST list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS)
#define PRONOUNS_LIST_NO_IT list(HE_HIM, SHE_HER, THEY_THEM)
#define PRONOUNS_LIST_IT_ONLY list(IT_ITS)

// Voice types

#define VOICE_TYPE_MASC		"Masculine"
#define VOICE_TYPE_FEM		"Feminine"
#define VOICE_TYPE_ANDRO	"Androgynous"

#define VOICE_TYPES_LIST list(VOICE_TYPE_MASC, VOICE_TYPE_FEM, VOICE_TYPE_ANDRO)

#define VOICE_TYPES_MASCANDRO list(VOICE_TYPE_MASC, VOICE_TYPE_ANDRO)
#define VOICE_TYPES_FEMANDRO list(VOICE_TYPE_FEM, VOICE_TYPE_ANDRO)

//alignment
#define ALIGNMENT_LG		"Lawful Good"
#define ALIGNMENT_NG		"Neutral Good"
#define ALIGNMENT_CG		"Chaotic Good"
#define ALIGNMENT_LN		"Lawful Neutral"
#define ALIGNMENT_TN		"True Neutral"
#define ALIGNMENT_CN		"Chaotic Neutral"
#define ALIGNMENT_LE		"Lawful Evil"
#define ALIGNMENT_NE		"Neutral Evil"
#define ALIGNMENT_CE		"Chaotic Evil"

#define ALL_ALIGNMENTS_LIST list(ALIGNMENT_LG,\
							ALIGNMENT_NG,\
							ALIGNMENT_CG,\
							ALIGNMENT_LN,\
							ALIGNMENT_TN,\
							ALIGNMENT_CN,\
							ALIGNMENT_LE,\
							ALIGNMENT_NE,\
							ALIGNMENT_CE)

#define UI_PREFERENCE_LIGHT_MODE "light mode"
#define UI_PREFERENCE_DARK_MODE "dark mode"

// here because they are specfically for the prefences menu

DEFINE_BITFIELD(toggles_default, list(
	"Be voice" = SCHIZO_VOICE,
	"Enable admin sounds" = SOUND_MIDI,
	"Enable ambience" = SOUND_AMBIENCE,
	"Enable background music" = SOUND_SHIP_AMBIENCE,
	//"Enable instruments" = SOUND_INSTRUMENTS,
	"Enable lobby music" = SOUND_LOBBY,
))

DEFINE_BITFIELD(toggles_maptext, list(
	"Disable balloon alerts" = DISABLE_BALLOON_ALERTS,
	//"Disable hover text" = DISABLE_HOVER_TEXT,
	"Disable runechat" = DISABLE_RUNECHAT,
))
