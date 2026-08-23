/datum/component/combat_vocalizer
	/// List of lines to say on aggro/during combat. Can be a list of strings or a path to a file.
	var/list/aggro_lines
	/// List of lines to say on death.
	var/list/death_lines
	/// Cooldown between combat barks (say() calls during handle_combat equivalent)
	var/bark_cooldown = 8 SECONDS
	/// Cooldown between emotes during combat
	var/emote_cooldown = 5 SECONDS
	/// Chance per planning tick to bark
	var/bark_chance = 3
	/// Chance per planning tick to emote
	var/emote_chance = 5

	COOLDOWN_DECLARE(last_bark)
	COOLDOWN_DECLARE(last_emote)

/datum/component/combat_vocalizer/Initialize(list/lines, list/death_lines, bark_cooldown, emote_cooldown, bark_chance, emote_chance)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	src.aggro_lines = lines
	src.death_lines = death_lines
	if(!isnull(bark_cooldown))
		src.bark_cooldown = bark_cooldown
	if(!isnull(emote_cooldown))
		src.emote_cooldown = emote_cooldown
	if(!isnull(bark_chance))
		src.bark_chance = bark_chance
	if(!isnull(emote_chance))
		src.emote_chance = emote_chance

	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(parent, COMSIG_AI_BLACKBOARD_KEY_SET(BB_BASIC_MOB_CURRENT_TARGET), PROC_REF(on_target_acquired))
	RegisterSignal(parent, COMSIG_MOB_TRY_BARK, PROC_REF(try_combat_bark))
	RegisterSignal(parent, COMSIG_MOB_MODIFY_AGGRO_LINES, PROC_REF(try_modify_aggro_lines))
	RegisterSignal(parent, COMSIG_MOB_MODIFY_DEATH_LINES, PROC_REF(try_modify_death_lines))

/datum/component/combat_vocalizer/Destroy(force)
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_LIVING_DEATH,
		COMSIG_AI_BLACKBOARD_KEY_SET(BB_BASIC_MOB_CURRENT_TARGET),
	))

/datum/component/combat_vocalizer/proc/on_target_acquired(mob/living/source, key)
	if(!COOLDOWN_FINISHED(src, last_bark))
		return
	if(!length(aggro_lines))
		return
	var/mob/living/target = source.ai_controller?.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!target)
		return
	source.say(pick(aggro_lines))
	source.pointed(target)
	COOLDOWN_START(src, last_bark, bark_cooldown)

/datum/component/combat_vocalizer/proc/try_combat_bark(mob/living/source, prob_override)
	if(!COOLDOWN_FINISHED(src, last_bark))
		return
	if(!length(aggro_lines))
		return
	var/chance = prob_override ? prob_override : bark_chance
	if(!prob(chance))
		return
	if(aggro_lines)
		source.say(pick(aggro_lines))
	COOLDOWN_START(src, last_bark, bark_cooldown)

/datum/component/combat_vocalizer/proc/on_death(mob/living/source)
	if(!length(death_lines))
		return
	if(death_lines)
		source.say(pick(death_lines), forced = TRUE)
	source.emote("painscream")

/datum/component/combat_vocalizer/proc/try_modify_death_lines(mob/living/source, list/incoming_lines, override)
	if(override)
		death_lines = list()
	death_lines += incoming_lines

/datum/component/combat_vocalizer/proc/try_modify_aggro_lines(mob/living/source, list/incoming_lines, override)
	if(override)
		aggro_lines = list()
	aggro_lines += incoming_lines
