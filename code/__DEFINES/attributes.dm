#define GET_ATTRIBUTE_DATUM(path) GLOB.all_attributes[path]
#define GET_MOB_ATTRIBUTE_VALUE_RAW(mob, attribute_path) mob.attributes?.raw_attribute_list[attribute_path]
#define GET_MOB_ATTRIBUTE_VALUE(mob, attribute_path) mob.attributes?.attribute_list[attribute_path]
#define GET_MOB_SKILL_VALUE_RAW(mob, skill_path) mob.attributes?.return_raw_effective_skill(skill_path)
#define GET_MOB_SKILL_VALUE(mob, skill_path) mob.attributes?.return_effective_skill(skill_path)
#define GET_MOB_SKILL_VALUE_RAW_OLD(mob, skill_path) mob.attributes?.return_raw_effective_skill(skill_path) * 0.1
#define GET_MOB_SKILL_VALUE_OLD(mob, skill_path) mob.attributes?.return_effective_skill(skill_path) * 0.1

#define GENERAL_SKILL_TIME_MULITPLIER(mob, skill_path) ATTRIBUTE_MIDDLING/max(GET_MOB_ATTRIBUTE_VALUE(mob, STAT_PERCEPTION), 1)

#define SKILL /datum/attribute/skill
#define STAT /datum/attribute/stat

// ~attribute/stat values
#define ATTRIBUTE_MIN -100 ///lmao get fucked
#define ATTRIBUTE_MAX 100

#define ATTRIBUTE_MIDDLING 10
#define ATTRIBUTE_MASTER 30

#define ATTRIBUTE_DEFAULT ATTRIBUTE_MIDDLING

// ~skill values
#define SKILL_MIN -100
#define SKILL_MAX 100

#define SKILL_MIDDLING 30
#define SKILL_MASTER 60

#define SKILL_DEFAULT null

// ~diceroll results
#define DICE_CRIT_SUCCESS 2
#define DICE_SUCCESS 1
#define DICE_FAILURE 0
#define DICE_CRIT_FAILURE -1

// ~diceroll return flags arguments
#define RETURN_DICE_SUCCESS (1<<0)
#define RETURN_DICE_DIFFERENCE (1<<1)
#define RETURN_DICE_BOTH (RETURN_DICE_SUCCESS|RETURN_DICE_DIFFERENCE)

// ~diceroll return list when RETURN_DICE_BOTH
#define RETURN_DICE_INDEX_SUCCESS 1
#define RETURN_DICE_INDEX_DIFFERENCE 2

// ~diceroll contexts
#define DICE_CONTEXT_PHYSICAL "physical"
#define DICE_CONTEXT_MENTAL "mental"

#define DICE_CONTEXT_DEFAULT DICE_CONTEXT_PHYSICAL

// ~skill categories
#define SKILL_CATEGORY_GENERAL "General Skills"
#define SKILL_CATEGORY_MELEE "Melee Skills"
#define SKILL_CATEGORY_RANGED "Ranged Skills"
#define SKILL_CATEGORY_BLOCKING "Blocking Skills"
#define SKILL_CATEGORY_COMBAT "Combat Skills"
#define SKILL_CATEGORY_SKULDUGGERY "Skulduggery Skills"
#define SKILL_CATEGORY_MEDICAL "Medical Skills"
#define SKILL_CATEGORY_RESEARCH "Research Skills"
#define SKILL_CATEGORY_ENGINEERING "Trade Skills"
#define SKILL_CATEGORY_DOMESTIC "Domestic Skills"
#define SKILL_CATEGORY_DUMB "Stupid Skills"

// ~skill difficulties
#define SKILL_DIFFICULTY_VERY_EASY "Very Easy"
#define SKILL_DIFFICULTY_EASY "Easy"
#define SKILL_DIFFICULTY_AVERAGE "Medium"
#define SKILL_DIFFICULTY_HARD "Hard"
#define SKILL_DIFFICULTY_VERY_HARD "Very Hard"

// ~path defines
#define STAT_STRENGTH /datum/attribute/stat/strength
#define STAT_ENDURANCE /datum/attribute/stat/endurance
#define STAT_INTELLIGENCE /datum/attribute/stat/intelligence
#define STAT_PERCEPTION /datum/attribute/stat/perception
#define STAT_CONSTITUTION /datum/attribute/stat/constitution
#define STAT_FORTUNE /datum/attribute/stat/fortune
#define STAT_SPEED /datum/attribute/stat/speed

#define MOBSTATS list(STAT_STRENGTH, STAT_ENDURANCE, STAT_INTELLIGENCE, STAT_PERCEPTION, STAT_CONSTITUTION, STAT_SPEED, STAT_FORTUNE)

#define SKILL_GOVERNING_MULTIPLIER_POSITIVE 0.5
#define SKILL_GOVERNING_MULTIPLIER_NEGATIVE 3

#define SKILL_XP_CATCHUP_MULTIPLIER_MAX 5.0
#define SKILL_XP_CATCHUP_LEVEL_FLOOR 10

#define APPRENTICE_SKILL_CAP 40
