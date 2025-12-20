/datum/action/cooldown/spell/beast_tame
	name = "Tame Beast"
	desc = "Attempt to turn a beast of Dendor to your favor."
	button_icon_state = "tamebeast"
	sound = 'sound/vo/smokedrag.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'
	self_cast_possible = FALSE

	cast_range = 5
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/dendor)
	attunements = list(
		/datum/attunement/earth = 1,
	)

	invocation = "Be still and calm, brotherbeast."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 6 MINUTES
	spell_cost = 60

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

/datum/action/cooldown/spell/beast_tame/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return istype(cast_on, /mob/living/simple_animal/hostile/retaliate)

/datum/action/cooldown/spell/beast_tame/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/mob/living/simple_animal/hostile/retaliate/SP = cast_on
	if(!SP.dendor_taming_chance || !SP.ai_controller || (SP.mob_biotypes & MOB_UNDEAD))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/beast_tame/cast(mob/living/simple_animal/hostile/retaliate/cast_on)
	. = ..()
	if(!prob(cast_on.dendor_taming_chance))
		to_chat(owner, span_warning("\The [cast_on] resists your soothing!"))
		return

	owner.visible_message(
		span_greentext("[owner] soothes \the [cast_on] with Dendor's whisper."),
		span_notice("I tame the beast with Dendor's whisper."),
	)

	cast_on.LoadComponent(/datum/component/obeys_commands, pet_commands)
	cast_on.ai_controller.can_idle = FALSE
	cast_on.ai_controller.add_to_top(/datum/ai_planning_subtree/pet_planning)
	cast_on.ai_controller.CancelActions()
	cast_on.ai_controller.set_blackboard_key(BB_PET_TARGETING_DATUM, new /datum/targetting_datum/basic/not_friends())
	cast_on.befriend(owner)
	cast_on.pet_passive = TRUE
	cast_on.tamed(owner)

	if(HAS_TRAIT(owner, TRAIT_DENDOR_GROWING))
		ADD_TRAIT(cast_on, TRAIT_ENTANGLER_IMMUNE, MAGIC_TRAIT)
	if(HAS_TRAIT(owner, TRAIT_DENDOR_STINGING))
		ADD_TRAIT(cast_on, TRAIT_KNEESTINGER_IMMUNITY, MAGIC_TRAIT)
	if(HAS_TRAIT(owner, TRAIT_DENDOR_DEVOURING))
		ADD_TRAIT(cast_on, TRAIT_CRITICAL_RESISTANCE, MAGIC_TRAIT)
	if(HAS_TRAIT(owner, TRAIT_DENDOR_LORDING))
		ADD_TRAIT(cast_on, TRAIT_CRITICAL_RESISTANCE, MAGIC_TRAIT)
