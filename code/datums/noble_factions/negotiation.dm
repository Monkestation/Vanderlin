#define PATRONAGE_MAX_ROUNDS 6

/datum/patronage_negotiation
	var/mob/living/carbon/human/noble
	var/mob/living/carbon/human/target
	var/rounds_used = 0

/datum/patronage_negotiation/New(mob/noble, mob/target)
	. = ..()
	src.noble = noble
	src.target = target

/datum/patronage_negotiation/proc/start()
	if(!validate_parties())
		return

	var/opening_offer = tgui_input_number(noble, "Daily wage to offer [target.real_name]?", "Offer Patronage", 0, 1000, 0)
	if(!can_still_negotiate() || isnull(opening_offer))
		cancel("[noble.real_name] never made an offer.")
		return

	negotiate(responder = target, proposer = noble, offer = opening_offer)

/// responder is being asked to accept/counter/decline the proposer's offer
/datum/patronage_negotiation/proc/negotiate(mob/living/carbon/human/responder, mob/living/carbon/human/proposer, offer)
	if(!can_still_negotiate())
		return

	rounds_used++
	if(rounds_used > PATRONAGE_MAX_ROUNDS)
		cancel("Negotiations between [noble.real_name] and [target.real_name] broke down.")
		return

	var/choice = tgui_alert(responder, "[proposer.real_name] offers [offer] mammon/day in patronage. Accept?", "Patronage Offer", list("Accept", "Counter-offer", "Decline"))

	if(!can_still_negotiate())
		return

	switch(choice)
		if("Accept")
			finalize(offer)
		if("Decline")
			cancel("[responder.real_name] declined [proposer.real_name]'s offer.")
		if("Counter-offer")
			var/counter = tgui_input_number(responder, "Counter-offer (daily wage)?", "Patronage Offer", 0, 1000, offer)
			if(!can_still_negotiate())
				return
			if(isnull(counter))
				cancel("[responder.real_name] didn't respond. Negotiations ended.")
				return
			// roles flip: the responder is now the proposer
			negotiate(responder = proposer, proposer = responder, offer = counter)
		else
			cancel("Negotiations timed out.")

/datum/patronage_negotiation/proc/validate_parties()
	if(!noble?.client || !target?.client)
		return FALSE

	var/datum/job/target_job = SSjob.GetJob(target.job)

	if(!target_job?.is_guild_head)
		to_chat(noble, span_warning("[target.real_name] isn't in a position to accept patronage."))
		return FALSE

	if(target.mind?.noble_faction)
		to_chat(noble, span_warning("[target.real_name] already answers to a patron."))
		return FALSE

	return TRUE

/// Re-checked before every step in case someone died/disconnected/got patronized elsewhere mid-negotiation
/datum/patronage_negotiation/proc/can_still_negotiate()
	if(!noble?.client || !target?.client)
		return FALSE
	var/datum/job/job = SSjob.GetJob(target.job)
	var/datum/guild/guild = get_or_create_guild(job?.guild_type)
	if(guild?.patron_faction) // someone else beat us to it
		return FALSE
	return TRUE

/datum/patronage_negotiation/proc/finalize(wage)
	var/datum/noble_faction/faction = noble.mind?.noble_faction
	if(!faction)
		faction = new /datum/noble_faction(noble)
		noble.mind.noble_faction = faction

	var/datum/job/job = SSjob.GetJob(target.job)
	var/datum/guild/guild = get_or_create_guild(job?.guild_type)

	guild?.apply_patronage(faction, wage)

	to_chat(noble, span_notice("[guild.name] has accepted your patronage at [wage] mammon/day."))
	for(var/mob/living/carbon/human/member as anything in guild.members)
		to_chat(member, span_notice("Your guild is now patronized by [noble.real_name] at [wage] mammon/day."))

/datum/patronage_negotiation/proc/cancel(reason)
	if(noble)
		to_chat(noble, span_warning(reason))
	if(target)
		to_chat(target, span_warning(reason))

#undef PATRONAGE_MAX_ROUNDS

/datum/action/cooldown/offer_patronage
	name = "Offer Patronage"
	desc = "Offer your patronage to a guild, negotiating a daily wage with its head."
	button_icon_state = "patronage"
	click_to_activate = TRUE
	cooldown_time = 10 MINUTES
	retrigger_after_cooldown = FALSE

/datum/action/cooldown/offer_patronage/Activate(atom/target)
	var/mob/living/carbon/human/noble = owner
	if(!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/head = target
	var/datum/job/job = SSjob.GetJob(head.job)
	var/datum/guild/guild = get_or_create_guild(job?.guild_type)
	if(!guild)
		to_chat(noble, span_warning("[head.real_name] belongs to no guild."))
		return FALSE
	if(!job.is_guild_head)
		to_chat(noble, span_warning("[head.real_name] doesn't speak for their guild."))
		return FALSE
	if(guild.patron_faction)
		to_chat(noble, span_warning("[guild.name] already answers to a patron."))
		return FALSE

	var/datum/patronage_negotiation/negotiation = new(noble, head)
	negotiation.start()
	StartCooldown()
	return TRUE
