// Orginially /poisonspray
/datum/action/cooldown/spell/undirected/create_cloud
	name = "Create Cloud"
	desc = "Hold a container in your hand, its contents turn into a 3-radius smoke."
	button_icon_state = "aerosolize"
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1

	charge_required = FALSE
	cooldown_time = 20 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	invocation = "Create cloud!"
	invocation_type = INVOCATION_SHOUT

	attunements = list(
		/datum/attunement/blood = 0.3,
		/datum/attunement/death = 0.3,
	)

/datum/action/cooldown/spell/undirected/create_cloud/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(cast_on)

/datum/action/cooldown/spell/undirected/create_cloud/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/obj/item/held_item = owner.get_active_held_item()
	if(!held_item)
		to_chat(owner, span_warning("You need to be holding a container to turn into a cloud!"))
		return . | SPELL_CANCEL_CAST

	if(!held_item?.is_open_container())
		to_chat(owner, span_warning("The cloud can't escape this!"))
		return . | SPELL_CANCEL_CAST

	var/datum/reagents/reagents = held_item.reagents
	if(!reagents?.total_volume)
		to_chat(owner, span_warning("It's empty!"))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/create_cloud/cast(atom/cast_on)
	. = ..()
	var/obj/item/held_item = owner.get_active_held_item()
	var/datum/reagents/reagents = held_item.reagents
	var/datum/effect_system/smoke_spread/chem/smoke = new
	smoke.set_up(reagents, 3, get_turf(owner), FALSE)
	smoke.start()

