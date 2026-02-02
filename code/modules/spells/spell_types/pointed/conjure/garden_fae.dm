/datum/action/cooldown/spell/conjure/garden_fae
	name = "Lively Bloom"
	desc = "Summons a gardener that will tend your crops."
	button_icon_state = "garden"
	sound = 'sound/items/dig_shovel.ogg'
	invocation = "Treefather, whisper life into this herb."
	invocation_type = INVOCATION_WHISPER
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/dendor)
	cooldown_time = 5 MINUTES
	spell_cost = 50
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 1.2
	summon_radius = 0
	self_cast_possible = FALSE
	attunements = list(
		/datum/attunement/arcyne = 0.3,
		/datum/attunement/life = 0.7
	)

	var/datum/weakref/gardener_ref
	var/static/list/garden_fae = list(
		/obj/structure/flora/grass/herb/atropa      = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/atropa,
		/obj/structure/flora/grass/herb/matricaria  = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/matricaria,
		/obj/structure/flora/grass/herb/symphitum   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/symphitum,
		/obj/structure/flora/grass/herb/taraxacum   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/taraxacum,
		/obj/structure/flora/grass/herb/euphrasia   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/euphrasia,
		/obj/structure/flora/grass/herb/paris       = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/paris,
		/obj/structure/flora/grass/herb/calendula   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/calendula,
		/obj/structure/flora/grass/herb/mentha      = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/mentha,
		/obj/structure/flora/grass/herb/urtica      = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/urtica,
		/obj/structure/flora/grass/herb/salvia      = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/salvia,
		/obj/structure/flora/grass/herb/hypericum   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/hypericum,
		/obj/structure/flora/grass/herb/benedictus  = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/benedictus,
		/obj/structure/flora/grass/herb/valeriana   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/valeriana,
		/obj/structure/flora/grass/herb/artemisia   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/artemisia,
		/obj/structure/flora/grass/herb/euphorbia   = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/euphorbia,
		/obj/structure/flora/grass/herb/rosa        = /mob/living/simple_animal/hostile/retaliate/fae/agriopylon/rosa
	)

/datum/action/cooldown/spell/conjure/garden_fae/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(!istype(cast_on, /obj/structure/flora/grass/herb))
		to_chat(owner, span_warning("You must target a wild herb!"))
		return . | SPELL_CANCEL_CAST
	var/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/gardener = gardener_ref?.resolve()
	if(!QDELETED(gardener))
		qdel(gardener)
	gardener_ref = null
	var/mob_type = garden_fae[cast_on.type]
	if(!mob_type)
		to_chat(owner, span_warning("Your gardener crumbles into dust."))
		return . | SPELL_CANCEL_CAST
	summon_type = list(mob_type)

/datum/action/cooldown/spell/conjure/garden_fae/cast(atom/cast_on)
	var/turf/T = get_turf(cast_on)
	qdel(cast_on)
	return ..(T)

/datum/action/cooldown/spell/conjure/garden_fae/post_summon(atom/summoned_object, atom/cast_on)
	var/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/gardener = summoned_object
	if(!gardener)
		return
	gardener.befriend(owner)
	gardener.owner = owner
	gardener_ref = WEAKREF(gardener)

/datum/action/cooldown/spell/conjure/garden_fae/Destroy()
	var/mob/living/simple_animal/hostile/retaliate/fae/agriopylon/gardener = gardener_ref?.resolve()
	if(!QDELETED(gardener))
		qdel(gardener)
	gardener_ref = null
	return ..()

