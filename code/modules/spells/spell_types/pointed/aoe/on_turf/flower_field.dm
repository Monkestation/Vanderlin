/datum/action/cooldown/spell/aoe/on_turf/circle/flower_field
	name = "Flower Field"
	desc = "Summons a magical field of flowers using a single flower."
	button_icon_state = "flower_field"

	point_cost = 5
	attunements = list(
		/datum/attunement/earth = 0.4,
		/datum/attunement/life = 0.3,
	)

	invocation = "May the earth bloom!"
	invocation_type = INVOCATION_WHISPER

	charge_time = 3 SECONDS
	charge_drain = 3
	charge_slowdown = 1.4
	cooldown_time = 60 SECONDS
	spell_cost = 50
	spell_flags = SPELL_RITUOS
	aoe_radius = 3
	ignore_openspace = TRUE

	var/obj/structure/flora/field/flowers

/datum/action/cooldown/spell/aoe/on_turf/circle/flower_field/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/static/list/flower_type_map = list(
		/obj/item/alch/herb/rosa = /obj/structure/flora/field/rosa,
		/obj/item/alch/herb/salvia = /obj/structure/flora/field/salvia,
		/obj/item/alch/herb/calendula = /obj/structure/flora/field/calendula,
		/obj/item/alch/herb/matricaria = /obj/structure/flora/field/matricaria,
		/obj/item/alch/herb/euphorbia = /obj/structure/flora/field/euphorbia,
		/obj/item/reagent_containers/food/snacks/produce/manabloom = /obj/structure/flora/field/manabloom,
		/obj/item/reagent_containers/food/snacks/produce/poppy = /obj/structure/flora/field/poppy,
	)

	var/obj/item/alch/flower_item

	for(var/obj/item/I in owner.contents)
		var/obj/structure/flora/field_type = LAZYACCESS(flower_type_map, I.type)
		if(field_type)
			flower_item = I
			flowers = field_type
			break

	if(!flower_item || !flowers)
		to_chat(owner, span_warning("I need a flower as a catalyst!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	if(isliving(owner))
		var/mob/living/L = owner
		L.apply_status_effect(/datum/status_effect/buff/flowerfield_resistance)

/datum/action/cooldown/spell/aoe/on_turf/circle/flower_field/cast_on_thing_in_aoe(turf/victim, atom/caster)
	if(prob(25))
		return
	var/obj/structure/flora/field/field = new flowers(victim)
	field.dir = pick(GLOB.cardinals)
	for(var/mob/living/L in victim)
		field.Crossed(L)

/*-----------------\
|  Flower Fields   |
\-----------------*/
/obj/structure/flora/field
	name = ""
	desc = ""
	anchored = TRUE
	density = FALSE
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = ""
	dir = SOUTH
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"
	layer = ABOVE_NORMAL_TURF_LAYER
	max_integrity = 25
	blade_dulling = DULLING_CUT
	resistance_flags = FLAMMABLE
	object_slowdown = 2

/obj/structure/flora/field/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(flower_decay)), 1 MINUTES)

/obj/structure/flora/field/Crossed(atom/movable/AM)
	. = ..()
	if (isliving(AM))
		var/mob/living/L = AM
		if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
			return
		if (L.m_intent == MOVE_INTENT_SNEAK)
			return
		playsound(src, "plantcross", 90, FALSE, -1)
		var/oldx = pixel_x
		animate(src, pixel_x = oldx + 1, time = 0.5)
		animate(pixel_x = oldx - 1, time = 0.5)
		animate(pixel_x = oldx, time = 0.5)
		L.consider_ambush()


/obj/structure/flora/field/proc/flower_decay()
	playsound(src, "plantcross", 100, FALSE)
	icon_state = "leaf_dying"
	QDEL_IN(src, 1 SECONDS)

/obj/structure/flora/field/proc/apply_flower_effect(mob/living/L, effect_path)
	if (!L) return
	if (!L.has_status_effect(effect_path))
		L.apply_status_effect(effect_path)

// ---------------------- ROSA FIELD ----------------------------
/obj/structure/flora/field/rosa
	name = "rosa field"
	icon_state = "rosa"

/obj/structure/flora/field/rosa
	name = "rosa field"
	icon_state = "rosa"

/obj/structure/flora/field/rosa/Crossed(atom/movable/AM)
	. = ..()
	if (!isliving(AM))
		return
	var/mob/living/L = AM
	if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
		return
	if (!L.buckled && prob(45))
		L.visible_message(span_danger("The rose vines entangle [L]!"), span_userdanger("Vines entangle me!"))
		buckle_mob(L, TRUE, check_loc = FALSE)
	apply_flower_effect(L, /datum/status_effect/debuff/rosa_pacification)

// ---------------------- SALVIA FIELD ----------------------------
/obj/structure/flora/field/salvia
	name = "salvia field"
	icon_state = "salvia"
	object_slowdown = 4

/obj/structure/flora/field/salvia/Crossed(atom/movable/AM)
	. = ..()
	if (isliving(AM))
		var/mob/living/L = AM
		if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
			return
		if (prob(30))
			L.emote("spin", forced=TRUE)
			L.Stun(5)
		apply_flower_effect(L, /datum/status_effect/debuff/salvia_madness)

// ---------------------- EUPHORBIA FIELD ----------------------------
/obj/structure/flora/field/euphorbia
	name = "euphorbia field"
	icon_state = "euphorbia"
	object_slowdown = 3

/obj/structure/flora/field/euphorbia/Crossed(atom/movable/AM)
	. = ..()
	if (!isliving(AM))
		return
	var/mob/living/L = AM
	if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
		return
	if (!L.buckled && prob(35))
		L.visible_message(span_warning("The euphorbia vines entwine [L]!"))
		if (buckle_mob(L, TRUE, check_loc = FALSE))
			if (!HAS_TRAIT(L, TRAIT_NOPAIN))
				L.emote("agony")
			L.Stun(2 SECONDS)
	if (!HAS_TRAIT(L, TRAIT_PIERCEIMMUNE))
		L.adjustBruteLoss(10)
		to_chat(L, span_danger("Thorns rip into you as you push through!"))
	apply_flower_effect(L, /datum/status_effect/debuff/euphorbia_thorns)

// ---------------------- CALENDULA FIELD ----------------------------
/obj/structure/flora/field/calendula
	name = "calendula field"
	icon_state = "calendula"

/obj/structure/flora/field/calendula/Crossed(atom/movable/AM)
	. = ..()
	if (isliving(AM))
		var/mob/living/L = AM
		if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
			return
		apply_flower_effect(L, /datum/status_effect/debuff/calendula_sedation)

// ---------------------- MANABLOOM FIELD ----------------------------
/obj/structure/flora/field/manabloom
	name = "manabloom field"
	icon_state = "mana"

/obj/structure/flora/field/manabloom/Crossed(atom/movable/AM)
	. = ..()
	if (isliving(AM))
		var/mob/living/L = AM
		if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
			return
		apply_flower_effect(L, /datum/status_effect/debuff/manabloom_silence)

// ---------------------- MATRICARIA FIELD ----------------------------
/obj/structure/flora/field/matricaria
	name = "matricaria field"
	icon_state = "matricaria"
	object_slowdown = 3

/obj/structure/flora/field/matricaria/Crossed(atom/movable/AM)
	. = ..()
	if (!isliving(AM)) return
	var/mob/living/L = AM
	if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
		return
	apply_flower_effect(L, /datum/status_effect/debuff/matricaria_remedy)
	if (!L.has_status_effect(/datum/status_effect/frost_trap) && prob(40))
		L.apply_status_effect(/datum/status_effect/frost_trap)

// ---------------------- POPPY FIELD ----------------------------
/obj/structure/flora/field/poppy
	name = "poppy field"
	icon_state = "poppy"

/obj/structure/flora/field/poppy/Crossed(atom/movable/AM)
	. = ..()
	if (isliving(AM))
		var/mob/living/L = AM
		if (HAS_TRAIT(L, TRAIT_FLOWERFIELD_IMMUNITY))
			return
		apply_flower_effect(L, /datum/status_effect/debuff/poppy_arena)

/*-----------------\
|  Flower Debuffs  |
\-----------------*/

/datum/status_effect/debuff/flower_base
	var/overlay_state = null
	var/field_path = null
	var/image/flower_overlay

/datum/status_effect/debuff/flower_base/on_apply()
	. = ..()
	if(overlay_state && ismob(owner))
		var/mob/M = owner
		flower_overlay = mutable_appearance('icons/effects/effects.dmi', overlay_state)
		M.add_overlay(flower_overlay)
		RegisterSignal(M, COMSIG_MOVABLE_MOVED, PROC_REF(_check_flower_field))

/datum/status_effect/debuff/flower_base/on_remove()
	. = ..()
	if (ismob(owner))
		var/mob/M = owner
		if (flower_overlay)
			M.overlays -= flower_overlay
			flower_overlay = null
		UnregisterSignal(M, COMSIG_MOVABLE_MOVED)

/datum/status_effect/debuff/flower_base/tick()
	check_field_presence()

/datum/status_effect/debuff/flower_base/proc/_check_flower_field(mob/living/L)
	if (!field_path || !locate(field_path) in get_turf(L))
		L.remove_status_effect(src)

/datum/status_effect/debuff/flower_base/proc/check_field_presence()
	var/mob/living/L = owner
	if (!L) return
	if (!locate(field_path) in get_turf(L))
		L.remove_status_effect(src)


// ---------------------- ROSA PACIFICATION ----------------------------
/datum/status_effect/debuff/rosa_pacification
	parent_type = /datum/status_effect/debuff/flower_base
	id = "rosa_pacification"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/rosa_pacification
	duration = -1
	status_type = STATUS_EFFECT_REFRESH
	overlay_state = "rosa_overlay"
	field_path = /obj/structure/flora/field/rosa
	tick_interval = 10

/datum/status_effect/debuff/rosa_pacification/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_PACIFISM, TRAIT_GENERIC)

/datum/status_effect/debuff/rosa_pacification/tick()
	check_field_presence()

/datum/status_effect/debuff/rosa_pacification/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, TRAIT_GENERIC)
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/rosa_pacification
	name = "Pacified"
	desc = span_notice("You are unable to do violence.")
	icon_state = "pacify"

// ---------------------- SALVIA MADNESS ----------------------------
/datum/status_effect/debuff/salvia_madness
	parent_type = /datum/status_effect/debuff/flower_base
	id = "salvia_madness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/salvia_madness
	duration = -1
	tick_interval = 20
	status_type = STATUS_EFFECT_REFRESH
	overlay_state = "salvia_overlay"
	field_path = /obj/structure/flora/field/salvia
	var/tick_counter = 0

/datum/status_effect/debuff/salvia_madness/tick()
	var/mob/living/L = owner
	if (!L) return
	check_field_presence()
	tick_counter++
	L.Stun(3)
	L.adjust_jitter(4 SECONDS)
	L.emote(pick("spin", "dance"), forced=TRUE)
	L.emote(pick("laugh", "giggle"), forced=TRUE)
	if (tick_counter >= 4)
		L.emote("faint", forced=TRUE)
		qdel(src)

/atom/movable/screen/alert/status_effect/debuff/salvia_madness
	name = "Salvia Madness"
	desc = span_notice("You have an overwhelming urge to dance and laugh.")
	icon_state = "salvia_mad"


// ---------------------- EUPHORBIA THORNS ----------------------------
/datum/status_effect/debuff/euphorbia_thorns
	parent_type = /datum/status_effect/debuff/flower_base
	id = "euphorbia_thorns"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/euphorbia_thorns
	duration = -1
	tick_interval = 10
	status_type = STATUS_EFFECT_REFRESH
	overlay_state = "euphorbia_overlay"
	field_path = /obj/structure/flora/field/euphorbia

/datum/status_effect/debuff/euphorbia_thorns/on_apply()
	. = ..()
	owner.visible_message(span_danger("[owner] is pierced by thorns!"))

/datum/status_effect/debuff/euphorbia_thorns/tick()
	var/mob/living/L = owner
	if (!L) return
	check_field_presence()
	L.adjustBruteLoss(10)

	if (locate(/obj/structure/flora/field/euphorbia) in get_turf(L))
		to_chat(L, span_warning("The spines hurt your feet"))

	if (prob(20) && ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/bodypart/BP = pick(H.bodyparts)
		var/obj/item/natural/thorn/TH = new(get_turf(H))
		BP.add_embedded_object(TH, silent = TRUE)
		to_chat(H, span_danger("A thorn embeds into your [BP.name]!"))

/atom/movable/screen/alert/status_effect/debuff/euphorbia_thorns
	name = "Spiny Terrain"
	desc = "You are stepping on spines."
	icon_state = "entwined"

// ---------------------- CALENDULA SEDATION ----------------------------
/datum/status_effect/debuff/calendula_sedation
	parent_type = /datum/status_effect/debuff/flower_base
	id = "calendula_sedation"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/calendula_sedation
	duration = -1
	tick_interval = 10
	effectedstats = list(STATKEY_SPD = -2, STATKEY_STR = -1, STATKEY_END = 1)
	status_type = STATUS_EFFECT_REFRESH
	overlay_state = "calendula_overlay"
	field_path = /obj/structure/flora/field/calendula
	var/tick_counter = 0

/datum/status_effect/debuff/calendula_sedation/tick()
	tick_counter++
	var/mob/living/L = owner
	if (!L) return
	check_field_presence()

	L.adjustBruteLoss(-2)
	L.adjustFireLoss(-2)
	L.adjustToxLoss(-1.5)
	L.adjustOxyLoss(-1.3)
	var/list/wounds = L.get_wounds()
	if(wounds.len > 0)
		L.heal_wounds(1)

	if (tick_counter % 15 == 5)
		if (!HAS_TRAIT(L, TRAIT_NOSTAMINA) && prob(30))
			L.adjust_stamina(-1, internal_regen = FALSE)
			to_chat(L, span_notice("You feel drained..."))

	if (tick_counter % 15 == 10 && !L.has_status_effect(/datum/status_effect/incapacitating/sleeping))
		L.emote("yawn", forced=TRUE)

	if (tick_counter % 15 == 0 && !L.has_status_effect(/datum/status_effect/incapacitating/sleeping))
		if(prob(65))
			L.visible_message(span_danger("[L] suddenly collapses!"))
			L.apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, 5 SECONDS)
			L.emote("snore", forced=TRUE)

/atom/movable/screen/alert/status_effect/debuff/calendula_sedation
	name = "Tranquility"
	desc = "You feel too relaxed...."
	icon_state = "tranquil"

// ---------------------- MANABLOOM SILENCE ----------------------------
/datum/status_effect/debuff/manabloom_silence
	parent_type = /datum/status_effect/debuff/flower_base
	id = "manabloom_silence"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/manabloom_silence
	duration = -1
	status_type = STATUS_EFFECT_REFRESH
	overlay_state = "manabloom_overlay"
	field_path = /obj/structure/flora/field/manabloom
	tick_interval = 10

/datum/status_effect/debuff/manabloom_silence/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_SPELLBLOCK, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_MUTE, TRAIT_GENERIC)

/datum/status_effect/debuff/manabloom_silence/tick()
	check_field_presence()

/datum/status_effect/debuff/manabloom_silence/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_SPELLBLOCK, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_MUTE, TRAIT_GENERIC)
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/manabloom_silence
	name = "Silenced"
	desc = span_notice("You are blocked from the arcyne.")
	icon_state = "spellblock"

// ---------------------- MATRICARIA CHILL ----------------------------
/datum/status_effect/debuff/matricaria_remedy
	parent_type = /datum/status_effect/debuff/flower_base
	id = "matricaria_remedy"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/matricaria_remedy
	duration = -1
	tick_interval = 10
	effectedstats = list(STATKEY_SPD = -3)
	status_type = STATUS_EFFECT_REFRESH
	overlay_state = "matricaria_overlay"
	field_path = /obj/structure/flora/field/matricaria

/datum/status_effect/debuff/matricaria_remedy/tick()
	var/mob/living/M = owner
	if (!M || M.stat != CONSCIOUS) return
	check_field_presence()
	M.set_confusion_if_lower(0.5 SECONDS)
	if (prob(15) && !M.has_status_effect(/datum/status_effect/frost_trap))
		M.apply_status_effect(/datum/status_effect/frost_trap)
		M.adjustFireLoss(-8)

/atom/movable/screen/alert/status_effect/debuff/matricaria_remedy
	name = "Chill"
	desc = "A chilling breeze courses through you."
	icon_state = "matricaria_cold"

// ---------------------- POPPY ARENA ----------------------------// ran out of ideas
/datum/status_effect/debuff/poppy_arena
	parent_type = /datum/status_effect/debuff/flower_base
	id = "poppy_arena"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/poppy_arena
	duration = -1
	tick_interval = 20
	status_type = STATUS_EFFECT_REFRESH
	overlay_state = "poppy_overlay"
	field_path = /obj/structure/flora/field/poppy
	effectedstats = list(STATKEY_STR = 1, STATKEY_END = -2, STATKEY_PER = -2, STATKEY_INT = -2)

/datum/status_effect/debuff/poppy_arena/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

	if (iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/ozium)//i think this is the screen effect thing

/datum/status_effect/debuff/poppy_arena/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

	if (iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/ozium)
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/poppy_arena
	name = "Arena"
	desc = span_notice("You're in for a fair fight")
	icon_state = "arena"

// ---------------------- FLOWERFIELD RESISTANCE ----------------------------
/datum/status_effect/buff/flowerfield_resistance
	id = "flowerfield_resistance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/flowerfield_resistance
	duration = 7 SECONDS

/datum/status_effect/buff/flowerfield_resistance/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_FLOWERFIELD_IMMUNITY, TRAIT_GENERIC)

/datum/status_effect/buff/flowerfield_resistance/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_FLOWERFIELD_IMMUNITY, TRAIT_GENERIC)

/atom/movable/screen/alert/status_effect/buff/flowerfield_resistance
	name = "Flower Stider"
	desc = span_notice("You are momentarily immune to the flower field's effects.")
	icon_state = "flowerfield"
