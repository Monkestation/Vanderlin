GLOBAL_LIST_INIT(ritualslist, build_zizo_rituals())

/proc/build_zizo_rituals()
	. = list()
	for(var/datum/ritual/ritual as anything in subtypesof(/datum/ritual))
		if(IS_ABSTRACT(ritual))
			continue
		.[ritual.name] = new ritual

// RITUAL DATUMS
/datum/ritual
	abstract_type = /datum/ritual
	var/name = "DVRK AND EVIL RITVAL"
	var/center_requirement
	// This is absolutely fucking terrible. I tried to do it with lists but it just didn't work and
	//kept runtiming. Something something, can't access list inside a datum.
	//I couldn't find a more efficient solution to do this, I'm sorry. -7
	var/n_req
	var/e_req
	var/s_req
	var/w_req
	/// If zizo followers can't perform this
	var/is_cultist_ritual = FALSE

/datum/ritual/proc/invoke(mob/living/user, turf/center)
	return

// SERVANTRY
/datum/ritual/servantry
	abstract_type = /datum/ritual/servantry

/datum/ritual/servantry/convert
	name = "Convert"
	center_requirement = /mob/living/carbon/human

	is_cultist_ritual = TRUE

/datum/ritual/servantry/convert/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target == user)
		return
	if(is_zizocultist(target.mind) || is_zizolackey(target.mind))
		return
	if(!target.client)
		return
	if(istype(target.wear_neck, /obj/item/clothing/neck/psycross/silver) || istype(target.wear_wrists, /obj/item/clothing/neck/psycross/silver) )
		to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
		return
	var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist)
	var/alert = browser_alert(target, "YOU WILL BE SHOWN THE TRUTH. DO YOU RESIST?", "???", list("Yield", "Resist"))
	target.Immobilize(3 SECONDS)
	if(alert == "Yield")
		to_chat(target, span_notice("I see the truth now! It all makes so much sense! They aren't HERETICS! They want the BEST FOR US!"))
		PR.add_cultist(target.mind)
		target.praise()
	else
		target.visible_message(span_danger("[target] thrashes around, unyielding!"))
		to_chat(target, span_danger("Yield."))
		if(target.electrocute_act(10))
			target.emote("painscream")

/datum/ritual/servantry/skeletaljaunt
	name = "Skeletal Jaunt"
	center_requirement = /mob/living/carbon/human

	n_req = /obj/item/organ/heart

	is_cultist_ritual = TRUE

/datum/ritual/servantry/skeletaljaunt/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target == user)
		return
	if(is_zizocultist(target.mind))
		to_chat(target, span_danger("I will not let my followers become mindless brutes."))
		return

	var/datum/job/summon_job = SSjob.GetJobType(/datum/job/skeleton/zizoid)
	target.mind?.set_assigned_role(summon_job)
	target.dress_up_as_job(summon_job)
	summon_job.after_spawn(target, target.client)
	ADD_TRAIT(target, TRAIT_CABAL, TRAIT_GENERIC)

	to_chat(target, span_userdanger("I am returned to serve. I will obey, so that I may return to rest."))
	to_chat(target, span_userdanger("My master is [user]."))

/datum/ritual/servantry/thecall
	name = "The Call"
	center_requirement = /obj/item/bedsheet

	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg

/datum/ritual/servantry/thecall/invoke(mob/living/user, turf/center)
	var/obj/item/paper/P = locate() in center
	if(!P)
		to_chat(user, span_warning("The ritual requires a parchment with a name."))
		return
	var/paper_name = STRIP_HTML_FULL(P.info, MAX_NAME_LEN)
	if(!user.mind?.do_i_know(name = paper_name))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return
	for(var/mob/living/carbon/human/HL as anything in GLOB.human_list)
		if(HL.real_name != paper_name)
			continue
		if(HL == SSticker.rulermob)
			break
		if(HL.mind?.assigned_role.title in GLOB.church_positions)
			to_chat(HL, span_warning("I sense an unholy presence loom near my soul."))
			to_chat(user, span_danger("They are protected..."))
			break
		if(istype(HL.wear_neck, /obj/item/clothing/neck/psycross/silver) || istype(HL.wear_wrists, /obj/item/clothing/neck/psycross/silver))
			to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
			break
		if(!HAS_TRAIT(HL, TRAIT_NOSLEEP))
			to_chat(HL, span_userdanger("I'm so sleepy..."))
			HL.SetSleeping(5 SECONDS)
		else
			to_chat(HL, span_userdanger("My eyes close on their own!"))
			HL.set_eyes_closed(TRUE)
		addtimer(CALLBACK(src, PROC_REF(kidnap), HL, center), 3 SECONDS)
		qdel(P)
		break

/datum/ritual/servantry/thecall/proc/kidnap(mob/living/victim, turf/to_go)
	if(QDELETED(victim))
		return
	if(to_go.is_blocked_turf(TRUE))
		return
	victim.SetSleeping(0)
	to_chat(victim, span_warning("This isn't my bed... Where am I?!"))
	victim.playsound_local(victim, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
	victim.forceMove(to_go)

/datum/ritual/servantry/falseappearance
	name = "Falsified Appearance"
	center_requirement = /mob/living/carbon/human

	n_req = /obj/item/bodypart/head
	s_req = /obj/item/natural/glass/shard
	e_req = /obj/item/natural/glass/shard
	w_req = /obj/item/natural/glass/shard

/datum/ritual/servantry/falseappearance/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_warning("The fruits of her work prevent me from changing my appearance..."))
		return
	target.randomize_human_appearance(include_donator = FALSE)
	target.regenerate_clothes()
	target.update_body()

/datum/ritual/servantry/heartache
	name = "Heartaches"
	center_requirement = /obj/item/organ/heart

	n_req = /obj/item/natural/worms/leech

/datum/ritual/servantry/heartache/invoke(mob/user, turf/center)
	new /obj/item/corruptedheart(center)
	to_chat(user, span_notice("A corrupted heart. When used on a non-enlightened mortal their heart shall ache and they will be immobilized and too stunned to speak. Perfect for getting new soon-to-be enlightened. Now, just don't use it at the combat ready."))

/obj/item/corruptedheart
	name = "corrupted heart"
	desc = "It sparkles with forbidden magic energy. It makes all the heart aches go away."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart-on"
	w_class =  WEIGHT_CLASS_SMALL

/obj/item/corruptedheart/attack(mob/living/target, mob/living/user, list/modifiers)
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return
	if(istype(target.patron, /datum/patron/inhumen/zizo))
		target.blood_volume = BLOOD_VOLUME_MAXIMUM
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

/datum/ritual/servantry/darksunmark
	name = "Dark Sun's Mark"
	center_requirement = /obj/item/weapon/knife/dagger // Requires a combat dagger. Can be iron, steel or silver.

/datum/ritual/servantry/darksunmark/invoke(mob/living/user, turf/center)
	var/obj/item/paper/P = locate() in center.contents
	if(!P)
		to_chat(user, span_warning("The ritual requires a parchment with a name."))
		return
	var/obj/item/weapon/knife/dagger/D = locate() in center.contents
	if(!D)
		to_chat(user, span_warning("A dagger is required as a sacrifice."))
		return
	var/paper_name = STRIP_HTML_FULL(P.info, MAX_NAME_LEN)
	if(!user.mind || !user.mind.do_i_know(name = paper_name))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return
	var/mob/living/carbon/human/target
	var/assassin_found = FALSE
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.stat != DEAD)
			continue
		if(HL.real_name == paper_name)
			target = HL
		else if(HAS_TRAIT(HL, TRAIT_ASSASSIN))
			assassin_found = TRUE
			var/obj/item/weapon/knife/dagger/steel/profane/dagger = locate() in HL.get_all_gear()
			if(dagger)
				to_chat(HL, "profane dagger whispers, <span class='danger'>\"The terrible Zizo has called for our aid. Hunt and strike down our common foe, [target.real_name]!\"</span>")
	if(!target || !assassin_found)
		to_chat(user, span_warning("There has been no answer to your call to the Dark Sun. It seems his servants are far from here..."))
		return
	ADD_TRAIT(target, TRAIT_ZIZOID_HUNTED, TRAIT_GENERIC) // Gives the victim a trait to track that they are wanted dead.
	log_hunted("[key_name(target)] playing as [target] had the hunted flaw by Zizoid curse.")
	to_chat(target, span_danger("My hair stands on end. Has someone just said my name? I should watch my back."))
	to_chat(user, span_warning("Your target has been marked, your profane call answered by the Dark Sun. [target.real_name] will surely perish!"))
	qdel(D)
	qdel(P)
	target.playsound_local(target, 'sound/magic/marked.ogg', 100)

// TRANSMUTATION
/datum/ritual/transmutation
	abstract_type = /datum/ritual/transmutation

/datum/ritual/transmutation/allseeingeye
	name = "All-seeing Eye"
	center_requirement = /obj/item/organ/eyes

/datum/ritual/transmutation/allseeingeye/invoke(mob/living/user, turf/center)
	. = ..()
	new /obj/item/scrying/eye(center)
	to_chat(user, span_notice("The All-seeing Eye. To see beyond sight."))

/datum/ritual/transmutation/cross
	name = "Summon Amulet of Zizo"
	center_requirement = /obj/item/clothing/neck/psycross

/datum/ritual/transmutation/cross/invoke(mob/living/user, turf/center)
	. = ..()
	new /obj/item/clothing/neck/psycross/zizo(center)
	to_chat(user, span_notice("The psycross is transmuted into an amulet of Zizo."))

/datum/ritual/transmutation/criminalstool
	name = "Criminal's Tool"
	center_requirement = /obj/item/natural/cloth

/datum/ritual/transmutation/criminalstool/invoke(mob/living/user, turf/center)
	new /obj/item/soap/cult(center)
	to_chat(user, span_notice("The Criminal's Tool. Could be useful for hiding tracks or getting rid of sigils."))

/obj/item/soap/cult
	name = "accursed soap"
	desc = "It is pulsating."
	clean_speed = 1
	clean_effectiveness = 100
	clean_strength = CLEAN_ALL
	color = LIGHT_COLOR_BLOOD_MAGIC
	uses = 200

/datum/ritual/transmutation/propaganda
	name = "Propaganda"
	center_requirement = /obj/item/natural/worms/leech
	n_req = /obj/item/paper
	s_req = /obj/item/natural/feather

/datum/ritual/transmutation/propaganda/invoke(mob/living/user, turf/center)
	new /obj/item/natural/worms/leech/propaganda(center)
	to_chat(user, span_notice("A leech to make their minds wrangled. They'll be in bad spirits."))

// Wtf is this shit
// /datum/ritual/transmutation/falseidol
// 	name = "False Idol"
// 	center_requirement = /mob/living/carbon/human
// 	w_req = /obj/item/paper
// 	s_req = /obj/item/natural/feather

// /datum/ritual/transmutation/falseidol/invoke(mob/living/user, turf/center)
// 	var/mob/living/carbon/human/target = locate() in center.contents
// 	if(!target)
// 		return
// 	var/obj/effect/dummy/falseidol/idol = new(center)

// /obj/effect/dummy/falseidol
// 	name = "false idol"
// 	icon = 'icons/effects/effects.dmi'
// 	icon_state = "static"
// 	desc = "Through lies interwine from blood into truth."

// /obj/effect/dummy/falseidol/Crossed(atom/movable/AM, oldloc)
// 	. = ..()
// 	qdel(src)

/datum/ritual/transmutation/invademind
	name = "Invade Mind"
	center_requirement = /obj/item/natural/feather

/datum/ritual/transmutation/invademind/invoke(mob/living/user, turf/center)
	var/obj/item/paper/P = locate() in center.contents
	if(!P)
		return
	var/info = STRIP_HTML_FULL(P.info, MAX_NAME_LEN)
	var/input = browser_input_text(user, "To whom do we send this message?", "ZIZO")
	if(!input)
		return
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == input)
			to_chat(HL, "<i>You hear a voice in your head... <b>[info]</i></b>")
		qdel(P)

/datum/ritual/transmutation/summonoutfit
	name = "Summon Cult Outfit"
	center_requirement = /obj/item/natural/cloth

/datum/ritual/transmutation/summonoutfit/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/clothing/head/helmet/skullcap/cult(center)

	new /obj/item/clothing/cloak/half/shadowcloak/cult(center)

	new /obj/item/rope/chain(center)

	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonneant
	name = "Summon Neant"
	center_requirement = /obj/item/reagent_containers/lux
	n_req = /mob/living/carbon/human
	s_req = /obj/item/ingot/steel

	is_cultist_ritual = TRUE

/datum/ritual/transmutation/summonneant/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/noble = locate() in get_step(center, NORTH)
	if(!(noble.is_noble()))
		return
	noble.gib()
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/weapon/polearm/neant(center)

	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonarmor
	name = "Summon Darksteel Armor"
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/ingot/steel
	s_req = /obj/item/ingot/steel

	is_cultist_ritual = TRUE

/datum/ritual/transmutation/summonarmor/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat == DEAD)
		target.gib(FALSE, FALSE, FALSE)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/clothing/armor/plate/full/zizo(center)

	new /obj/item/clothing/pants/platelegs/zizo(center)

	new /obj/item/clothing/shoes/boots/armor/zizo(center)

	new /obj/item/clothing/head/helmet/heavy/zizo(center)

	new /obj/item/clothing/gloves/plate/zizo(center)

	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonweapon
	name = "Summon Weapons"
	center_requirement = /obj/item/ingot/steel

	is_cultist_ritual = TRUE

/datum/ritual/transmutation/summonweapon/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/weapon/sword/long/greatsword/zizo(center)

	new /obj/item/weapon/sword/arming(center)

	new /obj/item/weapon/mace/steel(center)

	playsound(center, pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

// FLESH CRAFTING
/datum/ritual/fleshcrafting
	abstract_type = /datum/ritual/fleshcrafting

/datum/ritual/fleshcrafting/bunnylegs
	name = "Saliendo Pedes"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg
	n_req = /obj/item/reagent_containers/food/snacks/meat

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/bunnylegs/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ZJUMP, TRAIT_GENERIC)
	to_chat(target, span_notice("I feel like my legs have become stronger."))

/datum/ritual/fleshcrafting/fleshmend
	name = "Fleshmend"
	center_requirement = /mob/living/carbon/human
	n_req =  /obj/item/reagent_containers/food/snacks/meat

/datum/ritual/fleshcrafting/fleshmend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.playsound_local(target, 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)
	target.fully_heal()
	to_chat(target, span_notice("ZIZO EMPOWERS ME!"))

/datum/ritual/fleshcrafting/darkeyes
	name = "Darkened Eyes"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/organ/eyes
	e_req = /obj/item/organ/eyes
	n_req = /obj/item/reagent_containers/food/snacks/meat

/datum/ritual/fleshcrafting/darkeyes/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.grant_undead_eyes()
	to_chat(target, span_notice("I no longer fear the dark."))

/datum/ritual/fleshcrafting/undead
	name = "Dominate Undead"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/organ/brain
	e_req = /obj/item/organ/brain
	n_req = /obj/item/reagent_containers/food/snacks/rotten/meat

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/undead/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.faction = list(FACTION_UNDEAD)
	target.add_spell(/datum/action/cooldown/spell/gravemark)
	target.add_spell(/datum/action/cooldown/spell/control_undead)
	target.add_spell(/datum/action/cooldown/spell/decompose)
	to_chat(target, span_notice("The undead bow down to my will."))

/datum/ritual/fleshcrafting/arcane
	name = "Siphon Arcane"
	center_requirement = /mob/living/carbon/human

	n_req = /mob/living/carbon/human

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/arcane/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/cultist = locate() in center.contents
	var/mob/living/carbon/human/mage = locate() in get_step(center, NORTH)
	if(!(mage.mana_pool?.intrinsic_recharge_sources & MANA_ALL_LEYLINES))
		return
	mage.gib()
	cultist.adjust_skillrank(/datum/skill/magic/arcane, 4, TRUE)
	cultist.adjust_spell_points(18)
	cultist.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	cultist.generate_random_attunements(rand(6, 8))
	to_chat(cultist, span_notice("Stolen Arcane prowess floods my mind, ZIZO empowers me."))

/datum/ritual/fleshcrafting/curse
    name = "Hollow Curse"
    center_requirement = /mob/living/carbon/human

    w_req = /obj/item/alch/sinew
    e_req = /obj/item/alch/sinew
    n_req = /obj/item/natural/fur/volf
    s_req = /obj/item/natural/fur/volf

/datum/ritual/fleshcrafting/curse/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(!target.mind)
		to_chat(target, span_warning("A mindless servant is useless to me!"))
		return
	if(target.mob_biotypes & MOB_UNDEAD)
		to_chat(target, span_warning("The curse doesn't take hold!"))
		return
	if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
		to_chat(target, span_warning("The curse doesn't take hold!"))
		return
	if(target.get_lux_status() != LUX_HAS_LUX)
		to_chat(target, span_warning("The curse requires lux!"))
		return
	if(target.stat == DEAD)
		return
	to_chat(target, span_warning("My very being, body, soul, and mind is contorted and twisted violently into a ball of flesh and fur, until I am reshaped anew as an abomination!"))
	addtimer(CALLBACK(src, PROC_REF(get_hollowed), target, center), 5 SECONDS)

/datum/ritual/fleshcrafting/curse/proc/get_hollowed(mob/living/victim, turf/place)
	if(QDELETED(victim))
		return
	if(place != get_turf(victim))
		return
	if(!victim.mind)
		return
	if(victim.mob_biotypes & MOB_UNDEAD)
		to_chat(victim, span_warning("The curse doesn't take hold!"))
		return
	if(victim.mind.has_antag_datum(/datum/antagonist/werewolf))
		to_chat(victim, span_warning("The curse doesn't take hold!"))
		return
	if(victim.get_lux_status() != LUX_HAS_LUX)
		to_chat(victim, span_warning("The curse requires lux!"))
		return
	if(victim.stat == DEAD)
		return

	var/mob/living/wll = new /mob/living/carbon/human/species/demihuman(place)
	victim.mind.transfer_to(wll)
	victim.gib()

/datum/ritual/fleshcrafting/nopain
	name = "Painless Battle"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/organ/heart
	e_req = /obj/item/organ/brain
	n_req = /obj/item/reagent_containers/food/snacks/meat

/datum/ritual/fleshcrafting/nopain/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	to_chat(target, span_notice("I no longer feel pain, but it has come at a terrible cost."))
	target.change_stat(STATKEY_STR, -2)
	target.change_stat(STATKEY_CON, -3)

/datum/ritual/fleshcrafting/immortality
	name = "Flawed Immortality"
	center_requirement = /mob/living/carbon/human

	n_req = /mob/living/carbon/human

/datum/ritual/fleshcrafting/immortality/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	var/mob/living/carbon/human/victim = locate() in get_step(center, NORTH)
	if(!(is_species(victim, /datum/species/aasimar)))
		return
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
	to_chat(target, span_notice("ZIZO EMPOWERS ME!! SOMETHING HAS GONE WRONG, THE RITUAL FAILED BUT WHAT IT LEFT ME WITH IS STILL POWER!!"))
	target.adjust_stat_modifier(STATMOD_ABOM, STATKEY_STR, -3)
	target.adjust_stat_modifier(STATMOD_ABOM, STATKEY_SPD, -4)
	target.adjust_stat_modifier(STATMOD_ABOM, STATKEY_END, -4)
	target.Knockdown(5 SECONDS)
	target.emote("agony", forced = TRUE)
	target.add_spell(/datum/action/cooldown/spell/undirected/regenerate)

/datum/ritual/fleshcrafting/fleshform
	name = "Stronger Form"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/organ/guts
	e_req = /obj/item/organ/guts
	n_req = /obj/item/reagent_containers/food/snacks/meat
	s_req = /obj/item/reagent_containers/food/snacks/meat
	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/fleshform/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(is_zizocultist(target.mind))
		to_chat(target, span_danger("I'm not letting my strongest follower become a mindless brute."))
		return
	if(!target.mind)
		to_chat(target, span_warning("A mindless beast will not serve our cause."))
		return
	to_chat(target, span_warning("SOON I WILL BECOME A HIGHER FORM!"))
	addtimer(CALLBACK(src, PROC_REF(flesh_convert), target, center), 5 SECONDS)

/datum/ritual/fleshcrafting/fleshform/proc/flesh_convert(mob/living/victim, turf/place)
	if(QDELETED(victim))
		return
	if(place != get_turf(victim))
		return
	if(!victim.mind)
		return
	var/mob/living/trl = new /mob/living/simple_animal/hostile/retaliate/blood(place)
	victim.mind.transfer_to(trl)
	victim.gib()

/datum/ritual/fleshcrafting/gutted
	name = "Gutted Fish"
	center_requirement = /mob/living/carbon/human // One to be gutted.human

/datum/ritual/fleshcrafting/gutted/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat != DEAD)
		return
	target.take_overall_damage(500)
	center.visible_message(span_danger("[target] is lifted up into the air and multiple scratches, incisions and deep cuts start etching themselves into their skin as all of their internal organs spill on the floor below!"))
	var/atom/drop_location = target.drop_location()
	for(var/obj/item/organ/organ as anything in target.internal_organs)
		organ.Remove(target)
		organ.forceMove(drop_location)
	var/obj/item/bodypart/chest/cavity = target.get_bodypart(BODY_ZONE_CHEST)
	if(cavity.cavity_item)
		cavity.cavity_item.forceMove(drop_location)
		cavity.cavity_item = null
	for(var/obj/item/bodypart/part as anything in target.bodyparts)
		part.drop_limb()

/datum/ritual/fleshcrafting/badomen
	name = "Bad Omen"
	center_requirement = /mob/living/carbon/human
	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/badomen/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat == DEAD)
		target.gib(FALSE, FALSE, FALSE)
		addomen(OMEN_ROUNDSTART)

/datum/ritual/fleshcrafting/ascend
	name = "ASCEND!"
	center_requirement = /mob/living/carbon/human // cult leader

	n_req = /mob/living/carbon/human // the ruler
	s_req = /mob/living/carbon/human // virgin

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/ascend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/cultist = locate() in center.contents
	if(!cultist || cultist != user)
		return
	if(!is_zizocultist(cultist.mind))
		return
	var/mob/living/carbon/human/RULER = locate() in get_step(center, NORTH)
	if(RULER != SSticker.rulermob && RULER.stat != DEAD)
		return
	var/mob/living/carbon/human/VIRGIN = locate() in get_step(center, SOUTH)
	if(!VIRGIN.virginity && VIRGIN.stat != DEAD)
		return
	VIRGIN.gib()
	RULER.gib()
	SSmapping.retainer.cult_ascended = TRUE
	addomen(OMEN_ASCEND)
	to_chat(cultist, span_userdanger("I HAVE DONE IT! I HAVE REACHED A HIGHER FORM! ZIZO SMILES UPON ME WITH MALICE IN HER EYES TOWARD THE ONES WHO LACK KNOWLEDGE AND UNDERSTANDING!"))
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
