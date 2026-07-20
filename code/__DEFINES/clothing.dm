/// Wrapper for adding clothing based traits
#define ADD_CLOTHING_TRAIT(mob, trait) ADD_TRAIT(mob, trait, "[CLOTHING_TRAIT]_[REF(src)]")
/// Wrapper for removing clothing based traits
#define REMOVE_CLOTHING_TRAIT(mob, trait) REMOVE_TRAIT(mob, trait, "[CLOTHING_TRAIT]_[REF(src)]")

#define ARMOR_CLASS_NONE 0
#define AC_LIGHT 1
#define AC_MEDIUM 2
#define AC_HEAVY 3

//Armor material categories
#define ARMOR_MAT_PLATE 1
#define ARMOR_MAT_FABRIC 2
#define ARMOR_MAT_CHAINMAIL 3
