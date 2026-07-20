/// from /datum/emote/living/pray/run_emote(): (message)
#define COMSIG_EMOTE_PRAY "carbon_prayed"
	/// Prevents the carbon's patron from hearing this prayer.
	#define CARBON_PRAY_CANCEL (1<<0)

///From mob/living/carbon/human/suicide()
#define COMSIG_HUMAN_SUICIDE_ACT "human_suicide_act"

///Called when a carbon attempts to breath, before the breath has actually occurred
#define COMSIG_CARBON_ATTEMPT_BREATHE "carbon_attempt_breathe"
	// Prevents the breath
	#define COMSIG_CARBON_BLOCK_BREATH (1 << 0)
	/// Allow the breath but prevent inake, think losebreath
	#define BREATHE_SKIP_BREATH (1<<1)
///Called when a carbon breathes, before the breath has actually occurred
#define COMSIG_CARBON_PRE_BREATHE "carbon_pre_breathe"

///from base of /mob/living/carbon/regenerate_limbs(): (excluded_limbs)
#define COMSIG_CARBON_REGENERATE_LIMBS "living_regen_limbs"

/// from base of /mob/living/carbon/add_stress: (event_type)
#define COMSIG_CARBON_ADD_STRESS "mob_add_stress"
/// from base of /datum/reagent/proc/on_transfer: (atom/A, method=TOUCH, trans_volume) //Called after a reagent is transfered to a carbon
#define COMSIG_CARBON_REAGENT_ADD "carbon_reagent_add"
/// from base of mob/living/carbon/soundbang_act(): (list(intensity))
#define COMSIG_CARBON_SOUNDBANG "carbon_soundbang"
/// From base of /mob/living/carbon/handle_blood: ()
#define COMSIG_CARBON_ON_HANDLE_BLOOD "human_on_handle_blood"
	#define HANDLE_BLOOD_HANDLED (1<<0)
	#define HANDLE_BLOOD_NO_NUTRITION_DRAIN (1<<1)
	#define HANDLE_BLOOD_NO_EFFECTS (1<<2)

/// Called from the base of '/obj/item/bodypart/proc/drop_limb(special)' ()
#define COMSIG_CARBON_DISMEMBER "mob_drop_limb"
	#define COMPONENT_CANCEL_DISMEMBER (1<<0) //cancel the drop limb
/// from /mob/say_dead(): (mob/speaker, message)
