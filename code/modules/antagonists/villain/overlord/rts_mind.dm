/mob/camera/strategy_controller/overlord_controller
	name = "Phylactery Overseer"
	desc = "The overlord's consciousness, overseeing phylactery construction."
	worker_type = /mob/living/simple_animal/hostile/retaliate/overlord_minion

/mob/living/simple_animal/hostile/retaliate/overlord_minion
	name = "shadowy minion"
	desc = "A dark servant animated to serve the overlord's will."
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	icon_state = "skeleton"
	faction = list(FACTION_UNDEAD)
	mob_biotypes = MOB_UNDEAD
	speak_emote = list("whispers", "hisses")
	see_in_dark = 8
