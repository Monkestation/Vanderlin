/datum/attribute_modifier/ancestral_smithing
	id = "Ancestral Smithing"
	attribute_list = list(
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/craft/weaponsmithing = 15,
		/datum/attribute/skill/craft/armorsmithing = 15,
	)

/datum/action/cooldown/spell/essence/ancestral_smithing
	name = "Ancestral Smithing"
	desc = "Channels the spirits of ancient dwarven smiths to guide crafting."
	button_icon_state = "ancestral_smithing"
	cast_range = 0
	point_cost = 7
	attunements = list(/datum/attunement/fire, /datum/attunement/earth)
	essences = list(/datum/thaumaturgical_essence/earth, /datum/thaumaturgical_essence/fire)

/datum/action/cooldown/spell/essence/ancestral_smithing/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] calls upon the wisdom of ancient dwarven smiths."))
	var/mob/living/L = owner
	L.apply_status_effect(/datum/status_effect/buff/ancestral_smithing, 600 SECONDS)

/atom/movable/screen/alert/status_effect/ancestral_smithing
	name = "Ancestral Smithing"
	desc = "The spirits of ancient smiths guide your hands."
	icon_state = "buff"
/datum/status_effect/buff/ancestral_smithing
	id = "ancestral_smithing"
	alert_type = /atom/movable/screen/alert/status_effect/ancestral_smithing
	duration = 600 SECONDS

/datum/status_effect/buff/ancestral_smithing/on_apply()
	. = ..()
	owner.attributes?.add_attribute_modifier(/datum/attribute_modifier/ancestral_smithing)

/datum/status_effect/buff/ancestral_smithing/on_remove()
	. = ..()
	owner.attributes?.remove_attribute_modifier(/datum/attribute_modifier/ancestral_smithing)
