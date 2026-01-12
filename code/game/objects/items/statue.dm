
/obj/item/statue
	icon = 'icons/roguetown/items/valuable.dmi'
	name = "statue"
	icon_state = ""
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = null
	grid_width = 32
	grid_height = 64

/obj/item/statue/gold
	name = "gold statue"
	icon_state = "gstatue1"
	smeltresult = /obj/item/ingot/gold
	sellprice = 120

/obj/item/statue/gold/Initialize()
	. = ..()
	icon_state = "gstatue[pick(1,2)]"

/obj/item/statue/gold/loot
	name = "gold statuette"
	icon_state = "lstatue1"
	sellprice = 45

/obj/item/statue/gold/loot/Initialize()
	. = ..()
	sellprice = rand(45,100)
	icon_state = "lstatue[pick(1,2)]"

/obj/item/statue/silver
	name = "silver statue"
	icon_state = "sstatue1"
	smeltresult = /obj/item/ingot/silver
	sellprice = 90

/obj/item/statue/silver/Initialize()
	. = ..()
	icon_state = "sstatue[pick(1,2)]"
	enchant(/datum/enchantment/silver)

/*	..................   Misc   ................... */
/obj/item/statue/silver/gnome
	name = "petrified gnome"
	desc = "A literal gnome, turned to stone mid-step and put on a matching stone platform. Rather unsettling."
	smeltresult = null
	sellprice = 120

/obj/item/statue/steel
	name = "steel statue"
	icon_state = "ststatue1"
	melt_amount = 50
	melting_material = /datum/material/steel
	sellprice = 60

/obj/item/statue/steel/Initialize()
	. = ..()
	icon_state = "ststatue[pick(1,2)]"

/obj/item/statue/iron
	name = "iron statue"
	icon_state = "istatue1"
	smeltresult = /obj/item/ingot/iron
	sellprice = 40

/obj/item/statue/iron/Initialize()
	. = ..()
	icon_state = "istatue[pick(1,2)]"

/obj/item/statue/iron/deformed
	name = "deformed iron statue"
	desc = "There's something strange about this statue..."
	icon_state = "istatue1"
	smeltresult = /obj/item/ore/iron
	sellprice = 10

/*	..................   Silver  ................... */
/obj/item/statue/silver/volf
	name = "silver volf bust"
	desc = "A silver bust resembling a volf's head."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "volf_silv"
	dropshrink = 0.7
	smeltresult = /obj/item/ingot/silver
	sellprice = 45

/obj/item/statue/silver/volf/Initialize()
	. = ..()
	icon_state = "volf_silv" // whoever designed this system needs to be cursed

/obj/item/statue/silver/finger
	name = "silver hand"
	desc = "A silver statue of a humen hand flashing a common Xylixian slight. This offensive item has no value."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "finger_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 0

/obj/item/statue/silver/finger/Initialize()
	. = ..()
	icon_state = "finger_silv"

/obj/item/statue/silver/urn
	name = "silver urn"
	desc = "A large decorative silver urn."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "urn_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 50

/obj/item/statue/silver/urn/Initialize()
	. = ..()
	icon_state = "urn_silv"

/obj/item/statue/silver/vase
	name = "silver vase"
	desc = "A large decorative silver vase."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "vase_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 25

/obj/item/statue/silver/vase/Initialize()
	. = ..()
	icon_state = "vase_silv"

/obj/item/statue/silver/vasefancy
	name = "fancy silver vase"
	desc = "A large decorative silver vase. It's quite fancy!"
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "fancyvase_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 45

/obj/item/statue/silver/vasefancy/Initialize()
	. = ..()
	icon_state = "fancyvase_silv"

/obj/item/statue/silver/bust
	name = "silver bust"
	desc = "A bust made out of silver."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "bust_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 30

/obj/item/statue/silver/bust/Initialize()
	. = ..()
	icon_state = "bust_silv"

/obj/item/statue/silver/figurine
	name = "silver figurine"
	desc = "A figurine made out of silver. Popular among adults as a decoration, popular among children as a toy."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "figurine_silv"
	sellprice = 15

/obj/item/statue/silver/figurine/Initialize()
	. = ..()
	icon_state = "figurine_silv"

/obj/item/statue/silver/obelisk
	name = "silver obelisk"
	desc = "An obelisk made of silver."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "obelisk_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 30

/obj/item/statue/silver/obelisk/Initialize()
	. = ..()
	icon_state = "obelisk_silv"

/obj/item/statue/silver/fish
	name = "silver fish figurine"
	desc = "A fish figurine made out of silver."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "fish_silv"
	sellprice = 15

/obj/item/statue/silver/fish/Initialize()
	. = ..()
	icon_state = "fish_silv"

/obj/item/statue/silver/tablet
	name = "silver tablet"
	desc = "A tablet made out of silver."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "tablet_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 25

/obj/item/statue/silver/tablet/Initialize()
	. = ..()
	icon_state = "tablet_silv"

/obj/item/statue/silver/cameo
	name = "silver cameo"
	desc = "A cameo made out of silver depicting...someone? Use your imagination for who it could be."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "cameo_silv"
	sellprice = 15

/obj/item/statue/silver/cameo/Initialize()
	. = ..()
	icon_state = "cameo_silv"

/obj/item/statue/silver/comb
	name = "silver comb"
	desc = "A silver comb, great for combing your hair or lack thereof."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "combs_silv"
	sellprice = 10

/obj/item/statue/silver/comb/Initialize()
	. = ..()
	icon_state = "comb_silv"

/obj/item/statue/silver/totem
	name = "silver totem"
	desc = "An elven totem made out of silver."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "elven_silv"
	smeltresult = /obj/item/ingot/silver
	sellprice = 35

/obj/item/statue/silver/totem/Initialize()
	. = ..()
	icon_state = "elven_silv"

/*	..................   Gold   ................... */
/obj/item/statue/gold/volf
	name = "golden volf bust"
	desc = "A golden bust resembling a volf's head."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "volf_gold"
	dropshrink = 0.7
	smeltresult = /obj/item/ingot/gold
	sellprice = 85

/obj/item/statue/gold/volf/Initialize()
	. = ..()
	icon_state = "volf_gold"

/obj/item/statue/gold/finger
	name = "golden hand"
	desc = "A golden statue of a humen hand flashing a common Xylixian slight. This offensive item has a measly value."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "finger_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 1

/obj/item/statue/gold/finger/Initialize()
	. = ..()
	icon_state = "finger_gold"

/obj/item/statue/gold/urn
	name = "gold urn"
	desc = "A large decorative gold urn."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "urn_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 100

/obj/item/statue/gold/urn/Initialize()
	. = ..()
	icon_state = "urn_gold"

/obj/item/statue/gold/vase
	name = "gold vase"
	desc = "A large decorative golden vase."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "vase_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 45

/obj/item/statue/gold/vase/Initialize()
	. = ..()
	icon_state = "vase_gold"

/obj/item/statue/gold/vasefancy
	name = "fancy gold vase"
	desc = "A large decorative golden vase. It's quite fancy!"
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "fancyvase_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 80

/obj/item/statue/gold/vasefancy/Initialize()
	. = ..()
	icon_state = "fancyvase_gold"

/obj/item/statue/gold/bust
	name = "gold bust"
	desc = "A bust made out of gold."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "bust_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 60

/obj/item/statue/gold/bust/Initialize()
	. = ..()
	icon_state = "bust_gold"

/obj/item/statue/gold/figurine
	name = "golden figurine"
	desc = "A figurine made out of gold. Popular among adults as a decoration, popular among children as a toy."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "figurine_gold"
	sellprice = 30

/obj/item/statue/gold/figurine/Initialize()
	. = ..()
	icon_state = "figurine_gold"

/obj/item/statue/gold/cameo
	name = "golden cameo"
	desc =  "A cameo made out of gold depicting...someone? Use your imagination for who it could be."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "cameo_gold"
	sellprice = 30

/obj/item/statue/gold/cameo/Initialize()
	. = ..()
	icon_state = "cameo_gold"

/obj/item/statue/gold/obelisk
	name = "gold obelisk"
	desc =  "An obelisk made out of gold."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "obelisk_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 60

/obj/item/statue/gold/obelisk/Initialize()
	. = ..()
	icon_state = "obelisk_gold"

/obj/item/statue/gold/tablet
	name = "gold tablet"
	desc =  "A tablet made out of gold."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "tablet_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 45

/obj/item/statue/gold/tablet/Initialize()
	. = ..()
	icon_state = "tablet_gold"

/obj/item/statue/gold/fish
	name = "golden fish figurine"
	desc =  "A fish figurine made out of gold."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "fish_gold"
	sellprice = 30

/obj/item/statue/gold/fish/Initialize()
	. = ..()
	icon_state = "fish_gold"

/obj/item/statue/gold/totem
	name = "gold totem"
	desc =  "An elven totem made out of gold."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "elven_gold"
	smeltresult = /obj/item/ingot/gold
	sellprice = 65

/obj/item/statue/gold/totem/Initialize()
	. = ..()
	icon_state = "elven_gold"

/obj/item/statue/gold/comb
	name = "golden comb "
	desc =  "A golden comb, great for combing your hair or lack thereof."
	icon = 'icons/roguetown/items/precious_objects.dmi'
	icon_state = "comb_gold"
	sellprice = 30

/obj/item/statue/gold/comb/Initialize()
	. = ..()
	icon_state = "comb_gold"



