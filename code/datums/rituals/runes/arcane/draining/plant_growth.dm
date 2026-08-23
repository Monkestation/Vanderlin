/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/deweed
	name = "arcyne deweed sigil"
	desc = "A creeping, root-like sigil that reaches into the earth and tears out what does not belong..."
	color = "#6BBF59"
	invocation = "Vel'keth un'dara!"
	user_facing = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/deweed/trigger_effects()
	for(var/obj/structure/soil/S in range(4, src))
		S.deweed()

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/crop_growth
	name = "arcyne growth sigil"
	desc = "A spiraling, vine-etched sigil that breathes life into dormant seeds and urges them skyward..."
	color = "#A8D84A"
	invocation = "Veth'ara un'kael!"
	user_facing = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/crop_growth/trigger_effects()
	for(var/obj/structure/soil/S in range(4, src))
		if(S.add_growth(1 MINUTES))
			S.update_appearance(UPDATE_OVERLAYS)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/water
	name = "arcyne water sigil"
	desc = "A flowing, tide-marked sigil that draws moisture from the air and feeds it to the earth..."
	color = "#3FA7D6"
	invocation = "Aev'seth un'mora!"
	user_facing = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/water/trigger_effects()
	for(var/obj/structure/soil/S in range(4, src))
		S.adjust_water(20)
