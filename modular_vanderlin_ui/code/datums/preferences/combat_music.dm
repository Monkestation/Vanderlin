/// Combat music selectable in character setup (antag tracks are excluded).
/// Generated from sound/music/cmode - add new tracks here by hand.
GLOBAL_LIST_INIT(cmode_music_choices, list(
    "adventurer/combat_vaquero" = 'sound/music/cmode/adventurer/combat_vaquero.ogg',
    "adventurer/CombatDream" = 'sound/music/cmode/adventurer/CombatDream.ogg',
    "adventurer/CombatIntense" = 'sound/music/cmode/adventurer/CombatIntense.ogg',
    "adventurer/CombatMonk" = 'sound/music/cmode/adventurer/CombatMonk.ogg',
    "adventurer/CombatOutlander" = 'sound/music/cmode/adventurer/CombatOutlander.ogg',
    "adventurer/CombatOutlander2" = 'sound/music/cmode/adventurer/CombatOutlander2.ogg',
    "adventurer/CombatOutlander3" = 'sound/music/cmode/adventurer/CombatOutlander3.ogg',
    "adventurer/CombatOutlander4" = 'sound/music/cmode/adventurer/CombatOutlander4.ogg',
    "adventurer/CombatRogue" = 'sound/music/cmode/adventurer/CombatRogue.ogg',
    "adventurer/CombatSorcerer" = 'sound/music/cmode/adventurer/CombatSorcerer.ogg',
    "adventurer/CombatWarrior" = 'sound/music/cmode/adventurer/CombatWarrior.ogg',
    "church/CombatAbyssor" = 'sound/music/cmode/church/CombatAbyssor.ogg',
    "church/CombatAstrata" = 'sound/music/cmode/church/CombatAstrata.ogg',
    "church/CombatDendor" = 'sound/music/cmode/church/CombatDendor.ogg',
    "church/CombatEora" = 'sound/music/cmode/church/CombatEora.ogg',
    "church/CombatGravekeeper" = 'sound/music/cmode/church/CombatGravekeeper.ogg',
    "church/CombatInquisitor" = 'sound/music/cmode/church/CombatInquisitor.ogg',
    "church/CombatInquisitor2" = 'sound/music/cmode/church/CombatInquisitor2.ogg',
    "church/CombatMartyrUlt" = 'sound/music/cmode/church/CombatMartyrUlt.ogg',
    "church/CombatNoc" = 'sound/music/cmode/church/CombatNoc.ogg',
    "church/CombatRavox" = 'sound/music/cmode/church/CombatRavox.ogg',
    "church/CombatXylix" = 'sound/music/cmode/church/CombatXylix.ogg',
    "combat" = 'sound/music/cmode/combat.ogg',
    "combat_delf" = 'sound/music/cmode/combat_delf.ogg',
    "combat_dwarf" = 'sound/music/cmode/combat_dwarf.ogg',
    "combat_grenzelhoft" = 'sound/music/cmode/combat_grenzelhoft.ogg',
    "combat_weird" = 'sound/music/cmode/combat_weird.ogg',
    "garrison/CombatForestGarrison" = 'sound/music/cmode/garrison/CombatForestGarrison.ogg',
    "garrison/CombatForestGarrison2" = 'sound/music/cmode/garrison/CombatForestGarrison2.ogg',
    "garrison/CombatGarrison" = 'sound/music/cmode/garrison/CombatGarrison.ogg',
    "garrison/CombatGatekeeper" = 'sound/music/cmode/garrison/CombatGatekeeper.ogg',
    "garrison/CombatManAtArms" = 'sound/music/cmode/garrison/CombatManAtArms.ogg',
    "nobility/combat_noble" = 'sound/music/cmode/nobility/combat_noble.ogg',
    "nobility/combat_physician" = 'sound/music/cmode/nobility/combat_physician.ogg',
    "nobility/CombatCourtMagician" = 'sound/music/cmode/nobility/CombatCourtMagician.ogg',
    "nobility/CombatDungeoneer" = 'sound/music/cmode/nobility/CombatDungeoneer.ogg',
    "nobility/CombatJester1" = 'sound/music/cmode/nobility/CombatJester1.ogg',
    "nobility/CombatJester2" = 'sound/music/cmode/nobility/CombatJester2.ogg',
    "nobility/CombatJesterSTR" = 'sound/music/cmode/nobility/CombatJesterSTR.ogg',
    "nobility/CombatKnight" = 'sound/music/cmode/nobility/CombatKnight.ogg',
    "nobility/CombatSpymaster" = 'sound/music/cmode/nobility/CombatSpymaster.ogg',
    "towner/CombatBeggar" = 'sound/music/cmode/towner/CombatBeggar.ogg',
    "towner/CombatElder" = 'sound/music/cmode/towner/CombatElder.ogg',
    "towner/CombatGaffer" = 'sound/music/cmode/towner/CombatGaffer.ogg',
    "towner/CombatInn" = 'sound/music/cmode/towner/CombatInn.ogg',
    "towner/CombatMayor" = 'sound/music/cmode/towner/CombatMayor.ogg',
    "towner/CombatPrisoner" = 'sound/music/cmode/towner/CombatPrisoner.ogg',
    "towner/CombatTowner" = 'sound/music/cmode/towner/CombatTowner.ogg',
    "towner/CombatTowner2" = 'sound/music/cmode/towner/CombatTowner2.ogg',
    "towner/CombatVeteran" = 'sound/music/cmode/towner/CombatVeteran.ogg'
))

/datum/preference/choiced/combat_music
    savefile_key = "combat_music"
    savefile_identifier = PREF_CHARACTER
    category = "character"
    can_randomize = FALSE

/datum/preference/choiced/combat_music/init_possible_values(datum/preferences/prefs)
    var/list/out = list("default")
    for(var/key in GLOB.cmode_music_choices)
        out += key
    return out

/datum/preference/choiced/combat_music/create_default_value(datum/preferences/prefs)
    return "default"

/datum/preference/choiced/combat_music/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
    // null for "default" (not in the list) - the class music is used then.
    H.preferred_cmode_music = GLOB.cmode_music_choices[value]

/datum/preference/choiced/combat_music/handle_link(datum/preferences/prefs, mob/user)
    var/list/options = list("default")
    for(var/key in GLOB.cmode_music_choices)
        options += key
    var/current = prefs.read_preference(/datum/preference/choiced/combat_music)
    var/choice = browser_input_list(user, "CHOOSE YOUR HERO'S COMBAT MUSIC", "BATTLE HYMNS", options, current)
    if(!choice)
        return
    prefs.write_preference(/datum/preference/choiced/combat_music, choice)
    if(choice == "default")
        to_chat(user, span_notice("Combat music: determined by your class."))
        return
    to_chat(user, span_notice("Combat music: [choice]. It overrides your class music."))
    var/track = GLOB.cmode_music_choices[choice]
    if(track)
        SEND_SOUND(user, sound(track, volume = 50))