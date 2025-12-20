#define FIRE_DAMAGE "fire"
#define LIGHTNING_DAMAGE "lightning"
#define COLD_DAMAGE "cold"

#define STATUS_KEY_BLEED "bleed chance"
#define STATUS_KEY_IGNITE "ignite chance"
#define STATUS_KEY_CHILL "chill chance"
#define STATUS_KEY_POISON "poison chance"

#define RECIPE_KEY "recipes"
#define PASSIVE_KEY "passives"
#define ABILITY_KEY "abilities"

#define GEM_CHIPPED 1
#define GEM_FLAWED 2
#define GEM_REGULAR 3
#define GEM_FLAWLESS 4
#define GEM_PERFECT 5

// Item slot types for gem effects
#define SLOT_WEAPON "weapon"
#define SLOT_ARMOR "armor"
#define SLOT_SHIELD "shield"

GLOBAL_LIST_INIT(gem_quality_names, list(
	"Chipped", // GEM_CHIPPED
	"Flawed", // GEM_FLAWED
	"", // GEM_REGULAR
	"Flawless", // GEM_FLAWLESS
	"Perfect" // GEM_PERFECT
))


#define DIRTY_SPLIT			(1<<0)
#define DIRTY_FORK		(1<<1)
#define DIRTY_EXTRA		(1<<2)

#define BOOST_TYPE_GENERAL 1
