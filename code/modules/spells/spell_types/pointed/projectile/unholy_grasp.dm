/datum/action/cooldown/spell/projectile/blood_net
	name = "Unholy Grasp"
	desc = "Toss forth an unholy snare of blood and guts a short distance, summoned from your leftover trophies sacrificed to Graggar. Like a net, may it snare your target! You will need some guts to use this."
	button_icon_state = "unholy_grasp"
	sound = 'sound/misc/stings/generic.ogg'
	charge_sound = 'sound/magic/charging_lightning.ogg'

	spell_type = SPELL_MIRACLE //it does count as one, funnily enough.
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy

	attunements = list(
		/datum/attunement/blood = 0.5,
	)

	invocation_type = INVOCATION_EMOTE
	invocation = span_userdanger("<b>%CASTER</b> casts %PRONOUN_their hands outward!")
	invocation_self_message = span_danger("I throw out an unholy snare!")

	charge_time = 2 SECONDS
	charge_drain = 1
	cooldown_time = 10 SECONDS
	spell_cost = 30

/datum/action/cooldown/spell/projectile/blood_net/before_cast()
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/obj/item/held_item = owner.get_active_held_item()
	if(istype(held_item, /obj/item/organ/guts))
		projectile_type = /obj/projectile/magic/unholy_grasp
		qdel(held_item)
	else if(istype(held_item, /obj/item/organ/tongue))
		projectile_type = /obj/projectile/magic/unholy_muzzle
		qdel(held_item)
	// else if(istype(held_item, /obj/item/organ/stomach))
	// 	projectile_type = /obj/projectile/magic/cannibalistic_vomit
	// 	qdel(held_item)
	else
		to_chat(owner, "I'm missing some guts to cast this..")
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST


//------------------------
//Netting oponent using guts
//------------------------

/obj/projectile/magic/unholy_grasp
	name = "visceral lasso"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 3 //Net, So Low range.


/obj/projectile/magic/unholy_grasp/on_hit(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(!iscarbon(hit_atom))	//if it gets caught or the target can't be cuffed.
		return
	ensnare(hit_atom)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/C)		//Same code as net but with le flavor.
	if(!C.legcuffed && C.num_legs >= 2)
		visible_message("<span class='danger'>\The [src] ensnares [C] using some guts!</span>")
		//This now ONLY gives the debuff, the unholy grasp leg cuff was bugged and couldn't be taken off

		//C.legcuffed = src
		//forceMove(C)
		//C.update_inv_legcuffed()
		//SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		to_chat(C, "<span class='danger'>\The [src] ensnares you!</span>")
		//C.Knockdown(knockdown) //We don't seems to use the knockdown, good enough tbh.
		C.apply_status_effect(/datum/status_effect/debuff/netted)
		playsound(src, 'sound/combat/caught.ogg', 50, TRUE)

//------------------------
//Silencing using tongue
//------------------------

/obj/projectile/magic/unholy_muzzle
	name = "tongue-twister"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 7 //Screen wide

/obj/projectile/magic/unholy_muzzle/on_hit(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(!iscarbon(hit_atom))	//if it gets caught or the target can't be cuffed.
		return
	silence(hit_atom)


/obj/projectile/magic/unholy_muzzle/proc/silence(mob/living/carbon/C)
	C.emote("gasp")
	visible_message("<span class='danger'>\The [src] starts twisting [C] tongue!</span>")
	to_chat(C, "<span class='danger'>\The [src] twits your tongue!</span>")
	C.apply_status_effect(/datum/status_effect/silenced)
	playsound(src, 'sound/magic/marked.ogg', 50, TRUE)

//------------------------
//Force vomit with purging chemicals
//------------------------

// /obj/projectile/magic/cannibalistic_vomit
// 	name = "cannibalistic vomit"
// 	icon_state = "tentacle_end"
// 	nodamage = TRUE
// 	range = 4 //medium range

// /obj/projectile/magic/cannibalistic_vomit/on_hit(atom/hit_atom, datum/thrownthing/throwingdatum)
// 	. = ..()
// 	if(. != BULLET_ACT_HIT)
// 		return
// 	if(!iscarbon(hit_atom))	//if it gets caught or the target can't be cuffed.
// 		return
// 	vomit(hit_atom)


// /obj/projectile/magic/cannibalistic_vomit/proc/vomit(mob/living/carbon/C)
// 	visible_message("<span class='danger'>[C]'s stomach starts aching!</span>")
// 	to_chat(C, "<span class='danger'>Your stomach hurts a lot!</span>")
// 	C.emote("gag")
// 	var/turf/floor = get_turf(src)
// 	var/obj/effect/decal/cleanable/vomit/spew = new(floor)
// 	C.reagents.trans_to(spew, 30, transfered_by = src)
// 	playsound(src, 'sound/magic/marked.ogg', 50, TRUE)



