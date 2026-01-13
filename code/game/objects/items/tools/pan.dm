/obj/item/cooking/pan
	name = "frypan"
	icon_state = "pan"
	force = DAMAGE_MACE
	throwforce = DAMAGE_MACE - 5
	wdefense = ULTMATE_PARRY
	can_parry = TRUE
	possible_item_intents = list(SHOVEL_STRIKE)

	wlength = WLENGTH_SHORT
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 64

	sharpness = IS_BLUNT
	slot_flags = ITEM_SLOT_HIP
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	associated_skill = /datum/skill/combat/axesmaces
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/iron
	ingsize = 3

/obj/item/cooking/pan/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/food/cooking/pan)
	AddComponent(/datum/component/container_craft, subtypesof(/datum/container_craft/pan))
	AddComponent(/datum/component/food_burner, 2 MINUTES, TRUE, CALLBACK(src, PROC_REF(can_burn)))

/obj/item/cooking/pan/examine(mob/user)
	. = ..()

/obj/item/cooking/pan/proc/can_burn()
	if(!istype(loc, /obj/machinery/light/fueled))
		return FALSE
	var/obj/machinery/light/fueled/fueled = loc
	if(!fueled.fueluse)
		return FALSE
	return TRUE

/obj/item/cooking/pan/proc/get_item_overlay(obj/item/our_item)
	var/mutable_appearance/MA = mutable_appearance(our_item.icon, our_item.icon_state)
	MA.color = our_item.color
	MA.pixel_x = our_item.base_pixel_x + rand(-3, 3)
	MA.pixel_y = our_item.base_pixel_y + rand(-3, 3)
	MA.vis_flags = VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID
	MA.blend_mode = BLEND_INSET_OVERLAY
	MA.transform *= 0.6
	return MA

/obj/item/cooking/pan/update_overlays()
	. = ..()

	for(var/obj/item/I as anything in contents)
		. += get_item_overlay(I)

/obj/item/cooking/pan/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	var/list/obj/item/oldContents = contents.Copy()
	if(!length(oldContents))
		return
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_QUICK_EMPTY)
	var/generator/scatter_gen = generator(GEN_CIRCLE, 0, 48, NORMAL_RAND)
	for(var/obj/item/scattered_item as anything in oldContents)
		var/list/scatter_vector = scatter_gen.Rand()
		scattered_item.pixel_x = scattered_item.base_pixel_x + scatter_vector[1]
		scattered_item.pixel_y = scattered_item.base_pixel_y + scatter_vector[2]
		scattered_item.throw_impact(hit_atom, throwingdatum)
