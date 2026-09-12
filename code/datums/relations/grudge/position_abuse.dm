
/datum/grudge_type/job
	abstract_type = /datum/grudge_type/job

/datum/grudge_type/job/knight_over_guardsman
	grudge_bitflags = GARRISON
	aggressor_titles = list(/datum/job/royalknight::title, /datum/job/lieutenant::title)
	victim_titles = list(/datum/job/guardsman::title, /datum/job/men_at_arms::title)
	grudge_name = "Abuse of Authority"
	aggressor_text = "You assigned them the worst duties for weeks and made sure they knew it was personal."
	victim_text = "They used their rank to make your life miserable with no recourse available to you."

/datum/grudge_type/job/lord_over_serf
	grudge_bitflags = NOBLEMEN | SERFS
	aggressor_titles = list(/datum/job/lord::title, /datum/job/steward::title)
	victim_titles = list(/datum/job/blacksmith::title, /datum/job/tailor::title, /datum/job/innkeep::title)
	grudge_name = "Unjust Levy"
	aggressor_text = "You imposed an extra tithe on their workshop that they could ill afford."
	victim_text = "They singled out your trade for an extra levy that nearly ruined you."

/datum/grudge_type/job/priest_over_serf
	grudge_bitflags = CHURCHMEN | SERFS
	aggressor_titles = list(/datum/job/priest::title, /datum/job/gmtemplar::title)
	victim_titles = list(/datum/job/innkeep::title, /datum/job/blacksmith::title, /datum/job/tailor::title)
	grudge_name = "Public Penance"
	aggressor_text = "You called them out before the congregation for a sin that was none of the church's business."
	victim_text = "They dragged your private failings before the whole congregation and revelled in your shame."
