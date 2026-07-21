///these mob spawn subtypes trigger immediately (New or Initialize) and are not player controlled... since they're dead, you know?
/obj/effect/mob_spawn/corpse
	abstract_type = /obj/effect/mob_spawn/corpse
	icon_state = "deadbodyplacer"
	density = FALSE
	///when this mob spawn should auto trigger.
	var/spawn_when = CORPSE_INSTANT

	////damage values (very often, mappers want corpses to be mangled)

	///brute damage this corpse will spawn with
	var/brute_damage = 0
	///oxy damage this corpse will spawn with
	var/oxy_damage = 0
	///burn damage this corpse will spawn with
	var/burn_damage = 0

/obj/effect/mob_spawn/corpse/Initialize(mapload)
	. = ..()
	switch(spawn_when)
		if(CORPSE_INSTANT)
			INVOKE_ASYNC(src, PROC_REF(create))
		if(CORPSE_ROUNDSTART)
			if(SSticker.current_state < GAME_STATE_PLAYING)
				SSticker.OnRoundstart(CALLBACK(src, PROC_REF(create)))
			else
				INVOKE_ASYNC(src, PROC_REF(create))

/obj/effect/mob_spawn/corpse/special(mob/living/spawned_mob)
	. = ..()
	spawned_mob.death(TRUE)
	spawned_mob.adjustOxyLoss(oxy_damage, updating_health = FALSE)
	spawned_mob.adjustBruteLoss(brute_damage, updating_health = FALSE, damage_type = pick(BCLASS_BITE, BCLASS_BLUNT, BCLASS_LASHING, BCLASS_CUT))
	spawned_mob.adjustFireLoss(burn_damage, updating_health = FALSE)

/obj/effect/mob_spawn/corpse/create(mob/mob_possessor, newname)
	. = ..()
	qdel(src)
