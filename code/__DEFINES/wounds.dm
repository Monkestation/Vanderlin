// ~biology defines
// What kind of biology a limb has, and what wounds it can suffer
/// Has absolutely fucking nothing, no wounds
#define BIO_INORGANIC NONE
/// Has bone - allows the victim to suffer fractures
#define BIO_BONE (1<<0)
/// Has flesh - allows the victim to suffer fleshy slash pierce and burn wounds
#define BIO_FLESH (1<<1)
/// Has metal - allows the victim to suffer robotic blunt and burn wounds
#define BIO_METAL (1<<2)
/// Has bloodflow - can suffer bleeding wounds and can bleed
#define BIO_BLOODED (1<<3)
/// Is connected by a joint - can suffer dislocation
#define BIO_JOINTED (1<<4)

/// Robotic - can suffer all metal wounds
#define BIO_ROBOTIC (BIO_METAL)
/// Has flesh and bone - See BIO_BONE and BIO_FLESH
#define BIO_FLESH_BONE (BIO_BONE|BIO_FLESH)
/// Standard humanoid - can bleed and suffer all flesh/bone wounds except dislocations. Think human heads/chests
#define BIO_STANDARD_UNJOINTED (BIO_FLESH_BONE|BIO_BLOODED)
/// Standard humanoid limbs - can bleed and suffer all flesh/bone wounds. Can also bleed, and be dislocated. Think human arms and legs
#define BIO_STANDARD_JOINTED (BIO_STANDARD_UNJOINTED|BIO_JOINTED)

