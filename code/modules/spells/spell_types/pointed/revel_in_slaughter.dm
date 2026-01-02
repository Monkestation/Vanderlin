/datum/action/cooldown/spell/revel_in_slaughter
	name = "Revel in Slaughter"
	desc = "The blood of your enemy shall boil, their skin feeling as if it's being ripped apart! Graggar demands their blood must FLOW!!!"
	button_icon_state = "bloodsteal"
	sound = 'sound/magic/antimagic.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation = "YOUR BLOOD WILL BOIL TILL IT'S SPILLED!"
	invocation_type = INVOCATION_SHOUT
	attunements = list(
		/datum/attunement/blood = 0.5,
	)
	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_cost = 70

/datum/action/cooldown/spell/revel_in_slaughter/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return ishuman(cast_on)

/datum/action/cooldown/spell/revel_in_slaughter/before_cast()
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/success = 0
	for(var/obj/effect/decal/cleanable/blood/B in view(3, owner))
		success++
		qdel(B)
	if(!success)
		to_chat(owner, span_warning("I need blood around me to do this!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/revel_in_slaughter/cast(atom/cast_on, mob/living/user = usr)
	. = ..()
	if(!ishuman(cast_on))
		return FALSE
	var/mob/living/carbon/human/human_target = cast_on
	var/datum/physiology/phy = human_target.physiology
	phy.bleed_mod *= 1.5
	phy.pain_mod *= 1.5
	addtimer(VARSET_CALLBACK(phy, bleed_mod, phy.bleed_mod /= 1.5), 25 SECONDS)
	addtimer(VARSET_CALLBACK(phy, pain_mod, phy.pain_mod /= 1.5), 15 SECONDS)
	human_target.visible_message(span_danger("[human_target]'s wounds become inflamed as their vitality is sapped away!"))
	to_chat(human_target, span_warning("My skin feels like pins and needles, as if something were ripping and tearing at me!"))

