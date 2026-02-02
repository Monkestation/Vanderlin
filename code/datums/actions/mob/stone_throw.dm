/datum/action/cooldown/spell/stone_throw
	name = "Stone Throw"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "explosion"
	desc = "Chucks a stone at someone"
	cooldown_time = 15 SECONDS
	check_flags = null
	charge_required = FALSE

/datum/action/cooldown/spell/stone_throw/cast(atom/cast_on)
	. = ..()
	prepare_stone()
	addtimer(CALLBACK(src, PROC_REF(chuck_stone), cast_on), 1 SECONDS)
	StartCooldown()

/datum/action/cooldown/spell/stone_throw/proc/prepare_stone(atom/target)
	var/static/list/transforms
	owner.visible_message(span_boldwarning("[owner] digs into the ground for rocks!"))
	playsound(owner,'sound/items/dig_shovel.ogg', 100, TRUE)

	if(!transforms)
		var/matrix/M1 = matrix()
		var/matrix/M2 = matrix()
		var/matrix/M3 = matrix()
		var/matrix/M4 = matrix()
		M1.Translate(-5, 0)
		M2.Translate(0, 2)
		M3.Translate(5, 0)
		M4.Translate(0, -2)
		transforms = list(M1, M2, M3, M4)

	animate(owner, transform=transforms[1], time=2.5 DECISECONDS)
	animate(transform=transforms[2], time= 2.5 DECISECONDS)
	animate(transform=transforms[3], time= 2.5 DECISECONDS)
	animate(transform=transforms[4], time=2.5 DECISECONDS)

/datum/action/cooldown/spell/stone_throw/proc/chuck_stone(atom/target)
	if(!target)
		return

	owner.visible_message(span_boldwarning("[owner] chucks a huge stone rock!"))
	playsound(owner, 'sound/combat/shieldraise.ogg', 100)
	var/turf/target_turf = get_turf(target)
	new /obj/effect/temp_visual/target/orcthrow(target_turf)

/datum/action/cooldown/spell/stone_throw/proc/post_chuck_stone()
