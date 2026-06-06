#define BARD_T1 1 // Lesser Bard (Cantor, Spellsinger, etc.)
#define BARD_T2 2 // Full Bard (Minstrel, Jester, Psyalmist, Rogue Bard)

// Bardic song costs
#define SONG_ACTIVATION_COST 30 // Upfront stamina cost to start or swap a song
#define SONG_SUSTAIN_COST 10 // Blue drained per sustain tick (every 20 seconds)
#define SONG_SUSTAIN_TICKS 10 // Number of tick() calls between sustain drains (10 ticks x 2s = 20s)

// Bardic tier scaling - song effect multiplier
#define BARD_SCALING_LESSER 0.66 // Cantor / Spellsinger (T1)
#define BARD_SCALING_FULL 1.0 // Bard (T2)

// Bardic tier scaling - flat stat bonuses (CON from Resolute Refrain, SPD from Akathist, etc.)
#define BARD_STAT_FULL 3 // Bard (T2)
#define BARD_STAT_LESSER 2 // Cantor / Spellsinger (T1)

// Rhythm system (on-hit melee effects for bards)
#define RHYTHM_COOLDOWN 7 SECONDS // Shared cooldown after a rhythm successfully procs
#define RHYTHM_WINDOW 8 SECONDS // Time to land a hit after activating rhythm
#define RHYTHM_ACTIVATION_COST 10 // Stamina cost to activate rhythm
#define CRESCENDO_STACKS 3 // Rhythm procs needed to unlock Crescendo
#define CRESCENDO_DECAY 20 SECONDS // Time before Crescendo stacks decay

// Rhythm shared cooldown group
#define RHYTHM_SHARED_COOLDOWN "bardic_rhythm"

// Rhythm picks per tier
#define RHYTHM_PICKS_T1 2
#define RHYTHM_PICKS_T2 2

// Rhythm types
#define RHYTHM_NONE "None"
#define RHYTHM_RESONATING "Resonating"
#define RHYTHM_CONCUSSIVE "Concussive"
#define RHYTHM_FRIGID "Frigid"
#define RHYTHM_REGENERATING "Regenerating" // T2 (Full Bard) exclusive

// Rhythm damage values
#define RHYTHM_RESONATING_DAMAGE 20 // Parry-bypassing brute on hit (armor-checked)
#define RHYTHM_CONCUSSIVE_DAMAGE 8 // Minor knockback damage
#define RHYTHM_REGEN_TICK 0.5 // Heal-over-time per tick (compare: miracle = 1.0, hymn = 0.6)
#define RHYTHM_REGEN_DURATION 10 SECONDS // Duration of regen HoT

// Crescendo damage values (cone AoE, T2 only)
#define CRESCENDO_RESONATING_DAMAGE 55 // Parry-bypassing brute in cone (armor-checked)
#define CRESCENDO_CONCUSSIVE_DAMAGE 25 // Brute + 3-tile knockback in cone
#define CRESCENDO_MENDING_DURATION 30 SECONDS // Duration of crescendo HoT on audience (2x rhythm_regen)
#define CRESCENDO_MENDING_TICK 1.0 // Heal-over-time per tick (compare: rhythm_regen = 0.5)
