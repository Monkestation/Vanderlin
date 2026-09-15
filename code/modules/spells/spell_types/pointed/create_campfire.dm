/datum/action/cooldown/spell/create_campfire
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "Create Campfire"
	desc = "Creates a magical campfire to cook on. 3 tiles range. Lasts for 10 minutes."
	button_icon_state = "create_campfire"
	sound = 'sound/magic/whiteflame.ogg'
	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 3

	spell_cost = 10
	required_form = FORM_FIRE

	invocation = "Ignis Castrensis Magicae."
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_NO_MOVE | SPELL_REQUIRES_SAME_Z

	var/static/list/turf_blacklist = list(
		/turf/open/water,
		/turf/open/openspace,
		)

/datum/action/cooldown/spell/create_campfire/cast(atom/cast_on)
	. = ..()
	var/turf/target = get_turf(cast_on)

	if(!target || !target.Enter(owner) || is_type_in_list(target, turf_blacklist))
		to_chat(owner, span_warning("This turf can't be on fiyaaaah! (It's blocked sire.)"))
		return FALSE

	new /obj/machinery/light/fueled/campfire/create_campfire(target)

	return TRUE

/obj/machinery/light/fueled/campfire/create_campfire
	name = "magical campfire"
	icon_state = "densefire1"
	base_state = "densefire"
	density = FALSE
	layer = 2.8
	brightness = 7
	fueluse = 10 MINUTES
	color = "#6ab2ee"
	bulb_colour = "#6ab2ee"
	max_integrity = 30
	var/lifespan = 10 MINUTES

/obj/machinery/light/fueled/campfire/create_campfire/Initialize()
	. = ..()
	if(lifespan)
		QDEL_IN(src, lifespan) //delete after it runs out

/obj/machinery/light/fueled/campfire/create_campfire/onkick(mob/user)
	var/mob/living/L = user
	L.visible_message(span_info("[L] kicks \the [src], the arcyne fire dissipating."))
	burn_out()
	qdel(src)
