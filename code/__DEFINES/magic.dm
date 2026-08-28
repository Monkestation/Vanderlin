#define NO_MANA_POOL (1<<0)
#define MANA_POOL_FULL (1<<1)

#define MANA_POOL_TRANSFER_START (1<<2)
#define MANA_POOL_TRANSFER_STOP (1<<3)

#define MANA_POOL_ALREADY_TRANSFERRING (1<<4)
#define MANA_POOL_CANNOT_TRANSFER (1<<5)

#define MANA_POOL_TRANSFER_SKIP_ACTIVE (1<<6)

#define LEYLINE_BASE_RECHARGE 8 // Per second, we recharge this much man

#define MANA_CRYSTAL_BASE_HARDCAP 200
#define MANA_CRYSTAL_BASE_RECHARGE 0.001

#define BASE_MANA_CAPACITY 1000
#define MANA_CRYSTAL_BASE_MANA_CAPACITY (BASE_MANA_CAPACITY * 0.2)
#define CARBON_BASE_MANA_CAPACITY (BASE_MANA_CAPACITY)
#define LEYLINE_BASE_CAPACITY 1200 //todo: standardize

#define BASE_MANA_SOFTCAP (BASE_MANA_CAPACITY * 0.2) //20 percent
#define BASE_MANA_CRYSTAL_SOFTCAP  MANA_CRYSTAL_BASE_MANA_CAPACITY
#define BASE_CARBON_MANA_SOFTCAP (CARBON_BASE_MANA_CAPACITY * 0.2)

#define BASE_MANA_OVERLOAD_THRESHOLD (BASE_MANA_CAPACITY * 0.9)
#define MANA_CRYSTAL_OVERLOAD_THRESHOLD MANA_CRYSTAL_BASE_MANA_CAPACITY
#define CARBON_MANA_OVERLOAD_THRESHOLD BASE_CARBON_MANA_SOFTCAP

#define BASE_MANA_OVERLOAD_COEFFICIENT 5
#define MANA_CRYSTAL_OVERLOAD_COEFFICIENT 0.1
#define CARBON_MANA_OVERLOAD_COEFFICIENT 5

#define MANA_OVERLOAD_DAMAGE_THRESHOLD 2
#define MANA_OVERLOAD_BASE_DAMAGE 10

// inverse - higher numbers decrease the intensity of the decay
#define BASE_MANA_EXPONENTIAL_DIVISOR 60 // careful with this value - low numbers will cause some fuckery
#define BASE_CARBON_MANA_EXPONENTIAL_DIVISOR (BASE_MANA_EXPONENTIAL_DIVISOR * 0.5)
#define MANA_CRYSTAL_BASE_DECAY_DIVISOR (BASE_MANA_EXPONENTIAL_DIVISOR * 5)

// in mana per second
#define BASE_MANA_DONATION_RATE (BASE_MANA_CAPACITY * 0.5)
#define BASE_MANA_CRYSTAL_DONATION_RATE (BASE_MANA_DONATION_RATE * 0.1)
#define BASE_LEYLINE_DONATION_RATE 60

#define MANA_BATTERY_MAX_TRANSFER_DISTANCE 3

#define MAGIC_MATERIAL_NAME "Primordial Quartz"
#define MAGIC_UNIT_OF_MEASUREMENT "Mana"
#define MAGIC_UNIT_OF_MAGNITUDE "TP" // Thaumatergic Potential
#define STORY_MAGIC_BASE_CONSUME_SCORE 50
#define THAUMATERGIC_SENSE_POOL_DISCERNMENT_LEVEL_ZERO 0
#define THAUMATERGIC_SENSE_POOL_DISCERNMENT_LEVEL_ONE 1
#define THAUMATERGIC_SENSE_POOL_DISCERNMENT_LEVEL_TWO 2

// MAGIC TRAITS GO HERE
// give this to an object to declare that its pool can be used during cast.
#define TRAIT_POOL_AVAILABLE_FOR_CAST "pool_available_for_cast"

#define COMSIG_MANA_POOL_INTRINSIC_RECHARGE_UPDATE "mana_pool_intrinsic_recharge_update"
#define COMSIG_ATOM_MANA_POOL_CHANGED "atom_mana_pool_changed"
#define COMSIG_MANA_POOL_ADJUSTED "mana_pool_adjusted"

// Mana source flags
/// Absorb from leylines
#define MANA_ALL_LEYLINES (1 << 0)
/// Absorb from pylons with right click
#define MANA_ALL_PYLONS (1 << 1)
/// Absord from souls (if visible)
#define MANA_SOULS (1 << 2)

DEFINE_BITFIELD(intrinsic_recharge_sources, list(
	"MANA_ALL_LEYLINES" = MANA_ALL_LEYLINES,
	"MANA_ALL_PYLONS" = MANA_ALL_PYLONS,
	"MANA_SOULS" = MANA_SOULS,
))

#define MANA_DISPERSE_EVENLY 1
#define MANA_SEQUENTIAL 2

#define MANA_POOL_SKIP_NEXT_TRANSFER (1 << 0)
#define MANA_POOL_INTRINSIC (1 << 1)

// Invocation types - what does the wizard need to do to invoke (cast) the spell?
/// Allows being able to cast the spell without saying or doing anything.
#define INVOCATION_NONE "none"
/// Forces the wizard to shout the invocation to cast the spell.
#define INVOCATION_SHOUT "shout"
/// Forces the wizard to whisper the invocation to cast the spell.
#define INVOCATION_WHISPER "whisper"
/// Forces the wizard to emote to cast the spell.
#define INVOCATION_EMOTE "emote"

// Bitflags for teleport spells
/// Whether the teleport spell skips over space turfs
#define TELEPORT_SPELL_SKIP_SPACE (1 << 0)
/// Whether the teleport spell skips over dense turfs
#define TELEPORT_SPELL_SKIP_DENSE (1 << 1)
/// Whether the teleport spell skips over blocked turfs
#define TELEPORT_SPELL_SKIP_BLOCKED (1 << 2)

/// Default magic resistance that blocks normal magic (wizard, spells, magical staff projectiles)
#define MAGIC_RESISTANCE (1 << 0)
/// Tinfoil hat magic resistance that blocks mental magic (telepathy, mind curses, abductors, jelly people)
#define MAGIC_RESISTANCE_MIND (1 << 1)
/// Holy magic resistance that blocks miracles
#define MAGIC_RESISTANCE_HOLY (1 << 2)
/// Holy magic resistance that blocks unholy magic (revenant, cult, voice of god)
#define MAGIC_RESISTANCE_UNHOLY (1 << 3)
/// Magic resistance that blocks vampiric magic and blood spells.
#define MAGIC_RESISTANCE_BLOOD (1 << 4)

DEFINE_BITFIELD(antimagic_flags, list(
	"MAGIC_RESISTANCE" = MAGIC_RESISTANCE,
	"MAGIC_RESISTANCE_HOLY" = MAGIC_RESISTANCE_HOLY,
	"MAGIC_RESISTANCE_MIND" = MAGIC_RESISTANCE_MIND,
	"MAGIC_RESISTANCE_UNHOLY" = MAGIC_RESISTANCE_UNHOLY,
	"MAGIC_RESISTANCE_BLOOD" = MAGIC_RESISTANCE_BLOOD,
))

// Spell types
/// Uses mana, normal behaviour
#define SPELL_MANA 1
/// Use stamina, all spells use stamina but this makes it the only cost and at full price instead of half
#define SPELL_STAMINA 2
/// Miracle, uses devotion and thus requires a devotion holder
#define SPELL_MIRACLE 3
/// Cast with the essence gauntlet, using essence vials
#define SPELL_ESSENCE 4
/// Cast using your bloodpool
#define SPELL_BLOOD 5
///this is a "miracle" granted by "psydon's" inquisition
#define SPELL_PSYDONIC_MIRACLE 6
///this is a spell that uses rage to cast
#define SPELL_RAGE 7


// Generic Bitflags for spells
/// Ignore the trait [TRAIT_SPELLBLOCK]
#define SPELL_IGNORE_SPELLBLOCK (1 << 0)

/// Is learnable via Rituos
#define SPELL_RITUOS (1 << 1)

#define SPELL_PSYDON (1 << 2)

#define SPELL_TEMPORARY (1 << 3)

#define SPELL_UNETCHABLE (1 << 4)

// Bitflags for spell requirements
/// Whether the spell requires wizard clothes to cast.
#define SPELL_REQUIRES_WIZARD_GARB (1 << 0)
/// Whether the spell can only be cast by humans (mob type, not species).
/// SPELL_REQUIRES_WIZARD_GARB comes with this flag implied, as carbons and below can't wear clothes.
#define SPELL_REQUIRES_HUMAN (1 << 1)
/// Whether the spell can be cast while phased, such as blood crawling, ethereal jaunting or using rod form.
#define SPELL_CASTABLE_WHILE_PHASED (1 << 2)
/// Whether the spell can be cast while the user has antimagic on them that corresponds to the spell's own antimagic flags.
#define SPELL_REQUIRES_NO_ANTIMAGIC (1 << 3)
/// Whether the spell requires being on the station z-level to be cast.
#define SPELL_REQUIRES_STATION (1 << 4)
/// Whether the spell must be cast by someone with a mind datum.
#define SPELL_REQUIRES_MIND (1 << 5)
/// Whether the spell can be cast, even if the caster is unable to speak the invocation
/// (effectively making the invocation flavor, instead of required).
#define SPELL_CASTABLE_WITHOUT_INVOCATION (1 << 6)
/// If the spell requires the user to not move during casting
#define SPELL_REQUIRES_NO_MOVE (1 << 7)
/// Whether the spell requires the target to be on the same Z-level as the caster.
#define SPELL_REQUIRES_SAME_Z (1 << 8)
/// Whether the spell can be cast while buckled to a living mount (on horseback).
#define SPELL_CASTABLE_WHILE_MOUNTED (1 << 9)

DEFINE_BITFIELD(spell_requirements, list(
	"SPELL_CASTABLE_WITHOUT_INVOCATION" = SPELL_CASTABLE_WITHOUT_INVOCATION,
	"SPELL_CASTABLE_WHILE_PHASED" = SPELL_CASTABLE_WHILE_PHASED,
	"SPELL_REQUIRES_HUMAN" = SPELL_REQUIRES_HUMAN,
	"SPELL_REQUIRES_MIND" = SPELL_REQUIRES_MIND,
	"SPELL_REQUIRES_NO_ANTIMAGIC" = SPELL_REQUIRES_NO_ANTIMAGIC,
	"SPELL_REQUIRES_NO_MOVE" = SPELL_REQUIRES_NO_MOVE,
	"SPELL_REQUIRES_STATION" = SPELL_REQUIRES_STATION,
	"SPELL_REQUIRES_WIZARD_GARB" = SPELL_REQUIRES_WIZARD_GARB,
	"SPELL_REQUIRES_SAME_Z" = SPELL_REQUIRES_SAME_Z,
	"SPELL_CASTABLE_WHILE_MOUNTED" = SPELL_CASTABLE_WHILE_MOUNTED,
))

/**
 * Checks if our mob is jaunting actively (within a phased mob object)
 * Used in jaunting spells specifically to determine whether they should be entering or exiting jaunt
 *
 * If you want to use this in non-jaunt related code, it is preferable
 * to instead check for trait [TRAIT_MAGICALLY_PHASED] instead of using this
 * as it encompasses more states in which a mob may be "incorporeal from magic"
 */
#define is_jaunting(atom) (istype(atom.loc, /obj/effect/dummy/phased_mob))

/// When set, the item hijacks afterattack and fires a spell via diceroll
/// rather than passively granting spells to the holder.
#define SPELLOBJECT_HIJACK_CLICK (1<<0)
/// When set (alongside HIJACK_CLICK), aim-failure picks a random nearby mob
/// instead of always backfiring onto the user, and spell names are obscured in examine.
#define SPELLOBJECT_CHAOTIC (1<<1)
/// When set, the item deletes itself when all spell charges are exhausted
#define SPELLOBJECT_CONSUMABLE (1<<2)
/// If set update overlays adds a small version to the object
#define SPELLOBJECT_VISUAL (1<<3)
/// If set we will always fire true
#define SPELLOBJECT_STABLE (1<<4)

/// Diceroll requirement at each arcane skill tier for aimed-fire
/// Lower = easier to hit the intended target (roll-under system)
#define SPELLOBJECT_AIM_REQ_NONE 6
#define SPELLOBJECT_AIM_REQ_NOVICE 9
#define SPELLOBJECT_AIM_REQ_APPRENTICE 11
#define SPELLOBJECT_AIM_REQ_JOURNEYMAN 13
#define SPELLOBJECT_AIM_REQ_EXPERT 15
#define SPELLOBJECT_AIM_REQ_MASTER 16
#define SPELLOBJECT_AIM_REQ_LEGENDARY 17

#define TECHNIQUE_DESTRUCTION "Destruction"
#define TECHNIQUE_CREATION "Creation"
#define TECHNIQUE_SUMMONING "Summoning"
#define TECHNIQUE_RESTORATION "Restoration"
#define TECHNIQUE_ALTERATION "Alteration"
#define TECHNIQUE_ILLUSION "Illusion"
#define TECHNIQUE_IMBUE "Imbue"

#define FORM_FIRE "Fire"
#define FORM_ICE "Ice"
#define FORM_LIGHTNING "Lightning"
#define FORM_EARTH "Earth"
#define FORM_ARCANE "Arcane"
#define FORM_DEATH "Death"
#define FORM_LIFE "Life"
#define FORM_AIR "Aeromancy"
#define FORM_WATER "Hydromancy"
#define FORM_BLOOD "Hemomancy"

#define MASTERY_RANK_NOVICE 0
#define MASTERY_RANK_ADEPT 2
#define MASTERY_RANK_EXPERT 4
#define MASTERY_RANK_MASTER 6

GLOBAL_LIST_INIT(mastery_rank_names, list(
	"[MASTERY_RANK_NOVICE]" = "Novice",
	"[MASTERY_RANK_ADEPT]" = "Adept",
	"[MASTERY_RANK_EXPERT]" = "Expert",
	"[MASTERY_RANK_MASTER]" = "Master",
))

GLOBAL_LIST_INIT(form_colors, list(
	FORM_FIRE = "#FF4500",
	FORM_ICE = "#00BFFF",
	FORM_LIGHTNING = "#FFD700",
	FORM_WATER = "#00158b",
	FORM_LIFE = "#32CD32",
	FORM_DEATH = "#800080",
	FORM_EARTH = "#8B4513",
	FORM_AIR = "#C0C0C0",
	FORM_ARCANE = "#9932CC",
	FORM_BLOOD = COLOR_BLOOD_MAGIC
))

GLOBAL_LIST_INIT(all_techniques, list(
	TECHNIQUE_DESTRUCTION,
	TECHNIQUE_CREATION,
	TECHNIQUE_SUMMONING,
	TECHNIQUE_RESTORATION,
	TECHNIQUE_ALTERATION,
	TECHNIQUE_ILLUSION,
	TECHNIQUE_IMBUE,
))

GLOBAL_LIST_INIT(all_forms, list(
	FORM_FIRE,
	FORM_ICE,
	FORM_LIGHTNING,
	FORM_EARTH,
	FORM_ARCANE,
	FORM_LIFE,
	FORM_DEATH,
	FORM_AIR,
	FORM_WATER,
	FORM_BLOOD,
))

#define CHARGETIME_POKE 0.5 SECONDS // Staple poke spells
#define CHARGETIME_MINOR 1 SECONDS // Minor utility / support spells
#define CHARGETIME_MAJOR 1.5 SECONDS // Major projectiles
#define CHARGETIME_HEAVY 2 SECONDS // Heavy AOE / ultimates
#define CHARGETIME_BARRAGE 3 SECONDS // Barrage / Channeled spells

#define CHARGING_SLOWDOWN_NONE 0
#define CHARGING_SLOWDOWN_SMALL 1
#define CHARGING_SLOWDOWN_MEDIUM 2
#define CHARGING_SLOWDOWN_HEAVY 3

#define SPELL_RANGE_PROJECTILE 10 // Standard projectile travel distance and projectile spell cast range
#define SPELL_RANGE_GROUND 7 // Standard ground-targeted / AOE spell cast range
#define SPELL_RANGE_TWO_SCREENS 14 // Two screens away for very very special spells
#define SPELL_RANGE_AURA 4 // For 'warcry' type miracles or AOE BUFFS originating on the caster
#define SPELL_RANGE_ADJACENT 1 // Self explanatory

#define SPELL_IMPACT_NONE 0
#define SPELL_IMPACT_LOW 1
#define SPELL_IMPACT_MEDIUM 2
#define SPELL_IMPACT_HIGH 3

#define CONJURE_RECOIL_LIGHT 0
#define CONJURE_RECOIL_PARTIAL 1
#define CONJURE_RECOIL_FULL 2

#define SPELLBOOK_THEME_BASELINE_QUALITY 6
#define SPELLBOOK_THEME_BASELINE_FORM_POINTS 7
#define SPELLBOOK_THEME_BASELINE_TECHNIQUE_POINTS 3

#define SPELLMOD_COST "cost"
#define SPELLMOD_CASTSPEED "castSpeed"
#define SPELLMOD_MAGNITUDE "magnitude"
