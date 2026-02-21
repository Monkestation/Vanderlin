/mob/living/carbon/human/MiddleClick(mob/user, list/modifiers)
	. = ..()
	if(!user)
		return
	var/obj/item/held_item = user.get_active_held_item()
	if(user.cmode)
		if(held_item && (user.zone_selected == BODY_ZONE_PRECISE_NECK))
			if(held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
				playsound(src, 'sound/surgery/scalpel1.ogg', 100, TRUE, -1)
				if(user == src)
					user.visible_message("<span class='danger'>[user] starts to slit [user.p_their()] throat with [held_item].</span>")
				else
					user.visible_message("<span class='danger'>[user] starts to slit [src]'s throat with [held_item].</span>")
				if(do_after(user, 5 SECONDS, src))
					var/obj/item/bodypart/part = src.get_bodypart(BODY_ZONE_PRECISE_NECK)
					part.add_wound(/datum/wound/artery/neck)

	else if(held_item && (user.zone_selected == BODY_ZONE_PRECISE_SKULL))
		if(held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
			playsound(src, 'sound/foley/shaving.ogg', 100, TRUE, -1)
			if(user == src)
				user.visible_message(span_danger("[user] starts to shave [user.p_their()] hair with [held_item].</span>"))
			else
				user.visible_message(span_danger("[user] starts to shave [src]'s hair with [held_item].</span>"))
			if(do_after(user, 10 SECONDS, src))
				set_hair_style(/datum/sprite_accessory/hair/head/bald)
				update_body()

		if(held_item && (user.zone_selected == BODY_ZONE_PRECISE_MOUTH))
			if(held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT)
				var/datum/bodypart_feature/hair/facial = get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
				if(has_stubble)
					playsound(src, 'sound/foley/shaving.ogg', 100, TRUE, -1)
					if(user == src)
						user.visible_message("<span class='danger'>[user] starts to shave [user.p_their()] stubble with [held_item].</span>")
					else
						user.visible_message("<span class='danger'>[user] starts to shave [src]'s stubble with [held_item].</span>")
					if(do_after(user, 5 SECONDS, src))
						has_stubble = FALSE
						update_body()
					else
						held_item.melee_attack_chain(user, src, modifiers)
				else if(facial?.accessory_type != /datum/sprite_accessory/hair/facial/none)
					playsound(src, 'sound/foley/shaving.ogg', 100, TRUE, -1)
					if(user == src)
						user.visible_message("<span class='danger'>[user] starts to shave [user.p_their()] facehairs with [held_item].</span>")
					else
						user.visible_message("<span class='danger'>[user] starts to shave [src]'s facehairs with [held_item].</span>")
					if(do_after(user, 5 SECONDS, src))
						set_facial_hair_style(/datum/sprite_accessory/hair/facial/none)
						update_body()
						record_round_statistic(STATS_BEARDS_SHAVED)
						if(dna?.species)
							if(dna.species.id == SPEC_ID_DWARF)
								var/mob/living/carbon/V = src
								V.add_stress(/datum/stress_event/dwarfshaved)
					else
						held_item.melee_attack_chain(user, src, modifiers)
		else if(held_item && (user.zone_selected == BODY_ZONE_PRECISE_R_FOOT || user.zone_selected == BODY_ZONE_PRECISE_L_FOOT))
			var/obj/item/clothing/shoes/shoes_check
			var/mob/living/carbon/target
			if(user == src)
				return
			else if(iscarbon(src))
				target = src
				shoes_check = locate(/obj/item/clothing/shoes) in list(target.shoes)
			if(shoes_check)
				if(istype(held_item, /obj/item/natural/cloth) && user?.used_intent?.type == INTENT_USE && shoes_check.polished == 0)
					var/obj/item/natural/cloth/cloth_check = held_item
					if(cloth_check.reagents.total_volume < 0.1)
						to_chat(user, span_warning("[cloth_check] is too dry to polish with!"))
						return
					var/DirtyWater = cloth_check.reagents.get_reagent_amount(/datum/reagent/water/gross)
					if(DirtyWater)
						to_chat(user, span_warning("[cloth_check] water is too dirty to polish anything with it!"))
						return
					to_chat(user, ("You start polishing the [shoes_check] with the [cloth_check]"))
					user.visible_message(span_notice("[user] starts to polish the [shoes_check] of [src]."))
					if(do_after(user, 2 SECONDS, src))
						cloth_check.reagents.remove_all(1)
						shoes_check.polished = 1
						shoes_check.AddComponent(/datum/component/particle_spewer/sparkle)
						addtimer(CALLBACK(shoes_check, TYPE_PROC_REF(/obj/item/clothing/shoes, lose_shine)), 15 MINUTES)
						if(HAS_TRAIT(user, TRAIT_NOBLE))
							user.add_stress(/datum/stress_event/noble_polishing_shoe)
						target.add_stress(/datum/stress_event/shiny_shoes)
						to_chat(user, ("You polished the [shoes_check]."))
					return
				else if(istype(held_item, /obj/item/natural/cloth) && user?.used_intent?.type == INTENT_USE && shoes_check.polished == 1)
					to_chat(user, span_notice("The [shoes_check] are already polished."))
					return
				if(istype(held_item, /obj/item/reagent_containers/food/snacks/fat) && user?.used_intent?.type == INTENT_USE && shoes_check.polished == 1)
					to_chat(user, ("You start polishing the [shoes_check] with the animal"))
					user.visible_message(span_notice("[user] starts to polish the [shoes_check] of [src]."))
					if(do_after(user, 2 SECONDS, src))
						shoes_check.polished = 2
						if(HAS_TRAIT(user, TRAIT_NOBLE))
							user.add_stress(/datum/stress_event/noble_polishing_shoe)
						var/datum/component/particle_spewer = shoes_check.GetComponent(/datum/component/particle_spewer/sparkle)
						if(particle_spewer)
							qdel(particle_spewer)
						shoes_check.AddComponent(/datum/component/particle_spewer/sparkle, shine_more = TRUE)
						addtimer(CALLBACK(shoes_check, TYPE_PROC_REF(/obj/item/clothing/shoes, lose_shine)), 15 MINUTES)
						target.add_stress(/datum/stress_event/extra_shiny_shoes)
						to_chat(user, ("You polished the [shoes_check]."))
					return
				if(istype(held_item, /obj/item/reagent_containers/food/snacks/fat) && user?.used_intent?.type == INTENT_USE && shoes_check.polished == 2)
					to_chat(user, ("You can't possibily make it shine more."))

/mob/living/carbon/human/Initialize()
	add_verb(src, /mob/living/proc/lay_down)

	//initialize limbs first
	create_bodyparts()

	setup_human_dna()

	if(dna.species)
		set_species(dna.species.type)

	//initialise organs
	create_internal_organs() //most of it is done in set_species now, this is only for parent call
	physiology = new()
	culture = new()

	. = ..()

	AddElement(/datum/element/footstep, footstep_type, 1, -6)
	GLOB.human_list += src
	if(ai_controller && flee_in_pain)
		AddElement(/datum/element/ai_flee_while_in_pain)

/mob/living/carbon/human/Destroy()
	QDEL_NULL(physiology)
	QDEL_NULL(culture)
	GLOB.human_list -= src
	return ..()

/mob/living/carbon/human/ZImpactDamage(turf/T, levels)
	var/mob/living/carbon/V = src
	var/obj/item/bodypart/affecting
	var/dam = levels * rand(10,50)
	V.add_stress(/datum/stress_event/felldown)
	record_round_statistic(STATS_MOAT_FALLERS, -1) // If you get your ankles broken you fall. This makes sure only those that DIDN'T get damage get counted.
	record_round_statistic(STATS_ANKLES_BROKEN)
	var/chat_message
	switch(rand(1,4))
		if(1)
			affecting = get_bodypart(pick(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
			chat_message = "<span class='danger'>I fall on my [affecting]!</span>"
		if(2)
			affecting = get_bodypart(pick(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM))
			chat_message = "<span class='danger'>I fall on my arm!</span>"
		if(3)
			affecting = get_bodypart(BODY_ZONE_CHEST)
			chat_message = "<span class='danger'>I fall flat! I'm winded!</span>"
			emote("gasp")
			adjustOxyLoss(50)
		if(4)
			affecting = get_bodypart(BODY_ZONE_HEAD)
			chat_message = "<span class='danger'>I fall on my head!</span>"
	if(affecting && apply_damage(dam, BRUTE, affecting, run_armor_check(affecting, "blunt", damage = dam)))
		update_damage_overlays()
		if(levels >= 1)
			//absurd damage to guarantee a crit
			affecting.try_crit(BCLASS_TWIST, 300)

	for(var/mob/living/M in T.contents)
		visible_message("\The [src] hits \the [T]!")
		M.AdjustKnockdown(levels * 20)
		M.take_overall_damage(dam * 3.5)

	if(chat_message)
		to_chat(src, chat_message)

	AdjustKnockdown(levels * 15)

/mob/living/carbon/human/proc/setup_human_dna()
	//initialize dna. for spawned humans; overwritten by other code
	create_dna(src)
	randomize_human(src)
	dna.initialize_dna()
	reset_limb_fingerprints()

/mob/living/carbon/human/get_status_tab_items()
	. = ..()
	if(clan)
		. += "VITAE: [bloodpool]"

/mob/living/carbon/human/show_inv(mob/user)
	user.set_machine(src)
	var/obscured = check_obscured_slots()
	var/list/dat = list()

	dat += "<table>"

	if(handcuffed)
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HANDCUFFED]'>Remove [handcuffed]</A></td></tr>"
	if(legcuffed)
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_LEGCUFFED]'>Remove [legcuffed]</A></td></tr>"

	dat += "<tr><td><hr></td></tr>"

	for(var/i in 1 to held_items.len)
		var/obj/item/I = get_item_for_held_index(i)
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HANDS];hand_index=[i]'>[(I && !(I.item_flags & ABSTRACT)) ? I : "<font color=grey>[get_held_index_name(i)]</font>"]</a></td></tr>"

	dat += "<tr><td><hr></td></tr>"

	//head
	if(obscured & ITEM_SLOT_HEAD)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_HEAD]'>[(head && !(head.item_flags & ABSTRACT)) ? head : "<font color=grey>Head</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_MASK)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_MASK]'>[(wear_mask && !(wear_mask.item_flags & ABSTRACT)) ? wear_mask : "<font color=grey>Mask</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_MOUTH)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_MOUTH]'>[(mouth && !(mouth.item_flags & ABSTRACT)) ? mouth : "<font color=grey>Mouth</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_NECK)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_NECK]'>[(wear_neck && !(wear_neck.item_flags & ABSTRACT)) ? wear_neck : "<font color=grey>Neck</font>"]</A></td></tr>"

	dat += "<tr><td><hr></td></tr>"

//	dat += "<tr><td><B>BACK</B></td></tr>"

	if(obscured & ITEM_SLOT_CLOAK)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_CLOAK]'>[(cloak && !(cloak.item_flags & ABSTRACT)) ? cloak : "<font color=grey>Cloak</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_BACK_R)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_BACK_R]'>[(backr && !(backr.item_flags & ABSTRACT)) ? backr : "<font color=grey>Back</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_BACK_L)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_BACK_L]'>[(backl && !(backl.item_flags & ABSTRACT)) ? backl : "<font color=grey>Back</font>"]</A></td></tr>"

	dat += "<tr><td><hr></td></tr>"

//	dat += "<tr><td><B>TORSO</B></td></tr>"

	if(obscured & ITEM_SLOT_ARMOR)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_ARMOR]'>[(wear_armor && !(wear_armor.item_flags & ABSTRACT)) ? wear_armor : "<font color=grey>Armor</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_SHIRT)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_SHIRT]'>[(wear_shirt && !(wear_shirt.item_flags & ABSTRACT)) ? wear_shirt : "<font color=grey>Shirt</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_GLOVES)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_GLOVES]'>[(gloves && !(gloves.item_flags & ABSTRACT)) ? gloves : "<font color=grey>Gloves</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_RING)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_RING]'>[(wear_ring && !(wear_ring.item_flags & ABSTRACT)) ? wear_ring : "<font color=grey>Ring</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_WRISTS)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_WRISTS]'>[(wear_wrists && !(wear_wrists.item_flags & ABSTRACT)) ? wear_wrists : "<font color=grey>Wrists</font>"]</A></td></tr>"

	dat += "<tr><td><hr></td></tr>"

//	dat += "<tr><td><B>WAIST</B></td></tr>"

	if(obscured & ITEM_SLOT_BELT)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_BELT]'>[(belt && !(belt.item_flags & ABSTRACT)) ? belt : "<font color=grey>Belt</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_BELT_R)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_BELT_R]'>[(beltr && !(beltr.item_flags & ABSTRACT)) ? beltr : "<font color=grey>Hip</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_BELT_L)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_BELT_L]'>[(beltl && !(beltl.item_flags & ABSTRACT)) ? beltl : "<font color=grey>Hip</font>"]</A></td></tr>"

	dat += "<tr><td><hr></td></tr>"

//	dat += "<tr><td><B>LEGS</B></td></tr>"

	if(obscured  & ITEM_SLOT_PANTS)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_PANTS]'>[(wear_pants && !(wear_pants.item_flags & ABSTRACT)) ? wear_pants : "<font color=grey>Trousers</font>"]</A></td></tr>"

	if(obscured & ITEM_SLOT_SHOES)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='byond://?src=[REF(src)];item=[ITEM_SLOT_SHOES]'>[(shoes && !(shoes.item_flags & ABSTRACT)) ? shoes : "<font color=grey>Boots</font>"]</A></td></tr>"

	dat += "<tr><td><hr></td></tr>"

	dat += {"</table>"}

	var/datum/browser/popup = new(user, "mob[REF(src)]", "[src]", 220, 690)
	popup.set_content(dat.Join())
	popup.open()

// called when something steps onto a human
// this could be made more general, but for now just handle mulebot
/mob/living/carbon/human/Crossed(atom/movable/AM)
	. = ..()
	spreadFire(AM)

/mob/living/carbon/human/proc/canUseHUD()
	return (mobility_flags & MOBILITY_USE)

/mob/living/carbon/human/can_inject(mob/user, error_msg, target_zone, penetrate_thick = 0)
	. = 1 // Default to returning true.
	if(user && !target_zone)
		target_zone = user.zone_selected
	if(HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
		. = 0
	// If targeting the head, see if the head item is thin enough.
	// If targeting anything else, see if the wear suit is thin enough.
	if (!penetrate_thick)
		if(above_neck(target_zone))
			if(head && istype(head, /obj/item/clothing))
				var/obj/item/clothing/CH = head
				if (CH.clothing_flags & THICKMATERIAL)
					. = 0
		else
			if(wear_armor && istype(wear_armor, /obj/item/clothing))
				var/obj/item/clothing/CS = wear_armor
				if (CS.clothing_flags & THICKMATERIAL)
					. = 0
	if(!. && error_msg && user)
		// Might need re-wording.
		to_chat(user, "<span class='alert'>There is no exposed flesh or thin material [above_neck(target_zone) ? "on [p_their()] head" : "on [p_their()] body"].</span>")

/mob/living/carbon/human/proc/do_cpr(mob/living/carbon/C)
	CHECK_DNA_AND_SPECIES(C)

	if(C.stat == DEAD || (HAS_TRAIT(C, TRAIT_FAKEDEATH)))
		to_chat(src, "<span class='warning'>[C.name] is dead!</span>")
		return
	if(is_mouth_covered())
		to_chat(src, "<span class='warning'>Remove your mask first!</span>")
		return 0
	if(C.is_mouth_covered())
		to_chat(src, "<span class='warning'>Remove [p_their()] mask first!</span>")
		return 0

	if(C.cpr_time < world.time + 30)
		visible_message("<span class='notice'>[src] is trying to perform CPR on [C.name]!</span>", \
						"<span class='notice'>I try to perform CPR on [C.name]... Hold still!</span>")
		if(!do_after(src, 3 SECONDS, C))
			to_chat(src, "<span class='warning'>I fail to perform CPR on [C]!</span>")
			return 0

		var/they_breathe = !HAS_TRAIT(C, TRAIT_NOBREATH)
		var/they_lung = C.getorganslot(ORGAN_SLOT_LUNGS)

		if(C.health > C.crit_threshold)
			return

		src.visible_message("<span class='notice'>[src] performs CPR on [C.name]!</span>", "<span class='notice'>I perform CPR on [C.name].</span>")
		add_stress(/datum/stress_event/perform_cpr)
		C.cpr_time = world.time
		log_combat(src, C, "CPRed")

		if(they_breathe && they_lung)
			var/suff = min(C.getOxyLoss(), 7)
			C.adjustOxyLoss(-suff)
			C.updatehealth()
			to_chat(C, "<span class='unconscious'>I feel a breath of fresh air enter your lungs... It feels good...</span>")
		else if(they_breathe && !they_lung)
			to_chat(C, "<span class='unconscious'>I feel a breath of fresh air... but you don't feel any better...</span>")
		else
			to_chat(C, "<span class='unconscious'>I feel a breath of fresh air... which is a sensation you don't recognise...</span>")

/mob/living/carbon/human/cuff_resist(obj/item/I)
	if(..())
		dropItemToGround(I)

//Turns a mob black, flashes a skeleton overlay
//Just like a cartoon!
/mob/living/carbon/human/proc/electrocution_animation(anim_duration)
	//Handle mutant parts if possible
	if(dna && dna.species)
		add_atom_colour("#000000", TEMPORARY_COLOUR_PRIORITY)
		var/static/mutable_appearance/electrocution_skeleton_anim
		if(!electrocution_skeleton_anim)
			electrocution_skeleton_anim = mutable_appearance(icon, "electrocuted_base")
			electrocution_skeleton_anim.appearance_flags |= RESET_COLOR|KEEP_APART
		add_overlay(electrocution_skeleton_anim)
		addtimer(CALLBACK(src, PROC_REF(end_electrocution_animation), electrocution_skeleton_anim), anim_duration)

	else //or just do a generic animation
		flick_overlay_view(image(icon,src,"electrocuted_generic",ABOVE_MOB_LAYER), src, anim_duration)

/mob/living/carbon/human/proc/end_electrocution_animation(mutable_appearance/MA)
	remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#000000")
	cut_overlay(MA)

/mob/living/carbon/human/resist_restraints()
	if(wear_armor && wear_armor.breakouttime)
		changeNext_move(CLICK_CD_BREAKOUT)
		last_special = world.time + CLICK_CD_BREAKOUT
		cuff_resist(wear_armor)
	else
		..()

/mob/living/carbon/human/replace_records_name(oldname,newname) // Only humans have records right now, move this up if changed.
	for(var/list/L in list(GLOB.data_core.general,GLOB.data_core.medical,GLOB.data_core.security,GLOB.data_core.locked))
		var/datum/data/record/R = find_record("name", oldname, L)
		if(R)
			R.fields["name"] = newname

/mob/living/carbon/human/update_tod_hud()
	if(!client || !hud_used)
		return
	if(hud_used.clock)
		hud_used.clock.update_appearance()

/mob/living/carbon/human/update_health_hud(stamina_only = FALSE)
	if(!client || !hud_used)
		return
	if(dna?.species?.update_health_hud())
		return
	else
		if(hud_used.bloods)
			var/bloodloss = ((BLOOD_VOLUME_NORMAL - blood_volume) / BLOOD_VOLUME_NORMAL) * 100

			var/toxloss = getToxLoss()
			var/oxyloss = getOxyLoss()
			var/painpercent = (get_complex_pain() / (STAEND * 12)) * 100


			var/usedloss = 0
			if(bloodloss > 0)
				usedloss = bloodloss

			hud_used.bloods.cut_overlays()
			if(usedloss <= 0)
				hud_used.bloods.icon_state = "dam0"
				if(toxloss > 0)
					var/toxoverlay
					switch(toxloss)
						if(1 to 20)
							toxoverlay = "toxloss20"
						if(21 to 49)
							toxoverlay = "toxloss40"
						if(50 to 79)
							toxoverlay = "toxloss60"
						if(80 to 99)
							toxoverlay = "toxloss80"
						if(100 to 999)
							toxoverlay = "toxloss100"
					hud_used.bloods.add_overlay(toxoverlay)

				if(oxyloss > 0)
					var/oxyoverlay
					switch(oxyloss)
						if(1 to 20)
							oxyoverlay = "oxyloss20"
						if(21 to 49)
							oxyoverlay = "oxyloss40"
						if(50 to 79)
							oxyoverlay = "oxyloss60"
						if(80 to 99)
							oxyoverlay = "oxyloss80"
						if(100 to 999)
							oxyoverlay = "oxyloss100"
					hud_used.bloods.add_overlay(oxyoverlay)
			else
				var/used = round(usedloss, 10)
				if(used <= 80)
					hud_used.bloods.icon_state = "dam[used]"
				else
					hud_used.bloods.icon_state = "damelse"
			if(painpercent > 0)
				var/painoverlay
				switch(painpercent)
					if(1 to 29)
						painoverlay = "painloss20"
					if(30 to 59)
						painoverlay = "painloss40"
					if(60 to 79)
						painoverlay = "painloss60"
					if(80 to 99)
						painoverlay = "painloss80"
					if(100 to 999)
						painoverlay = "painloss100"
				hud_used.bloods.add_overlay(painoverlay)
			SEND_SIGNAL(src, COMSIG_MOB_HEALTHHUD_UPDATE, hud_used.bloods.icon_state)

		if(hud_used.stamina)
			if(stat != DEAD)
				. = 1
				if(stamina >= maximum_stamina)
					hud_used.stamina.icon_state = "fat0"
				else if(stamina > maximum_stamina*0.90)
					hud_used.stamina.icon_state = "fat10"
				else if(stamina > maximum_stamina*0.80)
					hud_used.stamina.icon_state = "fat20"
				else if(stamina > maximum_stamina*0.70)
					hud_used.stamina.icon_state = "fat30"
				else if(stamina > maximum_stamina*0.60)
					hud_used.stamina.icon_state = "fat40"
				else if(stamina > maximum_stamina*0.50)
					hud_used.stamina.icon_state = "fat50"
				else if(stamina > maximum_stamina*0.40)
					hud_used.stamina.icon_state = "fat60"
				else if(stamina > maximum_stamina*0.30)
					hud_used.stamina.icon_state = "fat70"
				else if(stamina > maximum_stamina*0.20)
					hud_used.stamina.icon_state = "fat80"
				else if(stamina > maximum_stamina*0.10)
					hud_used.stamina.icon_state = "fat90"
				else if(stamina >= 0)
					hud_used.stamina.icon_state = "fat100"

		if(hud_used.energy)
			if(stat != DEAD)
				. = 1
				if(energy <= 0)
					hud_used.energy.icon_state = "stam0"
				else if(energy > max_energy*0.90)
					hud_used.energy.icon_state = "stam100"
				else if(energy > max_energy*0.80)
					hud_used.energy.icon_state = "stam90"
				else if(energy > max_energy*0.70)
					hud_used.energy.icon_state = "stam80"
				else if(energy > max_energy*0.60)
					hud_used.energy.icon_state = "stam70"
				else if(energy > max_energy*0.50)
					hud_used.energy.icon_state = "stam60"
				else if(energy > max_energy*0.40)
					hud_used.energy.icon_state = "stam50"
				else if(energy > max_energy*0.30)
					hud_used.energy.icon_state = "stam40"
				else if(energy > max_energy*0.20)
					hud_used.energy.icon_state = "stam30"
				else if(energy > max_energy*0.10)
					hud_used.energy.icon_state = "stam20"
				else if(energy > 0)
					hud_used.energy.icon_state = "stam10"

	if(hud_used.zone_select && !stamina_only)
		hud_used.zone_select.update_appearance(UPDATE_OVERLAYS)

/mob/living/carbon/human/fully_heal(heal_flags = HEAL_ALL)
	// set_heartattack(FALSE)
	if(heal_flags & HEAL_ESSENTIALS)
		set_hygiene(HYGIENE_LEVEL_NORMAL)
	return ..()

/mob/living/carbon/human/check_weakness(obj/item/weapon, mob/living/attacker)
	. = ..()
	if (dna && dna.species)
		. += dna.species.check_species_weakness(weapon, attacker, src)

/mob/living/carbon/human/is_literate()
	if(mind)
		if(get_skill_level(/datum/skill/misc/reading) > 0)
			return TRUE
		else
			return FALSE
	return TRUE

/mob/living/carbon/human/can_hold_items()
	return TRUE

/mob/living/carbon/human/vomit(lost_nutrition = 10, blood = 0, stun = 1, distance = 0, message = 1, toxic = 0)
	if(blood && (NOBLOOD in dna.species.species_traits) && !HAS_TRAIT(src, TRAIT_TOXINLOVER))
		if(message)
			visible_message("<span class='warning'>[src] dry heaves!</span>", \
							"<span class='danger'>I try to throw up, but there's nothing in your stomach!</span>")
		if(stun)
			Immobilize(200)
		return 1
	..()

/mob/living/carbon/human/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_COPY_OUTFIT, "Copy Outfit")
	VV_DROPDOWN_OPTION(VV_HK_SET_SPECIES, "Set Species")
	VV_DROPDOWN_OPTION(VV_HK_CORONATE, "Coronate")
	VV_DROPDOWN_OPTION(VV_HK_CHANGE_TITLE, "Change Title")

/mob/living/carbon/human/vv_do_topic(list/href_list)
	. = ..()
	if(href_list[VV_HK_COPY_OUTFIT])
		if(!check_rights(R_SPAWN))
			return
		copy_outfit()
	if(href_list[VV_HK_SET_SPECIES])
		if(!check_rights(R_SPAWN))
			return
		var/result = input(usr, "Please choose a new species","Species") as null|anything in GLOB.species_list
		if(result)
			var/newtype = GLOB.species_list[result]
			admin_ticket_log("[key_name_admin(usr)] has modified the bodyparts of [src] to [result]")
			set_species(newtype)
	if(href_list[VV_HK_CORONATE])
		if(!src.mind)
			return
		if(is_lord_job(mind.assigned_role))
			return

		var/appointment_type = browser_alert(usr, "Are you sure you want to coronate [src.real_name] as the new Monarch?", "Confirmation", DEFAULT_INPUT_CHOICES)
		if(appointment_type == CHOICE_NO)
			return

		var/mob/living/carbon/coronated
		coronated = src

		var/datum/job/lord_job = SSjob.GetJobType(/datum/job/lord)
		var/datum/job/consort_job = SSjob.GetJobType(/datum/job/consort)
		for(var/mob/living/carbon/human/HL in GLOB.human_list)
			//this sucks ass. refactor to locate the current ruler/consort
			if(HL.mind)
				if(is_lord_job(HL.mind.assigned_role) || is_consort_job(HL.mind.assigned_role))
					HL.mind.set_assigned_role(SSjob.GetJobType(/datum/job/villager))
			//would be better to change their title directly, but that's not possible since the title comes from the job datum
			if(HL.job == "Monarch")
				HL.job = "Ex-Monarch"
				lord_job?.remove_spells(HL)
			if(HL.job == "Consort")
				HL.job = "Ex-Consort"
				consort_job?.remove_spells(HL)

		var/new_title = (coronated.gender == MALE) ? SSmapping.config.monarch_title : SSmapping.config.monarch_title_f
		coronated.mind.set_assigned_role(/datum/job/lord)
		lord_job?.get_informed_title(coronated, FALSE, TRUE, new_title)
		coronated.job = "Monarch" //Monarch is used when checking if the ruler is alive, not "King" or "Queen". Can also pass it on and have the title change properly later.
		lord_job?.add_spells(coronated)
		SSticker.rulermob = coronated
		GLOB.badomens -= OMEN_NOLORD
		priority_announce("The Ten have named [coronated.real_name] the inheritor of [SSmapping.config.map_name]!", \
		title = "Long Live [lord_job.get_informed_title(coronated)] [coronated.real_name]!", sound = 'sound/misc/bell.ogg')
	if(href_list[VV_HK_CHANGE_TITLE])
		if(!mind?.assigned_role)
			return
		var/datum/job/human_job = mind.assigned_role
		var/new_title = browser_input_text(usr, "What new title would you like to assign?", "Title Change")
		if(!new_title)
			return
		admin_title = new_title
		if(is_lord_job(human_job))
			var/datum/job/lord_job = SSjob.GetJobType(/datum/job/lord)
			lord_job?.get_informed_title(src, TRUE, new_title)

/mob/living/carbon/human/MouseDrop_T(mob/living/target, mob/living/user)
	if(pulling == target && stat == CONSCIOUS)
		//If they dragged themselves and we're currently aggressively grabbing them try to piggyback
		if(user == target && can_piggyback(target))
			if(cmode)
				to_chat(target, span_warning("[src] is too alert to let you piggyback!"))
				return FALSE
			piggyback(target)
			return TRUE
		//If you dragged them to you and you're aggressively grabbing try to carry them
		else if(user != target && can_be_firemanned(target))
			var/obj/G = get_active_held_item()
			if(G)
				if(istype(G, /obj/item/grabbing))
					fireman_carry(target)
					return TRUE
	. = ..()

/mob/proc/return_accent_list()
	if(!accent)
		return
	if(accent == ACCENT_NONE)
		return
	return GLOB.accent_list[accent]

//src is the user that will be carrying, target is the mob to be carried
/mob/living/carbon/human/proc/can_piggyback(mob/living/carbon/target)
	return (istype(target) && target.stat == CONSCIOUS)

/mob/living/carbon/human/proc/can_be_firemanned(mob/living/carbon/target)
	return (ishuman(target) && target.body_position == LYING_DOWN)

/mob/living/carbon/human/proc/fireman_carry(mob/living/carbon/target)
	var/carrydelay = 5 SECONDS //if you have latex you are faster at grabbing

	var/backnotshoulder = FALSE
	if(r_grab && l_grab)
		if(r_grab.grabbed == target)
			if(l_grab.grabbed == target)
				backnotshoulder = TRUE

	if(can_be_firemanned(target) && !incapacitated(IGNORE_GRAB))
		if(backnotshoulder)
			visible_message("<span class='notice'>[src] starts lifting [target] onto their back...</span>")
		else
			visible_message("<span class='notice'>[src] starts lifting [target] onto their shoulder...</span>")
		if(do_after(src, carrydelay, target))
			//Second check to make sure they're still valid to be carried
			if(can_be_firemanned(target) && !incapacitated(IGNORE_GRAB))
				buckle_mob(target, TRUE, TRUE, 90, 0, 0)
				return
	to_chat(src, "<span class='warning'>I fail to carry [target].</span>")

/mob/living/carbon/human/proc/piggyback(mob/living/carbon/target)
	if(can_piggyback(target))
		visible_message("<span class='notice'>[target] starts to climb onto [src]...</span>")
		if(do_after(target, 1.5 SECONDS, src))
			if(can_piggyback(target))
				if(target.incapacitated(IGNORE_GRAB) || incapacitated(IGNORE_GRAB))
					to_chat(target, "<span class='warning'>I can't piggyback ride [src].</span>")
					return
				buckle_mob(target, TRUE, TRUE, FALSE, 0, 0)
	else
		to_chat(target, "<span class='warning'>I can't piggyback ride [src].</span>")

/mob/living/carbon/human/buckle_mob(mob/living/target, force = FALSE, check_loc = TRUE, lying_buckle = FALSE, hands_needed = 0, target_hands_needed = 0)
	if(!force)//humans are only meant to be ridden through piggybacking and special cases
		return
	if(!is_type_in_typecache(target, can_ride_typecache))
		target.visible_message("<span class='warning'>[target] really can't seem to mount [src]...</span>")
		return
	buckle_lying = lying_buckle
	var/datum/component/riding/human/riding_datum = LoadComponent(/datum/component/riding/human)
	if(target_hands_needed)
		riding_datum.ride_check_rider_restrained = TRUE
	if(buckled_mobs && ((target in buckled_mobs) || (buckled_mobs.len >= max_buckled_mobs)) || buckled)
		return
	var/equipped_hands_self
	var/equipped_hands_target
	if(hands_needed)
		equipped_hands_self = riding_datum.equip_buckle_inhands(src, hands_needed, target)
	if(target_hands_needed)
		equipped_hands_target = riding_datum.equip_buckle_inhands(target, target_hands_needed)

	if(hands_needed || target_hands_needed)
		if(hands_needed && !equipped_hands_self)
			src.visible_message("<span class='warning'>[src] can't get a grip on [target] because their hands are full!</span>",
				"<span class='warning'>I can't get a grip on [target] because your hands are full!</span>")
			return
		else if(target_hands_needed && !equipped_hands_target)
			target.visible_message("<span class='warning'>[target] can't get a grip on [src] because their hands are full!</span>",
				"<span class='warning'>I can't get a grip on [src] because your hands are full!</span>")
			return

	//stop_pulling()
	riding_datum.handle_vehicle_layer()
	. = ..(target, force, check_loc)

/mob/living/carbon/human/proc/is_shove_knockdown_blocked() //If you want to add more things that block shove knockdown, extend this
	var/list/body_parts = list(head, wear_mask, wear_armor, wear_pants, backl, backr, gloves, shoes, belt, wear_ring)
	for(var/bp in body_parts)
		if(istype(bp, /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.clothing_flags & BLOCKS_SHOVE_KNOCKDOWN)
				return TRUE
	return FALSE

/mob/living/carbon/human/proc/clear_shove_slowdown()
	remove_movespeed_modifier(MOVESPEED_ID_SHOVE)
	var/active_item = get_active_held_item()
	if(is_type_in_typecache(active_item, GLOB.shove_disarming_types))
		visible_message("<span class='warning'>[src.name] regains their grip on \the [active_item]!</span>", "<span class='warning'>I regain your grip on \the [active_item]</span>", null, COMBAT_MESSAGE_RANGE)

/mob/living/carbon/human/do_after_coefficent()
	. = ..()
	. *= physiology?.do_after_speed

/mob/living/carbon/human/updatehealth(amount)
	. = ..()
	dna?.species.spec_updatehealth(src)
	if(HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)
		remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN_FLYING)
		return
	var/health_deficiency = max((maxHealth - health), 0)
	if(health_deficiency >= 80)
		add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, override = TRUE, multiplicative_slowdown = (health_deficiency / 75), blacklisted_movetypes = FLOATING|FLYING)
		add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN_FLYING, override = TRUE, multiplicative_slowdown = (health_deficiency / 25), movetypes = FLOATING)
	else
		remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)
		remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN_FLYING)

/mob/living/carbon/human/proc/skele_look()
	dna.species.go_bald()
	update_body_parts(redraw = TRUE)
	underwear = "Nude"

/mob/living/carbon/human/adjust_nutrition(change) //Honestly FUCK the oldcoders for putting nutrition on /mob someone else can move it up because holy hell I'd have to fix SO many typechecks
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		return FALSE
	return ..()

/mob/living/carbon/human/set_nutrition(change) //Seriously fuck you oldcoders.
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		return FALSE
	return ..()

/mob/living/carbon/human/adjust_hydration(change)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		return FALSE
	return ..()

/mob/living/carbon/human/set_hydration(change)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER))
		return FALSE
	return ..()

/// copies the physical cosmetic features of another human mob.
/mob/living/carbon/human/proc/copy_physical_features(mob/living/carbon/human/target)
	if(!istype(target))
		return

	icon = target.icon

	copy_bodyparts(target)

	target.dna.transfer_identity(src)
	reset_limb_fingerprints()

	updateappearance(mutcolor_update = TRUE)

	job = target.job // NOT assigned_role
	faction = target.faction
	deathsound = target.deathsound
	gender = target.gender
	real_name = target.real_name
	voice_color = target.voice_color
	voice_pitch = target.voice_pitch
	detail_color = target.detail_color
	skin_tone = target.skin_tone
	lip_style = target.lip_style
	lip_color = target.lip_color
	age = target.age
	underwear = target.underwear
	underwear_color = target.underwear_color
	undershirt = target.undershirt
	shavelevel = target.shavelevel
	socks = target.socks
	spouse_mob = target.spouse_mob
	spouse_indicator = target.spouse_indicator
	has_stubble = target.has_stubble
	headshot_link = target.headshot_link
	flavortext = target.flavortext
	set_bloodpool(target.bloodpool)

	var/obj/item/bodypart/head/target_head = target.get_bodypart(BODY_ZONE_HEAD)
	if(!isnull(target_head))
		var/obj/item/bodypart/head/user_head = get_bodypart(BODY_ZONE_HEAD)
		user_head.bodypart_features = target_head.bodypart_features

	if(HAS_TRAIT(target, TRAIT_FOREIGNER))
		ADD_TRAIT(src, TRAIT_FOREIGNER, TRAIT_GENERIC)
	else
		REMOVE_TRAIT(src, TRAIT_FOREIGNER, TRAIT_GENERIC)

	if(HAS_TRAIT(target, TRAIT_RECOGNIZED))
		ADD_TRAIT(src, TRAIT_RECOGNIZED, TRAIT_GENERIC)
	else
		REMOVE_TRAIT(src, TRAIT_RECOGNIZED, TRAIT_GENERIC)

	if(HAS_TRAIT(target, TRAIT_RECRUITED))
		ADD_TRAIT(src, TRAIT_RECRUITED, TRAIT_GENERIC)
	else
		REMOVE_TRAIT(src, TRAIT_RECRUITED, TRAIT_GENERIC)

	if(HAS_TRAIT(target, TRAIT_FACELESS))
		ADD_TRAIT(src, TRAIT_FACELESS, TRAIT_GENERIC)
	else
		REMOVE_TRAIT(src, TRAIT_FACELESS, TRAIT_GENERIC)

	if(HAS_TRAIT(target, TRAIT_ABOMINATION))
		ADD_TRAIT(src, TRAIT_ABOMINATION, TRAIT_GENERIC)
	else
		REMOVE_TRAIT(src, TRAIT_ABOMINATION, TRAIT_GENERIC)

	regenerate_icons()


/mob/living/carbon/human/proc/copy_bodyparts(mob/living/carbon/human/target)
	var/mob/living/carbon/human/self = src
	var/list/target_missing = target.get_missing_limbs()
	var/list/my_missing = self.get_missing_limbs()

	// Store references to bodyparts
	var/list/original_parts = list()
	var/list/target_parts = list()

	var/list/full = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)

	for(var/zone in full)
		original_parts[zone] = self.get_bodypart(zone)
		target_parts[zone] = target.get_bodypart(zone)

	bodyparts = list()

	// Rebuild bodyparts list with typepaths
	for(var/zone_2 in full)
		var/obj/item/bodypart/target_part = target_parts[zone_2]
		var/obj/item/bodypart/my_part = original_parts[zone_2]

		if(zone_2 in my_missing)
			continue
		else if(zone_2 in target_missing)
			if(my_part)
				bodyparts += my_part.type
		else
			if(target_part)
				bodyparts += target_part.type

	create_bodyparts()

/mob/living/carbon/human/species
	var/race = null

/mob/living/carbon/human/species/Initialize()
	. = ..()
	if(race)
		set_species(race)
	return INITIALIZE_HINT_LATELOAD

/mob/living/carbon/human/species/LateInitialize()
	. = ..()
	var/turf/turf = get_turf(loc)
	if(turf)
		if(!("[turf.z]" in GLOB.weatherproof_z_levels))
			if(SSmapping.level_has_any_trait(turf.z, list(ZTRAIT_IGNORE_WEATHER_TRAIT)))
				GLOB.weatherproof_z_levels |= "[turf.z]"
		if("[turf.z]" in GLOB.weatherproof_z_levels)
			faction |= FACTION_MATTHIOS
			SSmatthios_mobs.register_mob(src)
		if(SSterrain_generation.get_island_at_location(turf))
			faction |= "islander"
			SSisland_mobs.register_mob(src, SSterrain_generation.get_island_at_location(turf))

/**
 * Called when this human should be washed
 */
/mob/living/carbon/human/wash(clean_types)
	. = ..()

	// Wash equipped stuff that cannot be covered
	if(wear_armor?.wash(clean_types))
		update_inv_armor()
		. = TRUE

	if(belt?.wash(clean_types))
		update_inv_belt()
		. = TRUE

	// Check and wash stuff that can be covered
	var/obscured = check_obscured_slots()

	if(!is_mouth_covered())
		. = TRUE

	if(!(obscured & ITEM_SLOT_SHIRT) && wear_shirt?.wash(clean_types))
		update_inv_shirt()
		. = TRUE

	// Wash hands if exposed
	if(!gloves && (clean_types & CLEAN_TYPE_BLOOD) && bloody_hands > 0 && !(obscured & ITEM_SLOT_GLOVES))
		bloody_hands = 0
		update_inv_gloves()
		. = TRUE

/mob/living/carbon/human/dual_wielding_check()
	if(!HAS_TRAIT(src, TRAIT_DUALWIELDER))
		return FALSE

	var/main_hand = get_active_held_item()
	var/off_hand = get_inactive_held_item()

	if(istype(main_hand, off_hand) || (isweapon(main_hand) && isweapon(off_hand)))
		return TRUE

	return FALSE

/mob/living/carbon/human/Logout()
	. = ..()

	var/datum/job/role = mind?.assigned_role

	if(role?.type in MESSAGE_ADMINS_ROLES)
		addtimer(CALLBACK(src, PROC_REF(notify_admins_of_disconnect)), 30 SECONDS)

/mob/living/carbon/human/proc/notify_admins_of_disconnect()
	if(client)
		return

	message_admins("[ADMIN_LOOKUPFLW_PP(src)] is a [mind.assigned_role.get_informed_title(src)] and has been disconnected for more than 30 seconds!")

/mob/living/carbon/human/nobles_seen_servant_work()
	if(!is_servant_job(mind.assigned_role))
		return

	var/list/nobles = list()
	for(var/mob/living/carbon/human/target as anything in viewers(6, src))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(!HAS_TRAIT(target, TRAIT_NOBLE))
			continue
		nobles += target
	if(length(nobles))
		for(var/mob/living/carbon/human/target as anything in nobles)
			if(!target.has_stress_type(/datum/stress_event/noble_seen_servant_work))
				target.add_stress(/datum/stress_event/noble_seen_servant_work)
