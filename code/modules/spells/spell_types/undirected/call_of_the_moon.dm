/datum/action/cooldown/spell/undirected/howl/call_of_the_moon
	name = "Call of the Moon"
	desc = "Draw upon the secrets of the hidden firmament to converse with the mooncursed."
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/dendor)
	has_visual_effects = TRUE

	use_language = TRUE
	spell_cost = 50

/datum/action/cooldown/spell/undirected/howl/call_of_the_moon/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	// only usable at night
	if (!GLOB.tod == "night")
		to_chat(owner, span_warning("I must wait for the hidden moon to rise before I may call upon it."))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/howl/call_of_the_moon/cast(atom/cast_on)
	// if they don't have beast language somehow, give it to them
	if (!owner.has_language(/datum/language/beast))
		owner.grant_language(/datum/language/beast)
		to_chat(owner, span_boldnotice("The vestige of the hidden moon high above reveals His truth: the knowledge of beast-tongue was in me all along."))
		to_chat(owner, span_boldwarning("So it is murmured in the Earth and Air: the Call of the Moon is sacred, and to share knowledge gleaned from it with those not of Him is a SIN."))
		to_chat(owner, span_boldwarning("Ware thee well, child of Dendor."))

	. = ..()
