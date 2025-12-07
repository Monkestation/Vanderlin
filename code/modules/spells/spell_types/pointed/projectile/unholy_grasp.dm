/datum/action/cooldown/spell/projectile/blood_net
	name = "Unholy Grasp"
	desc = "Toss forth an unholy snare of blood and guts a short distance, summoned from your leftover trophies sacrificed to Graggar. Like a net, may it snare your target! You will need Viscera to use this."
	button_icon_state = "unholy_grasp"
	sound = 'sound/misc/stings/generic.ogg'
	charge_sound = 'sound/magic/charging_lightning.ogg'

	spell_type = SPELL_MIRACLE //it does count as one, funnily enough.
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy

	attunements = list(
		/datum/attunement/blood = 0.5,
	)

	invocation = "throws out his hand!"
	invocation_type = INVOCATION_EMOTE

	charge_time = 2 SECONDS
	charge_drain = 1
	cooldown_time = 10 SECONDS
	spell_cost = 30
	projectile_type = /obj/projectile/magic/unholy_grasp

/datum/action/cooldown/spell/projectile/blood_net/before_cast()
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/obj/item/held_item = owner.get_active_held_item()
	if(istype(held_item, /obj/item/alch/viscera))
		qdel(held_item)
	else
		to_chat(owner, "I'm missing viscera to cast this..")
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/obj/projectile/magic/unholy_grasp
	name = "viceral organ net"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 3 //Net, So Low range.

/obj/projectile/magic/unholy_grasp/on_hit(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(!iscarbon(hit_atom))	//if it gets caught or the target can't be cuffed.
		return
	ensnare(hit_atom)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/C)		//Same code as net but with le flavor.
	if(!C.legcuffed && C.num_legs >= 2)
		visible_message("<span class='danger'>\The [src] ensnares [C] in vicera!</span>")
		C.legcuffed = src
		forceMove(C)
		C.update_inv_legcuffed()
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		to_chat(C, "<span class='danger'>\The [src] ensnares you!</span>")
		//C.Knockdown(knockdown) //We don't seems to use the knockdown, good enough tbh.
		C.apply_status_effect(/datum/status_effect/debuff/netted)
		playsound(src, 'sound/combat/caught.ogg', 50, TRUE)
