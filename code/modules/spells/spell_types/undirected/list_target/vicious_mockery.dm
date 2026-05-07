#define MOCKERY_STACKS_MAX 2
#define MOCKERY_STACK_DURATION 30 SECONDS
#define MOCKERY_STAT_PER_STACK -1 // Each stack applies this to STR, SPD, INT, WIL
#define MOCKERY_COOLDOWN 20 SECONDS

/datum/action/cooldown/spell/projectile/vicious_mockery
	name = "Vicious Mockery"
	desc = "Hurl a musical insult at your target. Stacks up to 2 times, increasingly reducing their stats."
	button_icon_state = "tragedy"
	sound = 'sound/magic/mockery.ogg'

	projectile_type = /obj/projectile/magic/mockery_note
	cast_range = 7

	has_visual_effects = FALSE
	spell_type = NONE

	invocation_type = INVOCATION_NONE
	charge_required = TRUE
	charge_time = 0.5 SECONDS
	charge_slowdown = 0
	cooldown_time = MOCKERY_COOLDOWN

	associated_skill = /datum/attribute/skill/misc/music
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/projectile/vicious_mockery/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/target = cast_on
	if(!ishuman(H))
		return
	var/message
	if(ishuman(target))
		if(check_strings("bard.json", "[target.dna.species.id]_mockery"))
			message = pick_list_replacements("bard.json", "[target.dna.species.id]_mockery")
		else
			message = pick_list_replacements("bard.json", "default_mockery")
	else
		message = pick_list_replacements("bard.json", "default_mockery")

	H.say(message, forced = "spell")
	. = ..()

/obj/projectile/magic/mockery_note
	name = "vicious note"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "mockery_note"
	damage = 0
	nodamage = TRUE
	speed = 1
	range = 8
	hitsound = 'sound/magic/mockery.ogg'

/obj/projectile/magic/mockery_note/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(!M.can_hear())
			visible_message(span_warning("The insult falls on deaf ears!"))
			qdel(src)
			return BULLET_ACT_BLOCK
		var/datum/status_effect/debuff/mockery_stack/existing = M.has_status_effect(/datum/status_effect/debuff/mockery_stack)
		if(existing)
			existing.add_stack()
		else
			M.apply_status_effect(/datum/status_effect/debuff/mockery_stack)
		if(firer)
			SEND_SIGNAL(firer, COMSIG_VICIOUSLY_MOCKED, target)
		playsound(get_turf(target), hitsound, 60, TRUE)
	return ..()

/datum/status_effect/debuff/mockery_stack
	id = "mockery_stack"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/mockery_stack
	duration = MOCKERY_STACK_DURATION
	var/stacks = 1

/atom/movable/screen/alert/status_effect/debuff/mockery_stack
	name = "Vicious Mockery"
	desc = "<span class='warning'>That bard's words cut deeper than any blade!</span>\n"

/datum/status_effect/debuff/mockery_stack/on_apply()
	. = ..()
	apply_stack_effects()
	owner.balloon_alert_to_viewers("mocked (x[stacks])")
	owner.visible_message(
		span_warning("[owner] flinches from the mockery!"),
		span_userdanger("The bard's words sting - I can't focus!"))

/datum/status_effect/debuff/mockery_stack/proc/add_stack()
	if(stacks >= MOCKERY_STACKS_MAX)
		duration = MOCKERY_STACK_DURATION
		return
	remove_stack_effects()
	stacks = min(stacks + 1, MOCKERY_STACKS_MAX)
	duration = MOCKERY_STACK_DURATION
	apply_stack_effects()
	owner.balloon_alert_to_viewers("mocked (x[stacks])")
	if(stacks >= MOCKERY_STACKS_MAX)
		to_chat(owner, span_userdanger("The mockery digs deeper - I can barely think straight!"))
	update_alert()

/datum/status_effect/debuff/mockery_stack/proc/apply_stack_effects()
	if(!owner)
		return
	var/penalty = stacks * MOCKERY_STAT_PER_STACK
	var/list/stats = list(STATKEY_STR = penalty, STATKEY_SPD = penalty, STATKEY_INT = penalty, STATKEY_WIL = penalty)
	owner?.attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/mockery, TRUE, stats)
	for(var/statkey in effectedstats)
		owner.change_stat(statkey, effectedstats[statkey])

/datum/status_effect/debuff/mockery_stack/proc/remove_stack_effects()
	if(!owner || !effectedstats)
		return
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/mockery)

/datum/status_effect/debuff/mockery_stack/proc/update_alert()
	if(!linked_alert)
		return
	linked_alert.name = "Vicious Mockery ([stacks]/[MOCKERY_STACKS_MAX])"

/datum/status_effect/debuff/mockery_stack/on_remove()
	remove_stack_effects()
	to_chat(owner, span_info("The sting of mockery fades."))
	. = ..()

#undef MOCKERY_STACKS_MAX
#undef MOCKERY_STACK_DURATION
#undef MOCKERY_STAT_PER_STACK
#undef MOCKERY_COOLDOWN
