
/// Used by the examine pronoun list as keys.
#define THEY		"they"
#define THEM		"them"
#define THEIR		"their"
#define HAVE		"have"
#define ARE			"are"
#define THEYRE		"theyre"
#define THEYVE		"theyve"

/**
 * These are used to establish an indexing format for examine sections.
 * EXAMINE_SECTS are just numbers, so they can only be used in alists
 */
#define EXAMINE_SECT_NAME		1 // The name/title. Maybe don't use this line?
#define EXAMINE_SECT_SPECIES	2 // The species line. Gets combined into a single string.
#define EXAMINE_SECT_FACE		3 // The face line. Usually stuff that only shows up from their face.
#define EXAMINE_SECT_PREGEAR	4 // Misc things before gear, used by antags a lot.
#define EXAMINE_SECT_GEAR		5 // Equipment box
#define EXAMINE_SECT_BODY		6 // Sort of like face, but always shows up. Based on physical stuff.
#define EXAMINE_SECT_WARNING	7 // Things to inform the player of, e.g. whether they're soaked.
#define EXAMINE_SECT_HEALTH		8 // Things pertinent to health. Like whether you're bleeding or missing a limb.
#define EXAMINE_SECT_LAST		9 // Things you wanna cram at the very end.
#define EXAMINE_SECT_HEADSHOT	10 // The headshot / examine closer buttons.
// If you add anything past this, the character won't be the only relevant headshot

// used for weird cases with variable honorary titles to determine their position
#define HONORARY_PREFIX 0
#define HONORARY_SUFFIX 1

// Heresy severity colors
#define COLOR_HERESYSEVERITY_ALARMING "#c43535"
#define COLOR_HERESYSEVERITY_SUSPICIOUS "#c49337"
#define COLOR_HERESYSEVERITY_ODD "#c564c5"
#define COLOR_HERESYSEVERITY_VERYODD "#c564c5"

//Other Colors
#define COLOR_VIBE_FRIEND "#6476c5"
#define COLOR_VIBE_FOE "#c43535"
#define COLOR_VIBE_CROWN "#ffdc7c"
#define COLOR_VIBE_GOLGATHA "#94f8ff"

// Heresy severity symbols
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_SUSPICIOUS "!"
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_VERYODD "!"
/// Zcross unicode in HTML form
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ALARMING "&#x16E3;"
#define EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ODD "?"

#define SYMBOL_VIBE_FRIEND "&#x26E8;"
#define SYMBOL_VIBE_FOE "&#x2694;"
#define SYMBOL_VIBE_CROWN "&#x2654;"
#define SYMBOL_VIBE_GOLGATHA "&#5833;"
