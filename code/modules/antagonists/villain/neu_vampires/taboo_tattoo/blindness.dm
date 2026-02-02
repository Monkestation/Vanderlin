/datum/client_colour/psyker
	priority = INFINITY
	colour = list(0.8,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

/datum/taboo_tattoo/bloodsight
	name = "Restriction of Sight"
	desc = "You've given your eyes to see the world for what it truly is."
	tier = 1
	feature = /datum/bodypart_feature/bloodsight_brand

/datum/taboo_tattoo/bloodsight/apply_effects()
	if (!bearer)
		return

	bearer.AddComponent(/datum/component/echolocation, echo_group = "psyker", echo_icon = "psyker", color_path = /datum/client_colour/psyker)

/datum/taboo_tattoo/bloodsight/remove_effects()
	if (!bearer)
		return

	REMOVE_TRAIT(bearer, TRAIT_THERMAL_VISION, TABOO_TRAIT)
	qdel(bearer.GetComponent(/datum/component/echolocation))

/datum/bodypart_feature/bloodsight_brand
	name = "Bloodsight Brand"
	feature_slot = BODYPART_FEATURE_BRAND
	body_zone = BODY_ZONE_CHEST // Around the eyes
	accessory_colors = "#FF4500"
	accessory_type = /datum/sprite_accessory/brand/vampire_seal
