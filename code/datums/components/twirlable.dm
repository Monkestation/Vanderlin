/obj/effect/twirl_overlay
	vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/component/twirlable
	var/twirling = FALSE
	var/twirl_time = 3
	var/twirl_sound = 'sound/combat/parry/wood/parrywood (1).ogg'
	var/pivot_x = -8
	var/pivot_y = -2

/datum/component/twirlable/Initialize(_twirl_time, _twirl_sound, _pivot_x, _pivot_y)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(_twirl_time)
		twirl_time = _twirl_time
	if(_twirl_sound)
		twirl_sound = _twirl_sound
	if(!isnull(_pivot_x))
		pivot_x = _pivot_x
	if(!isnull(_pivot_y))
		pivot_y = _pivot_y

	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF_SECONDARY, PROC_REF(on_attack_self))

/datum/component/twirlable/proc/get_spin_matrix(angle, mob/living/carbon/user, obj/item/I)
	var/flipsprite = !(user.get_held_index_of_item(I) % 2 == 0)

	var/px = pivot_x
	var/py = pivot_y

	if(flipsprite)
		px = -px

	switch(user.dir)
		if(NORTH)
			py = -py
		if(EAST)
			px = 0

	var/matrix/M = matrix()
	if(px || py)
		M.Translate(-px, -py)
	M.Turn(angle)
	if(px || py)
		M.Translate(px, py)
	return M

/datum/component/twirlable/proc/finish_twirl(obj/item/I, mob/living/carbon/user, obj/effect/twirl_overlay/vis_obj)
	REMOVE_TRAIT(I, TRAIT_TWIRLING, REF(src))
	twirling = FALSE

	if(vis_obj)
		if(user)
			user.vis_contents -= vis_obj
		qdel(vis_obj)

	if(user)
		user.update_inv_hands()

/datum/component/twirlable/proc/on_attack_self(obj/item/I, mob/living/carbon/user)
	SIGNAL_HANDLER
	if(twirling || !user || HAS_TRAIT(I, TRAIT_WIELDED))
		return

	twirling = TRUE
	ADD_TRAIT(I, TRAIT_TWIRLING, REF(src))

	if(twirl_sound)
		playsound(user, twirl_sound, 50, TRUE)

	var/step_delay = twirl_time / 3
	var/matrix/M1 = get_spin_matrix(120, user, I)
	var/matrix/M2 = get_spin_matrix(240, user, I)
	var/matrix/M3 = matrix()

	animate(I, transform = M1, time = step_delay, flags = ANIMATION_END_NOW)
	animate(transform = M2, time = step_delay)
	animate(transform = M3, time = step_delay)

	var/obj/effect/twirl_overlay/vis_obj = new(user)

	var/mutable_appearance/hand_appearance = build_inhand_appearance(I, user)
	if(hand_appearance)
		vis_obj.appearance = hand_appearance
		vis_obj.layer = user.layer + 0.01
		user.vis_contents += vis_obj

		animate(vis_obj, transform = M1, time = step_delay, flags = ANIMATION_END_NOW)
		animate(transform = M2, time = step_delay)
		animate(transform = M3, time = step_delay)

	user.update_inv_hands()

	addtimer(CALLBACK(src, PROC_REF(finish_twirl), I, user, vis_obj), twirl_time)
	return ITEM_INTERACT_SUCCESS

/datum/component/twirlable/proc/build_inhand_appearance(obj/item/I, mob/living/carbon/user)
	var/used_prop = "gen"
	if(I.altgripped)
		used_prop = "altgrip"
	else if(HAS_TRAIT(I, TRAIT_WIELDED))
		used_prop = "wielded"

	var/list/prop = I.getonmobprop(used_prop)
	if(!prop)
		return null

	var/flipsprite = !(user.get_held_index_of_item(I) % 2 == 0)

	var/is_behind = (user.dir & NORTH) ? TRUE : FALSE
	var/target_layer = is_behind ? -HANDS_LAYER : -HANDS_LAYER

	var/mutable_appearance/inhand = mutable_appearance(I.getmoboverlay(used_prop, prop, behind = is_behind, mirrored = flipsprite), layer = target_layer)
	inhand = center_image(inhand, I.inhand_x_dimension, I.inhand_y_dimension)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/species/species = H.dna?.species
		if(species)
			var/use_female = (H.gender == FEMALE && !species.swap_female_clothes) || (H.gender == MALE && species.swap_male_clothes)
			var/list/offsets = (H.age == AGE_CHILD) ? species.offset_features_child : (use_female ? species.offset_features_f : species.offset_features_m)
			if(LAZYACCESS(offsets, OFFSET_HANDS))
				inhand.pixel_x += offsets[OFFSET_HANDS][1]
				inhand.pixel_y += offsets[OFFSET_HANDS][2]

	return inhand
