///what is this you might ask and why isn't this something per chemical?
/// this keeps track of various total powers of checmicals and lets us scale things easier
/// IE: if you have 9 different pain killers they shouldn't stack additively and expecting
/// people to redo the math everywhere for it is less than ideal, so thats where this comes in.

#define SIGNAL_ADDCHEMEFFECT(chem_effect) "addchemeffect [chem_effect]"
#define SIGNAL_REMOVECHEMEFFECT(chem_effect) "removechemeffect [chem_effect]"
#define SIGNAL_INCREASECHEMEFFECT(chem_effect) "increasechemeffect [chem_effect]"
#define SIGNAL_DECREASECHEMEFFECT(chem_effect) "decreasechemeffect [chem_effect]"

/// default chem effect source
#define CHEM_GENERIC "generic"


// ~defines for chemical effects
/// Stabilizes pulse
#define CE_STABLE "stable"
/// Boosts spleen blood regen
#define CE_BLOODRESTORE "bloodrestore"
/// Reduces shock
#define CE_PAINKILLER "painkiller"
/// Liver filtering
#define CE_ALCOHOL "alcohol"
/// Liver damage
#define CE_ALCOHOL_TOXIC "alcotoxic"
/// Temporary speed increase/decrease
#define CE_SPEED "speed"
/// Harder to disarm
#define CE_STIMULANT "stimulant"
/// Increases or decreases heart rate
#define CE_PULSE "pulse"
/// Stops heartbeat
#define CE_NOPULSE "heartstop"
/// Reduces toxins in the blood stream
#define CE_ANTITOX "antitox"
/// Increases blood oxygenation
#define CE_OXYGENATED "oxygen"
/// Heals the brain over time
#define CE_BRAIN_REGEN "brainfix"
/// Doubles organ healing from all sources
#define CE_ORGAN_REGEN "organ_regen"
/// Generic toxins, stops autoheal
#define CE_TOXIN "toxins"
/// Breathing depression, makes you need more air
#define CE_BREATHLOSS "breathloss"
/// Stabilizes or wrecks mind
#define CE_MIND "mindbending"
/// Gets in the way of blood circulation, higher the worse
#define CE_BLOCKAGE "blockage"
/// Helium voice. Squeak squeak
#define CE_SQUEAKY "squeaky"
/// Gives xray vision
#define CE_THIRDEYE "thirdeye"
/// Applies sedation effects, i.e. paralysis, inability to use items, etc
#define CE_SEDATE "sedate"
/// Speeds up stamina recovery
#define CE_ENERGETIC "energetic"
/// Lowers the subject's voice to a whisper
#define	CE_VOICELOSS "whispers"
