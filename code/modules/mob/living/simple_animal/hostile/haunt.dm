/datum/intent/simple/slash
	name = "slash"
	icon_state = "inchop"
	attack_verb = list("cuts", "slashes")
	animname = "slash"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 0
	penfactor = 10
	swingdelay = 3
	item_damage_type = "slash"

/mob/living/simple_animal/hostile/haunt
	name = "haunt"
	desc = ""
	icon = 'icons/roguetown/mob/monster/wraith.dmi'
	icon_state = "haunt"
	icon_living = "haunt"
	icon_dead = null
	alpha = 200
	mob_biotypes = MOB_UNDEAD|MOB_HUMANOID
	is_flying_animal = TRUE
	environment_smash = ENVIRONMENT_SMASH_NONE
	pass_flags = PASSTABLE|PASSGRILLE
	base_intents = list(/datum/intent/simple/slash)
	gender = MALE
	speak_chance = 0
	response_help_continuous = "passes through"
	response_help_simple = "pass through"
	maxHealth = 50
	health = 50
	spacewalk = TRUE
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	speed = 1
	move_to_delay = 5 //delay for the automated movement.
	harm_intent_damage = 1
	obj_damage = 1
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_sound = 'sound/combat/wooshes/bladed/wooshmed (1).ogg'
	dodge_sound = 'sound/combat/dodge.ogg'
	parry_sound = "sword"
	d_intent = INTENT_PARRY
	speak_emote = list("growls")
	limb_destroyer = 1
	del_on_death = TRUE
	minbodytemp = 0
	faction = list(FACTION_UNDEAD)
	footstep_type = null
	defdrain = 20
	canparry = TRUE
	var/obj/structure/bonepile/slavepile

	base_fortune = 11

	ai_controller = /datum/ai_controller/haunt



/mob/living/simple_animal/hostile/haunt/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/haunt/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	return FALSE

/mob/living/simple_animal/hostile/haunt/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "head"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "head"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "hand"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "hand"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "tail"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "body"
		if(BODY_ZONE_PRECISE_GROIN)
			return "body"
		if(BODY_ZONE_PRECISE_R_INHAND)
			return "body"
		if(BODY_ZONE_PRECISE_L_INHAND)
			return "body"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "tail"
		if(BODY_ZONE_L_LEG)
			return "tail"
		if(BODY_ZONE_R_ARM)
			return "arm"
		if(BODY_ZONE_L_ARM)
			return "arm"
		if(BODY_ZONE_CHEST)
			return "chest"

	return ..()

/obj/structure/bonepile
	icon = 'icons/roguetown/mob/monster/wraith.dmi'
	icon_state = "hauntpile-s"
	max_integrity = 100
	anchored = TRUE
	density = FALSE
	var/list/haunts = list()
	var/maxhaunts = 1
	var/datum/looping_sound/boneloop/soundloop
	var/spawning_haunt = FALSE
	layer = BELOW_OBJ_LAYER
	attacked_sound = 'sound/vo/mobs/ghost/skullpile_hit.ogg'

/obj/structure/inert_bonepile
	icon = 'icons/roguetown/mob/monster/wraith.dmi'
	icon_state = "hauntpile"
	max_integrity = 100
	anchored = FALSE
	density = FALSE
	layer = BELOW_OBJ_LAYER
	attacked_sound = 'sound/vo/mobs/ghost/skullpile_hit.ogg'

/obj/structure/bonepile/Initialize()
	. = ..()
	soundloop = new(src, FALSE)
	soundloop.start()
	for(var/i in 1 to maxhaunts)
		spawn_haunt()
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/bonepile/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	for(var/mob/living/simple_animal/hostile/haunt/H as anything in haunts)
		H.death()
	haunts.Cut()
	var/spawned = pick(/obj/item/reagent_containers/powder/spice)
	new spawned(get_turf(src))
	return ..()

/obj/structure/bonepile/update_icon_state()
	. = ..()
	if(spawning_haunt)
		icon_state = "hauntpile-r"
	else
		icon_state = "hauntpile"

/obj/structure/bonepile/proc/createhaunt()
	if(QDELETED(src))
		return
	spawning_haunt = FALSE
	var/mob/living/simple_animal/hostile/haunt/H = new (get_turf(src))
	H.slavepile = src
	H.ai_controller.set_blackboard_key(BB_LEYLINE_SOURCE, src)
	haunts += H
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/bonepile/proc/spawn_haunt()
	if(QDELETED(src))
		return
	spawning_haunt = TRUE
	update_appearance(UPDATE_ICON_STATE)
	addtimer(CALLBACK(src, PROC_REF(createhaunt)), rand(4,6) SECONDS)

/mob/living/simple_animal/hostile/haunt/Initialize()
	. = ..()
	set_light(2, 2, l_color = "#c0523f")
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/haunt/Destroy()
	set_light(0)
	if(slavepile)
		slavepile.haunts -= src
		slavepile.spawn_haunt()
		slavepile = null
	. = ..()

/mob/living/simple_animal/hostile/haunt/death(gibbed)
	emote("death")
	..()

/mob/living/simple_animal/hostile/haunt/Life()
	. = ..()
	if(slavepile)
		var/offset_x = x - slavepile.x
		var/offset_y = y - slavepile.y
		if(offset_x > 8 || offset_x < -8 || offset_y > 8 || offset_y < -8 || (z != slavepile.z))
			if(isturf(slavepile.loc))
				src.forceMove(slavepile.loc)
			else
				death()
	if(!target)
		if(prob(3))
			emote(pick("laugh", "moan", "whisper"), TRUE)

/mob/living/simple_animal/hostile/haunt/get_sound(input)
	switch(input)
		if("laugh")
			return pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg','sound/vo/mobs/ghost/laugh (4).ogg','sound/vo/mobs/ghost/laugh (5).ogg','sound/vo/mobs/ghost/laugh (6).ogg')
		if("moan")
			return pick('sound/vo/mobs/ghost/moan (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg')
		if("death")
			return 'sound/vo/mobs/ghost/death.ogg'
		if("whisper")
			return pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg')
		if("aggro")
			return pick('sound/vo/mobs/ghost/aggro (1).ogg','sound/vo/mobs/ghost/aggro (2).ogg','sound/vo/mobs/ghost/aggro (3).ogg','sound/vo/mobs/ghost/aggro (4).ogg','sound/vo/mobs/ghost/aggro (5).ogg','sound/vo/mobs/ghost/aggro (6).ogg')

/mob/living/simple_animal/hostile/haunt/AttackingTarget()
	. = ..()
	if(. && prob(8) && iscarbon(target))
		var/mob/living/carbon/C = target
		C.Immobilize(2 SECONDS)
		C.visible_message("<span class='danger'>\The [src] paralyzes \the [C] in fear!</span>", \
				"<span class='danger'>\The [src] paralyzes me!</span>")
		emote("laugh")
