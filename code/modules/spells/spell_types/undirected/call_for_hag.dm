#define LIST_CALLS list ("Matron, where are you?", "Matron?", "Matron where did you go?")

#define LIST_CALLS_HELP list ("Matron, help", "I need help Matron", "Aaah, help me Matron", "Matron save me")

/datum/action/cooldown/spell/undirected/call_for_hag
	name = "Call for the Hag"
	desc = "Callout to the Matron."
	button_icon_state = "message"

	spell_type = NONE
	charge_required = FALSE
	sound = null
	has_visual_effects = FALSE

	charge_required = FALSE
	cooldown_time = 5 SECONDS //change to 2 MINUTE later
	var/list/matrons = list() //In case we have multiple matrons through admemes

/datum/action/cooldown/spell/undirected/call_for_hag/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(QDELETED(src) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(!owner.can_speak_vocal() || owner.mouth?.muteinmouth || HAS_TRAIT(C, TRAIT_BAGGED))
		to_chat(owner, span_red("I am unable to yell out to her!"))
		return . | SPELL_CANCEL_CAST

	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.job == "Matron")
			matrons += HL

	if(!matrons)
		to_chat(owner, span_red("You recall that the Matron is too far away to hear you..."))
		return . | SPELL_CANCEL_CAST

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
			to_chat(matron, span_warning("That was [owner]'s voice!"))
		else
			matron.add_stress(/datum/stress_event/orphan_calling)
			to_chat(matron, span_notice("That sounded like it came from [owner]..."))


#undef LIST_CALLS
#undef LIST_CALLS_HELP
