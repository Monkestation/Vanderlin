// TODO touch spell?
/datum/action/cooldown/spell/decompose
	name = "Decompose"
	desc = "Instantly rots the target, if humanoid creates a deadite."
	button_icon_state = "orison"
	sound = 'sound/magic/whiteflame.ogg'
	self_cast_possible = FALSE
	spell_flags = SPELL_RITUOS
	cast_range = 1
	point_cost = 3
	associated_skill = /datum/attribute/skill/magic/blood
	attunements = list(
		/datum/attunement/death = 0.3,
		/datum/attunement/blood = 0.2,
	)
	invocation = "Return to rot."
	invocation_type = INVOCATION_WHISPER

	charge_time = 5 SECONDS
	charge_drain = 1
	cooldown_time = 30 SECONDS
	spell_cost = 50

/datum/action/cooldown/spell/decompose/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isitem(cast_on) || isliving(target)

/datum/action/cooldown/spell/decompose/cast(atom/cast_on)
	. = ..()
	if(isitem(cast_on))
		if(istype(cast_on, /obj/item/reagent_containers/food/snacks))
			var/obj/item/reagent_containers/food/snacks/food = cast_on
			if(!food.become_rotten())
				to_chat(owner, span_warning("[food] rots away into nothing."))
				qdel(food)
		return
	// DATUMISE ROT PLEASE
	if(isanimal(cast_on))
		var/mob/living/simple_animal/SA = cast_on
		var/datum/component/rot/rot = SA.GetComponent(/datum/component/rot/simple)
		if(rot && rot.amount < 9.9 MINUTES)
			rot.amount = 9.9 MINUTES
		return
	if(!ishuman(cast_on))
		return
	var/mob/living/carbon/human/target = cast_on
	for(var/datum/injury/injury in target.all_injuries)
		injury.adjust_germ_level(250)

	if(target.stat == DEAD)
		var/datum/antagonist/zombie/z_check = target.zombie_check() //why is this called zombie check when it makes you a zombie...
		if(!z_check)
			return
		z_check.wake_zombie(TRUE)
