/datum/action/cooldown/spell/undirected/werewolf_form
	name = "Release your Rage"
	desc = "Be free from your restraints take your primal form once again."
	button_icon_state = "tamebeast"

	spell_type = SPELL_RAGE
	antimagic_flags = MAGIC_RESISTANCE_HOLY

	invocation = "DENDOR LEND ME YOUR POWER!!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 3.5 MINUTES
	spell_cost = 0

	sound = 'sound/vo/mobs/wwolf/roar.ogg'

/datum/action/cooldown/spell/undirected/werewolf_form/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(owner))
		return FALSE
	var/mob/living/carbon/human/human = owner
	if(is_species(human, /datum/species/werewolf))
		return FALSE
	if(!human.rage_datum)
		return FALSE
	if(!human.rage_datum.check_rage(text2num(RAGE_LEVEL_HIGH)))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/undirected/werewolf_form/cast(atom/cast_on)
	. = ..()
	transformation()

/datum/action/cooldown/spell/undirected/werewolf_form/proc/transformation()
	var/mob/living/carbon/human/human = owner
	human.werewolf_transform()
