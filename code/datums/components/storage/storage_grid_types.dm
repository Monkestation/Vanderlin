/datum/component/storage/concrete/grid
	grid = TRUE

/datum/component/storage/concrete/grid/satchel
	screen_max_rows = 4
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/satchel/cloth
	screen_max_rows = 3
	screen_max_columns = 2

/datum/component/storage/concrete/grid/backpack
	screen_max_rows = 7
	screen_max_columns = 4
	max_w_class = WEIGHT_CLASS_NORMAL
	not_while_equipped = TRUE

/datum/component/storage/concrete/grid/cannon
	screen_max_rows = 3
	screen_max_columns = 3
	max_w_class = WEIGHT_CLASS_HUGE

/datum/component/storage/concrete/grid/surgery_bag
	screen_max_rows = 5
	screen_max_columns = 4
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/belt
	screen_max_rows = 3
	screen_max_columns = 2
	max_w_class = WEIGHT_CLASS_SMALL

/datum/component/storage/concrete/grid/coin_pouch
	screen_max_rows = 4
	screen_max_columns = 1
	max_w_class = WEIGHT_CLASS_NORMAL
	not_while_equipped = FALSE

/datum/component/storage/concrete/grid/coin_pouch/cloth
	screen_max_rows = 2
	screen_max_columns = 1

/datum/component/storage/concrete/grid/keyring
	screen_max_rows = 4
	screen_max_columns = 5
	max_w_class = WEIGHT_CLASS_SMALL
	allow_dump_out = TRUE
	click_gather = TRUE
	attack_hand_interact = FALSE
	collection_mode = COLLECT_ONE
	insert_verb = "slide"
	insert_preposition = "on"
	rustle_sound = 'sound/items/gems (1).ogg'

/datum/component/storage/concrete/grid/keyring/New(datum/P, ...)
	. = ..()
	set_holdable(list(/obj/item/key))

/datum/component/storage/concrete/grid/belt/knife_belt
	screen_max_rows = 4
	screen_max_columns = 4

/datum/component/storage/concrete/grid/belt/knife_belt/New(datum/P, ...)
	. = ..()
	set_holdable(list(/obj/item/weapon/knife/throwingknife))


/datum/component/storage/concrete/grid/belt/cloth
	screen_max_columns = 1

/datum/component/storage/concrete/grid/belt/assassin
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/cloak
	max_w_class = WEIGHT_CLASS_NORMAL
	screen_max_rows = 2
	screen_max_columns = 2

/datum/component/storage/concrete/grid/cloak/lord
	max_w_class = WEIGHT_CLASS_BULKY

/datum/component/storage/concrete/grid/mailmaster
	max_w_class = WEIGHT_CLASS_HUGE
	screen_max_rows = 10
	screen_max_columns = 10

/datum/component/storage/concrete/grid/mailmaster/show_to(mob/M)
	. = ..()
	if(!.)
		return
	if(istype(parent, /obj/item/fake_machine/mastermail))
		var/obj/item/fake_machine/mastermail/mail_machine = parent
		if(mail_machine.new_mail)
			mail_machine.new_mail = FALSE
			mail_machine.update_appearance(UPDATE_ICON_STATE)

/datum/component/storage/concrete/grid/bin
	max_w_class = WEIGHT_CLASS_HUGE
	screen_max_rows = 8
	screen_max_columns = 4

/datum/component/storage/concrete/grid/bin/New(datum/P, ...)
	. = ..()
	cant_hold = typecacheof(list(/obj/item/weapon))

/datum/component/storage/concrete/grid/sack
	max_w_class = WEIGHT_CLASS_NORMAL
	screen_max_rows = 5
	screen_max_columns = 4
	click_gather = TRUE
	collection_mode = COLLECT_EVERYTHING
	dump_time = 0
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	allow_dump_out = TRUE
	insert_preposition = "in"

/datum/component/storage/concrete/grid/handbasket
	max_w_class = WEIGHT_CLASS_NORMAL
	screen_max_rows = 3
	screen_max_columns = 3
	click_gather = TRUE
	collection_mode = COLLECT_EVERYTHING
	dump_time = 0
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	allow_dump_out = TRUE
	insert_preposition = "in"

/datum/component/storage/concrete/grid/sack/meat/New(datum/P, ...)
	. = ..()
	set_holdable(list(
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/natural/fur,
		/obj/item/natural/hide,
		/obj/item/alch/sinew,
		/obj/item/alch/viscera,
		/obj/item/alch/bone
		))

/datum/component/storage/concrete/grid/egg_basket
	max_w_class = WEIGHT_CLASS_NORMAL
	screen_max_rows = 5
	screen_max_columns = 2
	click_gather = TRUE
	collection_mode = COLLECT_EVERYTHING
	dump_time = 0
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	insert_preposition = "in"

/datum/component/storage/concrete/grid/egg_basket/New(datum/P, ...)
	. = ..()
	set_holdable(
		typecacheof(list(/obj/item/reagent_containers/food/snacks/egg)
	))

/datum/component/storage/concrete/grid/magebag
	max_w_class = WEIGHT_CLASS_NORMAL
	screen_max_rows = 8
	screen_max_columns = 5

/datum/component/storage/concrete/grid/magebag/New(datum/P, ...)
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

/datum/component/storage/concrete/grid/headhook
	max_w_class = WEIGHT_CLASS_NORMAL
	screen_max_rows = 6
	screen_max_columns = 4
	click_gather = TRUE
	collection_mode = COLLECT_EVERYTHING
	dump_time = 0
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	allow_dump_out = TRUE
	insert_preposition = "in"

/datum/component/storage/concrete/grid/headhook/New(datum/P, ...)
	. = ..()
	set_holdable(list(/obj/item/natural/head,
		/obj/item/bodypart/head)
	)

/datum/component/storage/concrete/grid/headhook/bronze
	max_w_class = WEIGHT_CLASS_NORMAL
	screen_max_rows = 8
	screen_max_columns = 6
	click_gather = TRUE
	collection_mode = COLLECT_EVERYTHING
	dump_time = 0
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	allow_dump_out = TRUE
	insert_preposition = "in"

/datum/component/storage/concrete/grid/crucible
	screen_max_rows = 5
	screen_max_columns = 3
	max_w_class = WEIGHT_CLASS_HUGE
	not_while_equipped = TRUE

/datum/component/storage/concrete/grid/crucible/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check, list/modifiers, storage_click)
	if(!storing.melting_material)
		var/obj/item/ingot/ingot = storing.smeltresult
		if(!ispath(ingot, /obj/item/ingot))
			return FALSE
	. = ..()

/datum/component/storage/concrete/grid/anvil_bin
	max_w_class = WEIGHT_CLASS_HUGE
	screen_max_rows = 8
	screen_max_columns = 4

/datum/component/storage/concrete/grid/anvil_bin/show_to(mob/M)
	var/obj/structure/material_bin/source = src.parent
	if(!source.opened)
		return FALSE
	. = ..()

/datum/component/storage/concrete/grid/anvil_bin/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check, list/modifiers, storage_click)
	var/obj/structure/material_bin/source = src.parent
	if(!source.opened)
		return FALSE
	. = ..()

/datum/component/storage/concrete/grid/kobold_storage
	max_w_class = WEIGHT_CLASS_HUGE
	screen_max_columns = 2
	screen_max_rows = 3

/datum/component/storage/concrete/grid/kobold_storage/New(datum/P, ...)
	. = ..()
	set_holdable(list(
		/obj/item/mob_holder,
		))

/datum/component/storage/concrete/grid/zigbox
	max_w_class = WEIGHT_CLASS_TINY
	screen_max_rows = 2
	screen_max_columns = 3
	max_items = 6

/datum/component/storage/concrete/grid/teapot
	screen_max_rows = 1
	screen_max_columns = 5
	max_w_class = WEIGHT_CLASS_HUGE

/datum/component/storage/concrete/grid/cup
	screen_max_rows = 2
	screen_max_columns = 1
	max_w_class = WEIGHT_CLASS_TINY

/datum/component/storage/concrete/grid/bucket
	screen_max_rows = 4
	screen_max_columns = 2
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/bucket/New(datum/P, ...)
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

/datum/component/storage/concrete/grid/food/cooking
	max_w_class = WEIGHT_CLASS_HUGE

/datum/component/storage/concrete/grid/food/cooking/New(datum/P, ...)
	. = ..()
	set_holdable(
		typecacheof(
			list(
				/obj/item/reagent_containers/food,
				/obj/item/natural,
				/obj/item/alch,
				/obj/item/mana_battery/mana_crystal,
				/obj/item/reagent_containers/powder,
				/obj/item/organ,
				/obj/item/neuFarm/seed,
				/obj/item/mob_holder,
				)
			),
		)

/datum/component/storage/concrete/grid/food/cooking/pan
	screen_max_rows = 2
	screen_max_columns = 2
	insert_verb = "place"
	insert_preposition = "on"

/datum/component/storage/concrete/grid/food/cooking/pot
	screen_max_rows = 3
	screen_max_columns = 3
	insert_verb = "put"
	insert_preposition = "in"

/datum/component/storage/concrete/grid/food/cooking/oven
	screen_max_rows = 2
	screen_max_columns = 5
	insert_verb = "slide"
	insert_preposition = "in"

/datum/component/storage/concrete/grid/porter
	screen_max_rows = 8
	screen_max_columns = 5
	max_w_class = WEIGHT_CLASS_HUGE
	not_while_equipped = TRUE
	allow_big_nesting = TRUE

/datum/component/storage/concrete/grid/pilltin
	max_w_class = WEIGHT_CLASS_TINY
	screen_max_rows = 1
	screen_max_columns = 3
	max_items = 3

/datum/component/storage/concrete/grid/pilltin/New(datum/P, ...)
	. = ..()
	set_holdable(
		typecacheof(
			list(
				/obj/item/reagent_containers/pill
				)
			)
		)

/datum/component/storage/concrete/grid/ifak
	screen_max_rows = 2
	screen_max_columns = 5
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/ifak/New(datum/P, ...)
	. = ..()
	set_holdable(
		typecacheof(
			list(
			/obj/item/weapon/surgery,
			/obj/item/needle,
			/obj/item/natural/worms/leech,
			/obj/item/reagent_containers/lux,
			/obj/item/natural/bundle/cloth,
			/obj/item/natural/cloth,
			/obj/item/reagent_containers/syringe,
			/obj/item/reagent_containers/pill,
			/obj/item/storage/fancy/pilltin,
			/obj/item/candle/yellow
			)
		)
	)

/datum/component/storage/concrete/grid/drying_rack
	max_w_class = WEIGHT_CLASS_HUGE
	screen_max_rows = 8
	screen_max_columns = 4

/datum/component/storage/concrete/grid/drying_rack/New(datum/P, ...)
	. = ..()
	set_holdable(list(/obj/item/clothing))

/datum/component/storage/concrete/grid/tray
	max_w_class = WEIGHT_CLASS_BULKY
	screen_max_rows = 6
	screen_max_columns = 1

/datum/component/storage/concrete/grid/tray/New(datum/P, ...)
	. = ..()
	set_holdable(list(/obj/item/plate))
