#define TRANSFORMATION_DURATION 22
/// Will be removed once the transformation is complete.
#define TEMPORARY_TRANSFORMATION_TRAIT "temporary_transformation"
/// Considered "permanent" since we'll be deleting the old mob and the client will be inserted into a new one (without this trait)
#define PERMANENT_TRANSFORMATION_TRAIT "permanent_transformation"

/mob/living/carbon/proc/monkeyize(tr_flags = (TR_KEEPITEMS | TR_KEEPVIRUS | TR_KEEPSTUNS | TR_KEEPREAGENTS | TR_DEFAULTMSG))
	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return
	//Handle items on mob

	var/list/int_organs = list()

	var/list/missing_bodyparts_zones = get_missing_limbs()

	var/obj/item/cavity_object

	var/obj/item/bodypart/chest/CH = get_bodypart(BODY_ZONE_CHEST)
	if(CH.cavity_item)
		cavity_object = CH.cavity_item
		CH.cavity_item = null

	if(tr_flags & TR_KEEPITEMS)
		var/Itemlist = get_equipped_items(TRUE)
		Itemlist += held_items
		for(var/obj/item/W in Itemlist)
			dropItemToGround(W)

	//Make mob invisible and spawn animation
	ADD_TRAIT(src, TRAIT_NO_TRANSFORM, "monkeyize")
	Paralyze(22, ignore_canstun = TRUE)
	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_MAXIMUM

	new /obj/effect/temp_visual/monkeyify(loc)
	sleep(22)
	var/mob/living/carbon/monkey/O = new /mob/living/carbon/monkey( loc )

	// hash the original name?
	if(tr_flags & TR_HASHNAME)
		O.name = "monkey ([copytext(md5(real_name), 2, 6)])"
		O.real_name = "monkey ([copytext(md5(real_name), 2, 6)])"

	//handle DNA and other attributes
	dna.transfer_identity(O)
	reset_limb_fingerprints()
	O.updateappearance(icon_update=0)

	if(suiciding)
		O.set_suicide(suiciding)
	if(hellbound)
		O.hellbound = hellbound
	O.a_intent = INTENT_HARM

	//keep damage?
	if (tr_flags & TR_KEEPDAMAGE)
		O.setToxLoss(getToxLoss(), 0)
		O.adjustBruteLoss(getBruteLoss(), 0)
		O.setOxyLoss(getOxyLoss(), 0)
		O.setCloneLoss(getCloneLoss(), 0)
		O.adjustFireLoss(getFireLoss(), 0)
		O.setOrganLoss(ORGAN_SLOT_BRAIN, getOrganLoss(ORGAN_SLOT_BRAIN))
		O.updatehealth()

	//re-add organs to new mob. this order prevents moving the mind to a brain at any point
	if(tr_flags & TR_KEEPORGANS)
		for(var/obj/item/organ/I as anything in O.internal_organs)
			I.Remove(O, 1)

		if(mind)
			mind.transfer_to(O)

		for(var/obj/item/organ/I as anything in internal_organs)
			int_organs += I
			I.Remove(src, 1)

		for(var/obj/item/organ/I as anything in int_organs)
			I.Insert(O, 1)

	var/obj/item/bodypart/chest/torso = O.get_bodypart(BODY_ZONE_CHEST)
	if(cavity_object)
		torso.cavity_item = cavity_object //cavity item is given to the new chest
		cavity_object.forceMove(O)

	for(var/missing_zone in missing_bodyparts_zones)
		var/obj/item/bodypart/BP = O.get_bodypart(missing_zone)
		BP.drop_limb(1)
		if(!(tr_flags & TR_KEEPORGANS)) //we didn't already get rid of the organs of the newly spawned mob
			for(var/obj/item/organ/G as anything in O.internal_organs)
				if(BP.body_zone == check_zone(G.zone))
					qdel(G) //we lose the organs in the missing limbs
		qdel(BP)

	//transfer stuns
	if(tr_flags & TR_KEEPSTUNS)
		O.Stun(AmountStun(), ignore_canstun = TRUE)
		O.Knockdown(AmountKnockdown(), ignore_canstun = TRUE)
		O.Immobilize(AmountImmobilized(), ignore_canstun = TRUE)
		O.Paralyze(AmountParalyzed(), ignore_canstun = TRUE)
		O.Unconscious(AmountUnconscious(), ignore_canstun = TRUE)
		O.Sleeping(AmountSleeping(), ignore_canstun = TRUE)

	//transfer reagents
	if(tr_flags & TR_KEEPREAGENTS)
		reagents.trans_to(O, reagents.total_volume)

	//transfer mind if we didn't yet
	if(mind)
		mind.transfer_to(O)


	if (tr_flags & TR_DEFAULTMSG)
		to_chat(O, "<B>I am now a monkey.</B>")

	for(var/A in loc.vars)
		if(loc.vars[A] == src)
			loc.vars[A] = O

	transfer_observers_to(O)

	. = O

	qdel(src)

//////////////////////////           Humanize               //////////////////////////////
//Could probably be merged with monkeyize but other transformations got their own procs, too

/mob/living/carbon/proc/humanize(tr_flags = (TR_KEEPITEMS | TR_KEEPVIRUS | TR_KEEPSTUNS | TR_KEEPREAGENTS | TR_DEFAULTMSG))
	if (HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return
	//Handle items on mob

	var/list/int_organs = list()

	var/list/missing_bodyparts_zones = get_missing_limbs()

	var/obj/item/cavity_object

	var/obj/item/bodypart/chest/CH = get_bodypart(BODY_ZONE_CHEST)
	if(CH.cavity_item)
		cavity_object = CH.cavity_item
		CH.cavity_item = null

	//now the rest
	if (tr_flags & TR_KEEPITEMS)
		var/Itemlist = get_equipped_items(TRUE)
		Itemlist += held_items
		for(var/obj/item/W in Itemlist)
			dropItemToGround(W, TRUE)
			if (client)
				client.screen -= W



	//Make mob invisible and spawn animation
	ADD_TRAIT(src, TRAIT_NO_TRANSFORM, "humanize")
	Paralyze(22, ignore_canstun = TRUE)

	icon = null
	cut_overlays()
	invisibility = INVISIBILITY_MAXIMUM
	new /obj/effect/temp_visual/monkeyify/humanify(loc)
	sleep(22)

	var/mob/living/carbon/human/O = new( loc )
	for(var/obj/item/C in O.loc)
		if(C.anchored)
			continue
		O.equip_to_appropriate_slot(C)

	dna.transfer_identity(O)
	reset_limb_fingerprints()
	O.updateappearance(mutcolor_update=1)

	if(cmptext("monkey",copytext(O.dna.real_name,1,7)))
		O.real_name = random_unique_name(O.gender)
		O.dna.generate_unique_enzymes(O)
	else
		O.real_name = O.dna.real_name
	O.name = O.real_name

	if(suiciding)
		O.set_suicide(suiciding)
	if(hellbound)
		O.hellbound = hellbound

	//keep damage?
	if (tr_flags & TR_KEEPDAMAGE)
		O.setToxLoss(getToxLoss(), 0)
		O.adjustBruteLoss(getBruteLoss(), 0)
		O.setOxyLoss(getOxyLoss(), 0)
		O.setCloneLoss(getCloneLoss(), 0)
		O.adjustFireLoss(getFireLoss(), 0)
		O.adjustOrganLoss(ORGAN_SLOT_BRAIN, getOrganLoss(ORGAN_SLOT_BRAIN))
		O.updatehealth()

	if(tr_flags & TR_KEEPORGANS)
		for(var/obj/item/organ/I as anything in O.internal_organs)
			I.Remove(O, 1)

		if(mind)
			mind.transfer_to(O)
		for(var/obj/item/organ/I as anything in internal_organs)
			int_organs += I
			I.Remove(src, 1)

		for(var/obj/item/organ/I as anything in int_organs)
			I.Insert(O, 1)


	var/obj/item/bodypart/chest/torso = get_bodypart(BODY_ZONE_CHEST)
	if(cavity_object)
		torso.cavity_item = cavity_object //cavity item is given to the new chest
		cavity_object.forceMove(O)

	for(var/missing_zone in missing_bodyparts_zones)
		var/obj/item/bodypart/BP = O.get_bodypart(missing_zone)
		BP.drop_limb(1)
		if(!(tr_flags & TR_KEEPORGANS)) //we didn't already get rid of the organs of the newly spawned mob
			for(var/obj/item/organ/G as anything in O.internal_organs)
				if(BP.body_zone == check_zone(G.zone))
					qdel(G) //we lose the organs in the missing limbs
		qdel(BP)

	//transfer stuns
	if(tr_flags & TR_KEEPSTUNS)
		O.Stun(AmountStun(), ignore_canstun = TRUE)
		O.Knockdown(AmountKnockdown(), ignore_canstun = TRUE)
		O.Immobilize(AmountImmobilized(), ignore_canstun = TRUE)
		O.Paralyze(AmountParalyzed(), ignore_canstun = TRUE)
		O.Unconscious(AmountUnconscious(), ignore_canstun = TRUE)
		O.Sleeping(AmountSleeping())

	//transfer reagents
	if(tr_flags & TR_KEEPREAGENTS)
		reagents.trans_to(O, reagents.total_volume)

	if(mind)
		mind.transfer_to(O)

	O.a_intent = INTENT_HELP
	if (tr_flags & TR_DEFAULTMSG)
		to_chat(O, "<B>I am now a human.</B>")

	transfer_observers_to(O)

	. = O

	for(var/A in loc.vars)
		if(loc.vars[A] == src)
			loc.vars[A] = O

	qdel(src)

/mob/living/carbon/human/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in sortList(mobtypes, GLOBAL_PROC_REF(cmp_typepaths_asc))

	if(!safe_animal(mobpath))
		to_chat(usr, "<span class='danger'>Sorry but this mob type is currently unavailable.</span>")
		return

	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return
	ADD_TRAIT(src, TRAIT_NO_TRANSFORM, "monkeyize")
	Paralyze(1, ignore_canstun = TRUE)

	for(var/obj/item/W in src)
		dropItemToGround(W)

	regenerate_icons()
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	for(var/t in bodyparts)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = INTENT_HARM


	to_chat(new_mob, "<span class='boldnotice'>I suddenly feel more... animalistic.</span>")
	. = new_mob
	qdel(src)

/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_animal)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in sortList(mobtypes, GLOBAL_PROC_REF(cmp_typepaths_asc))

	if(!safe_animal(mobpath))
		to_chat(usr, "<span class='danger'>Sorry but this mob type is currently unavailable.</span>")
		return

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = INTENT_HARM
	to_chat(new_mob, "<span class='boldnotice'>I feel more... animalistic.</span>")

	. = new_mob
	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldnt be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(MP)

//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return 0	//Sanity, this should never happen.

//Good mobs!
	if(ispath(MP, /mob/living/simple_animal/pet/cat))
		return 1

	//Not in here? Must be untested!
	return 0

#undef PERMANENT_TRANSFORMATION_TRAIT
#undef TEMPORARY_TRANSFORMATION_TRAIT
#undef TRANSFORMATION_DURATION
