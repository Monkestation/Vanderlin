//bitflags to check for certain conditions determining ability to actually cast a coven
//flags overlap, like COVEN_CHECK_CAPABLE covers COVEN_CHECK_CONSCIOUS and COVEN_CHECK_TORPOR
///Caster must not be in Torpor
#define COVEN_CHECK_TORPORED (1<<0)
///Caster must be conscious
#define COVEN_CHECK_CONSCIOUS (1<<1)
///Caster must be capable of taking actions (not stunned)
#define COVEN_CHECK_CAPABLE (1<<2)
///Caster must be standing up (not knocked down)
#define COVEN_CHECK_LYING (1<<3)
///Caster must be capable of moving
#define COVEN_CHECK_IMMOBILE (1<<4)
///Caster must have usable hands
#define COVEN_CHECK_FREE_HAND (1<<5)
///Caster must be able to speak
#define COVEN_CHECK_SPEAK (1<<6)
///Caster must be able to see
#define COVEN_CHECK_SEE (1<<7)


//normal duration defines
///Duration of one "turn", which is 5 seconds according to us
#define TURNS * 5 SECONDS
///Duration of one "scene", which is 3 minutes according to us
#define SCENES * 3 MINUTES

//targeting bitflags, NONE or 0 if targeting self exclusively
///Allows for self to also be selected in ranged targeting, SET TO 0 IF NOT TARGETED OR RANGED
#define TARGET_SELF (1<<0)
///Targets anything of type /obj and its children
#define TARGET_OBJ (1<<1)
///Targets anything of type /turf and its children
#define TARGET_TURF (1<<2)
///Targets anything of type /mob/living and its children only if it is not dead
#define TARGET_LIVING (1<<3)
///Targets anything of type /mob/dead and its children, ie targets ghosts
#define TARGET_GHOST (1<<4)
///Targets anything of type /mob/living and its children, dead or not
#define TARGET_MOB (1<<5)
///Targets anything of type /mob/living/carbon/human and its children
#define TARGET_HUMAN (1<<6)
///Targets anything of type /mob/living and its children only if it has a client attached to it
#define TARGET_PLAYER (1<<7)
///Targets mobs only if they are vampires/Kindred
#define TARGET_VAMPIRE (1<<8)

//Aggregated targeting for /mob/living
#define MOB_LIVING_TARGETING (TARGET_MOB | TARGET_LIVING | TARGET_HUMAN | TARGET_PLAYER | TARGET_VAMPIRE)


#define COVEN_POWER_GROUP_NONE 0
#define COVEN_POWER_GROUP_COMBAT 1

#define POWER_TYPE_COVEN "coven"

#define COVEN_COST_VITAE 0

#define DICE_CRIT_WIN 1
#define DICE_WIN 2
