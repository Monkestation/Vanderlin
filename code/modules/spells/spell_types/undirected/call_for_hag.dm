#define LIST_CALLS list ("Matron, where are you?", "Matron?", "Matron where did you go?")

#define LIST_CALLS_HELP list ("Help", "I need help", "Aaah, help me", "Matron save me", "They are going to get me", "I am just an orphan, please")

/datum/action/cooldown/spell/undirected/call_for_hag
	name = "Call for That Hag"
	desc = "Callout to the Matron. If you are fighting, you can call out for help..."
	button_icon_state = "message"

	spell_type = NONE
	charge_required = FALSE
	sound = null
	has_visual_effects = FALSE

	cooldown_time = 2 MINUTES
	var/list/matrons = list() //In case we have multiple matrons through admemes

/datum/action/cooldown/spell/undirected/call_for_hag/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(QDELETED(src) || QDELETED(cast_on) || !can_cast_spell() || !iscarbon(owner))
		return . | SPELL_CANCEL_CAST

	var/mob/living/carbon/caster = owner // need to be carbon for these checks

	if(!caster.can_speak_vocal() || caster.mouth?.muteinmouth || HAS_TRAIT(caster, TRAIT_BAGGED))
		to_chat(owner, span_red("I am unable to yell out to her!"))
		return . | SPELL_CANCEL_CAST

	matrons = list() //reset list
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.job == JOB_MATRON && !(HL in matrons) && HL.stat < UNCONSCIOUS) // Is a Matron and not unconscious or dead
			matrons += HL

/datum/action/cooldown/spell/undirected/call_for_hag/cast(atom/cast_on)
	. = ..()
	// if cmode, its a cry for help
	var/what_to_yell
	if(owner.cmode)
		what_to_yell = pick(LIST_CALLS_HELP)
		owner.emote("scream")
	else
		what_to_yell = pick(LIST_CALLS)
	owner.say("[what_to_yell]!!", spans = list("reallybig"))

	for(var/mob/living/carbon/human/matron in matrons)
		if(!matron.mind)
			continue

		to_chat(matron, span_reallybig("[what_to_yell]!!"))
		if(owner.cmode) // The Orphans need me!
			matron.add_stress(/datum/stress_event/orphan_calling_help)
			to_chat(matron, span_warning("That was [owner.real_name]'s voice!"))
		else
			matron.add_stress(/datum/stress_event/orphan_calling)
			to_chat(matron, span_notice("That sounded like it came from [owner.real_name]..."))


#undef LIST_CALLS
#undef LIST_CALLS_HELP
