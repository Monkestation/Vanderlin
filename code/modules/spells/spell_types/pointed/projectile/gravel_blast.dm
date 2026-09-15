/datum/action/cooldown/spell/projectile/gravel_blast
	button_icon = 'icons/mob/actions/spells/mage_geomancy.dmi'
	name = "Gravel Blast"
	desc = "Spray a volley of stones at a target. Stones ricochet off walls. Subsequent hits on the same target deal reduced damage. \
	Stones are particularly effective at degrading armor. \
	Toggle arc mode (Shift+G) to lob over obstacles at reduced damage."
	button_icon_state = "gravel_blast"
	sound = 'sound/combat/hits/onstone/wallhit.ogg'

	projectile_type = /obj/projectile/magic/gravel_blast
	projectile_type_arc = /obj/projectile/magic/gravel_blast/arc
	cast_range = SPELL_RANGE_PROJECTILE
	projectiles_per_fire = 5

	spell_cost = 15

	required_form = FORM_EARTH
	required_technique = TECHNIQUE_DESTRUCTION

	invocation = "Saxum Iaci!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 24 SECONDS
	var/spread_step = 8

	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/projectile/gravel_blast/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/base_angle = to_fire.Angle
	if(isnull(base_angle))
		base_angle = get_angle(user, target)
	var/center_index = (projectiles_per_fire + 1) / 2
	to_fire.Angle = base_angle + ((iteration - center_index) * spread_step)
	// Only the center stone can roll for blunt crit/knockout
	if(iteration != center_index)
		to_fire.woundclass = null

