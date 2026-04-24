/mob/living/simple_animal/hostile/boss/fishboss
	name = "Duke of the Deep"
	desc = "An enormous, bloated deep one, pulsating with ancient power from the abyss."
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	faction = list("deepone")
	icon = 'icons/roguetown/mob/monster/pufferboss.dmi'
	icon_state = "pufferman"
	vision_range = 16
	aggro_vision_range = 24
	ranged = 1
	rapid = 4
	rapid_fire_delay = 8
	ranged_message = "spits stones"
	ranged_cooldown_time = 200
	ranged_ignores_vision = TRUE
	environment_smash = 0
	minimum_distance = 2
	retreat_distance = 0
	move_to_delay = 10
	obj_damage = 100
	base_intents = list(/datum/intent/simple/claw/deepone_boss)
	melee_damage_lower = 65
	melee_damage_upper = 90
	health = 4500
	maxHealth = 4500
	base_strength = 18
	base_perception = 15
	base_intelligence = 12
	base_constitution = 20
	base_endurance = 20
	base_speed = 15
	base_fortune = 14
	projectiletype = /obj/projectile/bullet/reusable/deepone
	projectilesound = 'sound/combat/wooshes/punch/punchwoosh (1).ogg'
	patron = /datum/patron/divine/abyssor

	animal_type = /datum/blood_type/human/triton
	stat_attack = SOFT_CRIT
	loot = list(/obj/item/weapon/mace/goden/deepduke)
	ai_controller = /datum/ai_controller/fishboss
	var/list/phase_messages = list(
		"<span class='warning'>The Duke of the Deep's eyes glow with an intense blue light as its skin starts to shift!</span>",
		"<span class='warning'>The Duke of the Deep roars in anger as barnacles and coral formations burst from its skin!</span>",
		"<span class='warning'>The Duke's flesh splits open revealing glowing eldritch sigils as it howls in rage!</span>"
	)
	var/list/phase_colors = list(
		"#66DDFF",
		"#44BBFF",
		"#2299FF"
	)

/mob/living/simple_animal/hostile/boss/fishboss/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	RegisterSignal(src, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(check_phase_transition))
	// Create unique name from list of possibilities
	var/list/possible_titles = list(
		"Duke of the Deep",
		"Harbinger of the Abyss",
		"Drowner of Worlds",
		"Voice of the Crushing Depths",
		"The Tide's Master"
	)
	name = pick(possible_titles)
	// Add slight visual difference each round
	var/base_color_shift = pick("normal", "green", "blue")
	switch(base_color_shift)
		if("normal")
			color = "#FFFFFF"
		if("green")
			color = "#DDFFEE"
		if("blue")
			color = "#DDEEFF"

/mob/living/simple_animal/hostile/boss/fishboss/proc/check_phase_transition()
	if(!ai_controller)
		return

	// Calculate current health percentage
	var/health_percent = (health / maxHealth) * 100

	// Determine which phase the boss should be in based on health
	var/new_phase = 0
	if(health_percent <= 25)
		new_phase = 3  // Final phase (25% or less)
	else if(health_percent <= 50)
		new_phase = 2  // Third phase (50% or less)
	else if(health_percent <= 75)
		new_phase = 1  // Second phase (75% or less)
	else
		new_phase = 0  // First phase (above 75%)

	// Check if we're entering a new phase
	var/current_phase = ai_controller.blackboard[BB_RAGE_PHASE]
	if(new_phase != current_phase)
		ai_controller.CancelActions()

/mob/living/simple_animal/hostile/boss/fishboss/proc/enter_new_phase(phase_number)
	if(phase_number < 1 || phase_number > 3)
		return

	// Display phase transition message
	visible_message(phase_messages[phase_number])

	// Visual effects
	color = phase_colors[phase_number]
	add_filter("rage_glow", 2, outline_filter(phase_number, "#3366FF"))
	playsound(src, 'sound/misc/explode/explosion.ogg', 100, TRUE) // Replace with appropriate sound

	// Particle effects based on phase
	var/datum/effect_system/smoke_spread/FS = new()
	FS.set_up(3 + phase_number, loc, 0)
	FS.start()

	// Shake screen for nearby players
	for(var/mob/M in view(7, src))
		if(M.client)
			var/shake_intensity = 1 + phase_number
			shake_camera(M, 2 SECONDS, shake_intensity)

	// Adjust stats based on phase
	switch(phase_number)
		if(1) // Phase 1 (75% health)
			melee_damage_lower += 10
			melee_damage_upper += 15
			move_to_delay = 9 // Slightly faster
			ranged_cooldown_time = 180 // Faster ranged attacks

		if(2) // Phase 2 (50% health)
			melee_damage_lower += 15
			melee_damage_upper += 20
			move_to_delay = 8 // Even faster
			ranged_cooldown_time = 160
			rapid = 5 // More projectiles

		if(3) // Phase 3 (25% health - final phase)
			melee_damage_lower += 20
			melee_damage_upper += 25
			move_to_delay = 7 // Quite fast now
			ranged_cooldown_time = 140
			rapid = 6
			// New projectile type for final phase
			projectiletype = /obj/projectile/bullet/reusable/deepone/enhanced

	// Heal a bit to reward phase transition
	adjustHealth(-maxHealth * 0.05)

/obj/projectile/bullet/reusable/deepone
	name = "stone"
	damage = 25
	damage_type = BRUTE
	armor_penetration = 30
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"
	ammo_type = /obj/item/natural/stone
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 50
	woundclass = BCLASS_STAB
	flag = "piercing"
	speed = 10


/mob/living/simple_animal/hostile/boss/fishboss/death()
	visible_message("<span class='warning'>[src] convulses violently as eldritch energy pours from its wounds! The bloated, grotesque fishman explodes in a cataclysmic shower of gore and sea water!</span>")

	// More dramatic death effects
	playsound(src, 'sound/misc/explode/explosion.ogg', 100, TRUE) // Replace with appropriate sound

	// Shake screen for nearby players
	for(var/mob/M in view(10, src))
		if(M.client)
			shake_camera(M, 3 SECONDS, 4)

	// Create explosion effect
	var/datum/effect_system/smoke_spread/FS = new()
	FS.set_up(8, loc, 0)
	FS.start()

	// Spawn additional gibs and effects
	spawn_gibs()
	spawn_gibs()
	spawn_gibs()
	new /obj/effect/temp_visual/cult/sparks(loc)

	// Drop loot with better visuals
	new /obj/effect/temp_visual/guardian/phase/out(drop_location())
	new /obj/item/weapon/mace/goden/deepduke(drop_location())

	// Chance for bonus loot
	if(prob(50))
		new /obj/item/deepone_artifact(drop_location())

	qdel(src)
	return

// Enhanced projectile for final phase
/obj/projectile/bullet/reusable/deepone/enhanced
	name = "abyssal spitstone"
	damage = 30
	color = "#44AAFF"

/obj/projectile/bullet/reusable/deepone/enhanced/on_hit(atom/target, blocked)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.apply_status_effect(/datum/status_effect/abyssal_chill, 3 SECONDS)

/datum/status_effect/abyssal_chill
	id = "abyssal_chill"
	duration = 3 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/abyssal_chill

/atom/movable/screen/alert/status_effect/abyssal_chill
	name = "Abyssal Chill"
	desc = "The cold of the deep slows your movements."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "frozen"

/datum/status_effect/abyssal_chill/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id), multiplicative_slowdown = 1.5)
	owner.color = "#AADDFF"
	return TRUE

/datum/status_effect/abyssal_chill/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(MOVESPEED_ID_STATUS_EFFECT(id))
	owner.color = initial(owner.color)

/obj/effect/temp_visual/guardian/phase
	duration = 5
	icon_state = "phasein"

/obj/effect/temp_visual/guardian/phase/out
	icon_state = "phaseout"

/obj/effect/temp_visual/cult/sparks
	randomdir = TRUE
	name = "blood sparks"
	icon_state = "bloodsparkles"

/obj/item/deepone_artifact
	name = "abyssal artifact"
	desc = "A strange relic from the deep ocean. It pulses with eldritch energy."
	icon = 'icons/effects/effects.dmi'  // Replace with appropriate icon
	icon_state = "horn"  // Replace with appropriate icon_state
	var/list/possible_types = list("crown", "chalice", "idol", "scale")

/obj/item/deepone_artifact/Initialize()
	. = ..()
	var/chosen_type = pick(possible_types)
	switch(chosen_type)
		if("crown")
			name = "coral crown"
			desc = "A crown made of living coral that seems to pulse with the rhythm of distant tides."
			icon_state = "crown"
		if("chalice")
			name = "abyssal chalice"
			desc = "A chalice crafted from unknown deep-sea materials. Water placed within never spills."
			icon_state = "chalice"
		if("idol")
			name = "deep one idol"
			desc = "A small statue depicting an ancient being. It feels uncomfortably damp no matter how much you dry it."
			icon_state = "idol"
		if("scale")
			name = "scale of the Duke"
			desc = "An enormous fish scale that shimmers with an otherworldly light."
			icon_state = "scale"

	// Add a unique glow
	add_filter("artifact_glow", 2, outline_filter(1, "#3366FF"))
