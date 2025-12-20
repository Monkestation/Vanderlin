/*ALL MOB-RELATED DEFINES THAT DON'T BELONG IN ANOTHER FILE GO HERE*/

#define STATKEY_STR "strength"
#define STATKEY_PER "perception"
#define STATKEY_INT "intelligence"
#define STATKEY_CON "constitution"
#define STATKEY_END "endurance"
#define STATKEY_SPD "speed"
#define STATKEY_LCK "fortune"

#define MOBSTATS list(STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_CON, STATKEY_END, STATKEY_SPD, STATKEY_LCK)

//Misc mob defines

//for vision cone
#define FOV_DEFAULT 	           	(1<<0)
#define FOV_RIGHT 	            	(1<<1)
#define FOV_LEFT 	            	(1<<2)
#define FOV_BEHIND 	 	          	(1<<3) //180

//Ready states at roundstart for mob/dead/new_player
#define PLAYER_NOT_READY 0
#define PLAYER_READY_TO_PLAY 1

//movement intent defines for the m_intent var
#define MOVE_INTENT_WALK "walk"
#define MOVE_INTENT_RUN  "run"
#define MOVE_INTENT_SNEAK "sneak"

//resist
#define RESIST_INTENT 0
#define SUBMIT_INTENT 1

//Blood levels
#define BLOOD_VOLUME_MAXIMUM 2240
#define BLOOD_VOLUME_SLIME_SPLIT 1120
#define BLOOD_VOLUME_NORMAL 1120
#define BLOOD_VOLUME_SAFE 950
#define BLOOD_VOLUME_OKAY 672
#define BLOOD_VOLUME_BAD 448
#define BLOOD_VOLUME_SURVIVE 244

//Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 0
#define MOB_SIZE_SMALL 1
#define MOB_SIZE_HUMAN 2
#define MOB_SIZE_LARGE 3

//Ventcrawling defines
#define VENTCRAWLER_NONE   0
#define VENTCRAWLER_NUDE   1
#define VENTCRAWLER_ALWAYS 2

//Bloodcrawling defines
#define BLOODCRAWL 1
#define BLOODCRAWL_EAT 2

//Mob bio-types flags
#define MOB_ORGANIC 	(1<<0)
#define MOB_MINERAL		(1<<1)
#define MOB_ROBOTIC 	(1<<2)
#define MOB_UNDEAD		(1<<3)
#define MOB_HUMANOID 	(1<<4)
#define MOB_BUG 		(1<<5)
#define MOB_BEAST		(1<<6)
#define MOB_EPIC		(1<<7) //megafauna
#define MOB_REPTILE		(1<<8)
#define MOB_SPIRIT		(1<<9)

//Organ defines for carbon mobs
#define CHRONIC_ARTHRITIS 1
#define CHRONIC_NERVE_DAMAGE 2
#define CHRONIC_OLD_FRACTURE 3
#define CHRONIC_SCAR_TISSUE 4

#define ORGAN_ORGANIC   1
#define ORGAN_ROBOTIC   2

#define BODYPART_ORGANIC   1
#define BODYPART_ROBOTIC   2

#define BODYPART_NOT_DISABLED 0
#define BODYPART_DISABLED_DAMAGE 1
#define BODYPART_DISABLED_PARALYSIS 2 //either a fall or twisting the limb
#define BODYPART_DISABLED_WOUND 3 //bone fracture
#define BODYPART_DISABLED_ROT 4 //limb is rotten oh nooo
#define BODYPART_DISABLED_CLAMPED 5 //limb is clamped by a hemostat or speculum

#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/human_parts_greyscale.dmi'

#define MONKEY_BODYPART "monkey"
#define DEVIL_BODYPART "devil"
/*see __DEFINES/inventory.dm for bodypart bitflag defines*/

// Health/damage defines for carbon mobs
#define HUMAN_MAX_OXYLOSS 3
#define HUMAN_CRIT_MAX_OXYLOSS (SSmobs.wait/30)

#define HEAT_DAMAGE_LEVEL_1 0 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 0.1 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 0.2 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 0.1 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 0.2 //Amount of damage applied when your body temperature passes the 120K point


//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 1 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 1 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 1 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 20
#define BRAIN_DAMAGE_SEVERE 100
#define BRAIN_DAMAGE_DEATH 200

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special
#define BRAIN_TRAUMA_MAGIC /datum/brain_trauma/magic

#define TRAUMA_RESILIENCE_BASIC 1      //Curable with chems
#define TRAUMA_RESILIENCE_SURGERY 2    //Curable with brain surgery
#define TRAUMA_RESILIENCE_LOBOTOMY 3   //Curable with lobotomy
#define TRAUMA_RESILIENCE_MAGIC 4      //Curable only with magic
#define TRAUMA_RESILIENCE_ABSOLUTE 5   //This is here to stay

//Limit of traumas for each resilience tier
#define TRAUMA_LIMIT_BASIC 3
#define TRAUMA_LIMIT_SURGERY 2
#define TRAUMA_LIMIT_LOBOTOMY 3
#define TRAUMA_LIMIT_MAGIC 3
#define TRAUMA_LIMIT_ABSOLUTE INFINITY

#define BRAIN_DAMAGE_INTEGRITY_MULTIPLIER 0.5

//Surgery Defines
#define BIOWARE_GENERIC "generic"
#define BIOWARE_NERVES "nerves"
#define BIOWARE_CIRCULATION "circulation"
#define BIOWARE_LIGAMENTS "ligaments"

//Health hud screws for carbon mobs
#define SCREWYHUD_NONE 0
#define SCREWYHUD_CRIT 1
#define SCREWYHUD_DEAD 2
#define SCREWYHUD_HEALTHY 3

//Threshold levels for beauty for humans
#define BEAUTY_LEVEL_HORRID -66
#define BEAUTY_LEVEL_BAD -33
#define BEAUTY_LEVEL_DECENT 33
#define BEAUTY_LEVEL_GOOD 66
#define BEAUTY_LEVEL_GREAT 100

//Moods levels for humans
#define MOOD_LEVEL_HAPPY4 15
#define MOOD_LEVEL_HAPPY3 10
#define MOOD_LEVEL_HAPPY2 6
#define MOOD_LEVEL_HAPPY1 2
#define MOOD_LEVEL_NEUTRAL 0
#define MOOD_LEVEL_SAD1 -3
#define MOOD_LEVEL_SAD2 -7
#define MOOD_LEVEL_SAD3 -15
#define MOOD_LEVEL_SAD4 -20

//Sanity levels for humans
#define SANITY_MAXIMUM 150
#define SANITY_GREAT 125
#define SANITY_NEUTRAL 100
#define SANITY_DISTURBED 75
#define SANITY_UNSTABLE 50
#define SANITY_CRAZY 25
#define SANITY_INSANE 0

//Nutrition levels for humans
#define NUTRITION_LEVEL_FULL 1000
#define NUTRITION_LEVEL_FAT 800
#define NUTRITION_LEVEL_WELL_FED 700
#define NUTRITION_LEVEL_FED 500
#define NUTRITION_LEVEL_HUNGRY 350
#define NUTRITION_LEVEL_STARVING 100

#define HYDRATION_LEVEL_FULL 1000
#define HYDRATION_LEVEL_WATER_LOGGED 850
#define HYDRATION_LEVEL_HYDRATED 700
#define HYDRATION_LEVEL_SMALLTHIRST 600
#define HYDRATION_LEVEL_THIRSTY 350
#define HYDRATION_LEVEL_DEHYDRATED 100

#define NUTRITION_LEVEL_START_MIN 500
#define NUTRITION_LEVEL_START_MAX 900

#define HYDRATION_LEVEL_START_MIN 600
#define HYDRATION_LEVEL_START_MAX 900

//Disgust levels for humans
#define DISGUST_LEVEL_MAXEDOUT 150
#define DISGUST_LEVEL_DISGUSTED 75
#define DISGUST_LEVEL_VERYGROSS 50
#define DISGUST_LEVEL_GROSS 25
#define DISGUST_LEVEL_SLIGHTLYGROSS 10

//Hygiene

#define HYGIENE_LEVEL_CLEAN 250
#define HYGIENE_LEVEL_NORMAL 200
#define HYGIENE_LEVEL_DIRTY 75
#define HYGIENE_LEVEL_DISGUSTING 0

//For washing
#define HYGIENE_GAIN_CLOTHED 10
#define HYGIENE_GAIN_UNCLOTHED 25

#define HARPY_PREENING_COOLDOWN 10 MINUTES

//Used as an upper limit for species that continuously gain nutriment
#define NUTRITION_LEVEL_ALMOST_FULL 995

//Charge levels for Ethereals
#define ETHEREAL_CHARGE_NONE 0
#define ETHEREAL_CHARGE_LOWPOWER 20
#define ETHEREAL_CHARGE_NORMAL 50
#define ETHEREAL_CHARGE_ALMOSTFULL 75
#define ETHEREAL_CHARGE_FULL 100

//Slime evolution threshold. Controls how fast slimes can split/grow
#define SLIME_EVOLUTION_THRESHOLD 10

//Slime extract crossing. Controls how many extracts is required to feed to a slime to core-cross.
#define SLIME_EXTRACT_CROSSING_REQUIRED 10

//Slime commands defines
#define SLIME_FRIENDSHIP_FOLLOW 			3 //Min friendship to order it to follow
#define SLIME_FRIENDSHIP_STOPEAT 			5 //Min friendship to order it to stop eating someone
#define SLIME_FRIENDSHIP_STOPEAT_NOANGRY	7 //Min friendship to order it to stop eating someone without it losing friendship
#define SLIME_FRIENDSHIP_STOPCHASE			4 //Min friendship to order it to stop chasing someone (their target)
#define SLIME_FRIENDSHIP_STOPCHASE_NOANGRY	6 //Min friendship to order it to stop chasing someone (their target) without it losing friendship
#define SLIME_FRIENDSHIP_STAY				3 //Min friendship to order it to stay
#define SLIME_FRIENDSHIP_ATTACK				8 //Min friendship to order it to attack

//Sentience types, to prevent things like sentience potions from giving bosses sentience
#define SENTIENCE_ORGANIC 1
#define SENTIENCE_ARTIFICIAL 2
// #define SENTIENCE_OTHER 3 unused
#define SENTIENCE_MINEBOT 4
#define SENTIENCE_BOSS 5

//Mob AI Status

//Hostile simple animals
//If you add a new status, be sure to add a list for it to the simple_animals global in _globalvars/lists/mobs.dm

//determines if a mob can smash through it
#define ENVIRONMENT_SMASH_NONE			0
#define ENVIRONMENT_SMASH_STRUCTURES	(1<<0) 	//crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS			(1<<1)  //walls
#define ENVIRONMENT_SMASH_RWALLS		(1<<2)	//rwalls

#define NO_SLIP_WHEN_WALKING	(1<<0)
#define SLIDE					(1<<1)
#define GALOSHES_DONT_HELP		(1<<2)
#define SLIDE_ICE				(1<<3)
#define SLIP_WHEN_CRAWLING		(1<<4) //clown planet ruin

#define MAX_CHICKENS 50

///Flags used by the flags parameter of electrocute act.

///Makes it so that the shock doesn't take gloves into account.
#define SHOCK_NOGLOVES (1 << 0)
///Used when the shock is from a tesla bolt.
#define SHOCK_TESLA (1 << 1)
///Used when an illusion shocks something. Makes the shock deal stamina damage and not trigger certain secondary effects.
#define SHOCK_ILLUSION (1 << 2)
///The shock doesn't stun.
#define SHOCK_NOSTUN (1 << 3)

#define INCORPOREAL_MOVE_BASIC 1
#define INCORPOREAL_MOVE_SHADOW 2 // leaves a trail of shadows
#define INCORPOREAL_MOVE_JAUNT 3 // is blocked by holy water/salt

//Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED		(1<<0)
#define JUDGE_IDCHECK		(1<<1)
#define JUDGE_WEAPONCHECK	(1<<2)
#define JUDGE_RECORDCHECK	(1<<3)
//ED209's ignore monkeys
#define JUDGE_IGNOREMONKEYS	(1<<4)

#define MEGAFAUNA_DEFAULT_RECOVERY_TIME 5

#define SHADOW_SPECIES_LIGHT_THRESHOLD 0.2

// Offsets defines

#define OFFSET_RING "wear_ring"
#define OFFSET_GLOVES "gloves"
#define OFFSET_WRISTS "wear_wrists"
#define OFFSET_HANDS "hands"
#define OFFSET_SHOES "shoes"
#define OFFSET_FACEMASK "mask"
#define OFFSET_HEAD "head"
#define OFFSET_FACE "face" //facial hair and hair
#define OFFSET_BELT "belt"
#define OFFSET_BACK "back"
#define OFFSET_SUIT "suit"
#define OFFSET_NECK "neck"
#define OFFSET_CLOAK "cloak"
#define OFFSET_MOUTH "mouth"
#define OFFSET_PANTS "wear_pants"
#define OFFSET_SHIRT "wear_shirt"
#define OFFSET_ARMOR "wear_armor"
#define OFFSET_UNDIES "underwear"

#define HUNGER_FACTOR		0.15	//factor at which mob nutrition decreases
#define	HYGIENE_FACTOR  	0.05  //factor at which hygiene decreases
#define ETHEREAL_CHARGE_FACTOR	0.12 //factor at which ethereal's charge decreases
#define REAGENTS_METABOLISM 1	//How many units of reagent are consumed per tick, by default.
#define REAGENTS_SLOW_METABOLISM 0.1 // needed to have poisons have powerful effect at low doses without making it too fast
#define REAGENTS_EFFECT_MULTIPLIER (REAGENTS_METABOLISM / 0.4)	// By defining the effect multiplier this way, it'll exactly adjust all effects according to how they originally were with the 0.4 metabolism
#define REM REAGENTS_EFFECT_MULTIPLIER

// Eye protection
#define FLASH_PROTECTION_SENSITIVE -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_FLASH 1
#define FLASH_PROTECTION_WELDER 2

#define HUMAN_FIRE_STACK_ICON_NUM	5

#define PULL_PRONE_SLOWDOWN 2
#define HUMAN_CARRY_SLOWDOWN 0

//Flags that control what things can spawn species (whitelist)
//Wabbacjack staff projectiles
#define WABBAJACK     (1<<0)

// Randomization keys for calling wabbajack with.
// Note the contents of these keys are important, as they're displayed to the player
// Ex: (You turn into a "monkey", You turn into a "xenomorph")
#define WABBAJACK_HUMAN "humanoid"
#define WABBAJACK_ANIMAL "animal"

#define SLEEP_CHECK_DEATH(X) sleep(X); if(QDELETED(src) || stat == DEAD) return;

#define DOING_INTERACTION(user, interaction_key) (LAZYACCESS(user.do_afters, interaction_key))
#define DOING_INTERACTION_LIMIT(user, interaction_key, max_interaction_count) ((LAZYACCESS(user.do_afters, interaction_key) || 0) >= max_interaction_count)
#define DOING_INTERACTION_WITH_TARGET(user, target) (LAZYACCESS(user.do_afters, target))
#define DOING_INTERACTION_WITH_TARGET_LIMIT(user, target, max_interaction_count) ((LAZYACCESS(user.do_afters, target) || 0) >= max_interaction_count)

//defense intents
#define INTENT_DODGE 1
#define INTENT_PARRY 2

/// Humans are slowed by the difference between bodytemp and BODYTEMP_COLD_DAMAGE_LIMIT divided by this
#define COLD_SLOWDOWN_FACTOR				20

/// Possible value of [/atom/movable/buckle_lying]. If set to a different (positive-or-zero) value than this, the buckling thing will force a lying angle on the buckled.
#define NO_BUCKLE_LYING -1

/// Simple mob trait, indicating it may follow continuous move actions controlled by code instead of by user input.
#define MOVES_ON_ITS_OWN (1<<0)

// Body position defines.
/// Mob is standing up, usually associated with lying_angle value of 0.
#define STANDING_UP 0
/// Mob is lying down, usually associated with lying_angle values of 90 or 270.
#define LYING_DOWN 1

///How much a mob's sprite should be moved when they're lying down
#define PIXEL_Y_OFFSET_LYING -6

/// If reading is required to perform action (can't read a book if you are illiterate)
#define NEED_LITERACY (1<<0)
/// If lighting must be present to perform action (can't heal someone in the dark)
#define NEED_LIGHT (1<<1)
/// If other mobs (monkeys, aliens, etc) can perform action (can't use computers if you are a monkey)
#define NEED_DEXTERITY (1<<2)
/// If telekinesis is forbidden to perform action from a distance (ex. canisters are blacklisted from telekinesis manipulation)
#define FORBID_TELEKINESIS_REACH (1<<3)
/// If resting on the floor is allowed to perform action
#define ALLOW_RESTING (1<<4)
