//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	max_integrity = 200
	integrity_failure = 0.9
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	pixel_y = 32

/obj/structure/mirror/fancy
	icon_state = "fancymirror"
	pixel_y = 32

/obj/structure/mirror/Initialize(mapload)
	. = ..()
	if(icon_state == "mirror_broke" && !broken)
		obj_break(null, TRUE, mapload)

/obj/structure/mirror/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(broken || !Adjacent(user))
		return

	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user


	var/list/options = list("hairstyle", "facial hairstyle", "hair color", "skin", "detail", "eye color")
	var/chosen = browser_input_list(user, "Change what?", "VANDERLIN", options)
	var/should_update
	switch(chosen)
		if("facial hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type

			var/new_style = browser_input_list(user, "Choose your facial hairstyle", "Hair Styling", valid_facial_hairstyles)
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						// Create a new facial hair entry with the SAME color as the current facial hair
						var/datum/customizer_entry/hair/facial/facial_entry = new()
						facial_entry.hair_color = current_facial.hair_color

						// Create the new facial hair with the new style but preserve color
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)

						// Apply all the color data from the entry
						facial_choice.customize_feature(new_facial, H, null, facial_entry)

						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						should_update = TRUE

		if("hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type

			var/new_style = browser_input_list(user, "Choose your hairstyle", "Hair Styling", valid_hairstyles)
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color

						if(istype(current_hair, /datum/bodypart_feature/hair/head))
							hair_entry.natural_gradient = current_hair.natural_gradient
							hair_entry.natural_color = current_hair.natural_color
							if(hasvar(current_hair, "hair_dye_gradient"))
								hair_entry.dye_gradient = current_hair.hair_dye_gradient
							if(hasvar(current_hair, "hair_dye_color"))
								hair_entry.dye_color = current_hair.hair_dye_color

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)

						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE
		if("hair color")
			var/new_hair
			var/list/hairs
			if(H.age == AGE_OLD && (OLDGREY in H.dna.species.species_traits))
				hairs = H.dna.species.get_oldhc_list()
				new_hair = browser_input_list(user, "Choose your character's hair color:", "", hairs)
			else
				hairs = H.dna.species.get_hairc_list()
				new_hair = browser_input_list(user, "Choose your character's hair color:", "", hairs)
			if(new_hair)
				H.set_hair_color(hairs[new_hair], FALSE)
				H.set_facial_hair_color(hairs[new_hair], FALSE)
				should_update = TRUE

		if("skin")
			var/listy = H.dna.species.get_skin_list()
			var/new_s_tone = browser_input_list(user, "Choose your character's skin tone:", "Sun", listy)
			if(new_s_tone)
				H.skin_tone = listy[new_s_tone]
				should_update = TRUE

		if("detail")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("none")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/detail/detail = new detail_type()
				valid_details[detail.name] = detail_type

			var/new_detail = browser_input_list(user, "Choose your face detail", "Face Detail", valid_details)
			if(new_detail)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing face detail if any
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break

					// Add new face detail if not "none"
					if(new_detail != "none")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[new_detail], H.get_hair_color(), H)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE

		if("eye color")
			var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
			var/new_eyes = input(user, "Choose your character's eye color:", "Character Preference",eyes.eye_color) as color|null
			if(new_eyes)
				eyes.eye_color = sanitize_hexcolor(new_eyes)
				should_update = TRUE

	if(should_update)
		H.update_body()
		H.update_body_parts()

/obj/structure/mirror/examine_status(mob/user)
	if(broken)
		return list()// no message spam
	return ..()

/obj/structure/mirror/obj_break(damage_flag, silent, mapload)
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		icon_state = "[icon_state]1"
		if(!mapload)
			new /obj/item/natural/glass/shard (get_turf(src))
		broken = TRUE
	..()

/obj/structure/mirror/deconstruct(disassembled = TRUE)
	..()

/obj/structure/mirror/welder_act(mob/living/user, obj/item/I)
	..()
	if(user.used_intent.type == INTENT_HARM)
		return FALSE

	if(!broken)
		return TRUE

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, "<span class='notice'>I begin repairing [src]...</span>")
	if(I.use_tool(src, user, 10, volume=50))
		to_chat(user, "<span class='notice'>I repair [src].</span>")
		broken = 0
		icon_state = initial(icon_state)
		desc = initial(desc)

	return TRUE
