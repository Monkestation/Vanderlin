/obj/item/organ/wings
	name = "wings"
	desc = "A pair of wings. Those may or may not allow you to fly... or at the very least flap."
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_WINGS
	organ_efficiency = list(ORGAN_SLOT_WINGS = 100)

	///Whether a wing can be opened by the *wing emote. The sprite use a "_open" suffix, before their layer
	var/can_open
	///Whether an openable wing is currently opened
	var/wings_open
