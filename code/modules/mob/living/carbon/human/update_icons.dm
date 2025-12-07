	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/* Keep these comments up-to-da/sprite_accessory/earste if you -insist- on hurting my code-baby ;_;
This system allows you to update individual mob-overlays, without regenerating them all each time.
When we generate overlays we generate the standing version and then rotate the mob as necessary..

As of the time of writing there are 20 layers within this list. Please try to keep this from increasing. //22 and counting, good job guys
	var/overlays_standing[20]		//For the standing stance

Most of the time we only wish to update one overlay:
	e.g. - we dropped the fireaxe out of our left hand and need to remove its icon from our mob
	e.g.2 - our hair colour has changed, so we need to update our hair icons on our mob
In these cases, instead of updating every overlay using the old behaviour (regenerate_icons), we instead call
the appropriate update_X proc.
	e.g. - update_l_hand()
	e.g.2 - update_body()

Note: Recent changes by aranclanos+carn:
	update_icons() no longer needs to be called.
	the system is easier to use. update_icons() should not be called unless you absolutely -know- you need it.
	IN ALL OTHER CASES it's better to just call the specific update_X procs.

Note: The defines for layer numbers is now kept exclusvely in __DEFINES/misc.dm instead of being defined there,
	then redefined and undefiend everywhere else. If you need to change the layering of sprites (or add a new layer)
	that's where you should start.

All of this means that this code is more maintainable, faster and still fairly easy to use.

There are several things that need to be remembered:
>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src), rather than using the helper procs)
	You will need to call the relevant update_inv_* proc

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_ring() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_damage_overlays()	//handles damage overlays for brute/burn damage
		update_body()				//Handles updating your mob's body layer and mutant bodyparts
									as well as sprite-accessories that didn't really fit elsewhere (underwear, undershirts, socks, lips, eyes)
									//NOTE: update_mutantrace() is now merged into this!
		update_body()				//Handles updating your hair overlay (used to be update_face, but mouth and
									eyes were merged into update_body())


*/

/mob/living/carbon/proc/get_limbloss_index(limbr, limbl)
	var/jazz = 1
	for(var/obj/item/bodypart/affecting as anything in bodyparts)
		if(affecting.body_part == limbr)
			jazz += 1
		if(affecting.body_part == limbl)
			jazz += 2
	return jazz


/mob/living/carbon/human/update_body()
	dna?.species?.handle_body(src) //create destroy moment
	..()

/mob/living/carbon/human/proc/update_organ_colors()
	var/list/colors = color_key_source_list_from_carbon(src)
	for(var/obj/item/organ/organ in internal_organs)
		organ.build_colors_for_accessory(colors)

/mob/living/carbon/human/update_fire()
	if(fire_stacks + divine_fire_stacks < 10)
		return ..("Generic_mob_burning")
	else
		var/burning = dna?.species?.enflamed_icon
		if(!burning)
			return ..("widefire")
		return ..(burning)


/mob/living/carbon/human/update_damage_overlays()
	START_PROCESSING(SSdamoverlays,src)

/mob/living/carbon/human/proc/update_damage_overlays_real()
	var/datum/species/species = dna?.species
	if(species?.update_damage_overlays(src))
		return

	remove_overlay(DAMAGE_LAYER)
	remove_overlay(LEG_DAMAGE_LAYER)
	remove_overlay(ARM_DAMAGE_LAYER)

	var/use_female_sprites = MALE_SPRITES
	if(species?.sexes)
		if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	var/list/offsets
	var/limb_icon
	var/is_child = (age == AGE_CHILD)
	if(use_female_sprites)
		offsets = is_child ? species.offset_features_child : species.offset_features_f
		limb_icon = is_child ? species.child_dam_icon : species.dam_icon_f
	else
		offsets = is_child ? species.offset_features_child : species.offset_features_m
		limb_icon = is_child ? species.child_dam_icon : species.dam_icon_m

	var/hidechest = TRUE
	if(use_female_sprites)
		var/obj/item/bodypart/CH = get_bodypart(BODY_ZONE_CHEST)
		if(CH)
			if(wear_armor?.flags_inv & HIDEBOOB)
				hidechest = TRUE
			else if(wear_shirt?.flags_inv & HIDEBOOB)
				hidechest = TRUE
			else if(cloak?.flags_inv & HIDEBOOB)
				hidechest = TRUE
			else
				hidechest = FALSE

	var/list/limb_overlaysa = list()
	var/list/limb_overlaysb = list()
	var/list/limb_overlaysc = list()
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		var/list/damage_overlays = list()
		var/list/legdam_overlays = list()
		var/list/armdam_overlays = list()
		if(BP.body_zone == BODY_ZONE_HEAD)
			update_body()
		var/bleed_checker = FALSE
		var/list/wound_overlays
		if(!BP.skeletonized)
			if(BP.brutestate)
				var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.body_zone]_[BP.brutestate]0", -DAMAGE_LAYER)
				damage_overlays += damage_overlay
				var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.body_zone]_[BP.brutestate]0", -LEG_DAMAGE_LAYER)
				legdam_overlays += legdam_overlay
				var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.body_zone]_[BP.brutestate]0", -ARM_DAMAGE_LAYER)
				armdam_overlays += armdam_overlay
			if(BP.burnstate)
				var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.body_zone]_0[BP.burnstate]", -DAMAGE_LAYER)
				damage_overlays += damage_overlay
				var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.body_zone]_0[BP.burnstate]", -LEG_DAMAGE_LAYER)
				legdam_overlays += legdam_overlay
				var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.body_zone]_0[BP.burnstate]", -ARM_DAMAGE_LAYER)
				armdam_overlays += armdam_overlay
			if(BP.get_bleed_rate())
				bleed_checker = TRUE
				if(BP.bandage)
					var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.body_zone]_b", -DAMAGE_LAYER)
					damage_overlay.color = BP.bandage.color
					damage_overlays += damage_overlay
					var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.body_zone]_b", -LEG_DAMAGE_LAYER)
					legdam_overlay.color = BP.bandage.color
					legdam_overlays += legdam_overlay
					var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.body_zone]_b", -ARM_DAMAGE_LAYER)
					armdam_overlay.color = BP.bandage.color
					armdam_overlays += armdam_overlay
			wound_overlays = list()
			for(var/datum/wound/wound as anything in BP.wounds)
				if(!wound.mob_overlay)
					continue
				wound_overlays |= wound.mob_overlay
			for(var/wound_overlay in wound_overlays)
				var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.body_zone]_[wound_overlay]", -DAMAGE_LAYER)
				damage_overlays += damage_overlay
				var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.body_zone]_[wound_overlay]", -LEG_DAMAGE_LAYER)
				legdam_overlays += legdam_overlay
				var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.body_zone]_[wound_overlay]", -ARM_DAMAGE_LAYER)
				armdam_overlays += armdam_overlay
		if(!bleed_checker && BP.bandage)
			var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.body_zone]_b", -DAMAGE_LAYER)
			damage_overlay.color = BP.bandage.color
			damage_overlays += damage_overlay
			var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.body_zone]_b", -LEG_DAMAGE_LAYER)
			legdam_overlay.color = BP.bandage.color
			legdam_overlays += legdam_overlay
			var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.body_zone]_b", -ARM_DAMAGE_LAYER)
			armdam_overlay.color = BP.bandage.color
			armdam_overlays += armdam_overlay
		if(BP.aux_zone && !((BP.body_zone == BODY_ZONE_CHEST) && hidechest))
			if(!BP.skeletonized)
				if(BP.brutestate)
					var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.aux_zone]_[BP.brutestate]0", -DAMAGE_LAYER)
					damage_overlays += damage_overlay
					var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.aux_zone]_[BP.brutestate]0", -LEG_DAMAGE_LAYER)
					legdam_overlays += legdam_overlay
					var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.aux_zone]_[BP.brutestate]0", -ARM_DAMAGE_LAYER)
					armdam_overlays += armdam_overlay
				if(BP.burnstate)
					var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.aux_zone]_0[BP.burnstate]", -DAMAGE_LAYER)
					damage_overlays += damage_overlay
					var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.aux_zone]_0[BP.burnstate]", -LEG_DAMAGE_LAYER)
					legdam_overlays += legdam_overlay
					var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.aux_zone]_0[BP.burnstate]", -ARM_DAMAGE_LAYER)
					armdam_overlays += armdam_overlay
				if(bleed_checker)
					if(BP.bandage)
						var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.aux_zone]_b", -DAMAGE_LAYER)
						damage_overlay.color = BP.bandage.color
						damage_overlays += damage_overlay
						var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.aux_zone]_b", -LEG_DAMAGE_LAYER)
						legdam_overlay.color = BP.bandage.color
						legdam_overlays += legdam_overlay
						var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.aux_zone]_b", -ARM_DAMAGE_LAYER)
						armdam_overlay.color = BP.bandage.color
						armdam_overlays += armdam_overlay
				//We got the wound overlays before, it's all good
				for(var/wound_overlay in wound_overlays)
					var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.aux_zone]_[wound_overlay]", -DAMAGE_LAYER)
					damage_overlays += damage_overlay
					var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.aux_zone]_[wound_overlay]", -LEG_DAMAGE_LAYER)
					legdam_overlays += legdam_overlay
					var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.aux_zone]_[wound_overlay]", -ARM_DAMAGE_LAYER)
					armdam_overlays += armdam_overlay
			if(!bleed_checker && BP.bandage)
				var/mutable_appearance/damage_overlay = mutable_appearance(limb_icon, "[BP.aux_zone]_b", -DAMAGE_LAYER)
				damage_overlay.color = BP.bandage.color
				damage_overlays += damage_overlay
				var/mutable_appearance/legdam_overlay = mutable_appearance(limb_icon, "legdam_[BP.aux_zone]_b", -LEG_DAMAGE_LAYER)
				legdam_overlay.color = BP.bandage.color
				legdam_overlays += legdam_overlay
				var/mutable_appearance/armdam_overlay = mutable_appearance(limb_icon, "armdam_[BP.aux_zone]_b", -ARM_DAMAGE_LAYER)
				armdam_overlay.color = BP.bandage.color
				armdam_overlays += armdam_overlay

		var/used_offset = BP.offset
		for(var/mutable_appearance/M as anything in damage_overlays)
			if(used_offset in offsets)
				M.pixel_x += offsets[used_offset][1]
				M.pixel_y += offsets[used_offset][2]
			limb_overlaysa += M
		for(var/mutable_appearance/M as anything in legdam_overlays)
			if(used_offset in offsets)
				M.pixel_x += offsets[used_offset][1]
				M.pixel_y += offsets[used_offset][2]
			limb_overlaysb += M
		for(var/mutable_appearance/M as anything in armdam_overlays)
			if(used_offset in offsets)
				M.pixel_x += offsets[used_offset][1]
				M.pixel_y += offsets[used_offset][2]
			limb_overlaysc += M

	overlays_standing[DAMAGE_LAYER] = limb_overlaysa
	overlays_standing[LEG_DAMAGE_LAYER] = limb_overlaysb
	overlays_standing[ARM_DAMAGE_LAYER] = limb_overlaysc

	apply_overlay(DAMAGE_LAYER)
	apply_overlay(LEG_DAMAGE_LAYER)
	apply_overlay(ARM_DAMAGE_LAYER)


/* --------------------------------------- */

/mob/living/carbon/human/update_clothing(slot_flags)
	if(slot_flags & ITEM_SLOT_BACK)
		update_inv_back()
	if(slot_flags & ITEM_SLOT_CLOAK)
		update_inv_cloak()
	if(slot_flags & ITEM_SLOT_MASK)
		update_inv_wear_mask()
	if(slot_flags & ITEM_SLOT_NECK)
		update_inv_neck()
	if(slot_flags & ITEM_SLOT_BELT)
		update_inv_belt()
	if(slot_flags & ITEM_SLOT_WRISTS)
		update_inv_wrists()
	if(slot_flags & ITEM_SLOT_MASK)
		update_inv_wear_mask()
	if(slot_flags & ITEM_SLOT_MOUTH)
		update_inv_mouth()
	if(slot_flags & ITEM_SLOT_GLOVES)
		update_inv_gloves()
	if(slot_flags & ITEM_SLOT_HEAD)
		update_inv_head()
	if(slot_flags & ITEM_SLOT_SHOES)
		update_inv_shoes()
	if(slot_flags & ITEM_SLOT_PANTS)
		update_inv_pants()
	if(slot_flags & ITEM_SLOT_SHIRT)
		update_inv_shirt()
	if(slot_flags & ITEM_SLOT_ARMOR)
		update_inv_armor()

//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	if(!..())
		icon_render_key = null //invalidate bodyparts cache
		if(dna?.species?.regenerate_icons(src))
			return
		update_body()
		update_inv_ring()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_wear_mask()
		update_inv_head()
		update_inv_belt()
		update_inv_back()
		update_inv_armor()

		update_inv_neck()
		update_inv_cloak()
		update_inv_pants()
		update_inv_shirt()
		update_inv_mouth()
		update_transform()
		//damage overlays
		update_damage_overlays()

/mob/proc/regenerate_clothes()
	return
/mob/living/carbon/human/regenerate_clothes()
	update_inv_ring()
	update_inv_gloves()
	update_inv_shoes()
	update_inv_wear_mask()
	update_inv_head()
	update_inv_belt()
	update_inv_back()
	update_inv_armor()
	update_inv_neck()
	update_inv_cloak()
	update_inv_pants()
	update_inv_shirt()
	update_inv_mouth()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_neck()
	remove_overlay(NECK_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_NECK) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_neck)
		update_hud_neck(wear_neck)
		if(!(ITEM_SLOT_NECK & check_obscured_slots()))
			var/datum/species/species = dna?.species

			var/use_female_sprites = FALSE
			if(species?.sexes)
				if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
					use_female_sprites = FEMALE_SPRITES

			var/list/offsets
			if(use_female_sprites)
				offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
			else
				offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

			var/mutable_appearance/neck_overlay = wear_neck.build_worn_icon(age, NECK_LAYER, 'icons/roguetown/clothing/onmob/neck.dmi')
			if(LAZYACCESS(offsets, OFFSET_NECK))
				neck_overlay.pixel_x += offsets[OFFSET_NECK][1]
				neck_overlay.pixel_y += offsets[OFFSET_NECK][2]
			overlays_standing[NECK_LAYER] = neck_overlay

	update_body()
	apply_overlay(NECK_LAYER)

/mob/living/carbon/human/update_inv_ring()
	remove_overlay(RING_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_RING) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_ring)
		wear_ring.screen_loc = rogueui_ringr
		if(client && hud_used?.hud_shown)
			client.screen += wear_ring
		update_observer_view(wear_ring)

		var/datum/species/species = dna?.species

		var/use_female_sprites = FALSE
		if(species?.sexes)
			if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES

		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

		var/mutable_appearance/ring_overlay = wear_ring.build_worn_icon(age, RING_LAYER, 'icons/roguetown/clothing/onmob/rings.dmi')
		if(LAZYACCESS(offsets, OFFSET_RING))
			ring_overlay.pixel_x += offsets[OFFSET_RING][1]
			ring_overlay.pixel_y += offsets[OFFSET_RING][2]
		overlays_standing[RING_LAYER] = ring_overlay

	apply_overlay(RING_LAYER)


/mob/living/carbon/human/update_inv_gloves()
	remove_overlay(GLOVES_LAYER)
	remove_overlay(GLOVESLEEVE_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_GLOVES) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	var/datum/species/species = dna?.species
	var/use_female_sprites = FALSE
	if(species?.sexes)
		if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	if(!gloves && bloody_hands)
		var/mutable_appearance/bloody_overlay = mutable_appearance('icons/effects/blood.dmi', "bloodyhands", -GLOVES_LAYER)
		if(num_hands < 2)
			if(has_left_hand(FALSE))
				bloody_overlay.icon_state = "bloodyhands_left"
			else if(has_right_hand(FALSE))
				bloody_overlay.icon_state = "bloodyhands_right"

		if(use_female_sprites)
			bloody_overlay.icon_state += "_f"

		overlays_standing[GLOVESLEEVE_LAYER] = bloody_overlay

	if(gloves)
		gloves.screen_loc = rogueui_gloves
		if(client && hud_used?.hud_shown)
			if(hud_used.inventory_shown)
				client.screen += gloves
		update_observer_view(gloves, 1)

		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

		var/racecustom
		if(species?.custom_clothes)
			if(species.custom_id)
				racecustom = species.custom_id
			else
				racecustom = species.id

		var/armsindex = get_limbloss_index(ARM_RIGHT, ARM_LEFT)
		var/mutable_appearance/gloves_overlay = gloves.build_worn_icon(age, GLOVES_LAYER, 'icons/roguetown/clothing/onmob/gloves.dmi', coom = use_female_sprites, sleeveindex = armsindex, customi = racecustom)

		if(LAZYACCESS(offsets, OFFSET_GLOVES))
			gloves_overlay.pixel_x += offsets[OFFSET_GLOVES][1]
			gloves_overlay.pixel_y += offsets[OFFSET_GLOVES][2]
		overlays_standing[GLOVES_LAYER] = gloves_overlay

		//add sleeve overlays, then offset
		var/list/sleeves = list()
		if(gloves.sleeved && armsindex > 0)
			sleeves = get_sleeves_layer(gloves, armsindex, GLOVESLEEVE_LAYER)

		if(sleeves)
			for(var/mutable_appearance/S as anything in sleeves)
				if(LAZYACCESS(offsets, OFFSET_GLOVES))
					S.pixel_x += offsets[OFFSET_GLOVES][1]
					S.pixel_y += offsets[OFFSET_GLOVES][2]
				overlays_standing[GLOVESLEEVE_LAYER] = sleeves

	apply_overlay(GLOVES_LAYER)
	apply_overlay(GLOVESLEEVE_LAYER)

/mob/living/carbon/human/update_inv_wrists()
	remove_overlay(WRISTS_LAYER)
	remove_overlay(WRISTSLEEVE_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_WRISTS) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_wrists)
		wear_wrists.screen_loc = rogueui_wrists
		if(client && hud_used?.hud_shown)
			if(hud_used.inventory_shown)
				client.screen += wear_wrists
		update_observer_view(wear_wrists,1)
		var/datum/species/species = dna?.species
		var/armsindex = get_limbloss_index(ARM_RIGHT, ARM_LEFT)

		var/use_female_sprites = FALSE
		if(species?.sexes)
			if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES

		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

		var/racecustom
		if(species?.custom_clothes)
			if(species.custom_id)
				racecustom = species.custom_id
			else
				racecustom = species.id

		var/mutable_appearance/wrists_overlay = wear_wrists.build_worn_icon(age, WRISTS_LAYER, coom = use_female_sprites, sleeveindex = armsindex, customi = racecustom)

		if(LAZYACCESS(offsets, OFFSET_WRISTS))
			wrists_overlay.pixel_x += offsets[OFFSET_WRISTS][1]
			wrists_overlay.pixel_y += offsets[OFFSET_WRISTS][2]

		overlays_standing[WRISTS_LAYER] = wrists_overlay

		//add sleeve overlays, then offset
		var/list/sleeves = list()
		if(wear_wrists.sleeved && armsindex > 0)
			sleeves = get_sleeves_layer(wear_wrists,armsindex,WRISTSLEEVE_LAYER)

		if(sleeves)
			for(var/mutable_appearance/S as anything in sleeves)
				if(LAZYACCESS(offsets, OFFSET_WRISTS))
					S.pixel_x += offsets[OFFSET_WRISTS][1]
					S.pixel_y += offsets[OFFSET_WRISTS][2]
			overlays_standing[WRISTSLEEVE_LAYER] = sleeves

	apply_overlay(WRISTS_LAYER)
	apply_overlay(WRISTSLEEVE_LAYER)

/mob/living/carbon/human/update_inv_shoes()
	remove_overlay(SHOES_LAYER)
	remove_overlay(SHOESLEEVE_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_SHOES) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(shoes)
		shoes.screen_loc = rogueui_shoes
		if(client && hud_used?.hud_shown)
			if(hud_used.inventory_shown)
				client.screen += shoes
		update_observer_view(shoes,1)

		var/datum/species/species = dna?.species
		var/footindex = get_limbloss_index(LEG_RIGHT, LEG_LEFT)

		var/use_female_sprites = FALSE
		if(species?.sexes)
			if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES

		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

		var/racecustom
		if(species?.custom_clothes)
			if(species.custom_id)
				racecustom = species.custom_id
			else
				racecustom = species.id

		var/mutable_appearance/shoes_overlay = shoes.build_worn_icon(age, SHOES_LAYER, 'icons/mob/clothing/feet.dmi', coom = use_female_sprites, customi = racecustom, sleeveindex = footindex)
		if(LAZYACCESS(offsets, OFFSET_SHOES))
			shoes_overlay.pixel_x += offsets[OFFSET_SHOES][1]
			shoes_overlay.pixel_y += offsets[OFFSET_SHOES][2]
		overlays_standing[SHOES_LAYER] = shoes_overlay

		//add sleeve overlays, then offset
		var/list/sleeves = list()
		if(shoes.sleeved && footindex > 0)
			sleeves = get_sleeves_layer(shoes, footindex, SHOESLEEVE_LAYER)
		if(sleeves)
			for(var/mutable_appearance/S as anything in sleeves)
				if(LAZYACCESS(offsets, OFFSET_SHOES))
					S.pixel_x += offsets[OFFSET_SHOES][1]
					S.pixel_y += offsets[OFFSET_SHOES][2]

			overlays_standing[SHOESLEEVE_LAYER] = sleeves

	apply_overlay(SHOES_LAYER)
	apply_overlay(SHOESLEEVE_LAYER)

/mob/living/carbon/human/update_inv_head(hide_nonstandard = FALSE)
	remove_overlay(HEAD_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_HEAD) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(head)
		if(hide_nonstandard && (head.worn_x_dimension != 32 || head.worn_y_dimension != 32))
			update_hud_head(head)
			return

		update_hud_head(head)
		var/datum/species/species = dna?.species
		var/use_female_sprites = FALSE
		if(species?.sexes)
			if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES
		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

		overlays_standing[HEAD_LAYER] = head.build_worn_icon(age = age, default_layer = HEAD_LAYER, default_icon_file = 'icons/roguetown/clothing/onmob/head.dmi', coom = FALSE)
		var/mutable_appearance/head_overlay = overlays_standing[HEAD_LAYER]
		if(head_overlay)
			if(LAZYACCESS(offsets, OFFSET_HEAD))
				head_overlay.pixel_x += offsets[OFFSET_HEAD][1]
				head_overlay.pixel_y += offsets[OFFSET_HEAD][2]
			overlays_standing[HEAD_LAYER] = head_overlay

	apply_overlay(HEAD_LAYER)
	update_body() //hoodies

/mob/living/carbon/human/update_inv_belt(hide_experimental = FALSE)
	remove_overlay(BELT_LAYER)
	remove_overlay(BELT_BEHIND_LAYER)

	var/list/standing_front = list()
	var/list/standing_behind = list()

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BELT) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)
		inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BELT_R) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)
		inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BELT_L) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	var/datum/species/species = dna?.species
	var/use_female_sprites = FALSE
	if(species?.sexes)
		if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	var/list/offsets
	if(use_female_sprites)
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
	else
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	var/racecustom
	if(species?.custom_clothes)
		if(species.custom_id)
			racecustom = species.custom_id
		else
			racecustom = species.id

	if(beltr)
		if(beltr.bigboy)
			beltr.screen_loc = "WEST-4:-16,SOUTH+2:-16"
		else
			beltr.screen_loc = rogueui_beltr
		if(client && hud_used?.hud_shown)
			client.screen += beltr
		update_observer_view(beltr)
		if(!(cloak && (cloak.flags_inv & HIDEBELT)))
			var/mutable_appearance/onbelt_overlay
			var/mutable_appearance/onbelt_behind
			if(beltr.experimental_onhip && !hide_experimental)
				var/list/prop
				if(beltr.force_reupdate_inhand)
					prop = beltr.onprop?["onbelt"]
					if(!prop)
						prop = beltr.getonmobprop("onbelt")
						LAZYSET(beltr.onprop, "onbelt", prop)
				else
					prop = beltr.getonmobprop("onbelt")
				if(prop)
					onbelt_overlay = mutable_appearance(beltr.getmoboverlay("onbelt",prop,mirrored=FALSE), layer=-BELT_LAYER)
					onbelt_behind = mutable_appearance(beltr.getmoboverlay("onbelt",prop,behind=TRUE,mirrored=FALSE), layer=-BELT_BEHIND_LAYER)
					onbelt_overlay = center_image(onbelt_overlay, beltr.inhand_x_dimension, beltr.inhand_y_dimension)
					onbelt_behind = center_image(onbelt_behind, beltr.inhand_x_dimension, beltr.inhand_y_dimension)
					if(LAZYACCESS(offsets, OFFSET_BELT))
						onbelt_overlay.pixel_x += offsets[OFFSET_BELT][1]
						onbelt_overlay.pixel_y += offsets[OFFSET_BELT][2]
						onbelt_behind.pixel_x += offsets[OFFSET_BELT][1]
						onbelt_behind.pixel_y += offsets[OFFSET_BELT][2]
					standing_front += onbelt_overlay
					standing_behind += onbelt_behind
			else
				onbelt_overlay = beltr.build_worn_icon(age, BELT_LAYER, 'icons/roguetown/clothing/onmob/belt_r.dmi')
				if(onbelt_overlay)
					if(LAZYACCESS(offsets, OFFSET_BELT))
						onbelt_overlay.pixel_x += offsets[OFFSET_BELT][1]
						onbelt_overlay.pixel_y += offsets[OFFSET_BELT][2]
				standing_front += onbelt_overlay

	if(beltl)
		if(beltl.bigboy)
			beltl.screen_loc = "WEST-2:-16,SOUTH+2:-16"
		else
			beltl.screen_loc = rogueui_beltl
		if(client && hud_used?.hud_shown)
			client.screen += beltl
		update_observer_view(beltl)
		if(!(cloak && (cloak.flags_inv & HIDEBELT)))
			var/mutable_appearance/onbelt_overlay
			var/mutable_appearance/onbelt_behind
			if(beltl.experimental_onhip && !hide_experimental)
				var/list/prop
				if(beltl.force_reupdate_inhand)
					prop = beltl.onprop?["onbelt"]
					if(!prop)
						prop = beltl.getonmobprop("onbelt")
						LAZYSET(beltl.onprop, "onbelt", prop)
				else
					prop = beltl.getonmobprop("onbelt")
				if(prop)
					onbelt_overlay = mutable_appearance(beltl.getmoboverlay("onbelt",prop,mirrored=TRUE), layer=-BELT_LAYER)
					onbelt_behind = mutable_appearance(beltl.getmoboverlay("onbelt",prop,behind=TRUE,mirrored=TRUE), layer=-BELT_BEHIND_LAYER)
					onbelt_overlay = center_image(onbelt_overlay, beltl.inhand_x_dimension, beltl.inhand_y_dimension)
					onbelt_behind = center_image(onbelt_behind, beltl.inhand_x_dimension, beltl.inhand_y_dimension)
					if(LAZYACCESS(offsets, OFFSET_BELT))
						onbelt_overlay.pixel_x += offsets[OFFSET_BELT][1]
						onbelt_overlay.pixel_y += offsets[OFFSET_BELT][2]
						onbelt_behind.pixel_x += offsets[OFFSET_BELT][1]
						onbelt_behind.pixel_y += offsets[OFFSET_BELT][2]
					standing_front += onbelt_overlay
					standing_behind += onbelt_behind
			else
				onbelt_overlay = beltl.build_worn_icon(age, BELT_LAYER, 'icons/roguetown/clothing/onmob/belt_l.dmi')
				if(onbelt_overlay)
					if(LAZYACCESS(offsets, OFFSET_BELT))
						onbelt_overlay.pixel_x += offsets[OFFSET_BELT][1]
						onbelt_overlay.pixel_y += offsets[OFFSET_BELT][2]
				standing_front += onbelt_overlay

	if(belt)
		belt.screen_loc = rogueui_belt
		if(client && hud_used?.hud_shown)
			client.screen += belt
		update_observer_view(belt)
		if(!(cloak?.flags_inv & HIDEBELT))
			var/mutable_appearance/mbeltoverlay = belt.build_worn_icon(age, BELT_LAYER, 'icons/roguetown/clothing/onmob/belts.dmi', coom = use_female_sprites, customi = racecustom)
			if(mbeltoverlay)
				if(LAZYACCESS(offsets, OFFSET_BELT))
					mbeltoverlay.pixel_x += offsets[OFFSET_BELT][1]
					mbeltoverlay.pixel_y += offsets[OFFSET_BELT][2]
			standing_front += mbeltoverlay

	overlays_standing[BELT_LAYER] = standing_front
	overlays_standing[BELT_BEHIND_LAYER] = standing_behind

	apply_overlay(BELT_LAYER)
	apply_overlay(BELT_BEHIND_LAYER)

/mob/living/carbon/human/update_inv_wear_suit()
	return

/mob/living/carbon/human/update_inv_wear_mask()
	remove_overlay(MASK_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_GLOVES) + 1]
		inv?.update_icon()

	if(wear_mask)
		update_hud_wear_mask(wear_mask)
		if(!(ITEM_SLOT_MASK & check_obscured_slots()))
			var/mutable_appearance/mask_overlay = wear_mask.build_worn_icon(default_layer = MASK_LAYER, default_icon_file = 'icons/roguetown/clothing/onmob/masks.dmi')
			var/datum/species/species = dna?.species
			var/use_female_sprites = FALSE
			if(species.sexes)
				if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
					use_female_sprites = FEMALE_SPRITES
			var/list/offsets
			if(use_female_sprites)
				offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
			else
				offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m
			if(mask_overlay)
				if(LAZYACCESS(offsets, OFFSET_FACEMASK))
					mask_overlay.pixel_x += offsets[OFFSET_FACEMASK][1]
					mask_overlay.pixel_y += offsets[OFFSET_FACEMASK][2]
				overlays_standing[MASK_LAYER] = mask_overlay

	apply_overlay(MASK_LAYER)

/mob/living/carbon/human/update_inv_back(hide_experimental = FALSE)
	remove_overlay(BACK_LAYER)
	remove_overlay(BACK_BEHIND_LAYER)
	remove_overlay(UNDER_CLOAK_LAYER)

	var/list/overcloaks
	var/list/undercloaks
	var/list/backbehind

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK_R) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)
		inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_BACK_L) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	var/datum/species/species = dna?.species

	var/use_female_sprites = FALSE
	if(species?.sexes)
		if(gender == FEMALE && !species.swap_female_clothes)
			use_female_sprites = FEMALE_BOOB
		else if(gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	var/list/offsets
	if(use_female_sprites)
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
	else
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	if(backr)
		if(backr.alternate_worn_layer == CLOAK_BEHIND_LAYER)
			update_inv_cloak()
		else
			var/mutable_appearance/back_overlay
			var/mutable_appearance/behindback_overlay
			update_hud_backr(backr)
			if(backr.experimental_onback && !hide_experimental)
				var/list/prop
				if(backr.force_reupdate_inhand)
					prop = backr.onprop?["onback"]
					if(!prop)
						prop = backr.getonmobprop("onback")
						LAZYSET(backr.onprop, "onback", prop)
				else
					prop = backr.getonmobprop("onback")
				if(prop)
					back_overlay = mutable_appearance(backr.getmoboverlay("onback",prop,mirrored=FALSE), layer=-BACK_LAYER)
					behindback_overlay = mutable_appearance(backr.getmoboverlay("onback",prop,behind=TRUE,mirrored=FALSE), layer=-BACK_BEHIND_LAYER)
					back_overlay = center_image(back_overlay, backr.inhand_x_dimension, backr.inhand_y_dimension)
					behindback_overlay = center_image(behindback_overlay, backr.inhand_x_dimension, backr.inhand_y_dimension)
					if(LAZYACCESS(offsets, OFFSET_BACK))
						back_overlay.pixel_x += offsets[OFFSET_BACK][1]
						back_overlay.pixel_y += offsets[OFFSET_BACK][2]
						behindback_overlay.pixel_x += offsets[OFFSET_BACK][1]
						behindback_overlay.pixel_y += offsets[OFFSET_BACK][2]
					LAZYADD(overcloaks, back_overlay)
					LAZYADD(backbehind, behindback_overlay)
			else
				back_overlay = backr.build_worn_icon(age, BACK_LAYER, 'icons/roguetown/clothing/onmob/back_r.dmi')
				if(LAZYACCESS(offsets, OFFSET_BACK))
					back_overlay.pixel_x += offsets[OFFSET_BACK][1]
					back_overlay.pixel_y += offsets[OFFSET_BACK][2]
				if(backr.alternate_worn_layer == UNDER_CLOAK_LAYER)
					LAZYADD(undercloaks, back_overlay)
				else
					LAZYADD(overcloaks, back_overlay)

	if(backl)
		if(backl.alternate_worn_layer == CLOAK_BEHIND_LAYER)
			update_inv_cloak()
		else
			update_hud_backl(backl)
			var/mutable_appearance/back_overlay
			var/mutable_appearance/behindback_overlay
			if(backl.experimental_onback && !hide_experimental)
				var/list/prop
				if(backl.force_reupdate_inhand)
					prop = backl.onprop?["onback"]
					if(!prop)
						prop = backl.getonmobprop("onback")
						LAZYSET(backl.onprop, "onback", prop)
				else
					prop = backl.getonmobprop("onback")
				if(prop)
					back_overlay = mutable_appearance(backl.getmoboverlay("onback",prop,mirrored=TRUE), layer=-BACK_LAYER)
					behindback_overlay = mutable_appearance(backl.getmoboverlay("onback",prop,behind=TRUE,mirrored=TRUE), layer=-BACK_BEHIND_LAYER)
					back_overlay = center_image(back_overlay, backl.inhand_x_dimension, backl.inhand_y_dimension)
					behindback_overlay = center_image(behindback_overlay, backl.inhand_x_dimension, backl.inhand_y_dimension)
					if(LAZYACCESS(offsets, OFFSET_BACK))
						back_overlay.pixel_x += offsets[OFFSET_BACK][1]
						back_overlay.pixel_y += offsets[OFFSET_BACK][2]
						behindback_overlay.pixel_x += offsets[OFFSET_BACK][1]
						behindback_overlay.pixel_y += offsets[OFFSET_BACK][2]
					LAZYADD(overcloaks, back_overlay)
					LAZYADD(backbehind, behindback_overlay)
			else
				back_overlay = backl.build_worn_icon(age, BACK_LAYER, 'icons/roguetown/clothing/onmob/back_l.dmi')
				if(LAZYACCESS(offsets, OFFSET_BACK))
					back_overlay.pixel_x += offsets[OFFSET_BACK][1]
					back_overlay.pixel_y += offsets[OFFSET_BACK][2]
				if(backl.alternate_worn_layer == UNDER_CLOAK_LAYER)
					LAZYADD(undercloaks, back_overlay)
				else
					LAZYADD(overcloaks, back_overlay)

	if(LAZYLEN(overcloaks))
		overlays_standing[BACK_LAYER] = overcloaks
	if(LAZYLEN(backbehind))
		overlays_standing[BACK_BEHIND_LAYER] = backbehind
	if(LAZYLEN(undercloaks))
		overlays_standing[UNDER_CLOAK_LAYER] = undercloaks

	apply_overlay(BACK_LAYER)
	apply_overlay(BACK_BEHIND_LAYER)
	apply_overlay(UNDER_CLOAK_LAYER)

/mob/living/carbon/human/update_inv_cloak()
	remove_overlay(CLOAK_LAYER)
	remove_overlay(CLOAK_BEHIND_LAYER)
	remove_overlay(TABARD_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_CLOAK) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	var/list/cloaklays
	var/datum/species/species = dna?.species

	var/use_female_sprites = FALSE
	if(species?.sexes)
		if(gender == FEMALE && !species.swap_female_clothes)
			use_female_sprites = FEMALE_BOOB
		else if(gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	var/list/offsets
	if(use_female_sprites)
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
	else
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	var/racecustom
	if(species?.custom_clothes)
		if(species.custom_id)
			racecustom = species.custom_id
		else
			racecustom = species.id

	if(cloak)
		cloak.screen_loc = rogueui_cloak
		if(client && hud_used?.hud_shown)
			if(hud_used.inventory_shown)
				client.screen += cloak
		update_observer_view(cloak, 1)

		var/mutable_appearance/cloak_overlay = cloak.build_worn_icon(age, CLOAK_LAYER, coom = use_female_sprites, customi = racecustom)

		if(LAZYACCESS(offsets, OFFSET_CLOAK))
			cloak_overlay.pixel_x += offsets[OFFSET_CLOAK][1]
			cloak_overlay.pixel_y += offsets[OFFSET_CLOAK][2]
		if(cloak.alternate_worn_layer == TABARD_LAYER)
			overlays_standing[TABARD_LAYER] = cloak_overlay
		if(cloak.alternate_worn_layer == CLOAK_BEHIND_LAYER)
			overlays_standing[CLOAK_BEHIND_LAYER] = cloak_overlay
		if(!cloak.alternate_worn_layer)
			LAZYADD(cloaklays, cloak_overlay)

		//add sleeve overlays, then offset
		var/list/cloaksleeves
		if(cloak.sleeved)
			cloaksleeves = get_sleeves_layer(cloak,0,CLOAK_LAYER)

		if(LAZYLEN(cloaksleeves))
			for(var/mutable_appearance/S as anything in cloaksleeves)
				if(LAZYACCESS(offsets, OFFSET_CLOAK))
					S.pixel_x += offsets[OFFSET_CLOAK][1]
					S.pixel_y += offsets[OFFSET_CLOAK][2]
				LAZYADD(cloaklays, S)

	if(backr && backr.alternate_worn_layer == CLOAK_BEHIND_LAYER)
		update_hud_backr(backr)
		var/mutable_appearance/cloak_overlay = backr.build_worn_icon(age, CLOAK_LAYER, coom = use_female_sprites, customi = racecustom)

		if(LAZYACCESS(offsets, OFFSET_CLOAK))
			cloak_overlay.pixel_x += offsets[OFFSET_CLOAK][1]
			cloak_overlay.pixel_y += offsets[OFFSET_CLOAK][2]
		if(backr.alternate_worn_layer == TABARD_LAYER)
			overlays_standing[TABARD_LAYER] = cloak_overlay
		if(backr.alternate_worn_layer == CLOAK_BEHIND_LAYER)
			overlays_standing[CLOAK_BEHIND_LAYER] = cloak_overlay
		if(!backr.alternate_worn_layer)
			LAZYADD(cloaklays, cloak_overlay)

		//add sleeve overlays, then offset
		var/list/cloaksleeves
		if(backr.sleeved)
			cloaksleeves = get_sleeves_layer(backr,0,CLOAK_LAYER)

		if(LAZYLEN(cloaksleeves))
			for(var/mutable_appearance/S in cloaksleeves)
				if(LAZYACCESS(offsets, OFFSET_CLOAK))
					S.pixel_x += offsets[OFFSET_CLOAK][1]
					S.pixel_y += offsets[OFFSET_CLOAK][2]
				LAZYADD(cloaklays, S)

	overlays_standing[CLOAK_LAYER] = cloaklays
	update_inv_armor() //fixboob
	apply_overlay(TABARD_LAYER)
	apply_overlay(CLOAK_BEHIND_LAYER)
	apply_overlay(CLOAK_LAYER)

/mob/living/carbon/human/update_inv_shirt()
	remove_overlay(SHIRT_LAYER)
	remove_overlay(SHIRTSLEEVE_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_SHIRT) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_shirt)
		wear_shirt.screen_loc = rogueui_shirt					//move the item to the appropriate screen loc
		if(client && hud_used?.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open
				client.screen += wear_shirt					//add it to client's screen
		update_observer_view(wear_shirt,1)
		var/datum/species/species = dna?.species
		var/armsindex = get_limbloss_index(ARM_RIGHT, ARM_LEFT)
		var/hideboob = FALSE
		if(wear_armor?.flags_inv & HIDEBOOB)
			hideboob = TRUE
		if(cloak?.flags_inv & HIDEBOOB)
			hideboob = TRUE
		if(species?.no_boobs)
			hideboob = TRUE
		var/use_female_sprites = FALSE
		if(species?.sexes)
			if(gender == FEMALE && !species.swap_female_clothes)
				use_female_sprites = hideboob ? FEMALE_SPRITES : FEMALE_BOOB
			else if(gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES
		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m
		var/racecustom
		if(species?.custom_clothes)
			if(species.custom_id)
				racecustom = species.custom_id
			else
				racecustom = species.id
		var/mutable_appearance/shirt_overlay = wear_shirt.build_worn_icon(age, SHIRT_LAYER, coom = use_female_sprites, customi = racecustom, sleeveindex = armsindex)

		if(LAZYACCESS(offsets, OFFSET_SHIRT))
			shirt_overlay.pixel_x += offsets[OFFSET_SHIRT][1]
			shirt_overlay.pixel_y += offsets[OFFSET_SHIRT][2]
		overlays_standing[SHIRT_LAYER] = shirt_overlay

		//add sleeve overlays, then offset
		var/list/sleeves = list()
		if(wear_shirt.sleeved && armsindex > 0)
			sleeves = get_sleeves_layer(wear_shirt, armsindex, SHIRTSLEEVE_LAYER)

		if(sleeves)
			for(var/mutable_appearance/S as anything in sleeves)
				if(LAZYACCESS(offsets, OFFSET_SHIRT))
					S.pixel_x += offsets[OFFSET_SHIRT][1]
					S.pixel_y += offsets[OFFSET_SHIRT][2]
			overlays_standing[SHIRTSLEEVE_LAYER] = sleeves

	update_body_parts(redraw = TRUE)
	dna.species.handle_body(src)
	update_body()

	apply_overlay(SHIRT_LAYER)
	apply_overlay(SHIRTSLEEVE_LAYER)

/mob/living/carbon/human/update_inv_armor()
	remove_overlay(ARMOR_LAYER)
	remove_overlay(ARMORSLEEVE_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_ARMOR) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_armor)
		wear_armor.screen_loc = rogueui_armor					//move the item to the appropriate screen loc
		if(client && hud_used?.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open
				client.screen += wear_armor					//add it to client's screen
		update_observer_view(wear_armor,1)
		var/datum/species/species = dna?.species
		var/armsindex = get_limbloss_index(ARM_RIGHT, ARM_LEFT)
		var/hideboob = FALSE
		if(cloak?.flags_inv & HIDEBOOB)
			hideboob = TRUE
		if(species?.no_boobs)
			hideboob = TRUE
		var/use_female_sprites = FALSE
		if(species?.sexes)
			if(gender == FEMALE && !species.swap_female_clothes)
				use_female_sprites = hideboob ? FEMALE_SPRITES : FEMALE_BOOB
			else if(gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES
		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m
		var/racecustom
		if(species?.custom_clothes)
			if(species?.custom_id)
				racecustom = species?.custom_id
			else
				racecustom = species?.id
		var/mutable_appearance/armor_overlay = wear_armor.build_worn_icon(age, ARMOR_LAYER, coom = use_female_sprites , customi = racecustom, sleeveindex = armsindex)
		if(LAZYACCESS(offsets, OFFSET_ARMOR))
			armor_overlay.pixel_x += offsets[OFFSET_ARMOR][1]
			armor_overlay.pixel_y += offsets[OFFSET_ARMOR][2]
		overlays_standing[ARMOR_LAYER] = armor_overlay

		//add sleeve overlays, then offset
		var/list/sleeves = list()
		if(wear_armor.sleeved && armsindex > 0)
			sleeves = get_sleeves_layer(wear_armor,armsindex,ARMORSLEEVE_LAYER)

		if(sleeves)
			for(var/mutable_appearance/S as anything in sleeves)
				if(LAZYACCESS(offsets, OFFSET_ARMOR))
					S.pixel_x += offsets[OFFSET_ARMOR][1]
					S.pixel_y += offsets[OFFSET_ARMOR][2]
			overlays_standing[ARMORSLEEVE_LAYER] = sleeves

	update_body_parts(redraw = TRUE)
	dna.species.handle_body(src)
	update_body()
	update_inv_shirt() // fix boob

	apply_overlay(ARMOR_LAYER)
	apply_overlay(ARMORSLEEVE_LAYER)

/mob/living/carbon/human/update_inv_pants()
	remove_overlay(PANTS_LAYER)
	remove_overlay(LEGSLEEVE_LAYER)

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_PANTS) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(wear_pants)
		wear_pants.screen_loc = rogueui_pants					//move the item to the appropriate screen loc
		if(client && hud_used?.hud_shown)
			if(hud_used.inventory_shown)			//if the inventory is open
				client.screen += wear_pants					//add it to client's screen
		update_observer_view(wear_pants,1)
		var/datum/species/species = dna?.species
		var/legsindex = get_limbloss_index(LEG_RIGHT, LEG_LEFT)
		var/use_female_sprites = FALSE
		if(species?.sexes)
			if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
				use_female_sprites = FEMALE_SPRITES
		var/list/offsets
		if(use_female_sprites)
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
		else
			offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m
		var/racecustom
		if(species?.custom_clothes)
			if(species.custom_id)
				racecustom = species.custom_id
			else
				racecustom = species.id
		var/mutable_appearance/pants_overlay = wear_pants.build_worn_icon(age, PANTS_LAYER, coom = use_female_sprites, customi = racecustom, sleeveindex = legsindex)

		if(LAZYACCESS(offsets, OFFSET_PANTS))
			pants_overlay.pixel_x += offsets[OFFSET_PANTS][1]
			pants_overlay.pixel_y += offsets[OFFSET_PANTS][2]
		overlays_standing[PANTS_LAYER] = pants_overlay

		//add sleeve overlays, then offset
		var/list/sleeves = list()
		var/femw = use_female_sprites ? "_f" : ""
		if(wear_pants.sleeved && legsindex > 0 && wear_pants.adjustable != CADJUSTED)
			sleeves = get_sleeves_layer(wear_pants,legsindex, LEGSLEEVE_LAYER)
		if(wear_pants.adjustable == CADJUSTED)
			var/mutable_appearance/overleg = mutable_appearance(wear_pants.mob_overlay_icon, "[wear_pants.icon_state][femw][racecustom ? "_[racecustom]" : ""]", -LEGSLEEVE_LAYER)
			sleeves += overleg
		if(sleeves)
			for(var/mutable_appearance/S as anything in sleeves)
				if(LAZYACCESS(offsets, OFFSET_PANTS))
					S.pixel_x += offsets[OFFSET_PANTS][1]
					S.pixel_y += offsets[OFFSET_PANTS][2]
			overlays_standing[LEGSLEEVE_LAYER] = sleeves

	update_body()

	apply_overlay(PANTS_LAYER)
	apply_overlay(LEGSLEEVE_LAYER)

/mob/living/carbon/human/update_inv_mouth()
	remove_overlay(MOUTH_LAYER)

	if(!get_bodypart(BODY_ZONE_HEAD)) //Decapitated
		return

	if(client && hud_used)
		var/atom/movable/screen/inventory/inv = hud_used.inv_slots[TOBITSHIFT(ITEM_SLOT_MOUTH) + 1]
		inv?.update_appearance(UPDATE_ICON_STATE)

	if(mouth)
		update_hud_mouth(mouth)
		if(!(ITEM_SLOT_MOUTH & check_obscured_slots()))
			var/datum/species/species = dna?.species
			var/use_female_sprites = FALSE
			if(species?.sexes)
				if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
					use_female_sprites = FEMALE_SPRITES
			var/list/offsets
			if(use_female_sprites)
				offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
			else
				offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m
			var/mutable_appearance/mouth_overlay = mouth.build_worn_icon(age, MOUTH_LAYER, 'icons/roguetown/clothing/onmob/mouth_items.dmi')
			if(mouth_overlay)
				if(LAZYACCESS(offsets, OFFSET_MOUTH))
					mouth_overlay.pixel_x += offsets[OFFSET_MOUTH][1]
					mouth_overlay.pixel_y += offsets[OFFSET_MOUTH][2]
				overlays_standing[MOUTH_LAYER] = mouth_overlay

	apply_overlay(MOUTH_LAYER)

//endrogue


/mob/living/carbon/human/update_inv_legcuffed()
	remove_overlay(LEGCUFF_LAYER)
	clear_alert("legcuffed")
	if(legcuffed)
		overlays_standing[LEGCUFF_LAYER] = mutable_appearance('icons/roguetown/mob/bodies/cuffed.dmi', "[legcuffed.name]down", -LEGCUFF_LAYER)
		apply_overlay(LEGCUFF_LAYER)
		throw_alert("legcuffed", /atom/movable/screen/alert/restrained/legcuffed, new_master = src.legcuffed)

/proc/wear_female_version(t_color, icon, layer, type)
	var/index = t_color
	var/icon/female_clothing_icon = GLOB.female_clothing_icons[index]
	if(!female_clothing_icon) 	//Create standing/laying icons if they don't exist
		generate_female_clothing(index,t_color,icon,type)
	return mutable_appearance(GLOB.female_clothing_icons[t_color], layer = -layer)

/proc/wear_dismembered_version(t_color, icon, layer, sleeveindex, type)
	var/index = "[t_color][sleeveindex]"
	var/icon/clothing_icon = GLOB.dismembered_clothing_icons[index]
	if(!clothing_icon) 	//Create standing/laying icons if they don't exist
		generate_dismembered_clothing(index,t_color,icon,sleeveindex, type)
	return mutable_appearance(GLOB.dismembered_clothing_icons[index], layer = -layer)


/mob/living/carbon/human/proc/get_overlays_copy(list/unwantedLayers)
	var/list/out = new
	for(var/i in 1 to TOTAL_LAYERS)
		if(overlays_standing[i])
			if(i in unwantedLayers)
				continue
			out += overlays_standing[i]
	return out


//human HUD updates for items in our inventory

//update whether our head item appears on our hud.
/mob/living/carbon/human/update_hud_head(obj/item/I)
	I.screen_loc = rogueui_head
	if(client && hud_used?.hud_shown)
		if(hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

//update whether our mask item appears on our hud.
/mob/living/carbon/human/update_hud_wear_mask(obj/item/I)
	I.screen_loc = rogueui_mask
	if(client && hud_used?.hud_shown)
		if(hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

/mob/living/carbon/human/update_hud_mouth(obj/item/I)
	I.screen_loc = rogueui_mouth
	if(client && hud_used?.hud_shown)
		if(hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

//update whether our neck item appears on our hud.
/mob/living/carbon/human/update_hud_neck(obj/item/I)
	I.screen_loc = rogueui_neck
	if(client && hud_used?.hud_shown)
		if(hud_used.inventory_shown)
			client.screen += I
	update_observer_view(I,1)

//update whether our back item appears on our hud.
/mob/living/carbon/human/update_hud_backr(obj/item/I)
	if(I.bigboy)
		I.screen_loc = "WEST-4:-16,SOUTH+5:-16"
	else
		I.screen_loc = rogueui_backr
	if(client && hud_used?.hud_shown)
		client.screen += I
	update_observer_view(I)

//update whether our back item appears on our hud.
/mob/living/carbon/human/update_hud_backl(obj/item/I)
	if(I.bigboy)
		I.screen_loc = "WEST-2:-16,SOUTH+5:-16"
	else
		I.screen_loc = rogueui_backl
	if(client && hud_used?.hud_shown)
		client.screen += I
	update_observer_view(I)

/*
Does everything in relation to building the /mutable_appearance used in the mob's overlays list
covers:
 * inhands and any other form of worn item
 * centering large appearances
 * layering appearances on custom layers
 * building appearances from custom icon files

By Remie Richards (yes I'm taking credit because this just removed 90% of the copypaste in update_icons())

state: A string to use as the state, this is FAR too complex to solve in this proc thanks to shitty old code
so it's specified as an argument instead.

default_layer: The layer to draw this on if no other layer is specified

default_icon_file: The icon file to draw states from if no other icon file is specified

isinhands: If true then alternate_worn_icon is skipped so that default_icon_file is used,
in this situation default_icon_file is expected to match either the lefthand_ or righthand_ file var

femalueuniform: A value matching a uniform item's fitted var, if this is anything but NO_FEMALE_UNIFORM, we
generate/load female uniform sprites matching all previously decided variables


*/
/obj/item/proc/build_worn_icon(age = AGE_ADULT, default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, coom = FALSE, customi = null, sleeveindex)
	var/t_state
	var/sleevejazz = sleevetype
	if(age == AGE_CHILD)
		coom = FALSE
	if(override_state)
		t_state = override_state
	else if(isinhands && item_state)
		t_state = item_state
	else if(coom)
		t_state = icon_state + "_f"
		if(sleevejazz)
			sleevejazz += "_f"
	else
		t_state = icon_state
	if(customi)
		t_state += "_[customi]"
		if(sleevejazz)
			sleevejazz += "_[customi]"
	var/t_icon = mob_overlay_icon
	if(age == AGE_CHILD)
		if(!istype(src, /obj/item/clothing/head) && !istype(src, /obj/item/clothing/face) && !istype(src, /obj/item/clothing/cloak) && !istype(src, /obj/item/clothing/gloves) && !istype(src, /obj/item/clothing/neck))
			t_state += "_child"
	if(!t_icon)
		t_icon = default_icon_file

	//Find a valid icon file from variables+arguments
	var/file2use
	if(!isinhands && mob_overlay_icon)
		file2use = mob_overlay_icon
	if(!file2use)
		file2use = default_icon_file

	//Find a valid layer from variables+arguments
	var/layer2use
	if(alternate_worn_layer)
		layer2use = alternate_worn_layer
	if(!layer2use)
		layer2use = default_layer

	if(r_sleeve_status == SLEEVE_TORN || r_sleeve_status == SLEEVE_ROLLED)
		if(sleeveindex == 4 || sleeveindex == 2)
			sleeveindex -= 1
	if(l_sleeve_status == SLEEVE_TORN || l_sleeve_status == SLEEVE_ROLLED)
		if(sleeveindex == 4 || sleeveindex == 3)
			sleeveindex -= 2

	var/mutable_appearance/standing
//	if(femaleuniform)
//		standing = wear_female_version(t_state,file2use,layer2use,femaleuniform)
	if(sleeved && sleevejazz && sleeveindex < 4) //cut out sleeves from north/south sprites
		if(!nodismemsleeves)
			standing = wear_dismembered_version(t_state,file2use,layer2use,sleeveindex,sleevejazz)
		else
			sleeveindex = 4
	if(!standing)
		standing = mutable_appearance(file2use, t_state, -layer2use)

	//Get the overlays for this item when it's being worn
	//eg: ammo counters, primed grenade flashes, etc.
	var/mob/mob_type = loc
	var/list/worn_overlays = worn_overlays(standing, isinhands, file2use, dummy_block = istype(mob_type, /mob/living/carbon/human/dummy))
	if(worn_overlays && worn_overlays.len)
//		for(var/mutable_appearance/MA in worn_overlays)
//			MA.blend_mode = BLEND_MULTIPLY
		standing.overlays.Add(worn_overlays)
	var/do_boob = (coom == FEMALE_BOOB && boobed)
	if(!isinhands && do_boob)
		var/mutable_appearance/boob_overlay = mutable_appearance(file2use, "[t_state]_boob", -layer2use)
		standing.overlays.Add(boob_overlay)

	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(file2use, "[t_state][get_detail_tag()]"), -layer2use)
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		standing.overlays.Add(pic)
		if(!isinhands && do_boob)
			pic = mutable_appearance(icon(file2use, "[t_state]_boob[get_detail_tag()]"), -layer2use)
			pic.appearance_flags = RESET_COLOR
			if(get_detail_color())
				pic.color = get_detail_color()
			standing.overlays.Add(pic)

	if(!isinhands && GET_ATOM_BLOOD_DNA_LENGTH(src))
		var/index = "[t_state][sleeveindex]"
		var/static/list/bloody_onmob = list()
		var/icon/clothing_icon = bloody_onmob["[index][(coom == "f") ? "_boob" : ""]"]
		if(!clothing_icon)
			if(sleeved && sleeveindex < 4) //cut out sleeves from north/south sprites
				clothing_icon = icon(GLOB.dismembered_clothing_icons[index])
			else
				clothing_icon = icon(file2use, t_state)
			if(do_boob)
				clothing_icon.Blend(icon(file2use, "[t_state]_boob"), ICON_OVERLAY)
			clothing_icon.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
			clothing_icon.Blend(icon(bloody_icon, bloody_icon_state), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
			bloody_onmob["[index][(coom == "f") ? "_boob" : ""]"] = fcopy_rsc(clothing_icon)
		var/mutable_appearance/pic = mutable_appearance(clothing_icon, -layer2use)
		standing.overlays.Add(pic)

	standing = center_image(standing, isinhands ? inhand_x_dimension : worn_x_dimension, isinhands ? inhand_y_dimension : worn_y_dimension)

	//Handle held offsets
	var/mob/M = loc
	if(istype(M))
		var/list/L = get_held_offsets()
		if(L)
			standing.pixel_x += L["x"] //+= because of center()ing
			standing.pixel_y += L["y"]

	standing.alpha = alpha
	standing.color = color

	return standing

/mob/living/carbon/proc/get_sleeves_layer(obj/item/I,sleeveindex,layer2use)
	if(!I)
		return
	var/list/sleeves = list()

	if(I.r_sleeve_status == SLEEVE_TORN || I.r_sleeve_status == SLEEVE_ROLLED)
		if(sleeveindex == 4 || sleeveindex == 2)
			sleeveindex -= 1
	if(I.l_sleeve_status == SLEEVE_TORN || I.l_sleeve_status == SLEEVE_ROLLED)
		if(sleeveindex == 4 || sleeveindex == 3)
			sleeveindex -= 2

	var/index = I.icon_state
	var/mob/living/carbon/human/HM = src
	if(istype(HM) && HM.age == AGE_CHILD)
		index += "_child"
	else if(gender == FEMALE ^ dna.species.swap_female_clothes)
		index += "_f"
	if(dna.species.custom_clothes)
		index += "_[dna.species.custom_id ? dna.species.custom_id : dna.species.id]"

	var/static/list/bloody_r = list()
	var/static/list/bloody_l = list()
	if(I.nodismemsleeves && sleeveindex) //armor pauldrons that show up above arms but don't get dismembered
		sleeveindex = 4

	var/leftused = FALSE
	var/rightused = FALSE
	if(I.inhand_mod) //cloak holding icons
		for(var/obj/item/H in held_items)
			var/rightorleft
			rightorleft = get_held_index_of_item(H) % 2
			if(rightorleft == 0)
				rightused = TRUE
			else
				leftused = TRUE

	if(sleeveindex == 2 || sleeveindex == 4 || !sleeveindex)
		var/used = "r_[index]"
		if(!sleeveindex)
			if(rightused)
				used = "xr_[index]"
		var/mutable_appearance/r_sleeve = mutable_appearance(I.sleeved, used, layer=-layer2use)
		r_sleeve.color = I.color
		r_sleeve.alpha = I.alpha
		sleeves += r_sleeve

		if(I.get_detail_tag())
			var/mutable_appearance/pic = mutable_appearance(icon(I.sleeved, "[used][I.get_detail_tag()]"), layer=-layer2use)
//			pic.appearance_flags = RESET_COLOR
			if(I.get_detail_color())
				pic.color = I.get_detail_color()
			sleeves += pic

		if(GET_ATOM_BLOOD_DNA_LENGTH(I))
			var/icon/blood_overlay = bloody_r[used]
			if(!blood_overlay)
				blood_overlay = icon(I.sleeved, used)
				blood_overlay.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
				blood_overlay.Blend(icon(I.bloody_icon, I.bloody_icon_state), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
				bloody_r[used] = fcopy_rsc(blood_overlay)
			var/mutable_appearance/pic = mutable_appearance(blood_overlay, layer=-layer2use)
			sleeves += pic

	if(sleeveindex == 3 || sleeveindex == 4 || !sleeveindex)
		var/used = "l_[index]"
		if(!sleeveindex)
			if(leftused)
				used = "xl_[index]"
		var/mutable_appearance/l_sleeve = mutable_appearance(I.sleeved, used, layer=-layer2use)
		l_sleeve.color = I.color
		l_sleeve.alpha = I.alpha
		sleeves += l_sleeve

		if(I.get_detail_tag())
			var/mutable_appearance/pic = mutable_appearance(icon(I.sleeved, "[used][I.get_detail_tag()]"), layer=-layer2use)
//			pic.appearance_flags = RESET_COLOR
			if(I.get_detail_color())
				pic.color = I.get_detail_color()
			sleeves += pic

		if(GET_ATOM_BLOOD_DNA_LENGTH(I))
			var/icon/blood_overlay = bloody_l[used]
			if(!blood_overlay)
				blood_overlay = icon(I.sleeved, used)
				blood_overlay.Blend("#fff", ICON_ADD) 			//fills the icon_state with white (except where it's transparent)
				blood_overlay.Blend(icon(I.bloody_icon, I.bloody_icon_state), ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
				bloody_l[used] = fcopy_rsc(blood_overlay)
			var/mutable_appearance/pic = mutable_appearance(blood_overlay, layer=-layer2use)
			sleeves += pic

	return sleeves


/obj/item/proc/get_held_offsets()
	var/list/L
	if(ismob(loc))
		var/mob/M = loc
		L = M.get_item_offsets_for_index(M.get_held_index_of_item(src))
	return L


//Can't think of a better way to do this, sadly
/mob/proc/get_item_offsets_for_index(i)
	switch(i)
		if(3) //odd = left hands
			return list("x" = 0, "y" = 16)
		if(4) //even = right hands
			return list("x" = 0, "y" = 16)
		else //No offsets or Unwritten number of hands
			return list("x" = 0, "y" = 0)//Handle held offsets

//produces a key based on the human's limbs
/mob/living/carbon/human/generate_icon_render_key()
	. = list(dna.species.limbs_id)
	if(dna.species.use_skintones)
		. += "coloured"
		. += skin_tone
	else
		. += "not_coloured"

	. += gender
	. += age

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		. += BP.body_zone
		if(BP.status == BODYPART_ORGANIC)
			. += "organic"
		else
			. += "robotic"
		if(BP.rotted)
			. += "rotted"
		if(BP.skeletonized)
			. += "skeletonized"
		if(BP.dmg_overlay_type)
			. += BP.dmg_overlay_type

		for(var/datum/bodypart_feature/feature as anything in BP.bodypart_features)
			. += feature.accessory_type
			. += feature.accessory_colors

	if(HAS_TRAIT(src, TRAIT_HUSK))
		. += "husk"
	return jointext(., "-")

/mob/living/carbon/human/load_limb_from_cache()
	..()
	update_body()



/mob/living/carbon/human/proc/update_observer_view(obj/item/I, inventory)
	if(observers && observers.len)
		for(var/mob/dead/observe as anything in observers)
			if(observe.client && observe.client.eye == src)
				if(observe.hud_used)
					if(inventory && !observe.hud_used.inventory_shown)
						continue
					observe.client.screen += I
			else
				observers -= observe
				if(!observers.len)
					observers = null
					break

/mob/living/carbon/human/update_body_parts(redraw = FALSE)
	//CHECK FOR UPDATE
	var/oldkey = icon_render_key
	icon_render_key = generate_icon_render_key()
	if(oldkey == icon_render_key && !redraw)
		return

	remove_overlay(BODYPARTS_LAYER)

	for(var/obj/item/bodypart/BP as anything in bodyparts)
		BP.update_limb()

	//LOAD ICONS
	if(!redraw)
		if(limb_icon_cache[icon_render_key])
			load_limb_from_cache()
			return

	//GENERATE NEW LIMBS
	var/list/new_limbs = list()
	var/hideboob = FALSE //used to tell if we should hide boobs, basically
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(BP.body_zone == BODY_ZONE_CHEST)
			if(wear_armor?.flags_inv & HIDEBOOB)
				hideboob = TRUE
			if(wear_shirt?.flags_inv & HIDEBOOB)
				hideboob = TRUE
			if(cloak?.flags_inv & HIDEBOOB)
				hideboob = TRUE
			new_limbs += BP.get_limb_icon(hideaux = hideboob)
		else
			new_limbs += BP.get_limb_icon()
	if(new_limbs.len)
		overlays_standing[BODYPARTS_LAYER] = new_limbs
		limb_icon_cache[icon_render_key] = new_limbs

	apply_overlay(BODYPARTS_LAYER)
	update_damage_overlays()

/mob/proc/update_body_parts_head_only()
	return

// Only renders the head of the human
/mob/living/carbon/human/update_body_parts_head_only()
	if (!dna)
		return

	if (!dna.species)
		return

	var/obj/item/bodypart/HD = get_bodypart("head")

	if(!istype(HD))
		return

	var/datum/species/species = dna?.species

	var/use_female_sprites = MALE_SPRITES
	if(species.sexes)
		if(gender == FEMALE && !species.swap_female_clothes || gender == MALE && species.swap_male_clothes)
			use_female_sprites = FEMALE_SPRITES

	var/list/offsets
	if(use_female_sprites)
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_f
	else
		offsets = (age == AGE_CHILD) ? species.offset_features_child : species.offset_features_m

	HD.update_limb()

	add_overlay(HD.get_limb_icon())
	update_damage_overlays()

	if(HD && !(HAS_TRAIT(src, TRAIT_HUSK)))
		// lipstick
		if(lip_style && (LIPS in species.species_traits))
			var/mutable_appearance/lip_overlay = mutable_appearance('icons/mob/human_face.dmi', "lips_[lip_style]", -BODY_LAYER)
			lip_overlay.color = lip_color
			if(LAZYACCESS(offsets, OFFSET_FACE))
				lip_overlay.pixel_x += offsets[OFFSET_FACE][1]
				lip_overlay.pixel_y += offsets[OFFSET_FACE][2]
			add_overlay(lip_overlay)

	update_inv_head()
	update_inv_wear_mask()
	update_inv_mouth()

/mob/living/carbon/human/proc/update_smell(smelly_icon = "generic_mob_smell")
	remove_overlay(SMELL_LAYER)
	if(hygiene == HYGIENE_LEVEL_DISGUSTING) //You have literally ignored your stank for so long that you physically can't get dirtier.
		var/mutable_appearance/new_smell_overlay = mutable_appearance('icons/mob/smelly.dmi', smelly_icon, -SMELL_LAYER)
		overlays_standing[SMELL_LAYER] = new_smell_overlay
		apply_overlay(SMELL_LAYER)
