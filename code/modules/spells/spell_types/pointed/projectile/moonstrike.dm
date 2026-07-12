/datum/action/cooldown/spell/projectile/moonstrike
	name = "Moonstrike"
	desc = "Cast forth concentrated moonlight!"
	button_icon_state = "moonstrike"
	sound = 'sound/misc/stings/generic.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/noc)

	charge_time = 2 SECONDS
	charge_slowdown = 0.3
	cooldown_time = 30 SECONDS
	spell_cost = 35

	projectile_type = /obj/projectile/magic/energy/moonstrike

/datum/action/cooldown/spell/projectile/moonstrike/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(GLOB.tod == DAWN || GLOB.tod == DAY)
		to_chat(owner, span_warning("I cannot wield moonlight during the day!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/obj/projectile/magic/energy/moonstrike
	name = "moonstrike"
	icon_state = "slash"
	damage = 30
	damage_type = BURN
	woundclass = BCLASS_CUT
	armor_penetration = 10
	nodamage = FALSE
	flag = "piercing"
	speed = 2
	spread = 4
