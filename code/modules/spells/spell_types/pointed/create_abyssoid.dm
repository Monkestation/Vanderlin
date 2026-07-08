/datum/action/cooldown/spell/undirected/create_abyssoid
	name = "Create Abyssoid"
	button_icon_state = "bloodsteal"
	has_visual_effects = FALSE

	cast_range = 1
	charge_required = FALSE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/spell/undirected/create_abyssoid/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return

	if(!isliving(owner))
		return FALSE

	var/mob/living/follower = owner
	if(follower.get_blood_volume() < BLOOD_VOLUME_BAD)
		if(feedback)
			to_chat(follower, span_warning("You don't have enough blood to sacrifice!"))
		return FALSE

/datum/action/cooldown/spell/undirected/create_abyssoid/cast(atom/cast_on)
	. = ..()

	var/obj/item/natural/worms/leech/target
	var/mob/living/follower = owner

	for(var/obj/item/natural/worms/leech/leech in follower.held_items)
		target = leech
		break

	if(!target)
		to_chat(follower, span_warning("You must hold a leech in your hands to transform it!"))
		return

	follower.visible_message(
		span_warning("[follower] begins stragely murmuring over [target]..."),
		span_notice("You begin the transformation ritual, offering your blood to Abyssor."),
	)

	if(!do_after(follower, 10 SECONDS, target))
		to_chat(follower, span_warning("The ritual was interrupted!"))
		return FALSE


	if(!(target in follower.held_items))
		to_chat(follower, span_warning("You must keep holding the leech during the ritual!"))
		return FALSE

	if(follower.get_blood_volume() < BLOOD_VOLUME_BAD)
		to_chat(follower, span_warning("You don't have enough blood to complete the ritual!"))
		return FALSE

	follower.adjust_blood_volume(-70)
	var/obj/item/natural/worms/leech/abyssoid/new_leech = new(owner.drop_location())
	qdel(target)
	follower.put_in_hands(new_leech)

	follower.visible_message(span_warning("[follower] completes the ritual, transforming the leech!"), \
						span_red("The leech transforms into a holy abyssoid leech!"))

	SEND_SIGNAL(follower, COMSIG_ABYSSOID_CREATED)
