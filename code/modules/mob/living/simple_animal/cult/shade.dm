/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit."
	gender = PLURAL
	icon = 'icons/mob/nonhuman-player/cult.dmi'
	icon_state = "shade_cult"
	icon_living = "shade_cult"
	mob_biotypes = MOB_SPIRIT | MOB_UNDEAD
	maxHealth = 40
	health = 40
	status_flags = CANPUSH
	speak_emote = list("hisses")
	response_help_continuous = "puts their hand through"
	response_help_simple = "put your hand through"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	response_harm_continuous = "punches"
	response_harm_simple = "punch"
	melee_damage_lower = 5
	melee_damage_upper = 12
	attack_verb_continuous = "metaphysically strikes"
	attack_verb_simple = "metaphysically strike"
	speed = -1
	del_on_death = TRUE
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, STAMINA = 0, OXY = 1)
	/// Theme controls color. THEME_CULT is red THEME_WIZARD is purple and THEME_HOLY is blue
	var/theme
	/// The different flavors of goop shades can drop, depending on theme.
	var/static/list/remains_by_theme = list(
	)

/mob/living/simple_animal/shade/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/simple_flying)
	if(isnull(theme))
		return
	icon_state = "shade_[theme]"
	// var/remains = remains_by_theme[theme]
	// if(remains)
	// 	AddElement(/datum/element/death_drops, remains)

/mob/living/simple_animal/shade/update_icon_state()
	. = ..()
	if(!isnull(theme))
		icon_state = "shade_[theme]"
	icon_living = icon_state

// /mob/living/simple_animal/shade/death()
// 	if(death_message == initial(death_message))
// 		death_message = "lets out a contented sigh as [p_their()] form unwinds."
// 	..()

/mob/living/simple_animal/shade/can_suicide()
	if(GetComponent(/datum/component/soulstoned)) //do not suicide while soulstoned
		return FALSE
	return ..()

/mob/living/simple_animal/shade/suicide_log(obj/item/suicide_tool)
	..()
