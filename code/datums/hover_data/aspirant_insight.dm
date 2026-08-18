/datum/hover_data/noble_faction_head
	var/pixel_y_offset = 32

/datum/hover_data/noble_faction_head/setup_data(atom/source, mob/enterer)
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/head = source
	var/datum/noble_faction/faction = head.mind?.noble_faction
	if(!faction)
		return
	if(faction.head_ref?.resolve() != head)
		return // only show for the actual current head, not rank-and-file members
	if(!enterer.client)
		return

	var/image/hover_image = image(/obj/effect/overlay/hover, loc = source)
	hover_image.pixel_y = pixel_y_offset
	hover_image.maptext_height = 64
	hover_image.maptext_width = 128
	hover_image.maptext = MAPTEXT("<span style='color:#e8c468'>[faction.name]</span>\n<span style='color:white'>[length(faction.members)] member[length(faction.members) == 1 ? "" : "s"]</span>")

	add_client_image(hover_image, enterer.client)
