
/obj/item/painting
	name = "painting"
	icon_state = "painting"
	desc = ""
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.65
	static_price = TRUE
	sellprice = 20
	icon = 'icons/roguetown/misc/decoration.dmi'
	item_weight = 1.5 KILOGRAMS
	var/deployed_structure = /obj/structure/fluff/walldeco/painting

/obj/item/painting/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isclosedturf(attacked_atom))
		return ..()

	var/direction = get_dir(attacked_atom,user)
	if(!(direction in GLOB.cardinals))
		return ..()

	. = TRUE
	to_chat(user, span_warning("I place [src] on the wall."))
	if(!do_after(user, 3 SECONDS, attacked_atom))
		return
	var/obj/structure/S = new deployed_structure(user.loc)
	switch(direction)
		if(NORTH)
			S.pixel_y = S.base_pixel_y - 32
		if(SOUTH)
			S.pixel_y = S.base_pixel_y + 32
		if(WEST)
			S.pixel_x = S.base_pixel_x + 32
		if(EAST)
			S.pixel_x = S.base_pixel_x - 32
	qdel(src)

/obj/structure/fluff/walldeco/painting
	name = "painting"
	desc = "The artist is unknown. The subject is unknown. Maybe a memorial to a corpse that was trampled on the trail to this reality."
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "painting_deployed"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE
	layer = ABOVE_MOB_LAYER
	var/stolen_painting = /obj/item/painting

/obj/structure/fluff/walldeco/painting/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(do_after(user, 3 SECONDS, src))
		var/obj/item/I = new stolen_painting(user.loc)
		user.put_in_hands(I)
		qdel(src)
		return

/* Paintings */
/obj/item/painting/queen
	icon_state = "queenpainting"
	desc = "A portrait of Queen Samantha I of Psydonia. Her sudden disappearance marked a day of tragedy and mourning still practiced to this year."
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/queen

/obj/structure/fluff/walldeco/painting/queen
	desc = "A portrait of Queen Samantha I of Psydonia. Her sudden disappearance marked a day of tragedy and mourning still practiced to this year."
	icon_state = "queenpainting_deployed"
	stolen_painting = /obj/item/painting/queen

/obj/item/painting/seraphina
	icon_state = "seraphinapainting"
	desc = "A portrait of holy priest Seraphina, first of her name, blessed be her name."
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/seraphina

/obj/structure/fluff/walldeco/painting/seraphina
	desc = "A portrait of holy priest Seraphina, first of her name, blessed be her name."
	icon_state = "seraphinapainting_deployed"
	stolen_painting = /obj/item/painting/seraphina

/obj/item/painting/skull
	icon_state = "skullpainting"
	desc = "A moody scene depicting a skull and candles on a table. Memento mori."
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/skull

/obj/structure/fluff/walldeco/painting/skull
	desc = "A moody scene depicting a skull and candles on a table. Memento mori."
	icon_state = "skullpainting_deployed"
	stolen_painting = /obj/item/painting/skull

/obj/item/painting/castle
	icon_state = "castlepainting"
	desc = "A painting of a dark tower looming beyond mountains and mist."
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/castle

/obj/structure/fluff/walldeco/painting/castle
	desc = "A painting of a dark tower looming beyond mountains and mist."
	icon_state = "castlepainting_deployed"
	stolen_painting = /obj/item/painting/castle

/obj/item/painting/crown
	icon_state = "crownpainting"
	desc = "A painting of a kingly crown resting on a book."
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/crown

/obj/structure/fluff/walldeco/painting/crown
	desc = "A painting of a kingly crown resting on a book."
	icon_state = "crownpainting_deployed"
	stolen_painting = /obj/item/painting/crown
