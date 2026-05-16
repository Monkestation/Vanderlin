/datum/action/cooldown/spell/undirected/song/rejuvenation_song
	name = "Healing Hymn"
	desc = "Recuperate your allies' bodies with your song! Refills health slowly over time!"
	button_icon_state = "melody_t3_base"
	invocation = "plays a beautiful, stirring song. The world around them becomes more vivid."
	invocation_self_message = "you play a beautiful, stirring song. The world around them becomes more vivid."
	song_effect = /datum/status_effect/buff/playing_melody/rejuvenation

/datum/status_effect/buff/playing_melody/rejuvenation
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt3
	buff_to_apply = /datum/status_effect/buff/healing/rejuvenationsong
	buff_to_apply_full = /datum/status_effect/buff/healing/rejuvenationsong/full

/datum/status_effect/buff/healing/rejuvenationsong
	id = "healingrejuvesong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 15 SECONDS
	healing_on_tick = 0.6 // Lesser bard (66%)
	outline_colour = "#c92f2f"

/datum/status_effect/buff/healing/rejuvenationsong/full
	healing_on_tick = 1 // Full bard (100%)

/datum/status_effect/buff/healing/rejuvenationsong/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#660759"
	var/list/wCount = owner.get_wounds()
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.adjust_bloodvolume(healing_on_tick + 1)
	if(length(wCount) > 0)
		if(iscarbon(owner))
			var/mob/living/carbon/carbon = owner
			for(var/datum/injury/injury in carbon.all_injuries)
				if(!(injury.damage_type in list(WOUND_SLASH, WOUND_PIERCE, WOUND_BITE, WOUND_BLUNT)))
					continue
				injury.heal_damage(healing_on_tick)
		owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise))
		owner.update_damage_overlays()

	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

	var/mob/living/carbon/human/human = owner
	if(!istype(human))
		return
	for(var/datum/injury/injury in human.all_injuries)
		if(!healing_on_tick)
			break
		if(injury.damage_type == WOUND_DIVINE)
			continue
		healing_on_tick = injury.heal_damage(healing_on_tick)
