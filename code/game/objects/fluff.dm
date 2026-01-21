/obj/structure/flora/shells
	name = "shells"
	desc = ""
	icon = 'icons/delver/abyss_objects.dmi'
	icon_state = "shell-1"

/obj/structure/flora/shells/Initialize()
	if(icon_state == "shell-1")
		icon_state = "shell-[rand(1, 5)]"
	. = ..()

/obj/structure/flora/ocean_plants
	name = "abyssor plants"
	desc = ""
	icon = 'icons/delver/abyss_objects.dmi'
	icon_state = "clutter1"

/obj/structure/flora/ocean_plants/Initialize()
	icon_state = "clutter[rand(1, 8)]"
	. = ..()

/obj/structure/flora/starfish
	name = "starfish"
	desc = ""
	icon = 'icons/delver/abyss_objects.dmi'
	icon_state = "starfish-1"

/obj/structure/flora/starfish/Initialize()
	icon_state = "starfish-[rand(1, 3)]"
	. = ..()

/obj/structure/flora/driftwood
	name = "driftwood"
	desc = ""
	icon = 'icons/delver/abyss_objects.dmi'
	icon_state = "driftwood-1"
	debris = list(/obj/item/grown/log/tree/stick = 2)
	static_debris = list(/obj/item/grown/log/tree = 1)

/obj/structure/flora/driftwood/Initialize()
	icon_state = "driftwood-[rand(1, 4)]"
	. = ..()

// ausbush
/obj/structure/flora/ausbushes
	name = "bush"
	desc = ""
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"
	max_integrity = 25

/obj/structure/flora/ausbushes/Initialize()
	if(icon_state == "firstbush_1")
		icon_state = "firstbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/Initialize()
	icon_state = "reedbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/Initialize()
	icon_state = "leafybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/Initialize()
	icon_state = "palebush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/Initialize()
	icon_state = "stalkybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/Initialize()
	icon_state = "grassybush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/Initialize()
	icon_state = "fernybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/Initialize()
	icon_state = "sunnybush_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/Initialize()
	icon_state = "genericbush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/Initialize()
	icon_state = "pointybush_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/Initialize()
	icon_state = "lavendergrass_[rand(1, 4)]"
	. = ..()

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/Initialize()
	icon_state = "ywflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/Initialize()
	icon_state = "brflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/Initialize()
	icon_state = "ppflowers_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"
	max_integrity = 5

/obj/structure/flora/ausbushes/sparsegrass/Initialize()
	icon_state = "sparsegrass_[rand(1, 3)]"
	. = ..()

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"
	max_integrity = 5

/obj/structure/flora/ausbushes/fullgrass/Initialize()
	icon_state = "fullgrass_[rand(1, 3)]"
	. = ..()

//a rock is flora according to where the icon file is
//and now these defines

/obj/structure/flora/rock
	icon_state = "basalt"
	desc = ""
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	density = TRUE

/obj/structure/flora/rock/Initialize()
	. = ..()
	icon_state = "[icon_state][rand(1,3)]"

/obj/structure/flora/rock/pile
	icon_state = "lavarocks"
	desc = ""

/obj/structure/flora/rock/pile/largejungle
	name = "rocks"
	icon_state = "rocks"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	density = FALSE
	SET_BASE_PIXEL(-16, -16)

/obj/structure/flora/rock/pile/largejungle/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,3)]"

/obj/structure/flora/rock/water
	name = "boulder"
	icon_state = "boulder-1"
	icon = 'icons/delver/abyss_objects.dmi'

/obj/structure/flora/rock/water/Initialize()
	. = ..()
	icon_state = "boulder-[rand(1,6)]"

/obj/structure/flora/rock/coral
	name = "coral"
	icon_state = "coral-1"
	icon = 'icons/delver/abyss_objects.dmi'

/obj/structure/flora/rock/coral/Initialize()
	. = ..()
	icon_state = "coral-[rand(1,32)]"

/obj/structure/flora/pillar
	name = "pillar"
	icon_state = "pillar1"
	icon = 'icons/delver/abyss_objects.dmi'
	resistance_flags = FIRE_PROOF
	density = TRUE

/obj/structure/flora/pillar/Initialize()
	. = ..()
	icon_state = "pillar[rand(1,5)]"

//Jungle rocks

/obj/structure/flora/rock/jungle
	icon_state = "rock"
	desc = ""
	icon = 'icons/obj/flora/jungleflora.dmi'
	density = FALSE

/obj/structure/flora/rock/jungle/Initialize()
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,5)]"

/obj/structure/abyss_window
	name = "abyssal window"
	icon_state = "abyss_window"
	icon = 'icons/delver/abyss_objects.dmi'

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/abyss_window, 32)


/obj/structure/desert_elevator
	icon_state = "elevator"
	desc = ""
	icon = 'icons/delver/desert_elevator.dmi'
	density = FALSE

/obj/structure/boards
	name = "boards"
	icon_state = "boards"
	icon = 'icons/delver/desert_objects.dmi'

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/boards, 32)

/obj/structure/desert_window
	name = "desert window"
	icon_state = "window_brass"
	icon = 'icons/delver/desert_objects.dmi'

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/desert_window, 32)

/obj/structure/desert_window/open
	name = "open desert window"
	icon_state = "window_open"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/desert_window/open, 32)

/obj/structure/flora/astrata
	name = "astrata"
	icon_state = "astrata1"
	icon = 'icons/delver/desert_objects.dmi'
	resistance_flags = FIRE_PROOF
	density = TRUE

/obj/structure/flora/astrata/Initialize()
	. = ..()
	icon_state = "astrata[rand(1,3)]"

/obj/structure/flora/sandbrick
	name = "sandstone brick"
	icon_state = "sandstone_brick"
	icon = 'icons/delver/desert_objects.dmi'
	resistance_flags = FIRE_PROOF

/obj/structure/flora/kelp
	name = "kelp"
	icon_state = "kelp-1"
	icon = 'icons/delver/kelp.dmi'
	resistance_flags = FIRE_PROOF
	density = TRUE

/obj/structure/flora/kelp/Initialize()
	. = ..()
	icon_state = "kelp-[rand(1,4)]"
