

//Values for antag preferences, event roles, etc. unified here



//These are synced with the Database, if you change the values of the defines
//then you MUST update the database!
#define ROLE_MANIAC				"Maniac"
#define ROLE_WEREWOLF			"Werewolf"
#define ROLE_VAMPIRE			"Vampire Lord"
#define ROLE_BANDIT				"Bandit"
#define ROLE_DELF				"Dark Elf"
#define ROLE_PREBEL				"Peasant Rebel"
#define ROLE_ZIZOIDCULTIST		"Zizoid Cultist"
#define ROLE_LICH				"Lich"
#define ROLE_ASPIRANT			"Aspirant"
#define ROLE_HARLEQUINN 		"Harlequinn"
#define ROLE_ZOMBIE				"Zombie"
#define ROLE_NECRO_SKELETON		"Necromancer Skeleton"
#define ROLE_WRETCH				"Wretch"


GLOBAL_LIST_INIT(special_roles_rogue, list(
	ROLE_MANIAC = /datum/antagonist/maniac,
	ROLE_PREBEL = /datum/antagonist/prebel,
	ROLE_BANDIT = /datum/antagonist/bandit,
	ROLE_ZIZOIDCULTIST = /datum/antagonist/zizocultist,
	ROLE_WEREWOLF = /datum/antagonist/werewolf,
	ROLE_VAMPIRE = /datum/antagonist/vampire,
	ROLE_ASPIRANT = /datum/antagonist/aspirant,
	ROLE_LICH = /datum/antagonist/lich,
	ROLE_HARLEQUINN = /datum/antagonist/harlequinn,
	ROLE_WRETCH = /datum/antagonist/wretch
))

//Job defines for what happens when you fail to qualify for any job during job selection
#define BERANDOMJOB "Be Random Role"
#define RETURNTOLOBBY 	"Return to Lobby"
