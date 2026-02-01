/datum/storage/satchel
	screen_max_rows = 4

/datum/storage/satchel/cloth
	screen_max_rows = 3
	screen_max_columns = 2

/datum/storage/backpack
	screen_max_rows = 7
	screen_max_columns = 4
	equipped_access_flags = STORAGE_ACCESS_NOT_WORN

/datum/storage/cannon
	screen_max_rows = 3
	screen_max_columns = 3
	max_specific_storage = WEIGHT_CLASS_HUGE

/datum/storage/surgery_bag
	screen_max_rows = 5
	screen_max_columns = 4

/datum/storage/belt
	screen_max_rows = 3
	screen_max_columns = 2
	max_specific_storage = WEIGHT_CLASS_SMALL

/datum/storage/coin_pouch
	screen_max_rows = 4
	screen_max_columns = 1

/datum/storage/coin_pouch/cloth
	screen_max_rows = 2
	screen_max_columns = 1

/datum/storage/keyring
	screen_max_rows = 4
	screen_max_columns = 5
	max_specific_storage = WEIGHT_CLASS_SMALL
	allow_quick_empty = TRUE
	allow_quick_gather = TRUE
	attack_hand_interact = FALSE
	collection_mode = COLLECT_ONE
	insert_preposition = "on"
	rustle_sound = 'sound/items/gems (1).ogg'

/datum/storage/keyring/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/key))

/datum/storage/belt/knife_belt
	screen_max_rows = 4
	screen_max_columns = 4

/datum/storage/belt/knife_belt/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/weapon/knife/throwingknife))

/datum/storage/belt/cloth
	screen_max_columns = 1

/datum/storage/belt/assassin
	max_specific_storage = WEIGHT_CLASS_NORMAL

/datum/storage/cloak
	screen_max_rows = 2
	screen_max_columns = 2

/datum/storage/cloak/lord
	max_specific_storage = WEIGHT_CLASS_BULKY

/datum/storage/mailmaster
	max_specific_storage = WEIGHT_CLASS_HUGE
	screen_max_rows = 10
	screen_max_columns = 10

/datum/storage/mailmaster/show_contents(mob/to_show)
	. = ..()
	if(!.)
		return

	if(istype(parent, /obj/item/fake_machine/mastermail))
		var/obj/item/fake_machine/mastermail/mail_machine = parent
		if(mail_machine.new_mail)
			mail_machine.new_mail = FALSE
			mail_machine.update_appearance(UPDATE_ICON_STATE)

/datum/storage/bin
	max_specific_storage = WEIGHT_CLASS_HUGE
	screen_max_rows = 8
	screen_max_columns = 4

/datum/storage/bin/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	cant_hold = typecacheof(list(/obj/item/weapon))

/datum/storage/sack
	screen_max_rows = 5
	screen_max_columns = 4
	collection_mode = COLLECT_EVERYTHING
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	insert_preposition = "in"

/datum/storage/handbasket
	screen_max_rows = 3
	screen_max_columns = 3
	collection_mode = COLLECT_EVERYTHING
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	insert_preposition = "in"

/datum/storage/sack/meat/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/natural/fur,
		/obj/item/natural/hide,
		/obj/item/alch/sinew,
		/obj/item/alch/viscera,
		/obj/item/alch/bone,
	))

/datum/storage/egg_basket
	screen_max_rows = 5
	screen_max_columns = 2
	collection_mode = COLLECT_SAME
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	insert_preposition = "in"

/datum/storage/egg_basket/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/reagent_containers/food/snacks/egg))

/datum/storage/magebag
	screen_max_rows = 8
	screen_max_columns = 5

/datum/storage/magebag/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/natural/infernalash,
		/obj/item/natural/hellhoundfang,
		/obj/item/natural/moltencore,
		/obj/item/natural/abyssalflame,
		/obj/item/natural/fairydust,
		/obj/item/natural/iridescentscale,
		/obj/item/natural/heartwoodcore,
		/obj/item/natural/sylvanessence,
		/obj/item/natural/elementalmote,
		/obj/item/natural/elementalshard,
		/obj/item/natural/elementalfragment,
		/obj/item/natural/elementalrelic,
		/obj/item/natural/obsidian,
		/obj/item/natural/leyline,
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
		/obj/item/mana_battery/mana_crystal,
		/obj/item/fertilizer/ash,
		))

/datum/storage/headhook
	screen_max_rows = 6
	screen_max_columns = 4
	collection_mode = COLLECT_EVERYTHING
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	insert_preposition = "in"

/datum/storage/headhook/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/natural/head,
		/obj/item/bodypart/head,
	))

/datum/storage/headhook/bronze
	screen_max_rows = 8
	screen_max_columns = 6

/datum/storage/crucible
	screen_max_rows = 5
	screen_max_columns = 3
	max_specific_storage = WEIGHT_CLASS_HUGE

/datum/storage/crucible/can_insert(obj/item/to_insert, mob/user, messages, force, params)
	. = ..()
	if(!.)
		return

	if(!to_insert.melting_material)
		if(!ispath(to_insert.smeltresult, /obj/item/ingot))
			if(user && messages)
				user.balloon_alert(user, "won't melt!")
			return FALSE

/datum/storage/anvil_bin
	max_specific_storage = WEIGHT_CLASS_HUGE
	screen_max_rows = 8
	screen_max_columns = 4

/datum/storage/anvil_bin/open_storage(mob/living/to_show)
	. = ..()
	if(!.)
		return

	if(istype(parent, /obj/structure/material_bin))
		var/obj/structure/material_bin/bin = parent
		if(!bin.opened)
			if(!silent)
				to_show.balloon_alert(to_show, "not open!")
			return FALSE

/datum/storage/anvil_bin/can_insert(obj/item/to_insert, mob/user, messages, force, params)
	. = ..()
	if(!.)
		return

	if(istype(parent, /obj/structure/material_bin))
		var/obj/structure/material_bin/bin = parent
		if(!bin.opened)
			if(user && messages)
				user.balloon_alert(user, "not open!")
			return FALSE

/datum/storage/kobold_storage
	max_specific_storage = WEIGHT_CLASS_HUGE
	screen_max_columns = 2
	screen_max_rows = 3

/datum/storage/kobold_storage/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/mob_holder))

/datum/storage/zigbox
	max_specific_storage = WEIGHT_CLASS_TINY
	screen_max_rows = 2
	screen_max_columns = 3

/datum/storage/teapot
	screen_max_rows = 1
	screen_max_columns = 5
	max_specific_storage = WEIGHT_CLASS_HUGE

/datum/storage/cup
	screen_max_rows = 2
	screen_max_columns = 1
	max_specific_storage = WEIGHT_CLASS_TINY

/datum/storage/bucket
	screen_max_rows = 4
	screen_max_columns = 2

/datum/storage/bucket/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	//the idea is as follows
	//the bucket can hold items that you can put in, and reliably pull out without having to toss everything out
	//so no coins or fibres, they are too small and would get stuck at the bottom
	set_holdable(list(
		/obj/item/reagent_containers/food/snacks/fish,
		/obj/item/natural/worms,
		/obj/item/natural/bundle/worms,
		/obj/item/fishing/lure,
		/obj/item/grown/log/tree/stick,
		/obj/item/natural/bundle/stick,
		/obj/item/weapon/knife,//wouldn't it be cool to smuggle a knife somewhere via a bucket?
	))

/datum/storage/food/cooking
	max_specific_storage = WEIGHT_CLASS_HUGE

/datum/storage/food/cooking/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/reagent_containers/food,
		/obj/item/natural,
		/obj/item/alch,
		/obj/item/mana_battery/mana_crystal,
		/obj/item/reagent_containers/powder,
		/obj/item/organ,
		/obj/item/neuFarm/seed,
		/obj/item/mob_holder,
	))

/datum/storage/food/cooking/pan
	screen_max_rows = 2
	screen_max_columns = 2
	insert_preposition = "on"

/datum/storage/food/cooking/pot
	screen_max_rows = 3
	screen_max_columns = 3
	insert_preposition = "in"

/datum/storage/food/cooking/oven
	screen_max_rows = 2
	screen_max_columns = 5
	insert_preposition = "in"

/datum/storage/porter
	screen_max_rows = 8
	screen_max_columns = 5
	max_specific_storage = WEIGHT_CLASS_HUGE
	equipped_access_flags = STORAGE_ACCESS_NOT_WORN
	allow_big_nesting = TRUE

/datum/storage/pilltin
	max_specific_storage = WEIGHT_CLASS_TINY
	screen_max_rows = 1
	screen_max_columns = 3
	max_slots = 3

/datum/storage/pilltin/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/reagent_containers/pill))

/datum/storage/ifak
	screen_max_rows = 2
	screen_max_columns = 5

/datum/storage/ifak/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(
		/obj/item/weapon/surgery,
		/obj/item/needle,
		/obj/item/natural/worms/leech,
		/obj/item/reagent_containers/lux,
		/obj/item/natural/bundle/cloth,
		/obj/item/natural/cloth,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/fancy/pilltin,
		/obj/item/candle/yellow,
	))

/datum/storage/drying_rack
	max_specific_storage = WEIGHT_CLASS_HUGE
	screen_max_rows = 8
	screen_max_columns = 4

/datum/storage/drying_rack/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/clothing))

/datum/storage/tray
	max_specific_storage = WEIGHT_CLASS_BULKY
	screen_max_rows = 6
	screen_max_columns = 1

/datum/storage/tray/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()
	set_holdable(list(/obj/item/plate))

/datum/storage/messkit
	screen_max_rows = 2
	screen_max_columns = 5
	max_specific_storage = WEIGHT_CLASS_BULKY
	allow_big_nesting = TRUE
	equipped_access_flags = STORAGE_ACCESS_NOT_WORN

/datum/storage/messkit/New(atom/parent, screen_max_rows, screen_max_columns, max_slots, max_specific_storage, max_total_storage)
	. = ..()

	set_holdable(list(/obj/item/kitchen, /obj/item/folding_table_stored, /obj/item/cooking, /obj/item/reagent_containers/food/snacks, /obj/item/reagent_containers, /obj/item/mobilestove))
