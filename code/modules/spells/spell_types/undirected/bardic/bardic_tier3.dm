/**
 * Accelerating Akathist
 */
/datum/action/cooldown/spell/undirected/song/accelakathist
	name = "Accelerating Akathist"
	desc = "Accelerate your audience with your bardic song. (+2 SPD, lower action cooldowns)"
	button_icon_state = "bardsong_t3_base"
	background_icon_state = "bardsong_t3_base"
	invocation = "%Let's move tonight! Share in the speed of life!"
	spell_cost = 60
	inspiration_effect = /datum/status_effect/inspiration/accelakathist

/datum/action/cooldown/spell/undirected/song/fervor_song/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	. = ..()
	if(!.)
		return
	applied_effect.visual_icon_state = "bardsong_t3_base"
	applied_effect.max_stacks = 10 // i am speed
	applied_effect.stack_threshold = 10

#define ACCELAKATHIST_FILTER "akathist_glow"

/datum/status_effect/inspiration/accelakathist
	var/outline_colour ="#F0E68C"
	id = "haste"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/accelakathist
	effectedstats = list(STATKEY_SPD = 2)
	duration = 30 SECONDS

/datum/status_effect/inspiration/accelakathist/on_apply()
	. = ..()
	owner.add_filter(ACCELAKATHIST_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_notice("My limbs move with uncanny swiftness!"))

/datum/status_effect/inspiration/accelakathist/on_remove()
	. = ..()
	owner.remove_filter(ACCELAKATHIST_FILTER)

/atom/movable/screen/alert/status_effect/buff/song/accelakathist
	name = "Accelerating Akathist"
	desc = "I am hastened by bardic tunes."
	icon_state = "buff"

#undef ACCELAKATHIST_FILTER

/datum/status_effect/inspiration/accelakathist/nextmove_modifier()
	return 0.85

/**
 * Healing Hymn
 */
/atom/movable/screen/alert/status_effect/buff/healing
	name = "Healing Miracle"
	desc = "Divine intervention relieves me of my ailments."
	icon_state = "buff"

/obj/effect/temp_visual/heal_rogue //color is white by default, set to whatever is needed
	name = "enduring glow"
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "heal_pantheon"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/heal_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/datum/status_effect/buff/healing
	id = "healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 10 SECONDS
	var/healing_on_tick = 1
	var/outline_colour = "#c42424"
	var/effect_color = "#FF0000"

/datum/status_effect/buff/healing/on_creation(mob/living/new_owner, new_healing_on_tick)
	healing_on_tick = new_healing_on_tick
	return ..()

#define MIRACLE_HEALING_FILTER "miracle_heal_glow"

/datum/status_effect/buff/healing/on_apply()
	. = ..()
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/healing/on_remove()
	. = ..()
	owner.remove_filter(MIRACLE_HEALING_FILTER)

/datum/status_effect/buff/healing/get_examine_text()
	return "SUBJECTPRONOUN is bathed in a restorative aura!"

/datum/status_effect/buff/healing/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = effect_color
	var/list/wCount = owner.get_wounds()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_NORMAL)
	if(wCount.len > 0)
		// owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise))
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, FALSE)
	owner.adjustFireLoss(-healing_on_tick, FALSE)
	owner.adjustOxyLoss(-healing_on_tick, FALSE)
	owner.adjustToxLoss(-healing_on_tick, FALSE)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, TRUE)

#undef MIRACLE_HEALING_FILTER

/datum/action/cooldown/spell/undirected/song/rejuvenation_song
	name = "Healing Hymn"
	desc = "Recuperate your audience bodies with a melody! Refills health slowly over time."
	invocation = "%All ye weary and burdened, may the divine bless..."
	button_icon_state = "melody_t3_base"
	background_icon_state = "melody_t3_base"
	spell_cost = 60
	inspiration_effect = /datum/status_effect/buff/healing/rejuvenationsong

/datum/action/cooldown/spell/undirected/song/recovery_song/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	. = ..()
	if(!.)
		return
	applied_effect.visual_icon_state = "melody_t3_base"

/datum/status_effect/buff/healing/rejuvenationsong
	id = "healingrejuvesong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/rejuvsong
	duration = 30 SECONDS
	outline_colour = "#c92f2f"
	effect_color = "#660759"

/datum/status_effect/buff/healing/rejuvenationsong/on_apply()
	. = ..()
	healing_on_tick += owner.get_skill_level(/datum/skill/misc/music) * 0.2
	return ..()

/atom/movable/screen/alert/status_effect/buff/song/rejuvsong
	name = "Healing Miracle"
	desc = "Divine intervention relieves me of my ailments."

/**
 * Suffocating Seliloquy
 */
/datum/action/cooldown/spell/undirected/song/suffocating_seliloquy
	name = "Suffocating Seliloquy"
	desc = "Continuously play a heavy tune that drowns non-audience members with Abyssor's rage."
	button_icon_state = "dirge_t3_base"
	background_icon_state = "dirge_t3_base"
	sound = 'sound/magic/debuffroll.ogg'
	invocation = "%DOWN TOO LONG IN HIS MIDNIGHT SEA!"
	cooldown_time = 120 SECONDS
	spell_cost = 60
	song_stack_effect = /datum/status_effect/stacking/playing_inspiration/target_nonaudience/suffocating_seliloquy
	inspiration_effect = /datum/status_effect/debuff/song/suffocationsong

/datum/status_effect/stacking/playing_inspiration/target_nonaudience/suffocating_seliloquy
	visual_icon_state = "dirge_t3_base"
	consumed_on_threshold = FALSE
	finishing_energy_cost = 5
	finishing_sound = 'sound/magic/debuffroll.ogg'
	range = 6

/datum/status_effect/stacking/playing_inspiration/target_nonaudience/suffocating_seliloquy/threshold_cross_effect()
	. = ..()
	stacks_consumed_effect()
	INVOKE_ASYNC(src, PROC_REF(add_stacks), -stacks + 1)

/datum/status_effect/debuff/song/suffocationsong
	id = "suffocationsong"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/suffocationsong
	duration = 15 SECONDS

/datum/status_effect/debuff/song/suffocationsong/tick()
	owner.adjustOxyLoss(1.6)

/atom/movable/screen/alert/status_effect/debuff/song/suffocationsong
	name = "Musical Suffocation!"
	desc = "I am suffocating from the song!"
	icon_state = "debuff"
