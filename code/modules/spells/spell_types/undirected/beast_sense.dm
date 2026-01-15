/datum/action/cooldown/spell/undirected/beast_sense
	name = "Beastial Senses"
	desc = "Grants the Dendorite a keen sense of smell and excellent vision, to better hunt with."
	button_icon_state = "bestialsense"
	sound = 'sound/vo/smokedrag.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/dendor)
	attunements = list(
		/datum/attunement/earth = 0.5,
	)

	invocation = "Beast-Lord, lend me the eyes of the zad, the nose of the volf."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 10 MINUTES
	spell_cost = 20

/datum/action/cooldown/spell/undirected/beast_sense/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/C = owner
	var/obj/item/organ/eyes/eyes = C.getorgan(/obj/item/organ/eyes)
	if(!eyes)
		if(feedback)
			to_chat(owner, span_warning("The tree father can not restore my eyes."))
		return FALSE

/datum/action/cooldown/spell/undirected/beast_sense/cast(atom/cast_on)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(grant_status)), rand(5 SECONDS, 9 SECONDS))

/datum/action/cooldown/spell/undirected/beast_sense/proc/grant_status()
	var/mob/living/carbon/C = owner
	to_chat(C, span_greentext("A raven passes overhead... your prayer was heard!"))
	playsound(C, 'sound/vo/mobs/bird/CROW_01.ogg', 60, TRUE, -1)
	C.apply_status_effect(/datum/status_effect/buff/beastsense)
