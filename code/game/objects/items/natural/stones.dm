GLOBAL_LIST_INIT(stone_sharpness_names, list(
	"Sharp",
	"Vicious",
	"Cutthroat",
	"Keen",
	"Acute",
	"Edged",
	"Fierce",
	"Stinging",
))

GLOBAL_LIST_INIT(stone_sharpness_descs, list(
	"It has a vicious edge.",
	"This stone is akin to a knife.",
	"It has a pointed side.",
	"It has a serrated edge.",
))

GLOBAL_LIST_INIT(stone_bluntness_names, list(
	"Blunt",
	"Rotund",
	"Heavy",
	"Solid",
	"Chubby",
	"Portly",
	"Meaty",
	"Dumpy",
	"Stout",
	"Plump",
))

GLOBAL_LIST_INIT(stone_bluntness_descs, list(
	"It is very blunt.",
	"It is kinda hefty.",
	"It fills the hand.",
	"It is quite a handfull",
	"This stone feels like it was made for ME!",
))

GLOBAL_LIST_INIT(stone_magic_names, list(
	"Shimmering",
	"Glowing",
	"Enchanted",
	"Ancient",
	"Mystic",
	"Enhanced",
	"Magic",
	"Mysterious",
	"Radiant",
	"Singing",
	"Beautiful",
	"Tantalizing",
	"Allurring",
	"Wicked",
	"Mythical",
	"Baleful",
	"Heavenly",
	"Angelic",
	"Demonic",
	"Devilish",
	"Mischievous",
))

GLOBAL_LIST_INIT(stone_magic_descs, list(
	"It hums with internal energy.",
	"It has a faint aura.",
	"It has an odd sigil on it.",
	"It has a small red stone pressed into it.",
	"It is covered in tiny cracks.",
	"It looks unsafe.",
))

GLOBAL_LIST_INIT(stone_personalities, list(
	"Hatred",
	"Idiocy",
	"Mourning",
	"Glory",
	"Rock-Solidness",
	"Calmness",
	"Anger",
	"Rage",
	"Vainglory",
	"Risk-aversedness",
	"Daredevil",
	"Barbarics",
	"Fanciness",
	"Relaxing",
	"Blacked",
	"Greed",
	"Evil",
	"Good",
	"Neutrality",
	"Pride",
	"Lust",
	"Sloth",
	"Victory",
	"Defeat",
	"Recoil",
	"Impact",
	"Goring",
	"Destruction",
	"Hell",
	"Zizo",
	"Flames",
	"Darkness",
	"Light",
	"Heroism",
	"Heaven",
	"Cowards",
	"Conquerors",
	"Conquest",
	"Horripilation",
	"Terror",
	"Earthquakes",
	"Thunder",
))

GLOBAL_LIST_INIT(stone_personality_descs, list(
	"This stone is full of personality!",
	"They say the intelligent species built their foundations with stones.",
	"One must think, where did this stone come from?",
	"If all stones were like this, then they would be some pretty great stones.",
	"I wish my personality was like this stone's...",
	"I could sure do a whole lot with this stone.",
	"I love stones!",
))


/obj/item/natural/stone
	name = "stone"
	desc = "A piece of rough ground stone."
	icon_state = "stone1"
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	item_state = "stone"
	experimental_inhand = FALSE
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 15
	slot_flags = ITEM_SLOT_MOUTH
	w_class = WEIGHT_CLASS_SMALL
	/// If our stone is magical, this lets us know -how- magical. Maximum is 15.
	var/magic_power = 0
	var/magicstone = FALSE
	resistance_flags = FIRE_PROOF

/obj/item/natural/stone/Initialize()
	. = ..()
	icon_state = "stone[rand(1,4)]"
	stone_lore()

/obj/item/natural/stone/on_consume(mob/living/eater)
	if(!magic_power)
		return
	//eater.adjust_spell_points(magic_power * 0.1)
	//eater.mana_pool?.adjust_mana(magic_power * 25)
	//to_chat(eater, span_warning("I feel magic flowing from my stomach."))

/*
	This right here is stone lore,
	Yakub from BBC lore has inspired me
*/
/obj/item/natural/stone/proc/stone_lore()
	var/stone_title = "stone" // Our stones title
	var/stone_desc = "[desc]" // Total Bonus desc the stone will be getting

	icon_state = "stone[rand(1,5)]"

	var/bonus_force = 0 // Total bonus force the rock will be getting
	var/list/given_intent_list = list(/datum/intent/hit) // By default you get this at least
	var/list/extra_intent_list = list() // List of intents that we can possibly give it by the end of this
	var/list/blunt_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	var/list/sharp_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)

	var/bluntness_rating = rand(0,10)
	var/sharpness_rating = rand(0,10)

	var/stone_personality_rating = rand(0,25)

	//This is so sharpness and bluntness's name and descs come in randomly before or after each other
	//Magic will always be in front for now, and personality will be after magic.
	var/list/name_jumbler = list()
	var/list/desc_jumbler = list()

	switch(bluntness_rating)
		if(2 to 8)
			extra_intent_list += pick(blunt_intents) // Add one
		if(9 to 10)
			for(var/muhdik in blunt_intents) // add all intent to possible things
				extra_intent_list += muhdik

			name_jumbler += pick(GLOB.stone_bluntness_names)
			desc_jumbler += pick(GLOB.stone_bluntness_descs)

	switch(sharpness_rating)
		if(2 to 8)
			extra_intent_list += pick(sharp_intents) // Add one
		if(9 to 10)
			for(var/mofugga in sharp_intents) // add all intent to possible things
				extra_intent_list += mofugga

			name_jumbler += pick(GLOB.stone_sharpness_names)
			desc_jumbler += pick(GLOB.stone_sharpness_descs)

	if(name_jumbler.len) // Both name jumbler and desc jumbler should be symmetrical in insertions conceptually anyways.
		for(var/i in 1 to name_jumbler.len) //Theres only two right now
			if(!name_jumbler.len) // If list somehow empty get the hell out! Now~!
				break
			//Remove so theres no repeats
			var/picked_name = pick(name_jumbler)
			name_jumbler -= picked_name
			var/picked_desc = pick(desc_jumbler)
			desc_jumbler -= picked_desc

			stone_title = "[picked_name] [stone_title]" // Prefix and then stone
			stone_desc += " [picked_desc]" // We put the descs after the original one

	var/personality_modifier = 0
	switch(stone_personality_rating)
		if(10 to 22)
			if(prob(3)) // Stone has a 3 percent chance to have a personality despite missing its roll
				stone_title = "[stone_title] of [pick(GLOB.stone_personalities)]"
				stone_desc += " [pick(GLOB.stone_personality_descs)]"
				personality_modifier += rand(1,5) // Personality gives a stone some more power too
		if(23 to 25)
			stone_title = "[stone_title] of [pick(GLOB.stone_personalities)]"
			stone_desc += " [pick(GLOB.stone_personality_descs)]"
			personality_modifier += rand(1,5) // Personality gives a stone some more power too

	if (personality_modifier)
		bonus_force += personality_modifier
		magic_power += personality_modifier

	var/max_force_range = sharpness_rating + bluntness_rating // Add them together
	//max_force_range = round(max_force_range/2) // Divide by 2 and round jus incase

	bonus_force = rand(0, max_force_range) // Your total bonus force is now between 1 and your sharpness/bluntness totals

	if(prob(5)) // We hit the jackpot, a magical stone! JUST FOR ME!
		filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))
		var/magic_force = rand(1,10) //Roll, we need this seperate for now otherwise people will know the blunt/sharp boosts too
		stone_title = "[pick(GLOB.stone_magic_names)] [stone_title] +[magic_force]"
		stone_desc += " [pick(GLOB.stone_magic_descs)]"
		bonus_force += magic_force // Add on the magic force modifier
		magic_power += magic_force

	if(extra_intent_list.len)
		for(var/i in 1 to min(4, extra_intent_list.len))
			// No more than 4 bro, and if we are empty on intents just stop here
			if(!length(extra_intent_list))
				break
			var/cock = pick(extra_intent_list) // We pick one
			given_intent_list += cock // Add it to the list
			extra_intent_list -= cock // Remove it from the prev list

	//Now that we have built the history and lore of this stone, we apply it to the main vars.
	name = lowertext(stone_title)
	desc = stone_desc
	// force += bonus_force // This will result in a stone that has only 40 max at a extremely low chance damage at this time of this PR.
	throwforce += bonus_force // It gets added to throw damage too
	possible_item_intents = given_intent_list // And heres ur new extra intents too

/obj/item/natural/stone/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ROTMAN))
		to_chat(user, span_info("The [src] slips through dead fingers..."))
		user.dropItemToGround(src, TRUE)

/obj/item/natural/stone/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(istype(weapon, /obj/item/natural/stone))
		playsound(src, pick('sound/items/stonestone.ogg'), 100)
		if(prob(10))
			user.visible_message(span_info("[user] strikes the stones together."))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_step(user, user.dir)
			S.set_up(1, 1, front)
			S.start()
		user.changeNext_move(CLICK_CD_FAST)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/natural/stone/attackby(obj/item/W, mob/living/user, list/modifiers)
	var/list/offhand_types = typecacheof(list(/obj/item/weapon/hammer, /obj/item/natural/stone, /obj/item/natural/stoneblock))
	var/item = user.get_inactive_held_item()
	if(user.used_intent.type == /datum/intent/chisel && is_type_in_typecache(item, offhand_types))
		user.changeNext_move(CLICK_CD_MELEE)
		var/skill_level = user.get_skill_level(/datum/skill/craft/masonry, TRUE)
		var/work_time = (4 SECONDS - (skill_level * 5))
		if(istype(W, /obj/item/weapon/chisel))
			var/obj/item/weapon/chisel/chisel = W
			work_time *= chisel.time_multiplier
		playsound(src, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user] begins chiseling [src] into blocks.</span>")
		var/stone_amount = rand(1, max(round(skill_level)/2, 1))
		if(do_after(user, work_time))
			for(var/i in 1 to stone_amount)
				new /obj/item/natural/stoneblock(get_turf(src.loc))
			if(prob(10))
				new /obj/effect/decal/cleanable/debris/stone(get_turf(src))
			playsound(src, 'sound/foley/smash_rock.ogg', 100)
			qdel(src)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.2))
		return TRUE
	. = ..()

/obj/item/natural/rock
	name = "rock"
	desc = "A large stone that looks breakable."
	icon_state = "stonebig1"
	dropshrink = 0
	throwforce = 25
	throw_range = 2
	force = 15
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	force_wielded = 15
	gripped_intents = list(INTENT_GENERIC)
	w_class = WEIGHT_CLASS_HUGE
	var/obj/item/ore/mineralType = null
	var/mineralAmt = 1
	blade_dulling = DULLING_BASH
	max_integrity = 50
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'

/obj/item/natural/rock/apply_components()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/natural/rock/Initialize()
	. = ..()
	if(!isnull(mineralType))
		icon_state = "stonebigshiny[rand(1,2)]"
	else
		icon_state = "stonebig[rand(1,2)]"

/obj/item/natural/rock/Crossed(mob/living/L)
	if(istype(L) && !L.throwing)
		if(L.m_intent == MOVE_INTENT_RUN)
			L.visible_message(span_warning("[L] trips over the rock!"),span_warning("I trip over the rock!"))
			L.Knockdown(10)
			L.consider_ambush()
	..()

/obj/item/natural/rock/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(atom_integrity <= 0)
		record_featured_stat(FEATURED_STATS_MINERS, user)

/obj/item/natural/rock/deconstruct(disassembled = FALSE)
	if(!disassembled)
		if(mineralType && mineralAmt)
			if(has_world_trait(/datum/world_trait/malum_diligence))
				mineralAmt += is_ascendant(MALUM) ? rand (2,3) : rand(1,2)
			new mineralType(src.loc, mineralAmt)
		for(var/i in 1 to rand(1,3))
			var/obj/item/S = new /obj/item/natural/stone(src.loc)
			S.pixel_x = S.base_pixel_x + rand(25,-25)
			S.pixel_y = S.base_pixel_y + rand(25,-25)
		record_round_statistic(STATS_ROCKS_MINED)
	qdel(src)

/obj/item/natural/rock/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(.) //damage received
		if(damage_amount > 10)
			if(prob(10))
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_turf(src)
				S.set_up(1, 1, front)
				S.start()

/obj/item/natural/rock/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(istype(weapon, /obj/item/natural/stone))
		playsound(src, 'sound/items/stonestone.ogg', 100)
		if(prob(35))
			user.visible_message(span_info("[user] strikes the stone against the rock.</span>"))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_step(user, user.dir)
			S.set_up(1, 1, front)
			S.start()
		user.changeNext_move(CLICK_CD_FAST)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(istype(weapon, /obj/item/natural/rock))
		playsound(src, pick('sound/items/stonestone.ogg'), 100)
		if(prob(10))
			user.visible_message(span_info("[user] strikes the rocks together."))
			var/datum/effect_system/spark_spread/S = new()
			var/turf/front = get_step(user,user.dir)
			S.set_up(1, 1, front)
			S.start()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/natural/rock/attackby(obj/item/W, mob/living/user, list/modifiers)
	user.changeNext_move(CLICK_CD_MELEE)
	var/list/offhand_types = typecacheof(list(/obj/item/weapon/hammer, /obj/item/natural/stone, /obj/item/natural/stoneblock))
	var/item = user.get_inactive_held_item()
	if(user.used_intent.type == /datum/intent/chisel && is_type_in_typecache(item, offhand_types))
		var/skill_level = user.get_skill_level(/datum/skill/craft/masonry, TRUE)
		var/work_time = (10 SECONDS - (skill_level * 5))
		if(istype(W, /obj/item/weapon/chisel))
			var/obj/item/weapon/chisel/chisel = W
			work_time *= chisel.time_multiplier
		playsound(src, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg', 'sound/combat/hits/onrock/onrock (3).ogg', 'sound/combat/hits/onrock/onrock (4).ogg'), 100)
		user.visible_message("<span class='info'>[user] begins chiseling a part of [src] off.</span>")
		if(do_after(user, work_time))
			new /obj/item/natural/stoneblock(get_turf(src.loc))
			take_damage(max_integrity/2)
			user.mind.add_sleep_experience(/datum/skill/craft/masonry, (user.STAINT*0.2))
		return TRUE
	. = ..()

//begin ore loot rocks
/obj/item/natural/rock/gold
	mineralType = /obj/item/ore/gold

/obj/item/natural/rock/iron
	mineralType = /obj/item/ore/iron

/obj/item/natural/rock/coal
	mineralType = /obj/item/ore/coal

/obj/item/natural/rock/salt
	mineralType = /obj/item/reagent_containers/powder/salt

/obj/item/natural/rock/silver
	mineralType = /obj/item/ore/silver

/obj/item/natural/rock/copper
	mineralType = /obj/item/ore/copper

/obj/item/natural/rock/tin
	mineralType = /obj/item/ore/tin

/obj/item/natural/rock/gemerald
	mineralType = /obj/item/gem

/obj/item/natural/rock/random_ore
	name = "rock?"
	desc = "Wait, this shouldn't be here?"
	icon_state = "stonerandom"

/obj/item/natural/rock/random/Initialize()
	. = ..()
	var/obj/item/natural/rock/theboi = pick(list(
		/obj/item/natural/rock/gold,
		/obj/item/natural/rock/iron,
		/obj/item/natural/rock/coal,
		/obj/item/natural/rock/salt,
		/obj/item/natural/rock/silver,
		/obj/item/natural/rock/copper,
		/obj/item/natural/rock/tin,
		/obj/item/natural/rock/gemerald
	))
	new theboi(get_turf(src))
	return INITIALIZE_HINT_QDEL

//................	Stone blocks	............... //
/obj/item/natural/stoneblock
	name = "stone block"
	desc = "A rectangular stone block for building."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stoneblock"
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	item_state = "block"
	experimental_inhand = FALSE
	drop_sound = 'sound/foley/dropsound/brick_drop.ogg'
	hitsound = 'sound/foley/dropsound/brick_drop.ogg'
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 18 //brick is valid weapon
	w_class = WEIGHT_CLASS_SMALL
	bundletype = /obj/item/natural/bundle/stoneblock
	sellprice = 2

//................ Stone block stack	............... //
/obj/item/natural/bundle/stoneblock
	name = "stack of stone blocks"
	desc = "A stack of stone blocks."
	icon_state = "stoneblockbundle1"
	icon = 'icons/roguetown/items/natural.dmi'
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'
	item_state = "block"
	experimental_inhand = FALSE
	grid_width = 64
	grid_height = 64
	base_width = 64
	base_height = 64
	drop_sound = 'sound/foley/dropsound/brick_drop.ogg'
	pickup_sound = 'sound/foley/dropsound/brick_drop.ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 2
	throwforce = 0	// useless for throwing unless solo
	throw_range = 2
	w_class = WEIGHT_CLASS_NORMAL
	stackname = "stone blocks"
	stacktype = /obj/item/natural/stoneblock
	maxamount = 4
	icon1 = "stoneblockbundle2"
	icon1step = 3
	icon2 = "stoneblockbundle3"
	icon2step = 4
