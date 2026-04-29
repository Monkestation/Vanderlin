/datum/action/cooldown/spell/projectile/profane
	name = "Profane"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If you hold pieces of bone in your other hand, you will coax a much stronger lance of bone into being."
	button_icon_state = "profane"
	sound = 'sound/misc/stings/generic.ogg'
	charge_sound = 'sound/magic/vlightning.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	invocation = "Oblino!"
	invocation_type = INVOCATION_SHOUT

	attunements = list(
		/datum/attunement/death = 0.3,
		/datum/attunement/blood = 0.3,
	)

	charge_drain = 1
	charge_time = 2 SECONDS
	charge_slowdown = 0.3
	cooldown_time = 10 SECONDS
	spell_cost = 35
	projectile_type = /obj/projectile/magic/profane

/datum/action/cooldown/spell/projectile/profane/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/obj/item/held_item = owner.get_active_held_item()
	var/big_cast = FALSE
	if(istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bonez = held_item
		if(bonez.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE
	else if(istype(held_item, /obj/item/alch/bone))
		qdel(held_item)
		projectile_type = /obj/projectile/magic/profane/major
		big_cast = TRUE
	if(big_cast)
		owner.visible_message(span_danger("[owner] conjures and hurls a vicious lance of bone!"), span_notice("I hurl forth a vicious lance of profaned bone!"))
	else
		owner.visible_message(span_danger("[owner] directs forth a splinter of bone!"), span_notice("I fling forth a shard of profaned bone!"))

/datum/action/cooldown/spell/projectile/profane/after_cast(atom/cast_on)
	. = ..()
	projectile_type = /obj/projectile/magic/profane //In case you got major profane.

/obj/projectile/magic/profane
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	nodamage = FALSE
	damage_type = BRUTE
	damage = 20 //??? Correct me if i'm wrong but isn't that like a lot of damages for a spell
	range = 8
	var/embed_prob = 10

/obj/projectile/magic/profane/major
	name = "profaned bone lance"
	damage = 35
	embed_prob = 30

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()
	if(iscarbon(target) && prob(embed_prob))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/victim_limb = pick(carbon_target.bodyparts)
		var/obj/item/bone/splinter/our_splinter = new
		victim_limb.add_embedded_object(our_splinter, FALSE, TRUE)

/obj/item/bone/splinter
	name = "bone splinter"
	embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 25,
		"embedded_fall_chance" = 5,
	)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()
	to_chat(user, span_danger("[src] crumbles into dust..."))
	qdel(src)
