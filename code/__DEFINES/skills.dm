
// Skills
#define SKILL_LEVEL_NONE 0
#define SKILL_LEVEL_NOVICE 10 //basic
#define SKILL_LEVEL_APPRENTICE 20 //novice
#define SKILL_LEVEL_JOURNEYMAN 30 //skilled
#define SKILL_LEVEL_EXPERT 40 //expert
#define SKILL_LEVEL_MASTER 50 //master
#define SKILL_LEVEL_LEGENDARY 60 //legendary

#define SKILL_RANK_NONE 0
#define SKILL_RANK_NOVICE 1 //basic
#define SKILL_RANK_APPRENTICE 2 //novice
#define SKILL_RANK_JOURNEYMAN 3 //skilled
#define SKILL_RANK_EXPERT 4 //expert
#define SKILL_RANK_MASTER 5 //master
#define SKILL_RANK_LEGENDARY 6 //legendary

#define SKILL_EXP_NONE 0
#define SKILL_EXP_NOVICE 100
#define SKILL_EXP_APPRENTICE 250
#define SKILL_EXP_JOURNEYMAN 500
#define SKILL_EXP_EXPERT 900
#define SKILL_EXP_MASTER 1500
#define SKILL_EXP_LEGENDARY 2500

// Gets the reference for the skill type that was given
#define GetSkillRef(A) (SSskills.all_skills[A])
