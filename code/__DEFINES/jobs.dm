#define JOB_AVAILABLE 0
#define JOB_UNAVAILABLE_GENERIC 1
#define JOB_UNAVAILABLE_BANNED 2
#define JOB_UNAVAILABLE_PLAYTIME 3
#define JOB_UNAVAILABLE_SLOTFULL 4
#define JOB_UNAVAILABLE_AGE 5
#define JOB_UNAVAILABLE_RACE 6
#define JOB_UNAVAILABLE_SEX 7
#define JOB_UNAVAILABLE_DEITY 8
#define JOB_UNAVAILABLE_QUALITY 9
#define JOB_UNAVAILABLE_DONATOR 10
#define JOB_UNAVAILABLE_LASTCLASS 11
#define JOB_UNAVAILABLE_ACCOUNTAGE 12
#define JOB_UNAVAILABLE_JOB_COOLDOWN 13
#define JOB_UNAVAILABLE_RACE_BANNED 14

/* Job datum job_flags */
/// Whether the mob is announced on arrival.
#define JOB_ANNOUNCE_ARRIVAL (1<<0)
/// Whether the mob is added to the crew manifest.
#define JOB_SHOW_IN_CREDITS (1<<1)
/// Whether the mob is equipped through SSjob.EquipRank() on spawn.
#define JOB_EQUIP_RANK (1<<2)
/// Whether this job can be joined through the new_player menu.
#define JOB_NEW_PLAYER_JOINABLE (1<<3)
/// Whether the job can be displayed on the actors list
#define JOB_SHOW_IN_ACTOR_LIST (1<<4)

#define ALL_FACTIONS list( \
	FACTION_NONE, \
	FACTION_NEUTRAL, \
	FACTION_HOSTILE, \
	FACTION_TOWN, \
	FACTION_FOREIGNERS, \
	FACTION_MIGRANTS, \
	FACTION_UNDEAD, \
	FACTION_PLANTS, \
	FACTION_VINES, \
	FACTION_CABAL, \
	FACTION_RATS, \
	FACTION_ORCS, \
	FACTION_BUMS, \
	FACTION_MATTHIOS \
)

#define FACTION_NONE		"None"
#define FACTION_NEUTRAL		"Neutral"
#define FACTION_HOSTILE		"Hostile"
#define FACTION_TOWN		"Town"
#define FACTION_FOREIGNERS  "Foreigners"
#define FACTION_MIGRANTS  	"Migrants"
#define FACTION_UNDEAD		"Undead"
#define FACTION_PLANTS		"Plants"
#define FACTION_VINES		"Vines" //Seemingly unused
#define FACTION_CABAL		"Cabal"
#define FACTION_RATS		"Rats"
#define FACTION_ORCS		"Orcs"
#define FACTION_BUMS		"Bums"
#define FACTION_MATTHIOS	"Matthios"

#define NOBLEMEN		(1<<0)
#define GARRISON		(1<<1)
#define CHURCHMEN		(1<<2)
#define SERFS			(1<<3)
#define PEASANTS		(1<<4)
#define APPRENTICES		(1<<5)
#define YOUNGFOLK		(1<<6)
#define OUTSIDERS		(1<<7)
#define COMPANY			(1<<8)
#define INQUISITION 	(1<<9)

#define UNDEAD			(1<<10)


#define JCOLOR_NOBLE "#9c40bf"
#define JCOLOR_MERCHANT "#c2b449"
#define JCOLOR_SOLDIER "#b64949"
#define JCOLOR_SERF "#669968"
#define JCOLOR_PEASANT "#936d6c"
#define JCOLOR_INQUISITION "#FF0000"

// job display orders //

#define JDO_DEFAULT 0
#define JDO_LORD 1
#define JDO_CONSORT 1.1
#define JDO_PRINCE 1.2
#define JDO_HAND 2
#define JDO_STEWARD 3
#define JDO_MINOR_NOBLE 3.5
#define JDO_PHYSICIAN 3.7

#define JDO_MAGICIAN 4
#define JDO_WAPP 5

#define JDO_APOTHECARY 6
#define JDO_FELDSHER 6.1
#define JDO_CLINICAPPRENTICE 6.2

#define JDO_CAPTAIN 7
#define JDO_VET 7.1
#define JDO_ROYALKNIGHT 7.2
#define JDO_MENATARMS 8
#define JDO_CITYWATCHMEN 8.1
#define JDO_GATEMASTER 8.2
#define JDO_DUNGEONEER 9
#define JDO_JAILOR 9.1
#define JDO_SQUIRE 10
#define JDO_FORWARDEN 11
#define JDO_FORGUARD 11.1

#define JDO_PRIEST 12
#define JDO_CLERIC 13
#define JDO_MONK 14
#define JDO_GRAVETENDER 15
#define JDO_CHURCHLING 15.1

#define JDO_SHEPHERD 17
#define JDO_TEMPLAR 17.1

#define JDO_MERCHANT 18
#define JDO_SHOPHAND 18.1
#define JDO_GRABBER 18.2

#define JDO_TAILOR 19

#define JDO_ARMORER 20
#define JDO_WSMITH 21
#define JDO_BAPP 22
#define JDO_ARTIFICER 23



#define JDO_BUTLER 25
#define JDO_SERVANT 26

#define JDO_INNKEEP 27
#define JDO_INNKEEP_CHILD 27.5
#define JDO_COOK 28

#define JDO_BUTCHER 28.1
#define JDO_SOILSON 28.2
#define JDO_FISHER 28.3
#define JDO_HUNTER 28.4
#define JDO_CARPENTER 28.6
#define JDO_MASON 28.61
#define JDO_CHEESEMAKER 28.7
#define JDO_MINER 28.8
#define JDO_MATRON 28.9
#define JDO_GRAVEMAN 29


#define JDO_JESTER 30
#define JDO_BARD 30.1
#define JDO_PRISONER 31

#define JDO_CHIEF 32

#define JDO_ADVENTURER 33
#define JDO_GAFFER 33.1
#define JDO_PILGRIM 34.2
#define JDO_MIGRANT  34.3
#define JDO_BANDIT 34.3
#define JDO_WRETCH 34.4

#define JDO_MERCENARY 35

#define JDO_VAGRANT 36
#define JDO_ORPHAN 37
#define JDO_SOILCHILD 38

#define JDO_PURITAN 40
#define JDO_ORTHODOXIST	40.1
#define JDO_ABSOLVER 40.2

#define BITFLAG_CHURCH (1<<0)
#define BITFLAG_ROYALTY (1<<1)
#define BITFLAG_CONSTRUCTOR (1<<2)
#define BITFLAG_GARRISON (1<<3)

