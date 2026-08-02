// Helpers for checking whether a z-level conforms to a specific requirement

// Basic levels
#define is_centcom_level(z) SSmapping.level_trait(z, ZTRAIT_CENTCOM)

#define is_town_level(z) SSmapping.level_trait(z, ZTRAIT_TOWN)

#define is_reserved_level(z) SSmapping.level_trait(z, ZTRAIT_RESERVED)
