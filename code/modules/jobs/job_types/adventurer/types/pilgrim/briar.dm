/datum/job/advclass/pilgrim/briar
	title = "Briar"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/pilgrim/briar
	category_tags = list(CTAG_PILGRIM)
	tutorial = "Stoic gardeners or flesh-eating predators, all can follow Dendor's path. <br>His Briars scorn civilized living, many embracing their animal nature, being fickle and temperamental."
	cmode_music = 'sound/music/cmode/garrison/CombatForestGarrison.ogg'
	allowed_patrons = list(/datum/patron/divine/dendor)

	total_positions = 4
	exp_types_granted = list(EXP_TYPE_CLERIC)

	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1,
		STATKEY_INT = -1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/knives = 1,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/magic/holy = 3,
		/datum/skill/labor/taming = 4,
		/datum/skill/craft/tanning = 2,
		/datum/skill/misc/riding = 1,
		/datum/skill/labor/butchering = 2,
		/datum/skill/labor/farming = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/sewing = 1,
		/datum/skill/misc/swimming = 2
	)

	traits = list(
		TRAIT_SEEDKNOW
	)

/datum/job/advclass/pilgrim/briar/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_OLD)
		spawned.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)

	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/dendor/shillelagh)
	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/dendor/forestdelight)
	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/dendor/visage)
	spawned.mind?.teach_crafting_recipe(/datum/blueprint_recipe/dendor/shrine)
	spawned.mind?.teach_crafting_recipe(/datum/blueprint_recipe/dendor/shrine/saiga)
	spawned.mind?.teach_crafting_recipe(/datum/blueprint_recipe/dendor/shrine/volf)
	spawned.mind?.teach_crafting_recipe(/datum/blueprint_recipe/dendor/shrine/troll)
	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/dendor/sacrifice_growing)
	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/dendor/sacrifice_stinging)
	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/dendor/sacrifice_devouring)
	spawned.mind?.teach_crafting_recipe(/datum/repeatable_crafting_recipe/dendor/sacrifice_lording)

	var/holder = spawned.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(spawned)

	to_chat(spawned, "<br><br><font color='#44720e'><span class='bold'>You know well how to make a shrine to Dendor, wood, thorns, and the head of a favored animal.<br><br>Choose a path stinging, devouring or growing, and make your sacrifices...<br><br>Remember - Dendor will only grant special powers from Blessing the first time you do receive it, and only those mastering all his Miracles can unlock their full potential.  </span></font><br><br>")

/datum/outfit/pilgrim/briar
	name = "Briar (Pilgrim)"
	belt = /obj/item/storage/belt/leather/rope
	mask = /obj/item/clothing/face/druid
	neck = /obj/item/clothing/neck/psycross/silver/dendor
	shirt = /obj/item/clothing/armor/leather/vest
	armor = /obj/item/clothing/shirt/robe/dendor
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltl = /obj/item/weapon/knife/stone
	backl = /obj/item/weapon/mace/goden/shillelagh

/*	.................   Base Blessing of Dendor   ................... */
/obj/item/dendor_blessing
	name = "blank blessing of Dendor"
	icon = 'icons/roguetown/misc/magick.dmi'
	icon_state = ""
	plane = -1
	layer = 4.2
	alpha = 155
	var/associated_shrine = null
	var/path_trait = null
	var/required_trait = null
	var/gives_tier2 = FALSE
	var/unlocks_recipe = null

/obj/item/dendor_blessing/attack_atom(atom/attacked_atom, mob/living/user)
	if(!istype(attacked_atom, associated_shrine))
		return ..()

	. = TRUE
	if(ishuman(user) && user.patron.type == /datum/patron/divine/dendor)
		if(!check_blessing_requirements(user))
			return
		icon_state = "[icon_state]_end"

		if(!do_after(user, 3 SECONDS, target = src, display_over_user = TRUE))
			icon_state = initial(icon_state)
			return

		record_round_statistic(STATS_DENDOR_SACRIFICES)

		var/paths = list(TRAIT_DENDOR_GROWING, TRAIT_DENDOR_STINGING, TRAIT_DENDOR_DEVOURING, TRAIT_DENDOR_LORDING)
		for(var/T in paths)
			if(HAS_TRAIT(user, T) && T != path_trait)
				to_chat(user, span_warning("Dendor rejects my offering... I already follow another path."))
				icon_state = initial(icon_state)
				return

		if(required_trait && !HAS_TRAIT(user, required_trait))
			to_chat(user, span_warning("I am not yet attuned to this path..."))
			icon_state = initial(icon_state)
			return

		if(gives_tier2 && HAS_TRAIT(user, TRAIT_BLESSED))
			to_chat(user, span_info("Dendor has already blessed me once. Further miracles must be earned differently."))
			icon_state = initial(icon_state)
			return

		INVOKE_ASYNC(src, PROC_REF(give_blessing), user)
		if(path_trait && !HAS_TRAIT(user, path_trait))
			ADD_TRAIT(user, path_trait, TRAIT_GENERIC)
		if(gives_tier2 && !HAS_TRAIT(user, TRAIT_BLESSED))
			ADD_TRAIT(user, TRAIT_BLESSED, TRAIT_GENERIC)
		if(unlocks_recipe && user.mind && !HAS_TRAIT(user, TRAIT_BLESSED))
			user.mind.teach_crafting_recipe(unlocks_recipe)
			var/datum/blueprint_recipe/R = unlocks_recipe
			if(R && initial(R.name))
				to_chat(user, span_good("I have learned how to make [initial(R.name)]!"))

		qdel(src)
	else
		to_chat(user, span_warning("Dendor finds me unworthy of his blessings..."))
	return

/obj/item/dendor_blessing/proc/check_blessing_requirements(mob/living/user)
	return TRUE

/obj/item/dendor_blessing/proc/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	playsound(get_turf(user), 'sound/misc/wind.ogg', 100, TRUE, -1)
	user.emote("smile")
	user.apply_status_effect(/datum/status_effect/buff/calm)

/*	.................   Green Blessings of Dendor   ................... */
/obj/item/dendor_blessing/growing
	name = "growing blessing of Dendor"
	icon_state = "dendor_grow"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_gote
	path_trait = TRAIT_DENDOR_GROWING
	unlocks_recipe = /datum/repeatable_crafting_recipe/dendor/sacrifice_tending

/obj/item/dendor_blessing/growing/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	playsound(get_turf(user), 'sound/misc/wind.ogg', 100, TRUE, -1)
	to_chat(user, span_good("Plants grow rampant as the brush twists to ease your every step..."))
	user.emote("smile")
	ADD_TRAIT(user, TRAIT_BRUSHWALK, TRAIT_GENERIC)
	user.add_spell(/datum/action/cooldown/spell/undirected/touch/entangler, source = user.cleric)
	user.apply_status_effect(/datum/status_effect/buff/calm)

/obj/item/dendor_blessing/tending
	name = "tending blessing of Dendor"
	icon_state = "dendor_grow"
	color = "#35ffc6"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_gote
	path_trait = TRAIT_DENDOR_GROWING
	required_trait = TRAIT_DENDOR_GROWING
	gives_tier2 = TRUE

/obj/item/dendor_blessing/tending/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	playsound(get_turf(user), 'sound/misc/wind.ogg', 100, TRUE, -1)
	to_chat(user, span_good("You find seeds more easily."))
	user.emote("smile")
	ADD_TRAIT(user, TRAIT_SEED_FINDER, TRAIT_GENERIC)
	user.add_spell(/datum/action/cooldown/spell/conjure/garden_fae, source = user.cleric)
	user.apply_status_effect(/datum/status_effect/buff/calm)

/*	.................   Yellow Blessings of Dendor   ................... */
/obj/item/dendor_blessing/stinging
	name = "stinging blessing of Dendor"
	icon_state = "dendor_sting"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_saiga
	path_trait = TRAIT_DENDOR_STINGING
	unlocks_recipe = /datum/repeatable_crafting_recipe/dendor/sacrifice_hiding

/obj/item/dendor_blessing/stinging/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	playsound(get_turf(user), 'sound/misc/wind.ogg', 100, TRUE, -1)
	to_chat(user, span_good("You feel as if light follows your every step... your foraging will be easier from now on, surely."))
	user.emote("smile")
	ADD_TRAIT(user, TRAIT_FORAGER, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_MIRACULOUS_FORAGING, TRAIT_GENERIC)
	user.add_spell(/datum/action/cooldown/spell/conjure/kneestingers, source = user.cleric)
	user.apply_status_effect(/datum/status_effect/buff/calm)

/obj/item/dendor_blessing/hiding
	name = "hiding blessing of Dendor"
	icon_state = "dendor_sting"
	color = "#e39c2b"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_saiga
	path_trait = TRAIT_DENDOR_STINGING
	required_trait = TRAIT_DENDOR_STINGING
	gives_tier2 = TRUE

/obj/item/dendor_blessing/hiding/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	playsound(get_turf(user), 'sound/magic/fleshtostone.ogg', 100, TRUE, -1)
	to_chat(user, span_good("You stride the forests with ease and blend into the undergrowth."))
	user.emote("smile")
	user.add_spell(/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt, source = user.cleric)
	user.apply_status_effect(/datum/status_effect/buff/calm)

/*	.................  Red Blessings of Dendor   ................... */
/obj/item/dendor_blessing/devouring
	name = "devouring blessing of Dendor"
	icon_state = "dendor_consume"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_volf
	path_trait = TRAIT_DENDOR_DEVOURING
	unlocks_recipe = /datum/repeatable_crafting_recipe/dendor/sacrifice_falconing

/obj/item/dendor_blessing/devouring/check_blessing_requirements(mob/living/user)
	if(!user.get_spell(/datum/action/cooldown/spell/undirected/bless_crops))
		to_chat(user, span_warning("My faith to Dendor is insufficient..."))
		return FALSE
	return ..()

/obj/item/dendor_blessing/devouring/give_blessing(mob/living/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	to_chat(user, span_danger("A volf howls far away... and your teeth begin to sear with pain!"))
	playsound(get_turf(user), 'sound/vo/mobs/wwolf/idle (1).ogg', 50, TRUE)
	user.Immobilize(2 SECONDS)
	sleep(2 SECONDS)
	user.emote("pain")
	sleep(0.5 SECONDS)
	playsound(get_turf(user), 'sound/combat/fracture/fracturewet (1).ogg', 70, TRUE, -1)
	user.Immobilize(30)
	sleep(3.5 SECONDS)
	to_chat(user, span_warning("My incisors transform to predatory fangs!"))
	playsound(get_turf(user), 'sound/combat/fracture/fracturewet (1).ogg', 70, TRUE, -1)
	user.emote("rage", forced = TRUE)
	ADD_TRAIT(user, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_BESTIALSENSE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	user.update_sight()
	user.remove_spell(/datum/action/cooldown/spell/undirected/bless_crops)
	user.add_spell(/datum/action/cooldown/spell/undirected/conjure_item/briar_claw)
	user.apply_status_effect(/datum/status_effect/buff/barbrage/briarrage)
	to_chat(user, span_warning("Things that grow no longer interest me, the desire to hunt fills my heart!"))

/obj/item/dendor_blessing/falconing
	name = "falconing blessing of Dendor"
	icon_state = "dendor_consume"
	color = "#d52bff"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_volf
	path_trait = TRAIT_DENDOR_DEVOURING
	required_trait = TRAIT_DENDOR_DEVOURING
	gives_tier2 = TRUE

/obj/item/dendor_blessing/falconing/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/mobs/bird/birdfly.ogg', 100, TRUE)
	playsound(get_turf(user), 'sound/misc/wind.ogg', 100, TRUE, -1)
	to_chat(user, span_good("You feel winged beings guide you from above."))
	user.emote("smile")
	user.add_spell(/datum/action/cooldown/spell/projectile/falcon_disrupt, source = user.cleric)
	user.apply_status_effect(/datum/status_effect/buff/calm)

/*	.................  Purple Blessings of Dendor   ................... */
/obj/item/dendor_blessing/lording
	name = "lording blessing of Dendor"
	icon_state = "dendor_lord"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_troll
	path_trait = TRAIT_DENDOR_LORDING
	unlocks_recipe = /datum/repeatable_crafting_recipe/dendor/sacrifice_shaping

/obj/item/dendor_blessing/lording/check_blessing_requirements(mob/living/user)
	if(!user.get_spell(/datum/action/cooldown/spell/healing))
		to_chat(user, span_warning("My faith to Dendor is insufficient..."))
		return FALSE
	return ..()

/obj/item/dendor_blessing/lording/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	playsound(get_turf(user), pick('sound/vo/mobs/troll/idle1.ogg','sound/vo/mobs/troll/idle2.ogg'), 50, TRUE)
	to_chat(user, span_good("The rumblings of a troll echo through the trees, your offering was acknowledged by the ancient dwellers of the forest."))
	user.emote("rage", forced = TRUE)
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	user.physiology.pain_mod *= 0.6
	user.remove_spell(/datum/action/cooldown/spell/healing)
	user.add_spell(/datum/action/cooldown/spell/undirected/shapeshift/troll_form)
	to_chat(user, span_warning("I no longer care for mending wounds, let the lords of the forest be known!"))

/obj/item/dendor_blessing/shaping
	name = "shaping blessing of Dendor"
	icon_state = "dendor_lord"
	color = "#14b7ff"
	associated_shrine = /obj/structure/fluff/psycross/crafted/shrine/dendor_troll
	path_trait = TRAIT_DENDOR_LORDING
	required_trait = TRAIT_DENDOR_LORDING
	gives_tier2 = TRUE

/obj/item/dendor_blessing/shaping/give_blessing(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
	playsound(get_turf(user), pick('sound/vo/mobs/troll/idle1.ogg','sound/vo/mobs/troll/idle2.ogg'), 50, TRUE)
	to_chat(user, span_good("You grow taller and stronger, the might of Dendor surges through you."))
	user.emote("smile")
	user.add_spell(/datum/action/cooldown/spell/undirected/troll_shape, source = user.cleric)
	user.apply_status_effect(/datum/status_effect/buff/calm)

