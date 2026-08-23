/datum/action/cooldown/spell/stone_throw
	name = "Stone Throw"
	desc = "Hurls a heavy stone that shatters explosively on impact."
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "spell_default"
	cooldown_time = 8 SECONDS
	spell_type = NONE
	charge_required = FALSE
	var/projectile_type = /obj/projectile/thrown_stone

/datum/action/cooldown/spell/stone_throw/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!istype(caster) || !cast_on)
		return

	caster.visible_message(span_danger("[caster] hurls a boulder!"))
	var/obj/projectile/thrown_stone/shot = new projectile_type(get_turf(caster))
	shot.preparePixelProjectile(cast_on, caster)
	shot.fire()
