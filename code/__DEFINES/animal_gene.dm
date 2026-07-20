#define GENE_GROUP_BODY_SIZE "body_size"
#define GENE_GROUP_SPEED "speed"
#define GENE_GROUP_CONSTITUTION "constitution"
#define GENE_GROUP_TEMPERAMENT "temperament"
#define GENE_GROUP_DIET "diet"
#define GENE_GROUP_HIDE "hide"
#define GENE_GROUP_COAT_COLOR "coat_color"
#define GENE_GROUP_UNDERCOAT "undercoat"
#define GENE_GROUP_BREEDING "breeding"
#define GENE_GROUP_PROGENY "progeny"
#define GENE_GROUP_EMISSIVE "emissive"
#define GENE_GROUP_METABOLISM "metabolism"
#define GENE_GROUP_HAPPINESS "happiness"

#define GENETICS_TRAIT "genetics"
#define GENETICS_MUTATION_CHANCE 15
#define GENETICS_EMERGENCE_CHANCE 40
#define GENETICS_MAX_GENES 4

// How much random noise (+/-) is applied when averaging two parent intensities
#define GENETICS_INTENSITY_NOISE 1
// Minimum fraction of intensity_min a bred gene can ever fall to
#define GENETICS_INTENSITY_FLOOR 9
// Pass chance for dominant genes from a single parent
#define GENETICS_DOMINANT_PASS_CHANCE 70
// Pass chance for recessive genes from a single parent, lower, needs both sides contributing to reliably transmit
#define GENETICS_RECESSIVE_PASS_CHANCE 40

#define RECESSIVE_NONE 0
#define RECESSIVE_CARRIED 1    // one parent had it - silent carrier
#define RECESSIVE_EXPRESSED 2  // both parents had it - expresses

#define GENE_FLAG_INTRINSIC (1<<0) // Always passed, doesn't count toward gene cap
#define GENE_FLAG_UNCOUNTED (1<<1) // This gene never gets counted towards the gene cap
#define GENE_FLAG_EXLUDE_WILD (1<<2) // This gene can never appear in the wild
#define GENE_FLAG_EMERGENCE (1<<3) // This gene will only appear through genetic mutation outside of the wild

#define LINEAGE_MOTHER "mother"
#define LINEAGE_FATHER "father"
