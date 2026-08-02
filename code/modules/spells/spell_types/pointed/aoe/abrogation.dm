//Ported from Azure Peak made by Ephemeralis ?

/datum/action/cooldown/spell/aoe/abrogation
	name = "Abrogation"
	desc = "Bring forth motes of the Undermaiden to weaken the unliving."
	button_icon_state = "necra"
	sound = 'sound/magic/churn.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross)

	invocation = "The Undermaiden rejects your presence!"
	invocation_type = INVOCATION_SHOUT

	click_to_activate = FALSE
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_cost = 20

	aoe_radius = 7

/datum/action/cooldown/spell/aoe/abrogation/feedback(had_targets)
	if(!had_targets)
		to_chat(owner, span_notice("The rite of Abrogation passes from my lips in silence, having found nothing to assail."))
		return
	owner.visible_message(
		span_warning("A frigid blue glower suddenly erupts in [owner]'s eyes as a whispered prayer summons forth a winding veil of ghostly mists!"),
		span_notice("I perform the sacred rite of Abrogation, bringing forth Her servants to harry and weaken the unliving!"),
	)

/datum/action/cooldown/spell/aoe/abrogation/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/aoe/abrogation/cast_on_thing_in_aoe(mob/living/victim, atom/caster)
	if(victim.stat == DEAD)
		return
	if(victim.mind)
		if(victim.mind.has_antag_datum(/datum/antagonist/vampire/lord))
			owner.visible_message(
				span_warning("[owner] suddenly pales before an unseen presence, and gasps!"),
				span_warning("The sound of rushing blood fills my ears and mind, drowning out my abrogation!"),
			)
			owner.emote("gasp", forced = "[src]")
			if(isliving(owner))
				var/mob/living/fool = owner
				fool.Stun(50)
			owner.throw_at(get_ranged_target_turf(owner, get_dir(owner, victim), 7), 7, 1, victim, spin = FALSE)
			return TRUE
	if((victim.mob_biotypes & MOB_UNDEAD))
		victim.apply_status_effect(/datum/status_effect/debuff/abrogation, null, owner, clamp(round(GET_MOB_SKILL_VALUE_OLD(owner, associated_skill)), 1 , 3))

/atom/movable/screen/alert/status_effect/debuff/abrogation
	name = "Churning Essence"
	desc = "The magicks that bind me into being are being disrupted! I should get away from the source as soon as I can!"
	icon_state = "stressvb"

// This should be stacking
/datum/status_effect/debuff/abrogation
	id = "abrogation"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/abrogation
	duration = 30 SECONDS
	examine_text = "<b>SUBJECTPRONOUN is wreathed in a wild frenzy of ghostly motes!</b>"
	effectedstats = list(STAT_STRENGTH = -2, STAT_CONSTITUTION = -2, STAT_ENDURANCE = -2, STAT_SPEED = -2)
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 2 DECISECONDS
	var/datum/weakref/debuffer
	var/outline_colour = "#33cabc"
	var/base_tick = 0.2
	var/intensity = 1
	var/range = 10

/datum/status_effect/debuff/abrogation/on_creation(mob/living/new_owner, duration_override, mob/living/caster, potency)
	intensity = potency
	if(caster)
		debuffer = WEAKREF(caster)
	return ..()

/datum/status_effect/debuff/abrogation/on_apply()
	. = ..()
	to_chat(owner, span_warning("Wisps leap from the cloying mists to surround me, their chill disrupting my body! FLEE!"))
	owner.add_filter("filter_abrogation", 2, outline_filter(1, outline_colour))

/datum/status_effect/debuff/abrogation/on_remove()
	. = ..()
	to_chat(owner, span_notice("I've escaped the cloying mists!"))
	owner.remove_filter("filter_abrogation")

/datum/status_effect/debuff/abrogation/refresh(mob/living/new_owner, duration_override, ...)
	. = ..()
	intensity += 1
	to_chat(owner, span_boldwarning("The mists intensify, the glowing wisps steadily disrupting my body..."))

/datum/status_effect/debuff/abrogation/tick()
	if(!owner)
		return

	if(prob(66))
		owner.adjustFireLoss(base_tick * intensity)

	if(prob(10))
		to_chat(owner, span_warning("A frenzy of ghostly motes assail my form!"))
		owner.emote("scream")

	if(!debuffer)
		return

	var/mob/living/our_debuffer = debuffer.resolve()
	if(get_dist(our_debuffer, owner) > range)
		qdel(src)
