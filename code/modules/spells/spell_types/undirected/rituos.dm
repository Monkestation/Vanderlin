/datum/action/cooldown/spell/undirected/rituos
	name = "Rituos"
	desc = "Harness both Fleshcrafting and the Arcyne, and expunge the trappings of mortal flesh from your form in exchange for power unimaginable. Be warned: indulging in even the first step of this ritual will make you more deadite than not..."
	button_icon_state = "createlight"
	sound = 'sound/magic/timestop.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 10 SECONDS
	cooldown_time = 3 HOURS
	spell_cost = 120

	attunements = list(
		/datum/attunement/death = 0.5
	)

	/// Weakref to granted spell, for the dream ending
	var/datum/weakref/granted_spell

/datum/action/cooldown/spell/undirected/rituos/Destroy(force)
	granted_spell = null // Deleted with us
	return ..()

/datum/action/cooldown/spell/undirected/rituos/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(istype(granted_spell))
		return . | SPELL_CANCEL_CAST

	if(!length(get_unskeletonized_bodyparts(cast_on)))
		to_chat(cast_on, span_notice("I have completed Her Lesser Work. Only lichdom awaits me now, but just out of reach..."))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/rituos/cast(mob/living/carbon/cast_on)
	. = ..()
	var/list/choices = list()
	for(var/datum/action/cooldown/spell/spell_type as anything in subtypesof(/datum/action/cooldown/spell))
		if(!(initial(spell_type.spell_flags) & SPELL_RITUOS))
			continue
		choices[initial(spell_type.name)] = spell_type

	choices = sortList(choices)

	var/choice = browser_input_list(cast_on, "Choose an arcyne expression of the Lesser Work", "HER WORKS", choices)
	if(QDELETED(cast_on) || QDELETED(src))
		return

	var/spell_type = choices[choice]
	if(!spell_type)
		reset_spell_cooldown()
		return

	if(!(cast_on.mob_biotypes & MOB_UNDEAD))
		cast_on.visible_message(
			span_warning("The pallor of the grave descends across [cast_on]'s skin in a wave of arcyne energy..."),
			span_boldwarning("A deathly chill overtakes my body at my first culmination of the Lesser Work! I feel my heart slow down in my chest...")
		)
		cast_on.mob_biotypes |= MOB_UNDEAD
		cast_on.mana_pool.intrinsic_recharge_sources &= ~MANA_ALL_LEYLINES
		cast_on.mana_pool.set_intrinsic_recharge(MANA_SOULS)
		cast_on.add_spell(/datum/action/cooldown/spell/undirected/arcyne_eye)
		to_chat(cast_on, span_smallred("I have forsaken the living. I am now closer to a deadite than a mortal... but I still yet draw breath and bleed."))

	var/obj/item/bodypart/the_part = pick(get_unskeletonized_bodyparts(cast_on))
	var/obj/item/bodypart/part_to_bonify = cast_on.get_bodypart(the_part.body_zone)

	part_to_bonify.skeletonize(FALSE)
	cast_on.update_body_parts()
	cast_on.visible_message(
		span_warning("Faint runes flare beneath [cast_on]'s skin before their flesh suddenly slides away from their [part_to_bonify.name]!"),
		span_notice("I feel arcyne power surge throughout my frail mortal form, as the Rituos takes its terrible price from my [part_to_bonify.name].")
	)

	if(!length(get_unskeletonized_bodyparts(cast_on)))
		cast_on.adjust_stat_modifier(STATMOD_RITUAL, list(/datum/attribute/skill/magic/arcane = 30))
		cast_on.add_spell(/datum/action/cooldown/spell/undirected/touch/prestidigitation)
		cast_on.adjust_spell_points(18)
		cast_on.visible_message(
			span_boldwarning("[cast_on]'s form swells with terrible power as they cast away almost all of \
			the remnants of their mortal flesh, arcyne runes glowing upon their exposed bones..."),
			span_notice("I HAVE DONE IT! I HAVE COMPLETED HER LESSER WORK! I stand at the cusp of unspeakable power, but something is yet missing...")
		)
		ADD_TRAIT(cast_on, TRAIT_NOHUNGER, "[type]")
		ADD_TRAIT(cast_on, TRAIT_NOBREATH, "[type]")
		if(prob(33))
			to_chat(cast_on, span_danger("...what have I done?"))
		qdel(src)
		return

	RegisterSignal(cast_on, COMSIG_LIVING_DREAM_END, PROC_REF(on_dream_end))
	var/datum/action/cooldown/spell = new spell_type(src)
	to_chat(cast_on, span_notice("The Lesser Work of Rituos floods my mind with stolen arcyne knowledge: I can now cast [spell.name] until I next rest..."))
	cast_on.add_spell(spell)
	granted_spell = WEAKREF(spell)

/datum/action/cooldown/spell/undirected/rituos/proc/get_unskeletonized_bodyparts(mob/living/carbon/caster)
	var/static/list/excluded_bodypart_types = list(/obj/item/bodypart/head)

	var/list/possible_parts = list()
	for(var/obj/item/bodypart/BP in caster.bodyparts)
		if(BP.skeletonized)
			continue
		if(BP.type in excluded_bodypart_types)
			continue
		possible_parts += BP

	return possible_parts

/datum/action/cooldown/spell/undirected/rituos/proc/on_dream_end(mob/living/carbon/user)
	SIGNAL_HANDLER

	if(QDELETED(src))
		return

	var/datum/action/cooldown/spell = granted_spell?.resolve()
	if(spell)
		to_chat(user, span_warning("My glimpse of [spell.name] fades as I awaken..."))

	user.remove_spells(source = src)
	granted_spell = null
	to_chat(user, span_smallnotice("The toil of invoking Her Lesser Work slips away. I may begin anew…"))
	reset_spell_cooldown()
	UnregisterSignal(user, COMSIG_LIVING_DREAM_END)
