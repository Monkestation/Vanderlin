/datum/action/cooldown/spell/undirected/mansion_portal
	name = "Mansion Portal"
	desc = "Create a portal to return to MY mansion"
	has_visual_effects = FALSE

	charge_required = FALSE
	cooldown_time = 15 MINUTES
	spell_cost = 0

/datum/action/cooldown/spell/undirected/mansion_portal/cast(atom/cast_on)
	. = ..()
	if(SSmapping.config.map_name == "Voyage")
		to_chat(owner, span_warning("It cannot be, Nothing happens."))
		return

	var/obj/structure/vampire/portalmaker/destination
	for(var/obj/structure/vampire/portalmaker/P in GLOB.vampire_objects)
		destination = P
		break
	if(!destination)
		to_chat(owner, span_warning("It cannot be, Nothing happens."))
		return

	var/obj/effect/portal/vampire/portal = new /obj/effect/portal/vampire(get_turf(owner), owner, 15 MINUTES, null, FALSE, get_turf(destination), FALSE)
	portal.RegisterSignal(destination, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/obj/effect/portal/vampire, handle_portalmaker_destruction))

/obj/effect/portal/vampire
	name = "Eerie Portal"
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	icon_state = "portal"

/obj/effect/portal/vampire/proc/handle_portalmaker_destruction()
	visible_message(span_boldnotice("[src] shudders before rapidly closing."))
	qdel(src)
