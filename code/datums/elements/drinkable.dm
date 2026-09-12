/// Allows something to be drank from unconditionally, apply sparingly to non-turfs
/datum/element/drinkable
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	var/datum/reagent/reagent_type
	var/drink_time
	var/drink_amount

/datum/element/drinkable/Attach(datum/target, reagent_type = /datum/reagent/water, drink_time = 2.5 SECONDS, drink_amount = 2)
	. = ..()
	if(!isturf(target) && !isobj(target))
		return ELEMENT_INCOMPATIBLE

	if(!ispath(reagent_type, /datum/reagent))
		CRASH("Non reagent path passed to [type]!")

	src.reagent_type = reagent_type
	src.drink_time = drink_time
	src.drink_amount = drink_amount

	RegisterSignal(target, COMSIG_ATOM_BITTEN, PROC_REF(start_drink))

/datum/element/drinkable/proc/start_drink(atom/source, mob/living/drinker)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(do_drink), source, drinker)

/datum/element/drinkable/proc/do_drink(atom/fountain, mob/living/drinker)
	. = TRUE // Cancel other bites

	playsound(drinker, pick('sound/foley/waterwash (1).ogg', 'sound/foley/waterwash (2).ogg'), 100)
	drinker.visible_message(span_info("[drinker] starts to drink from [fountain]."))

	if(!do_after(drinker, drink_time, fountain))
		return

	var/datum/reagents/reagents = new()
	reagents.add_reagent(reagent_type, drink_amount)
	reagents.trans_to(drinker, reagents.total_volume, transfered_by = drinker, method = INGEST)

	playsound(drinker, pick('sound/items/drink_gen (1).ogg', 'sound/items/drink_gen (2).ogg', 'sound/items/drink_gen (3).ogg'), 100, TRUE)
