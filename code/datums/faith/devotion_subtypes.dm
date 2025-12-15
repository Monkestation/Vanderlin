/datum/devotion/divine/astrata
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/healing,
		CLERIC_T1 = /datum/action/cooldown/spell/sacred_flame,
		CLERIC_T2 = /datum/action/cooldown/spell/healing/greater,
		CLERIC_T3 = /datum/action/cooldown/spell/revive,
	)

/datum/devotion/divine/noc
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/healing,
		CLERIC_T1 = /datum/action/cooldown/spell/status/invisibility,
		CLERIC_T2 = /datum/action/cooldown/spell/blindness/miracle,
		CLERIC_T3 = /datum/action/cooldown/spell/projectile/moonlit_dagger,
	)

/datum/devotion/divine/dendor
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/healing,
		CLERIC_T1 = /datum/action/cooldown/spell/undirected/bless_crops,
		CLERIC_T2 = /datum/action/cooldown/spell/undirected/beast_sense,
		CLERIC_T3 = /datum/action/cooldown/spell/beast_tame,
	)

/datum/devotion/divine/abyssor
	miracles = list(
		CLERIC_T0 = list(/datum/action/cooldown/spell/healing, /datum/action/cooldown/spell/undirected/conjure_item/summon_leech),
		CLERIC_T1 = /datum/action/cooldown/spell/projectile/swordfish,
		CLERIC_T2 = /datum/action/cooldown/spell/undirected/conjure_item/summon_trident/miracle,
		CLERIC_T3 = /datum/action/cooldown/spell/ocean_embrace,
	)

/datum/devotion/divine/necra
	miracles = list(
		CLERIC_T0 = list(/datum/action/cooldown/spell/healing, /datum/action/cooldown/spell/avert),
		CLERIC_T1 = /datum/action/cooldown/spell/burial_rites,
		CLERIC_T2 = list(/datum/action/cooldown/spell/undirected/locate_dead, /datum/action/cooldown/spell/aoe/abrogation, /datum/action/cooldown/spell/undirected/soul_speak, ),
		CLERIC_T3 = /datum/action/cooldown/spell/aoe/churn_undead,
	)
	traits = list(TRAIT_DEATHSIGHT)

/datum/devotion/divine/ravox
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/healing,
		CLERIC_T1 = /datum/action/cooldown/spell/undirected/call_to_arms,
		CLERIC_T2 = /datum/action/cooldown/spell/undirected/divine_strike,
		CLERIC_T3 = /datum/action/cooldown/spell/persistence,
	)

/datum/devotion/divine/xylix
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/healing,
		CLERIC_T1 = /datum/action/cooldown/spell/undirected/list_target/vicious_mimicry,
		CLERIC_T2 = /datum/action/cooldown/spell/status/wheel,
		CLERIC_T3 = /datum/action/cooldown/spell/undirected/jaunt/illusory_prop,
	)

/datum/devotion/divine/pestra
	miracles = list(
		CLERIC_T0 = list(/datum/action/cooldown/spell/healing, /datum/action/cooldown/spell/undirected/conjure_item/summon_leech/pestra),
		CLERIC_T1 = /datum/action/cooldown/spell/diagnose/holy,
		CLERIC_T2 = /datum/action/cooldown/spell/attach_bodypart,
		CLERIC_T3 = /datum/action/cooldown/spell/cure_rot,
	)

/datum/devotion/divine/malum
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/healing,
		CLERIC_T1 = /datum/action/cooldown/spell/status/vigorous_craft,
		CLERIC_T2 = /datum/action/cooldown/spell/hammer_fall,
		CLERIC_T3 = /datum/action/cooldown/spell/heat_metal,
	)

/datum/devotion/divine/eora
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/healing,
		CLERIC_T1 = /datum/action/cooldown/spell/instill_perfection,
		CLERIC_T2 = /datum/action/cooldown/spell/projectile/eora_curse,
		CLERIC_T3 = /datum/action/cooldown/spell/eoran_bloom,
	)
	favored_species = list(SPEC_ID_HARPY)
	favored_miracles = list(
		CLERIC_T3 = /datum/action/cooldown/spell/charm/eoran
	)

// Inhumen
/datum/devotion/inhumen/make_cleric()
	. = ..()
	miracles_extra += list(
		/datum/action/cooldown/spell/healing/profane,
	)

/datum/devotion/inhumen/make_templar()
	. = ..()
	miracles_extra += list(
		/datum/action/cooldown/spell/healing/profane,
	)

/datum/devotion/inhumen/make_churching()
	. = ..()
	miracles_extra += list(
		/datum/action/cooldown/spell/healing/profane,
	)

/datum/devotion/inhumen/make_acolyte()
	. = ..()
	miracles_extra += list(
		/datum/action/cooldown/spell/healing/profane,
	)

/datum/devotion/inhumen/zizo
	miracles = list(
		CLERIC_T0 = list(/datum/action/cooldown/spell/undirected/touch/orison, /datum/action/cooldown/spell/aoe/snuff),
		CLERIC_T1 = /datum/action/cooldown/spell/projectile/profane,
		CLERIC_T2 = /datum/action/cooldown/spell/conjure/raise_lesser_undead,
		CLERIC_T3 = /datum/action/cooldown/spell/undirected/rituos,
	)
	traits = list(TRAIT_DEATHSIGHT)

/datum/devotion/inhumen/graggar
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/undirected/bloodrage,
		CLERIC_T1 = /datum/action/cooldown/spell/undirected/call_to_slaughter,
		CLERIC_T2 = /datum/action/cooldown/spell/projectile/blood_net,
		CLERIC_T3 = /datum/action/cooldown/spell/revel_in_slaughter,
	)

/datum/devotion/inhumen/matthios
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/appraise/holy,
		CLERIC_T1 = /datum/action/cooldown/spell/transact,
		CLERIC_T2 = /datum/action/cooldown/spell/beam/equalize,
		CLERIC_T3 = /datum/action/cooldown/spell/churn_wealthy,
	)

/datum/devotion/inhumen/baotha
	miracles = list(
		CLERIC_T0 = /datum/action/cooldown/spell/find_flaw,
		CLERIC_T1 = /datum/action/cooldown/spell/baothablessings,
		CLERIC_T2 = /datum/action/cooldown/spell/projectile/blowingdust,
		CLERIC_T3 = /datum/action/cooldown/spell/painkiller,
	)
