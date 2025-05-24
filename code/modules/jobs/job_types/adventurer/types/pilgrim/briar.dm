/datum/advclass/pilgrim/briar
	name = "Briar"
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/adventurer/briar
	category_tags = list(CTAG_PILGRIM)
	tutorial = "Stoic gardeners or flesh-eating predators, all can follow Dendors path. <br>His Briars scorn civilized living, many embracing their animal nature, being fickle and temperamental."
//	allowed_patrons = list(/datum/patron/divine/dendor)		this doesn't work so long its a subclass type. Besides its preferable to forceswitch as it does to make selection less clunky.
	cmode_music = 'sound/music/cmode/combat_dendor.ogg'
	maximum_possible_slots = 4	// to be lowered to 2? once testing is done

/datum/outfit/job/adventurer/briar/pre_equip(mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)

	belt = /obj/item/storage/belt/leather/rope
	mask = /obj/item/clothing/face/druid
	neck = /obj/item/clothing/neck/psycross/silver/dendor
	shirt = /obj/item/clothing/armor/leather/vest
	armor = /obj/item/clothing/shirt/robe/dendor
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltl = /obj/item/weapon/knife/stone
	backl = /obj/item/weapon/mace/goden/shillelagh

	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_INT, -1)

	if(H.mind)
		if(H.patron != /datum/patron/divine/dendor)
			H.set_patron(/datum/patron/divine/dendor)

		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
		H.adjust_skillrank(/datum/skill/labor/taming, 4, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, 5, TRUE)
		H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/shillelagh)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/forestdelight)

		if(H.age == AGE_OLD)
			H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)

		// the unique Dendor crafting recipes. Dendor shrines (pantheon cross) and alt cosmetic helmet
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/visage)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/shrine)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/shrine/saiga)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/shrine/volf)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/sacrifice_growing)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/sacrifice_stinging)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/dendor/sacrifice_devouring)

	var/datum/devotion/cleric_holder/C = new /datum/devotion/cleric_holder(H, H.patron)
	H.verbs += list(/mob/living/carbon/human/proc/devotionreport, /mob/living/carbon/human/proc/clericpray)
	C.grant_spells(H)
	/*
	if((H.facial_hairstyle == "Wise Hermit") || (H.facial_hairstyle == "Knightly") || (H.facial_hairstyle == "Raider") || (H.facial_hairstyle == "Rumata") || (H.facial_hairstyle == "Choppe") || (H.facial_hairstyle == "Full Beard") || (H.facial_hairstyle == "Fullest Beard") || (H.facial_hairstyle == "Drinker") || (H.facial_hairstyle == "Knowledge") || (H.facial_hairstyle == "Brew") || (H.facial_hairstyle == "Ranger"))
		C.devotion += 40
	*/
/datum/outfit/job/adventurer/briar
	var/tutorial = "<br><br><font color='#44720e'><span class='bold'>You know well how to make a shrine to Dendor, wood, thorns, and the head of a favored animal.<br><br>Choose a path stinging, devouring or growing, and make your sacrifices...<br><br>Remember - Dendor will only grant special powers from Blessing the first time you do recieve it, and only those mastering all his Miracles can unlock their full potential.  </span></font><br><br>"

/datum/outfit/job/adventurer/briar/post_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, tutorial)


/*	.................   Unique Dendor recipes   ................... */
/datum/crafting_recipe/dendor
	always_availible = FALSE
	craftdiff = 0
	category = CAT_NONE
	subtype_reqs = TRUE // so you can use any subtype of the items
	req_table = FALSE

/datum/crafting_recipe/dendor/visage
	name = "druids mask (unique)"
	reqs = list(/obj/item/grown/log/tree/small = 1)
	result = /obj/item/clothing/face/druid

/datum/crafting_recipe/dendor/shrine
	name = "growing shrine to Dendor (unique)"
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/thorn = 3,
				/obj/item/natural/head/gote = 1)
	result = /obj/structure/fluff/psycross/crafted/shrine/dendor_gote
	verbage = "consecrate"
	verbage_tp = "consecrates"
	craftsound = 'sound/foley/Building-01.ogg'

/datum/crafting_recipe/dendor/shillelagh
	name = "Shillelagh (unique)"
	result = /obj/item/weapon/mace/goden/shillelagh
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/ash = 1,
				/obj/item/reagent_containers/food/snacks/fat =1 )
	craftdiff = 1

/datum/crafting_recipe/dendor/forestdelight
	name = "forest guardian offering (unique)"
	reqs = list(/obj/item/bait/bloody = 1,
				/obj/item/reagent_containers/food/snacks/produce/swampweed_dried = 1,
				/obj/item/reagent_containers/food/snacks/raisins = 1 )
	result = /obj/item/bait/forestdelight

/datum/crafting_recipe/dendor/shrine/saiga
	name = "stinging shrine to Dendor (unique)"
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/thorn = 3,
				/obj/item/natural/head/saiga = 1)
	result = /obj/structure/fluff/psycross/crafted/shrine/dendor_saiga

/datum/crafting_recipe/dendor/shrine/volf
	name = "devouring shrine to Dendor (unique)"
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/thorn = 3,
				/obj/item/natural/head/volf = 1)
	result = /obj/structure/fluff/psycross/crafted/shrine/dendor_volf

/datum/crafting_recipe/dendor/sacrifice_growing
	name = "green sacrifice to Dendor (unique)"
	structurecraft = /obj/structure/fluff/psycross/crafted/shrine/dendor_gote
	reqs = list(/obj/item/natural/worms/grub_silk = 1,
				/obj/item/reagent_containers/food/snacks/produce/swampweed = 1,
				/obj/item/reagent_containers/food/snacks/produce/poppy = 1)
	result = /obj/item/blessing_of_dendor_growing
	verbage = "make"
	verbage_tp = "make"
	craftsound = 'sound/foley/burning_sacrifice.ogg'

/datum/crafting_recipe/dendor/sacrifice_stinging
	name = "yellow sacrifice to Dendor (unique)"
	structurecraft = /obj/structure/fluff/psycross/crafted/shrine/dendor_saiga
	reqs = list(/obj/item/reagent_containers/food/snacks/fish/eel = 1,
				/obj/item/reagent_containers/food/snacks/produce/westleach = 1,
				/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 1)
	result = /obj/item/blessing_of_dendor_stinging
	verbage = "make"
	verbage_tp = "make"
	craftsound = 'sound/foley/burning_sacrifice.ogg'

/datum/crafting_recipe/dendor/sacrifice_devouring
	name = "red sacrifice to Dendor (unique)"
	structurecraft = /obj/structure/fluff/psycross/crafted/shrine/dendor_volf
	reqs = list(/obj/item/bait/bloody = 2)
	result = /obj/item/blessing_of_dendor_devouring
	verbage = "make a"
	verbage_tp = "make a"
	craftsound = 'sound/foley/burning_sacrifice.ogg'

/*	.................   Green Blessings of Dendor   ................... */
/obj/item/blessing_of_dendor_growing
	name = "blessing of Dendor"
	icon = 'icons/roguetown/misc/magick.dmi'
	icon_state = "dendor_grow"
	plane = -1
	layer = 4.2
	alpha = 155
	anchored = TRUE

/obj/item/blessing_of_dendor_growing/attack_hand(mob/living/carbon/human/user)
	if(user.patron.type == /datum/patron/divine/dendor)
		icon_state = "dendor_grow_end"

		if(!do_after(user, 3 SECONDS, target = user))
			icon_state = "dendor_grow"
			return

		if(HAS_TRAIT(user, TRAIT_BLESSED))
			to_chat(user, span_info("Dendor will not grant more powers, but he still approves of the sacrifice, judging by the signs..."))
			user.apply_status_effect(/datum/status_effect/buff/blessed)
			GLOB.vanderlin_round_stats[STATS_DENDOR_SACRIFICES]++
			qdel(src)
			return

		playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
		playsound(get_turf(user), 'sound/misc/wind.ogg', 100, TRUE, -1)
		to_chat(user, span_notice("Plants grow rampant with your every step...things that constrain no longer does."))
		user.emote("smile")
		ADD_TRAIT(user, TRAIT_BLESSED, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_WEBWALK, TRAIT_GENERIC)
		user.AddSpell(new /obj/effect/proc_holder/spell/invoked/entangler(null))
		if(user.mind.has_spell(/obj/effect/proc_holder/spell/targeted/beasttame))
			user.apply_status_effect(/datum/status_effect/buff/calm)
	else
		to_chat(user, span_warning("Dendor finds me unworthy..."))

	GLOB.vanderlin_round_stats[STATS_DENDOR_SACRIFICES]++
	qdel(src)

/*	.................   Yellow Blessings of Dendor   ................... */
/obj/item/blessing_of_dendor_stinging
	name = "blessing of Dendor"
	icon = 'icons/roguetown/misc/magick.dmi'
	icon_state = "dendor_sting"
	plane = -1
	layer = 4.2
	alpha = 155
	anchored = TRUE

/obj/item/blessing_of_dendor_stinging/attack_hand(mob/living/carbon/human/user)
	if(user.patron.type == /datum/patron/divine/dendor)
		icon_state = "dendor_sting_end"

		if(!do_after(user, 3 SECONDS, target = user))
			icon_state = "dendor_sting"
			return

		if(HAS_TRAIT(user, TRAIT_BLESSED))
			to_chat(user, span_info("Dendor will not grant more powers, but he still approves of the sacrifice, judging by the signs..."))
			user.apply_status_effect(/datum/status_effect/buff/blessed)
			GLOB.vanderlin_round_stats[STATS_DENDOR_SACRIFICES]++
			qdel(src)
			return

		playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
		playsound(get_turf(user), 'sound/misc/wind.ogg', 100, TRUE, -1)
		to_chat(user, span_notice("You feel as if light follows your every step...your foraging will be easier from now on, surely."))
		user.emote("smile")
		ADD_TRAIT(user, TRAIT_BLESSED, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_MIRACULOUS_FORAGING, TRAIT_GENERIC)
		user.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_kneestingers(null))
		if(user.mind.has_spell(/obj/effect/proc_holder/spell/targeted/beasttame))
			user.apply_status_effect(/datum/status_effect/buff/calm)
	else
		to_chat(user, span_warning("Dendor finds me unworthy..."))

	GLOB.vanderlin_round_stats[STATS_DENDOR_SACRIFICES]++
	qdel(src)

/*	.................  Red Blessings of Dendor   ................... */
/obj/item/blessing_of_dendor_devouring
	name = "blessing of Dendor"
	icon = 'icons/roguetown/misc/magick.dmi'
	icon_state = "dendor_consume"
	plane = -1
	layer = 4.2
	alpha = 155
	anchored = TRUE

/obj/item/blessing_of_dendor_devouring/attack_hand(mob/living/carbon/human/user)
	if(user.patron.type == /datum/patron/divine/dendor)
		icon_state = "dendor_consume_end"

		if(!do_after(user, 3 SECONDS, target = user))
			icon_state = "dendor_consume"
			return

		if(HAS_TRAIT(user, TRAIT_BLESSED))
			to_chat(user, span_info("Dendor will not grant more powers, but he still approves of the sacrifice, judging by the signs..."))
			user.apply_status_effect(/datum/status_effect/buff/blessed)
			GLOB.vanderlin_round_stats[STATS_DENDOR_SACRIFICES]++
			qdel(src)
			return

		playsound(get_turf(user), 'sound/vo/smokedrag.ogg', 100, TRUE)
		to_chat(user, span_notice("A volf howls far away...and your teeth begin to sear with pain. Your sacrifice was accepted!"))
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
		ADD_TRAIT(user, TRAIT_BLESSED, TRAIT_GENERIC)

		if(user.mind)
			if(user.mind.has_spell(/obj/effect/proc_holder/spell/targeted/blesscrop))
				user.apply_status_effect(/datum/status_effect/buff/barbrage)
				user.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/blesscrop)
				to_chat(user, span_warning("Things that grow no longer interests me, the desire to hunt fills my heart!"))
			if(user.mind.has_spell(/obj/effect/proc_holder/spell/targeted/beasttame))
				user.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/lesser_heal)
				user.AddSpell(new /obj/effect/proc_holder/spell/self/trollshape(null))
				to_chat(user, span_warning("I no longer care for mending wounds, let my rage be heard!"))
	else
		to_chat(user, span_warning("Dendor finds me unworthy..."))

	GLOB.vanderlin_round_stats[STATS_DENDOR_SACRIFICES]++
	qdel(src)
