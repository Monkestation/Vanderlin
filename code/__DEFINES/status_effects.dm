
//These are all the different status effects. Use the paths for each effect in the defines.

///if it allows multiple instances of the effect
#define STATUS_EFFECT_MULTIPLE 0
///if it allows only one, preventing new instances
#define STATUS_EFFECT_UNIQUE 1
///if it allows only one, but new instances replace
#define STATUS_EFFECT_REPLACE 2
/// if it only allows one, and new instances just instead refresh the timer
#define STATUS_EFFECT_REFRESH 3

/// Use in status effect "duration" to make it last forever
#define STATUS_EFFECT_PERMANENT -1
/// Use in status effect "tick_interval" to prevent it from calling tick()
#define STATUS_EFFECT_NO_TICK -1
/// Use in status effect "tick_interval" to guarantee that tick() gets called on every process()
#define STATUS_EFFECT_AUTO_TICK 0

/// Indicates this status effect is an abstract type, ie not instantiated
/// Doesn't actually do anything in practice, primarily just a marker / used in unit tests,
/// so don't worry if your abstract status effect doesn't actually set this
#define STATUS_EFFECT_ID_ABSTRACT "abstract"

///Processing flags - used to define the speed at which the status will work
///This is fast - 0.2s between ticks (I believe!)
#define STATUS_EFFECT_FAST_PROCESS 0
///This is slower and better for more intensive status effects - 1s between ticks
#define STATUS_EFFECT_NORMAL_PROCESS 1

//Incapacitated status effect flags
/// If the incapacitated status effect will ignore a mob in restraints (handcuffs)
#define IGNORE_RESTRAINTS (1<<0)
/// If the incapacitated status effect will ignore a mob in stasis
#define IGNORE_STASIS (1<<1)
/// If the incapacitated status effect will ignore a mob being agressively grabbed
#define IGNORE_GRAB (1<<2)

///////////
// BUFFS //
///////////

#define STATUS_EFFECT_SHADOW_MEND /datum/status_effect/shadow_mend //Quick, powerful heal that deals damage afterwards. Heals 15 brute/burn every second for 3 seconds.
#define STATUS_EFFECT_VOID_PRICE /datum/status_effect/void_price //The price of healing myself with void energy. Deals 3 brute damage every 3 seconds for 30 seconds.

#define STATUS_EFFECT_POWERREGEN /datum/status_effect/cyborg_power_regen //Regenerates power on a given cyborg over time

#define STATUS_EFFECT_HISGRACE /datum/status_effect/his_grace //His Grace.

#define STATUS_EFFECT_WISH_GRANTERS_GIFT /datum/status_effect/wish_granters_gift //If you're currently resurrecting with the Wish Granter

#define STATUS_EFFECT_BLOODDRUNK /datum/status_effect/blooddrunk //Stun immunity and greatly reduced damage taken

#define STATUS_EFFECT_FLESHMEND /datum/status_effect/fleshmend //Very fast healing; suppressed by fire, and heals less fire damage

#define STATUS_EFFECT_EXERCISED /datum/status_effect/exercised //Prevents heart disease

#define STATUS_EFFECT_HIPPOCRATIC_OATH /datum/status_effect/hippocraticOath //Gives you an aura of healing as well as regrowing the Rod of Asclepius if lost

#define STATUS_EFFECT_GOOD_MUSIC /datum/status_effect/good_music

#define STATUS_EFFECT_REGENERATIVE_CORE /datum/status_effect/regenerative_core

#define STATUS_EFFECT_ANTIMAGIC /datum/status_effect/antimagic //grants antimagic (and reapplies if lost) for the duration

/////////////
// DEBUFFS //
/////////////

#define STATUS_EFFECT_OFFBALANCED /datum/status_effect/incapacitating/off_balanced

#define STATUS_EFFECT_STUN /datum/status_effect/incapacitating/stun //the affected is unable to move or use items

#define STATUS_EFFECT_KNOCKDOWN /datum/status_effect/incapacitating/knockdown //the affected is unable to stand up

#define STATUS_EFFECT_IMMOBILIZED /datum/status_effect/incapacitating/immobilized //the affected is unable to move

#define STATUS_EFFECT_PARALYZED /datum/status_effect/incapacitating/paralyzed //the affected is unable to move, use items, or stand up.

#define STATUS_EFFECT_UNCONSCIOUS /datum/status_effect/incapacitating/unconscious //the affected is unconscious

#define STATUS_EFFECT_SLEEPING /datum/status_effect/incapacitating/sleeping //the affected is asleep

#define STATUS_EFFECT_PACIFY /datum/status_effect/pacify //the affected is pacified, preventing direct hostile actions

#define STATUS_EFFECT_BELLIGERENT /datum/status_effect/belligerent //forces the affected to walk, doing damage if they try to run

#define STATUS_EFFECT_GEISTRACKER /datum/status_effect/geis_tracker //if you're using geis, this tracks that and keeps you from using scripture

#define STATUS_EFFECT_MANIAMOTOR /datum/status_effect/maniamotor //disrupts, damages, and confuses the affected as long as they're in range of the motor
#define MAX_MANIA_SEVERITY 100 //how high the mania severity can go
#define MANIA_DAMAGE_TO_CONVERT 90 //how much damage is required before it'll convert affected targets

#define STATUS_EFFECT_CHOKINGSTRAND /datum/status_effect/strandling //Choking Strand

#define STATUS_EFFECT_HISWRATH /datum/status_effect/his_wrath //His Wrath.

#define STATUS_EFFECT_SUMMONEDGHOST /datum/status_effect/cultghost //is a cult ghost and can't use manifest runes

#define STATUS_EFFECT_CRUSHERMARK /datum/status_effect/crusher_mark //if struck with a proto-kinetic crusher, takes a ton of damage

#define STATUS_EFFECT_SAWBLEED /datum/status_effect/stacking/saw_bleed //if the bleed builds up enough, takes a ton of damage

#define STATUS_EFFECT_NECKSLICE /datum/status_effect/neck_slice //Creates the flavor messages for the neck-slice

#define STATUS_EFFECT_NECROPOLIS_CURSE /datum/status_effect/necropolis_curse
#define STATUS_EFFECT_HIVEMIND_CURSE /datum/status_effect/necropolis_curse/hivemind
#define CURSE_BLINDING	1 //makes the edges of the target's screen obscured
#define CURSE_SPAWNING	2 //spawns creatures that attack the target only
#define CURSE_WASTING	4 //causes gradual damage
#define CURSE_GRASPING	8 //hands reach out from the sides of the screen, doing damage and stunning if they hit the target

#define STATUS_EFFECT_KINDLE /datum/status_effect/kindle //A knockdown reduced by 1 second for every 3 points of damage the target takes.

#define STATUS_EFFECT_ICHORIAL_STAIN /datum/status_effect/ichorial_stain //Prevents a servant from being revived by vitality matrices for one minute.

#define STATUS_EFFECT_SPASMS /datum/status_effect/spasms //causes random muscle spasms

#define STATUS_EFFECT_DNA_MELT /datum/status_effect/dna_melt //usually does something horrible to you when you hit 100 genetic instability

#define STATUS_EFFECT_GO_AWAY /datum/status_effect/go_away //makes you launch through walls in a single direction for a while

#define STATUS_EFFECT_FAKE_VIRUS /datum/status_effect/fake_virus //gives you fluff messages for cough, sneeze, headache, etc but without an actual virus

/////////////
// NEUTRAL //
/////////////

#define STATUS_EFFECT_SIGILMARK /datum/status_effect/sigil_mark

#define STATUS_EFFECT_CRUSHERDAMAGETRACKING /datum/status_effect/crusher_damage //tracks total kinetic crusher damage on a target

#define STATUS_EFFECT_SYPHONMARK /datum/status_effect/syphon_mark //tracks kills for the KA death syphon module

#define STATUS_EFFECT_INLOVE /datum/status_effect/in_love //Displays you as being in love with someone else, and makes hearts appear around them.

#define STATUS_EFFECT_BUGGED /datum/status_effect/bugged //Lets other mobs listen in on what it hears

#define STATUS_EFFECT_BOUNTY /datum/status_effect/bounty //rewards the person who added this to the target with refreshed spells and a fair heal

/////////////
//  SLIME  //
/////////////

#define STATUS_EFFECT_RAINBOWPROTECTION /datum/status_effect/rainbow_protection //Invulnerable and pacifistic
#define STATUS_EFFECT_SLIMESKIN /datum/status_effect/slimeskin //Increased armor

// Grouped effect sources, see also code/__DEFINES/traits.dm

#define STASIS_SHAPECHANGE_EFFECT "stasis_shapechange"

/// Causes the mob to become blind via the passed source
#define become_blind(source) apply_status_effect(/datum/status_effect/grouped/blindness, source)
/// Cures the mob's blindness from the passed source, removing blindness wholesale if no sources are left
#define cure_blind(source) remove_status_effect(/datum/status_effect/grouped/blindness, source)

/// Is the mob blind?
#define is_blind(...) has_status_effect(/datum/status_effect/grouped/blindness)
/// Is the mob blind from the passed source or sources?
#define is_blind_from(sources) has_status_effect_from_source(/datum/status_effect/grouped/blindness, sources)

/// Causes the mob to become nearsighted via the passed source
#define become_nearsighted(source) apply_status_effect(/datum/status_effect/grouped/nearsighted, source)
/// Cures the mob's nearsightedness from the passed source, removing nearsighted wholesale if no sources are left
#define cure_nearsighted(source) remove_status_effect(/datum/status_effect/grouped/nearsighted, source)

/// Is the mob nearsighted?
#define is_nearsighted(...) has_status_effect(/datum/status_effect/grouped/nearsighted)
/// Is the mob nearsigthed from the passed source or sources?
#define is_nearsighted_from(sources) has_status_effect_from_source(/datum/status_effect/grouped/nearsighted, sources)
/// Is the mob nearsighted CURRENTLY?
/// This check fails if the mob is nearsighted but is wearing glasses,
/// While is_nearsighted will always succeed even if they are wearing glasses.
/mob/proc/is_nearsighted_currently()
	var/datum/status_effect/grouped/nearsighted/nearsight = has_status_effect(/datum/status_effect/grouped/nearsighted)
	if(isnull(nearsight))
		return FALSE
	return nearsight.should_be_nearsighted()

// Status effect application helpers.
// These are macros for easier use of adjust_timed_status_effect and set_timed_status_effect.
//
// adjust_x:
// - Adds duration to a status effect
// - Removes duration if a negative duration is passed.
// - Ex: adjust_stutter(10 SECONDS) adds ten seconds of stuttering.
// - Ex: adjust_jitter(-5 SECONDS) removes five seconds of jittering, or just removes jittering if less than five seconds exist.
//
// adjust_x_up_to:
// - Will only add (or remove) duration of a status effect up to the second parameter
// - If the duration will result in going beyond the second parameter, it will stop exactly at that parameter
// - The second parameter cannot be negative.
// - Ex: adjust_stutter_up_to(20 SECONDS, 10 SECONDS) adds ten seconds of stuttering.
//
// set_x:
// - Set the duration of a status effect to the exact number.
// - Setting duration to zero seconds is effectively the same as just using remove_status_effect, or qdelling the effect.
// - Ex: set_stutter(10 SECONDS) sets the stuttering to ten seconds, regardless of whether they had more or less existing stutter.
//
// set_x_if_lower:
// - Will only set the duration of that effect IF any existing duration is lower than what was passed.
// - Ex: set_stutter_if_lower(10 SECONDS) will set stuttering to ten seconds if no stuttering or less than ten seconds of stuttering exists
// - Ex: set_jitter_if_lower(20 SECONDS) will do nothing if more than twenty seconds of jittering already exists

#define adjust_dizzy(duration) adjust_timed_status_effect(duration, /datum/status_effect/dizziness)
#define adjust_dizzy_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/dizziness, up_to)
#define set_dizzy(duration) set_timed_status_effect(duration, /datum/status_effect/dizziness)
#define set_dizzy_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/dizziness, TRUE)

#define adjust_jitter(duration) adjust_timed_status_effect(duration, /datum/status_effect/jitter)
#define adjust_jitter_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/jitter, up_to)
#define set_jitter(duration) set_timed_status_effect(duration, /datum/status_effect/jitter)
#define set_jitter_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/jitter, TRUE)

#define adjust_confusion(duration) adjust_timed_status_effect(duration, /datum/status_effect/confusion)
#define adjust_confusion_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/confusion, up_to)
#define set_confusion(duration) set_timed_status_effect(duration, /datum/status_effect/confusion)
#define set_confusion_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/confusion, TRUE)

#define adjust_drugginess(duration) adjust_timed_status_effect(duration, /datum/status_effect/drugginess)
#define adjust_drugginess_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/drugginess, up_to)
#define set_drugginess(duration) set_timed_status_effect(duration, /datum/status_effect/drugginess)
#define set_drugginess_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/drugginess, TRUE)

#define adjust_silence(duration) adjust_timed_status_effect(duration, /datum/status_effect/silenced)
#define adjust_silence_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/silenced, up_to)
#define set_silence(duration) set_timed_status_effect(duration, /datum/status_effect/silenced)
#define set_silence_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/silenced, TRUE)

#define adjust_drowsiness(duration) adjust_timed_status_effect(duration, /datum/status_effect/drowsiness)
#define adjust_drowsiness_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/drowsiness, up_to)
#define set_drowsiness(duration) set_timed_status_effect(duration, /datum/status_effect/drowsiness)
#define set_drowsiness_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/drowsiness, TRUE)

#define adjust_eye_blur(duration) adjust_timed_status_effect(duration, /datum/status_effect/eye_blur)
#define adjust_eye_blur_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/eye_blur, up_to)
#define set_eye_blur(duration) set_timed_status_effect(duration, /datum/status_effect/eye_blur)
#define set_eye_blur_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/eye_blur, TRUE)

#define adjust_temp_blindness(duration) adjust_timed_status_effect(duration, /datum/status_effect/temporary_blindness)
#define adjust_temp_blindness_up_to(duration, up_to) adjust_timed_status_effect(duration, /datum/status_effect/temporary_blindness, up_to)
#define set_temp_blindness(duration) set_timed_status_effect(duration, /datum/status_effect/temporary_blindness)
#define set_temp_blindness_if_lower(duration) set_timed_status_effect(duration, /datum/status_effect/temporary_blindness, TRUE)
