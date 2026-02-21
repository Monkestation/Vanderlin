GLOBAL_LIST_EMPTY(patron_list)
GLOBAL_LIST_EMPTY(patrons_by_faith)
GLOBAL_LIST_EMPTY(prayers)

/datum/patron
	abstract_type = /datum/patron
	/// Name of the god
	var/name
	/// Display name of the patron in the prefs menu
	var/display_name
	/// Domain of the god, such as earth, fire, water, murder etc
	var/domain = "Bad coding practices"
	/// Description of the god
	var/desc = "A god that ordains you to report this on GitHub - You shouldn't be seeing this, someone forgot to set the description of this patron."
	/// String that represents who worships this guy
	var/worshippers = "Shitty coders"
	///String that represents the god's flaws
	var/flaws = "This spagetti code"
	///Strong that represents what this god views as sins
	var/sins = "Codersocks"
	/// What boons the god may offer
	var/boons = "Code errors"
	/// Faith this god belongs to
	var/datum/faith/associated_faith = null
	/// All gods have related confessions
	var/list/confess_lines

	/// Devotion datum type associated with this god
	var/datum/devotion/devotion_holder = null

	/// List of words that this god considers profane.
	var/list/profane_words = list()

	///our traits thats applied by set_patron and removed when changed
	var/list/added_traits

	///verbs applied by set_patron and removed when changed
	var/list/added_verbs

	//If the patron has a specific specie worshipping them.
	var/list/allowed_races

	var/datum/storyteller/storyteller

/datum/patron/proc/preference_accessible(datum/preferences/prefs)
	if(length(allowed_races) && !(prefs.pref_species.id in allowed_races))
		return FALSE

	return TRUE

/datum/patron/proc/on_gain(mob/living/pious)
	for(var/trait in added_traits)
		ADD_TRAIT(pious, trait, "[type]")
	for(var/verb in added_verbs)
		add_verb(pious, verb)

/datum/patron/proc/on_remove(mob/living/pious)
	for(var/trait in added_traits)
		REMOVE_TRAIT(pious, trait, "[type]")
	for(var/verb in added_verbs)
		remove_verb(pious, verb)

/* -----PRAYERS----- */

/// Called when a patron's follower attempts to pray.
/// Returns TRUE if they satisfy the needed conditions.
/datum/patron/proc/can_pray(mob/living/follower)
	return TRUE

/// Called when a patron's follower prays to them.
/// Returns TRUE if their prayer was heard and the patron was not insulted
/datum/patron/proc/hear_prayer(mob/living/follower, message)
	if(!follower || !message)
		return FALSE
	var/prayer = SANITIZE_HEAR_MESSAGE(message)

	if(length(profane_words))
		for(var/profanity in profane_words)
			if(findtext(prayer, profanity))
				punish_prayer(follower)
				return FALSE

	if(length(prayer) <= 15)
		to_chat(follower, span_danger("My prayer was kinda short..."))
		return FALSE

	. = TRUE //the prayer has succeeded by this point forward
	GLOB.prayers |= prayer
	record_featured_stat(FEATURED_STATS_DEVOUT, follower)
	record_round_statistic(STATS_PRAYERS_MADE)

	if(findtext(prayer, name))
		reward_prayer(follower)

/// The follower has somehow offended the patron and is now being punished.
/datum/patron/proc/punish_prayer(mob/living/follower)
	follower.adjust_divine_fire_stacks(100)
	follower.IgniteMob()
	record_round_statistic(STATS_PEOPLE_SMITTEN)
	follower.add_stress(/datum/stress_event/psycurse)

/// The follower has prayed in a special way to the patron and is being rewarded.
/datum/patron/proc/reward_prayer(mob/living/follower)
	SHOULD_CALL_PARENT(TRUE)

	follower.playsound_local(follower, 'sound/misc/notice (2).ogg', 100, FALSE)
	follower.add_stress(/datum/stress_event/psyprayer)
