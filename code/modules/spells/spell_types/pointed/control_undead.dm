/datum/action/cooldown/spell/control_undead
	name = "Control Undead"
	desc = "Attempt to make an undead your ally."
	button_icon_state = "raiseskele"
	sound = 'sound/vo/smokedrag.ogg'
	self_cast_possible = FALSE

	cast_range = 5
	spell_type = SPELL_MANA
	antimagic_flags = MAGIC_RESISTANCE_UNHOLY
	associated_skill = /datum/skill/magic/arcane
	attunements = list(
		/datum/attunement/death = 1,
	)

	invocation = "Obey me."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 1 MINUTES
	spell_cost = 75

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/datum/action/cooldown/spell/control_undead/is_valid_target(mob/living/cast_on)
	. = ..()
	if(!.)
		return
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/victim = cast_on
	if(victim.mind || victim.stat == DEAD)
		return FALSE
	return (victim.mob_biotypes & MOB_UNDEAD)

/datum/action/cooldown/spell/control_undead/cast(mob/living/cast_on)
	. = ..()
	cast_on.LoadComponent(/datum/component/obeys_commands, pet_commands)
	cast_on.ai_controller.CancelActions()
	cast_on.ai_controller.set_blackboard_key(BB_PET_TARGETING_DATUM, new /datum/targetting_datum/basic/not_friends())
	cast_on.faction = list("Cabal", "Undead")
	cast_on.befriend(owner)
	cast_on.pet_passive = TRUE

	owner.visible_message(
		span_greentext("[owner] soothes \the [cast_on] with zizo's blessing."),
		span_notice("The creacher now obeys me."),
	)
