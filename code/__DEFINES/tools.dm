// Tool types
#define TOOL_NONE			"none" //exclusively used for surgery validation
#define TOOL_HAND			"hand" //exclusively used for surgery validation
#define TOOL_SHARP			"sharp implement"	//exclusively used for surgery validation
#define TOOL_HOT			"hot implement" //exclusively used for surgery validation
#define TOOL_CROWBAR 		"crowbar"
#define TOOL_MULTITOOL 		"multitool"
#define TOOL_SCREWDRIVER 	"screwdriver"
#define TOOL_WIRECUTTER 	"wirecutter"
#define TOOL_WRENCH 		"wrench"
#define TOOL_WELDER 		"welder"
#define TOOL_ANALYZER		"analyzer"
#define TOOL_MINING			"mining"
#define TOOL_SHOVEL			"shovel"
#define TOOL_RETRACTOR	 	"retractor"
#define TOOL_HEMOSTAT 		"hemostat"
#define TOOL_CAUTERY 		"cautery"
#define TOOL_DRILL			"drill"
#define TOOL_SCALPEL		"scalpel"
#define TOOL_SAW			"saw"
#define TOOL_BONESETTER		"bonesetter"
#define TOOL_SUTURE			"suture"
#define TOOL_IMPROVISED_RETRACTOR "improvised_retractor"
#define TOOL_IMPROVISED_HEMOSTAT "improvised_hemostat"
#define TOOL_IMPROVISED_SAW	"improvsaw"

// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20


#define TOOL_USAGE_TONGS (1<<0)
