/mob/living/simple_animal/hostile/retaliate/troll/rous
	name = "rous abomination"
	desc = "A massive, grotesque creature formed from the fused bodies of several giant rous."

	icon = 'icons/mob/creacher/trolls/rous_abomination.dmi'
	icon_state = "rous"

	health = ROUSABOM_HEALTH
	maxHealth = ROUSABOM_HEALTH

	melee_damage_lower = 25
	melee_damage_upper = 50

	base_constitution = 14
	base_endurance = 14

	base_intents = list(/datum/intent/unarmed/claw, /datum/intent/simple/bigbite)

	faction = list(FACTION_RATS)

	var/knockpack_prob = 30
	var/rous_children = 3

/mob/living/simple_animal/hostile/retaliate/troll/rous/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/rousabomination/aggro (1).ogg','sound/vo/mobs/rousabomination/aggro (2).ogg','sound/vo/mobs/rousabomination/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/rousabomination/pain (1).ogg','sound/vo/mobs/rousabomination/pain (2).ogg','sound/vo/mobs/rousabomination/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/rousabomination/death (1).ogg','sound/vo/mobs/rousabomination/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/rousabomination/rat_life.ogg','sound/vo/mobs/rousabomination/rat_life2.ogg','sound/vo/mobs/rousabomination/rat_life3.ogg')
		if("cidle")
			return pick('sound/vo/mobs/rousabomination/aggro (1).ogg','sound/vo/mobs/rousabomination/rat_life2.ogg')

/mob/living/simple_animal/hostile/retaliate/troll/rous/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(prob(knockpack_prob))
			L.Knockdown(2 SECONDS)
			L.throw_at(get_edge_target_turf(src, src.dir), 2, 3)

/mob/living/simple_animal/hostile/retaliate/troll/rous/death(gibbed)
	..()
	gib()

/mob/living/simple_animal/hostile/retaliate/troll/rous/gib()
	for(var/i = 1 to rous_children)
		new /mob/living/simple_animal/hostile/retaliate/bigrat(get_turf(src))
	to_chat(src, span_danger("The flesh of the abomination splits apart and several giant rous scurry out!"))
	..()


