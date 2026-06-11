/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	splatter_chance = 100
	pass_flags = PASSTABLE | PASSGRILLE
	damage_type = BRUTE
	nodamage = FALSE
	flag =  "piercing"
	hitsound_wall = "ricochet"
	impact_effect_type = /obj/effect/temp_visual/impact_effect

/obj/projectile/bullet/pellet
	name = "pellet"
	damage = 15 // musket damage + a tiny bit more if you manage to hit point-blank
	armor_penetration = 85 // smaller --> lower penetrating power
	speed = 0.6 //faster cuz it's smaller(?)
	range = 10
	woundclass = BCLASS_SHOT

/obj/projectile/bullet/pellet/zenar
	name = "zenar pellet"
	armor_penetration = 100
	speed = 0.8

/obj/projectile/bullet/pellet/zil
	name = "zil pellet"
	armor_penetration = 95
	speed = 0.75

/obj/projectile/bullet/pellet/zenny
	name = "zenny pellet"
	armor_penetration = 90
	speed = 0.7

/obj/projectile/bullet/pellet/glass
	name = "shard pellet"
	damage = 12
	armor_penetration = 45
	speed = 1
	embedchance = 100

/obj/projectile/bullet/pellet/salt
	name = "salt pellet"
	speed = 1
	damage = 20
	jitter = 5
	eyeblur = 3
	damage_type = STAMINA
