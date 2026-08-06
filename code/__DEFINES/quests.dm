GLOBAL_VAR(harlequinn_hunt_quest) // weakref to active /datum/quest/custom/harlequinn_hunt

#define HARLEQUINN_HUNT_COOLDOWN (35 MINUTES)
#define HARLEQUINN_VESSEL_ID "Harlequinn"
#define HARLEQUINN_HUNT_REWARD 500

#define QUEST_DIFFICULTY_EASY "Easy"
#define QUEST_DIFFICULTY_MEDIUM "Medium"
#define QUEST_DIFFICULTY_HARD "Hard"

#define QUEST_RETRIEVAL "Retrieval"
#define QUEST_COURIER "Courier"
#define QUEST_KILL_EASY "Kill"
#define QUEST_CLEAR_OUT "Clear Out"
#define QUEST_RAID "Raid"
#define QUEST_OUTLAW "Outlaw"
#define QUEST_BEACON "Beacon"
#define QUEST_CUSTOM "Custom"
#define QUEST_RECOVERY "Recovery"
#define QUEST_PLANAR "Planar Assault"
#define QUEST_OBJECTIVE "Decree"

#define QUEST_REWARD_EASY_LOW 5
#define QUEST_REWARD_EASY_HIGH 15
#define QUEST_REWARD_MEDIUM_LOW 30
#define QUEST_REWARD_MEDIUM_HIGH 45
#define QUEST_REWARD_HARD_LOW 50
#define QUEST_REWARD_HARD_HIGH 90

#define QUEST_DEPOSIT_EASY 5
#define QUEST_DEPOSIT_MEDIUM 10
#define QUEST_DEPOSIT_HARD 20

#define QUESTBOARD_POOL_MAX_EASY 6
#define QUESTBOARD_POOL_MAX_MEDIUM 4
#define QUESTBOARD_POOL_MAX_HARD 2

#define QUESTBOARD_COST_EASY 1 //3
#define QUESTBOARD_COST_MEDIUM 2
#define QUESTBOARD_COST_HARD 3

#define QUESTBOARD_CUSTOM_ISSUE_FEE 20

#define QUEST_THREAT_REDUCE_EASY 5
#define QUEST_THREAT_REDUCE_MEDIUM 12
#define QUEST_THREAT_REDUCE_HARD 25

#define QUEST_HANDLER_REWARD_MULTIPLIER 1.25

// Delivery quest additional reward scaling
#define QUEST_DELIVERY_DISTANCE_DIVISOR 8 // Divides the distance for reward calculation
#define QUEST_DELIVERY_DISTANCE_BONUS 1 // Adds a bonus for longer distances
#define QUEST_COURIER_BONUS_FLAT 10 // Flat bonus for courier quests, since you gotta wait for a person to open a package
#define QUEST_DELIVERY_PER_ITEM_BONUS 2 // Bonus per item delivered

// All eligible quest kill mobs
// The extra per number reward are based on toughness + whether their head is worth anything
#define QUEST_KILL_MOBS_LIST list(\
	/mob/living/carbon/human/species/goblin/npc/ambush/sea = 3,\
	/mob/living/carbon/human/species/skeleton/npc/supereasy = 4,\
	/mob/living/carbon/human/species/skeleton/npc/easy = 5,\
	/mob/living/carbon/human/species/skeleton/npc/pirate = 5,\
	/mob/living/carbon/human/species/human/northern/militia/deserter = 4,\
	/mob/living/carbon/human/species/orc/npc/footsoldier = 6,\
)

// Medium difficulty quest kill mobs, this is where I can put some slightly spicier mobs
#define QUEST_KILL_MEDIUM_LIST list(\
	/mob/living/carbon/human/species/human/northern/searaider/ambush = 6,\
	/mob/living/carbon/human/species/human/northern/highwayman = 6,\
	/mob/living/carbon/human/species/orc/npc/footsoldier = 6,\
	/mob/living/carbon/human/species/orc/npc/marauder = 8,\
	/mob/living/carbon/human/species/skeleton/npc/mediumspread = 6,\
	/mob/living/carbon/human/species/skeleton/npc/mediumspread = 6,\
	/mob/living/carbon/human/species/human/northern/thief = 8,\
	)

// Raid difficulty kill mobs - Only three mobs for now. Per person reward is low because base / head reward is high
#define QUEST_RAID_LIST list(\
	/mob/living/carbon/human/species/orc/npc/berserker = 10,\
	/mob/living/carbon/human/species/elf/dark/drowraider = 5, \
	/mob/living/carbon/human/species/human/northern/bog_deserters = 5,\
)

/// This quest type can be issued directly from the notice board by a steward.
#define CUSTOM_QUEST_NOTICEBOARD (1<<0)
/// This quest type can be created via a player-written pledge scroll.
#define CUSTOM_QUEST_PLEDGE (1<<1)
// Can be issued as a harlequinn objective quest
#define CUSTOM_QUEST_HARLEQUINN (1<<2)
