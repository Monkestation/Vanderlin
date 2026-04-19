/// from /datum/emote/living/pray/run_emote(): (message)
#define COMSIG_EMOTE_PRAY "carbon_prayed"
	/// Prevents the carbon's patron from hearing this prayer.
	#define CARBON_PRAY_CANCEL (1<<0)

///From mob/living/carbon/human/suicide()
#define COMSIG_HUMAN_SUICIDE_ACT "human_suicide_act"

///from base of /mob/living/carbon/regenerate_limbs(): (excluded_limbs)
#define COMSIG_CARBON_REGENERATE_LIMBS "living_regen_limbs"
