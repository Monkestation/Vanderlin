/datum/action/cooldown/spell/blood_pearl
	name = "Create Blood Pearl"
	desc = "Congeal Vitae into a pearl for storage."
	button_icon = 'icons/roguetown/items/misc.dmi'
	button_icon_state = "blood_pearl"
	sound = 'sound/magic/churn.ogg'

	click_to_activate = TRUE
	required_form = FORM_BLOOD
	required_level = 6

	invocation = "Sanguis congeala!"
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_cost = 600
	spell_flags = SPELL_RITUOS

/datum/action/cooldown/spell/blood_pearl/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/obj/item/blood_pearl/pearl = new(user.drop_location())
	pearl.stored_blood_color = user.get_blood_type().color
	user.put_in_hands(pearl)
	return TRUE

/obj/item/blood_pearl
	name = "blood pearl"
	desc = "A metallic pearl of blood."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "blood_pearl"
	dropshrink = 0.6
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	alpha = 255
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 32
	item_weight = 120 GRAMS
	var/vitae_amount = 500 // Summon spell is set to 600, 100 more than Vitae stored to prevent using for dupes.
	var/max_vitae = 1000
	var/stored_blood_color = COLOR_BLOOD

/obj/item/blood_pearl/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_BLOOD_SENSE) || HAS_TRAIT(user, TRAIT_BLOOD_MAGE) || HAS_TRAIT(user, TRAIT_BLOOD_SORCERER))
		. += span_bloody("The pearl contains [vitae_amount]/[max_vitae] Vitae")
	else
		. += span_warning("This just feels wrong... I should get rid of it.")
	if(HAS_TRAIT(user, TRAIT_DIVINE_SERVANT))
		. += SPAN_GOD_NECRA("A Necran could destroy this...")

/obj/item/blood_pearl/attack_self(mob/user, list/modifiers)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if(!(HAS_TRAIT(human_user, TRAIT_BLOOD_SENSE) || HAS_TRAIT(human_user, TRAIT_BLOOD_MAGE) || HAS_TRAIT(human_user, TRAIT_BLOOD_SORCERER)))
		to_chat(human_user, span_danger("I do not know what to do with this."))
		return

	var/confirm = tgui_alert(human_user, "Do you wish to consume this blood pearl?", "CONFIRM", DEFAULT_INPUT_CHOICES)
	if(confirm != CHOICE_YES)
		return

	if(!human_user.is_holding(src))
		return
	var/blood_to_draw = tgui_input_number(human_user, "How much vitae do you want to draw from the pearl?", "Draw Vitae", 0, vitae_amount)
	var/missing_vitae = human_user.maxbloodpool - human_user.bloodpool
	blood_to_draw = min(missing_vitae, blood_to_draw)
	if(!blood_to_draw || QDELETED(human_user) || QDELETED(src) || !human_user.is_holding(src))
		return
	to_chat(human_user, span_bloody("You draw [blood_to_draw] Vitae from the pearl."))
	new /obj/effect/decal/cleanable/blood/puddle(get_turf(human_user), stored_blood_color)
	human_user.adjust_bloodpool(blood_to_draw)
	vitae_amount -= blood_to_draw

	if(vitae_amount <= 0)
		shatter()

/obj/item/blood_pearl/proc/shatter(messy = FALSE)
	if(messy && vitae_amount > 10)
		visible_message(span_bloody("Blood pours as the pearl shatters..."), blind_message = span_info("I hear gushing liquid."))
		var/turf/target_turf = get_turf(src)
		if(istype(target_turf, /turf/open))
			target_turf.add_liquid(/datum/reagent/blood, floor(vitae_amount * 0.75))
	else
		visible_message(span_bloody("The pearl shatters..."), blind_message = span_info("I hear shattering glass."))
	playsound(src, 'sound/magic/crystal.ogg', 100, TRUE)
	qdel(src)
