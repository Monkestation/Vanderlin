/datum/action/cooldown/spell/magicians_stone
	button_icon = 'icons/mob/actions/spells/mage_geomancy.dmi'
	name = "Magician's Stone"
	desc = "Tear several stones from the earth itself and materialize them at your feet."
	button_icon_state = "magicians_stone"
	sound = 'sound/items/stonestone.ogg'

	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_cost = 10

	invocation = "Emerge, Lapis."
	invocation_type = INVOCATION_SHOUT

	required_form = FORM_EARTH

	charge_required = FALSE
	cooldown_time = 2 MINUTES

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/stone_count_min = 3
	var/stone_count_max = 5

/datum/action/cooldown/spell/magicians_stone/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	var/count = rand(stone_count_min, stone_count_max)
	var/turf/T = user.drop_location()
	var/handed = FALSE

	for(var/i in 1 to count)
		var/obj/item/natural/stone/S = new /obj/item/natural/stone(T)
		if(!handed && user.put_in_hands(S))
			handed = TRUE

	playsound(user, 'sound/foley/stone_scrape.ogg', 50, TRUE)
	owner.visible_message(span_notice("[owner] clenches [owner.p_their()] fist and [count] stones tear themselves from the earth."), span_notice("I tear [count] stones from the earth itself."))

	return TRUE
