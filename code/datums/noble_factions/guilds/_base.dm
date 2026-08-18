/datum/guild
	var/name = "Unnamed Guild"
	var/list/mob/living/carbon/human/members = list()

	/// Set once a noble successfully patronizes this guild. Null = independent.
	var/datum/noble_faction/patron_faction
	var/patronage_wage = 0

/datum/guild/New(guild_name, guild_id)
	. = ..()
	if(guild_name)
		name = guild_name
	GLOB.guilds[type] = src
	SStreasury.create_guild_account(src)

/datum/guild/Destroy(force)
	GLOB.guilds -= type
	members = null
	patron_faction = null
	return ..()

/datum/guild/proc/add_member(mob/living/carbon/human/member)
	if(!member || (member in members))
		return FALSE
	members += member
	// A guild that already has a patron auto-enrolls new members under the same terms
	if(patron_faction)
		patron_faction.add_member(member)
	return TRUE

/datum/guild/proc/remove_member(mob/living/carbon/human/member)
	if(!(member in members))
		return FALSE
	members -= member
	if(patron_faction)
		patron_faction.remove_member(member)
	return TRUE

/// Called once, when a patronage negotiation with the guild's head succeeds.
/// Brings every current member into the noble's faction, not just the negotiator.
/datum/guild/proc/apply_patronage(datum/noble_faction/faction, wage)
	patron_faction = faction
	patronage_wage = wage
	for(var/mob/living/carbon/human/member as anything in members)
		faction.add_member(member)

/datum/guild/proc/break_patronage()
	if(!patron_faction)
		return
	for(var/mob/living/carbon/human/member as anything in members)
		patron_faction.remove_member(member)
	patron_faction = null
	patronage_wage = 0

///IK we wanted a makers guild as an overarching guild but we can make these subguilds of it because giving someone executive power over like 40 jobs is to much
/datum/guild/blacksmith
	name = "Smith's Guild"

/datum/guild/tailor
	name = "Tailor's Guild"

/datum/guild/inn
	name = "Innkeeper's Guild"

/datum/guild/merc
	name = "Mercenary Guild"

/datum/guild/adv_guild
	name = "Adventurer's Guild"

/datum/guild/thieves
	name = "Thieves Guild"

/datum/guild/clinic
	name = "Medic's Guild"

/datum/guild/mage
	name = "Magician's College"

/datum/guild/constructors
	name = "Carpenter's Guild"

/datum/guild/alchemy
	name = "Alchemist's Guild"

/datum/guild/mason
	name = "Stone-Mason's Guild"

/datum/guild/artificer
	name = "Artificer's Guild"

/datum/guild/food
	name = "Farmer's Guild"

/datum/guild/hunter
	name = "Hunter's Guild"

/datum/guild/merchant
	name = "Merchant's Guild"

