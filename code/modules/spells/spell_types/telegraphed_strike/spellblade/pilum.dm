/datum/action/cooldown/spell/projectile/pilum
	name = "Pilum"
	desc = "A borrowed art - spellblades of tradition learned to imbue their throw with ice essence, \
		flash-chilling the target on impact. Applies 2 frost stacks on hit. \
		At 3+ momentum: consumes 3 for a heavier throw that applies 3 stacks, guaranteeing a freeze on any frosted target. \
		Toggle arc mode (Shift+G) to arc over allies."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "azurean_javelin"
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'

	projectile_type = /obj/projectile/energy/pilum
	projectile_type_arc = /obj/projectile/energy/pilum/arc
	cast_range = 15

	required_form = FORM_ICE
	required_technique = TECHNIQUE_IMBUE

	spell_cost = 25

	invocation = "Pilum Azureum!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 10 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/base_damage = 35
	var/empowered_damage = 50
	var/momentum_cost = 3
	var/cached_damage = 0
	var/cached_empowered = FALSE

/datum/action/cooldown/spell/projectile/pilum/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!H.arcyne_get_weapon())
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	cached_empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		cached_empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered pilum!"))

	cached_damage = cached_empowered ? empowered_damage : base_damage

	if(cached_empowered)
		projectile_type = /obj/projectile/energy/pilum/empowered
		projectile_type_arc = /obj/projectile/energy/pilum/empowered/arc
	else
		projectile_type = /obj/projectile/energy/pilum
		projectile_type_arc = /obj/projectile/energy/pilum/arc

	. = ..()

/datum/action/cooldown/spell/projectile/pilum/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	..()
	to_fire.damage = cached_damage

/obj/projectile/energy/pilum
	name = "Pilum"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "air_blade_stab"
	color = "#88BFFF"
	damage = 35
	woundclass = BCLASS_STAB
	nodamage = FALSE
	speed = 1.5
	hitsound = 'sound/combat/hits/bladed/genthrust (1).ogg'
	/// How many frost stacks to apply on hit
	var/frost_stacks = 1

/obj/projectile/energy/pilum/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.can_block_magic())
			visible_message(span_warning("[src] disperses on contact with [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			return BULLET_ACT_BLOCK
		if(out_of_effective_range())
			return
		apply_frost_stack(L, frost_stacks)
		to_chat(L, span_danger("An icy pilum strikes true - the cold seeps into my bones!"))
		if(firer)
			log_combat(firer, L, "pilum-struck")

/obj/projectile/energy/pilum/empowered
	name = "Empowered Pilum"
	icon_state = "youreyesonly"
	color = "#4CADEE"
	frost_stacks = 3

/obj/projectile/energy/pilum/arc
	name = "Arced Pilum"
	damage = 26
	arcshot = TRUE

/obj/projectile/energy/pilum/empowered/arc
	name = "Empowered Arced Pilum"
	damage = 26
	arcshot = TRUE
