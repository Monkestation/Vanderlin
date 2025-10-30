
/obj/item/fishing/line //short for line attachment
	attachtype = "line"
	var/bobber = FALSE
	///A bitfield of traits that this fishing line has, checked by fish traits and the minigame.
	var/fishing_line_traits
	/// Color of the fishing line
	var/line_color = COLOR_GRAY

/obj/item/fishing/line/bobber
	name = "wooden bobber"
	desc = "A wooden bobber. Keeps the hook floating in the water and helps you reel in fish."
	icon_state = "bobber"
	fishing_line_traits = FISHING_LINE_BOBBER
	line_color = "#8B4513"

/obj/item/fishing/line/sinker
	name = "stone sinker"
	desc = "A stone sinker. Keeps the hook low to catch fish that lurk at the bottom of the water."
	icon_state = "sinker"
	fishing_line_traits = FISHING_LINE_SINKER
	line_color = "#696969"

/obj/item/fishing/line/cloaked
	name = "spider silk line"
	desc = "Even harder to notice than the common variety."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_white"
	fishing_line_traits = FISHING_LINE_CLOAKED
	line_color = "#82cfdd20" //low alpha channel value, harder to see.

/obj/item/fishing/line/bouncy
	name = "flexible fishing line reel"
	desc = "This specialized line is much harder to snap."
	icon = 'icons/obj/fishing.dmi'
	icon_state = "reel_red"
	fishing_line_traits = FISHING_LINE_BOUNCY
	line_color = "#af221f"

/**
 * A special line reel that let you skip the biting phase of the minigame, netting you a completion bonus,
 * and thrown hooked items at you, so you can rapidly catch them from afar.
 * It may also work on mobs if the right hook is attached.
 */
/obj/item/fishing/line/auto_reel
	name = "fishing line auto-reel"
	icon = 'icons/obj/fishing.dmi'
	desc = "A fishing line that automatically spins lures and begins reeling in fish the moment it bites."
	icon_state = "reel_auto"
	fishing_line_traits = FISHING_LINE_AUTOREEL
	line_color = "#F88414"
