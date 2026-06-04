/*
 * Do not touch the values of these definitions
 * unless you are able to change them on the Elasticsearch engine as well.
 *
 * Hopefully, you know what you're doing.
 */

/* Categories */
	#define ELASCAT_GENERIC "generic"

	#define ELASCAT_COMBAT "combat"
	#define ELASCAT_CRAFTING "crafting"
	#define ELASCAT_ECONOMY "economy"
	#define ELASCAT_STORYTELLER "storyteller"
	#define ELASCAT_BALANCE "balance"
	#define ELASCAT_MEDICAL "medical"
	#define ELASCAT_ENCHANTING "enchanting"
	#define ELASCAT_HEARTBEAT "heartbeat"
	#define ELASCAT_ROUND "round"

/* Abstract Data */
	/* Combat */
		/// A mob has had its head dismembered.
		#define ELASDATA_DECAPITATIONS "decapitations"
		/// An animal mob has eaten a corpse.
		#define ELASDATA_EATEN_BODIES "eaten_bodies"
	/* Economy */
		#define ELASDATA_MAMMONS_GAINED "mammons_gained"
		#define ELASDATA_MAMMONS_SPENT "mammons_spent"
		#define ELASDATA_TAXES_EVADED "taxes_evaded"
		#define ELASDATA_TAXES_COLLECTED "taxes_collected"
		#define ELASDATA_WAGES_PAID "wages_paid"
		#define ELASDATA_FINE_INCOME "fine_income"
		#define ELASDATA_IMPORT_VALUE "import_value"
		#define ELASDATA_EXPORT_VALUE "export_value"
		#define ELASDATA_GOLDFACE_SPENT "goldface_spent"
		#define ELASDATA_NOBLE_INCOME "noble_income"
		#define ELASDATA_TRIUMPH_AWARDED "triumph_awarded"
		#define ELASDATA_TRIUMPH_SPENT "triumph_spent"

	/* Medical */
		#define ELASDATA_ANASTASIS_REVIVE "anastasis"
		#define ELASDATA_CPR_REVIVE "cpr"
		#define ELASDATA_ABSOLVE_REVIVE "absolve"
		#define ELASDATA_ULTIMATE_REVIVE "ultimate_sacrifice"
		#define ELASDATA_LUX_REVIVE "lux_revive"
		#define ELASDATA_LUX_EXTRACT "lux_extract_npc"
		#define ELASDATA_LUX_EXTRACT_PLAYER "lux_extract_player"
		/// An underworld spirit has been revived with a Toll.
		#define ELASDATA_COIN_REVIVES "coin_revive"
		/// An underworld spirit has won a pit fight.
		#define ELASDATA_FIGHT_REVIVES "fight_revives"
		#define ELASDATA_DEATH "deaths"
