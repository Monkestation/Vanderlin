/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt
	name = "Nature's Concealment"
	desc = "Disguise yourself as a nearby bush."
	button_icon_state = "bush_jaunt"
	jaunt_type = /obj/effect/dummy/bush_disguise
	sound = 'sound/magic/fleshtostone.ogg'
	invocation = "Treefather, conceal my form."
	invocation_type = INVOCATION_WHISPER
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/dendor)
	cooldown_time = 2 MINUTES
	spell_cost = 20
	has_visual_effects = FALSE
	attunements = list(/datum/attunement/life = 0.5)

	var/obj/effect/dummy/bush_disguise/active_dummy = null
	var/static/list/allowed_structures = list(
		/obj/structure/flora/grass/bush,
		/obj/structure/flora/grass/thorn_bush,
		/obj/structure/flora/grass/bush_meagre,
		/obj/structure/innocent_bush,
	)

/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/cast(mob/living/cast_on)
	if(active_dummy && !QDELETED(active_dummy))
		end_jaunt(cast_on)
		return TRUE

	new /obj/effect/temp_visual/bush_transform(get_turf(cast_on))
	cast_on.Immobilize(1 SECONDS)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(do_jaunt), cast_on), 1 SECONDS)
	return TRUE

/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/proc/do_jaunt(mob/living/cast_on)
	ADD_TRAIT(cast_on, TRAIT_NO_TRANSFORM, "[REF(src)]")
	var/obj/effect/dummy/bush_disguise/holder = enter_jaunt(cast_on)
	REMOVE_TRAIT(cast_on, TRAIT_NO_TRANSFORM, "[REF(src)]")
	if(!holder)
		CRASH("[type] failed to create a bush disguise holder via enter_jaunt.")
	start_jaunt(cast_on, holder)

/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/enter_jaunt(mob/living/jaunter, turf/loc_override)
	var/obj/effect/dummy/bush_disguise/holder = ..()
	if(holder && jaunter)
		// so they can like.. talk...
		jaunter.remove_traits(list(TRAIT_RUNECHAT_HIDDEN, TRAIT_MAGICALLY_PHASED), REF(src))
	return holder

/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/proc/start_jaunt(mob/living/cast_on, obj/effect/dummy/bush_disguise/holder)
	if(QDELETED(cast_on) || QDELETED(holder) || QDELETED(src))
		return
	var/obj/structure/nearest
	var/turf/origin = get_turf(cast_on)
	var/range = 10
	for(var/turf/T in view(range, origin))
		for(var/obj/O in T)
			if(is_type_in_list(O, allowed_structures))
				nearest = O
				break
		if(nearest)
			break

	var/obj/temp = new /obj()
	if(nearest)
		temp.appearance = nearest.appearance
		temp.name = nearest.name
	else
		var/path = pick(allowed_structures)
		var/obj/O = new path(origin)
		temp.appearance = O.appearance
		temp.name = O.name
		qdel(O)

	holder.activate(cast_on, temp.appearance, src, temp.name)
	cast_on.forceMove(holder)
	cast_on.cancel_camera()
	to_chat(cast_on, span_notice("You blend into your surroundings..."))
	active_dummy = holder

/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/proc/end_jaunt(mob/living/cast_on)
	if(!active_dummy || QDELETED(active_dummy))
		active_dummy = null
		return

	if(!active_dummy.destroying)
		active_dummy.destroying = TRUE
		active_dummy.deactivate(cast_on)

		var/turf/T = get_turf(active_dummy)
		if(T)
			cast_on.forceMove(T)
			cast_on.reset_perspective(null)

		qdel(active_dummy)
		active_dummy = null

		to_chat(cast_on, span_notice("Your disguise fades away."))
		new /obj/effect/temp_visual/emp/bush(get_turf(cast_on))
		playsound(cast_on, 'sound/misc/woodhit.ogg', 80, TRUE)

/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/on_jaunt_exited(obj/effect/dummy/phased_mob/jaunt, mob/living/unjaunter)
	..()
	end_jaunt(unjaunter)

/datum/action/cooldown/spell/undirected/jaunt/bush_jaunt/Remove(mob/living/remove_from)
	end_jaunt(remove_from)
	return ..()

/obj/effect/temp_visual/bush_transform
	name = "Transformation Bush"
	icon_state = "bush_transform"
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_LIGHTING_PLANE
	anchored = TRUE
	duration = 1.6 SECONDS

/obj/effect/temp_visual/emp/bush
	name = "bush destroyed"
	icon_state = "bush_destroyed"
	duration = 8

