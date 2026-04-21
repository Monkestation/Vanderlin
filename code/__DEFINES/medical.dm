//body damage zones
#define BODY_ZONE_HEAD		"head"
#define BODY_ZONE_CHEST		"chest"
#define BODY_ZONE_L_ARM		"l_arm"
#define BODY_ZONE_R_ARM		"r_arm"
#define BODY_ZONE_L_LEG		"l_leg"
#define BODY_ZONE_R_LEG		"r_leg"

#define BODY_ZONE_PRECISE_SKULL		"skull"
#define BODY_ZONE_PRECISE_EARS		"ears"
#define BODY_ZONE_PRECISE_R_EYE		"r_eye"
#define BODY_ZONE_PRECISE_L_EYE		"l_eye"
#define BODY_ZONE_PRECISE_NOSE		"nose"
#define BODY_ZONE_PRECISE_MOUTH		"mouth"
#define BODY_ZONE_PRECISE_NECK		"neck"
#define BODY_ZONE_PRECISE_STOMACH	"stomach"
#define BODY_ZONE_PRECISE_GROIN		"groin"
#define BODY_ZONE_PRECISE_L_HAND	"l_hand"
#define BODY_ZONE_PRECISE_L_INHAND	"l_inhand"
#define BODY_ZONE_PRECISE_R_HAND	"r_hand"
#define BODY_ZONE_PRECISE_R_INHAND	"r_inhand"
#define BODY_ZONE_PRECISE_L_FOOT	"l_foot"
#define BODY_ZONE_PRECISE_R_FOOT	"r_foot"

///the side we are facing
#define BODY_ZONE_FACING_FRONT      "front_face"
#define BODY_ZONE_FACING_L_ARM      "l_arm_face"
#define BODY_ZONE_FACING_R_ARM      "r_arm_face"
#define BODY_ZONE_FACING_L_LEG      "l_leg_face"
#define BODY_ZONE_FACING_R_LEG      "r_leg_face"

//organ slots
#define ORGAN_SLOT_ARTERY "artery"
#define ORGAN_SLOT_BRAIN "brain"
#define ORGAN_SLOT_SPLEEN "spleen"
#define ORGAN_SLOT_APPENDIX "appendix"
#define ORGAN_SLOT_STOMACH "stomach"
#define ORGAN_SLOT_GUTS "guts"
#define ORGAN_SLOT_EARS "ears"
#define ORGAN_SLOT_EYES "eyes"
#define ORGAN_SLOT_LUNGS "lungs"
#define ORGAN_SLOT_HEART "heart"
#define ORGAN_SLOT_LIVER "liver"
#define ORGAN_SLOT_TONGUE "tongue"
#define ORGAN_SLOT_VOICE "vocal_cords"
#define ORGAN_SLOT_TAIL "tail"
#define ORGAN_SLOT_FRILLS "frills"
#define ORGAN_SLOT_HORNS "horns"
#define ORGAN_SLOT_ANTENNAS "antennas"
#define ORGAN_SLOT_WINGS "wings"
#define ORGAN_SLOT_SNOUT "snout"

#define ORGAN_SLOT_NECK_FEATURE "neck_feature"
#define ORGAN_SLOT_HEAD_FEATURE "head_feature"
#define ORGAN_SLOT_BACK_FEATURE "back_feature"
#define ORGAN_SLOT_TAIL_FEATURE "tail_feature"

#define BODYPART_FEATURE_HAIR "hair"
#define BODYPART_FEATURE_FACIAL_HAIR "facehair"
#define BODYPART_FEATURE_ACCESSORY "accessory"
#define BODYPART_FEATURE_FACE_DETAIL "facedetail"
#define BODYPART_FEATURE_BRAND "brand"

//flags for requirements for a surgery step
#define SURGERY_BLOODY (1<<0)
#define SURGERY_INCISED (1<<1)
#define SURGERY_RETRACTED (1<<2)
#define SURGERY_CLAMPED	(1<<3)
#define SURGERY_DISLOCATED (1<<4)
#define SURGERY_BROKEN (1<<5)
#define SURGERY_DRILLED (1<<6)

// ~flags for the limb_flags var on /obj/item/bodypart
/// Can suffer artery wounds
#define	BODYPART_HAS_ARTERY	(1<<0)

//flags for the organ_flags var on /obj/item/organ
/// Synthetic organs, or cybernetic organs. Reacts to EMPs and don't deteriorate or heal
#define ORGAN_SYNTHETIC			(1<<0)
/// Frozen organs, don't deteriorate
#define ORGAN_FROZEN			(1<<1)
/// Failing organs perform damaging effects until replaced or fixed
#define ORGAN_FAILING			(1<<2)
/// Was this organ implanted/inserted/etc, if true will not be removed during species change.
#define ORGAN_EXTERNAL			(1<<3)
/// Currently only the brain - Removal of this organ immediately kills you
#define ORGAN_VITAL				(1<<4)
/// Destroyed organs don't function and cannot be repaired, needs a transplant
#define ORGAN_DESTROYED (1<<5)
/// Not only is the organ failing, it is completely septic and spreading germs around
#define ORGAN_DEAD (1<<6)
/// Organ has been cut away from the owner and can be safely removed during surgery
#define ORGAN_CUT_AWAY (1<<7)
/// Organ should update limb efficiency when damaged or healed
#define ORGAN_LIMB_SUPPORTER (1<<8)
/// Organ shouldn't be counted in /obj/item/bodypart/proc/damage_internal_organs()
#define ORGAN_NO_VIOLENT_DAMAGE (1<<9)
/// Organ cannot ever become destroyed beyond repair
#define ORGAN_INDESTRUCTIBLE (1<<10)

//wound severities for /datum/wound
/// Wounds that are either surgically induced or too minor to matter
#define WOUND_SEVERITY_SUPERFICIAL 0
/// Wounds that are minor, such as bruises and minor cuts
#define WOUND_SEVERITY_LIGHT 1
/// Wounds that are moderate, such as dislocations
#define WOUND_SEVERITY_MODERATE 2
/// Wounds that are severe, such as broken bones
#define WOUND_SEVERITY_SEVERE 3
/// Wounds that are critical and will kill rather quickly, such as torn arteries
#define WOUND_SEVERITY_CRITICAL 4
/// Wounds that are almost immediately fatal, such as a dissected aorta
#define WOUND_SEVERITY_FATAL 5
/// This wound has werewolf infection
#define WOUND_SEVERITY_BIOHAZARD 6

#define LIMB_EFFICIENCY_OPTIMAL 100
#define LIMB_EFFICIENCY_DISABLING 50

/// This is used as a reference point for dynamic wounds, so it's better off as a define.
#define ARTERY_LIMB_BLEEDRATE 25

/// Multiplier applied to reagents in blood when factoring in total volume for "purity"
#define BLOODLETTING_MULT 5

/// Black Briar
#define BBC_TIME_MAX (90 MINUTES)
#define BBC_TIME_MAX_LIMB BBC_TIME_MAX * 0.5

/// Black Briar time ratios
#define BBC_STAGE_LATE 	0.7
#define BBC_STAGE_MID	0.3
#define BBC_STAGE_DETECTABLE	0.15
#define BBC_SPREAD_RATE BBC_STAGE_DETECTABLE * 0.5

#define ALL_BODYPARTS list(\
	BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_R_EYE, \
	BODY_ZONE_PRECISE_MOUTH, \
	BODY_ZONE_HEAD, BODY_ZONE_PRECISE_NECK, \
	BODY_ZONE_CHEST, \
	BODY_ZONE_PRECISE_GROIN, \
	BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, \
	BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, \
	BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, \
	BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT, \
)

// ~should take around 20 minutes for a body to fully rot
#define MIN_ORGAN_DECAY_INFECTION 0.25
#define MAX_ORGAN_DECAY_INFECTION 0.5


// ~efficiency defines
#define ORGAN_OPTIMAL_EFFICIENCY 100
#define ORGAN_BRUISED_EFFICIENCY 80
#define ORGAN_FAILING_EFFICIENCY 50
#define ORGAN_DESTROYED_EFFICIENCY 0

// ~organ failure defines
/// Amount of seconds before liver failure reaches a new stage
#define LIVER_FAILURE_STAGE_SECONDS 60

// ~organ requirements
/// Normally 50% of the default blood volume (230cl)
#define DEFAULT_TOTAL_BLOOD_REQ	BLOOD_VOLUME_NORMAL * 0.33
#define DEFAULT_TOTAL_OXYGEN_REQ 50
#define DEFAULT_TOTAL_NUTRIMENT_REQ	HUNGER_FACTOR
#define DEFAULT_TOTAL_HYDRATION_REQ THIRST_FACTOR

// ~simple list of organs that come in pairs
#define PAIRED_ORGAN_SLOTS list(ORGAN_SLOT_EYES, ORGAN_SLOT_EARS, ORGAN_SLOT_HORNS)

#define GET_EFFECTIVE_BLOOD_VOL(num, total_blood_req) (max(num - DEFAULT_TOTAL_BLOOD_REQ + total_blood_req, 0))

//The contant in the rate of reagent transfer on life ticks
#define STOMACH_METABOLISM_CONSTANT 0.25

// ~infection levels
/// infections grow from ambient to one in ~5 minutes
#define INFECTION_LEVEL_ONE 250
/// infections grow from ambient to two in ~10 minutes
#define INFECTION_LEVEL_TWO 500
/// infections grow from two to three in ~15 minutes
#define INFECTION_LEVEL_THREE 1000

// ~germ defines
/// Medical equipment should start out as this
#define GERM_LEVEL_STERILE 0
/// Maximum germ level you can reach by standing still.
#define GERM_LEVEL_AMBIENT 250
/// Maximum germ level any atom can normally achieve
#define GERM_LEVEL_MAXIMUM 1000

/// Exposure to blood germ level per unit
#define GERM_PER_UNIT_BLOOD 2

// ~sanitization defines, related to lowering germ level
#define SANITIZATION_CUREROT 500
/// Sterilizine sanitization per unit
#define SANITIZATION_PER_UNIT_STERILIZINE 50
/// Space cleaner sanitization per unit
#define SANITIZATION_PER_UNIT_SPACE_CLEANER 25
/// Water sanitization per unit
#define SANITIZATION_PER_UNIT_WATER 10
/// CE_ANTIBIOTIC bodypart/organ sanitization per CE unit
#define SANITIZATION_ANTIBIOTIC 0.1
/// Bodypart/organ sanitization for laying down
#define SANITIZATION_LYING 1

//~brain damage related defines
/// We need to take at least this much brainloss gained at once to roll for brain traumas, any less it won't roll
#define TRAUMA_ROLL_THRESHOLD 4.5
/// Brainloss caused by mildly low blood oxygenation
#define BRAIN_DAMAGE_LOW_OXYGENATION 1.1
/// Brainloss caused by lower than low blood oxygenation
#define BRAIN_DAMAGE_LOWER_OXYGENATION 2.2
/// Brainloss caused by a complete lack of oxygen flow
#define BRAIN_DAMAGE_LOWEST_OXYGENATION 3.3

// ~pulse levels, very simplified.
#define PULSE_NONE 0   // So !M.pulse checks would be possible.
#define PULSE_SLOW 1   // <60     bpm
#define PULSE_NORM 2   //  60-90  bpm
#define PULSE_FAST 3   //  90-120 bpm
#define PULSE_FASTER 4   // >120    bpm
#define PULSE_THREADY 5   // Occurs during hypovolemic shock
#define PULSE_MAX_BPM 250 // Highest, readable BPM by machines and humans.
#define GETPULSE_BASIC 0   // Less accurate. (hand, health analyzer, etc.)
#define GETPULSE_ADVANCED 1   // More accurate. (med scanner, sleeper, etc.)
#define GETPULSE_PERFECT 2   // Perfectly accurate. (currently no non-adminbus means, you get the exact value 0-5)


// ~CPR types
/// Mouth to mouth - Heals oxygen deprivation
#define CPR_MOUTH "m2m"
#define CPR_CHEST "cardio"

/// Mouth to mouth cooldown duration
#define M2M_COOLDOWN 0.3 SECONDS
///Cpr cooldown duration
#define CPR_COOLDOWN 0.3 SECONDS

#define CPR_TIME 4 SECONDS
#define M2M_TIME 0.5 SECONDS

// ~simple brainloss defines
#define GETBRAINLOSS(mob) mob.getOrganLoss(ORGAN_SLOT_BRAIN)
#define ADJUSTBRAINLOSS(mob, amount) mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, amount)
#define SETBRAINLOSS(mob, amount) mob.setOrganLoss(ORGAN_SLOT_BRAIN, amount)


// ~arteries
#define ARTERY_MAX_HEALTH 100
#define ARTERIAL_BLOOD_FLOW 3

#define ARTERY_HEAD /obj/item/organ/artery/head
#define ARTERY_MOUTH /obj/item/organ/artery/mouth
#define ARTERY_CHEST /obj/item/organ/artery/chest
#define ARTERY_NECK /obj/item/organ/artery/neck
#define ARTERY_L_ARM /obj/item/organ/artery/l_arm
#define ARTERY_R_ARM /obj/item/organ/artery/r_arm
#define ARTERY_L_LEG /obj/item/organ/artery/l_leg
#define ARTERY_R_LEG /obj/item/organ/artery/r_leg
