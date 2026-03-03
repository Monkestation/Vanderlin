/mob/living/simple_animal/hostile/retaliate/bat
	name = "bat"
	desc = ""
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	response_help_continuous = "brushes aside"
	response_help_simple = "brush aside"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	maxHealth = 50
	health = 50
	spacewalk = TRUE
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef= 1)
	pass_flags = PASSTABLE
	faction = list("hostile")
	attack_sound = 'sound/blank.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	is_flying_animal = TRUE
	speak_emote = list("squeaks")

//this is literally a shapeshift and ai can't actually use it
	ai_controller = /datum/ai_controller/bat


/mob/living/simple_animal/hostile/retaliate/bat/Initialize()
	. = ..()
	add_verb(src, list(/mob/living/simple_animal/hostile/retaliate/bat/proc/bat_up, /mob/living/simple_animal/hostile/retaliate/bat/proc/bat_down))

/mob/living/simple_animal/hostile/retaliate/bat/proc/bat_up()
	set category = "RoleUnique.Vampire Bat"
	set name = "Move Up"

	if(zMove(UP, TRUE))
		to_chat(src, "<span class='notice'>I fly upwards.</span>")

/mob/living/simple_animal/hostile/retaliate/bat/proc/bat_down()
	set category = "RoleUnique.Vampire Bat"
	set name = "Move Down"

	if(zMove(DOWN, TRUE))
		to_chat(src, "<span class='notice'>I fly down.</span>")
