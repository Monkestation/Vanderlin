/obj/projectile/bullet/hellfire
	name = "melted silver"
	desc = "How can you see this?"
	damage = 10
	damage_type = BURN
	woundclass = BCLASS_SHOT
	range = 8
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	speed = 0.9
	reduce_crit_chance = 1

/obj/projectile/bullet/hellfire/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/projectile/bullet/hellfire/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/carbon/human/species/werewolf = target
		werewolf.fire_act(30)

	target.apply_status_effect(/datum/status_effect/debuff/silver_bane, null, affected)

/obj/item/explosive/hell_fire
	name = "Psydons rebuke"
	desc = "Once long ago, there was an outbreak of lycanthropia in Grenzelhoft, one stamped out by the populace with tenacity and blastpowder. This design of grenade is a sloppy yet effective weapon which is often used by the poor underclass in defense of nite-beasts.  Praise psydon, for it is he who grants us these gifts to make all those who prowl the nite run in fear. There is too little silver to harm vampires."
	icon_state = "hellfire" ///This is a REALLY badly sprited bomb, mainly because I do not want to steal from the grenade shell sprite again.
	icon = 'icons/obj/bombs.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	grid_height = 64
	grid_width = 32
	impact_explode = FALSE

	prob2fail = 10

	ex_dev = 0
	ex_heavy = 0
	ex_light = 2
	ex_flame = 0
	ex_smoke = 5

	shrapnel_type = /obj/projectile/bullet/hellfire
	shrapnel_radius = 5
	det_time = 4 SECONDS
