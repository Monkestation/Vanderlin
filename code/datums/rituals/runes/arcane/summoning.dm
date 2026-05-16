/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning
	name = "confinement matrix"
	desc = "A relatively basic confinement matrix used to hold small things when summoned."
	ritual_number = TRUE
	invocation = "Rhegal vex'ultraa!"
	tier = 1
	can_be_scribed = TRUE
	var/summoning = FALSE
	var/mob/living/simple_animal/summoned_mob

/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/Destroy()
	if(summoning)
		release_summon()
	.=..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/attack_hand(mob/living/user)
	if(summoning && GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) > SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You release the summon from its containment!"))
		playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)
		do_invoke_glow()
		sleep(20)
		animate(summoned_mob, color = null, time = 5)
		release_summon()
		return
	. = ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/proc/release_summon()
	if(!summoned_mob)
		return
	REMOVE_TRAIT(summoned_mob, TRAIT_PACIFISM, MAGIC_TRAIT)
	summoned_mob.status_flags -= GODMODE
	summoned_mob.candodge = TRUE
	summoned_mob.binded = FALSE
	summoned_mob.SetParalyzed(0)
	summoned_mob = null
	summoning = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/get_ritual_list_for_rune()
	switch(tier)
		if(1)
			return GLOB.t1summoningrunerituallist
		if(2)
			return GLOB.t2summoningrunerituallist
		if(3)
			return GLOB.t3summoningrunerituallist
	return GLOB.t4summoningrunerituallist

/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/invoke(list/invokers, datum/runerituals/runeritual)
	if(!..())
		return
	if(ismob(ritual_result))
		summoned_mob = ritual_result
		summoning = TRUE
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	finish_invoke(invokers)

/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/mid
	name = "sealate confinement matrix"
	desc = "An adept confinement matrix improved with the addition of a sealate matrix; used to hold things when summoned."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "sealate"
	runesize = 1
	tier = 2
	SET_BASE_PIXEL(-32, -32)
	pixel_z = 0
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/adv
	name = "warded sealate confinement matrix"
	desc = "A thoroughly-warded confinement matrix improved with the addition of a sealate matrix; used to hold larger, dangerous things when summoned."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "warded"
	runesize = 2
	tier = 3
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	can_be_scribed = TRUE


/obj/effect/decal/cleanable/ritual_rune/arcyne/summoning/max
	name = "noc's eye warded sealate confinement matrix"
	desc = "A thoroughly-warded confinement matrix improved with a Noc's eye sealing measure and the addition of a sealate matrix; used to hold the largest, most dangerous things summonable."
	icon = 'icons/effects/224x224.dmi'
	icon_state = "huge_runeblued"
	runesize = 3
	req_invokers = 3
	tier = 4
	SET_BASE_PIXEL(-96, -96)
	pixel_z = 0
	can_be_scribed = TRUE
