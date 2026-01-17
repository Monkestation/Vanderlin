/// Version used by werewolf antag
/datum/action/cooldown/spell/undirected/werewolf_form
	name = "Release your Rage"
	desc = "Be free from your restraints take your primal form once again."
	button_icon_state = "tamebeast"

	spell_type = SPELL_RAGE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	has_visual_effects = FALSE

	invocation = "THE BEAST UNLEASHED!"
	invocation_type = INVOCATION_SHOUT
	ignore_can_speak = TRUE

	charge_required = FALSE
	cooldown_time = 3.5 MINUTES
	spell_cost = 0

	sound = 'sound/vo/mobs/wwolf/roar.ogg'

/datum/action/cooldown/spell/undirected/werewolf_form/Grant(mob/grant_to)
	if(!IS_WEREWOLF(grant_to))
		return
	return ..()

/datum/action/cooldown/spell/undirected/werewolf_form/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(owner))
		return FALSE
	var/datum/antagonist/werewolf/werewolf_antag = IS_WEREWOLF(owner)
	if(!werewolf_antag)
		return FALSE
	if(werewolf_antag.transformed)
		return FALSE
	var/mob/living/carbon/human/human = owner
	if(!human.rage_datum?.check_rage(text2num(WW_RAGE_MEDIUM)))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/undirected/werewolf_form/cast(atom/cast_on)
	. = ..()
	var/datum/antagonist/werewolf/werewolf_antag = IS_WEREWOLF(owner)
	werewolf_antag?.begin_transform()
