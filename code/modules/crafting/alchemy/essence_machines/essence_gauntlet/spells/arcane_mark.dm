/datum/action/cooldown/spell/essence/arcane_mark
	name = "Arcane Mark"
	desc = "Places an invisible magical mark on an object for identification."
	button_icon_state = "arcane_mark"
	cast_range = 1
	point_cost = 2
	attunements = list(/datum/attunement/light)

/datum/action/cooldown/spell/essence/arcane_mark/cast(atom/cast_on)
	. = ..()
	var/obj/item/target = cast_on
	if(!isobj(target))
		return FALSE
	owner.visible_message(span_notice("[owner] places an arcane mark on [target]."))
	target.AddComponent(/datum/component/hovering_information, /datum/hover_data/arcane_mark)

/obj/effect/overlay/hover
	icon = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	layer = ABOVE_HUD_PLANE
	plane = GAME_PLANE_UPPER

/datum/hover_data/arcane_mark
	var/obj/effect/overlay/hover/mark

/datum/hover_data/arcane_mark/New(datum/component/hovering_information, atom/parent)
	mark = new(null)
	mark.icon = 'icons/effects/effects.dmi'
	mark.icon_state = "phasein"
	mark.pixel_y = 32

/datum/hover_data/arcane_mark/setup_data(mob/living/source, mob/enterer)
	var/image/new_image = new(source)
	new_image.appearance = mark.appearance
	if(!isturf(source.loc))
		new_image.loc = source.loc
	else
		new_image.loc = source
	add_client_image(new_image, enterer.client)
