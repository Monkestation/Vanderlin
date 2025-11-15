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
#define ORGAN_SLOT_BRAIN "brain"
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

/// This is used as a reference point for dynamic wounds, so it's better off as a define.
#define ARTERY_LIMB_BLEEDRATE 20
