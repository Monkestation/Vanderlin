/datum/slapcraft_step/use_item/sewing/needle
	desc =  "Using a needle sew the seams"
	item_types = list(/obj/item/needle)

/datum/slapcraft_step/use_item/carpentry/hammer
	desc = "Hammer the wooden joints"
	item_types = list(/obj/item/weapon/hammer)

/datum/slapcraft_step/use_item/carpentry/hammer/second

/datum/slapcraft_step/use_item/carpentry/hammer/get_speed_multiplier(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	. = ..()
	var/obj/item/weapon/hammer/hammer = item
	. *= hammer.toolspeed

/datum/slapcraft_step/use_item/masonry/hammer
	desc = "Hammer the stones"
	start_verb = "for"
	item_types = list(/obj/item/weapon/hammer)

/datum/slapcraft_step/use_item/masonry/hammer/second
/datum/slapcraft_step/use_item/masonry/hammer/third

/datum/slapcraft_step/use_item/masonry/hammer/get_speed_multiplier(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	. = ..()
	var/obj/item/weapon/hammer/hammer = item
	. *= hammer.toolspeed

/datum/slapcraft_step/use_item/engineering/hammer
	desc = "Hammer the mechanical parts"
	item_types = list(/obj/item/weapon/hammer)

/datum/slapcraft_step/use_item/engineering/hammer/second

/datum/slapcraft_step/use_item/engineering/hammer/get_speed_multiplier(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	. = ..()
	var/obj/item/weapon/hammer/hammer = item
	. *= hammer.toolspeed

/datum/slapcraft_step/use_item/masonry/chisel
	desc = "Chisel the rock"
	start_verb = "for"
	item_types = list(/obj/item/weapon/chisel)

/datum/slapcraft_step/use_item/masonry/chisel/second
/datum/slapcraft_step/use_item/masonry/chisel/third

/datum/slapcraft_step/use_item/masonry/chisel/get_speed_multiplier(mob/living/user, obj/item/item, obj/item/slapcraft_assembly/assembly)
	. = ..()
	var/obj/item/weapon/chisel/chisel = item
	. *= chisel.toolspeed
