/datum/action/cooldown/spell/projectile/sickness
	name = "Ray of Sickness"
	desc = "Fire a toxic projectile at the living."
	button_icon_state = "raiseskele"
	sound = 'sound/misc/portal_enter.ogg'

	required_form = FORM_WATER

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 0.3
	cooldown_time = 10 SECONDS
	spell_cost = 30

	projectile_type = /obj/projectile/magic/sickness

/obj/projectile/magic/sickness
	name = "Bolt of Sickness"
	icon_state = "xray"
	damage = 15
	damage_type = TOX

/obj/projectile/magic/sickness/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(target.reagents)
		target.reagents.add_reagent(/datum/reagent/toxin, 5)
