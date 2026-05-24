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

	var/healing_on_tick = 1

	var/outline_colour = "#c42424"
	var/outline_alpha = 60

	var/visual_type = /obj/effect/temp_visual/heal_rogue
	var/effect_color = "#FF0000"

/datum/status_effect/buff/healing/on_creation(mob/living/new_owner, duration_override, new_healing_on_tick)
	if(!isnull(new_healing_on_tick))
		healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/healing/on_apply()
	. = ..()
	if(outline_colour)
		owner.add_filter(id, 2, list("type" = "outline", "color" = outline_colour, "alpha" = outline_alpha, "size" = 1))

/datum/status_effect/buff/healing/tick(seconds_between_ticks)
	if(visual_type)
		var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
		H.color = effect_color

	owner.adjust_blood_volume(healing_on_tick + 1, maximum = BLOOD_VOLUME_NORMAL)
	owner.adjustOxyLoss(-healing_on_tick, FALSE)
	owner.adjustToxLoss(-healing_on_tick, FALSE)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, FALSE)
	owner.adjustBruteLoss(-healing_on_tick, FALSE)
	owner.adjustFireLoss(-healing_on_tick, TRUE)

	if(length(owner.get_wounds()) && owner.heal_wounds(healing_on_tick, src))
		owner.update_damage_overlays()

/datum/status_effect/buff/healing/on_remove()
	. = ..()
	if(outline_colour)
		owner.remove_filter(id)
