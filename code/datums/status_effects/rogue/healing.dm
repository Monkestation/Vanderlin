/atom/movable/screen/alert/status_effect/buff/healing
	name = "Healing Miracle"
	desc = "Divine intervention relieves me of my ailments."
	icon_state = "buff"

/obj/effect/temp_visual/heal_rogue //color is white by default, set to whatever is needed
	name = "enduring glow"
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "heal_pantheon"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/heal_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/datum/status_effect/buff/healing
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 10 SECONDS

	var/healing_per_second = 1

	var/outline_colour = "#c42424"

	var/visual_type = /obj/effect/temp_visual/heal_rogue
	var/effect_color = "#FF0000"

/datum/status_effect/buff/healing/on_creation(mob/living/new_owner, duration_override, healing_per_second)
	if(!isnull(healing_per_second))
		src.healing_per_second = healing_per_second
	return ..()

/datum/status_effect/buff/healing/on_apply()
	. = ..()
	if(outline_colour)
		owner.add_filter(id, 2, outline_filter(1, outline_colour))

/datum/status_effect/buff/healing/on_remove()
	. = ..()
	if(outline_colour)
		owner.remove_filter(id)

/datum/status_effect/buff/healing/tick(seconds_between_ticks)
	if(visual_type)
		var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
		H.color = effect_color

	var/base_healing = healing_per_second * seconds_between_ticks

	owner.adjust_blood_volume(base_healing * 2, maximum = BLOOD_VOLUME_NORMAL)
	owner.adjustOxyLoss(-base_healing, FALSE)
	owner.adjustToxLoss(-base_healing, FALSE)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -base_healing)
	owner.adjustCloneLoss(-base_healing, FALSE)
	owner.adjustBruteLoss(-base_healing, FALSE)
	owner.adjustFireLoss(-base_healing, TRUE)

	if(length(owner.get_wounds()) && owner.heal_wounds(base_healing, src))
		owner.update_damage_overlays()
