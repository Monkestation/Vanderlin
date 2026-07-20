/obj/item/weapon/surgery/saw/improv
	name = "improvised saw"
	desc = "A tool used to carve through bone crudely, but better than nothing."
	icon_state = "bonesaw_wood"
	throwforce = DAMAGE_KNIFE - 4
	tool_behaviour = TOOL_IMPROVISED_SAW
	sharpness = IS_BLUNT
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null

/obj/item/weapon/surgery/hemostat/improv
	name = "improvised clamp"
	desc = "A tool used to clamp down on soft tissue. A poor alternative to metal but better than nothing."
	icon_state = "forceps_wood"
	tool_behaviour = TOOL_IMPROVISED_HEMOSTAT
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null

/obj/item/weapon/surgery/retractor/improv
	name = "improvised retractor"
	desc = "A tool used to spread tissue open for surgical access in a tentative manner."
	icon_state = "speculum_wood"
	tool_behaviour = TOOL_IMPROVISED_RETRACTOR
	smeltresult = /obj/item/fertilizer/ash
	melting_material = null
