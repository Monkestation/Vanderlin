#define AGRIOPYLON_STATE_IDLE 0
#define AGRIOPYLON_STATE_BLESSING 1

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon
	name = "agriopylon"
	desc = "A gentle spirit that tends to garden."
	icon = 'icons/mob/summonable/32x32.dmi'
	icon_state = "flower_spirit"
	icon_living = "flower_spirit"
	icon_dead = null
	density = FALSE
	pass_flags = PASSMOB|PASSTABLE
	health = 60
	gender = FEMALE
	maxHealth = 60
	melee_damage_lower = 0
	melee_damage_upper = 0
	rapid = 1
	vision_range = 6
	aggro_vision_range = 8
	move_to_delay = 3
	base_constitution = 2
	base_strength = 1
	base_speed = 10
	faction = list("fae", "FACTION_PLANTS")
	attack_sound = list(
		'sound/foley/plantcross1.ogg',
		'sound/foley/plantcross2.ogg'
	)

	aggressive = 0
	ai_controller = /datum/ai_controller/agriopylon
	dendor_taming_chance = DENDOR_TAME_PROB_NONE
	del_on_death = TRUE

	var/current_color
	var/mutable_appearance/flower_idle
	var/mutable_appearance/flower_act
	var/agriopylon_state = AGRIOPYLON_STATE_IDLE
	var/static/list/pet_commands = list(
		/datum/pet_command/follow,
		/datum/pet_command/idle,
		/datum/pet_command/agriopylon/search_range,
		/datum/pet_command/agriopylon/tend_crops,
		/datum/pet_command/agriopylon/stop_tending
	)

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_ENTANGLER_IMMUNE, TRAIT_GENERIC)
	AddComponent(/datum/component/obeys_commands, pet_commands)
	AddComponent(/datum/component/ai_aggro_system)
	flower_idle = mutable_appearance(icon, "flower_spirit_detail")
	flower_idle.color = current_color
	flower_idle.layer = MOB_LAYER + 0.1
	flower_act = mutable_appearance(icon, "flower_spirit_act_detail")
	flower_act.color = current_color
	flower_act.layer = MOB_LAYER + 0.1
	update_flower_color()
	update_appearance(UPDATE_ICON)
	var/offset = rand(0, 30)
	addtimer(CALLBACK(src, PROC_REF(_bobbing_loop)), offset)

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/proc/update_flower_color()
	if(!current_color)
		return
	if(flower_idle)
		flower_idle.color = current_color
	if(flower_act)
		flower_act.color = current_color
	update_appearance(UPDATE_ICON)

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/update_overlays()
	. = ..()
	switch(agriopylon_state)
		if(AGRIOPYLON_STATE_IDLE)
			if(flower_idle)
				. += flower_idle
		if(AGRIOPYLON_STATE_BLESSING)
			if(flower_act)
				. += flower_act

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/update_icon_state()
	. = ..()
	switch(agriopylon_state)
		if(AGRIOPYLON_STATE_IDLE)
			icon_state = "flower_spirit"
		if(AGRIOPYLON_STATE_BLESSING)
			icon_state = "flower_spirit_act"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/proc/change_agriopylon_state(new_state)
	agriopylon_state = new_state
	update_appearance(UPDATE_ICON)

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/proc/start_bless_animation()
	change_agriopylon_state(AGRIOPYLON_STATE_BLESSING)

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/proc/stop_bless_animation()
	change_agriopylon_state(AGRIOPYLON_STATE_IDLE)

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/proc/_bobbing_loop()
	if(QDELETED(src)) return
	animate(src, pixel_y = 4, time = 30, loop = 0)
	animate(pixel_y = -2, time = 30, loop = 0)
	animate(pixel_y = 0, time = 20, loop = 0)
	addtimer(CALLBACK(src, PROC_REF(_bobbing_loop)), 80)

// I tried color mapping....I can't
/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/atropa
	current_color = "#2b1b66"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/matricaria
	current_color = "#e7e6b7"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/symphitum
	current_color = "#757cae"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/taraxacum
	current_color = "#c1b84d"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/euphrasia
	current_color = "#e7e6df"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/paris
	current_color = "#7e8042"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/calendula
	current_color = "#c58436"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/mentha
	current_color = "#508042"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/urtica
	current_color = "#595489"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/salvia
	current_color = "#be82ba"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/hypericum
	current_color = "#8c383c"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/benedictus
	current_color = "#ef6ce9"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/valeriana
	current_color = "#f3b7db"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/artemisia
	current_color = "#b0ab8f"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/euphorbia
	current_color = "#6dbd4a"

/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/rosa
	current_color = "#cc3768"

#undef AGRIOPYLON_STATE_IDLE
#undef AGRIOPYLON_STATE_BLESSING
