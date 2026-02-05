/datum/action/cooldown/meatvine/personal/ranged/spread
	name = "Spit Neurotoxin Spread"
	desc = "Spits a spread neurotoxin at someone, exhausting them."
	personal_resource_cost = 10
	acid_projectile = null
	acid_casing = /obj/item/ammo_casing/xenospit
	spit_sound = 'sound/alien/alien_spitacid2.ogg'
	cooldown_time = 10 SECONDS

/obj/item/ammo_casing/xenospit //This is probably really bad, however I couldn't find any other nice way to do this
	name = "big glob of neurotoxin"
	projectile_type = /obj/projectile/neurotoxin/spitter_spread
	pellets = 3
	variance = 20

/obj/projectile/neurotoxin/spitter_spread //Slightly nerfed because its a shotgun spread of these
	name = "neurotoxin spit"
	icon_state = "neurotoxin"
	damage = 25
	damage_type = TOX
	paralyze = 2 SECONDS
	impact_effect_type = /obj/effect/temp_visual/impact_effect/neurotoxin

/obj/projectile/neurotoxin/on_hit(atom/target, blocked = 0, pierce_hit)
	if(ishuman(target))
		var/mob/living/carbon/human/h_mob = target
		if(h_mob.can_inject())
			h_mob.adjust_stamina(-40)
	return ..()

/obj/effect/temp_visual/impact_effect/neurotoxin
	icon_state = "impact_neurotoxin"
