// This is eventually for wjohn to add more color standardization stuff like I keep asking him >:(
#define COLOR_BLOOD "#c90000"

#define COLOR_INPUT_DISABLED "#000000"
#define COLOR_INPUT_ENABLED "#231d1d"

#define COLOR_DARKMODE_BACKGROUND "#202020"
#define COLOR_DARKMODE_DARKBACKGROUND "#171717"
#define COLOR_DARKMODE_TEXT "#a4bad6"

#define COLOR_WHITE            "#EEEEEE"
#define COLOR_SILVER           "#C0C0C0"
#define COLOR_GRAY             "#808080"
#define COLOR_FLOORTILE_GRAY   "#8D8B8B"
#define COLOR_ALMOST_BLACK	   "#333333"
#define COLOR_BLACK            "#000000"
#define COLOR_RED              "#FF0000"
#define COLOR_RED_LIGHT        "#FF3333"
#define COLOR_MAROON           "#800000"
#define COLOR_YELLOW           "#FFFF00"
#define COLOR_OLIVE            "#808000"
#define COLOR_LIME             "#32CD32"
#define COLOR_GREEN            "#008000"
#define COLOR_CYAN             "#00FFFF"
#define COLOR_TEAL             "#008080"
#define COLOR_BLUE             "#0000FF"
#define COLOR_BLUE_LIGHT       "#33CCFF"
#define COLOR_NAVY             "#000080"
#define COLOR_PINK             "#FFC0CB"
#define COLOR_MAGENTA          "#FF00FF"
#define COLOR_PURPLE           "#800080"
#define COLOR_ORANGE           "#FF9900"
#define COLOR_BEIGE            "#CEB689"
#define COLOR_BLUE_GRAY        "#75A2BB"
#define COLOR_BROWN            "#BA9F6D"
#define COLOR_DARK_BROWN       "#997C4F"
#define COLOR_DARK_ORANGE      "#C3630C"
#define COLOR_GREEN_GRAY       "#99BB76"
#define COLOR_RED_GRAY         "#B4696A"
#define COLOR_PALE_BLUE_GRAY   "#98C5DF"
#define COLOR_PALE_GREEN_GRAY  "#B7D993"
#define COLOR_PALE_RED_GRAY    "#D59998"
#define COLOR_PALE_PURPLE_GRAY "#CBB1CA"
#define COLOR_PURPLE_GRAY      "#AE8CA8"

//Color defines used by the assembly detailer.
#define COLOR_ASSEMBLY_BLACK   "#545454"
#define COLOR_ASSEMBLY_BGRAY   "#9497AB"
#define COLOR_ASSEMBLY_WHITE   "#E2E2E2"
#define COLOR_ASSEMBLY_RED     "#CC4242"
#define COLOR_ASSEMBLY_ORANGE  "#E39751"
#define COLOR_ASSEMBLY_BEIGE   "#AF9366"
#define COLOR_ASSEMBLY_BROWN   "#97670E"
#define COLOR_ASSEMBLY_GOLD    "#AA9100"
#define COLOR_ASSEMBLY_YELLOW  "#CECA2B"
#define COLOR_ASSEMBLY_GURKHA  "#999875"
#define COLOR_ASSEMBLY_LGREEN  "#789876"
#define COLOR_ASSEMBLY_GREEN   "#44843C"
#define COLOR_ASSEMBLY_LBLUE   "#5D99BE"
#define COLOR_ASSEMBLY_BLUE    "#38559E"
#define COLOR_ASSEMBLY_PURPLE  "#6F6192"


//roguetown
// Expensive dyes ==========================
#define CLOTHING_DARK_INK "#392f2f"
#define CLOTHING_PLUM_PURPLE "#4b3c54"
#define CLOTHING_SALMON	 "#70545e"
#define CLOTHING_BLOOD_RED "#763434"
#define CLOTHING_OCEAN "#45749d"
#define CLOTHING_SWAMPWEED "#00713d"

#define CLOTHING_MAROON	 "#533727"
#define CLOTHING_RED_OCHRE "#913831"
#define CLOTHING_RUSSET	 "#80461B"
#define CLOTHING_MUSTARD_YELLOW "#E1AD01"
#define CLOTHING_YELLOW_OCHRE "#685e3b"
#define CLOTHING_FOREST_GREEN "#45553f"
#define CLOTHING_SKY_BLUE "#40445f"
#define CLOTHING_MAGE_BLUE "#454fa6"
#define CLOTHING_MAGE_GREEN "#60794a"
#define CLOTHING_MAGE_ORANGE "#935329"
#define CLOTHING_MAGE_YELLOW "#a79730"

// Royal dyes ==========================
#define CLOTHING_ROYAL_RED "#813434"
#define CLOTHING_ROYAL_MAJENTA "#822b52"
#define CLOTHING_FYRITIUS_ORANGE "#9b7540"
#define CLOTHING_ROYAL_PURPLE "#865c9c"
#define CLOTHING_BARK_BROWN "#685542"
#define CLOTHING_ROYAL_BLACK "#2f352f"
#define CLOTHING_BOG_GREEN "#4f693b"
#define CLOTHING_ROYAL_TEAL "#3b817a"
#define CLOTHING_PEAR_YELLOW "#a19f52"
#define CLOTHING_CHALK_WHITE "#c7c0b5"

// Cheap dyes ==========================
#define CLOTHING_SOOT_BLACK "#414145"
#define CLOTHING_WINESTAIN_RED "#673c3c"
#define CLOTHING_PEASANT_BROWN "#634f44"
#define CLOTHING_MUD_BROWN "#6f5f4d"
#define CLOTHING_CHESTNUT "#604631"
#define CLOTHING_OLD_LEATHER "#473f39"
#define CLOTHING_SPRING_GREEN "#41493a"
#define CLOTHING_BERRY_BLUE "#39404d"
#define CLOTHING_TARAXACUM_YELLOW "#63673c"

#define CLOTHING_ASH_GREY "#676262"
#define CLOTHING_CANVAS "#858564"
#define CLOTHING_LINEN "#a1a17a"
#define CLOTHING_WHITE "#ffffff"
#define CLOTHING_WET "#afafaf"

/// Deprecated macro, should be removed
#define CLOTHING_COLOR_NAMES	list("Ash Grey","Chalk White","Cream","White","Dark Ink","Plum Purple","Salmon","Blood Red", "Maroon","Red Ochre","Russet","Chestnut","Mustard Yellow","Yellow Ochre","Forest Green","Sky Blue","Teal", "Royal Black","Soot Black","Winestain Red","Royal Red","Royal Majenta","Fyritius Orange","Bark Brown","Peasant Brown","Mud Brown","Pear Yellow","Spring Green","Bog Green","Royal Teal","Berry Blue", "Royal Blue", "Royal Purple","Dunked in Water" )

/proc/clothing_color2hex(input)
	var/static/list/all_colors = GLOB.peasant_dyes + GLOB.noble_dyes + GLOB.royal_dyes
	return all_colors[input]

#define CM_COLOR_SAT_MIN 0.6
#define CM_COLOR_SAT_MAX 0.7
#define CM_COLOR_LUM_MIN 0.65
#define CM_COLOR_LUM_MAX 0.75


/**
 * Gets a color for a name, will return the same color for a given string consistently within a round.atom
 *
 * Note that this proc aims to produce pastel-ish colors using the HSL colorspace. These seem to be favorable for displaying on the map.
 *
 * Arguments:
 * * name - The name to generate a color for
 * * sat_shift - A value between 0 and 1 that will be multiplied against the saturation
 * * lum_shift - A value between 0 and 1 that will be multiplied against the luminescence
 */
/proc/colorize_string(name, sat_shift = 1, lum_shift = 1)
	// seed to help randomness
	var/static/rseed = rand(1,26)

	// get hsl using the selected 6 characters of the md5 hash
	var/hash = copytext(md5(name + GLOB.round_id), rseed, rseed + 6)
	var/h = hex2num(copytext(hash, 1, 3)) * (360 / 255)
	var/s = (hex2num(copytext(hash, 3, 5)) >> 2) * ((CM_COLOR_SAT_MAX - CM_COLOR_SAT_MIN) / 63) + CM_COLOR_SAT_MIN
	var/l = (hex2num(copytext(hash, 5, 7)) >> 2) * ((CM_COLOR_LUM_MAX - CM_COLOR_LUM_MIN) / 63) + CM_COLOR_LUM_MIN

	// adjust for shifts
	s = clamp(s * sat_shift, 0, 1)
	l = clamp(l * lum_shift, 0, 1)

	// convert to rgb
	var/h_int = round(h/60) // mapping each section of H to 60 degree sections
	var/c = (1 - abs(2 * l - 1)) * s
	var/x = c * (1 - abs((h / 60) % 2 - 1))
	var/m = l - c * 0.5
	x = (x + m) * 255
	c = (c + m) * 255
	m *= 255
	switch(h_int)
		if(0)
			return "#[num2hex(c, 2)][num2hex(x, 2)][num2hex(m, 2)]"
		if(1)
			return "#[num2hex(x, 2)][num2hex(c, 2)][num2hex(m, 2)]"
		if(2)
			return "#[num2hex(m, 2)][num2hex(c, 2)][num2hex(x, 2)]"
		if(3)
			return "#[num2hex(m, 2)][num2hex(x, 2)][num2hex(c, 2)]"
		if(4)
			return "#[num2hex(x, 2)][num2hex(m, 2)][num2hex(c, 2)]"
		if(5)
			return "#[num2hex(c, 2)][num2hex(m, 2)][num2hex(x, 2)]"
