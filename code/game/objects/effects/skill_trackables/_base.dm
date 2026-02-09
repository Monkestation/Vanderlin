
//Analysis levels depending on skillcheck during reveal.
#define ANALYSIS_TERRIBLE 1
#define ANALYSIS_BAD 2
#define ANALYSIS_DECENT 3
#define ANALYSIS_GOOD 4
#define ANALYSIS_PERFECT 5

/obj/effect/skill_tracker
	name = "\improper track"
	desc = null
	anchored = TRUE
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	invisibility = INVISIBILITY_MAXIMUM
	///The visible state for those that know this.
	var/real_icon_state = "tracks"
	///The image knowers see.c
	var/image/real_image
	///List of mobs aware of this track.
	var/list/mob/living/known_by = list()
	///When this was created. Adjusts difficulty of locating / analyzing.
	var/creation_time = 0
	///What kind of foot, or footwear, created this.
	var/track_type = "codersock tracks"
	///Like above, except what you get if you are not good.
	var/ambiguous_track_type = "footwear tracks"
	///The way the mob was facing when this was created. Obviously can be messed with if you e.g. walk backwards.
	var/facing = "nowhere"
	///If the depth of the tracks is abnormal, e.g. because of heavy armor.
	var/depth
	///If the creator was moving in a special way, e.g. running / sneaking. Difficult to discern.
	var/special_movement
	///The exact mob that created this. Only used to see if the spotter can notice their own tracks (fairly easy)
	var/mob/living/creator
	///Some things may be easier or harder to track. This adjusts the base difficulty accordingly.
	var/tracking_modifier = 0
	///Tracks how many tracks have been chain-overwritten before this track. Could indicate a commonly passed area.
	var/overwrites = 0
	///The timer handling deletion. Saved to potentially adjust it.
	var/deletion_timer
	///the trait we check incase we are always revealed to the mob
	var/always_revealed_trait
	///the skill we care about
	var/datum/skill/reveal_skill = /datum/skill/craft/alchemy
	///do we give xp to those who find us?
	var/adds_xp_on_reveal = FALSE

	var/static/list/mobs_with_trait = list()

/obj/effect/skill_tracker/Initialize(mapload, atom/parent)
	. = ..()
	if(!parent)
		parent = get_turf(src)
	real_image = image(icon, parent, real_icon_state, BULLET_HOLE_LAYER) //Default image in case manually created.
	real_image.alpha = alpha
	SStrackables.add_new_trackable(src)
	if(always_revealed_trait)
		check_for_users()

/obj/effect/skill_tracker/Destroy(force)
	real_image = null
	for(var/knowing_one as anything in known_by)
		remove_knower(knowing_one)
	if(creator)
		clear_creator_reference(creator)
	known_by = null
	if(deletion_timer)
		deltimer(deletion_timer)
		deletion_timer = null
	SStrackables.remove_trackable(src)
	return ..()

/obj/effect/skill_tracker/proc/check_for_users()
	for(var/datum/weakref/weak as anything in mobs_with_trait[always_revealed_trait])
		var/mob/living/living = weak.resolve()
		if(QDELETED(living) || !living)
			continue
		add_knower(living, ANALYSIS_PERFECT)

///Handles checks for if a mob can reveal this. Also returns FALSE if already known to mob.
/obj/effect/skill_tracker/proc/check_reveal(mob/living/user)
	if(user in known_by)
		return FALSE
	var/success = FALSE
	if(!HAS_TRAIT(user, always_revealed_trait))
		var/diff = 11 //Base Tracking Difficulty
		diff += tracking_modifier
		//diff += round((world.time - creation_time) / (60 SECONDS), 1) //Gets more difficult to spot the older.
		diff += rand(0, 5) //Entropy.

		var/competence = user.STAPER
		if(user.mind)
			competence += 2 * user.get_skill_level(reveal_skill, TRUE)

		if(competence >= diff)
			success = TRUE
		else if(diff - competence < 5)
			success = prob((100 - ((diff - competence) * 20)))
	else
		success = TRUE
	if(success && user.mind && creator != user && adds_xp_on_reveal)
		user.mind.add_sleep_experience(reveal_skill, (user.STAINT*2))
	return success

///Handles revealing the track, including checking how well the tracker can analyze it.
/obj/effect/skill_tracker/proc/handle_revealing(mob/living/user)
	//Second layer of skill check: How much knowledge you get.
	var/analysis_result = 0
	if(!HAS_TRAIT(user, always_revealed_trait))
		var/diff = 11
		diff += tracking_modifier
		//diff += round((world.time - creation_time) / (60 SECONDS), 1)
		var/competence = user.STAPER / 2
		if(user.mind)
			competence += 5 * user.get_skill_level(reveal_skill, TRUE) //Skill is much more relevant for analysis.
		switch(competence - diff)
			if(18 to INFINITY)
				analysis_result = ANALYSIS_PERFECT
			if(12 to 18)
				analysis_result = ANALYSIS_GOOD
			if(6 to 12)
				analysis_result = ANALYSIS_DECENT
			if(0 to 6)
				analysis_result = ANALYSIS_BAD
			if(-INFINITY to 0)
				analysis_result = ANALYSIS_TERRIBLE
	else
		analysis_result = ANALYSIS_PERFECT
	add_knower(user, analysis_result)

///Adds a new person to the list of people who can see this track.
/obj/effect/skill_tracker/proc/add_knower(mob/living/tracker, competence = 1)
	known_by[tracker] = competence
	if(tracker.client)
		tracker.client.images |= real_image
	RegisterSignal(tracker, COMSIG_PARENT_QDELETING, PROC_REF(remove_knower), override = TRUE)

///Removes a knower from the known ones. Usually only done when qdeleted.
/obj/effect/skill_tracker/proc/remove_knower(mob/living/tracker)
	SIGNAL_HANDLER
	UnregisterSignal(tracker, COMSIG_PARENT_QDELETING)
	if(tracker.client)
		tracker.client.images -= real_image
	known_by -= tracker
	if(creator == tracker)
		creator = null

///Clears the reference to the creator. Is replaced by the above proc if the creator analyzes it.
/obj/effect/skill_tracker/proc/clear_creator_reference(mob/living/creator_arg)
	SIGNAL_HANDLER
	UnregisterSignal(creator, COMSIG_PARENT_QDELETING)
	creator = null

#undef ANALYSIS_TERRIBLE
#undef ANALYSIS_BAD
#undef ANALYSIS_DECENT
#undef ANALYSIS_GOOD
#undef ANALYSIS_PERFECT
