
/datum/quirk/black_briar
	name = "Host of the Black Briar"
	desc = "Brambles writhe beneath my skin."
	random_exempt = TRUE
	quirk_category = null
	preview_render = FALSE
	available = FALSE

/datum/quirk/black_briar/on_spawn()
	. = ..()
	var/datum/wound/black_briar_curse/chest/root = owner.has_wound(/datum/wound/black_briar_curse/chest)
	if(root) // we already had a root, so remove the thing that even gave us this
		root.remove_immunity(owner)
		return
	var/obj/item/bodypart/bp = owner.get_bodypart() // defaults to chest
	//forcing this lets us ignore godmode from people who are advclassing
	root = bp?.add_wound(/datum/wound/black_briar_curse/chest, TRUE, forced = TRUE)
	root?.infection = root.max_infection * BBC_STAGE_LATE
	root?.infection_percent = BBC_STAGE_LATE
