/*
Remember to update _globalvars/traits.dm if you're adding/removing/renaming traits.
*/

// ************* atom traits

/// Prevents the affected atom from opening a loot window via alt click. See atom/AltClick()
#define TRAIT_ALT_CLICK_BLOCKER "no_alt_click"

// ************* atom movable traits

/// Is runechat for this atom/movable currently disabled, regardless of prefs or anything?
#define TRAIT_RUNECHAT_HIDDEN "runechat_hidden"
#define TRAIT_I_AM_INVISIBLE_ON_A_BOAT "invisible_on_tram"
///Trait given by /datum/element/relay_attacker
#define TRAIT_RELAYING_ATTACKER "relaying_attacker"

/// Movement type traits for movables. See elements/movetype_handler.dm
#define TRAIT_MOVE_GROUND "move_ground"
#define TRAIT_MOVE_FLYING "move_flying"
#define TRAIT_MOVE_VENTCRAWLING	"move_ventcrawling"
#define TRAIT_MOVE_FLOATING	"move_floating"
#define TRAIT_MOVE_PHASING "move_phasing"
/// Disables the floating animation. See above.
#define TRAIT_NO_FLOATING_ANIM "no-floating-animation"

// ************* mob traits

/// Prevents voluntary movement.
#define TRAIT_IMMOBILIZED "immobilized"
/// Buckling yourself to objects with this trait won't immobilize you
#define TRAIT_NO_IMMOBILIZE "no_immobilize"
/// Forces the user to stay unconscious.
#define TRAIT_KNOCKEDOUT "knockedout"
/// Prevents standing or staying up on its own.
#define TRAIT_FLOORED  "floored"
/// Prevents usage of manipulation appendages (picking, holding or using items, manipulating storage).
#define TRAIT_HANDS_BLOCKED "handsblocked"
/// Inability to access UI hud elements. Turned into a trait from [MOBILITY_UI] to be able to track sources.
#define TRAIT_UI_BLOCKED "uiblocked"
/// Inability to pull things. Turned into a trait from [MOBILITY_PULL] to be able to track sources.
#define TRAIT_PULL_BLOCKED "pullblocked"
/// Abstract condition that prevents movement if being pulled and might be resisted against. Handcuffs and straight jackets, basically.
#define TRAIT_RESTRAINED "restrained"
/// Generically incapacitated, cannot interact
#define TRAIT_INCAPACITATED	"incapacitated"
/// Can't speak
#define TRAIT_MUTE "mute"
/// Can't use emotes
#define TRAIT_EMOTEMUTE	"emotemute"
/// Speak in zombie moans
#define TRAIT_ZOMBIE_SPEECH "zombie_speech"
/// Speak garbled
#define TRAIT_GARGLE_SPEECH "gargle_speech"
/// Can't hear
#define TRAIT_DEAF "deaf"
/// Can't hear properly beyond 2 tiles
#define TRAIT_PARTIAL_DEAF "partial_deaf"
#define TRAIT_HUSK "husk"
#define TRAIT_CHUNKYFINGERS	"chunkyfingers" //means that you can't use weapons with normal trigger guards.
#define TRAIT_DUMB "dumb"
#define TRAIT_MONKEYLIKE "monkeylike" //sets IsAdvancedToolUser to FALSE
/// Cannot directly bring harm to other mobs
#define TRAIT_PACIFISM	"pacifism"
/// Ignore movement speed slow mods
#define TRAIT_IGNORESLOWDOWN "ignoreslow"
/// Ignore slowdown from damage
#define TRAIT_IGNOREDAMAGESLOWDOWN "ignoredamageslowdown"
/// Causes death-like unconsciousness
#define TRAIT_DEATHCOMA	"deathcoma"
/// ??? should be a signal?
#define TRAIT_SANGUINE "sanguine"
/// The mob has the stasis effect.
/// Does nothing on its own, applied via status effect.
#define TRAIT_STASIS "in_stasis"
/// Makes the owner appear as dead to most forms of medical examination
#define TRAIT_FAKEDEATH "fakedeath"
/// "Magic" trait that blocks the mob from moving or interacting with anything. Used for transient stuff like mob transformations or incorporality in special cases.
/// Will block movement, `Life()` (!!!), and other stuff based on the mob.
#define TRAIT_NO_TRANSFORM "block_transformations"
/// Blocker trait for hardcore quirk users
#define TRAIT_HARDCORE_PROFANE	"hardcore_profane"
/// Weak to inquisition torture
#define TRAIT_TORTURED "tortured"
/// Prone to heart failure with high stress
#define TRAIT_WEAK_HEART "weak_heart"
/// Blood always counts as no lux
#define TRAIT_TAINTED_LUX "tainted_lux"
/// Crafting is 10% faster
#define TRAIT_QUICK_HANDS "quick_hands"
/// Immunity to stunning effects
#define TRAIT_STUNIMMUNE "stun_immunity"
/// Stun duration reduced (unused)
#define TRAIT_STUNRESISTANCE "stun_resistance"
/// Immunity to sleep
#define TRAIT_SLEEPIMMUNE "sleep_immunity"
/// Can't be pushed
#define TRAIT_PUSHIMMUNE "push_immunity"
/// Doesn't need a heart
#define TRAIT_STABLEHEART "stable_heart"
/// Can't be stunned from pain
#define TRAIT_NOPAINSTUN "no_pain-stun"
/// Resists high temperatures
#define TRAIT_RESISTHEAT "resist_heat"
/// Can hold hot things
#define TRAIT_RESISTHEATHANDS "resist_heat_handsonly"
/// Resists low temperatures
#define TRAIT_RESISTCOLD "resist_cold"
/// Resist high pressure enviroments (unused with no atmos)
#define TRAIT_RESISTHIGHPRESSURE "resist_high_pressure"
/// Resist low pressure enviroments (unused with no atmos)
#define TRAIT_RESISTLOWPRESSURE	"resist_low_pressure"
/// This human is immune to the effects of being exploded. (ex_act)
#define TRAIT_BOMBIMMUNE "bomb_immunity"
/// Immune to radiation
#define TRAIT_RADIMMUNE "rad_immunity"
/// Skin is not possible to pierce (needles, embeds)
#define TRAIT_PIERCEIMMUNE "pierce_immunity"
/// Higher thresholds for dismemberment
#define TRAIT_HARDDISMEMBER "hard_dismember"
/// Lower thresholds for dismemberment
#define TRAIT_EASYDISMEMBER "easy_dismember"
/// Limbs can't be dismembered
#define TRAIT_NODISMEMBER "dismember_immunity"
/// Can't get fire stacks (can get DIVINE fire stacks)
#define TRAIT_NOFIRE "Nonflammable"
/// Can't use guns
#define TRAIT_NOGUNS "no_guns"
/// Doesn't use nutrition
#define TRAIT_NOHUNGER "no_hunger"
/// Doesn't use hygine
#define TRAIT_NOHYGIENE	"no_hygiene"
/// Can't metabolise reagents
#define TRAIT_NOMETABOLISM "no_metabolism"
/// Immune to toxin damage
#define TRAIT_TOXIMMUNE "toxin_immune"
/// Can reattach limbs without tools
#define TRAIT_LIMBATTACHMENT "limb_attach"
/// Limbs can't be disabled by damage
#define TRAIT_NOLIMBDISABLE	"no_limb_disable"
/// Limbs have lower damage thresholds
#define TRAIT_EASYLIMBDISABLE "easy_limb_disable"
/// Toxin damage heals, toxin healing does damage
#define TRAIT_TOXINLOVER "toxinlover"
/// Doesn't need to breathe
#define TRAIT_NOBREATH "no_breath"
#define TRAIT_HOLY "holy"
/// Doesn't take oxy damage in crit (unused)
#define TRAIT_NOCRITDAMAGE "no_crit"
/// Doesn't slip on water (unused)
#define TRAIT_NOSLIPWATER "noslip_water"
/// Doesn't slip
#define TRAIT_NOSLIPALL "noslip_all"
/// Can't die
#define TRAIT_NODEATH "nodeath"
/// Can't enter hard crit
#define TRAIT_NOHARDCRIT "nohardcrit"
/// Can't enter soft crit
#define TRAIT_NOSOFTCRIT "nosoftcrit"
/// Shielded from mind altering effects (unused)
#define TRAIT_MINDSHIELD "mindshield"
/// Unused
#define TRAIT_DISSECTED	"dissected"
/// Can hear dead people
#define TRAIT_SIXTHSENSE "sixth_sense"
/// Immune to the effects of phobias
#define TRAIT_FEARLESS "fearless"
//These are used for brain-based paralysis, where replacing the limb won't fix it
/// Brain paralysis of left arm
#define TRAIT_PARALYSIS_L_ARM "para-l-arm"
/// Brain paralysis of right arm
#define TRAIT_PARALYSIS_R_ARM "para-r-arm"
/// Brain paralysis of left leg
#define TRAIT_PARALYSIS_L_LEG "para-l-leg"
/// Brain paralysis of right leg
#define TRAIT_PARALYSIS_R_LEG "para-r-leg"
/// Can't swap with mobs not in combat mode
#define TRAIT_NOMOBSWAP "no-mob-swap"
/// Can see through opaque atoms
#define TRAIT_XRAY_VISION "xray_vision"
/// Can see mobs through opaque atoms
#define TRAIT_THERMAL_VISION "thermal_vision"
/// Unused
#define TRAIT_SURGEON "surgeon"
/// Immediately upgrade grabs when in combat mode
#define TRAIT_STRONG_GRABBER "strong_grabber"
/// Used for the choking status effect
#define TRAIT_MAGIC_CHOKE "magic_choke"
/// Immune to nervous cough
#define TRAIT_SOOTHED_THROAT "soothed-throat"
/// Can't lower hygiene
#define TRAIT_ALWAYS_CLEAN "always-clean"
/// Can throw reagent containers without spilling them
#define TRAIT_BOOZE_SLIDER "booze-slider"
/// Unused
#define TRAIT_QUICK_CARRY "quick-carry"
/// Unused
#define TRAIT_QUICKER_CARRY "quicker-carry"
/// Prevents the overlay from nearsighted
#define TRAIT_NEARSIGHTED_CORRECTED "fixes_nearsighted"
/// Massively garble speech
#define TRAIT_UNINTELLIGIBLE_SPEECH "unintelligible-speech"
/// Prevents speaking in languages
#define TRAIT_LANGUAGE_BARRIER "language-barrier"
/// Immunity to flash effects
#define TRAIT_NOFLASH "noflash"
/// Immunity to pain
#define TRAIT_NOPAIN "no_pain"
/// Has drunk ambience replacement from spice
#define TRAIT_DRUQK "druqk"
/// prevents a human corpse from being used for a corpse multiple times
#define TRAIT_BURIED_COIN_GIVEN "buried_coin_given"
/// can bleed, but will never die from blood loss
#define TRAIT_BLOODLOSS_IMMUNE "bloodloss_immune"
/// you are a rotman and need occasional maintenance
#define TRAIT_ROTMAN "rotman"
/// immune to zombie infection
#define TRAIT_ZOMBIE_IMMUNE "zombie_immune"
/// prevents biting
#define TRAIT_NO_BITE "no_bite"
/// is this guy a foreigner?
#define TRAIT_FOREIGNER "Foreigner"
/// mob cannot be ambushed for any reason
#define TRAIT_NOAMBUSH "no_ambush"
/// Can see build blueprints
#define TRAIT_BLUEPRINT_VISION "blueprint_vision"
/// Used to limit healing to putrid flesh mobs
#define TRAIT_PUTRID "Putrid"
/// Confessed under torture, to force sign
#define TRAIT_HAS_CONFESSED "has_confessed"
/// Confessed for specific type of antag
#define TRAIT_CONFESSED_FOR	"confessed_for"
/// For torture cooldown, should be a cooldown
#define TRAIT_RECENTLY_TORTURED "recently_tortured"
/// Receives echolocation images.
#define TRAIT_ECHOLOCATION_RECEIVER "echolocation_receiver"
/// Echolocation has a higher range.
#define TRAIT_ECHOLOCATION_EXTRA_RANGE "echolocation_extra_range"
/// Can't move diagonally
#define TRAIT_BLOCKED_DIAGONAL "blocked_diagonals"
/// Can swim ignoring water flow and slowdown
#define TRAIT_GOOD_SWIM "Good Swim"
/// trait determines if this mob can breed given by /datum/component/breeding
#define TRAIT_MOB_BREEDER "mob_breeder"
/// can't be perceived in any way, likely due to invisibility
#define TRAIT_IMPERCEPTIBLE "imperceptible"
/// Reduced turf slowdown
#define TRAIT_LONGSTRIDER "longstrider"
/// Increased parry ability
#define TRAIT_GUIDANCE "guidance"
/// Dendor Path Traits
#define TRAIT_DENDOR_GROWING "trait_dendor_growing"
#define TRAIT_DENDOR_STINGING "trait_dendor_stinging"
#define TRAIT_DENDOR_DEVOURING "trait_dendor_devouring"
#define TRAIT_DENDOR_LORDING "trait_dendor_lording"
/// trait that makes you bounce when speaking
#define TRAIT_SHAKY_SPEECH "Shaky Speech"
/// Allows for offhand weapon usage
#define TRAIT_DUALWIELDER "Dual Wielder"
/// Ignores body_parts_covered during the add_fingerprint() proc. Works both on the person and the item in the glove slot.
#define TRAIT_FINGERPRINT_PASSTHROUGH "fingerprint_passthrough"
/// The mob will automatically breach the Masquerade when seen by others, with no exceptions
#define TRAIT_UNMASQUERADE "unmasquerade"
/// Makes gambling incredibly effective, and causes random beneficial events to happen for the mob.
#define TRAIT_SUPERNATURAL_LUCK	"supernatural_luck"
/// Lets the mob block projectiles like bullets using only their hands.
#define TRAIT_HANDS_BLOCK_PROJECTILES "hands_block_projectiles"
/// The mob always dodges melee attacks
#define TRAIT_ENHANCED_MELEE_DODGE "enhanced_melee_dodge"
/// The mob can easily swim and jump very far.
#define TRAIT_SUPERNATURAL_DEXTERITY "supernatural_dexterity"
/// Can pass through walls so long as it doesn't move the mob into a new area
#define TRAIT_PASS_THROUGH_WALLS "pass_through_walls"
/// Technology supernaturally refuses to work or doesn't work properly for this person
#define TRAIT_REJECTED_BY_TECHNOLOGY "rejected_by_technology"
/// Doesn't cast a reflection
#define TRAIT_NO_REFLECTION "no_reflection"
/// Vampire cannot drink from anyone who doesn't consent to it
#define TRAIT_CONSENSUAL_FEEDING_ONLY "consensual_feeding_only"
#define TRAIT_COVEN_BANE "coven_bane"
/// Instead of knocking someone out when fed on, this vampire's Kiss inflicts pain
#define TRAIT_PAINFUL_VAMPIRE_KISS "painful_vampire_kiss"
/// Vampires will always diablerise this vampire given the chance
#define TRAIT_IRRESISTIBLE_VITAE "irresistible_vitae"
/// Vampire cannot feed from poor people
#define TRAIT_FEEDING_RESTRICTION "feeding_restriction"
/// Will always fail to resist supernatural mind-influencing powers
#define TRAIT_CANNOT_RESIST_MIND_CONTROL "cannot_resist_mind_control"
/// Is hurt by holiness/holy symbols and repelled by them
#define TRAIT_REPELLED_BY_HOLINESS "repelled_by_holiness"
/// Any changes in this Kindred's Humanity will be doubled
#define TRAIT_SENSITIVE_HUMANITY "sensitive_humanity"
/// Duration of frenzy is doubled
#define TRAIT_LONGER_FRENZY "longer_frenzy"
/// This mob is phased out of reality from magic, either a jaunt or rod form
#define TRAIT_MAGICALLY_PHASED "magically_phased"
/// Mob has lost control to their rage, their Beast, whatever and is frenzying
#define TRAIT_IN_FRENZY "in_frenzy"
#define TRAIT_MOVEMENT_BLOCKED "movement_blocked"
/// Incapable of losing control and entering frenzy
#define TRAIT_IMMUNE_TO_FRENZY "immune_to_frenzy"
#define TRAIT_COVEN_RESISTANT "coven_resistance"
/// Target can't be grabbed by tanglers
#define TRAIT_ENTANGLER_IMMUNE "tangler_immune"
/// This mob is antimagic, and immune to spells / cannot cast spells
#define TRAIT_ANTIMAGIC "anti_magic"
/// This allows a person who has antimagic to cast spells without getting blocked
#define TRAIT_ANTIMAGIC_NO_SELFBLOCK "anti_magic_no_selfblock"
/// makes your footsteps completely silent
#define TRAIT_SILENT_FOOTSTEPS "silent_footsteps"
/// Hides the SSD indicator. Used with scrying.
#define TRAIT_NOSSDINDICATOR "nossdindicator"
/// Instant grabs on someone else.
#define TRAIT_NOSTRUGGLE "nostruggle"
/// Black-bagged. More snowflaking.
#define TRAIT_BAGGED "bagged"
/// Pain Tolerance. Through faith, ENDURE.
#define TRAIT_PSYDONIAN_GRIT "Psydonian Grit"
/// Anti-Miracles on a selective basis, anastasis / cure rot still apply. Slow passive wound healing while you have blood.
#define TRAIT_PSYDONITE "Psydonite's Devotion"
/// Capable of using Garrotes and Blackbags. Apprehension techniques.
#define TRAIT_BLACKBAGGER "Apprehension Techniques"
#define TRAIT_WOUNDREGEN "Wound Regeneration"
#define TRAIT_ABOMINATION "Abomination"
#define TRAIT_EVASIVE "Evasive"
#define TRAIT_WEBWALK "Webwalker"
#define TRAIT_BRUSHWALK	"Brushwalker"
#define TRAIT_DEADNOSE "Dead Nose"
#define TRAIT_STINKY "Natural Stench"
#define TRAIT_ZJUMP "High Jumping"
#define TRAIT_JESTERPHOBIA "Jesterphobic"
#define TRAIT_XENOPHOBIC "Xenophobic"
#define TRAIT_TOLERANT "Tolerant"
#define TRAIT_NOSEGRAB "Intimidating"
#define TRAIT_NUTCRACKER "Nutcracker"
#define TRAIT_STRONGBITE "Strong Bite"
#define TRAIT_HATEWOMEN	"Ladykiller"
#define TRAIT_SEEDKNOW "Seed Knower"
#define TRAIT_NOBLE	"Noble Blooded"
#define TRAIT_EMPATH "Empath"
#define TRAIT_BREADY "Battleready"
#define TRAIT_BLINDFIGHTING "Sixth-Sense"
#define TRAIT_HEARING_SENSITIVE "hearing_sensitive"
#define TRAIT_MEDIUMARMOR "Mail Training"
#define TRAIT_HEAVYARMOR "Plate Training"
#define TRAIT_DODGEEXPERT "Fast Reflexes"
#define TRAIT_UNDODGING	"Inflexible"
#define TRAIT_UNPARRYING "Graceless"
#define TRAIT_DECEIVING_MEEKNESS "Deceiving Meekness"
#define TRAIT_VILLAIN "Villain"
#define TRAIT_CRITICAL_RESISTANCE "Critical Resistance"
#define TRAIT_CRITICAL_WEAKNESS	"Critical Weakness"
#define TRAIT_MANIAC_AWOKEN	"Awoken"
/// Doesn't consume stamina
#define TRAIT_NOSTAMINA	"Indefatigable"
/// Can't fall asleep
#define TRAIT_NOSLEEP "Fatal Insomnia"
#define TRAIT_FASTSLEEP "Fast Sleeper"
#define TRAIT_NUDIST "Nudist" //you can't wear most clothes
#define TRAIT_INHUMANE_ANATOMY "Inhumen Anatomy" //can't wear hats and shoes
#define TRAIT_NASTY_EATER "Inhumen Digestion" //can eat rotten food, organs, poison berries, and drink murky water
#define TRAIT_NOFALLDAMAGE1 "Minor Fall Damage Immunity"
#define TRAIT_NOFALLDAMAGE2 "Total	 Fall Damage Immunity"
#define TRAIT_DEATHSIGHT "Veiled Whispers" // Is notified when a player character dies, but not told exactly where or how.
#define TRAIT_CYCLOPS_LEFT "Cyclops (Left)" //poked left eye
#define TRAIT_CYCLOPS_RIGHT	"Cyclops (Right)" //poked right eye
#define TRAIT_ASSASSIN	"Assassin Training" //used for the assassin drifter's unique mechanics.
#define TRAIT_BARDIC_TRAINING "Bardic Training"
#define TRAIT_GRAVEROBBER "Graverobber"	// Prevents getting the cursed debuff when unearthing a grave, but permanent -1 LUC to whoever has it.
#define TRAIT_BLESSED "Once Blessed"	// prevents blessings stackings
#define TRAIT_MIRACULOUS_FORAGING "Miracle Foraging"	// makes bushes much more generous
#define TRAIT_MISSING_NOSE "Missing Nose" //halved stamina regeneration
#define TRAIT_DISFIGURED "Disfigured"
#define TRAIT_SPELLBLOCK "Bewitched" //prevents spellcasting
#define TRAIT_ANTISCRYING "Anti-Scrying"
#define TRAIT_SHOCKIMMUNE "Shock Immunity"
#define TRAIT_LEGENDARY_ALCHEMIST "Expert Herb Finder"
#define TRAIT_LIGHT_STEP "Light Step" //Can't trigger /obj/structure/trap/'s
#define TRAIT_THIEVESGUILD "Thieves' Guild Member"
#define TRAIT_ENGINEERING_GOGGLES "Engineering Goggles"
#define TRAIT_SEEPRICES "Golden Blood" //See prices
#define TRAIT_SEE_LEYLINES "Magical Visions"
#define TRAIT_POISONBITE "Poison Bite"
#define TRAIT_FORAGER "Expert Forager"
#define TRAIT_TINY "Tiny"
#define TRAIT_DREAM_WATCHER	"Noc Blessed" //Unique Trait of the Dream Watcher Town Elder Class, they have a chance to know about antags or gods influences.
#define TRAIT_HOLLOWBONES "Hollow Bones"
#define TRAIT_AMAZING_BACK "Light Load"
#define TRAIT_KITTEN_MOM "Loved By Kittens"
#define TRAIT_WATER_BREATHING "Waterbreathing"
#define TRAIT_MOONWATER_ELIXIR "Moonwater Elixir"
#define TRAIT_FLOWERFIELD_IMMUNITY "Flower Strider"
#define TRAIT_SECRET_OFFICIANT "Secret Officiant"
#define TRAIT_RECOGNIZE_ADDICTS	"Addict Recognition"
#define TRAIT_NOENERGY "Boundless Energy" //Specifically, You don't lose fatigue, but you do continue losing stamina.
#define TRAIT_KEENEARS "Keen Ears"
#define TRAIT_POISON_RESILIENCE "Poison Resilience"
#define TRAIT_SEED_FINDER "Seed Finder"
/// Cannot count coins
#define TRAIT_COIN_ILLITERATE "Barterer"
/// Chance for extra items when cooking
#define TRAIT_LUCKY_COOK "Lucky Cook"
#define TRAIT_BASHDOORS "bashdoors"
#define TRAIT_NOMOOD "no_mood"
#define TRAIT_BAD_MOOD "Bad Mood"
#define TRAIT_NIGHT_OWL "Night Owl"
#define TRAIT_SIMPLE_WOUNDS "simple_wounds"
#define TRAIT_SCHIZO_AMBIENCE "schizo_ambience" //replaces all ambience with creepy shit
#define TRAIT_SCREENSHAKE "screenshake" //screen will always be shaking, you cannot stop it
#define TRAIT_PUNISHMENT_CURSE "PunishmentCurse"
#define TRAIT_BANDITCAMP "banditcamp"
#define TRAIT_KNOWBANDITS "knowbandits"
#define TRAIT_VAMPMANSION "vampiremansion"
#define TRAIT_VAMP_DREAMS "vamp_dreams"
#define TRAIT_INHUMENCAMP "inhumencamp"
#define TRAIT_INTRAINING "intraining" //allows certain roles to bypass the average skill limitation of training dummies
#define TRAIT_STEELHEARTED "steelhearted" //no bad mood from dismembering or seeing this
#define TRAIT_IWASREVIVED "iwasrevived" //prevents PQ gain from reviving the same person twice
#define TRAIT_IWASUNZOMBIFIED "iwasunzombified" //prevents PQ gain from curing a zombie twice
#define TRAIT_ZIZOID_HUNTED "zizoidhunted" // Used to signal character has been marked by death by the Zizoid cult
#define TRAIT_LEPROSY "Leprosy"
#define TRAIT_NUDE_SLEEPER "Nude Sleeper"
#define TRAIT_BEAUTIFUL "Beautiful"
#define TRAIT_UGLY "Ugly"
#define TRAIT_FISHFACE "Fishface"
#define TRAIT_FAT "Obese"
#define TRAIT_SCHIZO_FLAW "Schizophrenic"
#define TRAIT_VIOLATOR "Violator of the Coven"
#define TRAIT_TORPOR "Endless Slumber"
#define TRAIT_SATE "SATE"
#define TRAIT_NODE_EXTRACTED "Humors Extracted"
#define TRAIT_NO_EXPERIENCE	"unlearning"
/// This mob should never close UI even if it doesn't have a client
#define TRAIT_PRESERVE_UI_WITHOUT_CLIENT "preserve_ui_without_client"

/// applied to orphans
#define TRAIT_ORPHAN "Orphan"
#define TRAIT_RECRUITED	"Recruit" //Trait used to give foreigners their new title
#define TRAIT_RECOGNIZED "Recognized" // Given to famous migrants, pilgrims and adventurers, enable their title.
#define TRAIT_FANATICAL "Fanatical" //Trait used for fanatical mobs who can bypass the excommunication(not the curses though.)

// Divine patron trait bonuses:
#define TRAIT_SOUL_EXAMINE "Blessing of Necra"  //can check bodies to see if they have departed
#define TRAIT_ROT_EATER "Blessing of Pestra" //can eat rotten food
#define TRAIT_KNEESTINGER_IMMUNITY "Blessing of Dendor" //Can move through kneestingers.
#define TRAIT_LEECHIMMUNE "Unleechable" //leeches drain very little blood
#define TRAIT_SHARPER_BLADES "Sharper Blades" //Weapons lose less blade integrity
#define TRAIT_BETTER_SLEEP "Better Sleep" //Recover more energy (blue bar) when sleeping
#define TRAIT_EXTEROCEPTION	"Exteroception" //See others' hunger and thirst
#define TRAIT_TUTELAGE "Tutelage" //Slightly more sleep xp to you and xp to apprentices
#define TRAIT_APRICITY "Apricity" //Decreased stamina regen time during "day"
#define TRAIT_BLACKLEG "Blackleg" //Rig coin, dice, cards in your favor
#define TRAIT_INQUISITION "Member of the Oratorium Throni Vacui"
#define TRAIT_PURITAN "Puritan"
#define TRAIT_SILVER_BLESSED "Silver Blessed"

// Inhumen patron trait bonuses
#define TRAIT_ORGAN_EATER "Blessing of Graggar"//Can eat organs (duh.) and raw meat
#define TRAIT_CRACKHEAD	"Blessing of Baotha" //No overdose on drugs.
#define TRAIT_CABAL "Of the Cabal" //Zizo cultists recognize each other too
#define TRAIT_MATTHIOS_EYES	"Eyes of Matthios" //Examine to see the most expensive item someone has

// PATRON CURSE TRAITS
#define TRAIT_CURSE "Curse" //source
#define TRAIT_ATHEISM_CURSE "Curse of Atheism"
#define TRAIT_PSYDON_CURSE "Psydon's Curse"
#define TRAIT_ASTRATA_CURSE "Astrata's Curse"
#define TRAIT_NOC_CURSE "Noc's Curse"
#define TRAIT_RAVOX_CURSE "Ravox's Curse"
#define TRAIT_NECRA_CURSE "Necra's Curse"
#define TRAIT_XYLIX_CURSE "Xylix's Curse"
#define TRAIT_PESTRA_CURSE "Pestra's Curse"
#define TRAIT_EORA_CURSE "Eora's Curse"
#define TRAIT_ZIZO_CURSE "Zizo's Curse"
#define TRAIT_GRAGGAR_CURSE "Graggar's Curse"
#define TRAIT_MATTHIOS_CURSE "Matthios' Curse"
#define TRAIT_BAOTHA_CURSE "Baotha's Curse"

// HIDDEN DOOR TRAITS
#define TRAIT_KNOW_KEEP_DOORS "know_keep_doors"
#define TRAIT_KNOW_INQUISITION_DOORS "know_inquisition_doors"
#define TRAIT_KNOW_THIEF_DOORS "know_thief_doors"

// JOB RELATED TRAITS
#define TRAIT_MALUMFIRE "Professional Smith"
#define TRAIT_CRATEMOVER "Crate Mover"
#define TRAIT_BURDEN "Burdened" //Gaffer stuff
#define TRAIT_OLDPARTY "Old Party"
#define TRAIT_EARGRAB "Ear Grab"
#define TRAIT_FACELESS "Faceless One"
#define TRAIT_ROYALSERVANT "Household Insight" // Let's you see the royals liked/hated food/drink

// ************* obj traits

/// this object has been frozen
#define TRAIT_FROZEN "frozen"

// **** bodypart traits
/// Used for limb-based paralysis and full body paralysis
#define TRAIT_PARALYSIS	"paralysis"
/// The limb is more susceptible to fractures
#define TRAIT_BRITTLE "brittle"
/// The limb has no fingies
#define TRAIT_FINGERLESS "fingerless"

// **** item traits
/// Can't drop
#define TRAIT_NODROP "nodrop"
/// Can't be embedded
#define TRAIT_NOEMBED "noembed"
/// Can't be teleported
#define TRAIT_NO_TELEPORT "no-teleport" //you just can't
#define TRAIT_NEEDS_QUENCH "Needs Quenching"
/// Properly wielded two handed item
#define TRAIT_WIELDED "wielded"
/// The items needs two hands to be carried
#define TRAIT_NEEDS_TWO_HANDS "needstwohands"
/// This item can't be pickpocketed
#define TRAIT_HARD_TO_STEAL "hard_to_steal"

// ************* turf traits
/// Turf trait for when a turf is transparent
#define TRAIT_Z_TRANSPARENT "turf_z_transparent"

// ************* Debug traits
/// This object has sound debugging tools attached to it
#define TRAIT_SOUND_DEBUGGED "sound_debugged"

