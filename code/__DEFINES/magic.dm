// Magic schools

/// Unset / default / "not actually magic" school.
#define SCHOOL_UNSET "unset"

// GOOD SCHOOLS (allowed by honorbound gods, some of these you can get on station)
/// Holy school (chaplain magic)
#define SCHOOL_HOLY "holy"
/// Mime... school? Mime magic. It counts
#define SCHOOL_MIME "mime"
/// Restoration school, which is mostly healing stuff
#define SCHOOL_RESTORATION "restoration"

// NEUTRAL SPELLS (punished by honorbound gods if you get caught using it)
/// Evocation school, usually involves killing or destroy stuff, usually out of thin air
#define SCHOOL_EVOCATION "evocation"
/// School of transforming stuff into other stuff
#define SCHOOL_TRANSMUTATION "transmutation"
/// School of transolcation, usually movement spells
#define SCHOOL_TRANSLOCATION "translocation"
/// Conjuration spells summon items / mobs / etc somehow
#define SCHOOL_CONJURATION "conjuration"

// EVIL SPELLS (instant smite + banishment)
/// Necromancy spells, usually involves soul / evil / bad stuff
#define SCHOOL_NECROMANCY "necromancy"
/// Other forbidden magics, such as heretic spells
#define SCHOOL_FORBIDDEN "forbidden"

#define NO_MANA_POOL (1<<0)
#define MANA_POOL_FULL (1<<1)

#define MANA_POOL_TRANSFER_START (1<<2)
#define MANA_POOL_TRANSFER_STOP (1<<3)

#define MANA_POOL_ALREADY_TRANSFERRING (1<<4)
#define MANA_POOL_CANNOT_TRANSFER (1<<5)

#define MANA_POOL_TRANSFER_SKIP_ACTIVE (1<<6)

#define LEYLINE_BASE_RECHARGE 0.5 // Per second, we recharge this much man

#define MANA_CRYSTAL_BASE_HARDCAP 200
#define MANA_CRYSTAL_BASE_RECHARGE 0.001

#define BASE_MANA_CAPACITY 1000
#define MANA_CRYSTAL_BASE_MANA_CAPACITY (BASE_MANA_CAPACITY * 0.2)
#define CARBON_BASE_MANA_CAPACITY (BASE_MANA_CAPACITY)
#define LEYLINE_BASE_CAPACITY 600 //todo: standardize

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
#define BASE_LEYLINE_DONATION_RATE 30

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
#define MANA_ALL_LEYLINES (1 << 1)
/// Absorb from pylons with right click
#define MANA_ALL_PYLONS (1 << 2)
/// Absord from souls (if visible)
#define MANA_SOULS (1 <<3)

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
/// Holy magic resistance that blocks unholy magic (revenant, cult, vampire, voice of god)
#define MAGIC_RESISTANCE_UNHOLY (1 << 3)

DEFINE_BITFIELD(antimagic_flags, list(
	"MAGIC_RESISTANCE" = MAGIC_RESISTANCE,
	"MAGIC_RESISTANCE_HOLY" = MAGIC_RESISTANCE_HOLY,
	"MAGIC_RESISTANCE_MIND" = MAGIC_RESISTANCE_MIND,
))

// Spell types
/// Uses mana, normal behaviour
#define SPELL_MANA 1
/// Use stamina, all spells use stamina but this makes it the only cost and at full price instead of half
#define SPELL_STAMINA 2
/// Miracle, uses devotion and thus requires a devotion holder
#define SPELL_MIRACLE 3

/// Casted with the essence gauntlet, using essence vials
#define SPELL_ESSENCE 4
/// Casted using your bloodpool
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

DEFINE_BITFIELD(spell_requirements, list(
	"SPELL_CASTABLE_WITHOUT_INVOCATION" = SPELL_CASTABLE_WITHOUT_INVOCATION,
	"SPELL_CASTABLE_WHILE_PHASED" = SPELL_CASTABLE_WHILE_PHASED,
	"SPELL_REQUIRES_HUMAN" = SPELL_REQUIRES_HUMAN,
	"SPELL_REQUIRES_MIND" = SPELL_REQUIRES_MIND,
	"SPELL_REQUIRES_NO_ANTIMAGIC" = SPELL_REQUIRES_NO_ANTIMAGIC,
	"SPELL_REQUIRES_NO_MOVE" = SPELL_REQUIRES_NO_MOVE,
	"SPELL_REQUIRES_STATION" = SPELL_REQUIRES_STATION,
	"SPELL_REQUIRES_WIZARD_GARB" = SPELL_REQUIRES_WIZARD_GARB,
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

#define RAGE_LEVEL_LOW "25"
#define RAGE_LEVEL_MEDIUM "50"
#define RAGE_LEVEL_HIGH "75"
#define RAGE_LEVEL_CRITICAL "90"
