/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}

/// Prepares text for maptext centered
#define MAPTEXT_CENTER(text) {"<span class='maptext center'>[##text]</span>"}

/// Large area entry maptext
#define MAPTEXT_BLACKMOOR(text) {"<span style='font-family: "Blackmoor LET"; font-size: 24pt; -dm-text-outline: 1px black'>[##text]</span>"}

/// Pixel maptext
#define MAPTEXT_PIXELIFY(text) {"<span style='font-family: "Pixelify Sans"; font-size: 8pt; -dm-text-outline: 1px black'>[##text]</span>"}

/// Pixel maptext
#define MAPTEXT_VATICANUS(text) {"<span style='font-family: "Vaticanus"; font-size: 8pt;'>[##text]</span>"}

/// Macro from Lummox used to get height from a MeasureText proc
#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (GLOB.filename_forbidden_chars.Replace(text, ""))

/// Simply removes the < and > characters, and limits the length of the message.
#define STRIP_HTML_SIMPLE(text, limit) (GLOB.angular_brackets.Replace(copytext(text, 1, limit), ""))

/// Removes everything enclose in < and > inclusive of the bracket, and limits the length of the message.
#define STRIP_HTML_FULL(text, limit) (GLOB.html_tags.Replace(copytext(text, 1, limit), ""))

#define SANITIZE_HEAR_MESSAGE(text) (GLOB.hearing_stripped_chars.Replace(text, ""))
