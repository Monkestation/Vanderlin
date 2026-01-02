/obj/item/reagent_containers/lux
	name = "lux"
	desc = "The stuff of life and souls, retrieved from within a hopefully-willing donor. It's a bit clammy and squishy, like a half-fried egg."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux"
	item_state = "lux"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/lux = 5)
	grind_results = list(/datum/reagent/lux = 5)
	sellprice = 500

/datum/reagent/lux
	name = "Lux"
	description = "The extracted and processed essence of life."
	color = "#7d8e98" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.1

/datum/reagent/lux/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25*REM)
	M.adjustFireLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/lux/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction()
	if(M.has_status_effect(/datum/status_effect/debuff/lux_drained))
		M.remove_status_effect(/datum/status_effect/debuff/lux_drained)
		addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living, apply_status_effect), /datum/status_effect/debuff/lux_drained), 5 MINUTES)
		to_chat(M, span_green("I can feel my soul again, albeit temporarily!"))
	if(M.has_status_effect(/datum/status_effect/debuff/flaw_lux_taken))
		M.remove_status_effect(/datum/status_effect/debuff/flaw_lux_taken)
		addtimer(CALLBACK(M, TYPE_PROC_REF(/mob/living, apply_status_effect), /datum/status_effect/debuff/flaw_lux_taken), 5 MINUTES)
		to_chat(M, span_green("A small respite- I'm whole again... for now..."))
	M.apply_status_effect(/datum/status_effect/buff/lux_drank)
	..()

/obj/item/reagent_containers/lux/pragmas
	name = "luxus pragmas"
	desc = "The Divine Essence that Eora gifted to Graggar and told him to make a female companion with.\
			He was supposed to make a beautiful and courageous wife from it, is what Eora had hoped he would do.\
			Instead, Graggar created the Broodmother who would in turn spawn his armies. Eora was heartbroken and furious.\
			Use this in hand to acquire charming power."
	icon = 'icons/obj/broodmother_32x.dmi'
	icon_state = "broodmother_lux"

/obj/item/reagent_containers/lux/pragmas/attack_self(mob/user, params)
	. = ..()
	var/datum/action/cooldown/spell/pragmas_charm/charm = new()
	charm.Grant(user)
	qdel(src)

/datum/action/cooldown/spell/pragmas_charm
	name = "luxus pragmas charm"
	desc = "charm an animal to be your companion"
	var/list/charmed_mobs = list()
	charge_time = 2 SECONDS

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/datum/action/cooldown/spell/pragmas_charm/proc/on_mob_death(datum/source)
	for(var/datum/weakref/mob_ref as anything in charmed_mobs)
		if(mob_ref.resolve() == source)
			charmed_mobs -= mob_ref
			return TRUE

/datum/action/cooldown/spell/pragmas_charm/proc/check_present(mob/passed_mob)
	for(var/datum/weakref/mob_ref as anything in charmed_mobs)
		if(mob_ref.resolve() == passed_mob)
			return TRUE

	return FALSE

/datum/action/cooldown/spell/pragmas_charm/Destroy()
	. = ..()
	for(var/datum/weakref/mob_ref as anything in charmed_mobs)
		var/mob/mobber = mob_ref.resolve()
		if(mobber)
			UnregisterSignal(mobber, COMSIG_LIVING_DEATH)

/datum/action/cooldown/spell/pragmas_charm/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isanimal(cast_on)

/datum/action/cooldown/spell/pragmas_charm/cast(mob/living/simple_animal/cast_on)
	. = ..()
	for(var/datum/weakref/mob_ref as anything in charmed_mobs)
		var/mob/mob = mob_ref.resolve()
		if(isnull(mob))
			charmed_mobs -= mob_ref

	if(check_present(cast_on))
		to_chat(owner, span_danger("already charmed!"))
		return

	if(length(charmed_mobs) >= 3)
		to_chat(owner, span_danger("too many charmed! can only charm 3!"))
		return

	if(cast_on.is_dead())
		to_chat(owner, span_danger("it's dead!"))
		return

	charmed_mobs += WEAKREF(cast_on)
	RegisterSignal(cast_on, COMSIG_LIVING_DEATH, PROC_REF(on_mob_death))
	cast_on.LoadComponent(/datum/component/obeys_commands, pet_commands)
	cast_on.ai_controller.can_idle = FALSE
	cast_on.ai_controller.add_to_top(/datum/ai_planning_subtree/pet_planning)
	cast_on.ai_controller.CancelActions()
	cast_on.ai_controller.set_blackboard_key(BB_PET_TARGETING_DATUM, new /datum/targetting_datum/basic/not_friends())
	cast_on.befriend(owner)
	cast_on.pet_passive = TRUE

/// Tainted Lux from goblins, rous and others.

/obj/item/reagent_containers/lux_tainted
	name = "tainted lux"
	desc = "A warped remnant of soulstuff, twisted by the touch of darker powers. It quivers with a sickly pulse, its surface slick like spoiled yolk."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "tainted_lux"
	item_state = "tainted_lux"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/lux_tainted = 5)
	grind_results = list(/datum/reagent/lux_tainted = 5)
	sellprice = 25

/datum/reagent/lux_tainted
	name = "Tainted lux"
	description = "A degraded echo of the soul's essence, tainted by profane influence. It carries the stain of malice and fragmentation."
	color = "#1a1038"
	overdose_threshold = 5
	metabolization_rate = 0.1

/datum/reagent/lux_tainted/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.5*REM)
	M.adjustFireLoss(0.5*REM, 0)
	..()
	. = 1

/datum/reagent/lux_tainted/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction()
	if(M.has_status_effect(/datum/status_effect/debuff/lux_drained))
		to_chat(M, span_green("This tastes awful, it won't help me feel my soul again.."))
	if(M.has_status_effect(/datum/status_effect/debuff/flaw_lux_taken))
		to_chat(M, span_green("This tastes awful, it won't help me feel my soul again.."))
	M.add_stress(/datum/stress_event/consumed_tainted_lux)
	..()
