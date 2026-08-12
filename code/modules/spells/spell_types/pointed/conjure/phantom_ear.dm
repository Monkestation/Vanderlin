/datum/action/cooldown/spell/conjure/phantom_ear
	name = "Summon Phantom Ear"
	desc = "Creates a magical ear to listen in on distant sounds."
	button_icon_state = "phantomear"
	self_cast_possible = TRUE

	has_visual_effects = FALSE
	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 60
	spell_flags = SPELL_RITUOS
	invocation = "Lend me thine ear."

	required_form = FORM_WATER

	invocation_type = INVOCATION_WHISPER

	summon_type = list(/obj/item/phantom_ear)
	summon_radius = 0

	var/datum/weakref/current_ear

/datum/action/cooldown/spell/conjure/phantom_ear/Destroy(force)
	QDEL_NULL(current_ear)
	return ..()

/datum/action/cooldown/spell/conjure/phantom_ear/post_summon(obj/item/phantom_ear/summoned_object)
	var/obj/item/phantom_ear/current = current_ear?.resolve()
	if(current)
		to_chat(owner, span_notice("You close one ear to open another."))
		qdel(current)
	else
		to_chat(owner, span_notice("You've conjured a phantom ear. You can hear through it as if you were there. Speak \"deafen\" to close this ear to the world, and \"listen\" to re-open it."))
	current_ear = WEAKREF(summoned_object)
	summoned_object.setup(owner)
