GLOBAL_LIST_INIT(noble_positions, list(
	/datum/job/lord::title,
	/datum/job/consort::title,
	/datum/job/hand::title,
	/datum/job/prince::title,
	/datum/job/captain::title,
	/datum/job/steward::title,
	/datum/job/magician::title,
	/datum/job/archivist::title,
	/datum/job/courtphys::title,
	/datum/job/minor_noble::title,
))
GLOBAL_PROTECT(noble_positions)

GLOBAL_LIST_INIT(garrison_positions, list(
	/datum/job/royalknight::title,
	/datum/job/veteran::title,
	/datum/job/guardsman::title,
	/datum/job/lieutenant::title,
	/datum/job/men_at_arms::title,
	/datum/job/gatemaster::title,
	/datum/job/jailor::title,
	/datum/job/dungeoneer::title,
	/datum/job/town_elder::title,
	/datum/job/forestwarden::title,
	/datum/job/forestguard::title,
	/datum/job/persistence/caravanguard::title,
	))
GLOBAL_PROTECT(garrison_positions)

GLOBAL_LIST_INIT(church_positions, list(
	/datum/job/priest::title,
	/datum/job/monk::title,
	/datum/job/undertaker::title,
	/datum/job/templar::title,
	))
GLOBAL_PROTECT(church_positions)

GLOBAL_LIST_INIT(inquisition_positions, list(
	/datum/job/inquisitor::title,
	/datum/job/orthodoxist::title,
	/datum/job/absolver::title,
	/datum/job/adept::title,
	))
GLOBAL_PROTECT(inquisition_positions)



GLOBAL_LIST_INIT(serf_positions, list(
	/datum/job/innkeep::title,
	/datum/job/armorsmith::title,
	/datum/job/weaponsmith::title,
	/datum/job/tailor::title,
	/datum/job/alchemist::title,
	/datum/job/artificer::title,
	/datum/job/matron::title,
	/datum/job/feldsher::title,
	/datum/job/apothecary::title,
	/datum/job/scribe::title,
	/datum/job/gaffer::title,
	/datum/job/butler::title,
	/datum/job/persistence/carpenter::title,
	/datum/job/persistence/stonemason::title,
	))
GLOBAL_PROTECT(serf_positions)

GLOBAL_LIST_INIT(peasant_positions, list(
	/datum/job/farmer::title,
	/datum/job/miner::title,
	/datum/job/butcher::title,
	/datum/job/cook::title,
	/datum/job/carpenter::title,
	/datum/job/jester::title,
	/datum/job/hunter::title,
	/datum/job/fisher::title,
	/datum/job/bard::title,
	/datum/job/prisoner::title,
	/datum/job/vagrant::title,
	/datum/job/persistence/woodsman::title,
	/datum/job/persistence/miner::title,
	/datum/job/persistence/farmer::title,
))
GLOBAL_PROTECT(peasant_positions)

GLOBAL_LIST_INIT(apprentices_positions, list(
	/datum/job/squire::title,
	/datum/job/bapprentice::title,
	/datum/job/mageapprentice::title,
	/datum/job/servant::title,
	/datum/job/tapster::title,
	/datum/job/gaffer_assistant::title,
	/datum/job/clinicapprentice::title,
	))
GLOBAL_PROTECT(apprentices_positions)

GLOBAL_LIST_INIT(youngfolk_positions, list(
	/datum/job/innkeep_son::title,
	/datum/job/orphan::title,
	/datum/job/churchling::title,
	/datum/job/soilchild::title,
))
GLOBAL_PROTECT(youngfolk_positions)

GLOBAL_LIST_INIT(company_positions, list(
	/datum/job/merchant::title,
	/datum/job/shophand::title,
	/datum/job/grabber::title,
	))
GLOBAL_PROTECT(company_positions)

GLOBAL_LIST_INIT(allmig_positions, list(
	/datum/job/pilgrim::title,
	/datum/job/adventurer::title,
	/datum/job/mercenary::title,
	/datum/job/bandit::title,
	/datum/job/wretch::title,
	))

GLOBAL_LIST_INIT(roguewar_positions, list(
	"Adventurer",
	))

GLOBAL_LIST_INIT(test_positions, list(
	"Tester",
	))

GLOBAL_LIST_EMPTY(job_assignment_order)

/proc/get_job_assignment_order()
	var/list/sorting_order = list()
	sorting_order += GLOB.noble_positions
	sorting_order += GLOB.garrison_positions
	sorting_order += GLOB.church_positions
	sorting_order += GLOB.inquisition_positions
	sorting_order += GLOB.serf_positions
	sorting_order += GLOB.company_positions
	sorting_order += GLOB.peasant_positions
	sorting_order += GLOB.apprentices_positions
	sorting_order += GLOB.allmig_positions
	sorting_order += GLOB.youngfolk_positions
	return sorting_order

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_GHOST = list(), // dead people, observers
))
GLOBAL_PROTECT(exp_specialmap)
