/obj/item/clothing/head/crown		// doesn't hide hair
	dynamic_hair_suffix = ""				// this just means hair does not change when item is worn
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	resistance_flags = FIRE_PROOF | ACID_PROOF
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	abstract_type = /obj/item/clothing/head/crown

/obj/item/clothing/head/crown/circlet
	name = "golden circlet"
	icon_state = "goldcirclet"
	sellprice = VALUE_GOLD_ITEM

/obj/item/clothing/head/crown/circlet/golddiadem
	name = "gold diadem"
	desc = "A luxurious diadem forged out of gold. Often associated with the nobility of the early Grenzelhoftian Empire."
	icon_state = "diadem_g"

/obj/item/clothing/head/crown/circlet/silverdiadem
	name = "silver diadem"
	desc = "A luxurious diadem forged out of silver. Often associated with the nobility of the early Grenzelhoftian Empire "
	icon_state = "diadem_s"
	sellprice = VALUE_SILVER_ITEM

/obj/item/clothing/head/crown/circlet/silverdiadem/Initialize()
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/head/crown/circlet/goldheaddress
	name = "zenarii headdress"
	desc = "A fancy headdress made out of zenarii. Light and fashionable, it's worn by the noble ladies of The Zaladin Dynasty."
	icon_state = "headdress_g"

/obj/item/clothing/head/crown/circlet/silverheaddress
	name = "ziliquae headdress"
	desc = "A fancy headdress made out of ziliquae. Light and fashionable, it's worn by the noble ladies of The Zaladin Dynasty."
	icon_state = "headdress_s"
	sellprice = VALUE_SILVER_ITEM

/obj/item/clothing/head/crown/circlet/silverheaddress/Initialize()
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/head/crown/circlet/jade
	name = "joapstone circlet"
	desc = "An ornate circlet carved out of joapstone."
	icon_state = "circlet_jade"
	sellprice = 65

/obj/item/clothing/head/crown/circlet/amber
	name = "petriamber circlet"
	desc = "An ornate circlet carved out of petriamber."
	icon_state = "circlet_amber"
	sellprice = 65

/obj/item/clothing/head/crown/circlet/shell
	name = "shell circlet"
	desc = "An ornate circlet carved out of shell."
	icon_state = "circlet_shell"
	sellprice = 25

/obj/item/clothing/head/crown/circlet/rose
	name = "rosellusk circlet"
	desc = "An ornate circlet carved out of rosellusk."
	icon_state = "circlet_rose"
	sellprice = 30

/obj/item/clothing/head/crown/circlet/turq
	name = "ceruleabaster circlet"
	desc = "An ornate circlet carved out of ceruleabaster."
	icon_state = "circlet_turq"
	sellprice = 90

/obj/item/clothing/head/crown/circlet/onyxa
	name = "onyxa circlet"
	desc = "An ornate circlet carved out of onyxa."
	icon_state = "circlet_onyxa"
	sellprice = 45

/obj/item/clothing/head/crown/circlet/coral
	name = "aoetal circlet"
	desc = "An ornate circlet carved out of aoetal."
	icon_state = "circlet_coral"
	sellprice = 75

/obj/item/clothing/head/crown/circlet/opal
	name = "opaloise circlet"
	desc = "An ornate circlet carved out of opaloise."
	icon_state = "circlet_opal"
	sellprice = 95

/obj/item/clothing/head/crown/nyle
	name = "jewel of nyle"
	icon_state = "nile"
	sellprice = VALUE_GOLD_ITEM

/obj/item/clothing/head/crown/nyle/consortcrown
	name = "jewel of nyle"
	icon_state = "consortcrown"
	sellprice = VALUE_GOLD_ITEM

/obj/item/clothing/head/crown/serpcrown
	name = "crown of Vanderlin"
	desc = "Heavy is the weight of the crown, and even heavier the responsibility it infers to its wearer."
	icon_state = "serpcrown"
	sellprice = VALUE_EXTREME
	resistance_flags = FIRE_PROOF|ACID_PROOF|LAVA_PROOF|UNACIDABLE|INDESTRUCTIBLE

/obj/item/clothing/head/crown/serpcrown/Initialize()
	. = ..()
	name = "crown of [SSmapping.config.map_name]"
	if(type == /obj/item/clothing/head/crown/serpcrown && !istype(loc, /mob/living/carbon/human/dummy)) //dummies spawn this in character setup
		SSroguemachine.crown = src

/obj/item/clothing/head/crown/serpcrown/Destroy()
	if(SSroguemachine.crown == src)
		SSroguemachine.crown = null
	return ..()

/obj/item/clothing/head/crown/serpcrown/proc/anti_stall()
	visible_message(span_warning("[src] crumbles to dust, the ashes spiriting away in the direction of the Keep."))
	qdel(src) //Anti-stall

/obj/item/clothing/head/crown/serpcrown/surplus
	name = "crown"
	desc = "A replacement for the Crown of Vanderlin, every bit as valid as proof of sovereignity as the original."
	icon_state = "serpcrowno"
	sellprice = VALUE_GOLD_ITEM

/obj/item/clothing/head/crown/sparrowcrown
	name = "champions circlet"
	desc = "Winner of tournaments, bask in Ravox's glory."
	icon_state = "sparrowcrown"
	sellprice = VALUE_GOLD_ITEM

/*obj/item/clothing/head/crown/hemhem
	name = "hemhem crown"
	desc = "A large ceremonial crown heavily associated with the Hemhem desert, located in the Queendom of Lakkari. It looks pretty heavy."
	icon_state = "hemhem"
	sellprice = VALUE_GOLD_ITEM
*/

/obj/item/clothing/head/crown/circlet/vision
	name = "mystical circlet"
	desc = "A shining gold circlet, with a mysterious purple insert. You feel like you have a third eye while near it..."
	icon_state = "visioncirclet"
	item_state = "visioncirclet"
	sellprice = VALUE_MAGIC_ITEM_STRONG

/obj/item/clothing/head/crown/circlet/vision/equipped(mob/user, slot)
	. = ..()
	if ((slot & ITEM_SLOT_HEAD) && istype(user))
		ADD_TRAIT(user, TRAIT_THERMAL_VISION,"thermal_vision")
	else
		REMOVE_TRAIT(user, TRAIT_THERMAL_VISION,"thermal_vision")

//............... Nosleep Circlet ............... //
/obj/item/clothing/head/crown/circlet/sleepless
	name = "clouded circlet"
	desc = "A shining gold circlet, with a mysterious blue insert. You feel more energetic while near it..."
	icon_state = "sleepcirclet"
	item_state = "sleepcirclet"
	sellprice = VALUE_MAGIC_ITEM_WEAK

/obj/item/clothing/head/crown/circlet/sleepless/equipped(mob/user, slot)
	. = ..()
	if ((slot & ITEM_SLOT_HEAD) && istype(user))
		ADD_TRAIT(user, TRAIT_NOSLEEP,"Fatal Insomnia")
	else
		REMOVE_TRAIT(user, TRAIT_NOSLEEP,"Fatal Insomnia")

//............... Stink Immunity Circlet ............... //
/obj/item/clothing/head/crown/circlet/stink
	name = "numbing circlet"
	desc = "A shining gold circlet, with a mysterious green insert. You feel your sense of smell numb while near it..."
	icon_state = "stinkcirclet"
	item_state = "stinkcirclet"
	sellprice = VALUE_MAGIC_ITEM_WEAK

/obj/item/clothing/head/crown/circlet/stink/equipped(mob/user, slot)
	. = ..()
	if ((slot & ITEM_SLOT_HEAD) && istype(user))
		ADD_TRAIT(user, TRAIT_DEADNOSE,"Dead Nose")
	else
		REMOVE_TRAIT(user, TRAIT_DEADNOSE,"Dead Nose")
