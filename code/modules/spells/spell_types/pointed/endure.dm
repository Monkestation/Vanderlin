
/obj/effect/temp_visual/psyheal_rogue //color is white by default, set to whatever is needed
	name = "enduring glow"
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "heal_psycross"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/psyheal_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/datum/action/cooldown/spell/psydonendure
	name = "ENDURE"
	spell_type = SPELL_PSYDONIC_MIRACLE
	spell_flags = SPELL_PSYDON

	spell_cost = 40
	charge_time = 1
	cast_range = 2
	sound = 'sound/magic/ENDVRE.ogg'
	invocation = "LIVE, ENDURE!" // holy larp yelling for healing is silly
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/psydonendure/cast(mob/living/target)
	. = ..()
	var/mob/living/user = owner
	if(isliving(target))
		var/brute = target.getBruteLoss()
		var/burn = target.getFireLoss()
		var/list/wAmount = target.get_wounds()
		var/conditional_buff = FALSE
		var/situational_bonus = 0
		var/psicross_bonus = 0
		var/pp = 0
		var/damtotal = brute + burn
		var/zcross_trigger = FALSE

		// Bonuses! Flavour! SOVL!
		for(var/obj/item/clothing/neck/current_item in target.get_equipped_items(TRUE))
			if(istype(current_item, /obj/item/clothing/neck/psycross))
				pp += 1
				if(pp >= 12 & target == user) // A harmless easter-egg. Only applies on self-cast. You'd have to be pretty deliberate to wear 12 of them.
					target.visible_message(span_danger("[target]'s many psycrosses reverberate with a strange, ephemeral sound..."), span_userdanger("HE must be waking up! I can hear it! I'm ENDURING so much!"))
					playsound(user, 'sound/magic/PSYDONE.ogg', 100, FALSE)
					sleep(60)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(20)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(15)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(10)
					user.gib()
					return FALSE

				switch(current_item.type) // Target-based worn Psicross Piety bonus. For fun.
					if(/obj/item/clothing/neck/psycross)
						psicross_bonus = 0.3
					if(/obj/item/clothing/neck/psycross/silver)
						psicross_bonus = 0.4
					if(/obj/item/clothing/neck/psycross/g) // PURITY AFLOAT.
						psicross_bonus = 0.4
		if(damtotal >= 300) // ARE THEY ENDURING MUCH, IN ONE WAY OR ANOTHER?
			situational_bonus += 0.3

		if(wAmount.len > 5)
			situational_bonus += 0.3

		if (situational_bonus > 0)
			conditional_buff = TRUE

		target.visible_message(span_info("A strange stirring feeling pours from [target]!"), span_info("Sentimental thoughts drive away my pain..."))
		var/psyhealing = 3
		psyhealing += psicross_bonus
		if (conditional_buff & !zcross_trigger)
			to_chat(user, "In <b>ENDURING</b> so much, become <b>EMBOLDENED</b>!")
			psyhealing += situational_bonus

		if (zcross_trigger)
			user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
			user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
			user.adjustBruteLoss(25)
			return FALSE

		target.apply_status_effect(/datum/status_effect/buff/psyhealing, psyhealing)
		return TRUE

	return FALSE

/atom/movable/screen/alert/status_effect/buff/psyhealing
	name = "Enduring"
	desc = "I am awash with sentimentality."
	icon_state = "buff"

#define PSYDON_HEALING_FILTER "psydon_heal_glow"

/datum/status_effect/buff/psyhealing
	id = "psyhealing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psyhealing
	duration = 15 SECONDS
	examine_text = "SUBJECTPRONOUN stirs with a sense of ENDURING!"
	var/healing_on_tick = 1
	var/outline_colour = "#d3d3d3"

/datum/status_effect/buff/psyhealing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/psyhealing/on_apply()
	. = ..()
	var/filter = owner.get_filter(PSYDON_HEALING_FILTER)
	if (!filter)
		owner.add_filter(PSYDON_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/psyhealing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/psyheal_rogue(get_turf(owner))
	H.color = "#d3d3d3"
	var/list/wCount = owner.get_wounds()
	if(wCount.len > 0)
		owner.heal_wounds(healing_on_tick * 1.75)
		owner.update_damage_overlays()
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/datum/status_effect/buff/psyhealing/on_remove()
	. = ..()
	owner.remove_filter(PSYDON_HEALING_FILTER)
	owner.update_damage_hud()

/atom/movable/screen/alert/status_effect/buff/psyvived
	name = "Absolved"
	desc = "I feel a strange sense of peace."
	icon_state = "buff"

#define PSYDON_REVIVED_FILTER "psydon_revival_glow"

/datum/status_effect/buff/psyvived
	id = "psyvived"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psyvived
	duration = 30 SECONDS
	examine_text = "SUBJECTPRONOUN moves with an air of ABSOLUTION!"
	var/outline_colour = "#aa1717"

/datum/status_effect/buff/psyvived/on_creation(mob/living/new_owner)
	return ..()

/datum/status_effect/buff/psyvived/on_apply()
	. = ..()
	var/filter = owner.get_filter(PSYDON_REVIVED_FILTER)
	if (!filter)
		owner.add_filter(PSYDON_REVIVED_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/psyvived/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/psyheal_rogue(get_turf(owner))
	H.color = "#aa1717"

/datum/status_effect/buff/psyvived/on_remove()
	. = ..()
	owner.remove_filter(PSYDON_REVIVED_FILTER)
	owner.update_damage_hud()

#undef PSYDON_HEALING_FILTER
#undef PSYDON_REVIVED_FILTER
