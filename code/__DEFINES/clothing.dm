/// Wrapper for adding clothing based traits
#define ADD_CLOTHING_TRAIT(mob, trait) ADD_TRAIT(mob, trait, "[CLOTHING_TRAIT]_[REF(src)]")
/// Wrapper for removing clothing based traits
#define REMOVE_CLOTHING_TRAIT(mob, trait) REMOVE_TRAIT(mob, trait, "[CLOTHING_TRAIT]_[REF(src)]")

#define ARMOR_CLASS_NONE 0
#define AC_LIGHT 1
#define AC_MEDIUM 2
#define AC_HEAVY 3

/// Missing left
#define SLEEVES_LEFT (1 << 0)
/// Missing right
#define SLEEVES_RIGHT (1 << 1)
