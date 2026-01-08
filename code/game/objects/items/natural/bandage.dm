/obj/item/natural/cloth/bandage
	name = "bandage"
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "bandageroll"
	desc = "A fabric treated and specially made to help with bleeding wounds. Better and faster at stopping bleeding than your regular piece of cloth."
	bundletype = /obj/item/natural/bundle/cloth/bandage
	bandage_effectiveness = 0.25
	bandage_health = 300
	bandage_speed = 4 SECONDS
	volume = 18

/obj/item/natural/bundle/cloth/bandage
	name = "roll of bandages"
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "bandageroll1"
	desc = "A roll of joined bandages for easier carrying. A bleeding man's best friend."
	maxamount = 4
	stacktype = /obj/item/natural/cloth/bandage
	stackname = "bandages"
	icon1 = "bandageroll1"
	icon1step = 3
	icon2 = "bandageroll2"
	icon2step = 4

/obj/item/natural/bundle/cloth/bandage/full
	icon_state = "bandageroll2"
	amount = 4
