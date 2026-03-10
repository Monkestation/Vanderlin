/datum/action/cooldown/spell/undirected/will_of_woods
	name = "Will of the Woods"
	desc = "Summon the aid of the woods."
	button_icon_state = "tamebeast"
	sound = 'sound/magic/timestop.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation = "Fear the wrath of the woods!"
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_cost = 40

/datum/action/cooldown/spell/undirected/will_of_woods/cast(atom/cast_on)
	. = ..()
	if(!isliving(owner))
		return
	var/mob/living/carbon/hunter = owner

	var/random_ambushes = 4 + rand(0,2) // 4 - 6 ambushes
	for(var/i = 0, i < random_ambushes, i++)
		hunter.consider_ambush(TRUE, TRUE, min_dist = 2, max_dist = 9)
