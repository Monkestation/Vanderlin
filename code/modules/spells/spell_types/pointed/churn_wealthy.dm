/datum/action/cooldown/spell/churn_wealthy
	name = "Churn Wealthy"
	desc = "Empowering the weak often involves destroying the strong."
	button_icon_state = "churnwealthy"
	sound = 'sound/magic/heal.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy

	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_cost = 40

	var/stacks_to_add = 3

/datum/action/cooldown/spell/churn_wealthy/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/churn_wealthy/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(owner.z != cast_on.z) //Stopping no-interaction snipes
		to_chat(owner, "<font color='yellow'>The Free-God compels me to face [cast_on] on level ground before I transact.</font>")
		return
	var/mammonsonperson = get_mammons_in_atom(cast_on)
	var/mammonsinbank = SStreasury.bank_accounts[cast_on]
	var/totalvalue = mammonsinbank + mammonsonperson
	if(HAS_TRAIT(cast_on, TRAIT_NOBLE_BLOOD) || HAS_TRAIT(cast_on, TRAIT_NOBLE_POWER))
		totalvalue += 101 // We're ALWAYS going to do a medium level smite minimum to nobles.
	if(totalvalue <=10)
		to_chat(owner, "<font color='yellow'>[cast_on] one has no wealth to hold against them.</font>")
		return
	if(totalvalue <= 30)
		owner.say("Wealth becomes woe!")
		cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
		cast_on.adjustFireLoss(30)
		playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
		return
	if(totalvalue <= 60)
		owner.say("Wealth becomes woe!")
		cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
		cast_on.adjustFireLoss(60)
		playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
		return
	if(totalvalue <= 100)
		owner.say("Wealth becomes woe!")
		cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
		cast_on.adjustFireLoss(80)
		cast_on.Stun(20)
		playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
		return
	if(totalvalue <= 200)
		owner.say("The Free-God rebukes!")
		cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
		cast_on.adjustFireLoss(100)
		cast_on.adjust_divine_fire_stacks(7)
		cast_on.Stun(20)
		cast_on.IgniteMob()
		playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
		return
	if(totalvalue <= 500)
		owner.say("The Free-God rebukes!")
		cast_on.visible_message(span_danger("[cast_on] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
		cast_on.adjustFireLoss(120)
		cast_on.adjust_divine_fire_stacks(9)
		cast_on.IgniteMob()
		cast_on.Stun(40)
		playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
		return
	if(totalvalue >= 501)
		cast_on.visible_message(span_danger("[cast_on] is smited with holy light!"), span_userdanger("I feel the weight of my wealth rend my soul apart!"))
		owner.say("Your final transaction! The Free-God rebukes!!")
		cast_on.Stun(60)
		cast_on.adjustFireLoss(120)
		cast_on.adjust_divine_fire_stacks(9)
		cast_on.IgniteMob()
		cast_on.emote("agony")
		playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
		explosion(get_turf(cast_on), light_impact_range = 1, flame_range = 1, smoke = FALSE)
