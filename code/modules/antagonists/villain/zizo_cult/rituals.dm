// RITUAL DATUMS
/datum/ritual
	abstract_type = /datum/ritual
	var/name = "DVRK AND EVIL RITVAL"
	// Special thing needed for the ritual, such as an sacrifical lamb or a piece of paper
	var/special_requiment
	var/descrequiment
	var/list/ingredients = list()
	var/atom/output
	/// If zizo followers can't perform this
	var/is_cultist_ritual = FALSE
	var/success_message
	var/description
	var/hides_from_books = FALSE
	abstract_type = /datum/ritual

/datum/ritual/proc/invoke(mob/living/user, turf/center)
	if(success_message)
		to_chat(user, SPAN_GOD_ZIZO(success_message))
	return

/datum/ritual/proc/invoke_requiments(mob/living/user, turf/center)
	return TRUE

/datum/ritual/convert
	name = "Convert"
	description = "A way for a herald to grant insight to their followers. Requires a source of knowledge - A brain, Trying to force somebody into accepting it is a waste of time and resources."
	special_requiment = /mob/living/carbon/human
	descrequiment = "An open-minded person, willing to embrace the future."
	ingredients = list(/obj/item/organ/brain)

	is_cultist_ritual = TRUE

/datum/ritual/convert/invoke_requiments(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return FALSE
	if(target == user)
		return FALSE
	if(is_zizocultist(target.mind) || is_zizolackey(target.mind))
		return
	if(!target.client)
		return FALSE
	if(is_antag_banned(target.ckey, ROLE_ZIZOIDCULTIST))
		to_chat(user, span_danger("This one is unworthy of her aiding her ascension."))
		return FALSE
	if(istype(target.wear_neck, /obj/item/clothing/neck/psycross/silver) || istype(target.wear_wrists, /obj/item/clothing/neck/psycross/silver) )
		to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
		return FALSE
	return TRUE

/datum/ritual/convert/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist)
	var/alert = tgui_alert(target, "YOU WILL BE SHOWN THE TRUTH. DO YOU ACCEPT IT?", "???", list("Yield", "Resist"))
	target.Immobilize(3 SECONDS)
	if(alert == "Yield")
		to_chat(target, span_notice("I see the truth now! It all makes so much sense! They aren't HERETICS! They want the BEST FOR US!"))
		PR.add_cultist(target.mind)
		target.praise()
	else
		target.visible_message(span_danger("[target] thrashes around, unyielding!"))
		to_chat(target, SPAN_GOD_ZIZO("You are unworthy of my gifts."))
		if(target.electrocute_act(10))
			target.emote("painscream")

/datum/ritual/skeletaljaunt
	name = "Skeletal Jaunt"
	description = "Abandon your flesh for higher durability. Only cultists might g through this rite"
	special_requiment = /mob/living/carbon/human
	descrequiment = "Cultist wishing to shed his flesh."

	ingredients = list(/obj/item/organ/heart)

	is_cultist_ritual = TRUE

/datum/ritual/skeletaljaunt/invoke_requiments(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target.mind?.has_antag_datum(/datum/antagonist/zizocultist))
		to_chat(user, SPAN_GOD_ZIZO("ONLY THOSE WHO EMBRACED HER MIGHT SHED THEIR SKIN WILLINGLY."))
		return FALSE
	return TRUE

/datum/ritual/skeletaljaunt/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return

	var/datum/job/summon_job = SSjob.GetJobType(/datum/job/skeleton/zizoid)
	target.mind?.set_assigned_role(summon_job)
	target.dress_up_as_job(summon_job)
	summon_job.after_spawn(target, target.client)
	ADD_TRAIT(target, TRAIT_CABAL, TRAIT_GENERIC)

	to_chat(target, SPAN_GOD_ZIZO("I am returned to serve. I will obey, so that I may return to rest."))

/datum/ritual/falseappearance
	name = "Falsified Appearance"
	special_requiment = /mob/living/carbon/human
	description = "You won't recognise your own reflection. There's no way to reverse it."

	ingredients = list(/obj/item/bodypart/head, /obj/item/natural/glass/shard, /obj/item/natural/glass/shard, /obj/item/natural/glass/shard)

/datum/ritual/falseappearance/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_warning("The fruits of her work prevent me from changing my appearance..."))
		return
	target.randomize_human_appearance(include_donator = FALSE)
	target.regenerate_clothes()
	target.update_body()

/datum/ritual/heartache
	name = "Heartaches"
	description = "A pounding heart that temporarily stops a living one from beating, or fills one of Her follower's with blood."
	ingredients = list(/obj/item/natural/worms/leech, /obj/item/organ/heart)
	output = /obj/item/corruptedheart

/obj/item/corruptedheart
	name = "corrupted heart"
	desc = "It sparkles with forbidden magic energy. It makes all the heart aches go away."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart-on"
	w_class =  WEIGHT_CLASS_SMALL

/obj/item/corruptedheart/attack(mob/living/target, mob/living/user, list/modifiers)
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return

	if(istype(target.patron, /datum/patron/inhumen/zizo) && CAN_HAVE_BLOOD(target) && target.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		target.set_blood_volume(BLOOD_VOLUME_NORMAL)
		to_chat(target, span_notice("My elixir of life is stagnant once again."))
		qdel(src)
		return

	if(!do_after(user, 2 SECONDS, target))
		return

	if(target.cmode)
		user.electrocute_act(30)

	target.Stun(10 SECONDS)

	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.adjust_silence(30 SECONDS)

	qdel(src)

/datum/ritual/darksunmark
	name = "Dark Sun's Mark"
	description = "The Sinistar's men lust for blood. Point them to whoever might have wronged you."
	special_requiment = /obj/item/paper // We must read the name off something
	descrequiment = "A piece of parchment with victim's name."
	ingredients = list(/obj/item/weapon/knife/dagger)

/datum/ritual/darksunmark/invoke_requiments(mob/living/user, turf/center)
	var/obj/item/paper/P = locate() in center.contents
	if(!P)
		to_chat(user, SPAN_GOD_ZIZO("The ritual requires a parchment with a name."))
		return FALSE
	return TRUE
/datum/ritual/darksunmark/invoke(mob/living/user, turf/center)
	var/obj/item/paper/P = locate() in center.contents
	var/paper_name = STRIP_HTML_FULL(P.info, MAX_NAME_LEN)
	if(!user.mind || !user.mind.do_i_know(name = paper_name))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return
	var/mob/living/carbon/human/target
	var/assassin_found = FALSE
	for(var/mob/living/carbon/human/HL as anything in GLOB.human_list)
		if(HL.stat == DEAD)
			continue
		if(HL.real_name == paper_name)
			target = HL
			continue
		if(HAS_TRAIT(HL, TRAIT_ASSASSIN))
			assassin_found = TRUE
			var/obj/item/weapon/knife/dagger/steel/inhumen/profane/dagger = locate() in HL.get_all_gear()
			if(dagger)
				to_chat(HL, "profane dagger whispers, <span class='danger'>\"The terrible Zizo has called for our aid. Hunt and strike down our common foe, [paper_name]!\"</span>")
	if(!target || !assassin_found)
		to_chat(user, span_warning("There has been no answer to your call to the Dark Sun. It seems his servants are far from here..."))
		return
	if(!target.get_quirk(/datum/quirk/vice/hunted))
		target.add_quirk(/datum/quirk/vice/hunted)
		var/datum/quirk/vice/hunted/quirk = target.get_quirk(/datum/quirk/vice/hunted)
		quirk.desc = "You have been marked for death. You will be hunted and have assassination attempts made against you without any escalation."
		quirk.customization_value = "Marked for death by the terrible Zizo."
		to_chat(user, span_warning("Your target has been marked, your profane call answered by the Dark Sun. [target.real_name] will surely perish!"))
		to_chat(target, span_warningbig("My hair stands on end. Has someone just said my name? I should watch my back."))
		log_hunted("[key_name(target)] playing as [target] had the hunted flaw by Zizoid curse.")
	else
		to_chat(user, span_warning("Your target is already hunted by the Dark Sun's assassins."))
	qdel(P)
	target.playsound_local(target, 'sound/magic/marked.ogg', 100)

// Item focused rituals

/datum/ritual/tutorialbook
	name = "Tome of Knowledge"
	description = "A gift to all who seek to change the world."
	success_message = "A gift to all who seek to change the world."
	ingredients = list(/obj/item/book)
	output = /obj/item/recipe_book/zizo_cult

/datum/ritual/tutorialbook/alternativerecipe
	ingredients = list(/obj/item/recipe_book)
	hides_from_books = TRUE

/datum/ritual/allseeingeye
	name = "All-seeing Eye"
	description = "The All-seeing Eye. To see beyond sight."
	success_message = "The All-seeing Eye. To see beyond sight."
	ingredients = list(/obj/item/organ/eyes)
	output = /obj/item/scrying/eye

/datum/ritual/cross
	name = "Summon Amulet of Zizo"
	description = "The Gods of old are casted away into the cold darkness. What they call profanation is our defiance."
	success_message = "The Gods of old are casted away into the cold darkness. What they call profanation is our defiance."
	output = /obj/item/clothing/neck/psycross/zizo
	ingredients = list(/obj/item/clothing/neck/psycross)

/datum/ritual/propaganda
	name = "Propaganda"
	description = "A leech to make their minds wrangled. They'll be in bad spirits."
	success_message = "A leech to make their minds wrangled. They'll be in bad spirits."
	ingredients = list(/obj/item/natural/worms/leech, /obj/item/paper, /obj/item/natural/feather)
	output = /obj/item/natural/worms/leech/propaganda

/datum/ritual/invademind
	name = "Invade Mind"
	description = "Seep into their thoughts. The power of the mind is infinite."
	success_message = "I feel like my mind is no longer bound to my body's confines. I can force my will onto others."
	ingredients = list(/obj/item/natural/feather, /obj/item/paper)

/datum/ritual/invademind/invoke(mob/living/user, turf/center)
	user.add_spell(/datum/action/cooldown/spell/undirected/message)
	user.add_spell(/datum/action/cooldown/spell/undirected/list_target/encode_thoughts)

/datum/ritual/summonneant
	name = "Summon Neant"
	special_requiment = /mob/living/carbon/human
	description = "Lay down a living nobleman in the middle, make sure he is ALIVE! When the words are spoken from his ribs a powerful weapon shall emerge."
	descrequiment = "A blue-blooded sacrifice."
	ingredients = list(/obj/item/reagent_containers/lux, /obj/item/ingot/steel)
	output = /obj/item/weapon/polearm/neant

	is_cultist_ritual = TRUE

/datum/ritual/summonneant/invoke(mob/living/user, turf/center)
	output = null
	var/mob/living/carbon/human/noble = locate() in center.contents
	if(!(noble.is_noble()) && noble.stat == DEAD)
		return
	noble.gib()
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	output = /obj/item/weapon/polearm/neant

	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/summonarmor
	name = "Summon Darksteel Armor"
	special_requiment = /mob/living/carbon/human
	description = "Place a body in the middle. Your enemies shall fear armor made from DARKSTEEL."
	descrequiment = "A humanoid carcass."
	ingredients = list(/obj/item/ingot/steel, /obj/item/ingot/steel)

	is_cultist_ritual = TRUE

/datum/ritual/summonarmor/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat == DEAD)
		target.gib(FALSE, FALSE, FALSE)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/clothing/armor/plate/full/inhumen/zizo(center)

	new /obj/item/clothing/pants/platelegs/inhumen/zizo(center)

	new /obj/item/clothing/shoes/boots/armor/inhumen/zizo(center)

	new /obj/item/clothing/head/helmet/heavy/inhumen/zizo(center)

	new /obj/item/clothing/gloves/plate/inhumen/zizo(center)

	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/summonweapon
	name = "Summon Weapons"
	description = "Darksteel weaponry, enough to arm three seekers."
	ingredients = list(/obj/item/ingot/steel)

	is_cultist_ritual = TRUE

/datum/ritual/summonweapon/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/weapon/sword/long/greatsword/zizo_kriegsmesser(center)

	new /obj/item/weapon/sword/arming/zizo_arming(center)

	new /obj/item/weapon/sword/long/zizo_longsword(center)

	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

// FLESH CRAFTING

/datum/ritual/bunnylegs
	name = "Saliendo Pedes"
	special_requiment = /mob/living/carbon/human
	description = "Powerful upgrade to your own body. Allows you to cross between floor levels with a single jump."
	descrequiment = "Ambitious cultist soon to jump over the moon."
	ingredients = list(/obj/item/bodypart/l_leg, /obj/item/bodypart/r_leg, /obj/item/reagent_containers/food/snacks/meat)
	success_message = "I feel like my legs have become stronger. I can jump onto higher levels!"

	is_cultist_ritual = TRUE

/datum/ritual/bunnylegs/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ZJUMP, TRAIT_GENERIC)

/datum/ritual/fleshmend
	name = "Fleshmend"
	special_requiment = /mob/living/carbon/human
	description = "Replace rotten and dead tissue with fresh meat. The more meat you use, the stronger it is."
	descrequiment = "Wounded individual, seeking Her aid."
	success_message = "Zizo empowers me."
	var/heal_tick = 5
	ingredients = list(/obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/meat)

/datum/ritual/fleshmend/greater
	name = "Fleshmend (T2)"
	heal_tick = 15
	ingredients = list(/obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/meat)
/datum/ritual/fleshmend/greatest
	name = "Fleshmend (T3)"
	heal_tick = 30
	ingredients = list(/obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/meat)

/datum/ritual/fleshmend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.playsound_local(target, 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)
	target.apply_status_effect(/datum/status_effect/buff/healing/fleshmend, null, heal_tick)

/datum/status_effect/buff/healing/fleshmend
	id = "fleshmend"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fleshmend
	visual_type = /obj/effect/temp_visual/heal_rogue/fleshmend
	outline_alpha = 160
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/healing/fleshmend/get_examine_text(mob/user, list/P)
	return span_danger("[P[THEYRE]] bathed in an ominous aura.")

/atom/movable/screen/alert/status_effect/buff/fleshmend
	name = "Fleshmend"
	desc = "Forbidden magick restores my ailments."
	icon_state = "bloodheal"

/obj/effect/temp_visual/heal_rogue/fleshmend
	icon_state = "heal_psycross_invert"

/datum/ritual/darkeyes
	name = "Darkened Eyes"
	description = "Eyes of a true predator, they will have trouble hitting you in the dark."
	special_requiment = /mob/living/carbon/human
	descrequiment = "Subject wishing to defy nature."
	success_message = "I no longer fear what hides in darkness."
	ingredients = list(/obj/item/organ/eyes, /obj/item/organ/eyes, /obj/item/reagent_containers/food/snacks/meat)

/datum/ritual/darkeyes/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.grant_undead_eyes()

/datum/ritual/undead
	name = "Dominate Undead"
	description = "The undead bow down to my will."
	ingredients = list(/obj/item/organ/brain, /obj/item/organ/brain, /obj/item/reagent_containers/food/snacks/rotten/meat)

	is_cultist_ritual = TRUE

/datum/ritual/undead/invoke(mob/living/user, turf/center)
	..()
	var/mob/living/carbon/human/target = user
	if(!target)
		return
	target.set_faction(list(FACTION_UNDEAD))
	target.add_spell(/datum/action/cooldown/spell/gravemark, mastery_spell = TRUE)
	target.add_spell(/datum/action/cooldown/spell/control_undead, mastery_spell = TRUE)
	target.add_spell(/datum/action/cooldown/spell/decompose, mastery_spell = TRUE)

/datum/ritual/arcane
	name = "Siphon Arcane"
	description = "The Mages of Noc waste their own potential. Take their prowess for yourself, exploding their head through the process and leaving you with innate magic."
	special_requiment = /mob/living/carbon/human
	success_message = "Stolen Arcane prowess floods my mind, ZIZO empowers me."
	descrequiment = "Mage which no longer has use for his arcyne powers."
	ingredients = list(/obj/item/spellbook)

	is_cultist_ritual = TRUE

/datum/ritual/arcane/invoke(mob/living/user, turf/center)
	..()
	var/mob/living/carbon/human/cultist = user
	var/mob/living/carbon/human/mage = locate() in center.contents
	if(!(mage.mana_pool?.intrinsic_recharge_sources & MANA_ALL_LEYLINES))
		return
	mage.gib()

	cultist.adjust_stat_modifier(STATMOD_RITUAL, list(/datum/attribute/skill/magic/arcane = 40))
	cultist.adjust_form_mastery_points(12)
	cultist.adjust_technique_mastery_points(5)
	cultist.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)

/datum/ritual/nopain
	name = "Painless Battle"
	description = "A person standing on the sigil shall no longer have their mind clouded with pain, yet the rites leave the body frail."
	special_requiment = /mob/living/carbon/human
	descrequiment = "Whoever rejects the weakness of our bodies - Pain."
	success_message = "I no longer feel pain, but it has come at a terrible cost."
	ingredients = list(/obj/item/organ/heart, /obj/item/organ/brain, /obj/item/reagent_containers/food/snacks/meat)

/datum/attribute_holder/sheet/job/nopain
	raw_attribute_list = list(
		STAT_STRENGTH = -2,
		STAT_CONSTITUTION = -3,
	)

/datum/ritual/nopain/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)

	target.attributes?.add_sheet(/datum/attribute_holder/sheet/job/nopain)

/datum/ritual/immortality
	name = "Flawed Immortality"
	description = "Transform the caster into a figure of stone, turning them completly invicible but trapped in their own body."
	special_requiment = /mob/living/carbon/human
	ingredients = list(/obj/item/natural/stone, /obj/item/natural/stone, /obj/item/natural/stone)
	descrequiment = "A construct of the Gods, a body of an Aasimar."
	success_message = "ZIZO EMPOWERS ME!! SOMETHING HAS GONE WRONG, THE RITUAL FAILED BUT WHAT IT LEFT ME WITH IS STILL POWER!!"

/datum/attribute_holder/sheet/job/immortality
	raw_attribute_list = list(
		STAT_STRENGTH = -3,
		STAT_SPEED = -4,
		STAT_ENDURANCE = -4,
	)

/datum/ritual/immortality/invoke_requiments(mob/living/user, turf/center)
	var/mob/living/carbon/human/victim = locate() in center.contents
	if(!(is_species(victim, /datum/species/aasimar)))
		to_chat(user, SPAN_GOD_ZIZO("ONLY AN AASIMAR CAN BE USED AS A CATALYST."))
		return FALSE
	return TRUE

/datum/ritual/immortality/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/victim = locate() in center.contents
	var/mob/living/carbon/human/target = user

	victim.gib()
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NODEATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_WOUNDREGEN, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_PACIFISM, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_SPELLBLOCK, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_ABOMINATION, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)

	target.attributes?.add_sheet(/datum/attribute_holder/sheet/job/immortality)
	target.Knockdown(5 SECONDS)
	target.emote("agony", forced = TRUE)
	target.add_spell(/datum/action/cooldown/spell/undirected/regenerate)

/datum/ritual/fleshform
	name = "Stronger Form"
	description = "A punishment for peasants that defied The Arch-lich was having their bodies mutiliated, and the guts reanimated to terrorise."
	special_requiment = /mob/living/carbon/human
	descrequiment = "Victim to be turned into a beast, alive or not."

	ingredients = list(/obj/item/organ/guts, /obj/item/organ/guts, /obj/item/reagent_containers/food/snacks/meat, /obj/item/reagent_containers/food/snacks/meat)
	is_cultist_ritual = TRUE

/datum/ritual/fleshform/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(is_zizocultist(target.mind))
		to_chat(target, span_danger("I'm not letting my strongest follower become a mindless brute."))
		return
	if(!target.mind)
		to_chat(target, span_warning("A mindless beast will not serve our cause."))
		return
	to_chat(target, SPAN_GOD_ZIZO("SOON I WILL BECOME A HIGHER FORM!"))
	addtimer(CALLBACK(src, PROC_REF(flesh_convert), target, center), 5 SECONDS)

/datum/ritual/fleshform/proc/flesh_convert(mob/living/victim, turf/place)
	if(QDELETED(victim))
		return
	if(place != get_turf(victim))
		return
	if(!victim.mind)
		return
	var/mob/living/trl = new /mob/living/simple_animal/hostile/retaliate/blood(place)
	victim.mind.transfer_to(trl)
	victim.gib()

/datum/ritual/gutted
	name = "Gutted Fish"
	description = "Acquisition of organs and flesh required for the ritual was a tedious work at the beginning. Now all it takes is a shard of glass to dance, cutting each new body the same exact way."
	special_requiment = /mob/living/carbon/human // One to be gutted.human
	descrequiment = "Dead humanoid body, that still has something inside that can be released. "
	ingredients = list(/obj/item/natural/glass/shard)
	output = /obj/item/natural/glass/shard

/datum/ritual/gutted/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat != DEAD)
		return
	target.take_overall_damage(500, damage_type = BCLASS_PIERCE)
	center.visible_message(span_danger("[target] is lifted up into the air and the shard starts precisely making incisions and cuts into their skin as all of their internal organs spill on the floor below!"))
	var/atom/drop_location = target.drop_location()
	for(var/obj/item/organ/organ as anything in target.internal_organs)
		organ.Remove(target)
		organ.forceMove(drop_location)
	var/obj/item/bodypart/chest/cavity = target.get_bodypart(BODY_ZONE_CHEST)
	for(var/atom/movable/item as anything in cavity.cavity_items)
		item.forceMove(drop_location)
		cavity.cavity_items -= item
	for(var/obj/item/bodypart/part as anything in target.bodyparts)
		part.drop_limb()

/datum/ritual/badomen
	name = "Bad Omen"
	description = "A beacon into the skies above, invisible to naked eye it calls the attention of The Profanator. Lit few candles in a dark room and lay them opposite to themselves on the sigil. Now a victim must be brought, force it to lay still on the circle. Ritually execute it through a throat slice, and mutter the words only when they lose conciousness, but their heart still clings to life. "
	special_requiment = /mob/living/carbon/human
	descrequiment = "A sacrifical lamb. Not yet dead, but barely alive."
	is_cultist_ritual = TRUE
	success_message = "I can feel Her gaze on me. Soon this place shall begin to twist and distrort."
	ingredients = list(/obj/item/candle, /obj/item/candle)

/datum/ritual/badomen/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat != DEAD && target.stat != CONSCIOUS)
		target.gib(FALSE, FALSE, FALSE)
		addomen(OMEN_ROUNDSTART)

/datum/ritual/ascend
	name = "ASCEND!"
	special_requiment = /mob/living/carbon/human // virgin
	descrequiment = "A pure-hearted virgin."
	success_message = "I HAVE DONE IT! I HAVE REACHED A HIGHER FORM! ZIZO SMILES UPON ME WITH MALICE IN HER EYES TOWARD THE ONES WHO LACK KNOWLEDGE AND UNDERSTANDING!"

	ingredients = list(/obj/item/clothing/head/crown/serpcrown)

	is_cultist_ritual = TRUE

/datum/ritual/ascend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/cultist = user
	var/mob/living/carbon/human/virgin = locate() in center.contents
	virgin.gib()
	SSmapping.retainer.cult_ascended = TRUE
	addomen(OMEN_ASCEND)
	var/mob/living/trl = new /mob/living/simple_animal/hostile/retaliate/blood/ascended(center)
	cultist.mind?.transfer_to(trl)
	cultist.gib()
	priority_announce("The sky blackens, a dark day for Psydonia.", "Ascension", 'sound/misc/gods/astrata_omen.ogg')
	for(var/mob/living/carbon/human/V in GLOB.human_list)
		if(V.mind in SSmapping.retainer.cultists)
			V.add_stress(/datum/stress_event/lovezizo)
		else
			V.add_stress(/datum/stress_event/hatezizo)
	SSgamemode.roundvoteend = TRUE
	SSgamemode.round_ends_at = world.time - SSticker.round_start_time + 15 MINUTES

// To avoid the crown being deleted
/datum/ritual/ascend/invoke_requiments(mob/living/user, turf/center)
	if(!is_zizocultist(user.mind))
		to_chat(user, SPAN_GOD_ZIZO("YOU WERE NOT CHOSEN. THIS RITUAL IS NOT FOR YOU TO PERFORM."))
		return FALSE
	var/mob/living/carbon/human/virgin = locate() in center.contents
	if(!HAS_TRAIT(virgin, TRAIT_VIRGIN))
		to_chat(user, SPAN_GOD_ZIZO("THE SIGILS DO NOT REACT TO THE BLOOD. THE SACRIFICE IS NOT A VIRGIN!"))
		return FALSE
	return TRUE
