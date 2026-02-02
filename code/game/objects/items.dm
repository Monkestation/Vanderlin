GLOBAL_DATUM_INIT(fire_overlay, /mutable_appearance, mutable_appearance('icons/effects/fire.dmi', "fire"))

// if true, everyone item when created will have its name changed to be
// more... RPG-like.

/obj/item
	name = "item"
	icon = 'icons/obj/items_and_weapons.dmi'
	pass_flags_self = PASSITEM
	pass_flags = PASSTABLE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	///icon state name for inhand overlays
	var/item_state = null
	///Icon file for left hand inhand overlays
	var/lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	///Icon file for right inhand overlays
	var/righthand_file = 'icons/mob/inhands/items_righthand.dmi'

	///Icon file for mob worn overlays.
	///no var for state because it should *always* be the same as icon_state
	var/icon/mob_overlay_icon
	//Forced mob worn layer instead of the standard preferred ssize.
	var/alternate_worn_layer

	//Dimensions of the icon file used when this item is worn, eg: hats.dmi
	//eg: 32x32 sprite, 64x64 sprite, etc.
	//allows inhands/worn sprites to be of any size, but still centered on a mob properly
	var/worn_x_dimension = 32
	var/worn_y_dimension = 32
	//Same as above but for inhands, uses the lefthand_ and righthand_ file vars
	var/inhand_x_dimension = 64
	var/inhand_y_dimension = 64

	var/no_effect = FALSE

	max_integrity = 200

	obj_flags = NONE
	var/item_flags = NONE

	var/list/hitsound
	///Played when the item is used, for example tools
	var/usesound
	// Sound used when this item, when thrown, hits a mob.
	var/mob_throw_hit_sound
	///Sound used when equipping the item into a valid slot
	var/equip_sound = null
	///Sound used when picking the item up (putting it on your hands)
	var/pickup_sound = "rustle"
	///Sound used when dropping the item, or when it's thrown.
	var/drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	///Whether or not we use stealthy audio levels for this item's attack sounds
	var/stealthy_audio = FALSE

	// Sound used when being placed on a table
	var/place_sound = 'sound/foley/dropsound/gen_drop.ogg'
	var/list/swingsound = PUNCHWOOSH
	var/list/parrysound = "parrywood"
	var/w_class = WEIGHT_CLASS_NORMAL
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	var/obj/item/master = null

	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN Celcius) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN Celcius) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	// List of /datum/action's that this item has.
	var/list/datum/action/actions
	// List of paths of action datums to give to the item on New().
	var/list/actions_types
	///Slot flags in which this item grants actions. If null, defaults to the item's slot flags (so actions are granted when worn)
	var/action_slots = null

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	//These flags are used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/flags_inv
	// You can see someone's mask through their transparent visor, but you can't reach it
	var/transparent_protection = NONE

	var/interaction_flags_item = INTERACT_ITEM_ATTACK_HAND_PICKUP

	// Takes bitflags. See setup.dm for appropriate bit flags
	var/body_parts_covered = 0
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/surgery_cover = TRUE // binary, whether this item is considered covering its bodyparts in respect to surgery. Tattoos, etc. are false.
	// How much clothing is slowing you down. Negative values speeds you up
	var/slowdown = 0
	// Value of armour effectiveness to remove. Since armor values can go over 100, this is no longer a percentage.
	var/armor_penetration = 0
	var/list/allowed = null //suit storage stuff.
	// In deciseconds, how long an item takes to equip; counts only for normal clothing slots, not pockets etc.
	var/equip_delay_self = 1
	// In deciseconds, how long does it take for us to take off a piece of clothing or equipment. Normally will have same value as equip_delay_self
	var/unequip_delay_self = 1
	/// Boolean. If true, can be moving while equipping (for helmets etc)
	var/edelay_type = TRUE
	// In deciseconds, how long an item takes to be put on another person via the undressing menu.
	var/equip_delay_other = 20
	//In deciseconds, how long an item takes to remove from another person via the undressing menu.
	var/strip_delay = 40
	var/breakouttime = 0 // greater than 15 str get this isnstead
	var/slipouttime = 0

	var/list/attack_verb //Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]"
	var/list/species_exception = null	// list() of species types, if a species cannot put items in a certain slot, but species type is in list, it will be able to wear that item

	var/mob/thrownby = null

	mouse_drag_pointer = MOUSE_ACTIVE_POINTER //the icon to indicate this object is being dragged

	var/datum/embedding_behavior/embedding
	var/is_embedded = FALSE

	var/flags_cover = 0 //for flags such as GLASSESCOVERSEYES
	var/heat = 0
	// All items with sharpness of IS_SHARP (1) or higher will automatically get the butchering component. See combat.dm for defines.
	var/sharpness = IS_BLUNT

	var/tool_behaviour = NONE
	var/toolspeed = 1

	var/block_chance = 0
	//If you want to have something unrelated to blocking/armour piercing etc. Maybe not needed, but trying to think ahead/allow more freedom
	var/hit_reaction_chance = 0

	//The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
	var/list/slot_equipment_priority = null // for default list, see /mob/proc/equip_to_appropriate_slot()

	// Needs to be in /obj/item because corgis can wear a lot of
	// non-clothing items
	var/datum/dog_fashion/dog_fashion = null

	//Tooltip vars
	var/force_string //string form of an item's force. Edit this var only to set a custom force string
	var/last_force_string_check = 0
	var/tip_timer

	var/trigger_guard = TRIGGER_GUARD_NONE

	// Used as the dye color source in the washing machine only (at the moment). Can be a hex color or a key corresponding to a registry entry, see washing_machine.dm
	var/dye_color
	// Whether the item is unaffected by standard dyeing.
	var/undyeable = FALSE
	// What dye registry should be looked at when dying this item; see washing_machine.dm
	var/dying_key

	//Grinder vars
	//A reagent list containing the reagents this item produces when ground up in a grinder - this can be an empty list to allow for reagent transferring only
	var/list/grind_results
	//A list of reagents produced when choosing to juice this item on a grinder
	var/list/juice_results

	var/canMouseDown = FALSE
	var/can_parry = FALSE
	var/associated_skill

	var/list/possible_item_intents = list(/datum/intent/use)

	// Used to center screen_loc when in hand
	var/bigboy = FALSE
	/// Value of force_wielded of two_handed component. Only used when initializing.
	var/force_wielded = 0
	var/list/gripped_intents //intents while gripped, replacing main intents

	var/altgripped = FALSE
	var/list/alt_intents //these replace main intents
	var/gripsprite = FALSE //use alternate grip sprite for inhand
	var/gripspriteonmob = FALSE //use alternate sprite for onmob

	/// Item will be scaled by this factor when on the ground.
	var/dropshrink = 0

	var/wlength = WLENGTH_NORMAL		//each weapon length class has its own inherent dodge properties
	var/wbalance = 0
	var/wdefense = 0					//Flat bonus to defense
	var/wdodgebonus = 0					//Bonus for dodging
	var/wparrybonus = 0					//Bonus to parrying
	var/wparryspeed = 0					//Minor reduction in parry cooldown time, for
	var/minstr = 0						//for weapons

	var/sleeved = null
	var/sleevetype = null
	var/nodismemsleeves = FALSE
	var/inhand_mod = FALSE
	var/r_sleeve_status = SLEEVE_NOMOD //SLEEVE_TORN or SLEEVE_ROLLED
	var/l_sleeve_status = SLEEVE_NOMOD
	var/r_sleeve_zone = BODY_ZONE_R_ARM
	var/l_sleeve_zone = BODY_ZONE_L_ARM

	var/bloody_icon = 'icons/effects/blood.dmi'
	var/bloody_icon_state = "itemblood"
	var/boobed = FALSE

	// Time in deciseconds this item adds to var/fueluse for a /obj/machinery/light/fueled type when fed to it.
	var/firefuel = 0 //add this idiot

	var/thrown_bclass = BCLASS_BLUNT

	var/icon/experimental_inhand = TRUE
	var/icon/experimental_onhip = FALSE
	var/icon/experimental_onback = FALSE

	// Trying to emote or talk with this in our mouth makes us muffled
	var/muteinmouth = TRUE
	// Using spit emote spits the item out of our mouth and falls out after some time
	var/spitoutmouth = TRUE

	var/has_inspect_verb = FALSE

	// Takes a skill path. Which skill we use to repair this item when hitting it with a blacksmith hammer?
	var/anvilrepair
	// Boolean. If TRUE, this item can be repaired using a needle.
	var/sewrepair
	// Boolean. sewrepair normally dictates dyeing, this is an override for non-sewn items to be dyeable.
	// In the future this might deserve its own refactor.
	var/dyeable

	var/breakpath

	var/mailer = null
	var/mailedto = null

	var/list/examine_effects = list()

	var/list/blocksound //played when an item that is equipped blocks a hit

	/// A lazylist to store inhands data.
	var/list/onprop
	var/damage_type = "blunt"
	var/force_reupdate_inhand = TRUE

	var/last_used = 0

	// Boolean sanity var for smelteries to avoid runtimes. Is this is a bar smelted through ore for exp gain?
	var/smelted = FALSE
	// Can this be used against a training dummy to learn skills? Prevents dumb exploits.
	var/istrainable = FALSE

	/// This is what we get when we either tear up or salvage a piece of clothing
	var/obj/item/salvage_result = null
	/// The amount of salvage we get out of salvaging with scissors
	var/salvage_amount = 0 //This will be more accurate when sewing recipes get sorted
	/// Temporary snowflake var to be used in the rare cases clothing doesn't require fibers to sew, to avoid material duping
	var/fiber_salvage = FALSE
	/// Number of torn sleves, important for salvaging calculations and examine text
	var/torn_sleeve_number = 0

	var/blocking_behavior
	var/wetness = 0
	var/block2add
	var/detail_tag
	var/detail_color


	// ~Grid INVENTORY VARIABLES
	/// Width we occupy on the hud - Keep null to generate based on w_class
	var/grid_width
	/// Height we occupy on the hud - Keep null to generate based on w_class
	var/grid_height
	///our melting material, basically if exists this is what we melt into in a crucible
	var/datum/material/melting_material
	///our metling amount
	var/melt_amount = 0
	///our current in progress slapcraft
	var/datum/orderless_slapcraft/in_progress_slapcraft
	///these are flags of what tools can interact with this atom useful to stop hard coding interactions
	var/tool_flags = NONE

	var/list/attunement_values
	///this is in KG
	var/item_weight = 0
	///this is a multiplier to the weight of items inside of this items contents
	var/carry_multiplier = 1

	/// Artificers Recipe
	var/datum/artificer_recipe/artrecipe

	/// angle of the icon, these are used for attack animations
	var/icon_angle = 50 // most of our icons are angled
	///the processing quality we have
	var/recipe_quality = 1

	// Lock related

	// This sucks but I can see it being useful
	/// This thing can be used to unlock locks
	var/can_unlock = TRUE

	///do we block the offhand while wielding
	var/wield_block = TRUE

/obj/item/proc/set_quality(quality)
	recipe_quality = clamp(quality, 0, 4)
	update_appearance(UPDATE_OVERLAYS)
	if(recipe_quality >= 3) // gold tier and above
		AddComponent(/datum/component/particle_spewer/sparkle)
	else
		var/datum/component/particle_spewer = GetComponent(/datum/component/particle_spewer/sparkle)
		if(particle_spewer)
			particle_spewer.RemoveComponent()

/obj/item/update_overlays()
	. = ..()
	//details tags for items/clothes
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon, "[icon_state][detail_tag]")
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		. += pic

	// Add quality overlay to the food item
	if(recipe_quality <= 0 || !ismob(loc))
		return
	var/list/quality_icons = list(
		null, // Regular has no overlay
		// "bronze",
		"silver",
		"gold",
		"diamond",
	)
	if(recipe_quality <= length(quality_icons) && quality_icons[recipe_quality])
		. += mutable_appearance('icons/effects/crop_quality.dmi', quality_icons[recipe_quality])

/**
 * Handles adding components to the item. Added in Initialize()
 *
 * Added as a seperate proc to allow for specific behavior
 */
/obj/item/proc/apply_components()
	if(force_wielded || gripped_intents)
		var/wielded_force = force_wielded ? force_wielded : force
		AddComponent(/datum/component/two_handed, force_unwielded = force, force_wielded = wielded_force, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)), wield_block_offhand = wield_block)

/obj/item/proc/get_detail_tag() //this is for extra layers on clothes or items
	return detail_tag

/obj/item/proc/get_detail_color() //this is for extra layers on clothes or items
	return detail_color

/// Handles sprite changes and decals
/obj/item/proc/update_transform()
	transform = null
	if(dropshrink)
		if(isturf(loc))
			var/matrix/M = matrix()
			M.Scale(dropshrink,dropshrink)
			transform = M
	if(ismob(loc))
		if(altgripped)
			if(gripsprite)
				icon_state = "[initial(icon_state)]1"
				var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
				if(B)
					B.remove()
					B.generate_appearance()
					B.apply()
			return
		if(HAS_TRAIT(src, TRAIT_WIELDED))
			if(gripsprite)
				icon_state = "[initial(icon_state)]1"
				var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
				if(B)
					B.remove()
					B.generate_appearance()
					B.apply()
			if(gripspriteonmob)
				item_state = "[initial(icon_state)]_wield"
				var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
				if(B)
					B.remove()
					B.generate_appearance()
					B.apply()
			return
		if(gripsprite)
			icon_state = initial(icon_state)
			var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
			if(B)
				B.remove()
				B.generate_appearance()
				B.apply()
		if(gripspriteonmob)
			item_state = initial(icon_state)
			var/datum/component/decal/blood/B = GetComponent(/datum/component/decal/blood)
			if(B)
				B.remove()
				B.generate_appearance()
				B.apply()

/obj/item/Initialize(mapload)
	if (attack_verb)
		attack_verb = typelist("attack_verb", attack_verb)

	if(experimental_inhand)
		var/props2gen = list("gen")
		var/list/prop
		if(force_wielded || gripped_intents)
			props2gen += "wielded"
		for(var/i in props2gen)
			prop = getonmobprop(i)
			if(prop)
				getmoboverlay(i,prop,behind=FALSE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=FALSE,mirrored=TRUE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=TRUE)

	if(experimental_onhip)
		if(slot_flags & ITEM_SLOT_BELT)
			var/i = "onbelt"
			var/list/prop = getonmobprop(i)
			if(prop)
				getmoboverlay(i,prop,behind=FALSE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=FALSE,mirrored=TRUE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=TRUE)

	if(experimental_onback)
		if(slot_flags & ITEM_SLOT_BACK)
			var/i = "onback"
			var/list/prop = getonmobprop(i)
			if(prop)
				getmoboverlay(i,prop,behind=FALSE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=FALSE)
				getmoboverlay(i,prop,behind=FALSE,mirrored=TRUE)
				getmoboverlay(i,prop,behind=TRUE,mirrored=TRUE)

	. = ..()
	// Handle adding item associated actions
	for(var/path in actions_types)
		add_item_action(path)

	actions_types = null

	if(force_string)
		item_flags |= FORCE_STRING_OVERRIDE

	if(!hitsound)
		if(damtype == "fire")
			hitsound = list('sound/blank.ogg')
		if(damtype == "brute")
			hitsound = list("swing_hit")

	if (!embedding)
		embedding = getEmbeddingBehavior()
	else if (islist(embedding))
		embedding = getEmbeddingBehavior(arglist(embedding))
	else if (!istype(embedding, /datum/embedding_behavior))
		stack_trace("Invalid type [embedding.type] found in .embedding during /obj/item Initialize()")

	if(sharpness) //give sharp objects butchering functionality, for consistency
		AddComponent(/datum/component/butchering, 80 * toolspeed)
	else
		max_blade_int = 0
		blade_int = 0

	if(max_blade_int && !blade_int) //set blade integrity to randomized 60% to 100% if not already set
		blade_int = max_blade_int + rand(-(max_blade_int * 0.4), 0)

	if(!pixel_x && !pixel_y && !bigboy)
		pixel_x = rand(-5,5)
		pixel_y = rand(-5,5)

	// Initalize addon for the var for custom inhands 32x32.
	if(!experimental_inhand)
		inhand_x_dimension = 32
		inhand_y_dimension = 32

	if(grid_width <= 0)
		grid_width = (w_class * world.icon_size)
	if(grid_height <= 0)
		grid_height = (w_class * world.icon_size)

	if(uses_lord_coloring)
		if(GLOB.lordprimary && GLOB.lordsecondary)
			lordcolor()
		else
			RegisterSignal(SSdcs, COMSIG_LORD_COLORS_SET, TYPE_PROC_REF(/obj/item, lordcolor))
	else if(get_detail_color()) // Lord color does this
		update_appearance(UPDATE_OVERLAYS)

	update_transform()
	apply_components()

/obj/item/Destroy()
	item_flags &= ~DROPDEL	//prevent reqdels
	if(ismob(loc))
		var/mob/m = loc
		m.temporarilyRemoveItemFromInventory(src, TRUE)

	// Handle cleaning up our actions list
	for(var/datum/action/action as anything in actions)
		remove_item_action(action)

	if(is_embedded)
		if(isbodypart(loc))
			var/obj/item/bodypart/embedded_part = loc
			embedded_part.remove_embedded_object(src)
		else if(isliving(loc))
			var/mob/living/embedded_mob = loc
			embedded_mob.simple_remove_embedded_object(src)
	if(artrecipe)
		QDEL_NULL(artrecipe)
	if(istype(loc, /obj/machinery/artificer_table))
		var/obj/machinery/artificer_table/A = loc
		A.material = null
		A.update_appearance(UPDATE_OVERLAYS)
	return ..()

/// Called when an action associated with our item is deleted
/obj/item/proc/on_action_deleted(datum/source)
	SIGNAL_HANDLER

	if(!(source in actions))
		CRASH("An action ([source.type]) was deleted that was associated with an item ([src]), but was not found in the item's actions list.")

	LAZYREMOVE(actions, source)

/// Adds an item action to our list of item actions.
/// Item actions are actions linked to our item, that are granted to mobs who equip us.
/// This also ensures that the actions are properly tracked in the actions list and removed if they're deleted.
/// Can be be passed a typepath of an action or an instance of an action.
/obj/item/proc/add_item_action(action_or_action_type)
	var/datum/action/action
	if(ispath(action_or_action_type, /datum/action))
		action = new action_or_action_type(src)
	else if(istype(action_or_action_type, /datum/action))
		action = action_or_action_type
	else
		CRASH("item add_item_action got a type or instance of something that wasn't an action.")

	LAZYADD(actions, action)
	RegisterSignal(action, COMSIG_PARENT_QDELETING, PROC_REF(on_action_deleted))
	if(ismob(loc))
		// We're being held or are equipped by someone while adding an action?
		// Then they should also probably be granted the action, given it's in a correct slot
		var/mob/holder = loc
		give_item_action(action, holder, holder.get_slot_by_item(src))

	return action

/// Removes an instance of an action from our list of item actions.
/obj/item/proc/remove_item_action(datum/action/action)
	if(!action)
		return

	UnregisterSignal(action, COMSIG_PARENT_QDELETING)
	LAZYREMOVE(actions, action)
	qdel(action)

/obj/item/proc/check_allowed_items(atom/target, not_inside, target_self)
	if(((src in target) && !target_self) || (!isturf(target.loc) && !isturf(target) && not_inside))
		return 0
	else
		return 1

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set hidden = 1
	set src in oview(1)

	if(!isturf(loc) || usr.stat != CONSCIOUS || HAS_TRAIT(usr, TRAIT_HANDS_BLOCKED))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	var/turf/T = loc
	loc = null
	loc = T

/obj/item/Topic(href, href_list)
	. = ..()

	if(href_list["inspect"])
		if(!usr.can_perform_action(src, NEED_DEXTERITY|FORBID_TELEKINESIS_REACH))
			return
		var/list/inspec = list(span_notice("PROPERTIES OF [uppertext(src.name)]"))
		get_inspect_entries(inspec)
		SEND_SIGNAL(src, COMSIG_TOPIC_INSPECT, inspec)

		to_chat(usr, examine_block("[inspec.Join()]"))

/obj/item
	var/simpleton_price = FALSE

/obj/item/get_inspect_button()
	if(has_inspect_verb || (atom_integrity < max_integrity))
		return " <span class='info'><a href='byond://?src=[REF(src)];inspect=1'>{?}</a></span>"
	return ..()

/obj/item/get_inspect_entries(list/inspect_list)
	if(!islist(inspect_list))
		inspect_list = list()

	if(minstr)
		inspect_list += "\n<b>MIN.STR:</b> [minstr]"

	if(wbalance)
		inspect_list += "\n<b>BALANCE: </b>"
		if(wbalance < 0)
			inspect_list += "Heavy"
		if(wbalance > 0)
			inspect_list += "Swift"

	if(wlength != WLENGTH_NORMAL)
		inspect_list += "\n<b>LENGTH:</b> "
		switch(wlength)
			if(WLENGTH_SHORT)
				inspect_list += "Short"
			if(WLENGTH_LONG)
				inspect_list += "Long"
			if(WLENGTH_GREAT)
				inspect_list += "Great"

//		if(eweight)
//			inspec += "\n<b>ENCUMBRANCE:</b> [eweight]"

	if(alt_intents)
		inspect_list += "\n<b>ALT-GRIPPABLE</b>"

	if(can_parry)
		inspect_list += "\n<b>PARRY:</b> [wdefense]"

	if(max_blade_int)
		inspect_list += "\n<b>SHARPNESS:</b> "
		var/meme = round(((blade_int / max_blade_int) * 100), 1)
		inspect_list += "[meme]%"

//**** General durability
	if(uses_integrity)
		inspect_list += "\n<b>DURABILITY:</b> "
		var/meme = round(((atom_integrity / max_integrity) * 100), 1)
		inspect_list += "[meme]%"

	return inspect_list

/obj/item/interact(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/item/ui_act(action, params)
	add_fingerprint(usr)
	return ..()

/obj/item/attack_hand(mob/living/user)
	. = ..()
	if(. || !user || anchored)
		return
	if(w_class == WEIGHT_CLASS_GIGANTIC)
		return
	return attempt_pickup(user)

/obj/item/proc/attempt_pickup(mob/user)
	. = TRUE
	var/mob/living/carbon/C = user
	if(C.has_status_effect(/datum/status_effect/tremor_grip_loss))
		return

	if(HAS_TRAIT(src, TRAIT_NEEDS_QUENCH))
		to_chat(user, "<span class='warning'>[src] is too hot to touch.</span>")
		return

	if(resistance_flags & ON_FIRE)
		var/can_handle_hot = FALSE
		if(!istype(C))
			can_handle_hot = TRUE
		else if(C.gloves && (C.gloves.max_heat_protection_temperature > 360))
			can_handle_hot = TRUE
		else if(HAS_TRAIT(C, TRAIT_RESISTHEAT) || HAS_TRAIT(C, TRAIT_RESISTHEATHANDS))
			can_handle_hot = TRUE

		if(can_handle_hot)
			extinguish()
			user.visible_message("<span class='warning'>[user] puts out the fire on [src].</span>")
		else
			user.visible_message("<span class='warning'>[user] burns [user.p_their()] hand putting out the fire on [src]!</span>")
			extinguish()
			var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
				C.update_damage_overlays()
			return

	if(acid_level > 20 && !ismob(loc))// so we can still remove the clothes on us that have acid.
		if(istype(C))
			if(!C.gloves || (!(C.gloves.resistance_flags & (UNACIDABLE|ACID_PROOF))))
				to_chat(user, "<span class='warning'>The acid on [src] burns my hand!</span>")
				var/obj/item/bodypart/affecting = C.get_bodypart("[(user.active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
				if(affecting && affecting.receive_damage( 0, 5 ))		// 5 burn damage
					C.update_damage_overlays()

	if(!(interaction_flags_item & INTERACT_ITEM_ATTACK_HAND_PICKUP))		//See if we're supposed to auto pickup.
		return

	if(SEND_SIGNAL(loc, COMSIG_STORAGE_BLOCK_USER_TAKE, src, user, TRUE))
		return

	if(!ontable() && isturf(loc))
		if(!do_after(user, 3 DECISECONDS, src))
			return

	//If the item is in a storage item, take it out
	var/outside_storage = !(item_flags & IN_STORAGE)
	var/turf/storage_turf
	if(!outside_storage)
		//We want the pickup animation to play even if we're moving the item between movables. Unless the mob is not located on a turf.
		if(isturf(user.loc))
			storage_turf = get_turf(loc)
		if(!SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user, TRUE))
			return
	if(QDELETED(src)) //moving it out of the storage destroyed it.
		return

	if(storage_turf)
		do_pickup_animation(user, storage_turf)

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user && outside_storage)
		if(!allow_attack_hand_drop(user) || !user.temporarilyRemoveItemFromInventory(src))
			return

	. = FALSE

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, ignore_animation = !outside_storage))
		user.dropItemToGround(src)
		return TRUE
	afterpickup(user)

/atom/proc/ontable()
	if(!isturf(src.loc))
		return FALSE
	for(var/obj/structure/table/T in src.loc)
		return TRUE
	return FALSE

/obj/item/proc/allow_attack_hand_drop(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/C = user
		if(!(src in C.held_items) && unequip_delay_self)
			if(unequip_delay_self >= 10)
				C.visible_message(span_smallnotice("[C] starts taking off [src]..."), span_smallnotice("I start taking off [src]..."))

			var/doafter_flags = edelay_type ? (IGNORE_USER_LOC_CHANGE) : (NONE)
			return do_after(C, minone(unequip_delay_self-C.STASPD), timed_action_flags = doafter_flags)

	return TRUE

/obj/item/attack_paw(mob/user)
	if(!user)
		return
	if(anchored)
		return

	SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, user.loc, TRUE)

	if(throwing)
		throwing.finalize(FALSE)
	if(loc == user)
		if(!user.temporarilyRemoveItemFromInventory(src))
			return

	pickup(user)
	add_fingerprint(user)
	if(!user.put_in_active_hand(src, FALSE, FALSE))
		user.dropItemToGround(src)

/obj/item/proc/GetDeconstructableContents()
	return GetAllContents() - src

// afterattack() and attack() prototypes moved to _onclick/item_attack.dm for consistency

/obj/item/proc/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	if(prob(final_block_chance))
		owner.visible_message("<span class='danger'>[owner] blocks [attack_text] with [src]!</span>")
		return 1
	return 0

/obj/item/proc/hit_response(mob/living/carbon/human/owner, mob/living/carbon/human/attacker)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_RESPONSE, owner, attacker)		//sends signal for Magic_items. Used to call enchantments effects for worn items

/obj/item/proc/talk_into(mob/M, input, channel, spans, datum/language/language)
	return ITALICS | REDUCE_RANGE

/obj/item/proc/dropped(mob/user, silent = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	// Remove any item actions we temporary gave out.
	for(var/datum/action/action_item_has as anything in actions)
		action_item_has.Remove(user)

	if(item_flags & DROPDEL)
		qdel(src)
		return
	pixel_x = base_pixel_x
	pixel_y = base_pixel_y
	if(isturf(loc))
		if(!ontable())
			var/oldy = pixel_y
			pixel_y += 5
			animate(src, pixel_y = oldy, time = 0.5)
	item_flags &= ~IN_INVENTORY
	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED,user)
	if(!silent)
		playsound(src, drop_sound, DROP_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
	toggle_altgrip(user, FALSE)
	user.update_equipment_speed_mods()
	if(isliving(user))
		var/mob/living/living_user = user
		living_user.encumbrance_to_speed()
	update_transform()
	update_appearance(UPDATE_OVERLAYS)

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_PICKUP, user)

	item_flags |= IN_INVENTORY

// called just after an item is successfully picked up (loc has changed)
/obj/item/proc/afterpickup(mob/user)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_ITEM_AFTER_PICKUP, user)

	if(isliving(user))
		var/mob/living/L = user
		L.encumbrance_to_speed()

/obj/item/proc/afterdrop(mob/user)

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// Initial is used to indicate whether or not this is the initial equipment (job datums etc) or just a player doing it
/obj/item/proc/equipped(mob/user, slot, initial = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)
	SEND_SIGNAL(user, COMSIG_MOB_EQUIPPED_ITEM, src, slot)

	// Give out actions our item has to people who equip it.
	for(var/datum/action/action as anything in actions)
		give_item_action(action, user, slot)

	item_flags |= IN_INVENTORY
	if(!initial)
		if(equip_sound && (slot_flags & slot))
			if(user.m_intent != MOVE_INTENT_SNEAK) // Sneaky sheathing/equipping
				playsound(src, equip_sound, EQUIP_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
		if(pickup_sound)
			if(user.is_holding(src))
				if(user.m_intent != MOVE_INTENT_SNEAK) // Don't play a sound if we're sneaking, for assassination purposes.
					playsound(src, pickup_sound, PICKUP_SOUND_VOLUME, ignore_walls = FALSE)
	user.update_equipment_speed_mods()
	update_transform()
	update_appearance(UPDATE_OVERLAYS)

/// Gives one of our item actions to a mob, when equipped to a certain slot
/obj/item/proc/give_item_action(datum/action/action, mob/to_who, slot)
	// Some items only give their actions buttons when in a specific slot.
	if(!item_action_slot_check(slot, to_who))
		// There is a chance we still have our item action currently,
		// and are moving it from a "valid slot" to an "invalid slot".
		// So call Remove() here regardless, even if excessive.
		action.Remove(to_who)
		return

	action.Grant(to_who)

/// Sometimes we only want to grant the item's action if it's equipped in a specific slot.
/obj/item/proc/item_action_slot_check(slot, mob/user)
	if(slot & (ITEM_SLOT_BACKPACK | ITEM_SLOT_LEGCUFFED)) //these aren't true slots, so avoid granting actions there
		return FALSE
	if(!isnull(action_slots))
		return (slot & action_slots)
	else if (slot_flags)
		if(isweapon(src))
			var/obj/item/active = user.get_active_held_item()
			var/obj/item/inactive = user.get_inactive_hand_index()
			if(active == src || inactive == src)
				return TRUE
			else
				return FALSE
		else
			return (slot & slot_flags)
	return TRUE

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//if this is being done by a mob other than M, it will include the mob equipper, who is trying to equip the item to mob M. equipper will be null otherwise.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to TRUE if you wish it to not give you outputs.
/obj/item/proc/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(!M)
		return FALSE

	return M.can_equip(src, slot, disable_warning, bypass_equip_delay_self)

/obj/item/verb/verb_pickup()
	set src in oview(1)
	set hidden = 1
	set name = "Pick up"

	if(usr.incapacitated(IGNORE_GRAB) || !Adjacent(usr))
		return

	if(isliving(usr))
		var/mob/living/L = usr
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return

	if(usr.get_active_held_item() == null) // Let me know if this has any problems -Yota
		usr.UnarmedAttack(src)

//This proc is executed when someone clicks the on-screen UI button.
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, stunned, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click(mob/user, actiontype)
	attack_self(user)

/obj/item/proc/IsReflect(def_zone) //This proc determines if and at what% an object will reflect energy projectiles if it's in l_hand,r_hand or wear_armor
	return 0

/obj/item/proc/eyestab(mob/living/carbon/M, mob/living/carbon/user)

	var/is_human_victim
	var/obj/item/bodypart/affecting = M.get_bodypart(BODY_ZONE_HEAD)
	if(ishuman(M))
		if(!affecting) //no head!
			return
		is_human_victim = TRUE

	if(M.is_eyes_covered())
		// you can't stab someone in the eyes wearing a mask!
		to_chat(user, "<span class='warning'>You're going to need to remove [M.p_their()] eye protection first!</span>")
		return

	if(isbrain(M))
		to_chat(user, "<span class='warning'>I cannot locate any organic eyes on this brain!</span>")
		return

	src.add_fingerprint(user)

	playsound(src, src.hitsound, 30, TRUE, -1)

	user.do_attack_animation(M, used_intent = user.used_intent, used_item = src)

	if(M != user)
		M.visible_message("<span class='danger'>[user] has stabbed [M] in the eye with [src]!</span>", \
							"<span class='danger'>[user] stabs you in the eye with [src]!</span>")
	else
		user.visible_message( \
			"<span class='danger'>[user] has stabbed [user.p_them()]self in the eyes with [src]!</span>", \
			"<span class='danger'>I stab myself in the eyes with [src]!</span>" \
		)
	if(is_human_victim)
		var/mob/living/carbon/human/U = M
		U.apply_damage(7, BRUTE, affecting)

	else
		M.take_bodypart_damage(7)

	M.add_stress(/datum/stress_event/eye_stab)

	log_combat(user, M, "attacked", "[src.name]", "(INTENT: [uppertext(user.used_intent)])")

	var/obj/item/organ/eyes/eyes = M.getorganslot(ORGAN_SLOT_EYES)
	if (!eyes)
		return
	M.adjust_eye_blur(6 SECONDS)
	eyes.applyOrganDamage(rand(2,4))
	if(eyes.damage >= 10)
		M.adjust_eye_blur(30 SECONDS)
		if(M.stat != DEAD)
			to_chat(M, "<span class='danger'>My eyes start to bleed profusely!</span>")
		if(!M.is_nearsighted_from(EYE_DAMAGE))
			to_chat(M, "<span class='danger'>I become nearsighted!</span>")
		M.become_nearsighted(EYE_DAMAGE)
		if(prob(50))
			if(M.stat != DEAD)
				if(M.drop_all_held_items())
					to_chat(M, "<span class='danger'>I drop what you're holding and clutch at my eyes!</span>")
			M.adjust_eye_blur(20 SECONDS)
			M.Unconscious(20)
			M.Paralyze(40)
		if (prob(eyes.damage - 10 + 1))
			M.become_blind(EYE_DAMAGE)
			to_chat(M, "<span class='danger'>I go blind!</span>")

/obj/item/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(hit_atom && !QDELETED(hit_atom))
		SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
		if(get_temperature() && isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.IgniteMob()
		var/itempush = 0
		if(w_class < 4)
			itempush = 0 //too light to push anything
		if(istype(hit_atom, /mob/living)) //Living mobs handle hit sounds differently.
			var/volume = get_volume_by_throwforce_and_or_w_class()
			if (throwforce > 0)
				if (mob_throw_hit_sound)
					playsound(hit_atom, mob_throw_hit_sound, volume, TRUE, -1)
				else if(hitsound)
					playsound(hit_atom, pick(hitsound), volume, TRUE, -1)
				else
					playsound(hit_atom, 'sound/blank.ogg',volume, TRUE, -1)
			else
				playsound(hit_atom, 'sound/blank.ogg', 1, volume, -1)

		else
			playsound(src, drop_sound, YEET_SOUND_VOLUME, TRUE, ignore_walls = FALSE)
		return hit_atom.hitby(src, 0, itempush, throwingdatum=throwingdatum, damage_type = src.damage_type)

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE)
	thrownby = thrower
	callback = CALLBACK(src, PROC_REF(after_throw), callback) //replace their callback with our own
	. = ..(target, range, speed, thrower, spin, diagonals_first, callback, force)


/obj/item/proc/after_throw(datum/callback/callback)
	if (callback) //call the original callback
		. = callback.Invoke()
	item_flags &= ~IN_INVENTORY
	if(!pixel_y && !pixel_x)
		pixel_x = base_pixel_x + rand(-8,8)
		pixel_y = base_pixel_y + rand(-8,8)


/obj/item/proc/remove_item_from_storage(atom/newLoc) //please use this if you're going to snowflake an item out of a obj/item/storage
	if(!newLoc)
		return FALSE
	if(SEND_SIGNAL(loc, COMSIG_CONTAINS_STORAGE))
		return SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_TAKE, src, newLoc, TRUE)
	return FALSE

/obj/item/proc/get_belt_overlay() //Returns the icon used for overlaying the object on a belt
	return mutable_appearance('icons/obj/clothing/belt_overlays.dmi', icon_state)

/obj/item/proc/update_slot_icon()
	if(!ismob(loc))
		return
	var/mob/owner = loc
	var/mob/living/carbon/human/H
	if(ishuman(owner))
		H = owner
	var/flags = slot_flags
	if(flags & ITEM_SLOT_GLOVES)
		owner.update_inv_gloves()
	if(flags & ITEM_SLOT_MASK)
		owner.update_inv_wear_mask()
	if(flags & ITEM_SLOT_SHOES)
		owner.update_inv_shoes()
	if(flags & ITEM_SLOT_RING)
		owner.update_inv_ring()
	if(flags & ITEM_SLOT_WRISTS)
		owner.update_inv_wrists()
	if(flags & ITEM_SLOT_BACK)
		owner.update_inv_back()
	if(flags & ITEM_SLOT_NECK)
		owner.update_inv_neck()
	if(flags & ITEM_SLOT_PANTS)
		owner.update_inv_pants()
	if(flags & ITEM_SLOT_CLOAK)
		owner.update_inv_cloak()
	if(H)
		if(flags & ITEM_SLOT_HEAD && H.head == src)
			owner.update_inv_head()
		if(flags & ITEM_SLOT_ARMOR && H.wear_armor == src)
			owner.update_inv_armor()
		if(flags & ITEM_SLOT_SHIRT && H.wear_shirt == src)
			owner.update_inv_shirt()
		if(flags & ITEM_SLOT_MOUTH && H.mouth == src)
			owner.update_inv_mouth()
		if(flags & ITEM_SLOT_BELT && H.belt == src)
			owner.update_inv_belt()
		if(flags & ITEM_SLOT_HIP && (H.beltr == src || H.beltl == src) )
			owner.update_inv_belt()
	else
		if(flags & ITEM_SLOT_HEAD)
			owner.update_inv_head()
		if(flags & ITEM_SLOT_ARMOR)
			owner.update_inv_armor()
		if(flags & ITEM_SLOT_SHIRT)
			owner.update_inv_shirt()
		if(flags & ITEM_SLOT_MOUTH)
			owner.update_inv_mouth()
		if(flags & ITEM_SLOT_BELT)
			owner.update_inv_belt()
		if(flags & ITEM_SLOT_HIP)
			owner.update_inv_belt()


///Returns the temperature of src. If you want to know if an item is hot use this proc.
/obj/item/proc/get_temperature()
	return heat

///Returns the sharpness of src. If you want to get the sharpness of an item use this.
/obj/item/proc/get_sharpness()
	//Oh no, we are dulled out!
	if(!max_blade_int) //not even sharp
		return FALSE
	if(max_blade_int && (blade_int <= 0))
		return FALSE
	var/max_sharp = sharpness
	for(var/datum/intent/intent as anything in possible_item_intents)
		if(initial(intent.blade_class) == BCLASS_CUT)
			max_sharp = max(max_sharp, IS_SHARP)
		if(initial(intent.blade_class) == BCLASS_CHOP)
			max_sharp = max(max_sharp, IS_SHARP)
	return max_sharp

/obj/item/proc/get_dismemberment_chance(obj/item/bodypart/affecting, mob/user)
	if(!affecting.can_dismember(src))
		return 0
	if((get_sharpness() || damtype == BURN) && (w_class >= WEIGHT_CLASS_NORMAL) && force >= 10)
		return force * (affecting.get_damage() / affecting.max_damage)

/obj/item/proc/open_flame(flame_heat=700)
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		var/success = FALSE
		if(src == M.get_item_by_slot(ITEM_SLOT_MASK))
			success = TRUE
		if(success)
			location = get_turf(M)
	if(isturf(location))
		location.hotspot_expose(flame_heat, 5)


/obj/item/proc/ignition_effect(atom/A, mob/user)
	if(get_temperature())
		. = "<span class='notice'>[user] lights [A] with [src].</span>"
	else
		. = ""

/obj/item/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum, damage_type = "blunt")
	return SEND_SIGNAL(src, COMSIG_ATOM_HITBY, AM, skipcatch, hitpush, blocked, throwingdatum, damage_type)


/obj/item/attack_animal(mob/living/simple_animal/M)
	if (obj_flags & CAN_BE_HIT)
		return ..()
	return 0

/obj/item/burn()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/ash_type = /obj/item/fertilizer/ash
		if(w_class == WEIGHT_CLASS_HUGE || w_class == WEIGHT_CLASS_GIGANTIC)
			ash_type = /obj/item/fertilizer/ash
		var/obj/item/fertilizer/ash/A = new ash_type(T)
		A.desc += "\nLooks like this used to be \an [name] some time ago."
		..()

/obj/item/acid_melt()
	if(!QDELETED(src))
		var/turf/T = get_turf(src)
		var/obj/effect/decal/cleanable/molten_object/MO = new(T)
		MO.pixel_x = MO.base_pixel_x + rand(-16,16)
		MO.pixel_y = MO.base_pixel_y + rand(-16,16)
		MO.desc = ""
		..()

/obj/item/proc/heating_act()
	return

/obj/item/proc/on_mob_death(mob/living/L, gibbed)

/obj/item/proc/grind_requirements() //Used to check for extra requirements for grinding an object
	return TRUE

//Called BEFORE the object is ground up - use this to change grind results based on conditions
//Use "return -1" to prevent the grinding from occurring
/obj/item/proc/on_grind()

/obj/item/proc/on_juice()

/obj/item/proc/set_force_string()
	switch(force)
		if(0 to 4)
			force_string = "very low"
		if(4 to 7)
			force_string = "low"
		if(7 to 10)
			force_string = "medium"
		if(10 to 11)
			force_string = "high"
		if(11 to 20) //12 is the force of a toolbox
			force_string = "robust"
		if(20 to 25)
			force_string = "very robust"
		else
			force_string = "exceptionally robust"
	last_force_string_check = force

/obj/item/proc/openTip(location, control, params, user)
	if(last_force_string_check != force && !(item_flags & FORCE_STRING_OVERRIDE))
		set_force_string()
	if(!(item_flags & FORCE_STRING_OVERRIDE))
		openToolTip(user,src,params,title = name,content = "[desc]<br>[force ? "<b>Force:</b> [force_string]" : ""]",theme = "")
	else
		openToolTip(user,src,params,title = name,content = "[desc]<br><b>Force:</b> [force_string]",theme = "")

// Called when a mob tries to use the item as a tool.
// Handles most checks.
/obj/item/proc/use_tool(atom/target, mob/living/user, delay, amount=0, volume=0, datum/callback/extra_checks)
	// No delay means there is no start message, and no reason to call tool_start_check before use_tool.
	// Run the start check here so we wouldn't have to call it manually.
	if(!delay && !tool_start_check(user, amount))
		return

	var/skill_modifier = 1

	if(tool_behaviour == TOOL_MINING && ishuman(user))
		var/mob/living/carbon/human/H = user
		skill_modifier = H.get_skill_speed_modifier(/datum/skill/labor/mining)

	delay *= toolspeed * skill_modifier

	// Play tool sound at the beginning of tool usage.
	play_tool_sound(target, volume)

	if(delay)
		// Create a callback with checks that would be called every tick by do_after.
		var/datum/callback/tool_check = CALLBACK(src, PROC_REF(tool_check_callback), user, amount, extra_checks)

		if(ismob(target))
			if(!do_after(user, delay, target, extra_checks=tool_check))
				return

		else
			if(!do_after(user, delay, target, extra_checks=tool_check))
				return
	else
		// Invoke the extra checks once, just in case.
		if(extra_checks && !extra_checks.Invoke())
			return

	// Use tool's fuel, stack sheets or charges if amount is set.
	if(amount && !use(amount))
		return

	// Play tool sound at the end of tool usage,
	// but only if the delay between the beginning and the end is not too small
	if(delay >= MIN_TOOL_SOUND_DELAY)
		play_tool_sound(target, volume)

	return TRUE

// Called before use_tool if there is a delay, or by use_tool if there isn't.
// Only ever used by welding tools and stacks, so it's not added on any other use_tool checks.
/obj/item/proc/tool_start_check(mob/living/user, amount=0)
	return tool_use_check(user, amount)

// A check called by tool_start_check once, and by use_tool on every tick of delay.
/obj/item/proc/tool_use_check(mob/living/user, amount)
	return !amount

// Generic use proc. Depending on the item, it uses up fuel, charges, sheets, etc.
// Returns TRUE on success, FALSE on failure.
/obj/item/proc/use(used)
	return !used

// Plays item's usesound, if any.
/obj/item/proc/play_tool_sound(atom/target, volume=50)
	if(target && usesound && volume)
		var/played_sound = usesound

		if(islist(usesound))
			played_sound = pick(usesound)

		playsound(target, played_sound, volume, TRUE)

// Used in a callback that is passed by use_tool into do_after call. Do not override, do not call manually.
/obj/item/proc/tool_check_callback(mob/living/user, amount, datum/callback/extra_checks)
	return tool_use_check(user, amount) && (!extra_checks || extra_checks.Invoke())

// Returns a numeric value for sorting items used as parts in machines, so they can be replaced by the rped
/obj/item/proc/get_part_rating()
	return 0

/obj/item/doMove(atom/destination)
	if (ismob(loc))
		var/mob/M = loc
		var/hand_index = M.get_held_index_of_item(src)
		if(hand_index)
			M.held_items[hand_index] = null
			M.update_inv_hands()
			if(M.client)
				M.client.screen -= src
			layer = initial(layer)
			plane = initial(plane)
			appearance_flags &= ~NO_CLIENT_COLOR
			dropped(M, TRUE)
	return ..()

/obj/item/throw_at(atom/target, range, speed, mob/thrower, spin=TRUE, diagonals_first = FALSE, datum/callback/callback, force, gentle = FALSE)
	if(HAS_TRAIT(src, TRAIT_NODROP))
		return
	return ..()

/obj/item/proc/embedded(atom/embedded_target, obj/item/bodypart/part)
	return

/obj/item/proc/unembedded(mob/living/owner)
	if(item_flags & DROPDEL && !QDELETED(src))
		qdel(src)
		return TRUE

/obj/item/proc/canStrip(mob/stripper, mob/owner)
	return !HAS_TRAIT(src, TRAIT_NODROP)

/obj/item/proc/doStrip(mob/stripper, mob/owner)
	return owner.dropItemToGround(src)

/obj/item/update_appearance(updates)
	. = ..()
	update_transform()

/obj/item/proc/on_wield(obj/item/source, mob/living/carbon/user)
	wdefense += 1
	user.update_a_intents()

/obj/item/proc/on_unwield(obj/item/source, mob/living/carbon/user)
	wdefense -= 1
	user.update_a_intents()

/obj/item/proc/toggle_altgrip(mob/user, override_state)
	if(!alt_intents)
		return
	var/new_state = !isnull(override_state) ? override_state : !altgripped
	if(altgripped == new_state)
		return
	altgripped = new_state
	update_transform()
	if(user.get_active_held_item() == src)
		user.update_a_intents()
		if(altgripped)
			to_chat(user, span_notice("I wield [src] with an alternate grip."))
		else
			to_chat(user, span_notice("I wield [src] normally."))

/obj/item/on_fall_impact(mob/living/impactee, fall_speed)
	. = ..()
	if(!item_weight)
		return

	var/target_zone = BODY_ZONE_HEAD
	/*
	if(impactee.lying)
		target_zone = BODY_ZONE_CHEST
	*/
	playsound(impactee, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	add_blood_DNA(GET_ATOM_BLOOD_DNA(impactee))
	impactee.visible_message(span_danger("[src] crashes into [impactee]'s [target_zone]!"), span_danger("A [src] hits you in your [target_zone]!"))
	impactee.apply_damage(item_weight * fall_speed, BRUTE, target_zone, impactee.run_armor_check(target_zone, "blunt", damage = item_weight * fall_speed))

/obj/item/proc/on_consume(mob/living/eater)
	return

/obj/item/proc/get_displayed_price(mob/user)
	if(QDELETED(user))
		return
	if(get_real_price() > 0 && (HAS_TRAIT(user, TRAIT_SEEPRICES) || simpleton_price))
		return span_info("Value: [get_real_price()] mammon")
	return FALSE

/obj/item/proc/get_stored_weight(has_trait)
	var/held_weight = 0
	for(var/obj/item/stored_item in contents)
		held_weight += stored_item.item_weight * carry_multiplier

	return has_trait ? held_weight * 0.5 : held_weight

/**
 * Updates all action buttons associated with this item
 *
* Arguments:
 * * update_flags - Which flags of the action should we update
 * * force - Force buttons update even if the given button icon state has not changed
 */
/obj/item/proc/update_item_action_buttons(update_flags = ALL, force = FALSE)
	for(var/datum/action/current_action as anything in actions)
		current_action.build_all_button_icons(update_flags, force)

// Update icons if this is being carried by a mob
/obj/item/wash(clean_types)
	. = ..()
	if(ismob(loc))
		update_slot_icon()

/obj/item/proc/do_pickup_animation(atom/target, turf/source)
	set waitfor = FALSE

	if(!source)
		if(!istype(loc, /turf))
			return
		source = loc
	var/image/pickup_animation = image(icon = src, layer = layer + 0.1)
	pickup_animation.plane = GAME_PLANE
	pickup_animation.transform.Scale(0.75)
	pickup_animation.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/direction
	if(!QDELETED(source) && !QDELETED(target))
		direction = get_dir(source, target)

	var/to_x = 0
	var/to_y = 0

	if(direction & NORTH)
		to_y += 32
	else if(direction & SOUTH)
		to_y -= 32
	if(direction & EAST)
		to_x += 32
	else if(direction & WEST)
		to_x -= 32
	if(!direction)
		to_y += 10
		pickup_animation.pixel_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	var/atom/movable/flick_visual/pickup = source.flick_overlay_view(pickup_animation, 0.6 SECONDS)
	var/matrix/animation_matrix = new(pickup.transform)
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.65)

	animate(pickup, alpha = 175, pixel_x = to_x, pixel_y = to_y, time = 0.3 SECONDS, transform = animation_matrix, easing = CUBIC_EASING)
	animate(alpha = 0, transform = matrix().Scale(0.7), time = 0.1 SECONDS)

/obj/item/proc/make_modifyable(sockets = 2, max_sockets = 2)
	AddComponent(/datum/component/modifications, sockets, max_sockets)

/proc/generate_random_socketed_item(item_type, socket_count, gem_quality_range = list(GEM_CHIPPED, GEM_PERFECT))
	if(!item_type)
		switch(rand(1, 2))
			if(1)
				item_type = pick(subtypesof(/obj/item/clothing))
			if(2)
				item_type = pick(subtypesof(/obj/item/weapon))

	if(!socket_count)
		socket_count = rand(1, 6)

	var/obj/item/new_item = new item_type(get_turf(usr))
	new_item.make_modifyable(socket_count, socket_count)

	// Fill with random gems
	var/list/gem_types = list(
		/obj/item/gem/red,
		/obj/item/gem/violet,
		/obj/item/gem/yellow,
		/obj/item/gem/green,
		/obj/item/gem/diamond,
		/obj/item/gem/blue,
	)

	for(var/i = 1 to socket_count)
		var/gem_type = pick(gem_types)
		var/obj/item/gem/new_gem = new gem_type
		new_gem.quality = rand(gem_quality_range[1], gem_quality_range[2])
		new_gem.generate_socketing_properties()

		var/datum/component/modifications/mod = new_item.GetComponent(/datum/component/modifications)
		mod?.socket_gem(new_gem, null) // null user for automatic generation

	return new_item

/obj/item/proc/can_embed()
	if(HAS_TRAIT(src, TRAIT_NODROP) || HAS_TRAIT(src, TRAIT_NOEMBED))
		return FALSE
	if(!embedding?.embed_chance)
		return FALSE
	return TRUE

/obj/item/examine(mob/user)
	. = ..()
	if(!get_precursor_data(src))
		return
	var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)
	var/datum/natural_precursor/precursor = get_precursor_data(src)
	if(precursor)
		for(var/datum/thaumaturgical_essence/essence as anything in precursor.essence_yields)
			var/amount = precursor.essence_yields[essence]
			var/smell = initial(essence.smells_like)
			switch(amount)
				if(15 to 100)
					if(alch_skill >= SKILL_LEVEL_NOVICE)
						. += span_notice(" Smells intensely of [smell].")
				if(10 to 14)
					if(alch_skill >= SKILL_LEVEL_APPRENTICE)
						. += span_notice(" Smells strongly of [smell].")
				if(5 to 9)
					if(alch_skill >= SKILL_LEVEL_JOURNEYMAN)
						. += span_notice(" Smells slightly of [smell].")
				if(1 to 4)
					if(alch_skill >= SKILL_LEVEL_EXPERT)
						. += span_notice(" Smells faintly of [smell].")
