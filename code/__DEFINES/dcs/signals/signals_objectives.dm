/// from base of /datum/action/cooldown/spell/mockery/cast() (victim)
#define COMSIG_VICIOUSLY_MOCKED "viciously_mocked_act"
/// from base of /obj/structure/well/fountain/mana/attackby() (baptizer)
#define COMSIG_BAPTISM_RECEIVED "baptism_received"
/// from base of /datum/surgery_step/extract_lux/success() (victim)
#define COMSIG_LUX_EXTRACTED "lux_extracted"
/// from base of /obj/item/reagent_containers/powder/attack() (applier)
#define COMSIG_DRUG_SNIFFED "drug_sniffed"
/// from base of /mob/living/MiddleClickOn() (victim)
#define COMSIG_ITEM_STOLEN "item_stolen"
/// from base of adjust_skillrank() (skill_type, new_rank)
#define COMSIG_SKILL_RANK_INCREASED "skill_rank_increased"
/// from base of /atom/proc/OnCrafted() (user, craft_path)
#define COMSIG_ITEM_CRAFTED "item_crafted"
/// from base of /obj/item/reagent_containers/food/snacks/organ/on_consume() (organ_type, obj/item/organ/organ_inside)
#define COMSIG_ORGAN_CONSUMED "organ_consumed"
/// from base of /mob/living/carbon/human/proc/torture_victim() (mob/living/torturer, mob/living/victim)
#define COMSIG_TORTURE_PERFORMED "torture_performed"
/// from base of /obj/structure/gravemarker/OnCrafted() (mob/living/consecrator, obj/container)
#define COMSIG_GRAVE_CONSECRATED "grave_consecrated"
/// from base of /mob/living/simple_animal/proc/tamed() (mob/living/tamer, mob/living/simple_animal)
#define COMSIG_ANIMAL_TAMED "animal_tamed"
/// from base of /datum/emote/living/hug/adjacentaction() (target)
#define COMSIG_MOB_HUGGED "mob_hugged"
/// from base of /datum/action/cooldown/spell/undirectedcreate_abyssoid/cast() ()
#define COMSIG_ABYSSOID_CREATED "abyssoid_created"
/// from base of /obj/item/reagent_containers/food/snacks/on_consume() (/obj/item/reagent_containers/food/snacks/eaten_food)
#define COMSIG_ROTTEN_FOOD_EATEN "rotten_food_eaten"
/// from base of /datum/status_effect/buff/lux_drank/on_apply() ()
#define COMSIG_LUX_TASTED "lux_tasted"
/// from base of //mob/living/carbon/monkey/attack_hand() (victim)
#define COMSIG_HEAD_PUNCHED "head_punched"
/// from base of /datum/action/cooldown/spell/transform_tree/cast() ()
#define COMSIG_TREE_TRANSFORMED "tree_transformed"
/// from base of /datum/emote/living/spit/adjacentaction() (mob/target)
#define COMSIG_SPAT_ON "spat_on"
/// from base of /mob/living/attack_hand_secondary() (mob/new_apprentice)
#define COMSIG_APPRENTICE_MADE "apprentice_made"
/// from base of /datum/action/cooldown/spell/adopt_child/cast() (mob/adoptee)
#define COMSIG_ORPHAN_ADOPTED "orphan_adopted"
/// from base of /datum/action/cooldown/spell/transfer_pain/cast() (amount)
#define COMSIG_PAIN_TRANSFERRED "pain_transferred"
/// from base of /obj/item/coin/attack_self() (mob/user, obj/item/coin/coin, outcome)
#define COMSIG_COIN_FLIPPED "coin_flipped"
/// From base of /obj/item/reagent_containers/glass/attack() (mob/user, mob/target, list/reagents_splashed)
#define COMSIG_SPLASHED_MOB "splashed_mob"
/// From base of /datum/stress_event/bathwater/on_apply() (mob/living/user)
#define COMSIG_BATH_TAKEN "bath_taken"
/// from /mob/living/adjust_energy() (mob/user, amount_spent)
#define COMSIG_MOB_ENERGY_SPENT "mob_energy_spent"
/// from /mob/living/simple_animal/butcher() (mob/user, mob/animal)
#define COMSIG_MOB_BUTCHERED "mob_butchered"
/// from /datum/species/proc/kicked() (mob/user, mob/target, zone_hit, damage_blocked)
#define COMSIG_MOB_KICK "mob_kick"
/// from /obj/structure/closet/dirthole/attackby() (mob/user)
#define COMSIG_GRAVE_ROBBED "grave_robbed"
/// from /datum/action/cooldown/spell/find_flaw/cast() (datum/charflaw/flaw, mob/target)
#define COMSIG_FLAW_FOUND "flaw_found"
// Globals

/// from base of /obj/structure/fluff/psycross/attackby() (bride, groom)
#define COMSIG_GLOBAL_MARRIAGE "global_marriage"
/// from base of /turf/open/water/Entered() (fish_type, fish_rarity)
#define COMSIG_GLOBAL_FISH_RELEASED "global_fish_released"
/// from base of /datum/action/cooldown/spell/undirected/list_target/convertrole/proc/convert() (mob/living/carbon/human/recruiter, mob/living/carbon/human/recruit, newrole)
#define COMSIG_GLOBAL_ROLE_CONVERTED "role_converted"
