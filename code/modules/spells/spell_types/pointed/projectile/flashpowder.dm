/datum/action/cooldown/spell/projectile/flashpowder
	name = "Flashpowder"
	desc = "Blind and damage the eyes of a target."
	button_icon_state = "noc_sight"
	sound = 'sound/magic/flashpowder.ogg'

	charge_required = FALSE
	cooldown_time = 2 MINUTES
	projectile_type = /obj/projectile/magic/flashpowder

/obj/projectile/magic/flashpowder
	name = "flashpowder"
	icon_state = "spark"
	range = 5
	nondirectional_sprite = TRUE
	nodamage = FALSE
	damage = 1

/obj/projectile/magic/flashpowder/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		to_chat(L, span_userdanger("OH, GODS ABOVE! MY EYES ARE BURNING!!"))
		L.blur_eyes(20)
		L.blind_eyes(4)
		L.emote("agony", forced = TRUE)
